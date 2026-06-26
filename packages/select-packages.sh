#!/usr/bin/env bash
#
# Self-contained package-category selector — no external dependencies (works on
# a clean machine before Homebrew/paru exist). Reads the available categories
# from packages.txt, pre-selects whatever was chosen last time, and writes the
# comma-separated result back to ~/.selected-package-categories (consumed by the
# Brewfile, Archfile, and third-party-installers.sh).
#
#   ↑/↓ or k/j       move
#   space/enter      toggle the focused checkbox
#   a                toggle all
#   [ Save & close ] space/enter on the last row saves and exits
#   q / esc          cancel without saving
#
# Compatible with macOS' bundled bash 3.2 (no associative arrays).

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PKG_FILE="$SCRIPT_DIR/packages.txt"
SELECTED_FILE="$HOME/.selected-package-categories"

# Migrate the old filename if it's still around.
if [ -f "$HOME/.selected-homebrew-crates" ] && [ ! -f "$SELECTED_FILE" ]; then
  mv "$HOME/.selected-homebrew-crates" "$SELECTED_FILE"
fi

# ── Load options ──────────────────────────────────────────────────────────────
options=()
while IFS= read -r line; do
  line="$(printf '%s' "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  [ -z "$line" ] && continue
  options+=("$line")
done <"$PKG_FILE"

count=${#options[@]}
if [ "$count" -eq 0 ]; then
  echo "No package categories found in $PKG_FILE" >&2
  exit 1
fi

# ── Pre-select from the previous run ──────────────────────────────────────────
previous=""
[ -f "$SELECTED_FILE" ] && previous="$(cat "$SELECTED_FILE")"

checked=()
for ((i = 0; i < count; i++)); do
  case ",$previous," in
    *",${options[$i]},"*) checked+=(1) ;;
    *) checked+=(0) ;;
  esac
done

# Non-interactive (piped, CI): keep the existing selection untouched.
if [ ! -t 0 ] || [ ! -t 1 ]; then
  echo "Not a TTY — keeping the existing package selection." >&2
  exit 0
fi

# ── Rendering ─────────────────────────────────────────────────────────────────
cursor=0
SAVE_ROW=$count          # virtual row index for the "Save & close" button
total_rows=$((count + 1))

cleanup() { tput cnorm 2>/dev/null || true; }
trap cleanup EXIT
tput civis 2>/dev/null || true   # hide cursor

draw() {
  local out="" i box pointer
  out+=$'  \033[1mSelect package categories\033[0m  \033[2m(↑/↓ move · space/enter toggle · a all · q cancel)\033[0m\n\n'
  for ((i = 0; i < count; i++)); do
    box="[ ]"; pointer="  "
    [ "${checked[$i]}" -eq 1 ] && box=$'[\033[32m✓\033[0m]'
    if [ "$i" -eq "$cursor" ]; then
      out+=$'\033[36m❯\033[0m '"$box"$' \033[36m'"${options[$i]}"$'\033[0m\033[K\n'
    else
      out+="$pointer$box ${options[$i]}"$'\033[K\n'
    fi
  done
  out+=$'\n'
  if [ "$cursor" -eq "$SAVE_ROW" ]; then
    out+=$'\033[36m❯\033[0m \033[1;32m[ Save & close ]\033[0m\033[K\n'
  else
    out+=$'  \033[1m[ Save & close ]\033[0m\033[K\n'
  fi
  printf '%b' "$out"
}

# Lines drawn = header(2) + options + blank(1) + save(1)
DRAWN_LINES=$((2 + count + 1 + 1))

redraw() {
  printf '\033[%dA' "$DRAWN_LINES"   # move cursor back to the top of the block
  draw
}

toggle_all() {
  local any_off=0 i
  for ((i = 0; i < count; i++)); do
    [ "${checked[$i]}" -eq 0 ] && any_off=1
  done
  for ((i = 0; i < count; i++)); do
    checked[$i]=$any_off
  done
}

save_and_exit() {
  local result="" i n
  for ((i = 0; i < count; i++)); do
    if [ "${checked[$i]}" -eq 1 ]; then
      [ -n "$result" ] && result+=","
      result+="${options[$i]}"
    fi
  done
  printf '%s' "$result" >"$SELECTED_FILE"
  redraw
  n=0
  [ -n "$result" ] && n=$(($(printf '%s' "$result" | tr -cd ',' | wc -c) + 1))
  printf '\n\033[32m✓\033[0m Saved %d categor%s to %s\n' \
    "$n" "$([ "$n" -eq 1 ] && echo y || echo ies)" "$SELECTED_FILE"
  exit 0
}

# ── Input loop ────────────────────────────────────────────────────────────────
draw
while true; do
  IFS= read -rsn1 key
  if [ "$key" = $'\033' ]; then
    # Could be an escape sequence (arrow key) or a bare Esc.
    rest=""
    IFS= read -rsn2 -t 0.001 rest || true
    key+="$rest"
  fi

  case "$key" in
    $'\033[A' | k) ((cursor > 0)) && ((cursor--)) || true ;;
    $'\033[B' | j) ((cursor < total_rows - 1)) && ((cursor++)) || true ;;
    ' ' | '' | $'\n' | $'\r') # space / enter — activate the focused row
      if [ "$cursor" -eq "$SAVE_ROW" ]; then
        save_and_exit
      else
        checked[$cursor]=$((1 - ${checked[$cursor]}))
      fi
      ;;
    a | A) toggle_all ;;
    q | Q | $'\033') cleanup; printf '\nCancelled — selection unchanged.\n'; exit 0 ;;
  esac
  redraw
done
