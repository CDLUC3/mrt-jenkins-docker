# image: mrt-jenkins-docker
FROM jenkins/jenkins:lts
MAINTAINER David Moles "david.moles@ucop.edu"

# ############################################################
# Prerequisites
# ############################################################

USER root

RUN apt-get update

# ############################################################
# OpenJDK 11  (system JDK is OpenJDK 8)
# ############################################################

USER jenkins

ENV OPENJDK_URL https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11%2B28/OpenJDK11-jdk_arm_linux_hotspot_11_28.tar.gz

RUN mkdir /tmp/openjdk && \
    cd /tmp/openjdk && \
    curl -L -o openjdk.tgz ${OPENJDK_URL} && \
    tar -zxf openjdk.tgz

# ############################################################
# Useful packages for debugging
# ############################################################

USER root

RUN apt-get install -y emacs-nox && \
    apt-get install -y less && \
    apt-get install -y tree && \
    apt-get install -y file
