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
   $ ./run-docker.sh
   ```
