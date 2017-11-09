#!/bin/bash

# exit the script on very first failed step
set -e

container_id=`ls -al| grep web | wc -l`
next_container=$[$container_id+1]
mkdir  webapp$next_container

# copying the Docker build file and making an increment for next image build
cp webapp$container_id/Dockerfile  webapp$next_container/
cd webapp$next_container/
sed -i "7s/$container_id/$next_container/g" Dockerfile

count=$[$next_container+80]

# Building a new image using previous launched container
docker build -t webserver$next_container .

# Creating a container using latest built image
docker run -d -p $count:80 webserver$next_container

cd ..

if [ $? -eq 0 ]
then
  echo "    server webserver$next_container 127.0.0.01:$count check" >> /etc/haproxy/haproxy.cfg
  echo ""
  echo "container $next_container configurations are updated in load balancer settings.. Hit the browser to check !"
  systemctl reload haproxy
else 
  echo "containers could not be added haproxy settings !! Check your script.."
  exit
fi

