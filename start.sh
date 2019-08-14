#!/bin/bash
git clone ${REPO_URL}
service php${P_V}-fpm start && service nginx start
