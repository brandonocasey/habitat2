habitat_help() {
  echo
  echo "  Usage: . habitat [options]"
  echo
  echo "  -d, --debug        print debug statements"
  echo "  -f, --force        force habitat to rebuild now rather than once a day"
  echo "  -t, --time <mins>  time between rebuilds in minutes, defaults is 10080 (7 days)"
  echo "  -n, --no-run       don't run habitat"
  echo "  -h, --help         show this help"
  echo
}

habitat_main() {
  local build_dir="$HABITAT_DIR/.build"
  [ ! -d "$build_dir" ] && mkdir -p "$build_dir"
  local rebuild_time=10080
  local run=0
  local build=0

  while [ $# -gt 0 ]; do
    local argv="$1"; shift

    case "$argv" in
      -d|--debug) HABITAT_DEBUG=0 ;;
      -h|--help) habitat_help && habitat_clean && return ;;
      -t|--time) [ -n "$1" ] && rebuild_time="$1" && shift || rebuild_time='invalid';;
      -f|--force) rebuild_time=0  && rm -f "$build_dir/lock";;
      -nr|--no-run) run=1 ;;
      -nb|--no-build) build=1 ;;
      *)
    esac
  done

  if [ -z "$HABITAT_DEBUG" ]; then
    export HABITAT_DEBUG=1
  fi

  if ! echo "$rebuild_time" | grep -Eq "[0-9]+"; then
    echo "Must pass a number with --time" 2>&1
    habitat_clean
    return 1
  fi

  habitat_build() {
    [ "$build" = "1" ] && return

    echo "Building your habitat!"
    "$HABITAT_DIR/bin/build.sh" "$build_dir" "$$"
  }

  habitat_run() {
    [ "$run" = 1 ] && return

    while read -r file; do
      [ "$HABITAT_DEBUG" = "0" ] && time . "$file" && echo "^^ Time to run lib $(basename "$file")" && continue
      . "$file"
    done <<< "$(find -L "$build_dir/syml/lib" -name '*.sh')"

    while read -r file; do
      [ "$HABITAT_DEBUG" = 0 ] && time . "$file" && echo "^^ Time to run plugin $(basename "$file")" && continue
      . "$file"
    done <<< "$(find -L "$build_dir/syml/plugins" -name '*.sh')"
  }

  # if its time to rebuild
  if [ -z "$(find "$build_dir/syml" -type l -mmin "-${rebuild_time}" 2>/dev/null)" ]; then
    if [ "$HABITAT_DEBUG" = 0 ]; then
      echo "----Build Start---" && time habitat_build && echo "^^ Total Build Time" && echo "----Build End----" && echo
    else
      habitat_build
    fi
  fi

  if [ "$HABITAT_DEBUG" = 0 ]; then
    echo "----Run Start----" && time habitat_run && echo "^^ Total Run Time" && echo "----Run End----" && echo
  else
    habitat_run
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