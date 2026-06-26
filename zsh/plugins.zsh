# Plugin management via sheldon (https://sheldon.cli.rs).
# Plugin list lives in zsh/sheldon.toml (linked to ~/.config/sheldon/plugins.toml).
# Update plugins with: sheldon lock --update
if (( $+commands[sheldon] )); then
  eval "$(sheldon source)"
fi
