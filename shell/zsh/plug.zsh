# ~/.dotfiles/shell/zsh/plug.zsh
typeset -gA _DEFERRED_PLUGINS

function load_plugins() {
  local -a sync=() lazy=()
  for p in "$@"; do
    if [[ $p == lazy:* ]]; then
      lazy+=("${p#lazy:}")
    else
      sync+=("$p")
    fi
  done

  for p in $sync; do _load_sync "$p"; done
  for p in $lazy; do _load_defer "$p"; done
}

function _check_plugin() {
  local plugin=$1
  local plugin_name=${plugin:t}
  local plugin_dir="$ZSHDOTDIR/plugins/$plugin_name"

  if [[ ! -d "$plugin_dir" ]]; then
    git clone --depth 1 --quiet "https://github.com/$plugin.git" "$plugin_dir" 2>/dev/null || return 1
  fi
}

function _load_sync() {
  local plugin=$1
  local plugin_name=${plugin:t}

  _check_plugin "$plugin" || return 1

  source_file "plugins/$plugin_name/$plugin_name.plugin.zsh" 2>/dev/null ||
  source_file "plugins/$plugin_name/$plugin_name.zsh" 2>/dev/null
}

function _load_defer() {
  local plugin=$1
  local plugin_name=${plugin:t}
  local plugin_dir="$ZSHDOTDIR/plugins/$plugin_name"

  _check_plugin "$plugin" || return 1

  # Resolve absolute path for precmd execution
  local target=""
  if [[ -f "$plugin_dir/$plugin_name.plugin.zsh" ]]; then
    target="$plugin_dir/$plugin_name.plugin.zsh"
  elif [[ -f "$plugin_dir/$plugin_name.zsh" ]]; then
    target="$plugin_dir/$plugin_name.zsh"
  else
    return 1
  fi

  _DEFERRED_PLUGINS["$plugin_name"]="$target"
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _flush_deferred_plugins
}

function _flush_deferred_plugins() {
  add-zsh-hook -d precmd _flush_deferred_plugins
  local f
  for f in "${_DEFERRED_PLUGINS[@]}"; do
    [[ -f "$f" ]] && source "$f"
  done
  unset _DEFERRED_PLUGINS
}

# Function to source files if they exist
function source_file() {
  [ -f "$ZSHDOTDIR/$1" ] && zsource "$ZSHDOTDIR/$1"
}

function update_plugins() {
  for plugin in $@; do
    plugin_name=$(echo $plugin | cut -d "/" -f 2)
    cd "$ZSHDOTDIR/plugins/$plugin_name" &&  git pull --ff-only 2>/dev/null;
    cd - > /dev/null
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

