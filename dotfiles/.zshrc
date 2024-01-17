# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Helpers
bin_exists() {
  if command -v $1 >/dev/null 2>&1; then
    return 0
  fi

  return 1
}


editor='nano';

# Set default command editor to vim
if bin_exists nvim; then
  export MANPAGER="nvim +Man!"
  editor='nvim'
elif bin_exists vim; then
  editor='vim'
elif bin_exist vi; then
  editor='vi'
fi


export FCEDIT=$editor
export EDITOR=$editor
export VISUAL=$editor
export SVN_EDITOR=$editor
export GIT_EDITOR=$editor

unset editor

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -g -A key

key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

# setup key accordingly
[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
  autoload -Uz add-zle-hook-widget
  function zle_application_mode_start { echoti smkx }
  function zle_application_mode_stop { echoti rmkx }
  add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
  add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi


# ---- PATH STUFF
typeset -U path PATH
typeset -U manpath MANPATH
typeset -U infopath INFOPATH


path+=(/usr/local/bin)

path+=("/usr/local/bin")
path+=("/usr/bin")
path+=("/bin")
path+=("/usr/sbin")
path+=("/sbin")
path+=("$HOME/bin")
path+=("./vendor/bin")
path+=("./bin")
path+=("./node_modules/.bin")
path+=("../node_modules/.bin")
path+=("../../node_modules/.bin")
path+=("../../../node_modules/.bin")
path+=("$HOME/.cargo/bin")
path+=("/usr/local/sbin")

manpath+=("/usr/share/man")
manpath+=("/usr/local/share/man")
manpath+=("$HOME/man")

infopath+=("$HOME/info")

if bin_exists "brew"; then
  export HOMEBREW_PREFIX="$(brew --prefix)"
  path+=("$HOMEBREW_PREFIX/bin")
  path+=("$HOMEBREW_PREFIX/sbin")
  manpath=("$HOMEBREW_PREFIX/share/man")
  infopath=("$HOMEBREW_PREFIX/share/info")
fi


# ---- ALIAS
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
    alias ll='eza -l --git --icons'
    alias la='eza -lah --git --icons'
    alias llsize='eza -lah --git --icons --total-size'
else
  if [ uname = 'Darwin' ]; then
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
alias cdgitroot='cd $(git rev-parse --show-toplevel)'

# node module bs
alias npmre="rm -rf ./node_modules && npm i"
alias npmrere="rm -f ./package-lock.json && npmre"
alias npmrews="rm -f ./package-lock.json && rm -rf packages/**/node_modules && npmre"

# keep env when going sudo
alias sudo='sudo --preserve-env'

cdmkdir() {
  mkdir -p "$@"
  cd "$@"
}

npminit() {
  cdmkdir "$@"
  npm init --yes
}

man() {
  if vim -c "if exists(':Man') | q! | else | cq! | endif"; then
    vim -c "Man $1 $2" -c 'silent only'
  else
    "$(command -v man)" "$@"
  fi
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

# ---- HISTORY 
# save every command to history before execution (inc_append_history) and
# read the history file every time history is called upon
setopt share_history

# 1 Billion lines of history
HISTSIZE=10000000
HISTFILESIZE=$HISTSIZE

# remove older commands from the history list that are duplicates of the current one
setopt HIST_IGNORE_ALL_DUPS

# ---- PLUGINS

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

eval "$(sheldon source)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


export ASDF_DIR=
if [ -f ~/.asdf/asdf.sh ]; then
  source ~/.asdf/asdf.sh

  # append completions to fpath
  fpath=(${ASDF_DIR}/completions $fpath)
  # initialise completions with ZSH's compinit
  autoload -Uz compinit && compinit
fi


