`docker-build` is a small script for building, tagging and pushing docker images within circle CI. We use this as a way of pre-building Docker images for Tugboat to deploy to Empire.

It makes the following assumptions:

1. Your docker registry repo and GitHub repo are the same (e.g. remind101/acme-inc on GitHub, remind101/acme-inc on Docker registry).
2. You want to tag the docker image with the value of the `$CIRLE_SHA1` (git commit sha) and `$CIRCLE_BRANCH` (git branch).
3. You're docker credentials are provided as `$DOCKER_EMAIL`, `$DOCKER_USER`, `$DOCKER_PASS`
4. If you're using a different registry than DockerHub then `$DOCKER_REGISTRY` is set. Please see [this blog post][private_registry] on the format of the registry url.

## Usage

**Build the image**

```console
$ docker-build build
```

Equivalent to:

```console
$ docker build --no-cache -t "$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME" .
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
$ docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASS
$ docker push "$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME"
```

### Circle CI

To use this script, merge the following in to your `circle.yml`:

```yml
machine:
  services:
    - docker

dependencies:
  pre:
    - curl https://raw.githubusercontent.com/remind101/docker-build/master/docker-build > /home/ubuntu/bin/docker-build
    - chmod +x /home/ubuntu/bin/docker-build
  override:
    - docker-build build

deployment:
  hub:
    branch: /.*/
    commands:
      - docker-build push
      - docker images
```

[private_registry]: https://blog.docker.com/2013/07/how-to-use-your-own-registry/
