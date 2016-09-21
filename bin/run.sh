##
# run_plugins
##
run_plugins() {
  local build_dir="$1"; shift
  local habitat_dir="$1"; shift
  local author_dir
  local plugin_dir

  if [ ! -d "$habitat_dir/plugins" ]; then
    return
  fi

  for author_dir in "$habitat_dir/plugins/"*; do
    local author="$(basename "$author_dir")"

    if [ "$author" = "*"  ]; then
      return
    fi
    for plugin_dir in "$author_dir/"*; do
      local plugin="$(basename "$plugin_dir")"

      if [ "$plugin" = "*"  ]; then
        break
      fi
      if [ ! -x "$plugin_dir/index" ]; then
        continue
      fi

      "$plugin_dir/index" "$plugin_dir" "$habitat_dir/dotfiles" > "$build_dir/${author}-${plugin}.sh"
    done
  done
}

run() {
  local habitat_dir="$1"; shift
  local habitat_symlink="$1"; shift

  build_dir="$habitat_dir/.habitat-new-build-$RANDOM"
  old_dir="$(readlink "$habitat_symlink")"

  output="$(cd "$habitat_dir" && git pull -q 2>&1 >/dev/null)"

  mkdir "$build_dir"

  run_plugins "$build_dir" "$habitat_dir"

  ln -sfn "$build_dir" "$habitat_symlink"
  if [ -d "$old_dir" ]; then
    rm -rf "$old_dir"
  fi
}

run "$@"
