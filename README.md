# GitLab repositories downloader

Bash script to easily mass-download repos from a GitLab instance.

Get yourself an API token from you GitLab instance then export `GITLAB_URL` and `GITLAB_ENV`.

The script assume you will clone/pull over SSH.

Requirements: bash, curl, jq, sed, awk, grep

## Download all projects from a group

```sh
./gitlab-repo-dl.sh group <group_name>
```

It will clone all repos in `group_name` to the `./group_name` folder. If a repo already exists, it will be pulled.

It doesn't support subgroups.

## Download all project from a GitLab instance

This is seperated in two scripts to prevent an API brute-force everytime you want to clone/pull repositories.

First, get all the repositories names including their namespace (= the whole path):

```sh
./gitlab-repo-dl.sh all-repo-list > list.txt
```

This can take quite a long time because it will call the API for each page of the list of projects, with 20 projects per page.

Clone all the repositories from the list into a directory:

```sh
./gitlab-repo-dl.sh from-list list.txt .
```

This can take all long time for obvious reasons. When running the script multiple times, it will pull existing repositories.
