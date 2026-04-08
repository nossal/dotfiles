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

# Global array to track deferred plugins
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

  # Load sync plugins immediately
  for p in $sync; do _source_plugin "$p"; done

  # Defer lazy plugins
  for p in $lazy; do _defer_plugin "$p"; done
}

function _source_plugin() {
  local repo=$1 name=${repo:t}
  local dir="$ZSHDOTDIR/plugins/$name"

  [[ -d "$dir" ]] || git clone --depth 1 --quiet "https://github.com/$repo.git" "$dir" 2>/dev/null || return 1

  local f
  if [[ -f "$dir/$name.plugin.zsh" ]]; then f="$dir/$name.plugin.zsh"
  elif [[ -f "$dir/$name.zsh" ]]; then f="$dir/$name.zsh"
  else return 1; fi

  source "$f"
}

function _defer_plugin() {
  local repo=$1 name=${repo:t}
  local dir="$ZSHDOTDIR/plugins/$name"

  [[ -d "$dir" ]] || git clone --depth 1 --quiet "https://github.com/$repo.git" "$dir" 2>/dev/null || return

  local f
  if [[ -f "$dir/$name.plugin.zsh" ]]; then f="$dir/$name.plugin.zsh"
  elif [[ -f "$dir/$name.zsh" ]]; then f="$dir/$name.zsh"
  else return; fi

  _DEFERRED_PLUGINS["$name"]="$f"
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _load_deferred_plugins_once
}

function _load_deferred_plugins_once() {
  add-zsh-hook -d precmd _load_deferred_plugins_once
  local f
  for f in "${_DEFERRED_PLUGINS[@]}"; do
    [[ -f "$f" ]] && source "$f"
  done
  unset _DEFERRED_PLUGINS
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

