#!/usr/bin/env bash

cat <<\EOF
path_add() {
  # remove trailing slashes
  local binary="${1%%+(/)}"; shift
  local unshift="$1"; shift

  if [ "$(echo "$PATH" | grep -q "(^|:)$binary(:|$)")" ]; then
    return
  fi

  if [ -z "$PATH" ]; then
    PATH="$binary"
  else
    # by default we push to the end
    if [ -z "$unshift" ]; then
      PATH+=":$binary"
    else
      PATH="$binary:$PATH"
    fi
  fi
}
EOF
