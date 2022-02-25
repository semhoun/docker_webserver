#!/bin/bash

set -e

if [ ! -f "/etc/apache2/conf-docker/20-htdocs.conf" ]; then
	if [ -d "/www/public" ]; then
		cp /etc/apache2/conf-docker/20-htdocs.conf-public /etc/apache2/conf-docker/20-htdocs.conf
	else
		cp /etc/apache2/conf-docker/20-htdocs.conf-root /etc/apache2/conf-docker/20-htdocs.conf
	fi
    
	if [ "${DEBUG_MODE}" == "true" ]; then
		cat >  /etc/php/8.0/fpm/conf.d/99-debug.ini << 'EOF'
display_errors = On
display_startup_errors = On
EOF
	fi
fi

if [ -n "${SERVER_NAME}" ] && [ -n "${SERVER_ADMIN}" ]; then
	cat > /etc/apache2/conf-docker/15-location.conf << EOF
ServerName ${SERVER_NAME}
ServerAdmin ${SERVER_ADMIN}
EOF
fi

rm -f /var/run/apache2.pid 
rm -f /var/run/php-fpm.sock

exec $@