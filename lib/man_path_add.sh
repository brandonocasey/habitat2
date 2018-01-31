#!/usr/bin/env bash

cat <<\EOF
man_path_add() {
  # remove trailing slashes
  local dir="${1%%+(/)}"; shift
  local unshift="$1"; shift

  # no path exists, just add the binary path
  if [ -z "$MANPATH" ]; then
    MANPATH="$dir"
    return
  fi

  # already in path
  local old_ifs="$IFS"
  IFS=:

  for p in $MANPATH; do
    [ "$p" = "$dir" ] && IFS="$old_ifs" && return
  done

  IFS="$old_ifs"

  # by default we push to the end
  if [ -z "$unshift" ]; then
    MANPATH="$MANPATH:$dir"
  else
    MANPATH="$dir:$MANPATH"
  fi
}
EOF
