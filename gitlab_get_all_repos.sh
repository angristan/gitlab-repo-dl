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

# Get total number of pages (with 20 projects per page) from HTTP header
TOTAL_PAGES=`curl "$GITLAB_URL/api/v4/projects?private_token=$GITLAB_TOKEN" -sI | grep X-Total-Pages | awk '{print $2}' | sed 's/\\r//g'`

for ((PAGE_NUMBER = 1; PAGE_NUMBER <= TOTAL_PAGES; PAGE_NUMBER++)); do
    # echo git@instance:namespace/repo.git
    curl "$GITLAB_URL/api/v4/projects?private_token=$GITLAB_TOKEN&per_page=20&page=$PAGE_NUMBER" | jq '.[] | .ssh_url_to_repo' | sed 's/"//g'
done
