
## Custom binding ALT-x - Select item from clipboard
FZF_ALT_X_COMMAND="copyq eval -- \"tab('clipboard'); for(i=1; i<size(); ++i) print(str(read(i-1)).substring(0,50) + '\n');\""

fzf-item_clipboard-widget() {
  setopt localoptions pipefail no_aliases 2> /dev/null
  local item="$(eval "${FZF_ALT_X_COMMAND}" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} ${FZF_ALT_X_OPTS-}" $(__fzfcmd) +m)"
  
  zle push-line # Clear buffer. Auto-restored on next prompt.
  BUFFER="copyq eval -- \"tab('clipboard'); add('${(q)item}'); select(0)\""
  zle accept-line
  unset item # ensure this doesn't end up appearing in prompt expansion
  zle reset-prompt
  return ''
}

zle     -N              fzf-item_clipboard-widget
bindkey -M emacs '\ex'  fzf-item_clipboard-widget
bindkey -M vicmd '\ex'  fzf-item_clipboard-widget
bindkey -M viins '\ex'  fzf-item_clipboard-widget

