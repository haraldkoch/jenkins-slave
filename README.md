# jenkins-slave
playing with building a jenkins slave image

This project builds a Docker image that can be used with the Jenkins
[SSH Slaves Plugin](https://wiki.jenkins.io/display/JENKINS/SSH+Slaves+plugin).

It contains various tools that we at UHN typically need to build our projects:
 * OpenJDK 1.7
 * OpenJDK 1.8
 * ansible (current)
 * git (current)
 * subversion (current)
 * Apache Maven 3.2.2
 * Leiningen 2.7.1
 * rancher-compose 0.12.3
 
 The build also creates a `jenkins` user for use with SSH, and installs and runs the SSH daemon on startup.
 
## Usage
 
 On the target host, run something like:
 
 `docker run --restart unless-stopped -p 10022:22 haraldkoch/jenkins-slave:latest`
 
 Then configure the Jenkins Slave launcher with Launch method "Launch slave agents via SSH",
 and configure in your hostname, the external port number, and the jenkins user credentials.
 
## Building

 `make` will build a new copy of the docker image with the current version tag; `make push` will upload the current image to the Docker Hub.

 `make release` will bump the 'patch' version number (e.g. 1.0.1 becomes 1.0.2).

 This project is currently built automatically using travis-ci also.
