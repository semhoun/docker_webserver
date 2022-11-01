FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=linux
WORKDIR "/tmp"

COPY opt/ /opt/

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
    php7.4-fpm php7.4 php7.4-cli php7.4-common php7.4-curl php7.4-gd php7.4-imap php7.4-mysql php7.4-pspell php7.4-snmp \
    php7.4-sqlite3 php7.4-xsl php7.4-intl php7.4-mbstring php7.4-zip php7.4-bcmath php7.4-xml php7.4-imagick php7.4-redis php7.4-memcache \
    php7.4-dev php7.4-apcu php7.4-gmp \
  # Fix for added by debfault
  && apt-get purge -y php7.1 php7.2 php7.3 php8* \
	&& cp /usr/sbin/php-fpm7.4 /usr/sbin/php-fpm \
  \
  \
# Configure www user  
	&& mkdir /www \
  && chown -R www-data.www-data /www \
  && usermod www-data -s /bin/bash \
  \
  \
# Add www user
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
  && rm /etc/apache2/apache2.conf \
	&& mkdir -p /etc/apache2/conf-docker \
  \
  \
# Configure permissions
  && chmod +x /opt/bin/* \
  \
  \
# Clean
  && apt-get -y purge php7.4-dev \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Encoding fix
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Configure Apache  
COPY conf/apache/. /etc/apache2/

# Configure PHP
COPY conf/php/* /etc/php/7.4/fpm/conf.d/
COPY conf/php/* /etc/php/7.4/cli/conf.d/
COPY conf/php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf

# WWW dir
WORKDIR "/www"
VOLUME ["/www"]

# Default env values
env SERVER_NAME="www.docker.test"
env SERVER_ADMIN="webmaster@docker.test"

# Docker starting params
CMD ["/usr/bin/supervisord","-c","/opt/conf/supervisord.conf"]
ENTRYPOINT ["/opt/bin/entrypoint.sh"]
HEALTHCHECK --start-period=60s --interval=15s --timeout=5s --retries=3 CMD curl --fail http://localhost/.well-known/health || exit 1
