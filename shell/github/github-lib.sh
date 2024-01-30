#!/bin/bash
#set -eu
export GH_HOST="${GH_HOST:-github.com}"

gh-login() {
    gh auth login --hostname ${GH_HOST}
}
git-clone() {
    echo " --- Cloning repo ---"
    if [[ $(git ls-remote --heads git@${GH_HOST}:${REPO_ORG}/${REPO} ${BRANCH}) ]];
    then
        gh repo clone ${REPO_ORG}/${REPO} ${CLONE_ROOT_DIR}/${REPO}-${BRANCH} -- --branch ${BRANCH} 
        
    else
        echo "Branch: ${BRANCH} not present, skipping the git clone"
    fi
}

pr-create() {
    if [[ $(git diff --name-only) ]];
        then
            pr=''
            echo " --- checkout new branch ${NEW_BRANCH} ---"
            git checkout -b ${NEW_BRANCH}

            echo " --- git add, commit and push --- "
            git add -u ; git commit -am "${MSG}" ; git push -u origin ${NEW_BRANCH}
            
            echo " --- PR create ---"
            pr=$(gh pr create --title "${MSG}" --body "issue: ${ISSUE_ID}" -B ${BRANCH} 2>&1)
        else
            echo " --- No changes skipping PR creation --- "
        fi
}
