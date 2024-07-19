#!/bin/sh

if test ! $(which rvm); then
  echo "--> Installing RVM"
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  curl -sSL https://get.rvm.io | bash -s head

  echo "\n\n\n\033[0;33mRVM was installed, but no ruby has been installed yet. Install one with \`rvm install 3.3 && rvm use --default 3.3\`\n\n\n"
else
  echo "--> Updating RVM"
  rvm get head
fi
