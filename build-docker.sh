#!/bin/bash

#OPENJDK_11_RELEASE_JSON='https://raw.githubusercontent.com/AdoptOpenJDK/openjdk11-binaries/master/latest_release.json'
#https://raw.githubusercontent.com/AdoptOpenJDK/openjdk8-binaries/master/latest_release.json

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd ${PROJECT_ROOT}
docker build -t mrt-jenkins-docker .
