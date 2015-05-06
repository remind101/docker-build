`docker-build` is a small script for building, tagging and pushing docker images within circle CI.

It makes the following assumptions:

1. Your docker registry repo and GitHub repo are the same (e.g. remind101/acme-inc on GitHub, remind101/acme-inc on Docker registry).
2. You want to tag the docker image with the value of the `$CIRLE_SHA1` (git commit sha) and `$CIRCLE_BRANCH` (git branch).
3. You're docker credentials are provided as `$DOCKER_EMAIL`, `$DOCKER_USER`, `$DOCKER_PASS`

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
dependencies:
  pre:
    - curl https://raw.githubusercontent.com/remind101/docker-build/script/docker-build > /home/ubuntu/bin/docker-build
    - chmod +x /home/ubuntu/bin/docker-build

deployment:
  hub: 
    branch: /.*/
    commands:
      - docker-build push
      - docker images
```
