send_signal() {
  local SIGNAL="$(echo "$1" | sed 's~SIG~~')"; shift
  local ignore="$1"; shift
  local old_ifs="$IFS"
  local shell_name
  local pid
  [ -z "$ignore" ] && ignore="$BASHPID"
  [ -z "$ignore" ] && ignore="$$"


  if [ -n "$BASH" ]; then
    shell_name='bash'
  elif [ -n "$shell" ]; then
    shell_name="$shell"
  elif [ -n "$version" ]; then
    shell_name='tcsh'
  elif [ -n "$ZSH_NAME" ]; then
    shell_name='zsh'
  else
    shell_name="$(basename "$SHELL")"
  fi

  IFS=$'\n'
  for  pid in $(pgrep -U "$USER" -- "$shell_name" | grep -v "$ignore"); do
    (kill -$SIGNAL -- "$pid" 2>/dev/null 1>/dev/null &)
  done
  IFS="$old_ifs"
}
