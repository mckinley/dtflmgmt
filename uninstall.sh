#!/usr/bin/env bash

# `./uninstall.sh`
# Uninstalls dotfiles.
# $BACKUPS_DIR will only be completely deleted if --delete-backups flag is passed: `./uninstall.sh --delete-backups`.
# Otherwise, backups will be copied to new directory at $Home/dotfile-history.

echo "Uninstalling dotfiles..."

[[ -z "$DOTFILES_DIR" ]] && DOTFILES_DIR="$HOME/.dotfiles"

BACKUPS_DIR="$DOTFILES_DIR/backups"
PRESERVED_BACKUPS_DIR="$HOME/dotfile-history"
ZSHRC="$HOME/.zshrc"

echo "- Removing dotfile config from ~/.zshrc"
if [[ ! -f "$ZSHRC" ]] || ! grep -qxF "# <Dotfiles>" "$ZSHRC"; then
  echo "-- No '# <Dotfiles>' block found in ~/.zshrc"
else
  ZSHRC_TMP="$(mktemp "${TMPDIR:-/tmp}/dtflmgmt-zshrc.XXXXXX")" || exit 1
  # Drop every line from "# <Dotfiles>" through "# </Dotfiles>", the block that
  # config.sh adds. awk instead of `sed -i` because BSD and GNU sed disagree on -i.
  # If a block has no closing marker, exit 2 and leave the file alone.
  if awk '
    in_block { if ($0 == "# </Dotfiles>") in_block = 0; next }
    $0 == "# <Dotfiles>" { in_block = 1; next }
    { print }
    END { if (in_block) exit 2 }
  ' "$ZSHRC" > "$ZSHRC_TMP"; then
    # Write back in place so the file keeps its permissions (and stays a symlink if it is one).
    cat "$ZSHRC_TMP" > "$ZSHRC"
  else
    echo "-- Found '# <Dotfiles>' with no closing '# </Dotfiles>', so ~/.zshrc was left unchanged" >&2
  fi
  rm -f "$ZSHRC_TMP"
fi

if [[ "$1" != "--delete-backups" && -d "$BACKUPS_DIR" ]]; then
  echo "- Preserving dotfile history to '$PRESERVED_BACKUPS_DIR'"
  if ! { mkdir -p "$PRESERVED_BACKUPS_DIR" && cp -R "$BACKUPS_DIR/." "$PRESERVED_BACKUPS_DIR/"; }; then
    echo "Copying backups to $PRESERVED_BACKUPS_DIR failed, so $DOTFILES_DIR was not removed." >&2
    exit 1
  fi
fi

echo "- Removing dotfile dir"
rm -rf "$DOTFILES_DIR"

echo "Uninstall complete."

echo "Resetting shell"
exec zsh
