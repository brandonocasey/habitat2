# shellcheck shell=sh

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
export VISUAL_EDITOR=$editor
export SVN_EDITOR=$editor
export GIT_EDITOR=$editor


# themed ls colors
if bin_exists vivid; then
  export LS_COLORS="$(vivid generate one-dark)"
else
  export LSCOLORS=GxFxCxDxBxegedabagaced
fi


unset editor

# Don't warn me about mail
unset MAILCHECK

# finding things
export GREP_OPTIONS="--color=auto"
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"

# 1 Billion lines of history
export HISTSIZE=10000000
export HISTFILESIZE=$HISTSIZE
