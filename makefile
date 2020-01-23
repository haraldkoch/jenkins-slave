USERNAME=haraldkoch
IMAGE=jenkins-slave
VERSION=`cat VERSION`

build:
	docker build -t ${USERNAME}/${IMAGE}:${VERSION}  -t ${USERNAME}/${IMAGE}:latest .

update:
	docker build --pull --no-cache -t ${USERNAME}/${IMAGE}:${VERSION}  -t ${USERNAME}/${IMAGE}:latest .

push:
	docker push ${USERNAME}/${IMAGE}

release:
	./release.sh ${USERNAME} ${IMAGE} patch
