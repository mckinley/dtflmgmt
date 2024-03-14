#!/usr/bin/env bash

# `./repo.sh`
# Creates a new dotfiles repo on Github.

echo "Creating repo on Github..."
  
[[ -z "$GITHUB_TOKEN" ]] && read -rsp $'Enter your GitHub personal access token with "repo" permissions: \n' GITHUB_TOKEN
[[ -z "$GITHUB_REPO" ]] && read -rp "Enter your github repo name: " GITHUB_REPO

[[ -z "$GITHUB_TOKEN" ]] && echo "GITHUB_TOKEN is required" && exit 1
[[ -z "$GITHUB_REPO" ]] && echo "GITHUB_REPO is required" && exit 1

echo "- Creating dotfiles repo on github and creating local dotfile and git dirs"
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user/repos -d "{\"name\":\"$GITHUB_REPO\"}"

echo "Repo creation complete."
