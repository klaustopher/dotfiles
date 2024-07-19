# The rest of my fun git aliases
alias gl='git pull --prune'
alias gr='git pull --rebase'
alias gme='git log --pretty=format:"%C(yellow)%h%Creset %ad%x09%s" --author="$(git config user.name)" --since="1 week ago"'
alias gtoday='git log --pretty=format:"%h %ad%x09%s" --author="$(git config user.name)" --since="1 day ago"'
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gclean="git pull --rebase && git fetch -p && for branch in \$(git branch -vv | grep ': gone]' | awk '{print \$1}'); do git branch -d \$branch; done"
alias gp='git push origin HEAD --follow-tags'
alias gd='git diff'
alias gc='git commit --verbose'
alias gca='git commit -a'
alias gco='git checkout'
alias gcb='git copy-branch-name'
alias gap='git add -p .'
alias gb='git branch'
alias gs='git status -sb' # upgrade your git if -sb breaks for you. it's fun.
alias gst='git status -sb'
alias grm="git status | grep deleted | awk '{\$1=\$2=\"\"; print \$0}' | \
           perl -pe 's/^[ \t]*//' | sed 's/ /\\\\ /g' | xargs git rm"
