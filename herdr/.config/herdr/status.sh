#!/bin/sh
# Mirrors the tmux status-right: catppuccin directory + session modules.
# Prints "<basename of focused pane cwd> · <focused workspace label>".
H=/opt/homebrew/bin/herdr
JQ=/usr/bin/jq
dir=$("$H" pane current 2>/dev/null | "$JQ" -r '.result.pane.cwd // empty')
ws=$("$H" workspace list 2>/dev/null | "$JQ" -r 'first(.result.workspaces[] | select(.focused) | .label) // empty')
out=""
[ -n "$dir" ] && out="${dir##*/}"
[ -n "$ws" ] && out="${out:+$out · }$ws"
printf '%s' "$out"
