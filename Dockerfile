FROM kytoonlabs/bpm4-base:4.0.0

# Getting develop version of the bpm base code
RUN mkdir -p /opt && mkdir -p /tmp && wget https://github.com/ProcessMaker/bpm/archive/develop.zip -P /tmp && \
    unzip -x /tmp/develop.zip -q -d /opt && mv /opt/bpm-develop /opt/processmaker

RUN apk add rsync

# Copying server configuration files
COPY files /tmp/files
RUN rsync --recursive --verbose --backup /tmp/files/ / && rm -rf /tmp/files

RUN rm /usr/local/etc/php-fpm.d/www.conf


# Defining working directory
WORKDIR /opt/processmaker



EXPOSE 80

STOPSIGNAL SIGTERM

ENTRYPOINT ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]

# CMD ["nginx", "-g", "daemon off;"]

