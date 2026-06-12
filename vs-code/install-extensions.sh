#!/usr/bin/env bash
#
# Install (or update) VSCodium extensions cross-platform (macOS + Arch).
#
#   - Extensions listed in extensions.txt come from Open VSX (codium's default).
#   - Extensions not published to Open VSX are side-loaded as VSIX from the
#     MS Marketplace (see install_vsix calls at the bottom).
#
# Usage:
#   install-extensions.sh            install missing extensions (idempotent)
#   install-extensions.sh --update   re-install everything at the latest version
#
# No-op if VSCodium isn't installed, so it's safe to run on every `./install`.

set -euo pipefail

FORCE=0
case "${1:-}" in
  --update | -u) FORCE=1 ;;
esac

CODIUM_BIN="${CODIUM_BIN:-codium}"

if ! command -v "$CODIUM_BIN" >/dev/null 2>&1; then
  echo "VSCodium (codium) not found — skipping extension install."
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXT_LIST="$SCRIPT_DIR/extensions.txt"

# Lower-cased list of already-installed extension ids (ids are case-insensitive).
installed="$("$CODIUM_BIN" --list-extensions 2>/dev/null | tr '[:upper:]' '[:lower:]')"

is_installed() {
  grep -qxF "$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')" <<<"$installed"
}

# ── Open VSX extensions ───────────────────────────────────────────────────────
while IFS= read -r ext; do
  ext="${ext%%#*}"                       # strip inline comments
  ext="$(printf '%s' "$ext" | xargs)"    # trim whitespace
  [ -z "$ext" ] && continue
  if [ "$FORCE" -eq 0 ] && is_installed "$ext"; then
    echo "✓ $ext"
  else
    echo "→ installing $ext"
    "$CODIUM_BIN" --install-extension "$ext" --force
  fi
done <"$EXT_LIST"

# ── VSIX-only extensions (not on Open VSX) ────────────────────────────────────
install_vsix() {
  local id="$1" publisher="$2" name="$3"
  if [ "$FORCE" -eq 0 ] && is_installed "$id"; then
    echo "✓ $id (vsix)"
    return
  fi
  echo "→ side-loading $id from MS Marketplace"
  local ver tmpd
  ver="$(curl -fsSL "https://marketplace.visualstudio.com/_apis/public/gallery/extensionquery" \
    -H "Accept: application/json;api-version=3.0-preview.1" \
    -H "Content-Type: application/json" \
    -d "{\"filters\":[{\"criteria\":[{\"filterType\":7,\"value\":\"$id\"}]}],\"flags\":914}" \
    | python3 -c "import sys,json; print(json.load(sys.stdin)['results'][0]['extensions'][0]['versions'][0]['version'])")"
  tmpd="$(mktemp -d)"
  trap 'rm -rf "$tmpd"' RETURN
  # --compressed is required: the vspackage endpoint serves the .vsix gzip-encoded,
  # so without it curl writes the still-compressed bytes and the zip is unreadable.
  curl -fsSL --compressed -o "$tmpd/$name.vsix" \
    "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/$publisher/vsextensions/$name/$ver/vspackage"
  "$CODIUM_BIN" --install-extension "$tmpd/$name.vsix" --force
}

install_vsix "jeffgodwin.geo-viewer" "jeffgodwin" "geo-viewer"

echo "VSCodium extensions up to date."
