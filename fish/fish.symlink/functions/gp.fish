function gp --wraps='git push origin HEAD --follow-tags' --description 'alias gp=git push origin HEAD --follow-tags'
  git push origin HEAD --follow-tags $argv
        
end
