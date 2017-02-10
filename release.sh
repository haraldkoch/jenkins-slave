#!/bin/sh

USERNAME=$1
IMAGE=$2
TYPE=$3

# ensure we're up to date
git pull

# bump version
docker run --rm -v "$PWD":/app treeder/bump $TYPE
version=`cat VERSION`
echo "version: $version"

# run build
make

# tag it
git add -A
git commit -m "version $version"
git tag -a "$version" -m "version $version"
git push
git push --tags

docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$version

# push it
docker push $USERNAME/$IMAGE:latest
docker push $USERNAME/$IMAGE:$version
