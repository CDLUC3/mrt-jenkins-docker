#!/bin/bash

ADMIN_PASSWORD_PATH="/var/jenkins_home/secrets/initialAdminPassword"

CONTAINER_ID=$(docker run -P -d mrt-jenkins-docker | cut -c 1-12)
JENKINS_PORT=$(docker port ${CONTAINER_ID} 8080)

echo "Jenkins Docker container running with \$CONTAINER_ID ${CONTAINER_ID}"
echo "To stop the server: docker kill ${CONTAINER_ID}"
echo "To restart after stop: docker start ${CONTAINER_ID}"
echo "To log into the container as jenkins: docker exec -u jenkins -it ${CONTAINER_ID} /bin/bash"
echo "To log into the container as root: docker exec -u root -it ${CONTAINER_ID} /bin/bash"

echo -n "Waiting for Jenkins to start..."
docker exec -it ${CONTAINER_ID} bash -c "while [ ! -f ${ADMIN_PASSWORD_PATH} ]; do echo -n '.'; sleep 1; done; echo"

JENKINS_ADMIN_PASSWORD=$(docker exec -it ${CONTAINER_ID} cat ${ADMIN_PASSWORD_PATH})
echo "Jenkins running at http://${JENKINS_PORT} with admin password: ${JENKINS_ADMIN_PASSWORD}"

