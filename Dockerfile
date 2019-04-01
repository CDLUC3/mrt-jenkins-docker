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
# Build tools
# ############################################################

USER root

RUN apt-get install -y maven

## ############################################################
## git configuration
## ############################################################

# TODO: figure out why 'USER jenkins' + 'git config --global' doesn't work
USER root
RUN git config --system user.email 'no-reply@builds.cdlib.org' && \
    git config --system user.name 'Jenkins (Docker)'

USER jenkins
RUN git config -l --show-origin

# ############################################################
# Skip Jenkins config wizard
# ############################################################

ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# ############################################################
# Jenkins plugins
# ############################################################

USER jenkins

# NOTE: plugin support in JCasC is deprecated; we should use this even outside of Docker, see
# https://github.com/jenkinsci/configuration-as-code-plugin/pull/766#issuecomment-469756749
RUN install-plugins.sh \
    ansicolor \
    configuration-as-code \
    configuration-as-code-support \
    git \
    github \
    job-dsl \
    maven-plugin \
    nexus-jenkins-plugin \
    pipeline-maven \
    workflow-aggregator

# ############################################################
# Latest OpenJDK 8 & 11  (system JDK is older OpenJDK 8)
# ############################################################

ARG OPENJDK8_URL
ARG OPENJDK11_URL

USER root

RUN cd /opt && \
   mkdir jdk && \
   chown jenkins:jenkins jdk

USER jenkins

RUN cd /tmp && \
    curl -L -o openjdk8.tgz ${OPENJDK8_URL} && \
    tar -zxf openjdk8.tgz -C /opt/jdk && \
    rm openjdk8.tgz && \
    ln -s $(ls -d /opt/jdk/*8*) /opt/jdk/jdk8

RUN cd /tmp && \
    curl -L -o openjdk11.tgz ${OPENJDK11_URL} && \
    tar -zxf openjdk11.tgz -C /opt/jdk && \
    rm openjdk11.tgz && \
    ln -s $(ls -d /opt/jdk/*11*) /opt/jdk/jdk11

# ############################################################
# Jenkins configuration
# ############################################################

COPY casc_configs/jenkins.yaml /var/jenkins_home/

# ############################################################
# Hack permissions on mounted volume before launching Jenkins
# ############################################################

# TODO: something less awful
#   - see https://github.com/jenkinsci/docker/issues/813#issuecomment-477739766
USER root
RUN apt-get install -y sudo
COPY scripts/fix-perms-and-start-jenkins.sh /usr/local/bin/
ENTRYPOINT ["/sbin/tini", "-vvv", "--", "/usr/local/bin/fix-perms-and-start-jenkins.sh"]
