if [[ -n $SSH_CONNECTION ]]; then
  export PS1='%m:%3~$(git_info_for_prompt)%# '
else
  export PS1='%3~$(git_info_for_prompt)%# '
fi

export EDITOR='nvim'
export VISUAL='nvim'

# Color setup: LSCOLORS is BSD/macOS; LS_COLORS (via dircolors) is GNU/Arch
export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true
if (( $+commands[dircolors] )); then
  eval "$(dircolors -b)"
fi

fpath=($DOTFILES/zsh/functions $fpath)

autoload -U $DOTFILES/zsh/functions/*(:t)

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF

# Directory stack navigation: `cd -<tab>` through history
setopt AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS PUSHD_SILENT

# SHARE_HISTORY (set above) already implies incremental append across sessions
setopt HIST_IGNORE_ALL_DUPS  # don't record dupes in history
setopt HIST_FIND_NO_DUPS     # don't show dupes when searching history
setopt HIST_IGNORE_SPACE     # commands prefixed with a space skip history (handy for secrets)
setopt HIST_REDUCE_BLANKS

unsetopt NOMATCH

# don't expand aliases _before_ completion has finished
#   like: git comm-[tab]
#setopt complete_aliases

zle -N newtab

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[^N' newtab
bindkey '^?' backward-delete-char

# History Plugin
bindkey '^\e[A' history-substring-search-up
bindkey '^\e[B' history-substring-search-down

# Ctrl-A + Ctrl-E
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Syntax Highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
