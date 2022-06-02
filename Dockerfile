FROM docker:20.10.16

ENTRYPOINT ["/bin/sh"]

RUN apk --no-cache add \
    git \
    make

COPY docker-build /usr/local/bin/docker-build
