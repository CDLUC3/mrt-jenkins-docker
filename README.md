# mrt-jenkins-docker

A sandbox Docker image for [Merritt](http://merritt.cdlib.org) continous
delivery development.

## Usage

1. Install Docker.
2. Clone the `mrt-jenkins-docker` git repository.
3. run the `build-docker.sh` script.

   ```
   $ cd mrt-jenkins-docker
   $ ./build-docker.sh
   ```

4. Verify that the image was created with `docker images`.

   ```
   $ docker images
   REPOSITORY           TAG                 IMAGE ID            CREATED             SIZE
   mrt-jenkins-docker   latest              acb5a89eacc3        4 seconds ago       1.12GB
   ```

5. Launch a new Docker container based on the newly created image:

   ```
   $ ./run-docker.sh
   ```
