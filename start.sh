#!/bin/bash

ETH0_IP=$(ifconfig eth0 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}')
ETH1_IP=$(ifconfig eth1 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}')

echo "Injecting eth0 as $ETH0_IP and eth1 as $ETH1_IP"

# build the publisherd-proxy nginx container
cd nginx/
docker build -t publisherd-proxy .

# build the publisherd main container
cd ../
docker build -t publisherd .

# check if a data volume exists, if not, create it
if [ $(docker ps -a | grep publisherd-data | wc -l) -eq 0 ]; then
    docker run -d \
        -v /etc/nginx/conf.d/ \
        -v /etc/nginx/certs/ \
        -v /var/publisherd/ \
        --name publisherd-data \
        busybox
fi

# run the publisherd main container
docker run -d \
    --name publisherd \
    --link ambassador:ambassador \
    --volumes-from publisherd-data \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e BACKEND_8500=consul-8500.service.consul \
    -e EXTERNAL_ETH0_IP=$ETH0_IP \
    -e EXTERNAL_ETH1_IP=$ETH1_IP \
    publisherd
