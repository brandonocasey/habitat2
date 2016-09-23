build_plugins() {
  local dist="$1"; shift
  local author_dir
  local plugin_dir

  # no plugins to build
  [ ! -d "$HABITAT_DIR/plugins" ] && return

  for author_dir in "$HABITAT_DIR/plugins/"*; do
    local author="$(basename "$author_dir")"

    # we have a plugins dir but not plugins
    [ "$author" = "*"  ] && return

    for plugin_dir in "$author_dir/"*; do
      local plugin="$(basename "$plugin_dir")"

      # we have an empty author dir
      [ "$plugin" = "*"  ] && break

      # we have a plugin with no index
      [ ! -x "$plugin_dir/index" ]&& continue

      local cmd="$plugin_dir/index"
      if [ "$HABITAT_DEBUG" = 0 ]; then
        time "$cmd" "$plugin_dir" "$HABITAT_DIR/dotfiles" > "$dist/${author}-${plugin}.sh"
        echo "Done Building $author/$plugin"
        continue
      fi
      "$cmd" "$plugin_dir" "$HABITAT_DIR/dotfiles" > "$dist/${author}-${plugin}.sh"
    done
  done
}

build() {
  local build_dir="$1"; shift
  mkdir -p "$build_dir"

  [ -f "$build_dir/lock" ] && return

  # start lock so other environments cannot build
  touch "$build_dir/lock"

  local syml="$(find "$build_dir" -type l)"
  [ -z "$syml" ] && syml="$build_dir/syml"

  local new_dir="$build_dir/new-build-$RANDOM"
  local old_dir="$(readlink "$syml")"

  # pull new changes
  [ -d "$HABITAT_DIR/.git" ] && cd "$HABITAT_DIR" && git pull -q 2>&1 >/dev/null

  mkdir -p "$new_dir"
  build_plugins "$new_dir"

  # replace
  # syml -> old_dir
  # with
  # syml -> new_dir
  ln -sfn "$new_dir" "$syml"
  [ -d "$old_dir" ] && rm -rf "$old_dir"

  # remove lock so other environments can build
  rm -f "$build_dir/lock"
}

build "$@"
