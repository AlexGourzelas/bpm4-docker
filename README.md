# bpm4-docker
 ProcessMaker BPM4 Docker Implementation based on [kytoonlabs/bpm4-base](https://github.com/kytoonlabs/bpm4-base.git) 

This is project is only a way to prepare and test ProcessMaker 4.0 using docker env, this is not intented to setup a developer instance.

# Getting Started
In order to start up and running processmaker you should have docker installed on your machine. After that follow the next steps:
```bash
git clone https:\\github.com\enriquecolosa\bmp4-docker.git
cd bpm4-docker
docker-compose up --build
```
After everything is built and docker containers started, you should go to https://locahost:8400 in order to start working with processmaker 4.0, default user/passwords is set to admin/admin.

Enjoy!

# Docker Image Generation
Please follow the next steps to build a new docker image

``` bash
docker build -t bpm4-docker .
```
After runing this you will have a docker image containing a bpm4 web server. Please use the following command to run it. Notice that this image does not contain mysql or redis servers so you should have those running externally.
``` bash
docker run --name bpm4 -p 8400:443 -p 6001:6001 --link my-mysql:db --link my-redis:redis -d bpm4-docker 
```
If you need some way more simpler you use a docker-compose.yaml file:
``` yaml
version: '3'
services:
  processmaker:
    build: .
    ports: 
      - 8400:443
      - 6001:6001
    privileged: true
    depends_on:
      - db
      - redis
  redis:
    image: redis
    restart: always
  db:
    image: mysql:5.7
    restart: always
    ports: 
      - 33060:3306
    environment:
      MYSQL_ROOT_PASSWORD: example
      MYSQL_DATABASE: 'bpm4'
```
Notice that processmaker container must run as *privileged* because internally is running a docker instance itself.
# Docker Compose Useful Commands
``` bash
# stop all containers
docker-compose stop 

# remove all containers
docker-compose rm

# ssh processmaker container
docker-compose exec processmaker sh
```
