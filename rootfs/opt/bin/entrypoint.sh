#!/bin/bash

set -e

if [ ! -f "/etc/apache2/conf-docker/20-htdocs.conf" ]; then
	cat > /etc/apache2/conf-docker/15-location.conf << EOF
ServerName ${SERVER_NAME}
ServerAdmin ${SERVER_ADMIN}
EOF
	if [ -d "/www/public" ]; then
		cp /etc/apache2/conf-docker/20-htdocs.conf-public /etc/apache2/conf-docker/20-htdocs.conf
	else
		cp /etc/apache2/conf-docker/20-htdocs.conf-root /etc/apache2/conf-docker/20-htdocs.conf
	fi
	
	if [ "${DEBUG_MODE}" == "true" ]; then
		cat >  /etc/php/8.2/fpm/conf.d/99-debug.ini << 'EOF'
display_errors = On
display_startup_errors = On
EOF
	fi
fi

rm -rf /var/spool/fcron/root
/usr/bin/fcrontab -n /etc/fcron/fcrontab-root root

rm -f /var/run/apache2.pid 
rm -f /var/run/php-fpm.sock

exec $@