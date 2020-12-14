#!/bin/bash

BRANCH_DEVELOP=develop
BRANCH_CURRENT=$(git branch --show-current)
GIT_REMOTE_NAME=origin

start_dev() {
	echo "starting development"
}

feature_start() {
	git flow feature start $1
}

feature_send() {
	git push -u $GIT_REMOTE_NAME $BRANCH_CURRENT
	gh pr create \
		--head $BRANCH_CURRENT \
		--base $BRANCH_DEVELOP \
		-t "Merge $BRANCH_CURRENT to $BRANCH_DEVELOP" \
		--fill --web
}

# main
if [[ $1 == 'dev' ]]; then start_dev
elif [[ $1 == 'feature-start' ]]; then feature_start $2
elif [[ $1 == 'feature-send' ]]; then feature_send
else
	echo "Please specify one of the actions"
fi
