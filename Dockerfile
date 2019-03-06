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

ARG OPENJDK_URL

USER root

RUN cd /opt && \
   mkdir jdk && \
   chown jenkins:jenkins jdk

USER jenkins

RUN cd /tmp && \
    curl -L -o openjdk.tgz ${OPENJDK_URL} && \
    tar -zxf openjdk.tgz -C /opt/jdk && \
    rm openjdk.tgz && \
    ln -s $(ls -d /opt/jdk/*) /opt/jdk/jdk-11

# ############################################################
# Jenkins plugins
# ############################################################

USER jenkins

RUN install-plugins.sh \
    configuration-as-code \
    configuration-as-code-support \
    blueocean

# ############################################################
# Skip Jenkins config wizard
# ############################################################

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# ############################################################
# Jenkins configuration
# ############################################################

COPY casc_configs/jenkins.yaml /var/jenkins_home/

## ############################################################
## git configuration
## ############################################################
#
## TODO: figure out why 'USER jenkins' + 'git config --global' doesn't work
#USER root
#RUN git config --system user.email 'no-reply@builds.cdlib.org' && \
#    git config --system user.name 'Jenkins (Docker)'
#
#USER jenkins
#RUN git config -l --show-origin
#
## ############################################################
## Build tools
## ############################################################
#
#USER root
#
#RUN apt-get install -y maven
