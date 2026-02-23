#!/usr/bin/env bash

set -uo pipefail

FLOAT_TERM="${1:-}"
LIST_PANES="$(tmux list-panes -F '#F')"
PANE_ZOOMED="$(echo "${LIST_PANES}" | grep Z)"
PANE_COUNT="$(echo "${LIST_PANES}" | wc -l | bc)"
CMD="$HOME/.opencode/bin/opencode"

if [ -n "${FLOAT_TERM}" ]; then
    if [ "$(tmux display-message -p -F "#{session_name}")" = "ai-popup" ]; then
        tmux detach-client
    else
        tmux popup -d '#{pane_current_path}' -S "bg=#0a0a0a,fg=#1c3762" -x110% -yC -w40% -h95% -E \
            "tmux attach -t ai-popup || tmux new -s ai-popup -c '#{pane_current_path}' -E '$CMD' \; set status off"
    fi
else
    if [ "${PANE_COUNT}" = 1 ]; then
        tmux split-window -c "#{pane_current_path}"
    elif [ -n "${PANE_ZOOMED}" ]; then
        tmux select-pane -t:.-
    else
        tmux resize-pane -Z -t1
    fi
fi
