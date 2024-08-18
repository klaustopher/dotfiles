#!/bin/sh

pushd "$(dirname "$(realpath -- "$0")")"
cp ./keyboard-layout/* ~/Library/Keyboard\ Layouts/
popd
