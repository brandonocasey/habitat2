path_add() {
  # remove trailing slashes
  local binary="${1%%+(/)}"

  if [ -n "$(echo "$PATH" | grep -E "(^|:)$binary(:|$)")" ]; then
    return
  fi

  if [ -z "$PATH" ]; then
    PATH="$binary"
  else
    PATH+=":$binary"
  fi
}
