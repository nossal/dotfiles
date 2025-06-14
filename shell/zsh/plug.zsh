# Function to source files if they exist
function source_file() {
  [ -f "$ZSHDOTDIR/$1" ] && source "$ZSHDOTDIR/$1"
}

function update_plugins() {
  for plugin in $@; do
    plugin_name=$(echo $plugin | cut -d "/" -f 2)
    cd "$ZSHDOTDIR/plugins/$plugin_name" &&  git pull --ff-only 2>/dev/null;
    cd - > /dev/null
  done
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

