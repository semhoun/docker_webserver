#!/bin/bash

set -e

if [ ! -f "/etc/apache2/conf-docker/20-htdocs.conf" ]; then
	cp /opt/conf/apache/10-optimization.conf /etc/apache2/conf-docker/10-optimization.conf
	cat > /etc/apache2/conf-docker/15-location.conf << EOF
ServerName ${SERVER_NAME}
ServerAdmin ${SERVER_ADMIN}
EOF
	if [ -d "/www/public" ]; then
		cp /opt/conf/apache/20-htdocs.conf-public /etc/apache2/conf-docker/20-htdocs.conf
	else
		cp /opt/conf/apache/20-htdocs.conf-root /etc/apache2/conf-docker/20-htdocs.conf
	fi
  cp /opt/conf/apache/30-healthcheck.conf /etc/apache2/conf-docker/30-healthcheck.conf
	
	if [ "${DEBUG_MODE}" == "true" ]; then
		cat >  /etc/php/8.0/fpm/conf.d/99-debug.ini << 'EOF'
display_errors = On
display_startup_errors = On
EOF
	fi
fi

rm -f /var/run/apache2.pid 
rm -f /var/run/php-fpm.sock

exec $@