# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [8.4.2] - 2025-01-XX

### Changed
- Improved Docker image build process
- Updated base dependencies

## [8.4.1] - 2025-01-XX

### Fixed
- Minor configuration fixes

## [8.4.0] - 2025-01-XX

### Changed
- Migrated base image from Debian Bullseye to Trixie
- Upgraded from PHP 8.2 to PHP 8.4

### Added
- OpenTelemetry support for distributed tracing
- Enhanced PHP extensions

## [8.2.4] - 2024-XX-XX

### Changed
- Updated base dependencies
- Security patches

## [8.2.3] - 2024-XX-XX

### Fixed
- Session cleanup script improvements

## [8.2.2] - 2024-XX-XX

### Changed
- Updated PHP configuration

## [8.2.1] - 2024-XX-XX

### Added
- Node.js 22 support

## [8.2.0] - 2024-XX-XX

### Changed
- Migrated from PHP 8.1 to PHP 8.2
- Updated to Debian Bookworm

## [8.1.4] - 2024-XX-XX

### Fixed
- Various bug fixes

## [8.1.3] - 2023-XX-XX

### Changed
- Dependency updates

## [8.1.2] - 2023-XX-XX

### Added
- Additional PHP extensions

## [8.0.6] - 2023-XX-XX

### Security
- Security patches applied

## [8.0.5] - 2023-XX-XX

### Fixed
- Configuration fixes

## [8.0.4] - 2023-XX-XX

### Changed
- Base image updates

## [8.0.3] - 2023-XX-XX

### Added
- LDAP and PostgreSQL PHP modules

## [8.0.2] - 2023-XX-XX

### Fixed
- Various improvements

## [8.0.1] - 2023-XX-XX

### Added
- Git directory blocking by default (security)

## [7.4.5] - 2022-XX-XX

### Changed
- Apache/PHP-FPM improvements

## [7.4.4] - 2022-XX-XX

### Fixed
- Bug fixes

## [7.4.2] - 2022-XX-XX

### Added
- Grunt support
- NPM upgrade

## [7.4.0] - 2022-XX-XX

### Changed
- Major refactoring

## [7.3.1] - 2021-XX-XX

### Fixed
- Minor fixes

## [7.3.0] - 2021-XX-XX

### Added
- New features

## [7.1.1] - 2020-XX-XX

### Fixed
- Bug fixes

## [7.1.0] - 2020-XX-XX

### Changed
- Initial stable release

## [5.6.3] - 2019-XX-XX

### Changed
- Legacy PHP 5.6 support

## Migration Notes

### Migrating from Apache/PHP-FPM to FrankenPHP (v8.4.0+)

The webserver has been completely re-architected:

- **Before**: Apache + PHP-FPM + Supervisor
- **After**: FrankenPHP (Caddy + PHP)

**Key changes:**
- Document root auto-detection (`/www` or `/www/public`)
- Caddyfile-based configuration instead of Apache vhosts
- Environment variables for HTTPS/Let's Encrypt
- Built-in HTTP/2 and HTTP/3 support
- OpenTelemetry integration

**Breaking changes:**
- Apache-specific configuration files no longer apply
- `.htaccess` files are NOT supported (use Caddy configuration instead)
- Different log format

[8.4.2]: https://gitlab.com/semhoun/docker_webserver/-/tags/8.4.2
[8.4.1]: https://gitlab.com/semhoun/docker_webserver/-/tags/8.4.1
[8.4.0]: https://gitlab.com/semhoun/docker_webserver/-/tags/8.4.0
[8.2.4]: https://gitlab.com/semhoun/docker_webserver/-/tags/8.2.4
[8.2.3]: https://gitlab.com/semhoun/docker_webserver/-/tags/8.2.3
[8.2.2]: https://gitlab.com/semhoun/docker_webserver/-/tags/8.2.2
[8.2.1]: https://gitlab.com/semhoun/docker_webserver/-/tags/8.2.1
[8.2.0]: https://gitlab.com/semhoun/docker_webserver/-/tags/8.2.0
[8.1.4]: https://gitlab.com/semhoun/docker_webserver/-/tags/8.1.4
[8.1.3]: https://gitlab.com/semhoun/docker_webserver/-/tags/8.1.3
[8.1.2]: https://gitlab.com/semhoun/docker_webserver/-/tags/8.1.2
[8.0.6]: https://gitlab.com/semhoun/docker_webserver/-/tags/8.0.6
[8.0.5]: https://gitlab.com/semhoun/docker_webserver/-/tags/8.0.5
[8.0.4]: https://gitlab.com/semhoun/docker_webserver/-/tags/8.0.4
[8.0.3]: https://gitlab.com/semhoun/docker_webserver/-/tags/8.0.3
[8.0.2]: https://gitlab.com/semhoun/docker_webserver/-/tags/8.0.2
[8.0.1]: https://gitlab.com/semhoun/docker_webserver/-/tags/8.0.1
[7.4.5]: https://gitlab.com/semhoun/docker_webserver/-/tags/7.4.5
[7.4.4]: https://gitlab.com/semhoun/docker_webserver/-/tags/7.4.4
[7.4.2]: https://gitlab.com/semhoun/docker_webserver/-/tags/7.4.2
[7.4.0]: https://gitlab.com/semhoun/docker_webserver/-/tags/7.4.0
[7.3.1]: https://gitlab.com/semhoun/docker_webserver/-/tags/7.3.1
[7.3.0]: https://gitlab.com/semhoun/docker_webserver/-/tags/7.3.0
[7.1.1]: https://gitlab.com/semhoun/docker_webserver/-/tags/7.1.1
[7.1.0]: https://gitlab.com/semhoun/docker_webserver/-/tags/7.1.0
[5.6.3]: https://gitlab.com/semhoun/docker_webserver/-/tags/5.6.3
