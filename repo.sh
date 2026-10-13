#!/usr/bin/env bash

# `./repo.sh`
# Creates a new dotfiles repo on Github.

echo "Creating repo on Github..."
  
# DOTFILES_GITHUB_* are the documented names. The unprefixed GITHUB_* names are
# still read as a fallback for older setups.
DOTFILES_GITHUB_TOKEN="${DOTFILES_GITHUB_TOKEN:-$GITHUB_TOKEN}"
DOTFILES_GITHUB_REPO="${DOTFILES_GITHUB_REPO:-$GITHUB_REPO}"

[[ -z "$DOTFILES_GITHUB_TOKEN" ]] && read -rsp $'Enter your GitHub personal access token with "repo" permissions: \n' DOTFILES_GITHUB_TOKEN
[[ -z "$DOTFILES_GITHUB_REPO" ]] && read -rp "Enter your github repo name: " DOTFILES_GITHUB_REPO

[[ -z "$DOTFILES_GITHUB_TOKEN" ]] && echo "DOTFILES_GITHUB_TOKEN is required" && exit 1
[[ -z "$DOTFILES_GITHUB_REPO" ]] && echo "DOTFILES_GITHUB_REPO is required" && exit 1

echo "- Creating dotfiles repo on github and creating local dotfile and git dirs"
curl -H "Authorization: token $DOTFILES_GITHUB_TOKEN" https://api.github.com/user/repos -d "{\"name\":\"$DOTFILES_GITHUB_REPO\"}"

echo "Repo creation complete."
