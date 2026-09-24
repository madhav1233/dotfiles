#!/bin/sh
# tmux: bind M-'"' / M-% split-window -c "#{session_path}"
# herdr has no workspace root path, so use the cwd of the workspace's
# first (lowest-numbered) pane as the session root.
# Usage: split-from-root.sh <down|right>
H=/opt/homebrew/bin/herdr
JQ=/usr/bin/jq
dir=${1:-down}
ws=$("$H" pane current 2>/dev/null | "$JQ" -r '.result.pane.workspace_id // empty')
[ -n "$ws" ] || exit 0
root=$("$H" pane list 2>/dev/null | "$JQ" -r --arg ws "$ws" \
  '[.result.panes[] | select(.workspace_id == $ws)] | sort_by(.pane_id) | .[0].cwd // empty')
[ -n "$root" ] || exit 0
exec "$H" pane split --current --direction "$dir" --cwd "$root"
