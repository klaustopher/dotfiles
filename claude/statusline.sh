#!/usr/bin/env bash
# Claude Code status line.
# Shows model, project root, cwd-relative location, git state, session
# cost/lines, context-window usage, plan (rate-limit) usage, and the
# active output style.
#
# When the cwd has drifted below the project root, the relative subpath is
# highlighted so that tool-use paths (which render relative to the cwd) are
# never ambiguous.

input=$(cat)

# Pull everything out of the payload in one jq pass, joined on the ASCII Unit
# Separator (0x1F). A non-whitespace delimiter is required: `read` collapses
# runs of whitespace (incl. tabs) and trims trailing ones, which would drop
# absent fields and misalign every value after them. 0x1F never occurs in the
# data (paths, names, numbers), so empty fields are preserved positionally.
IFS=$'\037' read -r model cwd root style cost added removed ctx_pct five_h five_h_reset seven_d seven_d_reset < <(
  printf '%s' "$input" | jq -r '
    [ .model.display_name // "?"
    , .workspace.current_dir // .cwd // ""
    , .workspace.project_dir // ""
    , .output_style.name // ""
    , (.cost.total_cost_usd // 0)
    , (.cost.total_lines_added // 0)
    , (.cost.total_lines_removed // 0)
    , (.context_window.used_percentage // "")
    , (.rate_limits.five_hour.used_percentage // "")
    , (.rate_limits.five_hour.resets_at // "")
    , (.rate_limits.seven_day.used_percentage // "")
    , (.rate_limits.seven_day.resets_at // "")
    ] | map(tostring) | join("\u001f")'
)

root_name=$(basename "$root")

# ANSI colors
dim=$'\033[2m'
cyan=$'\033[36m'
yellow=$'\033[33m'
green=$'\033[32m'
red=$'\033[31m'
magenta=$'\033[35m'
reset=$'\033[0m'

# Pick a color for a 0–100 usage percentage: green < 50, yellow < 80, red ≥ 80.
pct_color() {
  local p=${1%%.*} # integer part is enough for thresholds
  if [ "$p" -ge 80 ]; then
    printf '%s' "$red"
  elif [ "$p" -ge 50 ]; then
    printf '%s' "$yellow"
  else
    printf '%s' "$green"
  fi
}

# Format seconds-from-now until a Unix-epoch timestamp, picking the two
# coarsest non-zero units: "3d4h" / "1h12m" / "12m". Prints nothing if the
# timestamp is empty or in the past.
fmt_reset() {
  local target=${1%%.*} # strip any fractional part
  [ -n "$target" ] || return
  local now diff
  now=$(date +%s)
  diff=$((target - now))
  [ "$diff" -gt 0 ] || return
  local d=$((diff / 86400)) h=$(((diff % 86400) / 3600)) m=$(((diff % 3600) / 60))
  if [ "$d" -gt 0 ]; then
    printf '%dd%dh' "$d" "$h"
  elif [ "$h" -gt 0 ]; then
    printf '%dh%02dm' "$h" "$m"
  else
    printf '%dm' "$m"
  fi
}

# --- Location ---------------------------------------------------------------
# nf-custom-folder (U+E5FF) marks the project root;
# nf-fa-warning (U+F071) flags a drifted cwd.
if [ -n "$root" ] && [ "$cwd" = "$root" ]; then
  # At the project root — paths render relative to the repo root.
  loc="${cyan} ${root_name}${reset}"
elif [ -n "$root" ] && [ "${cwd#"$root"/}" != "$cwd" ]; then
  # cwd is below the project root — show and highlight the subpath.
  sub="${cwd#"$root"/}"
  loc="${cyan} ${root_name}${reset}${dim}/${reset}${yellow}${sub}${reset} ${yellow} paths relative here${reset}"
else
  # cwd is outside the project root entirely — show the full path.
  loc="${yellow} ${cwd}${reset}"
fi

# --- Git branch + dirty state ----------------------------------------------
# nf-dev-git_branch (U+E725)   nf-fa-check (U+F00C)   nf-fa-pencil (U+F040)
git=""
branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
if [ -z "$branch" ]; then
  # Detached HEAD — fall back to the short SHA.
  branch=$(git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
fi
if [ -n "$branch" ]; then
  if [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null | head -1)" ]; then
    git="  ${magenta} ${branch} ${red}${reset}"
  else
    git="  ${magenta} ${branch} ${green}${reset}"
  fi
fi

# --- Session cost + lines changed ------------------------------------------
# Trim cost to two decimals without spawning bc/awk.
cost_fmt=$(printf '%.2f' "$cost" 2>/dev/null || printf '%s' "$cost")
meta="  ${dim}\$${cost_fmt} ${green}+${added}${dim}/${red}-${removed}${reset}"

# --- Context-window usage --------------------------------------------------
# nf-fa-tachometer (U+F0E4) + "ctx" label. Null early in a session; show once known.
ctx=""
if [ -n "$ctx_pct" ]; then
  ctx="  ${dim} ctx:${reset}$(pct_color "$ctx_pct") ${ctx_pct%%.*}%${reset}"
fi

# --- Plan (rate-limit) usage -----------------------------------------------
# Pro/Max only, and only after the first API response — each window may be absent.
# "5h" = 5-hour (session) limit, "wk" = 7-day (weekly) limit.
# nf-fa-clock_o (U+F017) = 5-hour window   nf-fa-calendar (U+F073) = 7-day window
plan=""
if [ -n "$five_h" ]; then
  plan="${plan}  ${dim} 5h:${reset}$(pct_color "$five_h") ${five_h%%.*}%${reset}"
  reset_in=$(fmt_reset "$five_h_reset")
  if [ -n "$reset_in" ]; then
    plan="${plan} ${dim}(${reset_in})${reset}"
  fi
fi
if [ -n "$seven_d" ]; then
  plan="${plan}  ${dim} wk:${reset}$(pct_color "$seven_d") ${seven_d%%.*}%${reset}"
  reset_in=$(fmt_reset "$seven_d_reset")
  if [ -n "$reset_in" ]; then
    plan="${plan} ${dim}(${reset_in})${reset}"
  fi
fi

# --- Output style (situational) --------------------------------------------
# nf-fa-paint_brush (U+F1FC)
extra=""
if [ -n "$style" ] && [ "$style" != "default" ] && [ "$style" != "null" ]; then
  extra="${extra}  ${dim} ${style}${reset}"
fi

# nf-fa-robot (U+F544) prefixes the model name.
printf '%s %s%s  %s%s%s%s%s%s' \
  "$dim" "$model" "$reset" "$loc" "$git" "$meta" "$ctx" "$plan" "$extra"
