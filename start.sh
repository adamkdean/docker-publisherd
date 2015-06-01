#!/bin/bash

docker build -t publisherd .

docker run --rm -ti \
    --link ambassador:ambassador \
    -e BACKEND_8500=consul-8500.service.consul \
    -p 80:80 \
    publisherd
