#!/bin/bash

docker build -t consul-template-test .

docker run --rm -ti \
    --dns=10.17.42.1 \
    consul-template-test
