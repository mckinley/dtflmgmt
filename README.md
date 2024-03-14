# Dotfile Management Toolkit

### There are multiple use cases for managing dotfiles that dtflmgmt attempts to solve for:
- Setup a repository to track selected files in your home directory. This provides source control management for your dotfiles and anything else that you would like to track as standard configuration for all of your computers.
- When using a new computer, you can install the dotfiles from your repository. Any file that would be overwritten during the installation process is backed up so that the installation can be reverted.
- When temporarily using a computer, after installing your dotfiles, you can revert to the original state of the computer.
- An uninstall script is provided to completely remove all artifacts of the dtflmgmt toolkit.

Once everything is set up, you can treat your home directory as if it is a git repo with these main differences:
- instead of `git` use the alias `dotfiles` or `dot`. For example `dot status`.
- `status.showUntrackedFiles no` is used so only files that are explicitly added with `dot add` will show up with `dot status`
- `dot` explicitly sets the `git-dir` and `work-tree` directories. This means you can use `dot` within any directory and it will always reference your home directory.

When you make changes to your dotfiles and you want to share them with all computers using dtflmgmt, simply push your committed changes with `dot push`. Then you can pull changes on your other machines with `dot pull`

## New computer

### Ssh keys
https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent

### Personal access token
https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens

## Create new dotfile repository

```
DOTFILES_GITHUB_REPO="xxx"
DOTFILES_GITHUB_TOKEN="xxx"
```

`./provision.sh`

`./repo.sh`

`./install.sh`

`./config.sh`

## Install dotfiles

```
DOTFILES_GITHUB_REPO="xxx"
DOTFILES_GITHUB_USER="xxx"
```

`./provision.sh`

`./install.sh`

`./config.sh`

## Installs dependencies

`./provision.sh`

## Configure shell to use dotfiles and dot aliases

`./config.sh`

## Revert dotfiles that were changed by the install script

`./revert.sh`

## Remove all dtflmgmt artifacts

`./uninstall.sh`

## To use these scripts without cloning the repo, use the following pattern:

`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mckinley/dtflmgmt/master/[script])"`

example: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mckinley/dtflmgmt/master/install.sh)"`
