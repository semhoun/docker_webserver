FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=linux

# Bullseye security packages have moved to the Debian archive.
RUN sed -i 's|http://deb.debian.org/debian-security|http://archive.debian.org/debian-security|g' /etc/apt/sources.list \
  && apt-get update -y \
  && apt-get install -y --no-install-recommends curl ca-certificates vim bash dos2unix wget git unzip \
  && apt-get install -y apt-transport-https lsb-release ca-certificates \
  && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
  && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
  && apt-get update \
  \
  && apt-get install -y supervisor \
  \
  && apt-get install -y --no-install-recommends \
    apache2 apache2-utils \
    imagemagick graphicsmagick exiftran \
    locales aspell-fr \
    php7.4-fpm php7.4 php7.4-cli php7.4-common php7.4-curl php7.4-gd php7.4-imap php7.4-mysql php7.4-pspell php7.4-snmp \
    php7.4-sqlite3 php7.4-xsl php7.4-intl php7.4-mbstring php7.4-zip php7.4-bcmath php7.4-xml php7.4-imagick php7.4-redis php7.4-memcache \
    php7.4-dev php7.4-apcu php7.4-gmp \
  && ln -s /usr/sbin/php-fpm7.4 /usr/sbin/php-fpm \
  \
  \
# Configure www user  
  && usermod www-data -s /bin/bash \
  \
  \
# Add libgeos
  && apt-get install -y --no-install-recommends libgeos-dev autoconf automake libtool make g++ \
  && git clone https://github.com/ModelTech/php-geos.git \
  && ( \
    cd php-geos \
    && ./autogen.sh \
    && ./configure --with-php-config=/usr/bin/php-config7.4 \
    && make \
    && make install \
  ) \
  && rm -r php-geos \
  \
  \
# Configure locales
  && sed \
    -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' \
    -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' \
    -i /etc/locale.gen \
  && /usr/sbin/locale-gen \
  \
  \
# Install composer
  && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
  && php composer-setup.php --2.2 \
  && mv composer.phar /usr/bin/composer \
  && rm composer-setup.php \
  \
  \
# Configure Apache
  && a2enmod proxy_fcgi rewrite deflate alias actions headers \
  && a2disconf other-vhosts-access-log.conf \
  \
  \
# Clean
  && apt-get -y purge php7.4-dev \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Managing root fs
COPY rootfs/ /
RUN chown -R www-data:www-data /www \
	&& chmod +x /opt/bin/*

# Encoding fix
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

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
