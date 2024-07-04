
# Use human-friendly identifiers.
zmodload zsh/terminfo
typeset -gA key_info
key_info=(
  'Control'         '\C-'
  'ControlLeft'     '\e[1;5D'
  'ControlRight'    '\e[1;5C'
  'ControlPageUp'   '\e[5;5~'
  'ControlPageDown' '\e[6;5~'
  'ControlBackspace' "^H"
  'Escape'          '\e'
  'Meta'            '\M-'
  'Backspace'       "^?"
  'Delete'          "^[[3~"
  'F1'              "$terminfo[kf1]"
  'F2'              "$terminfo[kf2]"
  'F3'              "$terminfo[kf3]"
  'F4'              "$terminfo[kf4]"
  'F5'              "$terminfo[kf5]"
  'F6'              "$terminfo[kf6]"
  'F7'              "$terminfo[kf7]"
  'F8'              "$terminfo[kf8]"
  'F9'              "$terminfo[kf9]"
  'F10'             "$terminfo[kf10]"
  'F11'             "$terminfo[kf11]"
  'F12'             "$terminfo[kf12]"
  'Insert'          "$terminfo[kich1]"
  'Home'            "$terminfo[khome]"
  'PageUp'          "$terminfo[kpp]"
  'End'             "$terminfo[kend]"
  'PageDown'        "$terminfo[knp]"
  'Up'              "$terminfo[kcuu1]"
  'Left'            "$terminfo[kcub1]"
  'Down'            "$terminfo[kcud1]"
  'Right'           "$terminfo[kcuf1]"
  'BackTab'         "$terminfo[kcbt]"
)

# Set empty $key_info values to an invalid UTF-8 sequence to induce silent
# bindkey failure.
for key in "${(k)key_info[@]}"; do
  if [[ -z "$key_info[$key]" ]]; then
    key_info[$key]='�'
  fi
done

# Expands .... to ../..
function expand-dot-to-parent-directory-path {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+='/..'
  else
    LBUFFER+='.'
  fi
}
zle -N expand-dot-to-parent-directory-path

# Inserts 'sudo ' at the beginning of the line.
function prepend-sudo {
  if [[ "$BUFFER" != su(do|)\ * ]]; then
    BUFFER="sudo $BUFFER"
    (( CURSOR += 5 ))
  fi
}
zle -N prepend-sudo

# Expand aliases
function glob-alias {
  zle _expand_alias
  zle expand-word
  zle magic-space
}
zle -N glob-alias

bindkey "$key_info[Home]" beginning-of-line
bindkey "$key_info[End]" end-of-line
bindkey "$key_info[Insert]" overwrite-mode
bindkey "$key_info[Delete]" delete-char
bindkey "$key_info[Backspace]" backward-delete-char
bindkey "$key_info[ControlBackspace]" backward-delete-word

#bindkey "$key_info[Left]" backward-char
#bindkey "$key_info[Right]" forward-char
bindkey "$key_info[ControlLeft]" vi-backward-word
bindkey "$key_info[ControlRight]" vi-forward-word

bindkey ' ' magic-space

# Clear screen.
bindkey "$key_info[Control]L" clear-screen

# Bind Shift + Tab to go to the previous menu item.
bindkey "$key_info[BackTab]" reverse-menu-complete
# Complete in the middle of word.
bindkey "$key_info[Control]I" expand-or-complete
bindkey "." expand-dot-to-parent-directory-path

# Display an indicator when completing.
#bindkey "$key_info[Control]I" expand-or-complete-with-indicator

# Insert 'sudo ' at the beginning of the line.
bindkey "$key_info[Control]X$key_info[Control]S" prepend-sudo

# control-space expands all aliases, including global
bindkey "$key_info[Control] " glob-alias

