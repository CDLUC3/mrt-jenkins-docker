#!/bin/bash

ADMIN_PASSWORD_PATH="/var/jenkins_home/secrets/initialAdminPassword"

CONTAINER_ID=$(set -e; docker run -P -d mrt-jenkins-docker | cut -c 1-12)
[[ -z "${CONTAINER_ID}" ]] && { echo "Unable to start container" ; exit 1; }

JENKINS_PORT=$(docker port ${CONTAINER_ID} 8080)
[[ -z "${JENKINS_PORT}" ]] && { echo "Unable to determine Jenkins port" ; exit 1; }

cat <<EOF
Jenkins Docker container running with container ID ${CONTAINER_ID}
To stop the server: docker kill ${CONTAINER_ID}
To restart after stop: docker start ${CONTAINER_ID}
To remove the container after stop: docker rm ${CONTAINER_ID}
To log into the container as jenkins: docker exec -u jenkins -it ${CONTAINER_ID} /bin/bash
To log into the container as root: docker exec -u root -it ${CONTAINER_ID} /bin/bash
Waiting for Jenkins to start (should be ≲ 30 seconds)...
EOF

docker exec -it ${CONTAINER_ID} bash -c "while [ ! -f ${ADMIN_PASSWORD_PATH} ]; do echo -n '.'; sleep 1; done; echo"

JENKINS_ADMIN_PASSWORD=$(docker exec -it ${CONTAINER_ID} cat ${ADMIN_PASSWORD_PATH})
[[ -z "${JENKINS_ADMIN_PASSWORD}" ]] && { echo "Unable to determine Jenkins admin password" ; exit 1; }

cat <<EOF
Jenkins running at http://${JENKINS_PORT} with admin password: ${JENKINS_ADMIN_PASSWORD}
EOF

