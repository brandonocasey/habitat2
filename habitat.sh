habitat_help() {
  echo
  echo "  Usage: . habitat [options]"
  echo
  echo "  -d, --debug        print debug statements"
  echo "  -f, --force        force habitat to rebuild now rather than once a day"
  echo "  -fb, --force-build alias for force"
  echo "  -t, --time <mins>  time between rebuilds in minutes, defaults is 10080 (7 days)"
  echo "  -n, --no-run       don't run habitat"
  echo "  -h, --help         show this help"
  echo
}

habitat_git_check() {
  if [ ! -d "$HABITAT_DIR/.git" ]; then
    return
  fi

  (cd "$HABITAT_DIR" && git remote update >/dev/null 2>&1)
  local UPSTREAM="${1:-@{u}}"
  local LOCAL="$(cd "$HABITAT_DIR" && git rev-parse @)"
  local REMOTE="$(cd "$HABITAT_DIR" && git rev-parse "$UPSTREAM")"
  local BASE="$(cd "$HABITAT_DIR" && git merge-base @ "$UPSTREAM")"

  if [ "$LOCAL" = "$REMOTE" ] && [ "$HABITAT_DEBUG" = 1 ]; then
    echo "settings are up to date on git"
  elif [ "$LOCAL" = "$BASE" ]; then
    # pull needed
    (cd "$HABITAT_DIR" && git pull -q  >/dev/null 2>&1)
  elif [ "$REMOTE" = "$BASE" ]; then
    # push needed
    echo "You need to push your new habitat settings"
  else
    # fix needed
    echo "Your habitat git repo has diverged from master!"
  fi
}

habitat_build() {
  local build_dir="$1"; shift
  local lock_file="$build_dir/lock"
  local syml="$build_dir/syml"
  local new_dir="$build_dir/new-build-$RANDOM"
  local old_dir="$(readlink "$syml")"

  echo "Building your habitat!"
  mkdir -p "$build_dir"

  [ -f "$lock_file" ] && echo "habitat build is locked" && return

  # start lock so other environments cannot build
  touch "$lock_file"

  # pull new changes, warn about push
  habitat_git_check ""

  mkdir -p "$new_dir/"{lib,plugins}
  while read -r file; do
    newfile="$file"
    dir="$(dirname "$file")"
    if echo "$file" | grep -q "^plugins"; then
      newfile="$(echo "$dir" | sed 's~/~-~g' | sed 's~plugins-~plugins/~').sh"
    fi
    if [ "$HABITAT_DEBUG" = 1 ]; then
      time "$HABITAT_DIR/$file" "$HABITAT_DIR/$dir" "$HABITAT_DIR/dotfiles" >> "$new_dir/$newfile"
      echo "Done Building $file"
      continue;
    fi

    "$HABITAT_DIR/$file" "$HABITAT_DIR/$dir" "$HABITAT_DIR/dotfiles" >> "$new_dir/$newfile"
  done <<< "$(find "$HABITAT_DIR/"{lib,plugins} -type f -perm +111 | sed "s~$HABITAT_DIR/~~")"


  # replace
  # syml -> old_dir
  # with
  # syml -> new_dir
  ln -sfn "$new_dir" "$syml"
  [ -d "$old_dir" ] && rm -rf "$old_dir"

  # remove lock so other environments can build
  rm -f "$lock_file"

}

habitat_run() {
  local build_dir="$1"; shift

  while read -r file; do
    [ "$HABITAT_DEBUG" = "1" ] && time . "$file" && echo "^^ Time to run $(echo "$file" | sed "s~^$build_dir/syml/~~")" && continue
    . "$file"
  done <<< "$(find -L "$build_dir/syml/lib" "$build_dir/syml/plugins" -name '*.sh')"
}

habitat_main() {
  local build_dir="$HABITAT_DIR/.build"
  [ ! -d "$build_dir" ] && mkdir -p "$build_dir"
  local rebuild_time=10080
  local run=1
  local build=1

  while [ $# -gt 0 ]; do
    local argv="$1"; shift

    case "$argv" in
      -d|--debug) export HABITAT_DEBUG=1 ;;
      -h|--help) habitat_help && habitat_clean && return ;;
      -t|--time) [ -n "$1" ] && rebuild_time="$1" && shift || rebuild_time='invalid';;
      -f|--force|-fb|--force-build) rebuild_time=0 ;;
      -nr|--no-run) run=0 ;;
      -nb|--no-build) build=0 ;;
      *) echo "invalid option $argv" 1>&2 &&  habitat_clean && return 1;;
    esac
  done

  if [ -z "$HABITAT_DEBUG" ]; then
    export HABITAT_DEBUG=0
  fi

  if ! echo "$rebuild_time" | grep -Eq "[0-9]+"; then
    echo "Must pass a number with --time" 2>&1
    habitat_clean
    return 1
  fi

  # if its time to rebuild
  if [ "$build" = 1 ] && [ -z "$(find "$build_dir/syml" -type l -mmin "-${rebuild_time}" 2>/dev/null)" ]; then
    if [ "$HABITAT_DEBUG" = 1 ]; then
      echo "----Build Start---" && time habitat_build "$build_dir" && echo "^^ Total Build Time" && echo "----Build End----" && echo
    else
      habitat_build "$build_dir"
    fi
  fi

  if [ "$run" = 1 ]; then
    if [ "$HABITAT_DEBUG" = 1 ]; then
      echo "----Run Start----" && time habitat_run "$build_dir" && echo "^^ Total Run Time" && echo "----Run End----" && echo
    else
      habitat_run "$build_dir"
    fi
  fi

  habitat_clean
}

habitat_clean() {
  unset -f habitat_build
  unset -f habitat_run
  unset -f habitat_help
  unset -f habitat_main
  unset -f habitat_clean
  unset -f habitat_log
  unset -f habitat_time
  unset -f habitat_git_check
  unset HABITAT_DEBUG
}

# used to determine if this script is sourced or run as a binary
# shellcheck disable=SC2091
$(return >/dev/null 2>&1)

# shellcheck disable=SC2181
if [ "$?" != "0" ]; then
  echo "Script must be sourced, not run"
  exit 1
fi

if [ -z "$HABITAT_DIR" ] || [ ! -d "$HABITAT_DIR" ]; then
  echo "HABITAT_DIR must be set and exist before sourcing habitat" 2>&1
  return 1
fi

export HABITAT_DIR="$HABITAT_DIR"
alias habitat='. "$HABITAT_DIR/habitat.sh"'

habitat_main "$@"
