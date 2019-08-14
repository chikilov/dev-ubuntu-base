#!/bin/bash
cd /home/ubuntu/apps && git clone https://github.com/chikilov/minikube.git
service php7.3-fpm start && service nginx start
