# shellcheck shell=sh

export DOTFILES_DIR="$HOME/.config/dotfiles"

# Functions I need all the time, and really don't want to have to re-write
bin_exists() {
  if command -v "$1" >/dev/null 2>&1; then
    return 0
  fi

  return 1
}

_add_to_pathvar() {
  # remove trailing slashes
  pathvar="${1%%+(/)}"; shift
  dir="${1%%+(/)}"; shift
  unshift="$1"; shift

  # no path exists, just add the binary path
  if [ -n "$pathvar" ]; then

    # already in path
    old_ifs="$IFS"
    IFS=:

    for p in $PATH; do
      [ "$p" = "$dir" ] && IFS="$old_ifs" && return
    done

    IFS="$old_ifs"

    # by default we push to the end
    if [ -z "$unshift" ]; then
      PATH="$PATH:$dir"
    else
      PATH="$dir:$PATH"
    fi

    unset unshift
    unset old_ifs
  else
    pathvar="$dir"
  fi

  printf '%s' "$pathvar"
  unset pathvar
  unset dir
  unset unshift
}


path_add() {
  PATH="$(_add_to_pathvar "$PATH" "$1" "$2")"
  export PATH
}

manpath_add() {
  MANPATH="$(_add_to_pathvar "$MANPATH" "$1" "$2")"
  export MANPATH
}

infopath_add() {
  INFOPATH="$(_add_to_pathvar "$INFOPATH" "$1" "$2")"
  export MANPATH
}

fpath_add() {
  FPATH="$(_add_to_pathvar "$FPATH" "$1" "$2")"
  export FPATH
}

source_dir() {
  for file in "$DOTFILES_DIR/$1/"*; do
    echo "$file"
    #. "$file"
  done
  unset file
}



# PATH Priority is
# $HOME -> $DOTFILES_DIR -> (Homebrew if exists) -> global
path_add "/usr/local/bin"
path_add "/usr/bin"
path_add "/bin"
path_add "/usr/sbin"
path_add "/sbin"
path_add "./vendor/bin"
path_add "./bin"
path_add "./node_modules/.bin"
path_add "../node_modules/.bin"
path_add "../../node_modules/.bin"
path_add "../../../node_modules/.bin"
path_add "$HOME/.cargo/bin"
path_add "/usr/local/sbin"
manpath_add "/usr/share/man"
manpath_add "/usr/local/share/man"

if bin_exists "brew"; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  export HOMEBREW_PREFIX
  path_add "$HOMEBREW_PREFIX/bin"
  path_add "$HOMEBREW_PREFIX/sbin"
  manpath_add "$HOMEBREW_PREFIX/share/man"
  infopath_add "$HOMEBREW_PREFIX/share/info"
fi

path_add "$DOTFILES_DIR/bin"
manpath_add "$DOTFILES_DIR/man"
infopath_add "$DOTFILES_DIR/info"
fpath_add "$DOTFILES_DIR/fn"
path_add "$HOME/bin"
manpath_add "$HOME/man"
infopath_add "$HOME/info"
fpath_add "$HOME/fn"



source_dir sh

if [ -n "$ZSH_VERSION" ]; then
  source_dir zsh
elif [ -n "$BASH_VERSION" ];then
  source_dir bash
fi

unset -f source_dir
