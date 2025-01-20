#!/bin/bash

pushd "$(dirname "$(realpath -- "$0")")" || exit
cp ./keyboard-layout/* ~/Library/Keyboard\ Layouts/
popd || return
