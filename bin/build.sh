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
      [ ! -x "$plugin_dir/index" ] && echo "no executable index for $author/$plugin" 2>&1 && continue

      local cmd="$plugin_dir/index"
      local dist_file="$dist/${author}-${plugin}.sh"
      if [ "$HABITAT_DEBUG" = 0 ]; then
        time "$cmd" "$plugin_dir" "$HABITAT_DIR/dotfiles" >> "$dist_file"
        echo "Done Building $author/$plugin"
        continue
      fi
      "$cmd" "$plugin_dir" "$HABITAT_DIR/dotfiles" >> "$dist_file"
    done
  done
}

git_check() {
  if [ ! -d "$HABITAT_DIR/.git" ]; then
    return
  fi

  (cd "$HABITAT_DIR" && git remote update 2>&1 >/dev/null)
  local UPSTREAM="${1:-@{u}}"
  local LOCAL="$(cd "$HABITAT_DIR" && git rev-parse @)"
  local REMOTE="$(cd "$HABITAT_DIR" && git rev-parse "$UPSTREAM")"
  local BASE="$(cd "$HABITAT_DIR" && git merge-base @ "$UPSTREAM")"

  if [ "$LOCAL" = "$REMOTE" ] && [ "$HABITAT_DEBUG" = 0 ]; then
    echo "settings are up to date on git"
  elif [ "$LOCAL" = "$BASE" ]; then
    # pull needed
    (cd "$HABITAT_DIR" && git pull -q 2>&1 >/dev/null)
  elif [ "$REMOTE" = "$BASE" ]; then
    # push needed
    echo "You need to push your new habitat settings"
  else
    # fix needed
    echo "Your habitat git repo has diverged from master!"
  fi
}

build() {
  local build_dir="$1"; shift
  mkdir -p "$build_dir"

  [ -f "$build_dir/lock" ] && return

  # start lock so other environments cannot build
  touch "$build_dir/lock"

  local syml="$build_dir/syml"

  local new_dir="$build_dir/new-build-$RANDOM"
  local old_dir="$(readlink "$syml")"

  # pull new changes, warn about push
  git_check

  mkdir -p "$new_dir"
  build_plugins "$new_dir"

  # replace
  # syml -> old_dir
  # with
  # syml -> new_dir
  ln -sfn "$new_dir" "$syml"
  [ -d "$old_dir" ] && rm -rf "$old_dir"

  # update other terminals
  . "$HABITAT_DIR/lib/send_signal.sh"
  send_signal "SIGUSR1"

  # remove lock so other environments can build
  rm -f "$build_dir/lock"
}

build "$@"
