function update --description 'Updates everything relevant on the system'
    printf "Updating .dotfiles \uf1d3 repo\n"
    pushd ~/.dotfiles
    git pull origin main
    popd

    if test (uname) = "Darwin"
      printf "Installing \ue711 Software Updates\n"
      sudo softwareupdate -i -a

      printf "Updating Mac App Store Apps\n"
      mas outdated
      mas upgrade

      printf "Updating Homebrew Packages\n"
      brew update

      printf "Install everything from the Brewfile\n"
      brew bundle --file=~/.dotfiles/homebrew/Brewfile

      printf "Upgrade Homebrew Packages\n"
      brew upgrade

      printf "Cleaning Up old Homebrew Packages\n"
      brew cleanup -s
    end

    printf "Updating Rubygems for \ue739 $(ruby --version | cut -d" " -f2)\n"
    gem update --system

    if test -x code
        printf "Updating \udb82\ude1e VS Code Extensions\n"
        code --list-extensions | xargs -I{} code --install-extension {} --force
    end

    if test -x nvim
      printf "Updating \ue6ae LazyVim Plugins\n"
      nvim --headless "+Lazy! sync" +qa
  end
end
