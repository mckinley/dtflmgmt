#!/usr/bin/env bash

# `./config.sh`
# Sets up the local shell with dot and dotfile aliases.
# Configures shell to source ~/.zshrc.local if it exists.

echo "Configuring shell..."

[[ -z "$DOTFILES_DIR" ]] && DOTFILES_DIR="$HOME/.dotfiles"

GIT_DIR="$DOTFILES_DIR/git"

dotfiles() {
  git --git-dir="$GIT_DIR" --work-tree="$HOME" "$@"
}

echo "- Adding ~/.zshrc to dotfiles"
touch ~/.zshrc
dotfiles add ~/.zshrc

echo "- Adding dotfile config to ~/.zshrc"

echo "-- Adding dotfile aliases for home git dir"
{
  echo ""
  echo "# <Dotfiles>"
  echo "alias dotfiles='git --git-dir=$GIT_DIR --work-tree=\$HOME'"
  echo "alias dot=dotfiles"
} >> ~/.zshrc

echo "-- Adding ~/.zshrc.local detection"
{
  echo "[[ ! -f ~/.zshrc.local ]] || source ~/.zshrc.local"
  echo "# </Dotfiles>"
  echo ""
} >> ~/.zshrc

echo "Setup complete."

echo "Changes have been made to your .zshrc file."
echo "Please commit and push these changes to your new dotfiles repo on github."
echo "You may also want to add a .zshrc.local file to your home directory for local configuration that is not shared across your computers."
echo "cd"
echo "dot status"
echo "dot add ~/.zshrc"
echo "dot commit -m \"Configure shell for dotfiles\""
echo "dot push -u origin main"

echo "Resetting shell"
exec zsh
