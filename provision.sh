#!/usr/bin/env bash

# `./provision.sh`
# Installs software required by dtflmgmt.
# These instalations will not be cleaned up by the revert tool.

echo "Provisioning dotfiles..."

echo "- Installing Xcode Command Line Tools"
xcode-select --install

echo "- Installing Homebrew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "- Installing dependencies"
brew install \
  coreutils \
  git \
  rsync \
  zsh

echo "- Changing shell to zsh"
chsh -s "$(which zsh)"

echo "Provision complete."
echo "Please check homebrew output for any required manual steps."
