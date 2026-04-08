#!/bin/bash

set -e

cp /opt/conf/php/*  "${PHP_INI_DIR}/conf.d/"
if [ "${DEBUG_MODE}" == "true" ]; then
  cp  "${PHP_INI_DIR}/php.ini-development"  "${PHP_INI_DIR}/php.ini"
  cat > "${PHP_INI_DIR}/conf.d/z99-debug.ini" << 'EOF'
display_errors = On
display_startup_errors = On
opcache.enable = Off
EOF
else
  cp "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini"
fi

/opt/bin/cleansession.sh

ROOT_DIR="/www/public"
if [ ! -d "/www/public" ]; then
  ROOT_DIR="/www"
fi

mkdir -p /etc/caddy
TRACING_BLOCK=''
if [ -n "${OTEL_EXPORTER_OTLP_ENDPOINT}" ]; then
TRACING_BLOCK='  tracing {
      span "{method} {uri}"
    }
    request_header X-Trace-Id {http.vars.trace_id}
'
fi
SITE_ADDRESS=':80'
CADDY_HTTPS_OPTIONS='  auto_https off'
if [ "${ENABLE_LETSENCRYPT}" = "true" ] && [ -n "${ACME_EMAIL}" ]; then
  SITE_ADDRESS="${SERVER_NAME}"
  CADDY_HTTPS_OPTIONS="  email ${ACME_EMAIL}"
fi
cat > /etc/caddy/Caddyfile << EOF
{
  frankenphp
  order php_server before file_server
  log {
    output stderr
  }
  metrics
  ${CADDY_HTTPS_OPTIONS}
}

${SITE_ADDRESS} {
  root * ${ROOT_DIR}
  encode zstd gzip

  php_server {
    index index.php
  }
  file_server

  log {
    output stdout
    format formatted "{common_log}"
  }
${TRACING_BLOCK}
}
EOF

exec "$@"
