#!/bin/bash

# build the publisherd-proxy nginx container
cd nginx/
docker build -t publisherd-proxy .

# build the publisherd main container
cd ../
docker build -t publisherd .

# run the publisherd main container
docker run --rm -ti \
    --name publisherd \
    --link ambassador:ambassador \
    -e BACKEND_8500=consul-8500.service.consul \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $PWD/nginx/:/var/nginx/ \
    publisherd
