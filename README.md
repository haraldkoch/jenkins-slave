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
 
