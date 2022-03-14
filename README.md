# Semhoun's Webserver

[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)  ![Docker Size](https://img.shields.io/docker/image-size/semhoun/webserver)  ![Docker Pull](https://img.shields.io/docker/pulls/semhoun/webserver)

Apache / PHP-FPM in one docker.

Used in E-Dune infra.

## Getting Started

### Prerequisities


In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

### Usage

#### Docker

```shell
docker run -v ./www:/www semhoun/webserver
```
#### Docker Compose
```yaml
version: "3.2"

services:
  webserver:
    container_name: webserver
    image: semhoun/webserver
    environment:
      - SERVER_NAME="www.docker.test"
      - SERVER_ADMIN="webmaster@docker.test"
    volumes:
      - ./www/:/www/
    ports:
      - 8080:80
```

#### Environment Variables

* `SERVER_NAME` - Website url (ie: www.docker.test)
* `SERVER_ADMIN` - Apache webmaster mail (ie: webmaster@docker.test)
* `DEBUG_MODE` - Debug mode (display php errors)

#### Volumes

* `/www` - Website location (www/public would be detected as root directory)

#### Useful File Locations

* `/etc/apache2/conf-docker/` - Specific confs for docker
  
* `/etc/apache2/conf-docker/20-htdocs.conf` - htdocs configuration (ex: /www/public)
* `/etc/apache2/conf-docker/30-healthcheck.conf` - Health check alias configuration
* `http://localhost/.well-known/healthcheck` - Health check url

## Built With

* Debian bullseye
* Apache
* PHP 7.4.1
* Supervisor

## Find Us

* [GitLab](https://gitlab.com/semhoun/docker_webserver)
* [DockerHub](https://hub.docker.com/repository/docker/semhoun/webserver)

## Authors

* **Nathanaël Semhoun** -  [semhoun](https://gitlab.com/semhoun)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
