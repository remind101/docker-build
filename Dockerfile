FROM docker:19.03-git

ENTRYPOINT /bin/sh

RUN apk --no-cache add \
    docker-compose \
    make

COPY docker-build /usr/local/bin/docker-build
