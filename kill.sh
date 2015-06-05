#!/bin/bash

docker ps -a | grep publisherd | awk '{print $1}' | xargs docker kill
docker ps -a | grep publisherd | awk '{print $1}' | xargs docker rm
