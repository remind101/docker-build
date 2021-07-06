FROM docker:20.10.7

ENTRYPOINT /bin/sh

RUN apk --no-cache add \
    docker-compose \
    git \
    make

COPY docker-build /usr/local/bin/docker-build
