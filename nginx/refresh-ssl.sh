#!/bin/sh
set -e
certbot --nginx --non-interactive  --agree-tos --redirect --uir --hsts --staple-ocsp --must-staple -d r9.lv -d pma.r9.lv --email ruu.lv.analog.photo@gmail.com