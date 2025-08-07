#!/usr/bin/env bash

# Pick a session in a new tmux window so FZF gets a full TTY
tmux new-window -n "session-pick" "$HOME/dotfiles/scripts/tmux-sessionizer"
