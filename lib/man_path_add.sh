#!/usr/bin/env bash

cat <<\EOF
path_add() {
  # remove trailing slashes
  local dir="${1%%+(/)}"; shift
  local unshift="$1"; shift

  # no path exists, just add the binary path
  if [ -z "$MANPATH" ]; then
    MANPATH="$dir"
    return
  fi

  # already in path
  if echo "$MANPATH" | tr -s ':' '\n' | grep -xq "$dir"; then
    return
  fi

  # by default we push to the end
  if [ -z "$unshift" ]; then
    MANPATH="$MANPATH:$dir"
  else
    MANPATH="$dir:$MANPATH"
  fi
}
EOF
