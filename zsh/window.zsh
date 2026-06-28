# From http://dotfiles.org/~_why/.zshrc
# Sets the window title nicely no matter where you are
function title() {
  # escape '%' chars in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
  screen)
    print -Pn "\ek$a:$3\e\\" # screen title (in ^A")
    ;;
  xterm*|rxvt)
    print -Pn "\e]2;$2\a" # plain xterm title ($3 for pwd)
    ;;
  esac
}

# Keep the window title updated on every prompt. This used to live in the old
# prompt.zsh's precmd; spaceship now owns precmd, so register via add-zsh-hook
# so both coexist.
autoload -Uz add-zsh-hook
_set_window_title() { title "zsh" "%m" "%55<...<%~" }
add-zsh-hook precmd _set_window_title

