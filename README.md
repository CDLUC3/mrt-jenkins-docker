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
   $ docker run -it --rm -P mrt-jenkins-docker /bin/bash
   ```

   An explanation of the flags:

   - `-it`

     Short for `--interactive` and `--tty`; tells Docker to keep STDIN open and
     allocate a pseudo-TTY, i.e., to give you something that looks like a normal
     login session.

   - `--rm`

     Tells Docker to delete the container when the specified command
     (in this case `/bin/bash` exits).

   - `-P`

      Tells Docker to publish all ports specified in the Dockerfile. These will
      be mapped to random ports on the host machine that can be found with the
      `docker ps` or `docker port` command

   For additional login sessions in the same running container, use the `docker exec`
   command. You can get the container name (auto-generated) or ID (hash) with the
   `docker ps` command. E.g., to log in as root (`-u 0`):

   ```
   $ docker exec -u 0 -it 0a1291ea741d /bin/bash
   ```
