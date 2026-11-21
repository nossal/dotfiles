# vi: ft=tmux

if-shell 'env | grep -qE "SSH_CLIENT|SSH_CONNECTION"' {
    # sessões iniciadas via ssh não têm o PATH de login, e TPM/run-shell precisam achar o tmux
    set-environment -g PATH "/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    set -g update-environment "DISPLAY SSH_CONNECTION"
    set-environment -g SSH_AUTH_SOCK "$HOME/.ssh/agent.sock"

    set -g status-left  "#[fg=#FFFFFF,bg=#F80C0C,bold]  #S  #[fg=#CCCCCC,italics]remote  F12 "
}
