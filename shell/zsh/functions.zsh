# Function to source files if they exist
function source_file() {
  [ -f "$ZSHDOTDIR/$1" ] && source "$ZSHDOTDIR/$1"
}

function load_plugins() {
  for plugin in $@; do
    plugin_name=$(echo $plugin | cut -d "/" -f 2)

    if [ ! -d "$ZSHDOTDIR/plugins/$plugin_name" ]; then
      git clone "https://github.com/$plugin.git" "$ZSHDOTDIR/plugins/$plugin_name"
    fi

    # echo "$plugin_name"
    source_file "plugins/$plugin_name/$plugin_name.plugin.zsh" ||
      source_file "plugins/$plugin_name/$plugin_name.zsh"
  done
}

function zsh_add_completion() {
  plugin_name=$(echo $1 | cut -d "/" -f 2)
  if [ -d "$ZSHDOTDIR/completions/$plugin_name" ]; then
    # For completions
    completion_file_path=$(ls $ZSHDOTDIR/completions/$plugin_name/*/_*)
    fpath+="$(dirname "${completion_file_path}")"
    source_file "completions/$plugin_name/$plugin_name.plugin.zsh"
  else
    git clone "https://github.com/$1.git" "$ZSHDOTDIR/completions/$plugin_name"
    fpath+=$(ls $ZSHDOTDIR/completions/$plugin_name/*/_*)
    [ -f $ZSHDOTDIR/.zccompdump ] && $ZSHDOTDIR/.zccompdump
  fi
  completion_file="$(basename "${completion_file_path}")"
  [ "$2" = true ] && compinit "${completion_file:1}"
}

_priv_func() {
  echo "Private Function"
}

function ssht() {
  /usr/bin/ssh -t "$@" "tmux attach || tmux new"
}

function hostname() {

  echo $(cat /proc/sys/kernel/hostname)
}

function zv() {
  __zoxide_zi "$@" && nvim
}

function o() {
  case "$(uname -s)" in
  Darwin)
    open "$@"
    ;;
  Linux)
    if command -v xdg-open >/dev/null; then
      xdg-open "$@"
    elif command -v wsl-open >/dev/null; then
      wsl-open "$@"
    else
      echo "Neither xdg-open nor wsl-open are available"
      return 1
    fi
    ;;
  *)
    echo "Unsupported operating system"
    return 1
    ;;
  esac
}
