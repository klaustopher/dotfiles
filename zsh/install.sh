#!/bin/zsh

echo "Switching Shell to brew installed ZSH"
sudo chsh -s $(brew --prefix)/bin/zsh $(whoami)

echo "Fixing CompAudit issues"
autoload -U +X compinit && compinit
compaudit | xargs chmod g-w
