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
typeset -gA DEFERRED_PLUGINS

function load_plugins() {
  local -a sync_plugins=()
  local -a lazy_plugins=()

  # Parse arguments: prefix with "lazy:" to defer loading
  for plugin in $@; do
    if [[ $plugin == lazy:* ]]; then
      lazy_plugins+=("${plugin#lazy:}")
    else
      sync_plugins+=("$plugin")
    fi
  done

  # Load sync plugins immediately (essential ones)
  for plugin in $sync_plugins; do
    _load_single_plugin "$plugin"
  done

  # Defer lazy plugins until after prompt or first use
  for plugin in $lazy_plugins; do
    _defer_plugin "$plugin"
  done
}

function _load_single_plugin() {
  local plugin=$1
  local plugin_name=${plugin:t}  # Get repo name from path (e.g., "fzf-tab" from "unixorn/fzf-tab")
  local plugin_path="$ZSHDOTDIR/plugins/$plugin_name"

  # Clone if missing (only once per shell session)
  if [[ ! -d "$plugin_path" ]]; then
    git clone --depth 1 --quiet "https://github.com/$plugin.git" "$plugin_path" 2>/dev/null || return 1
  fi

  # Source the plugin file (try both conventions)
  local plugin_file
  if [[ -f "$plugin_path/$plugin_name.plugin.zsh" ]]; then
    plugin_file="$plugin_path/$plugin_name.plugin.zsh"
  elif [[ -f "$plugin_path/$plugin_name.zsh" ]]; then
    plugin_file="$plugin_path/$plugin_name.zsh"
  else
    echo "⚠️  Plugin file not found for: $plugin_name" >&2
    return 1
  fi

  # Source directly (bypass zsource wrapper for speed) or keep zsource if you need its features
  source "$plugin_file"
}

function _defer_plugin() {
  local plugin=$1
  local plugin_name=${plugin:t}
  local plugin_path="$ZSHDOTDIR/plugins/$plugin_name"

  # Ensure plugin is cloned (but don't source yet)
  if [[ ! -d "$plugin_path" ]]; then
    git clone --depth 1 --quiet "https://github.com/$plugin.git" "$plugin_path" 2>/dev/null || return
  fi

  # Determine file path
  local plugin_file
  if [[ -f "$plugin_path/$plugin_name.plugin.zsh" ]]; then
    plugin_file="$plugin_path/$plugin_name.plugin.zsh"
  elif [[ -f "$plugin_path/$plugin_name.zsh" ]]; then
    plugin_file="$plugin_path/$plugin_name.zsh"
  else
    return
  fi

  # Store for later loading
  DEFERRED_PLUGINS["$plugin_name"]="$plugin_file"

  # Load after prompt renders (non-blocking)
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd _load_deferred_plugins_once
}

function _load_deferred_plugins_once() {
  # Remove hook so this only runs once
  add-zsh-hook -d precmd _load_deferred_plugins_once

  # Source all deferred plugins
  for plugin_file in "${DEFERRED_PLUGINS[@]}"; do
    [[ -f "$plugin_file" ]] && source "$plugin_file"
  done

  # Clear array to free memory
  DEFERRED_PLUGINS=()
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

