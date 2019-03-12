#!/bin/bash

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd ${PROJECT_ROOT}
docker build \
    --build-arg OPENJDK8_URL=$(bin/get-openjdk-url.py 8) \
    --build-arg OPENJDK11_URL=$(bin/get-openjdk-url.py 11) \
    -t mrt-jenkins-docker .
