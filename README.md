# mrt-jenkins-docker

A sandbox Docker image for [Merritt](http://merritt.cdlib.org) continous
delivery development.

## Usage

1. Install Docker.
2. Clone the `mrt-jenkins-docker` git repository.
3. `cd` to the `mrt-jenkins-docker` directory, and create a new Docker image from
   the provided `Dockerfile`.

   ```
   $ cd mrt-jenkins-docker
   $ docker build -t mrt-jenkins-docker .
   ```

4. Verify that the image was created with `docker images`.
5. Launch a new Docker container based on the newly created image:

   ```
   $ docker run --rm -P mrt-jenkins-docker
   ```

   An explanation of the flags:

   - `-it`

     Short for `--interactive` and `--tty`; tells Docker to keep STDIN open and
     allocate a pseudo-TTY, i.e., to give you something that looks like a normal
     login session.

   - `-P`

      Tells Docker to publish all ports specified in the Dockerfile. These will
      be mapped to random ports on the host machine that can be found with the
      `docker ps` or `docker port` command

   Docker will use the default entrypoint specified in the 
   [parent Jenkins
   Dockerfile](https://github.com/jenkinsci/docker/blob/96061445a6f2e8fb861c4a2d46bdbb6eccc912bd/Dockerfile#L78),
   which runs `/usr/local/bin/jenkins.sh`.
   
   > **Optional**
   >
   > Pass the `--rm` flag to `docker run` to delete the container when the startup
   > command exits.

6. For additional login sessions in the same running container, use the `docker exec`
   command. You can get the container name (auto-generated) or ID (hash) with the
   `docker ps` command. E.g., to log in as root (`-u 0`):

   ```
   $ docker exec -u 0 -it f3770c2d2e6a /bin/bash
   ```

   From within the container, view the file
   `/var/jenkins_home/secrets/initialAdminPassword` to get the initial
   Jenkins admin password, e.g.

   ```
   root@f3770c2d2e6a:/# cat /var/jenkins_home/secrets/initialAdminPassword
   9b6c862bf18d4edc95e87a3c82a2af38
   ```

7. Use `docker ps` or `docker port <CONTAINER-ID> 8080` to identify the host port
   bound to container port 8080 (the Tomcat default port), e.g.

   ```
   $ docker port f3770c2d2e6a 8080`
   0.0.0.0:32785
   ```


