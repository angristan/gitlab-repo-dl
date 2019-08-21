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
    echo "List file name required"
    exit 1;
fi

if [ -z "$2" ]
  then
    echo "Target directory required"
    exit 1;
fi

LIST_FILE="$1"
TARGET_DIR="$2"

if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
fi

while read REPO_SSH_URL; do
    REPO_PATH="$(echo "$REPO_SSH_URL" | awk -F':' '{print $NF}' | awk -F'.' '{print $1}')"

    if [ ! -d "$TARGET_DIR/$REPO_PATH" ]; then
        echo "git clone $REPO_PATH"
        git clone "$REPO_SSH_URL" "$TARGET_DIR/$REPO_PATH" --quiet
    else
        echo "git pull $REPO_PATH"
        cd "$TARGET_DIR/$REPO_PATH" && git pull --quiet
    fi
done < $LIST_FILE
