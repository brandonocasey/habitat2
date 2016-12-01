path_add() {
  # remove trailing slashes
  local binary="${1%%+(/)}"

  if [ "$(echo "$PATH" | grep -E "(^|:)$binary(:|$)")" ]; then
    return
  fi

  if [ -z "$PATH" ]; then
    PATH="$binary"
  else
    PATH+=":$binary"
  fi
}

# Only add to the path if its not already there
#current_plugin_dir="$1"

path_add "/usr/local/bin"
path_add "/usr/bin"
path_add "/bin"
path_add "/usr/sbin"
path_add "/sbin"
path_add "$HABITAT_DIR/dotfiles/bin"
path_add "./vendor/bin"
path_add "./bin"
path_add "./node_modules/.bin"
path_add "../node_modules/.bin"
path_add "../../node_modules/.bin"
path_add "../../../node_modules/.bin"

if type -t npm >/dev/null 2>&1; then
  path_add "$(npm bin --global)"
fi

if type -t brew >/dev/null 2>&1; then
  path_add "$(brew --prefix)/bin"
fi
