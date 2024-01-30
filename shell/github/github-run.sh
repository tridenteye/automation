#!/bin/bash
set -eu
SCRIPT_PATH="$(dirname -- "$(readlink -f "${BASH_SOURCE}")")"

#source ${SCRIPT_PATH}/variable.env
source ${SCRIPT_PATH}/github-lib.sh

#### ENV Variable ###
# Github cli env variable
export GH_HOST="github.com"

# Github details, like Org, Repos, 
REPO_ORG="${REPO_ORG:-tridenteye}"

# Branch to clone
BRANCH="${BRANCH:-main}"

# Dir to clones the repos
export CLONE_ROOT_DIR="rhnode18"

## File with list od repo to clone
REPO_LIST_FILE=repo-flat
REPO_LIST=${SCRIPT_PATH}/${REPO_LIST_FILE}

### PR ###
pr=''
MSG="Updated the rhnode to version 18"
ISSUE_ID="https://github.com/tridenteye/issue/issues/61103"

#Branch to checkout
export NEW_BRANCH="bhav-rhnode18"

case "$1" in
    clone)
        mkdir -p ${CLONE_ROOT_DIR}

        while read -r REPO
        do
            arrText+=("$REPO")
            echo "########################################################################################"
            echo "      ${BRANCH}:- ${GH_HOST}:${REPO_ORG}/${REPO} "
            git-clone
        done < ${REPO_LIST}
      ;;
    pr-create)
        CLONE_ROOT_DIR="${PWD}/${CLONE_ROOT_DIR}"
        for dir in ${CLONE_ROOT_DIR}/*
        do
            echo "########################################################################################"
            echo "  $dir    "
            echo "########################################################################################"
            pushd $dir
            pr-create
            echo $pr | tee -a ${CLONE_ROOT_DIR}/pr-${BRANCH}.list
            popd
        done
        echo "PR List: ####"
        cat ${CLONE_ROOT_DIR}/pr-${BRANCH}.list
      ;;
    *)
      echo "[ERROR] Unsupported Request"
      echo "github-run.sh [ clone | pr-create ]"
      exit 1
      ;;
esac
