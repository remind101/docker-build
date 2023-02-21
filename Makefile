COMMIT_HASH := $(shell git rev-parse HEAD)
# ORB_VERSION defaults to a dev version based on the git hash, but can be
# overridden with a semver to publish a release.
ORB_VERSION := dev:$(COMMIT_HASH)
ORB_NAME := remind101/docker-build@$(ORB_VERSION)
DOCKER_IMAGE := remind101/docker-build:$(COMMIT_HASH)

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
	circleci orb publish orb.yml "$(ORB_NAME)"

orb.yml: orb.tmpl.yml
	sed 's|{{docker_image}}|$(DOCKER_IMAGE)|g' $< > $@
