#!/bin/bash
cd /home/ubuntu/apps && git pull
service php7.3-fpm start && service nginx start
