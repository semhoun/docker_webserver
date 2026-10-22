FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive
ENV TERM=linux

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    curl ca-certificates vim bash dos2unix wget git unzip \
  && mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://packages.sury.org/php/apt.gpg -o /etc/apt/keyrings/php.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/php.gpg] https://packages.sury.org/php/ bookworm main" > /etc/apt/sources.list.d/php.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    supervisor apache2 apache2-utils \
    imagemagick graphicsmagick exiftran locales aspell-fr \
    php5.6-fpm php5.6-cli php5.6-common php5.6-curl php5.6-gd php5.6-imap php5.6-mysql php5.6-pspell php5.6-snmp \
    php5.6-sqlite3 php5.6-xsl php5.6-intl php5.6-mbstring php5.6-zip php5.6-bcmath php5.6-xml php5.6-imagick php5.6-redis php5.6-memcache \
    php5.6-apcu php5.6-gmp php5.6-soap \
  && update-alternatives --set php /usr/bin/php5.6 \
  && ln -s /usr/sbin/php-fpm5.6 /usr/sbin/php-fpm \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Install Composer 1 for the existing PHP 5.6 environment.
RUN curl -fsSL https://getcomposer.org/installer -o /tmp/composer-setup.php \
  && curl -fsSL https://composer.github.io/installer.sig -o /tmp/composer-setup.sig \
  && php -r "if (trim(file_get_contents('/tmp/composer-setup.sig')) !== hash_file('sha384', '/tmp/composer-setup.php')) { exit(1); }" \
  && php /tmp/composer-setup.php --1 --install-dir=/usr/bin --filename=composer \
  && rm /tmp/composer-setup.php /tmp/composer-setup.sig

RUN usermod -s /bin/bash www-data \
  && sed \
    -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' \
    -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' \
    -i /etc/locale.gen \
  && locale-gen \
  && a2enmod proxy_fcgi rewrite deflate alias actions headers \
  && a2disconf other-vhosts-access-log

COPY rootfs/ /
RUN chown -R www-data:www-data /www \
  && chmod +x /opt/bin/*

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

ENV SERVER_NAME="www.docker.test" \
    SERVER_ADMIN="webmaster@docker.test" \
    DEBUG_MODE="false"

WORKDIR /www
VOLUME ["/www"]
EXPOSE 80

ENTRYPOINT ["/opt/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
HEALTHCHECK --start-period=60s --interval=15s --timeout=5s --retries=3 CMD curl --fail http://localhost/.well-known/health || exit 1
