# docker-build

Docker CLI wrapper that injects defaults for a more consistent CI process.
Currently only works in CircleCI.

Images are named after the repository that `docker-build` is being run on,
which is computed using the built-in CircleCI env vars:
`$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME`

Running docker-build with no command will do the following automatically:
1. Log in to Docker Hub
2. Build with automatic cache-from
3. Push to the standard set of tags on Docker Hub
4. If `--ecr` is passed:
    1. Create an ECR repo if it doesn't exist
    2. Log in to ECR
    3. Push to the standard set of tags on ECR

## Usage

TL;DR put this in `.circleci/config.yml`:

```yaml
version: 2.1

workflows:
  main:
    jobs:
      - docker_image:
          context:
            - docker-hub
            - aws-ecr

jobs:
  docker_image:
    docker:
      # build docker images and push them into a remote docker hub.
      - image: remind101/docker-build
    environment:
      DOCKER_BUILDKIT: 1
    steps:
      - checkout
      - setup_remote_docker:
          version: 20.10.14
      # build, tag and push to Docker Hub and AWS ECR
      - run: docker-build --ecr
      # idempotent put of ECR lifecycle policy
      - run: docker-build aws-ecr-put-default-lifecycle-policy
```

See `docker-build --help` for more information on available commands.

## Standard Tags

The following tags (as in,
`$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME:<tag>`) are published by
default:

- `latest`
- `${CIRCLECI_BRANCH}`
- `${CIRCLECI_BRANCH}-${CIRCLECI_BUILD_NUM}`
- `${CIRCLECI_SHA1}`

## BuildKit

To build with BuildKit and leverage improvements to `--cache-from` and inline
cache metadata, set `DOCKER_BUILDKIT=1` in the environment and make sure you're
using at least Docker 19.03:

```yml
jobs:
  docker_image:
    docker:
      - image: remind101/docker-build
    environment:
      DOCKER_BUILDKIT: 1
    steps:
      - checkout
      - setup_remote_docker:
          version: 20.10.14
      - run: docker-build
```

## AWS ECR

The `docker-build --ecr` command attempts to create and push to ECR
repositories if the following environment variables are present:

- `AWS_ECR_ACCOUNT_URL`
- `AWS_REGION`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

A [standard lifecycle policy](default-ecr-lifecycle-policy.json) can also be
applied using `docker-build aws-ecr-put-default-lifecycle-policy`. This is not
done by default because it is has the potential to delete images being used in
production if they are not being tagged properly. This policy reduces the
accumulation of unused images by expiring all images expect for those with tags
that have a `master` or `main` prefix after 90 days. Thus, this policy assumes
that images that are deployed come from the `main` or `master` branches, and
are tagged using `${CIRCLECI_BRANCH}-${CIRCLECI_BUILD_NUM}`.
test
