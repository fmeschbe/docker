#!/bin/env sh

GIT_DIR="checkout"
GIT_REPO="fmeschbe/webssh2"
GIT_BRANCH="fmeschbe/wrk"

DOCKERFILE="Dockerfile"

REGISTRY="registry.meschberger.ch"
REPOSITORY="${REGISTRY}/${GIT_REPO}"

LATEST="${REPOSITORY}:latest"
VERSION="${REPOSITORY}:$(date +%Y%m%d)"

# checkout or update the plexinc/pms-docker
if [ -d ${GIT_DIR} ] ; then
  cd ${GIT_DIR}
  git checkout "${GIT_BRANCH}"
  git pull --rebase
else
  git clone --branch "${GIT_BRANCH}" https://github.com/${GIT_REPO} ${GIT_DIR}
  cd ${GIT_DIR}
fi

# build the container
docker build -t ${LATEST} -t ${VERSION} -f "${DOCKERFILE}" .

# push the container to my registry
docker image push --all-tags "${REPOSITORY}"
