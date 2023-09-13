FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=linux

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends curl ca-certificates vim bash dos2unix wget curl git unzip gpg \
  && apt-get install -y apt-transport-https lsb-release ca-certificates \
  && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
  && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
  && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
  && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" > /etc/apt/sources.list.d/nodesource.list \
  && apt-get update \
  \
  && apt-get install -y supervisor \
  \
  && apt-get install -y nodejs \
  \
  && apt-get install -y \
    apache2 apache2-utils \
    imagemagick graphicsmagick exiftran \
    locales aspell-fr \
    php8.2-fpm php8.2 php8.2-cli php8.2-common php8.2-curl php8.2-gd php8.2-imap php8.2-mysql php8.2-pspell php8.2-snmp \
    php8.2-sqlite3 php8.2-xsl php8.2-intl php8.2-mbstring php8.2-zip php8.2-bcmath php8.2-xml php8.2-imagick php8.2-redis php8.2-memcache \
    php8.2-dev php8.2-apcu php8.2-gmp php8.2-ldap php8.2-pgsql \
  # Fix for added by debfault
  && apt-get purge -y php7* php8.0* php8.1* \
  && ln -s /usr/sbin/php-fpm8.2 /usr/sbin/php-fpm \
  \
  \
# Configure locales
  && sed \
    -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' \
    -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' \
    -i /etc/locale.gen \
  && /usr/sbin/locale-gen en_US.UTF-8 \
  \
  \
# Install composer
  && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php composer-setup.php \
  && mv composer.phar /usr/bin/composer \
  \
  \
# Install grunt
  && npm install -g grunt \
  \
  \
# Configure Apache
  && a2enmod proxy_fcgi rewrite deflate alias actions headers \
  \
  \
# Clean
  && apt-get -y purge php8.2-dev \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Managing root fs and www-data user
COPY rootfs/ /
RUN chown -R www-data:www-data /www \
  && usermod www-data -s /bin/bash -d /www \
  && chmod +x /opt/bin/*

# Encoding fix
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Default env values
ENV SERVER_NAME="www.docker.test"
ENV SERVER_ADMIN="webmaster@docker.test"
ENV DEBUG_MODE="false" 

# WWW dir
WORKDIR "/www"
VOLUME ["/www"]

#Expose port
EXPOSE 80

# Docker starting params
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
ENTRYPOINT ["/opt/bin/entrypoint.sh"]
HEALTHCHECK --start-period=60s --interval=15s --timeout=5s --retries=3 CMD curl --fail http://localhost/.well-known/health || exit 1
