FROM docker:20.10.16

ENTRYPOINT ["/bin/sh"]

# hadolint ignore=DL3018
RUN apk --no-cache add \
    git \
    make \
    aws-cli

COPY default-ecr-lifecycle-policy.json /default-ecr-lifecycle-policy.json
COPY docker-build /usr/local/bin/docker-build
