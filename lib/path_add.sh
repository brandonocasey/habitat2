path_add() {
  local binary="$(echo "$1" | sed -e 's~/$~~')"

  if [ -n "$(echo "$PATH" | grep -E "(^|:)$binary(:|$)")" ]; then
    return
  fi

  if [ -z "$PATH" ]; then
    PATH="$binary"
  else
    PATH+=":$binary"
  fi
}
