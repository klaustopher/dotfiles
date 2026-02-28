function update --description 'Updates everything relevant on the system'
    function _section
        echo ""
        set_color --bold blue; echo "┌─────────────────────────────────────────"; set_color normal
        set_color --bold blue; printf "│ "; set_color --bold white; echo $argv; set_color normal
        set_color --bold blue; echo "└─────────────────────────────────────────"; set_color normal
    end

    function _skip
        set_color yellow; echo "  ⚠ skipped: $argv"; set_color normal
    end

    # ── Dotfiles ──────────────────────────────────────────────────────────────
    _section "Updating  dotfiles repo"
    pushd ~/.dotfiles
    git pull origin main
    popd

    # ── macOS ─────────────────────────────────────────────────────────────────
    if test (uname) = "Darwin"
        _section "Installing  Software Updates"
        sudo softwareupdate -i -a

        _section "Updating Mac App Store Apps"
        if type -q mas
            mas outdated
            mas upgrade
        else
            _skip "mas not installed"
        end

        _section "Updating  Homebrew Packages"
        if type -q brew
            brew update
            brew upgrade
            brew bundle --file=~/.dotfiles/packages/Brewfile
            brew cleanup -s
        else
            _skip "brew not installed"
        end

    # ── Arch Linux ────────────────────────────────────────────────────────────
    else if test (uname) = "Linux"
        _section "Updating System Packages"
        if type -q paru
            paru -Syu
        else if type -q pacman
            sudo pacman -Syu
        else
            _skip "no known package manager found (expected paru or pacman)"
        end
    end

    # ── Rubygems ──────────────────────────────────────────────────────────────
    if type -q gem
        set ruby_version (ruby --version | string split " ")[2]
        _section "Updating Rubygems ($ruby_version)"
        gem update --system
    else
        _section "Rubygems"
        _skip "gem not installed"
    end

    # ── Editors ───────────────────────────────────────────────────────────────
    if type -q code
        _section "Updating VS Code Extensions"
        code --list-extensions | xargs -I{} code --install-extension {} --force
    end

    if type -q nvim
        _section "Updating LazyVim Plugins"
        nvim --headless "+Lazy! sync" +qa
    end

    echo ""
    set_color --bold green; echo "✓ Done."; set_color normal
    echo ""

    functions --erase _section _skip
end
