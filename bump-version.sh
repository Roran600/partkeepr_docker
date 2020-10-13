#!/usr/bin/env bash
#
# Copyright (C) 2014-2020, Markus Hubig <mhubig@gmail.com>
#
set -e

BRANCH_NAME="$(git symbolic-ref HEAD 2>/dev/null)"
BRANCH_NAME=${BRANCH_NAME##refs/heads/}

README_FILE="README.md"
README_TEMP=".README.md.new"

DOCKER_FILE="Dockerfile"
DOCKER_TEMP=".Dockerfile.new"

function push_hint () {
    MSG1="Now please push the changes and the new tag like this:"
    MSG2="git push && git push --tags"
    echo "$MSG1 $MSG2"
}

function update_readme () {
    sed -e "s/> The most resent version is: .*$/> The most resent version is: $1/g" \
        -e "s/bump-version\.sh .*/bump-version\.sh $1/g" \
        -e "s/(e.g. \`.*\`)/(e.g. \`$1\`)/g" \
        $README_FILE > $README_TEMP
}

function update_docker () {
    sed -e "s/^LABEL version=\".*\"$/LABEL version=\"$1\"/g" \
        $DOCKER_FILE > $DOCKER_TEMP
}

function commit_version () {
    git commit -m "Bumped version number to $1."
}

function tag_version () {
    git tag "$1"
}

if [ $# -ne 1 ]; then
    echo "usage: bump-version <version-id>"
    exit 1
fi

if [[ ! $BRANCH_NAME = master ]]; then
    echo "You need to be on master to use this script!"
    exit 1
fi

if ! update_readme "$1"; then
    echo "Could not bump version inside $README_FILE!" >&2
    exit 2
else
    mv $README_TEMP $README_FILE
    git add $README_FILE
fi

if ! update_docker "$1"; then
    echo "Could not bump version inside $DOCKER_FILE!" >&2
    exit 2
else
    mv $DOCKER_TEMP $DOCKER_FILE
    git add $DOCKER_FILE
fi

if ! commit_version "$1"; then
    echo "Could not commit the new version!" >&2
    exit 2
fi

if ! tag_version "$1"; then
    echo "Could not tag the new version!" >&2
    exit 2
fi

push_hint "$1"
