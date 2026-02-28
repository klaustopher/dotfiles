#!/bin/bash

if [ -f ~/.selected-homebrew-crates ] && [ ! -f ~/.selected-package-categories ]; then
    mv ~/.selected-homebrew-crates ~/.selected-package-categories
fi

pushd "$(dirname "$(realpath -- "$0")")"
touch ~/.selected-package-categories
packages=$(gum choose --no-limit --selected="$(cat ~/.selected-package-categories)" < packages.txt | paste -sd "," -)

if [ -n "${packages}" ]; then
    echo $packages > ~/.selected-package-categories
fi

popd
