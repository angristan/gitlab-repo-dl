#!/usr/bin/env bash

if [ -z "$GITLAB_URL" ]; then
    echo "Missing environment variable: GITLAB_URL (e.g. https://gitlab.com)"
    exit 1
fi

if [ -z "$GITLAB_TOKEN" ]; then
    echo "Missing environment variable: GITLAB_TOKEN"
    echo "See ${GITLAB_URL}profile/account."
    exit 1
fi

if [ -z "$1" ]
  then
    echo "Group name is required."
    exit 1;
fi

GROUP_NAME="$1"

echo "Cloning all git projects in group $GROUP_NAME"

REPO_SSH_URLS=`curl -s "$GITLAB_URL/api/v4/groups/$GROUP_NAME/projects?private_token=$GITLAB_TOKEN&per_page=999" | jq '.[] | .ssh_url_to_repo' | sed 's/"//g'`

for REPO_SSH_URL in $REPO_SSH_URLS; do
    REPO_PATH="$GROUP_NAME/$(echo "$REPO_SSH_URL" | awk -F'/' '{print $NF}' | awk -F'.' '{print $1}')"

    if [ ! -d "$REPO_PATH" ]; then
        echo "git clone "$REPO_PATH""
        git clone "$REPO_SSH_URL" "$REPO_PATH" --quiet
    else
        echo "git pull $REPO_PATH"
        (cd "$REPO_PATH" && git pull --quiet)
    fi
done
