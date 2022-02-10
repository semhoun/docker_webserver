FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=linux
WORKDIR "/tmp"

COPY patches /opt/patches/
COPY bin/ /opt/bin/
COPY service/ /service/

########################
# Daemontools
########################
RUN mkdir /package \
	&& chmod 1755 /package \
	&& apt-get update \
	&& apt-get -y install gcc make wget patch \
## fehQlibs
	&& cd /usr/local/src \
	&& wget https://www.fehcom.de/ipnet/fehQlibs/fehQlibs-19.tgz \
	&& tar xvzf fehQlibs-19.tgz \
	&& mv fehQlibs-19 qlibs  \
	&& cd qlibs \
	&& make \
## Daemontools
	&& cd /package \
	&& wget https://cr.yp.to/daemontools/daemontools-0.76.tar.gz \
	&& tar xvzf daemontools-0.76.tar.gz \
	&& cd admin \
	&& patch -p0 < /opt/patches/daemontools-0.76.errno.patch \
	&& patch -p0 < /opt/patches/daemontools-0.76-localtime.patch \
	&& cd daemontools-0.76 \
	&& package/install \
# Clean
  && apt-get -y purge gcc make wget patch \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/* /package/daemontools-0.76.tar.gz

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends curl ca-certificates vim bash dos2unix wget git unzip \
  && apt-get install -y apt-transport-https lsb-release ca-certificates \
  && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
  && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
  \
	&& curl -sL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get update \
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
	&& cp /usr/sbin/php-fpm8.0 /usr/sbin/php-fpm \
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
# Configure Apache
  && a2enmod proxy_fcgi rewrite deflate alias actions headers \
  && rm /etc/apache2/apache2.conf \
  \
  \
# Configure permissions
  && chmod +x /opt/bin/* /service/*/run \
  \
  \
# Clean
  && apt-get -y purge php8.0-dev \
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
COPY conf/php/* /etc/php/8.0/fpm/conf.d/
COPY conf/php/* /etc/php/8.0/cli/conf.d/
COPY conf/php-fpm.conf /etc/php/8.0/fpm/php-fpm.conf

WORKDIR "/www"
VOLUME ["/www"]

# Start Daemontools
CMD ["/command/svscan", "/service", "2>&1"]
ENTRYPOINT ["/opt/bin/docker-entrypoint.sh"]
