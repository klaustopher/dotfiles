#!/bin/bash

if ! [ -x "$(command -v gum)" ]; then
    brew install gum
fi
pushd "$(dirname "$(realpath -- "$0")")"
packages=$(cat packages.txt | gum choose --no-limit --selected=$(cat ~/.selected-homebrew-crates) | paste -sd "," -)

touch ~/.selected-homebrew-crates
echo $packages > ~/.selected-homebrew-crates

popd
