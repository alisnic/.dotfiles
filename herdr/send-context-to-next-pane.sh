#!/bin/sh
# Mirror tmux: send <leader>y in the focused pane, paste clipboard into the
# pane on the left, then focus that pane.
set -eu

PANE="${HERDR_ACTIVE_PANE_ID:-}"
if [ -z "$PANE" ]; then
  herdr notification show "No active pane" --body "Cannot send file context"
  exit 1
fi

herdr pane send-keys "$PANE" space y

# Neovim copies asynchronously, same race as the tmux bind.
sleep 0.2

LEFT="$(
  herdr pane neighbor --direction left --pane "$PANE" |
    jq -r '.result.neighbor.neighbor_pane_id // empty'
)"
if [ -z "$LEFT" ]; then
  herdr notification show "No pane to the left"
  exit 1
fi

TEXT="$(pbpaste)"
if [ -z "$TEXT" ]; then
  herdr notification show "Clipboard empty" --body "Neovim did not copy a file context"
  exit 1
fi

herdr pane send-text "$LEFT" "$TEXT"
herdr pane focus --direction left --pane "$PANE"
