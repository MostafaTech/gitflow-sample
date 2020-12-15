#!/bin/bash

BRANCH_MASTER=master
BRANCH_DEVELOP=develop
BRANCH_CURRENT=$(git branch --show-current)
GIT_REMOTE_NAME=origin

branch_pull() {
	if [[ $1 != '' ]]; then
		git pull $GIT_REMOTE_NAME $1
	else
		git pull $GIT_REMOTE_NAME $BRANCH_CURRENT
	fi
}

branch_push() {
	if [[ $1 != '' ]]; then
		git push -u $GIT_REMOTE_NAME $1
	else
		git push -u $GIT_REMOTE_NAME $BRANCH_CURRENT
	fi
}

feature_start() {
	if [[ $1 != '' ]]; then
		if [[ $BRANCH_CURRENT == $BRANCH_DEVELOP ]]; then
			git flow feature start $1
		else
			echo "You should be at $BRANCH_DEVELOP branch to start a feature"
		fi
	else
		echo "You should enter feature name"
	fi
}

feature_send() {
	if [[ $BRANCH_CURRENT == feature* ]]; then
		branch_push
		gh pr create \
			--head $BRANCH_CURRENT \
			--base $BRANCH_DEVELOP \
			--title "Merge $BRANCH_CURRENT to $BRANCH_DEVELOP" \
			--web
	else
		echo "You should be at a feature branch to send changes"
	fi
}

feature_done() {
	if [[ $BRANCH_CURRENT == feature* ]]; then
		git checkout $BRANCH_DEVELOP
		git branch -D $BRANCH_CURRENT
		git push $GIT_REMOTE_NAME --delete $BRANCH_CURRENT
		branch_pull $BRANCH_DEVELOP
	else
		echo "You should be at a feature branch to done it"
	fi
}

hotfix_start() {
	if [[ $1 != '' ]]; then
		git flow hotfix start $1
	else
		echo "You should enter hotfix name"
	fi
}

hotfix_send() {
	if [[ $BRANCH_CURRENT == hotfix* ]]; then
		branch_push
		gh pr create \
			--head $BRANCH_CURRENT \
			--base $BRANCH_MASTER \
			--title "Merge $BRANCH_CURRENT to $BRANCH_MASTER" \
			--web
	else
		echo "You should be at a hotfix branch to send changes"
	fi
}

hotfix_done() {
	if [[ $BRANCH_CURRENT == hotfix* ]]; then
		git checkout $BRANCH_MASTER
		git branch -D $BRANCH_CURRENT
		git push $GIT_REMOTE_NAME --delete $BRANCH_CURRENT
		branch_pull $BRANCH_MASTER
	else
		echo "You should be at a hotfix branch to done it"
	fi
}

# main
if [[ $1 == 'pull' ]]; then branch_pull $2
elif [[ $1 == 'push' ]]; then branch_push $2
elif [[ $1 == 'feature-start' ]]; then feature_start $2
elif [[ $1 == 'feature-send' ]]; then feature_send
elif [[ $1 == 'feature-done' ]]; then feature_done
elif [[ $1 == 'hotfix-start' ]]; then hotfix_start $2
elif [[ $1 == 'hotfix-send' ]]; then hotfix_send
elif [[ $1 == 'hotfix-done' ]]; then hotfix_done
else
	echo "Please specify one of the actions"
fi
