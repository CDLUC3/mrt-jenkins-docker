#!/bin/bash

#OPENJDK_11_RELEASE_JSON='https://raw.githubusercontent.com/AdoptOpenJDK/openjdk11-binaries/master/latest_release.json'
#https://raw.githubusercontent.com/AdoptOpenJDK/openjdk8-binaries/master/latest_release.json

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd ${PROJECT_ROOT}
docker build \
    --build-arg OPENJDK8_URL=$(bin/get-openjdk-url.py 8) \
    --build-arg OPENJDK11_URL=$(bin/get-openjdk-url.py 11) \
    -t mrt-jenkins-docker .
