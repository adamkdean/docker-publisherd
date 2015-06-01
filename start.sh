#!/bin/bash

docker build -t publisherd .

docker run --rm -ti \
    --link ambassador:ambassador \
    -p 80:80 \
    -e BACKEND_8500=consul-8500.service.consul \
    publisherd
