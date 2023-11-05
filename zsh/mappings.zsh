
alias nv="neovide.exe --wsl --multigrid"


alias ls="lsd"
alias ll="ls -l"
alias la="ll -a"
alias lt="ls --tree"

alias xclip="xclip -selection clipboard"
alias v="fd --type f --hidden --exclude 'node_modules .m2 .git' | fzf-tmux -p --reverse | xargs nvim"
