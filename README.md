# Semhoun's Webserver

[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://opensource.org/licenses/MIT)
[![Docker Image Size](https://img.shields.io/docker/image-size/semhoun/webserver)](https://hub.docker.com/r/semhoun/webserver)
[![Docker Pulls](https://img.shields.io/docker/pulls/semhoun/webserver)](https://hub.docker.com/r/semhoun/webserver)

A modern, high-performance PHP webserver Docker image built on
**FrankenPHP** (Caddy + PHP-FPM).

## Features

- **FrankenPHP** - Modern PHP application server built on Caddy
- **PHP 8.4** with extensive extension support
- **Automatic HTTPS** with Let's Encrypt support
- **HTTP/2** and **HTTP/3** support
- **Brotli** and **Gzip** compression
- **OpenTelemetry** tracing support
- Production and development modes

## Quick Start

### Docker

```shell
docker run -v ./www:/www -p 8080:80 semhoun/webserver
```

### Docker Compose

```yaml
services:
  webserver:
    image: semhoun/webserver
    environment:
      SERVER_NAME: "www.example.com"
    volumes:
      - ./www/:/www/
    ports:
      - "8080:80"
```

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `SERVER_NAME` | Website domain name | `:80` |
| `DEBUG_MODE` | Enable PHP debug mode (`true`/`false`) | `false` |
| `ENABLE_LETSENCRYPT` | Enable automatic HTTPS | `false` |
| `ACME_EMAIL` | Email for Let's Encrypt registration | - |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | OpenTelemetry collector endpoint | - |
| `QUEUE_WORKERS` | Number of queue workers | `2` |

### Volumes

| Path | Description |
|------|-------------|
| `/www` | Website files (auto-detects `/www/public` as document root) |

### PHP Extensions Included

- **Core**: bcmath, bz2, curl, exif, gd, gmp, intl, mbstring, opcache, pcntl
- **Database**: pdo_mysql, pdo_pgsql, pdo_sqlite, redis
- **Security**: sodium, ldap, apcu
- **Other**: xsl, zip, imagick, memcache, opentelemetry

### Built-in Tools

- **Composer** - PHP dependency manager
- **Ember** - Real-time monitoring dashboard CLI for Caddy & FrankenPHP
- **Git** - Version control
- **Vim** - Text editor

## Architecture

This image is based on:

- Debian Trixie
- FrankenPHP (starting at php 8.4)
- Multi-stage build for optimized image size

## Branches & Tags

Multiple PHP versions are available via different branches/tags:

| PHP Version | Branch | Tags |
|-------------|--------|------|
| 8.5 | `main` | `8.5.x`, `latest` |
| 8.4 | `php-8.4` | `8.5.x` |
| 8.2 | `php-8.2` | `8.2.x` |
| 8.1 | `php-8.1` | `8.1.x` |
| 8.0 | `php-8.0` | `8.0.x` |
| 7.4 | `php-7.4` | `7.4.x` |
| 7.3 | `php-7.3` | `7.3.x` |
| 7.1 | `php-7.1` | `7.1.x` |
| 5.6 | `php-5.6` | `5.6.x` |

## Building from Source

```shell
git clone https://gitlab.com/semhoun/docker_webserver.git
cd docker_webserver
docker build -t my-webserver .
```

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Links

- **Github**: <https://github.com/semhoun/docker_webserver>
- **DockerHub**: <https://hub.docker.com/r/semhoun/webserver>

## Author

**Nathanaël Semhoun** - [@semhoun](https://gitlab.com/semhoun)
