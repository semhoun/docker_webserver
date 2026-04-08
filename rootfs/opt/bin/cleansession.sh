#!/bin/bash

PHP=$(which php)
SESSION_LIFETIME=$($PHP -r 'echo ini_get("session.gc_maxlifetime");')
SESSION_PATH=/tmp

MINUTE=$((SESSION_LIFETIME / 60)) # on calcule les minutes pour la commande find
find ${SESSION_PATH} -type f -name 'sess_*' -cmin "+$MINUTE" -delete
