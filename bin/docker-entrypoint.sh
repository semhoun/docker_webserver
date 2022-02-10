#!/bin/bash

set -e

if [ ! -f "/etc/apache2/apache2.conf" ]; then
	if [ -d "/www/public" ]; then
		cp /etc/apache2/public.conf /etc/apache2/apache2.conf
	else
		cp /etc/apache2/root.conf /etc/apache2/apache2.conf
	fi
    
    if [ "${DEBUG_MODE}" == "true" ]; then
        cat >  /etc/php/8.0/fpm/conf.d/99-debug.ini << 'EOF'
display_errors = On
display_startup_errors = On
EOF
    fi

fi

rm -f /var/run/apache2/apache2.pid 
rm -f /var/run/php-fpm.sock

$@