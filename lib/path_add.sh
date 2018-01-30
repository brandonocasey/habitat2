#!/usr/bin/env bash

cat <<\EOF
path_add() {
  # remove trailing slashes
  local dir="${1%%+(/)}"; shift
  local unshift="$1"; shift

  # no path exists, just add the binary path
  if [ -z "$PATH" ]; then
    PATH="$dir"
    return
  fi

  # already in path
  if echo "$PATH" | tr -s ':' '\n' | grep -q "$dir"; then
    return
  fi

  # by default we push to the end
  if [ -z "$unshift" ]; then
    PATH="$PATH:$dir"
  else
    PATH="$dir:$PATH"
  fi
}
EOF
