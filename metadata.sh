#!/bin/bash


function docker_name {
  for container_name in `docker ps -a | awk 'NR>1{print $NF}'`;
    do echo ""
    echo $container_name
  done
}

function docker_id {
  for container_id in `docker ps -a | awk 'NR>1{print $1}'`;
    do echo ""
    echo $container_id
  done
}

function docker_image {
  for container_image in `docker ps -a | awk 'NR>1{print $2}'`;
    do echo ""
    echo $container_image
  done
}

function docker_ip {
  for container_ip in `docker ps -a | awk 'NR>1{print $1}'`;
    do echo ""
    docker inspect $container_ip | grep  -w -m1 IPAddress | egrep -o '([0-9]{1,3}\.){3}[0-9]{                             1,3}'
    if [[ $? != 0 ]]; then
      echo "NoIP"
    fi
  done
}

function docker_status {
  for container_status in `docker ps -a | awk 'NR>1{print $1}'`
    do echo ""
    docker inspect $container_status | grep -i status | awk '{ print $2}' | sed 's/,$//'
  done
}

function docker_pid {
  for container_ip in `docker ps -a | awk 'NR>1{print $1}'`;
    do echo ""
    tmp_id=`docker inspect $container_ip | grep -w Pid | grep -P -o "[0-9]+"`
    if [[ $tmp_id == 0 ]]; then
      echo "No Pid"
    else
      echo $tmp_id
    fi
  done
}


echo ""
echo "NAME        ID          IMAGE       IPADDRESS    STATUS     PROCESSID"
echo "---------------------------------------------------------------------"

pr -m -t <(docker_name) \
<(docker_id) \
<(docker_image) \
<(docker_ip) \
<(docker_status) \
<(docker_pid)

echo ""
