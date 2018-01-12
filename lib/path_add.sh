path_add() {
  # remove trailing slashes
  local binary="${1%%+(/)}"

  if [ "$(echo "$PATH" | grep -q "(^|:)$binary(:|$)")" ]; then
    return
  fi

  if [ -z "$PATH" ]; then
    PATH="$binary"
  else
    PATH+=":$binary"
  fi
}


