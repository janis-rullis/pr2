FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# create source directory
RUN rm -rf /var/www
RUN mkdir /var/www

# Install debian packages
RUN apt-get clean && apt-get -y update && apt-get install -y locales && locale-gen en_US.UTF-8
RUN apt-get install --yes build-essential inotify-tools cron nano mc htop curl nginx iputils-ping

RUN apt install software-properties-common -y
RUN add-apt-repository universe -y
RUN add-apt-repository ppa:certbot/certbot -y
RUN apt update -y
RUN apt-get install certbot python-certbot-nginx -y

# [Fix  `open() "/run/nginx.pid" failed (2: No such file or directory)`](https://github.com/gliderlabs/docker-alpine/issues/185#issuecomment-246595114)
RUN mkdir -p /run/nginx
RUN ln -s /var/www/site.conf /etc/nginx/sites-enabled/site.conf

RUN usermod -a -G www-data www-data
RUN chown www-data:www-data /var/www -R
RUN chmod a+rwX /var/www -R

WORKDIR /var/www

EXPOSE 80 443
CMD ["./run.sh"]