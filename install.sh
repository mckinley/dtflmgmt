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

[[ -z "$GITHUB_USER" ]] && read -rp "Enter your github username: " GITHUB_USER
[[ -z "$GITHUB_REPO" ]] && read -rp "Enter your github repo name: " GITHUB_REPO

[[ -z "$GITHUB_USER" ]] && echo "GITHUB_USER is required" && exit 1
[[ -z "$GITHUB_REPO" ]] && echo "GITHUB_REPO is required" && exit 1

dotfiles() {
  git --git-dir="$GIT_DIR" --work-tree="$HOME" "$@"
}

echo "- Cloning repo to tmp dir: '$GIT_DIR' '$TMP_DIR'"
rm -rf "$GIT_DIR"
mkdir -p "$TMP_DIR"
git clone --separate-git-dir="$GIT_DIR" "git@github.com:$GITHUB_USER/$GITHUB_REPO.git" "$TMP_DIR"
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
