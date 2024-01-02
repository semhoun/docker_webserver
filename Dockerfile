FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=linux

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends curl ca-certificates vim bash dos2unix wget curl git unzip \
  && apt-get install -y apt-transport-https lsb-release ca-certificates \
  && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
  && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
	&& curl -sL https://deb.nodesource.com/setup_16.x | bash - \
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
    php8.0-fpm php8.0 php8.0-cli php8.0-common php8.0-curl php8.0-gd php8.0-imap php8.0-mysql php8.0-pspell php8.0-snmp \
    php8.0-sqlite3 php8.0-xsl php8.0-intl php8.0-mbstring php8.0-zip php8.0-bcmath php8.0-xml php8.0-imagick php8.0-redis php8.0-memcache \
    php8.0-dev php8.0-apcu php8.0-gmp \
  # Fix for added by debfault
  && apt-get purge -y php7* php8.1* \
  && ln -s /usr/sbin/php-fpm8.0 /usr/sbin/php-fpm \
  \
  \
# Configure www user  
  && usermod www-data -s /bin/bash \
  && chown -R www-data.www-data /var/www \
  \
  \
# Add libgeos
  && apt-get install -y libgeos-dev \
  && git clone https://github.com/ModelTech/php-geos.git \
  && ( \
    cd php-geos \
    && ./autogen.sh \
    && ./configure \
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
  && a2disconf other-vhosts-access-log.conf \
  \
  \
# Clean
  && apt-get -y purge php8.2-dev \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /var/log/apache2

# Managing root fs
COPY rootfs/ /
RUN chown -R www-data.www-data /www \
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
