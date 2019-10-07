# Required values
project folder : /Volumes/exhdd/BaseProject

# Create Docker Image
git clone https://github.com/chikilov/minikube.git

cd minikube/

docker build -t dev-ubuntu-base-gldaily:latest .

# Create Docker Container

docker run -ti -p 80:80 -p 3306:3306 -p 6379:6379 -p 8080:8080 -v /Volumes/exhdd/BaseProject:/home/ubuntu/apps/current dev-ubuntu-base-gldaily

# Start Required Services at Container Shell

sudo chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

sudo service redis-server start

sudo service mysql start

sudo service php7.3-fpm start

sudo service nginx start

# Other Notices

mysql root password : globaldaily

port binding : 80(nginx), 3306(mysql), 6379(redis), 8080(extra)
