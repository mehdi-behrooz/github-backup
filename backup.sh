#!/bin/sh
set -e
set -o pipefail

echo "Running backup..."
cd /backups/

user="$GITHUB_USERNAME:$GITHUB_PASSWORD"
page=1
repos=""
error=0

while true; do

    url="https://api.github.com/user/repos?per_page=100&page=$page"

    result=$(curl -s -u $user $url | jq -r '.[] | .clone_url') || error=1
    [ -z "$result" ] && break

    repos="$repos$result"$'\n'

    page=$(( page + 1 ))

done


for repo in $repos; do

    repo_name=$(basename $repo)

    if [ -d "$repo_name" ]; then

        echo "Updating $repo_name..."
        git -C $repo_name fetch --all || error=1

    else

        git clone --mirror "$repo" || error=1

    fi

done

echo $error> $HEALTH_FLAG
