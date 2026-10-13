# dtflmgmt

A small toolkit of bash scripts for managing dotfiles with a "bare" git repo whose work tree
is `$HOME`. It sets up a GitHub repo to track chosen home-directory files, installs them on a
new computer (backing up every file it replaces), reverts a borrowed computer to how it
was, and uninstalls itself. Afterwards the `dotfiles` / `dot` alias works like `git` from any
directory: `dot status`, `dot add ~/.zshrc`, `dot push`. `status.showUntrackedFiles no` means
only explicitly added files show up.

## Scripts

There's no build, package manager, test suite or CI. Each script is standalone, and the
README shows how to run any of them straight from GitHub with
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mckinley/dtflmgmt/master/<script>)"`.

| Script | What it does |
|---|---|
| `provision.sh` | macOS only: Xcode CLT, Homebrew (Apple Silicon path `/opt/homebrew`), `coreutils git rsync zsh`, `chsh` to zsh. |
| `repo.sh` | Creates the GitHub repo through the API. Uses `DOTFILES_GITHUB_TOKEN` and `DOTFILES_GITHUB_REPO`, and prompts for missing ones. |
| `install.sh` | Clones `git@github.com:$DOTFILES_GITHUB_USER/$DOTFILES_GITHUB_REPO.git` (SSH) with `--separate-git-dir=$DOTFILES_DIR/git`, then rsyncs it over `$HOME`. Replaced files go to `$DOTFILES_DIR/backups/<date>`. |
| `config.sh` | Adds `~/.zshrc` to the repo and appends a `# <Dotfiles>` ... `# </Dotfiles>` block with the aliases and a `~/.zshrc.local` loader. Skips the block if a `# <Dotfiles>` line is already there. |
| `revert.sh` | Restores the newest backup into `$HOME`, then deletes that backup. Run it again to step further back. Exits 1 when there are no backups. |
| `uninstall.sh` | Removes the `# <Dotfiles>` ... `# </Dotfiles>` lines from `~/.zshrc` (with awk, since `sed -i` differs between BSD and GNU) and deletes `$DOTFILES_DIR`. It copies backups to `~/dotfile-history` first unless you pass `--delete-backups`. |

Layout on disk: `DOTFILES_DIR` defaults to `~/.dotfiles`, with `git/` (the repo),
`backups/` and a transient `tmp/`. Most scripts end with `exec zsh` to reload the shell.

## Releasing

There's nothing to deploy. Users run the scripts from the default branch, either a clone
or the raw GitHub URLs above, so a push to `main` is a release. The README's raw URLs say
`master`; they still resolve, but `main` is the real branch.

## Rules and gotchas

- These scripts overwrite and delete files in a real home directory. Don't run them on
  your own machine to test a change. Use a throwaway user or VM, and point `DOTFILES_DIR`
  somewhere disposable.
- `install.sh` runs `rm -rf "$DOTFILES_DIR/git"` first. Reinstalling discards unpushed
  dotfile commits.
- The public repo must not contain anyone's tokens, hostnames or personal paths. Tokens
  come only from env vars or prompts.
- The env vars are `DOTFILES_GITHUB_USER`, `DOTFILES_GITHUB_REPO` and
  `DOTFILES_GITHUB_TOKEN`. The unprefixed `GITHUB_*` names are only a fallback for old
  setups; don't document them as the main names.
- The README's `/bin/bash -c "$(curl ...)"` pattern runs the scripts under macOS's
  bash 3.2, so keep them 3.2-compatible (no `mapfile`, associative arrays or `${var,,}`).
- To test a change, run the script with a throwaway home and a clean environment, e.g.
  `env -i HOME="$(mktemp -d)" PATH="$PATH" /bin/bash ./config.sh </dev/null`. For
  `install.sh`, point `git@github.com:` at a local bare repo with a `url.<path>.insteadOf`
  entry in a config file passed through `GIT_CONFIG_GLOBAL`.

This project is tracked in the pjmgmt HQ: mckinley/pjmgmt, hq/projects/dotfile-management.md.
