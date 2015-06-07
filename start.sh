#!/bin/bash

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
    -v /var/run/docker.sock:/var/run/docker.sock \
    -e BACKEND_8500=consul-8500.service.consul \
    publisherd
