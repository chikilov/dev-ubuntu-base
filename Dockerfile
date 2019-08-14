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
# repository url
ARG REPO_URL=https://github.com/chikilov/minikube.git

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

# copy environment files
WORKDIR /home/ubuntu/apps
COPY php/${ENV:-dev}/php.ini /etc/php/${PV:-7.3}/fpm/php.ini
COPY nginx/${ENV:-dev}/fastcgi_params /etc/nginx/fastcgi_params
COPY nginx/${ENV:-dev}/site-enabled /etc/nginx/site-enabled

# source control
COPY start.sh /usr/bin/start.sh
RUN chmod 777 /usr/bin/start.sh
#ENTRYPOINT /usr/bin/start.sh

EXPOSE 80
