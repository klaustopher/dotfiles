#!/usr/bin/env bash
#
# Install tools that we deliberately don't manage through the Brewfile/Archfile
# because we want the latest upstream version straight from the vendor's own
# installer (cross-platform on macOS + Arch).
#
# Each tool is gated on a package category selected via select-packages.sh (see packages.txt
# and select-packages.sh). Running this on every `./install` is a no-op for
# anything that isn't selected or is already installed.

set -euo pipefail

CRATE_FILE="$HOME/.selected-package-categories"
CRATES="$([ -f "$CRATE_FILE" ] && cat "$CRATE_FILE" || echo "")"

selected() { echo "$CRATES" | grep -q "$1"; }

# ── Claude Code ───────────────────────────────────────────────────────────────
if selected "Claude Code"; then
  if command -v claude >/dev/null 2>&1; then
    echo "✓ Claude Code already installed"
  else
    echo "→ installing Claude Code"
    curl -fsSL https://claude.ai/install.sh | bash
  fi
fi
