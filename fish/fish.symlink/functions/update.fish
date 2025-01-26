function update --description 'Updates everything relevant on the system'
    echo "Updating .dotfiles \uf1d3  repo"
    pushd ~/.dotfiles
    git pull origin main
    popd

    if test (uname) = "Darwin"
      echo "Installing \ue711 Software Updates"
      sudo softwareupdate -i -a

      echo "Updating Mac App Store Apps"
      mas outdated
      mas upgrade

      echo "Updating Homebrew Packages"
      brew update

      echo "Install everything from the Brewfile"
      brew bundle --file=~/.dotfiles/homebrew/Brewfile

      echo "Upgrade Homebrew Packages"
      brew upgrade

      echo "Cleaning Up old Homebrew Packages"
      brew cleanup -s
    end

    echo "Updating Rubygems for \ue739 $(ruby --version | cut -d" " -f2)"
    gem update --system

    if test -x code
        echo "Updating \udb82\ude1e VS Code Extensions"
        code --list-extensions | xargs -I{} code --install-extension {} --force
    end

    if test -x nvim
      echo "Updating \ue6ae LazyVim Plugins"
      nvim --headless "+Lazy! sync" +qa
  end
end
