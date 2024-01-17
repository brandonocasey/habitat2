# shellcheck shell=sh
path_add "/usr/local/bin"

path_add "/usr/local/bin"
path_add "/usr/bin" 
path_add "/bin" 
path_add "/usr/sbin" 
path_add "/sbin" 
path_add "$HOME/bin" 
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
manpath_add "$HOME/man" 

infopath_add "$HOME/info" 

if bin_exists "brew"; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  export HOMEBREW_PREFIX
  path_add "$HOMEBREW_PREFIX/bin" 
  path_add "$HOMEBREW_PREFIX/sbin" 
  manpath_add "$HOMEBREW_PREFIX/share/man"
  infopath_add "$HOMEBREW_PREFIX/share/info"
fi

