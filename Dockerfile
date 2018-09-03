FROM kytoonlabs/bpm4-base:4.0.0

# Getting develop version of the bpm base code
RUN mkdir -p /opt && mkdir -p /tmp && wget https://github.com/ProcessMaker/bpm/archive/develop.zip -P /tmp && \
    unzip -x /tmp/develop.zip -q -d /opt && mv /opt/bpm-develop /opt/processmaker

# Copying server configuration files
COPY files /tmp/files
RUN rsync --recursive --verbose --backup /tmp/files/ / && rm -rf /tmp/files

# Defining working directory
WORKDIR /opt/processmaker

# Preparing PHP modules
RUN docker-php-ext-install pcntl zip pdo_mysql

# Preparing ProcessMaker project
USER nginx
RUN composer install && \
    php artisan vendor:publish --provider="Laravel\Horizon\HorizonServiceProvider" && \
    php artisan passport:keys
USER root
RUN npm i npm@latest -g && npm install && npm run dev

# Prepare required folders and preparing/removing files
RUN mkdir -p /var/log/supervisor && \
    mkdir -p /var/run/supervisor && \
    mkdir -p /usr/local/var/run/php-fpm && \
    mkdir -p /var/log/php-fpm && \
    rm /etc/nginx/conf.d/default.conf && \
    chown -R nginx:nginx /opt/processmaker

EXPOSE 80 443 6001
STOPSIGNAL SIGTERM

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
