#!/bin/sh

pushd "$(dirname "$(realpath -- "$0")")"
curl -L https://iterm2.com/shell_integration/zsh -o iterm2_shell_integration.zsh
popd
