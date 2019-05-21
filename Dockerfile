FROM docker:17.05.0-ce-git
MAINTAINER Christophe Furmaniak <christophe.furmaniak@gmail.com>

ENTRYPOINT /bin/sh

COPY docker-build /usr/local/bin/docker-build
