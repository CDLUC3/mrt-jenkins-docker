#!/bin/bash
LC_CTYPE=en_US.utf8 # just to be sure

ADMIN_PASSWORD_PATH="/var/jenkins_home/secrets/initialAdminPassword"

CONTAINER_ID=$(set -e; docker run -v jenkins_home:/var/jenkins_home -P -d mrt-jenkins-docker  | cut -c 1-12)
[[ -z "${CONTAINER_ID}" ]] && { echo "Unable to start container" ; exit 1; }

JENKINS_PORT=$(docker port ${CONTAINER_ID} 8080)
[[ -z "${JENKINS_PORT}" ]] && { echo "Unable to determine Jenkins port" ; exit 1; }

cat <<EOF
Jenkins Docker container running with container ID ${CONTAINER_ID}

- To stop the server:                   docker kill ${CONTAINER_ID}
- To restart after stop:                docker start ${CONTAINER_ID}
- To remove the container after stop:   docker rm ${CONTAINER_ID}
- To stop and remove in one step:       docker rm -f ${CONTAINER_ID}
- To log into the container as jenkins: docker exec -u jenkins -it ${CONTAINER_ID} /bin/bash
- To log into the container as root:    docker exec -u root -it ${CONTAINER_ID} /bin/bash
- To see output from Jenkins startup:   docker logs ${CONTAINER_ID}

Waiting for Jenkins to start (should be ≈ 15 seconds)...
EOF

bin/wait_for_jenkins_to_start.py ${CONTAINER_ID}

cat <<EOF
Jenkins running at http://${JENKINS_PORT}
EOF

