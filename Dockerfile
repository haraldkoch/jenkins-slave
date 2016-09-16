# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM ubuntu:trusty
MAINTAINER Harald Koch <harald.koch@gmail.com>

RUN apt-get update && apt-get -y dist-upgrade && apt-get install -y software-properties-common

# add webupd8team repository
RUN add-apt-repository -y ppa:webupd8team/java
# add ansible repository
RUN add-apt-repository -y ppa:ansible/ansible

# auto-accept Oracle license
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections

# Make sure the package repository is up to date, and install packages
# this ugliness with python-dev and PIP is required only because Ubuntu 14.04 trusty is missing python-xmltodict as a package.
# FIXME: upgrade to Ubuntu 16.04 or switch to alpine and see if it has the correct packages available - or use Archlinux. Ugh.
RUN apt-get update && apt-get install -y ansible krb5-user libkrb5-dev openssh-server oracle-java7-installer oracle-java7-unlimited-jce-policy oracle-java8-installer oracle-java8-set-default oracle-java8-unlimited-jce-policy python-dev python-pip && apt-get clean

# install python packages that we need for ansible and winrm
RUN pip install kerberos pywinrm xmltodict

# Install a basic SSH server
RUN sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd
RUN mkdir -p /var/run/sshd

# Add user jenkins to the image
RUN adduser --quiet jenkins

# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

# install maven
RUN wget -O /tmp/apache-maven-3.2.2-bin.zip http://archive.apache.org/dist/maven/binaries/apache-maven-3.2.2-bin.zip && \
	mkdir -p /home/jenkins/tools/hudson.tasks.Maven_MavenInstallation && \
	cd /home/jenkins/tools/hudson.tasks.Maven_MavenInstallation && \
	unzip /tmp/apache-maven-3.2.2-bin.zip && \
	rm /tmp/apache-maven-3.2.2-bin.zip

RUN chown -R jenkins.jenkins /home/jenkins

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
