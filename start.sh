#!/bin/bash

docker build -t publisherd .

docker run --rm -ti \
    --link ambassador:ambassador \
    publisherd
