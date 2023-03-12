#!/bin/bash

REPO_NAME="${1:?Missing repository name}"
REPO_DESCRIPTION="${2:-$REPO_NAME repository}"
REPO_DEFAULT_BRANCH="${3}"
REPO_DIR="${GIT_PROJECT_ROOT}/${REPO_NAME}.git"

mkdir -p "${REPO_DIR}"
cd "${REPO_DIR}"

git init --bare &> /dev/null
touch git-daemon-export-ok
cp hooks/post-update.sample hooks/post-update
git update-server-info

MESSAGE="Git repository '${REPO_NAME}' (${REPO_DESCRIPTION}) created"

if [ -n "${REPO_DEFAULT_BRANCH}" ] ; then
  # rename current HEAD to the new default branch name
  git branch -M "${REPO_DEFAULT_BRANCH}"

  # create initial README to ensure the default branch
  TMPDIR=$(mktemp -d)
  (
    cd "${TMPDIR}"

    cat <<-EOF_README > README.md
	# ${REPO_NAME}

	${REPO_DESCRIPTION}
	EOF_README

    git init
    git add .
    git commit -m "Initial commit"
    git branch -M "${REPO_DEFAULT_BRANCH}"
    git remote add origin "${REPO_DIR}"
    git push -u origin "${REPO_DEFAULT_BRANCH}"
  ) &> /dev/null
  rm -rf "${TMPDIR}"

  MESSAGE="${MESSAGE} with default branch ${REPO_DEFAULT_BRANCH}"
fi

# ensure access by the web server...
echo "$REPO_DESCRIPTION" > description
chown -Rf www-data:www-data "${REPO_DIR}"

echo "${MESSAGE}"
