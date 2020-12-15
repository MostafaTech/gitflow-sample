# Gitflow Sample
Version 0.2.0 [12-15-2020 03-30]

## Prerequisites
* gitflow
* github-cli

## Feature Workflow
Developers start with a feature:
```sh
$ ./project.sh feature-start my-awesome-feature
```
They do their works, add changes and commit their changes to the feature branch.

Then they send their feature branch to the github and make a pull-request with this command:
```sh
$ ./project.sh feature-send
```
It opens a web browser in gitgub to create a pull-request from `feature branch` to `develop branch`.
Project managers can review the codes and request for another changes. The developer can make more changes and after commiting the changes, pushes the rest of the changes to the remote branch with this command:
```sh
$ ./project.sh push
```
When the project managers reviewed the pull-request and approved the changes, they can merge the featue branch into the develop branch in github. After that, the developer can finish the feature by executing this command.
```sh
$ ./project.sh feature-done
```
This command deletes the feature branch from local and remote repositories and switches to the develop branch.

## Release workflow
Project managers can create release branches and merge them to master just like the git-flow way.
```sh
$ git flow release start '0.1.0'
... apply changes due to new release ...
... commit changes ...
$ git flow release finish '0.1.0'
$ ./project.sh push
```

## Hotfix workflow
Developers can start hotfixes on master branch just like the features.
```sh
$ ./project.sh hotfix-start a-critical-bugfix-on-master
```
It creates a hotfix branch from right from master. Developers can make their changes and commit to the hotfix branch and send a pull request to review and merge with this command:
```sh
$ ./project.sh hotfix-send
```
This command opens a browser to create pull-request page in github. Project managers can review and do their stuff with pull-request and then confirm the PR. After confirmation, the developer can use this command to finalize the hotfix and remove hotfix branch from local and remote repositories:
```sh
$ ./project.sh hotfix-done
```
