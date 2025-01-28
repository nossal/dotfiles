
pane_by_name() {
    pane_name="$1"
    pane_id=$(tmux list-panes -F '#{pane_id} #{pane_title}' | awk -v name="$pane_name" '$2 == name {print $1}')
    echo "$pane_id"
}
fu
