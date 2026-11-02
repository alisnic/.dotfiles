Andrei Lisnic's dotfiles
=========

These are config files for my MacOS + MacVim + Tmux setup

## Pi

Pi configuration lives in `pi/agent/`, including settings, model definitions,
extensions, and themes. Link it to Pi's default location on a fresh setup:

```sh
ln -s "$HOME/.dotfiles/pi" "$HOME/.pi"
```

If `~/.pi` already exists, check whether it points here before running the command.
Back up and merge any existing configuration before replacing a different directory
or symlink. Credentials, sessions, downloaded packages, and caches are ignored by Git.

## Herdr App

The `github-spaces` mod shows GitHub owner avatars in the spaces sidebar.
To install it, first check that the destination does not already exist, then run:

```sh
mkdir -p "$HOME/.config/herdr-app/mods" "$HOME/.config/herdr-app/data/github-avatars"
ln -s "$HOME/.dotfiles/herdr-app/mods/github-spaces" "$HOME/.config/herdr-app/mods/github-spaces"
```

Clone a layout and replace its `spaces` mod with `github-spaces`.
