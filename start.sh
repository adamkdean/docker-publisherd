#!/bin/bash

docker build -t consul-template-test .

docker run --rm -ti \
    --link ambassador:ambassador \
    -e "BACKEND_8500=consul-8500.service.consul" \
    consul-template-test
