#!/bin/bash
#
# Remove all publisherd containers (not the data container though)

docker ps -a | grep publisherd | grep -v data | awk '{print $1}' | xargs docker kill
docker ps -a | grep publisherd | grep -v data | awk '{print $1}' | xargs docker rm
