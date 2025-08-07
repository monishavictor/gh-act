#!/bin/bash

printenv

# echo "Check if PR \"$TRAVIS_BRANCH\" has a feature app label."

if ! command -v gh &> /dev/null
then
    echo "Github CLI was not found, installing..."

    curl -sSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

    sudo apt-get update
    sudo apt-get install gh

    gh auth status
fi

existing_pull_requests=$(gh pr list -H $GITHUB_HEAD_REF --repo $GITHUB_REPOSITORY --state open --limit 1 --label "Feature App")

if [[ -z "$existing_pull_requests" ]]; then
    echo "No pull requests found for branch $GITHUB_HEAD_REF or release branch with the label Feature App attached."
    exit 0
else
    echo "${existing_pull_requests}"
    echo "Pull requests found for branch $GITHUB_HEAD_REF with the label Feature App attached."
    exit 0
fi
