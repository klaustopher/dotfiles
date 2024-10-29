#!/bin/bash

if [ -f $HOME/.git-user-config ]
then
  echo "~/.git-user-config exists already, skipping"
else
  echo 'setup gitconfig'

  git_credential='cache'
  if [ "$(uname -s)" == "Darwin" ]
  then
    git_credential='osxkeychain'
  fi

  echo ' - What is your github author name?'
  read -e git_authorname
  echo ' - What is your github author email?'
  read -e git_authoremail

  SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

  sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" $SCRIPT_DIR/git-user-config.symlink.example > $HOME/.git-user-config
fi
