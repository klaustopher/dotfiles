# fzf shell integration: Ctrl-R fuzzy history, Ctrl-T file insert, Alt-C cd
# Requires fzf >= 0.48 for `fzf --zsh`; older versions ship a keybindings file instead.
if (( $+commands[fzf] )); then
  source <(fzf --zsh)

  # Use fd as the backend: respects .gitignore, includes hidden files, skips .git
  if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
  fi
fi
