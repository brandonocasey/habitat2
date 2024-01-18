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

if bin_exists "eza"; then
  alias ls='eza'
  alias ll="eza -l --git --icons --time-style=long-iso"
  alias la='ll -ah'
  alias lasize='la --total-size'
  alias llsize='ll --total-size'
  alias latree='la --tree'
  alias lltree='ll --tree'
  alias lstree='eza --tree'
  alias tree='lstree'
else
  if [ "$(uname)" = 'Darwin' ]; then
    # Show me all files and info about them
    alias ll='ls -lh --color'

    # Show me all files, including .dotfiles, and all info about them
    alias la='ls -lha --color'

    # Show me colors for regular ls too
    alias ls='ls --color'
  else
    alias ls='ls -G'
    # Show me all files and info about them
    alias ll='ls -lhG'

    # Show me all files, including .dotfiles, and all info about them
    alias la='ls -lhaG'
  fi
fi

if bin_exists s; then
  alias s='s --provider duckduckgo'
  alias web-search='s --provider duckduckgo'
fi


alias brewup='brew update; brew upgrade; brew prune; brew cleanup; brew doctor'

# Automatically make directories recursively
alias mkdir='mkdir -p'

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
alias npmrere="rm -f ./package-lock.json && npmre"
alias npmrews="rm -f ./package-lock.json && rm -rf packages/**/node_modules && npmre"

# keep env when going sudo
alias sudo='sudo --preserve-env'

cdmkdir() {
  mkdir -p "$@"
  cd "$@" || return 1
}

npminit() {
  cdmkdir "$@"
  npm init --yes
}

# use rlwrap if we have it
telnet() {
  if bin_exists rlwrap; then
    rlwrap telnet "$@"
  else
    "$(command -v telnet)" "$@"
  fi
}

# use multitail if we have it
tail() {
  if bin_exists multitail; then
    multitail "$@"
  else
    "$(command -v tail)" -f "$@"
  fi
}

