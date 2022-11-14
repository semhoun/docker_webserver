FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=linux

RUN apt-get update -y \
  && apt-get install -y --no-install-recommends curl ca-certificates vim bash dos2unix wget curl git unzip \
  && apt-get install -y apt-transport-https lsb-release ca-certificates \
  && wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg \
  && sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list' \
  && apt-get update \
	\
  && apt-get install -y supervisor \
	\
  && apt-get install -y \
    apache2 apache2-utils \
    imagemagick graphicsmagick exiftran \
    locales aspell-fr \
    php5.6-fpm php5.6 php5.6-cli php5.6-common php5.6-curl php5.6-gd php5.6-imap php5.6-mysql php5.6-pspell php5.6-snmp \
    php5.6-sqlite3 php5.6-xsl php5.6-intl php5.6-mbstring php5.6-zip php5.6-bcmath php5.6-xml php5.6-imagick php5.6-redis php5.6-memcache \
		php5.6-apcu php5.6-gmp \
  # Fix for added by debfault
  && apt-get purge -y php7* php8* \
	&& cp /usr/sbin/php-fpm5.6 /usr/sbin/php-fpm \
  \
  \
# Configure www user  
  && usermod www-data -s /bin/bash \
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
# Configure Apache
  && a2enmod proxy_fcgi rewrite deflate alias actions headers \
  \
  \
# Clean
  && apt-get -y purge \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

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
