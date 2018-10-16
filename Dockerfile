# image: mrt-jenkins-docker
FROM jenkins/jenkins:lts
MAINTAINER David Moles "david.moles@ucop.edu"

# ############################################################
# Prerequisites
# ############################################################

USER root

RUN apt-get update

# ############################################################
# Useful packages for debugging
# ############################################################

RUN apt-get install -y emacs-nox && \
    apt-get install -y less && \
    apt-get install -y tree && \
    apt-get install -y file

# ############################################################
# OpenJDK 11  (system JDK is OpenJDK 8)
# ############################################################

USER root

RUN cd /opt && \
   mkdir jdk && \
   chown jenkins:jenkins jdk

USER jenkins

ENV OPENJDK_URL https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11%2B28/OpenJDK11-jdk_arm_linux_hotspot_11_28.tar.gz

RUN cd /tmp && \
    curl -L -o openjdk.tgz ${OPENJDK_URL} && \
    tar -zxf openjdk.tgz -C /opt/jdk && \
    rm openjdk.tgz

# ############################################################
# Jenkins plugins
# ############################################################

USER jenkins

RUN install-plugins.sh \
    github \
    job-dsl \
    junit \
    workflow-aggregator

# ############################################################
# git configuration
# ############################################################

# TODO: figure out why 'USER jenkins' + 'git config --global' doesn't work
USER root
RUN git config --system user.email 'no-reply@builds.cdlib.org' && \
    git config --system user.name 'Jenkins (Docker)'

USER jenkins
RUN git config -l --show-origin

# ############################################################
# Build tools
# ############################################################

USER root

RUN apt-get install -y maven
