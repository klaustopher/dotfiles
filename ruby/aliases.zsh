alias be='bundle exec'

alias rubocop-autofix-branch='rubocop --force-exclusion -a $(git diff --name-only --diff-filter=d $(git merge-base HEAD $(git head-branch)) HEAD | grep "\.rb$")'
alias rubocop-autofix-branch-unsafe='rubocop --force-exclusion -A $(git diff --name-only --diff-filter=d $(git merge-base HEAD $(git head-branch)) HEAD | grep "\.rb$")'

alias rubocop-autofix-unstaged='rubocop --force-exclusion -a $(git status --porcelain | grep -v "^D " | sed -e "s/^.* //" | grep "\.rb$")'
alias rubocop-autofix-unstaged-unsafe='rubocop --force-exclusion -A $(git status --porcelain | grep -v "^D " | sed -e "s/^.* //" | grep "\.rb$")'

alias haml-lint-branch='haml-lint $(git diff --name-only --diff-filter=d $(git merge-base HEAD $(git head-branch)) HEAD | grep "\.haml$")'
