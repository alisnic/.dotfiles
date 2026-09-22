#!/usr/bin/env bash
set -euo pipefail

payload=$(cat)
model=$(printf '%s' "$payload" | jq -r '.model.display_name // "?"')
pct=$(printf '%s' "$payload" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
dir=$(printf '%s' "$payload" | jq -r '.workspace.current_dir // .cwd // empty')
wt_root="${CURSOR_WORKTREES_ROOT:-$HOME/.cursor/worktrees}"

if [ -z "$pct" ] || [ "$pct" -lt 0 ]; then
  pct=0
elif [ "$pct" -gt 100 ]; then
  pct=100
fi

filled=$((pct * 5 / 100))
empty=$((5 - filled))
bar=""
if [ "$filled" -gt 0 ]; then
  printf -v fill "%${filled}s"
  bar="${fill// /▓}"
fi
if [ "$empty" -gt 0 ]; then
  printf -v pad "%${empty}s"
  bar="${bar}${pad// /░}"
fi

git_ref() {
  local repo=$1
  local ref head tip

  ref=$(git -C "$repo" branch --show-current 2>/dev/null || true)
  if [ -n "$ref" ]; then
    printf '%s' "$ref"
    return
  fi

  head=$(git -C "$repo" rev-parse HEAD 2>/dev/null || true)
  for ref in master main; do
    tip=$(git -C "$repo" rev-parse "$ref" 2>/dev/null || true)
    if [ -n "$head" ] && [ -n "$tip" ] && [ "$head" = "$tip" ]; then
      printf '%s' "$ref"
      return
    fi
  done

  git -C "$repo" rev-parse --short HEAD 2>/dev/null || true
}

# Official CLI: ~/.cursor/worktrees/<repo>/<name>
# /worktree command: ~/.cursor/worktrees/<id>/<repo>-<12hex>
worktree_label() {
  local wt=$1
  local parent child common main_name

  parent=$(basename "$(dirname "$wt")")
  child=$(basename "$wt")
  common=$(git -C "$wt" rev-parse --git-common-dir 2>/dev/null || true)
  [ -n "$common" ] || { printf '%s' "$child"; return; }

  case "$common" in
    /*) ;;
    *) common=$(cd "$wt" && cd "$common" && pwd) ;;
  esac
  main_name=$(basename "$(dirname "$common")")

  if [ "$parent" = "$main_name" ]; then
    printf '%s' "$child"
  else
    printf '%s' "$parent"
  fi
}

under_wt_root() {
  local path=$1
  local rel=${path#"$wt_root"/}

  [ "$rel" != "$path" ] && [ "$rel" != "$path/" ] && case "$rel" in */*) return 0 ;; esac
  return 1
}

branch=""
worktree=""

if [ -n "$dir" ] && git -C "$dir" rev-parse --git-dir >/dev/null 2>&1; then
  toplevel=$(git -C "$dir" rev-parse --show-toplevel 2>/dev/null || true)
  wt_path=""

  if [ -n "$toplevel" ] && under_wt_root "$toplevel"; then
    wt_path=$toplevel
  elif [ -n "$toplevel" ]; then
    while IFS= read -r candidate; do
      [ -n "$candidate" ] || continue
      [ "$candidate" = "$toplevel" ] && continue
      under_wt_root "$candidate" || continue
      wt_path=$candidate
    done < <(git -C "$toplevel" worktree list --porcelain 2>/dev/null | awk '/^worktree / {print substr($0,10)}')
  fi

  if [ -n "$wt_path" ]; then
    worktree=$(worktree_label "$wt_path")
    branch=$(git_ref "$wt_path")
  else
    branch=$(git_ref "$dir")
  fi
fi

out="$model  ctx $bar"

if [ -n "$branch" ]; then
  out="$out  $branch"
fi

if [ -n "$worktree" ]; then
  out="$out  wt $worktree"
fi

printf '\033[90m%s\033[0m\n' "$out"
