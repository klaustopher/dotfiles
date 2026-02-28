function claude-docker --description 'Run Claude Code in a Docker container'
    if test (count $argv) -lt 1
        echo "Usage: claude-docker <docker-image> [setup-script]"
        echo "Example: claude-docker ubuntu:24.04"
        echo "Example: claude-docker ubuntu:24.04 ./my-setup.sh"
        return 1
    end

    if not type -q docker
        echo "Error: docker is not installed" >&2
        return 1
    end

    set -l image $argv[1]
    set -l setup_script ""
    if test (count $argv) -ge 2
        set setup_script $argv[2]
    end

    set -l current_dir (pwd)
    set -l claude_dir $HOME/.claude
    set -l claude_json $HOME/.claude.json
    set -l host_uid (id -u)
    set -l host_gid (id -g)
    set -l term_value $TERM
    if not set -q TERM
        set term_value xterm-256color
    end

    mkdir -p $claude_dir

    set -l volume_args \
        -v $current_dir:/app \
        -v $claude_dir:/tmp/claude-config:ro

    if test -f $claude_json
        set volume_args $volume_args -v $claude_json:/tmp/claude-config.json:ro
    end

    if test -n "$setup_script"
        if not test -f $setup_script
            echo "Error: setup script '$setup_script' not found" >&2
            return 1
        end
        set -l setup_abs (cd (dirname $setup_script); pwd)/(basename $setup_script)
        set volume_args $volume_args -v $setup_abs:/tmp/claude-setup.sh:ro
    end

    echo "Starting Claude Code in Docker container..."
    echo "  Image:         $image"
    echo "  Working dir:   $current_dir -> /app"
    echo "  Claude config: $claude_dir (read-only)"
    echo "  Running as:    uid=$host_uid gid=$host_gid"
    if test -n "$setup_script"
        echo "  Setup script:  $setup_script"
    end
    echo ""

    # Fish expands $host_uid/$host_gid before passing the string to bash,
    # so the container script sees the literal numeric IDs.
    docker run -it --rm \
        $volume_args \
        -w /app \
        -e TERM=$term_value \
        -e HOME=/home/claude \
        $image \
        bash -c "
            groupadd -g $host_gid claudegroup 2>/dev/null || true
            useradd -u $host_uid -g $host_gid -d /home/claude -s /bin/bash claude 2>/dev/null || true
            mkdir -p /home/claude/.local
            chown -R $host_uid:$host_gid /home/claude /home/claude/.local

            cp -r /tmp/claude-config /home/claude/.claude
            chown -R $host_uid:$host_gid /home/claude/.claude
            if [[ -f /tmp/claude-config.json ]]; then
                cp /tmp/claude-config.json /home/claude/.claude.json
                chown $host_uid:$host_gid /home/claude/.claude.json
            fi

            if [[ -f /tmp/claude-setup.sh ]]; then
                echo '>>> Running setup script...'
                bash /tmp/claude-setup.sh
            fi

            echo '>>> Installing Claude Code...'
            su - claude -c 'curl -fsSL https://claude.ai/install.sh | bash'

            echo '>>> Launching Claude Code...'
            exec su - claude -c 'cd /app && /home/claude/.local/bin/claude'
        "
end
