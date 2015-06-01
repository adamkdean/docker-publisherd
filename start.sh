#!/bin/bash

docker build -t publisherd .

docker run --rm -ti \
    --link ambassador:ambassador \
    -p 80:80 \
    publisherd
