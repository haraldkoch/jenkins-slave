#!/bin/sh

#Add docker group with same gid as host docker group to client
#Based on docker socket group ownership if it exists
#Also, add jenkins user to docker group
if [ -r /var/run/docker.sock ] ; then

    groupadd -o -g $(stat -c '%g' /var/run/docker.sock) docker
    usermod -a -G docker jenkins

fi


# generate host keys if not present
ssh-keygen -A

# do not detach (-D), log to stderr (-e), passthrough other arguments
exec /usr/sbin/sshd -D -e "$@"

