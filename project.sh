#!/bin/bash

BRANCH_DEVELOP=develop
BRANCH_CURRENT=$(git branch --show-current)
GIT_REMOTE_NAME=origin

start_dev() {
	echo "starting development"
}

branch_push() {
	if [[ $1 != '' ]]; then
		git push -u $GIT_REMOTE_NAME $1
	else
		git push -u $GIT_REMOTE_NAME $BRANCH_CURRENT
	fi
}

feature_start() {
	git flow feature start $1
}

feature_send() {
	branch_push
	gh pr create \
		--head $BRANCH_CURRENT \
		--base $BRANCH_DEVELOP \
		--title "Merge $BRANCH_CURRENT to $BRANCH_DEVELOP" \
		--web
}

feature_done() {
	git checkout $BRANCH_DEVELOP
	git branch -D $BRANCH_CURRENT
	git push $GIT_REMOTE_NAME  --delete $BRANCH_CURRENT
	git pull origin $BRANCH_DEVELOP
}

# main
if [[ $1 == 'dev' ]]; then start_dev
elif [[ $1 == 'push' ]]; then branch_push $2
elif [[ $1 == 'feature-start' ]]; then feature_start $2
elif [[ $1 == 'feature-send' ]]; then feature_send
elif [[ $1 == 'feature-done' ]]; then feature_done
else
	echo "Please specify one of the actions"
fi
