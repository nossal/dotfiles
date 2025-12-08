# vim: ft=tmux

if-shell 'env | grep -qE "SSH_CLIENT|SSH_CONNECTION"' {
    set -g @override_copy_command "nc localhost 9997"

    set -g status-left  "#[fg=#FFFFFF,bg=#F80C0C,bold]  #S  #[fg=#CCCCCC,italics]remote  F12 "
}
