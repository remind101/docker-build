`docker-build` is a small script for building, tagging and pushing docker images within CircleCI.

It makes the following assumptions:

1. Your docker registry repo and GitHub repo are the same (e.g. remind101/acme-inc on GitHub, remind101/acme-inc on Docker registry).
2. You want to tag the docker image with the value of the `$CIRLE_SHA1` (git commit sha) and `$CIRCLE_BRANCH` (git branch).

## Usage

**Build the image**

```console
$ docker-build build
```

Equivalent to:

```console
$ docker build -t "$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME" .
$ docker tag "$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME" \
  "$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME:$CIRCLE_SHA1"
$ docker tag "$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME" \
  "$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME:$CIRCLE_BRANCH"
```

**Push the resulting image to docker registry**

```console
$ docker-build push
```

Equivalent to:

```console
$ docker login -u $DOCKER_USER -p $DOCKER_PASS
$ docker push "$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME"
```

### Circle CI 2.0

To use this script, merge the following in to your `circle.yml`:

```yml
jobs:
  docker_image:
    docker:
      - image: remind101/docker-build
    steps:
      - checkout
      - setup_remote_docker
      - run: docker login -u $DOCKER_USER -p $DOCKER_PASS
      - run: docker-build
```

#### BuildKit Support

To build with BuildKit and leverage improvements to `--cache-from` and inline
cache metadata, set `DOCKER_BUILDKIT=1` in the environment and make sure you're
using at least Docker 19.03:

```yml
jobs:
  docker_image:
    docker:
      - image: remind101/docker-build
    environment:
      DOCKER_BUILDKIT: 1
    steps:
      - checkout
      - setup_remote_docker:
          version: 19.03.13
      - run: docker login -u $DOCKER_USER -p $DOCKER_PASS
      - run: docker-build
```
