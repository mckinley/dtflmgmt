#!/usr/bin/env bash

# `./install.sh`
# Installs home dotfiles.
# Backups of all replaced files are saved and can be reverted with the revert tool.

echo "Installing dotfiles..."

[[ -z "$DOTFILES_DIR" ]] && DOTFILES_DIR="$HOME/.dotfiles"

BACKUPS_DIR="$DOTFILES_DIR/backups"
BACKUP_DIR="$BACKUPS_DIR/$(date +%Y-%m-%d-%s)"
GIT_DIR="$DOTFILES_DIR/git"
TMP_DIR="$DOTFILES_DIR/tmp"

# DOTFILES_GITHUB_* are the documented names. The unprefixed GITHUB_* names are
# still read as a fallback for older setups.
DOTFILES_GITHUB_USER="${DOTFILES_GITHUB_USER:-$GITHUB_USER}"
DOTFILES_GITHUB_REPO="${DOTFILES_GITHUB_REPO:-$GITHUB_REPO}"

[[ -z "$DOTFILES_GITHUB_USER" ]] && read -rp "Enter your github username: " DOTFILES_GITHUB_USER
[[ -z "$DOTFILES_GITHUB_REPO" ]] && read -rp "Enter your github repo name: " DOTFILES_GITHUB_REPO

[[ -z "$DOTFILES_GITHUB_USER" ]] && echo "DOTFILES_GITHUB_USER is required" && exit 1
[[ -z "$DOTFILES_GITHUB_REPO" ]] && echo "DOTFILES_GITHUB_REPO is required" && exit 1

dotfiles() {
  git --git-dir="$GIT_DIR" --work-tree="$HOME" "$@"
}

echo "- Cloning repo to tmp dir: '$GIT_DIR' '$TMP_DIR'"
rm -rf "$GIT_DIR"
mkdir -p "$TMP_DIR"
git clone --separate-git-dir="$GIT_DIR" "git@github.com:$DOTFILES_GITHUB_USER/$DOTFILES_GITHUB_REPO.git" "$TMP_DIR"
dotfiles config --local status.showUntrackedFiles no

echo "- Syncing home dir with tmp repo and creating backups of replaced files: '$BACKUP_DIR'"
rsync --backup --recursive --checksum --verbose \
  --backup-dir="$BACKUP_DIR" \
  --exclude={.DS_Store,.git} \
  "$TMP_DIR/" "$HOME/"

echo "- Removing tmp repo"
rm -rf "$TMP_DIR"

echo "Install complete."

echo "Resetting shell"
exec zsh
