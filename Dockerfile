#build the container
from ubuntu:latest

MAINTAINER The Vampire hunter <arun_patel@baxter.com>
run apt-get update -y
run apt-get install apache2 -y
run echo "webserver 2 is running" > /var/www/html/index.html
expose 80

#start the service

cmd ["-D", "FOREGROUND"]
entrypoint ["/usr/sbin/apache2ctl"]
