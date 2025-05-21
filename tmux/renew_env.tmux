#!/usr/bin/env bash

set -eu

# Refresh environment variables in all active, interactive shell panes in tmux.
#
# This script:
# - Lists all tmux panes across all sessions.
# - Filters for live panes running interactive shells (bash, zsh, ksh, fish).
# - Sends commands to each matching pane to:
#     1. Re-evaluate the tmux environment (via `eval "$(tmux show-env -s)"`)
#     2. Clear the terminal screen.
#
# Useful for propagating updated environment variables (e.g., after `ssh-agent` changes)
# without restarting tmux sessions.

pane_fmt="#{pane_id} #{pane_in_mode} #{pane_input_off} #{pane_dead} #{pane_current_command}"
tmux list-panes -s -F "$pane_fmt" | awk '
  $2 == 0 && $3 == 0 && $4 == 0 && $5 ~ /(bash|zsh|ksh|fish)/ { print $1 }
' | while read -r pane_id; do
  # renew environment variables according to update-environment tmux option
  # also clear screen
  tmux send-keys -t "$pane_id" 'Enter' 'eval "$(tmux show-env -s)"' 'Enter' 'C-l'
done;
