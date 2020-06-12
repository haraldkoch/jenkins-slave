#!/bin/sh

#Add docker group with same gid as host docker group to client
#Based on docker socket group ownership if it exists
#Also, add jenkins user to docker group
if [ -r /var/run/docker.sock ] ; then

    groupadd -o -g $(stat -c '%g' /var/run/docker.sock) docker
    usermod -a -G docker jenkins

fi

# cleanup jenkins .ssh permissions (mainly for kubernetes)
chown -R jenkins.jenkins /home/jenkins/.ssh
chmod 600 /home/jenkins/.ssh/id_{rsa,ed25519}

# generate host keys if not present
ssh-keygen -A

# do not detach (-D), log to stderr (-e), passthrough other arguments
exec /usr/sbin/sshd -D -e "$@"

