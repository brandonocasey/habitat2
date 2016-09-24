send_signal() {
  local SIGNAL="$(echo "$1" | sed 's~SIG~~')"; shift
  local old_ifs="$IFS"
  local our_pid="$BASHPID"
  local shell_name
  local pid
  [ -z "$our_pid" ] && our_pid="$$"

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
  for  pid in $(pgrep -U "$USER" -- "$shell_name" | grep -v "$our_pid"); do
    kill -$SIGNAL -- "$pid"
  done
  IFS="$old_ifs"
}
