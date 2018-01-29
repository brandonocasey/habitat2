#!/usr/bin/env bash

cat <<\EOF
man_path_add() {
  # remove trailing slashes
  local binary="${1%%+(/)}";shift
  local unshift="$1"; shift


  if echo "$MANPATH" | grep -Eq "(^|:)$binary(:|$)"; then
    return
  fi

  if [ -z "$MANPATH" ]; then
    MANPATH="$binary"
  else

    # by default we push to the end
    if [ -z "$unshift" ]; then
      MANPATH+=":$binary"
    else
      MANPATH="$binary:$MANPATH"
    fi
  fi
}
EOF
