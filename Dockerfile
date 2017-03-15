# This Dockerfile is used to build an image containing the software I use for building projects in my jenkins slaves.
FROM centos:7
MAINTAINER Harald Koch <harald.koch@gmail.com>

EXPOSE 22
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

# we need epel-release to get ansible
RUN yum update -y && \
    yum -y install epel-release && \
    yum -y install ansible docker-client git sudo wget unzip openssh-server java-1.7.0-openjdk-devel java-1.8.0-openjdk-devel && \
    yum clean all

# Install a basic SSH server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Add user jenkins to the image. FIXME: figure out a better way to handle
# group access to the /var/run/docker.sock socket - this group 996 thing is
# not reliable.
RUN adduser -G 996 jenkins

# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

# install apache maven
RUN wget --progress=dot:mega -O /tmp/apache-maven-3.2.2-bin.zip http://archive.apache.org/dist/maven/binaries/apache-maven-3.2.2-bin.zip && \
	mkdir -p /home/jenkins/tools/hudson.tasks.Maven_MavenInstallation && \
	cd /home/jenkins/tools/hudson.tasks.Maven_MavenInstallation && \
	unzip /tmp/apache-maven-3.2.2-bin.zip && \
	rm /tmp/apache-maven-3.2.2-bin.zip

# install leiningen - Clojure build tool
RUN wget -O /usr/local/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    chmod +x /usr/local/bin/lein && \
    mkdir -p ~jenkins/.lein/self-installs && \
    wget --progress=dot:mega -O ~jenkins/.lein/self-installs/leiningen-2.7.1-standalone.jar \
        https://github.com/technomancy/leiningen/releases/download/2.7.1/leiningen-2.7.1-standalone.zip

# install rancher-compose
# we use a subdirectory because the rancher-compose tar file includes an entry
# for "."; extracting it as root disables write access to /tmp. Craziness!!
RUN wget --progress=dot:mega -O /tmp/rancher-compose-linux-amd64-v0.12.3.tar.gz https://github.com/rancher/rancher-compose/releases/download/v0.12.3/rancher-compose-linux-amd64-v0.12.3.tar.gz && \
    mkdir /tmp/rc && \
    tar -C /tmp/rc -xf /tmp/rancher-compose-linux-amd64-v0.12.3.tar.gz && \
    /bin/mv /tmp/rc/rancher-compose-v0.12.3/rancher-compose /usr/local/bin/rancher-compose && \
    chmod +x /usr/local/bin/rancher-compose && \
    /bin/rm -rf /tmp/rc /tmp/rancher-compose-linux-amd64-v0.12.3.tar.gz

COPY VERSION /home/jenkins
RUN chown -R jenkins.jenkins /home/jenkins
