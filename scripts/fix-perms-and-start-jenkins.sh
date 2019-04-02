#!/bin/bash -e

# ############################################################
# Hack permissions on mounted volume before launching Jenkins
# ############################################################

chown -R jenkins:jenkins ${JENKINS_HOME} && \
  sudo --login -u jenkins \
    NEXUS_PASSWORD=${NEXUS_PASSWORD} \
    JENKINS_HOME=${JENKINS_HOME} \
    JENKINS_WAR=${JENKINS_WAR} \
    COPY_REFERENCE_FILE_LOG=${COPY_REFERENCE_FILE_LOG} \
    JAVA_OPTS=${JAVA_OPTS} \
    JENKINS_SLAVE_AGENT_PORT=${JENKINS_SLAVE_AGENT_PORT} \
    JENKINS_OPTS=${JENKINS_OPTS} \
    DEBUG=${DEBUG} \
    /usr/local/bin/jenkins.sh "$@"
