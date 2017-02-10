USERNAME=haraldkoch
IMAGE=jenkins-slave

all:
	docker build -t ${USERNAME}/${IMAGE}:latest .

push:
	docker push ${USERNAME}/${IMAGE}:latest

release:
	./release.sh ${USERNAME} ${IMAGE} patch
