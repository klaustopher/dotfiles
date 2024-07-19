#!/bin/sh

pushd "$(dirname "$(realpath -- "$0")")"
cp Profil.json "$HOME/Library/Application Support/iTerm2/DynamicProfiles/"
popd
