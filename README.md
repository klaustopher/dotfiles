# klaustophers Dotfiles

This is my new 2024 stab of running my dotfiles. They are managed by [dotbot](https://github.com/anishathalye/dotbot) and are intended to be run on macOS.

Files are split up into topic folders.

## Installation

```shell
git clone git@github.com:klaustopher/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

## Homebrew

We will install [homebrew](https://brew.sh) when it is not there. In `homebrew/Brewfile` we have a Brewfile that list all of the tools I want in my basic setup. There's also a little shell utility that asks for what setups you want to have on the machine and installs stuff dependent on this.

## ZSH config

The `.zshrc` looks at all of the other topic folders and evaluates all `*.zsh` files so we can add behavior to our shell

We iterate alphabetically over all our topic folders and load `*.zsh` files in this order:

1. `path.zsh` are all loaded very early in `.zshrc` and modify the `PATH` environment variable
2. All other `*.zsh` files are executed between path and completion loading
3. `completion.zsh` are loaded at the end of `.zshrc` and are used to install completions

### Plugins

Plugins are managed using [`zplug`](https://github.com/zplug/zplug). Plugins will be defined and loaded in `zsh/plugins.zsh`

## Some helpful links I want to keep track off
- https://github.com/anishathalye/dotbot
- https://github.com/d12frosted/dotbot-brew forked to https://github.com/klaustopher/dotbot-brew
- https://github.com/DrDynamic/dotbot-sudo
