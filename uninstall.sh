#!/usr/bin/env bash

# `./uninstall.sh`
# Uninstalls dotfiles.
# $BACKUPS_DIR will only be completely deleted if --delete-backups flag is passed: `./uninstall.sh --delete-backups`.
# Otherwise, backups will be copied to new directory at $Home/dotfile-history.

echo "Uninstalling dotfiles..."

[[ -z "$DOTFILES_DIR" ]] && DOTFILES_DIR="$HOME/.dotfiles"

BACKUPS_DIR="$DOTFILES_DIR/backups"
PRESERVED_BACKUPS_DIR="$HOME/dotfile-history"

echo "- Removing dotfile config from ~/.zshrc"
sed 's/# <Dotfiles>.*<\/Dotfiles>//'

if [[ "$1" != "--delete-backups" ]]; then
  echo "- Preserving dotfile history to '$PRESERVED_BACKUPS_DIR'"
  cp -r "$BACKUPS_DIR" "$PRESERVED_BACKUPS_DIR"
fi

echo "- Removing dotfile dir"
rm -rf "$DOTFILES_DIR"

echo "Uninstall complete."

echo "Resetting shell"
exec zsh
