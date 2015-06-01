#!/bin/bash

PRIVATE_IPV4=$(ifconfig eth1 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}')

docker build -t publisherd .

docker run --rm -ti \
    --link ambassador:ambassador \
    -p $PRIVATE_IPV4:80:80 \
    -e BACKEND_8500=consul-8500.service.consul \
    publisherd

echo "*** Listening on $PRIVATE_IPV4:80 ***"
