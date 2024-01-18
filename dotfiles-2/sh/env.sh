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
export SVN_EDITOR=$editor
export GIT_EDITOR=$editor

unset editor
