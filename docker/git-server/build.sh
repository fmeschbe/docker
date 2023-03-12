#!/bin/env sh


DOCKERFILE="Dockerfile"

REGISTRY="registry.meschberger.ch"
REPOSITORY="${REGISTRY}/fmeschbe/git-server"

LATEST="${REPOSITORY}:latest"
VERSION="${REPOSITORY}:$(date +%Y%m%d)"

# build the container
docker build -t ${LATEST} -t ${VERSION} -f "${DOCKERFILE}" .

# push the container to my registry
docker image push --all-tags "${REPOSITORY}"
