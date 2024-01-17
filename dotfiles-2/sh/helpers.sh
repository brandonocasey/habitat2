# shellcheck shell=sh 
#
# Functions I need all the time, and really don't want to have to re-write
bin_exists() {
  if command -v "$1" >/dev/null 2>&1; then
    return 0
  fi

  return 1
}

_add_to_pathvar() {
  # remove trailing slashes
  pathvar="${1%%+(/)}"; shift
  dir="${1%%+(/)}"; shift
  unshift="$1"; shift

  # no path exists, just add the binary path
  if [ -z "$pathvar" ]; then
    PATH="$dir"
    return
  fi

  # already in path
  old_ifs="$IFS"
  IFS=:

  for p in $PATH; do
    [ "$p" = "$dir" ] && IFS="$old_ifs" && return
  done

  IFS="$old_ifs"

  # by default we push to the end
  if [ -z "$unshift" ]; then
    PATH="$PATH:$dir"
  else
    PATH="$dir:$PATH"
  fi

  unset dir
  unset unshift
  unset old_ifs

  printf '%s' "$pathvar"
}


path_add() {
  PATH="$(_add_to_pathvar "$PATH" "$1" "$2")"
  export PATH
}

manpath_add() {
  MANPATH="$(_add_to_pathvar "$MANPATH" "$1" "$2")"
  export MANPATH
}

infopath_add() {
  INFOPATH="$(_add_to_pathvar "$INFOPATH" "$1" "$2")"
  export MANPATH
}

fpath_add() {
  FPATH="$(_add_to_pathvar "$FPATH" "$1" "$2")"
  export FPATH
}
