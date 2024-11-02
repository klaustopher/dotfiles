#!/bin/bash

if ! [ -x "$(command -v gum)" ]; then
    brew install gum
fi

pushd "$(dirname "$(realpath -- "$0")")"
touch ~/.selected-homebrew-crates
packages=$(cat packages.txt | gum choose --no-limit --selected=$(cat ~/.selected-homebrew-crates) | paste -sd "," -)
echo $packages > ~/.selected-homebrew-crates
popd
