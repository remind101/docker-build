`docker-build` is a small Go program for building, tagging and pushing docker images within circle CI.

It makes the following assumptions:

1. Your docker registry repo and GitHub repo are the same (e.g. remind101/acme-inc on GitHub, remind101/acme-inc on Docker registry).
2. You want to tag the docker image with the value of the `$CIRLE_SHA1` (git commit sha).
3. You're docker credentials are provided as `$DOCKER_EMAIL`, `$DOCKER_USER`, `$DOCKER_PASS`

## Usage

**Build the image**

```console
$ docker-build build
```


**Push the resulting image to docker registry**

```console
$ docker-build push
```
