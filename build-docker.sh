#!/bin/bash

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd ${PROJECT_ROOT}

OPENJDK8_URL=$(bin/get-openjdk-url.py 8) || { echo "Can't get OpenJDK 8 URL"; exit 1; }
echo "OpenJDK 8: using ${OPENJDK8_URL}"

OPENJDK11_URL=$(bin/get-openjdk-url.py 11) || { echo "Can't get OpenJDK 11 URL"; exit 1; }
echo "OpenJDK 11: using ${OPENJDK11_URL}"

docker build \
    --build-arg OPENJDK8_URL=${OPENJDK8_URL} \
    --build-arg OPENJDK11_URL=${OPENJDK11_URL} \
    -t mrt-jenkins-docker .
