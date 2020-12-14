#!/bin/bash

BRANCH_MASTER=master
BRANCH_DEVELOP=develop
BRANCH_CURRENT=$(git branch --show-current)
GIT_REMOTE_NAME=origin

branch_push() {
	if [[ $1 != '' ]]; then
		git push -u $GIT_REMOTE_NAME $1
	else
		git push -u $GIT_REMOTE_NAME $BRANCH_CURRENT
	fi
}

feature_start() {
	if [[ $1 != '' ]]; then
		git flow feature start $1
	else
		echo "You should enter feature name"
	fi
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

hotfix_start() {
	if [[ $1 != '' ]]; then
		git flow hotfix start $1
	else
		echo "You should enter hotfix name"
	fi
}

hotfix_send() {
	branch_push
	gh pr create \
		--head $BRANCH_CURRENT \
		--base $BRANCH_MASTER \
		--title "Merge $BRANCH_CURRENT to $BRANCH_MASTER" \
		--web
}

hotfix_done() {
	git checkout $BRANCH_MASTER
	git branch -D $BRANCH_CURRENT
	git push $GIT_REMOTE_NAME  --delete $BRANCH_CURRENT
	git pull origin $BRANCH_MASTER
}

# main
if [[ $1 == 'push' ]]; then branch_push $2
elif [[ $1 == 'feature-start' ]]; then feature_start $2
elif [[ $1 == 'feature-send' ]]; then feature_send
elif [[ $1 == 'feature-done' ]]; then feature_done
elif [[ $1 == 'hotfix-start' ]]; then hotfix_start $2
elif [[ $1 == 'hotfix-send' ]]; then hotfix_send
elif [[ $1 == 'hotfix-done' ]]; then hotfix_done
else
	echo "Please specify one of the actions"
fi
