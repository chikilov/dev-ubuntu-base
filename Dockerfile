FROM ubuntu:18.04
LABEL maintainer "chikilov"

# common update
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y
RUN apt-get install -y apt-utils
# php version
ARG PV=7.3

# ex : dev, stage, production
ARG ENV=dev

# util installation
RUN apt-get install -y vim curl git sudo net-tools

# php installation
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:ondrej/php
RUN apt-get update
RUN apt-get install -y php${PV:-7.3}-fpm
RUN apt-get install -y php${PV:-7.3}-mbstring php${PV:-7.3}-curl php${PV:-7.3}-xml php${PV:-7.3}-gd php${PV:-7.3}-mysql php${PV:-7.3}-bcmath php-mbstring php-redis php-memcached

# nginx installation
RUN apt-get remove -y apache2
RUN add-apt-repository ppa:nginx/development
RUN apt-get update
RUN apt-get install -y nginx-full
RUN rm -rf /etc/nginx/sites-enabled/default

# mysql installation
RUN apt-get install -y mysql-server

# redis installation
RUN apt-get install -y redis-server

# copy environment files
WORKDIR /home/ubuntu/apps
COPY php/${ENV:-dev}/php.ini /etc/php/${PV:-7.3}/fpm/php.ini
COPY php/${ENV:-dev}/www.conf /etc/php/${PV:-7.3}/fpm/pool.d/www.conf
COPY nginx/${ENV:-dev}/fastcgi_params /etc/nginx/fastcgi_params
COPY nginx/${ENV:-dev}/sites-enabled /etc/nginx/sites-enabled
COPY redis/${ENV:-dev}/redis.conf /etc/redis/redis.conf

# file own change
RUN chown -R redis:redis /etc/redis/redis.conf
RUN service mysql start; exit 0
RUN usermod -d /var/lib/mysql/ mysql
RUN chown -R mysql:mysql /var/lib/mysql

# source control
COPY start.sh /home/ubuntu/start.sh
RUN chmod 777 /home/ubuntu/start.sh
RUN /home/ubuntu/start.sh "globaldaily"

EXPOSE 80
EXPOSE 3306
EXPOSE 6379
EXPOSE 8080
