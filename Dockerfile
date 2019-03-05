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
    rm openjdk.tgz

## ############################################################
## Jenkins plugins
## ############################################################
#
#USER jenkins
#
#RUN install-plugins.sh \
#    github \
#    job-dsl \
#    junit \
#    workflow-aggregator
#
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
#
## ############################################################
## Jobs
## ############################################################
#
## Cf. https://github.com/binario200/jenkins-job-dsl
## TODO: should these use COPY instead of ADD?
#
#USER jenkins
#
#ENV DSL_DIR ${JENKINS_HOME}/dsl
#RUN mkdir -p ${DSL_DIR}
#ADD --chown=jenkins:jenkins dsl ${DSL_DIR}
#
#ENV JOBS_DIR ${JENKINS_HOME}/jobs
#RUN mkdir -p ${JOBS_DIR}
#ADD --chown=jenkins:jenkins jobs ${JOBS_DIR}
#
#ENV INIT_DIR ${JENKINS_HOME}/init.groovy.d
#RUN mkdir -p ${INIT_DIR}
#ADD --chown=jenkins:jenkins init.groovy.d ${INIT_DIR}
