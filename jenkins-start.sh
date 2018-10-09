#!/bin/bash

CONTAINER_NAME=mrt-jenkins-docker

docker run -it -P ${CONTAINER_NAME}

# TODO: figure out how to get this; run without -it?
# export CONTAINER_ID=$(docker ps -q --filter "ancestor=${CONTAINER_NAME}")
# echo $CONTAINER_ID
