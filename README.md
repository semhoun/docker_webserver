# Docker Container Name

[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT) ![Badge Release](https://gitlab.com/semhoun/docker_webserver/-/badges/release.svg)  ![Docker Size](https://img.shields.io/docker/image-size/semhoun/webserver)  ![Docker Pull](https://img.shields.io/docker/pulls/semhoun/webserver)

Docker who run apache and php-fpm webserver.
Used in E-Dune infra.

## Getting Started

### Prerequisities


In order to run this container you'll need docker installed.

* [Windows](https://docs.docker.com/windows/started)
* [OS X](https://docs.docker.com/mac/started/)
* [Linux](https://docs.docker.com/linux/started/)

### Usage

#### Exemple

```shell
docker run -v ./www:/www semhoun/webserver
```

#### Environment Variables

* `SERVER_NAME` - Apache server name
* `SERVER_ADMIN` - Apache webmaster mail
* `DEBUG_MODE` - Debug mode (display php errors)

*Both SERVER_NAME and SERVER_ADMIN must be setted otherwise default value will be used*

#### Volumes

* `/www` - Website location (www/public would be detected as root directory)

#### Useful File Locations

* `/etc/apache2/conf-docker/` - Specific confs for docker
  
* `/etc/apache2/conf-docker/20-htdocs.conf` - htdocs configuration (ex: /www/public)

## Built With

* Debian bullseye
* Apache
* PHP 8.0
* Supervisor

## Find Us

* [GitLab](https://gitlab.com/semhoun/docker_webserver)
* [DockerHub](https://hub.docker.com/repository/docker/semhoun/webserver)

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Authors

* **Nathanaël Semhoun** -  [semhoun](https://github.com/semhoun)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
