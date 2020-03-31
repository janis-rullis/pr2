#!/bin/sh
set -e
service nginx start && tail -F /var/log/nginx/error.log