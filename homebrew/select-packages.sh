#!/bin/bash

if ! [ -x "$(command -v gum)" ]; then
    /opt/homebrew/bin/brew install gum
fi

pushd "$(dirname "$(realpath -- "$0")")"
touch ~/.selected-homebrew-crates
packages=$(cat packages.txt | /opt/homebrew/bin/gum choose --no-limit --selected="$(cat ~/.selected-homebrew-crates)" | paste -sd "," -)

if [ -n "${packages}" ]; then
    echo $packages > ~/.selected-homebrew-crates
fi

popd
