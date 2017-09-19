FROM alpine:3.2
MAINTAINER Christophe Furmaniak <christophe.furmaniak@gmail.com>

RUN apk add --update curl bash git \
  && curl -L https://download.docker.com/linux/static/stable/x86_64/docker-17.03.1-ce.tgz > /tmp/docker.tgz \
  && tar xzvf /tmp/docker.tgz \
  && cp docker/docker /usr/bin/docker \
  && rm -rf /tmp/docker* \
  && rm -rf /var/cache/apk/*

ADD docker-build /usr/local/bin/docker-build
