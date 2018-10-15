#!/bin/bash

PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd ${PROJECT_ROOT}
docker build -t mrt-jenkins-docker .
