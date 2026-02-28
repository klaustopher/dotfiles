function pubkey --description 'Copy public SSH key to clipboard'
    set -l keyfile ~/.ssh/id_ed25519.pub

    if not test -f $keyfile
        echo "Error: $keyfile not found" >&2
        return 1
    end

    if type -q pbcopy
        cat $keyfile | pbcopy
    else if type -q wl-copy
        cat $keyfile | wl-copy
    else if type -q xclip
        cat $keyfile | xclip -selection clipboard
    else
        echo "Error: no clipboard tool found (expected pbcopy, wl-copy, or xclip)" >&2
        return 1
    end

    echo "=> Public key copied to clipboard."
end
