# Fish Shell Migration

## `install.conf.yaml`

- [ ] Switch default shell to fish — currently `chsh -s $(brew --prefix)/bin/zsh`. Need platform variants: `$(brew --prefix)/bin/fish` on macOS, `/usr/bin/fish` on Arch (after `paru -S fish`). Also add fish to `/etc/shells` first.
- [ ] Add fisher + plugin bootstrap step — currently fisher is installed manually; no dotbot step installs it or runs `fisher update`. Should run after fish config is linked.
- [ ] Drop `source ~/.zshrc` at the end — replace with something meaningful for fish, or just remove it.

## `config.fish` (currently nearly empty)

- [ ] Set `$DOTFILES` — zsh derives it from `readlink ~/.zshrc`; fish needs it set explicitly.
- [ ] Set `$PROJECTS` — `set -gx PROJECTS ~/Projects`
- [ ] `direnv` hook — `zsh/direnv.zsh` has `eval "$(direnv hook zsh)"`. Fish equivalent: `direnv hook fish | source`. Not set up at all yet.
- [ ] `.localrc` equivalent — zshrc sources `~/.localrc` for machine-local secrets. Need a pattern for fish (e.g. source `~/.local.fish` if it exists).

## Missing `conf.d/` files

- [ ] Environment variables — none of these are in fish yet:
  - `EDITOR=nvim` (from `system/env.zsh`)
  - `LANG` / `LC_ALL` (from `system/env.zsh`)
  - `NEOVIDE_FORK=1` (from `nvim/env.zsh`)
  - `DISABLE_SPRING=true` (from `ruby/disable-spring.zsh`)
- [ ] PATH additions — `$DOTFILES/bin` and `$HOME/go/bin` not set for fish (homebrew is handled by `halostatue/fish-brew`, rbenv by `fish-rbenv`)
- [ ] grc colorization — `system/grc.zsh` sources `grc.bashrc`. Fish equivalent: `type -q grc && source (brew --prefix)/etc/grc.fish` in a conf.d file.

## Missing fish functions / aliases

### Git (`git/aliases.zsh`)

- [ ] `gme`, `gtoday` — git log shorthands
- [ ] `glog` — pretty graph log
- [ ] `gclean` — rebase + prune gone branches
- [ ] `gd` → `git diff`
- [ ] `gca` → `git commit -a`
- [ ] `gcb` → `git copy-branch-name`
- [ ] `gap` → `git add -p .`
- [ ] `grm` — remove deleted files from git

### General (`zsh/aliases.zsh`, `system/aliases.zsh`, `nvim/aliases.zsh`)

- [ ] `..`, `...`, `....` — cd shortcuts
- [ ] `vim` → `nvim`
- [ ] `ls` / `l` / `ll` / `la` with `gls --color` on macOS, plain `ls --color` on Linux
- [ ] `reload!` — `exec fish` equivalent

### Ruby (`ruby/aliases.zsh`, `ruby/functions.zsh`)

- [ ] `be` → `bundle exec`
- [ ] `rubocop-autofix-branch` / `-unsafe`
- [ ] `rubocop-autofix-unstaged` / `-unsafe`
- [ ] `haml-lint-branch`
- [ ] `fix-rubocop` / `fix-rubocop-unsafe`

### Utilities (`zsh/functions/`)

- [ ] `c` — `cd $PROJECTS/$1` with tab completion
- [ ] `supertouch` — `mkdir -p $(dirname $1) && touch $1`
- [ ] `allow-execute` — `xattr -d com.apple.quarantine $1` (macOS only)

## Node / NVM

- [ ] NVM for fish — `node/nvm.zsh` sources nvm.sh which doesn't work in fish. Options: add `jorgebucaran/nvm.fish` to `fish_plugins`, or use `bass` to source nvm.sh.

## Housekeeping

- [ ] Decide what to do with `zsh/` — keep it working for compatibility, or deprecate. `bin/update` still uses zsh.
- [ ] `bin/update` shebang — consider whether it stays as a zsh script or gets replaced by `update.fish` entirely.
