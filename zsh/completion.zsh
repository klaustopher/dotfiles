# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# arrow-key menu selection
zstyle ':completion:*' menu select

# colorize completion lists using LS_COLORS
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# cache completions for slow commands
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
