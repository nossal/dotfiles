#!/usr/bin/env bash

set -uo pipefail

CMD="$HOME/.opencode/bin/opencode"
dir_id=$(tmux display-message -p -F "#{pane_current_path}" | sed 's/\.//' | awk -F'/' '{print $(NF-1)"_"$NF}')
session_name="ai-popup-$dir_id"

if [ "$(tmux display-message -p -F "#{session_name}")" = "$session_name" ]; then
    tmux detach-client
else
    tmux popup -d '#{pane_current_path}' -s "bg=#0a0a0a" -S "bg=#0a0a0a,fg=#1c3762" -x112% -yC -w40% -h98% -E \
        "tmux attach -t $session_name || tmux new -s $session_name -c '#{pane_current_path}' -E '$CMD' \; set status off"
fi
