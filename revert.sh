#!/usr/bin/env bash

# `./revert.sh`
# Reverts to previous state of home directory.
# As the install script runs, it creates backups of all replaced files.
# This script will revert to the last backup.
# Each time the revert script is run, it will revert to the previous state of the home directory.
# The revert script will remove the last backup after reverting to it.

echo "Reverting dotfiles..."

[[ -z "$DOTFILES_DIR" ]] && DOTFILES_DIR="$HOME/.dotfiles"

BACKUPS_DIR="$DOTFILES_DIR/backups"

# install.sh names each backup dir YYYY-MM-DD-<epoch seconds>, so the newest sorts last.
LAST_BACKUP=""
if [[ -d "$BACKUPS_DIR" ]]; then
  LAST_BACKUP="$(find "$BACKUPS_DIR" -mindepth 1 -maxdepth 1 -type d | sort | tail -n 1)"
fi

if [[ -z "$LAST_BACKUP" ]]; then
  echo "No backups were found at $BACKUPS_DIR." >&2
  exit 1
fi

echo "- Last backup: $LAST_BACKUP"

if ! rsync --recursive --checksum --verbose \
  --exclude ".DS_Store" \
  "$LAST_BACKUP/" "$HOME/"; then
  echo "Restoring from $LAST_BACKUP failed. The backup has been kept." >&2
  exit 1
fi
rm -rf "$LAST_BACKUP"

echo "Revert complete."

echo "Resetting shell"
exec zsh
