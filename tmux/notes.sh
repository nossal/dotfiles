#!/usr/bin/env bash
set -uo pipefail

dir="$HOME/Documents/Notes"
session_name="notes"
CMD="nvim $dir"

if [ "$(tmux display-message -p -F "#{session_name}")" = "$session_name" ]; then
    tmux detach-client
else
    tmux popup -d "$dir" -s "bg=#0a0a0a" -S "bg=#0a0a0a,fg=#1c3762" -x10% -yC -w50% -h98% -E \
        "tmux attach -t $session_name || tmux new -s $session_name -c $dir -E '$CMD' \; set status off"
fi
