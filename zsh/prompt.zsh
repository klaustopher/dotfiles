autoload colors && colors
# cheers, @ehrenmurdick
# http://github.com/ehrenmurdick/config/blob/master/zsh/prompt.zsh

if (( $+commands[git] ))
then
  git="$commands[git]"
else
  git="/usr/bin/git"
fi

git_branch() {
  echo $($git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
}

git_dirty() {
  st=$($git status 2>/dev/null | tail -n 1)
  if [[ $st == "" ]]
  then
    echo ""
  else
    if [[ "$st" =~ ^nothing ]]
    then
      echo " on %{$fg_bold[green]%}$(git_prompt_info)%{$reset_color%}"
    else
      echo " on %{$fg_bold[red]%}$(git_prompt_info)%{$reset_color%}"
    fi
  fi
}

git_prompt_info () {
 ref=$($git symbolic-ref HEAD 2>/dev/null) || return
# echo "(%{\e[0;33m%}${ref#refs/heads/}%{\e[0m%})"
 echo "\ue0a0 ${ref#refs/heads/}"
}

unpushed () {
  $git cherry -v @{upstream} 2>/dev/null
}

need_push () {
  if [[ $(unpushed) == "" ]]
  then
    echo ""
  else
    echo " with %{$fg_bold[magenta]%}unpushed%{$reset_color%}"
  fi
}

ruby_version() {
  if (( $+commands[rvm-prompt] ))
  then
    echo "$(rvm-prompt | awk '{print $1}' | cut -d"-" -f2)"
  elif [ ! -z ruby ]
  then
    echo "$(ruby -v | cut -d" " -f2 | cut -d"-" -f2)"
  fi
}

node_version() {
  if [ ! -z $NVM_BIN ]
  then
    echo "$(nvm current | awk '{print $1}')"
  elif [ ! -z node ]
  then
    echo "$(node -v)"
  fi
}

rb_prompt() {
  if ! [[ -z "$(ruby_version)" ]]
  then
    echo "%{$fg_bold[yellow]%}\ue739 $(ruby_version)%{$reset_color%} "
  else
    echo ""
  fi
}

node_prompt() {
  if ! [[ -z "$(node_version)" ]]
  then
    echo "%{$fg_bold[magenta]%}\ued0d $(node_version)%{$reset_color%} "
  else
    echo ""
  fi
}

directory_name() {
  echo "%{$fg_bold[cyan]%}%1/%\/%{$reset_color%}"
}

export PROMPT=$'\n$(rb_prompt)$(node_prompt)in $(directory_name)$(git_dirty)$(need_push) as \uf1d3 \uf007  $(git config user.email)\n$ '
set_prompt () {
  export RPROMPT="%{$fg_bold[cyan]%}%{$reset_color%}"
}

precmd() {
  title "zsh" "%m" "%55<...<%~"
  set_prompt
}
