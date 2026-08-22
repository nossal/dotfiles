#!/usr/bin/env bash
set -euo pipefail

# CMD="$HOME/.opencode/bin/opencode"
CMD="$HOME/.local/share/mise/shims/pi"

current_path="$(tmux display-message -p -F '#{pane_current_path}')"
dir_id=$(printf '%s\n' "$current_path" | sed 's/\.//' | awk -F'/' '{print $(NF-1)"_"$NF}')
session_name="ai-popup-$dir_id"

if [ "$(tmux display-message -p -F "#{session_name}")" = "$session_name" ]; then
    tmux detach-client
    exit 0
else
    tmux popup -d '#{pane_current_path}' -s "bg=#0a0a0a" -S "bg=#0a0a0a,fg=#1c3762" -x112% -yC -w40% -h98% -E \
        "tmux new-session -A -s $session_name -c '#{pane_current_path}' -E 'zsh -l -c \"$CMD\"' \; set status off"
        # "tmux attach -t $session_name 2>/dev/null || tmux new-session -s $session_name -c '#{pane_current_path}' -E 'zsh -l -c \"$CMD\"' \; set status off"
        # "tmux new-session -A -s $session_name -c '#{pane_current_path}' \; set status off \; send-keys '$CMD; tmux kill-session -t $session_name' Enter"
        # "tmux attach -t $session_name 2>/dev/null || tmux new-session -s $session_name -c '#{pane_current_path}' \; set status off \; send-keys '$CMD; tmux kill-session -t $session_name' Enter"
fi
