#!/usr/bin/env bash

# `./revert.sh`
# Reverts to previous state of home directory.
# As the install script runs, it creates backups of all replaced files.
# This script will revert to the last backup.
# Each time the revert script is run, it will revert to the previous state of the home directory.
# The revert script will remove the last backup after reverting to it.

echo "Reverting dotfiles..."

BACKUPS_DIR="$DOTFILES_DIR/backups"
LAST_BACKUP="$BACKUPS_DIR/$(ls -tr "$BACKUPS_DIR" | tail -n 1)"

[[ -z "$LAST_BACKUP" ]] && echo "No backups where found at $BACKUPS_DIR." && return

echo "- Last backup: $LAST_BACKUP"

rsync --recursive --checksum --verbose \
  --exclude ".DS_Store" \
  "$LAST_BACKUP/" "$HOME/"
rm -rf "$LAST_BACKUP"

echo "Revert complete."

echo "Resetting shell"
exec zsh
