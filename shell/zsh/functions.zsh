zsource() {
  local file=$1
  local zwc="${file}.zwc"
  if [[ -f "$file" && (! -f "$zwc" || "$file" -nt "$file") ]]; then
    zcompile "$file"
  fi
  source "$file"
}

_priv_func() {
  echo "Private Function"
}

function ssht() {
  ssh -t "$1" "/usr/local/bin/tmux new -A -s $2"
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

function reload() {
    exec "$SHELL" -l
    echo "Zsh config reloaded!"
}
