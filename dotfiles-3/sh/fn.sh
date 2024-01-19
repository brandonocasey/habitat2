# shellcheck shell=sh

# kill processes by partial name
nkill() {
  if [ "$#" -lt "1" ]; then
    echo '  kill process by name'
    echo '  Usage:'
    echo '    nkill <process_name> ...'
    echo
    echo '  Example:'
    echo '    nkill httpd ssh-agent'
    echo
    return 1
  fi

  pgrep -fl "$@"
  if [ "$?" = "1" ]; then
    echo 'No processes match'
    return 1
  fi
  echo 'Hit [Enter] to pkill, [Ctrl+C] to abort'
  read -r && sudo pkill -9 -f "$@"
}

m_valgrind() {
  if command -v "valgrind" >/dev/null 2>&1; then
    echo "valgrind is not installed"
  fi

  if [ "$#" -ne "2" ]; then
    echo 'Usage:'
    echo '  m_valgrind log_output binary'
    echo
    echo 'Example:'
    echo '  m_valgrind /tmp/http_valgrind.log httpd'
    echo
    return 1
  fi
  sudo valgrind --leak-check=full --show-reachable=yes --log-file="$1" --trace-redir=yes -v "$2"
}

tcpd() {
  random="$(shuf -i 1-100 -n 1)"
  pcap="./${random}.pcap"
  unset random
  (tcpdump -q -s 0 -i any -w "$pcap" >/dev/null 2>&1 &)


  finish() {
    pkill -f "$pcap"
    echo "$pcap"
    trap - INT
    trap
    unset -f finish
    unset pcap
  }

  trap "echo && finish && return 0" INT
  printf 'Hit [Any Key] to kill tcpdump'
  read -r
  finish
}
