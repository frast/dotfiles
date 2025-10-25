#!/usr/bin/env bash

# fman helper: colored man pages and interactive browser
command -v batcat >/dev/null 2>&1 || {
  printf 'fman: batcat not found; install bat first.\n' >&2
  return 1
}

export GROFF_NO_SGR=1
export MANPAGER="sh -c 'col -bx | batcat -l man -p --paging always'"

command -v fzf >/dev/null 2>&1 || {
  printf 'fman: fzf not found; install fzf to use fman.\n' >&2
  return 1
}

fman_preview() {
(
  set -euo pipefail
  local entry="$1" topic section
  topic=$(awk '{print $1}' <<<"$entry")
  topic=${topic#\'}
  section=$(awk '{print $2}' <<<"$entry" | tr -d '()')
  [ -z "$topic" ] || MANPAGER=command\ cat MANWIDTH=${MANWIDTH:-120} man "$section" "$topic" \
    | col -bx \
    | batcat --color=always -l man -p --paging never
)
}
export -f fman_preview

fman() {
(
  set -euo pipefail
  local selection topic section
  selection=$(man -k . | fzf -q "${1:-}" --ansi --prompt='man> ' --preview 'fman_preview "{}"')
  [ -z "$selection" ] && return
  topic=$(awk '{print $1}' <<<"$selection")
  section=$(awk '{print $2}' <<<"$selection" | tr -d '()')
  man "$section" "$topic"
)
}
