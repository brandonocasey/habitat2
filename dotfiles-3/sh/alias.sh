# shellcheck shell=sh
#
# Ask before over-writing a file
alias mv='mv -i'

# Ask before deleting a file, and automatically make it recursive
alias rm='rm -Ri'

# Ask before over-writing a file and recursively copy by default
alias cp='cp -iR'

# We want free disc space in human readable output, trust me
alias df='df -h'

# Automatically make directories recursively
alias mkdir='mkdir -p'

# use coreutils ls if it exists
if bin_exists "eza"; then
  alias ls='eza'
  alias ll="eza -l --git --icons --time-style=long-iso"
  alias la='ll -ah'
  alias la_size='la --total-size'
  alias ll_size='ll --total-size'
  alias la_tree='la --tree'
  alias ll_tree='ll --tree'
  alias ls_tree='eza --tree'
  alias tree='lstree'
else
  if [ "$(uname)" = 'Darwin' ] && ! bin_exists gls; then
    # Show me all files and info about them
    alias ll='ls -lh --color=auto'

    # Show me all files, including .dotfiles, and all info about them
    alias la='ls -lha --color=auto'

    # Show me colors for regular ls too
    alias ls='ls --color=auto'
  else
    lsbin='ls'

    if bin_exists gls; then
      lsbin=gls
    fi

    alias ls="$lsbin --color=auto"
    # Show me all files and info about them
    alias ll="ls -lh --color=auto"
    # Show me all files, including .dotfiles, and all info about them
    alias la="ls -lha --color=auto"

    unset lsbin
  fi
fi

if bin_exists s; then
  alias s='s --provider duckduckgo'
  alias web-search='s --provider duckduckgo'
fi

alias brewup='brew update; brew upgrade; brew cleanup; brew doctor'

# Vim misspellings nuff' said
alias vim='nvim'
alias cim='nvim'
alias bim='nvim'
alias fim='nvim'
alias gim='nvim'
alias vi='nvim'

alias grep='grep --color="always"'

# easy mysql connection just tack on a -h
alias sql='mysql -umysql -pmysql'

# easy mysql dump just tack on a -h
alias sqld='mysqldump -umysql -pmysql --routines --single-transaction'

# reverse a string
alias reverse="perl -e 'print reverse <>'"

# go to root git directory
alias cdgitroot='cd "$(git rev-parse --show-toplevel)"'

# node module bs
alias npmre="rm -rf ./node_modules && npm i"
alias npmrews="rm -rf packages/**/node_modules && npmre"

# node workspace module bs
alias npmrere="rm -f ./package-lock.json && npmre"
alias npmrerews="rm -rf packages/**/node_modules && npmre"

# keep env when going sudo
alias sudo='sudo --preserve-env'

if bin_exists rlwrap; then
  alias telnet='rlwrap telnet'
fi

if bin_exists multitail; then
  alias tail='multitail'
else
  alias tail='tail -f'
fi


cdmkdir() {
  mkdir -p "$@"
  cd "$@" || return 1
}

npminit() {
  cdmkdir "$@"
  npm init --yes
}

nkill() {
  if [ "$#" -lt "1" ]; then
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
