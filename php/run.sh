#!/bin/sh
set -e
service php7.3-fpm start
composer install
service nginx start && tail -F /var/log/nginx/error.log
