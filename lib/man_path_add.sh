man_path_add() {
  # remove trailing slashes
  local binary="${1%%+(/)}"

  if [ -n "$(echo "$MANPATH" | grep -E "(^|:)$binary(:|$)")" ]; then
    return
  fi

  if [ -z "$MANPATH" ]; then
    MANPATH="$binary"
  else
    MANPATH+=":$binary"
  fi
}
