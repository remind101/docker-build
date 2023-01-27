# docker-build

Remind's standardized script and CircleCI Orb for building and pushing Docker
images.

## Usage

Example usage in a `.circleci/config.yml` file:

```yaml
version: 2.1

orbs:
  docker-build: remind101/docker-build@1

workflows:
  main:
    jobs:
      - docker-build/build-push:
          context:
            - docker-hub
            - aws-ecr
```

See `docker-build --help` for more information on available commands.

## Behavior

Images are built using automatic `--cache-from` settings, with the
equivalent of the `docker build .` command.

Images are named after the repository that `docker-build` is being run on,
which is computed using the built-in CircleCI env vars:
`$CIRCLE_PROJECT_USERNAME/$CIRCLE_PROJECT_REPONAME`.

Multiple images are tagged by default:

- `latest`
- `${CIRCLECI_BRANCH}`
- `${CIRCLECI_BRANCH}-${CIRCLECI_BUILD_NUM}`
- `${CIRCLECI_SHA1}`

Images are published to Docker Hub and ECR.

The following env vars are required:

- `DOCKER_USER`
- `DOCKER_PASS`
- `AWS_ECR_ACCOUNT_URL`
- `AWS_REGION`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

### AWS ECR

When pushing to ECR, vulnerability scanning is performed automatically.

The orb also installs an ECR lifecycle policy by default. This policy reduces
the accumulation of unused images by expiring all images expect for those with
tags that have a `master` or `main` prefix after 90 days. Thus, this policy
assumes that images that are deployed come from the `main` or `master`
branches, and are tagged using `${CIRCLECI_BRANCH}-${CIRCLECI_BUILD_NUM}`.

## Releases

To release a new version, tag the release commit with `vX.Y.Z` (e.g. `v1.2.3`)
and `git push --tags`. CircleCI will publish release versions for any tag
starting with `v`.
