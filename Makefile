VERSION := $(shell git rev-parse HEAD)
ORB_VERSION := dev:$(VERSION)
ORB_NAME := remind101/docker-build@$(ORB_VERSION)
DOCKER_IMAGE := remind101/docker-build:$(VERSION)

.PHONY: lint
lint: orb.yml
	shellcheck docker-build
	circleci orb validate orb.yml

.PHONY: docker-image
docker-image:
	docker build -t "$(DOCKER_IMAGE)" .

.PHONY: push-docker-image
push-docker-image: docker-image
	docker push "$(DOCKER_IMAGE)"

.PHONY: publish-orb
publish-orb: orb.yml
	circleci orb publish orb.yml $(ORB_NAME)

orb.yml: orb.yml.tmpl
	sed 's/{{version}}/$(VERSION)/g' $< > $@
