FROM docker:19.03-git

ENTRYPOINT /bin/sh

RUN apk add --update \
    make

COPY docker-build /usr/local/bin/docker-build
