# This Dockerfile is used to build an image containing basic stuff to be used as a Jenkins slave build node.
FROM java:8-alpine
MAINTAINER Harald Koch <harald.koch@gmail.com>

# Make sure the package repository is up to date, and install packages
# this ugliness with python-dev and PIP is required only because Ubuntu 14.04 trusty is missing python-xmltodict as a package.
# FIXME: upgrade to Ubuntu 16.04 or switch to alpine and see if it has the correct packages available - or use Archlinux. Ugh.

RUN apk --no-cache add ansible krb5 openssh py-pip py-kerberos \
 && apk --no-cache add --virtual build-dependencies python-dev build-base wget \
 && pip install pywinrm xmltodict \
 && apk del build-dependencies \
 && echo -e "Port 22\n" >> /etc/ssh/sshd_config \
 && cp -a /etc/ssh /etc/ssh.cache

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

COPY entry.sh /entry.sh

ENTRYPOINT ["/entry.sh"]

CMD ["/usr/sbin/sshd", "-D", "-f", "/etc/ssh/sshd_config"]

