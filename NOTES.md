# Docker+Jenkins deployment/configuration process

## Goal:

Ensure we have a Docker image with:

- Jenkins (incl. its own bootstrap JDK)
- Maven
- configured Git (incl. `user.email` & `user.name`)
- `-Djenkins.install.runSetupWizard=false`
- OpenJDK 8 and 11 in `/opt/jdk`
- installed plugins (w/`install-plugins.sh`) (**NOTE:** This has to run in the container)
- `jenkins.yaml` in `/var/jenkins_home/` (**NOTE:** This has to be in place before `jenkins.sh`)

## Problems:

- When we preserve `/var/jenkins_home`, any changes to it in the Dockerfile will not
  be picked up. This includes the `jenkins.yaml` copied into the Dockerfile as well as (probably)
  plugins installed with `install-plugins.sh`.
- We can run `install-plugins.sh` and copy `jenkins.yaml` after the container starts up,
  but not if the container's already running Jenkins.
  - possible solution:
    - replace [default ENTRYPOINT](https://github.com/jenkinsci/docker/blob/8f609a265213eff10a79fb46261d7ff8fd9c6e6f/Dockerfile#L76)
      from `jenkins/jenkins:lts` with one that just installs the plugins
    - copy `jenkins.yaml` in as part of run script
    - execute `/sbin/tini -- /usr/local/bin/jenkins.sh` as part of run script
  - possible issues:
    - do we want to install plugins every time we run the container? (probably not)
    - do we want to copy `jenkins.yaml` every time we run the container? (only if we have to)
    - procedural approach here doesn't play well with Ansible/Puppet declarative "ensure this state"
      philosophy