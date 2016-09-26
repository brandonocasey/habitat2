function! VimFind(path, extension)
  let files = system("find '" . expand(a:path) . "' -not -type l -name '*." . a:extension . "'")
  if empty(files)
    let files=[]
  else
    let files=split(files, '\n')
  endif
  return files
endfunction

function! SourceFiles(path, extension)
  for file in VimFind(a:path, a:extension)
    exe 'source' file
  endfor
endfunction

let VIM_CONFIG_DIR=expand('~/.vim')
let VIM_CONFIG_FILE=expand('~/.vimrc')
let VIM_DATA_DIR=expand('~/.viminfo')
let HABITAT_DOTFILES=expand($HABITAT_DIR . '/dotfiles')

" so that we can define XDG on OSX etc?
if has('nvim') == '1'
  let XDG_CONFIG_HOME=$XDG_CONFIG_HOME
  let XDG_DATA_HOME=$XDG_DATA_HOME
  if !exists(XDG_CONFIG_HOME)
    let XDG_CONFIG_HOME=expand('~/.config')
  endif
  if !exists(XDG_DATA_HOME)
    let XDG_DATA_HOME=expand('~/.local/share')
  endif
  let VIM_CONFIG_DIR=expand(XDG_CONFIG_HOME . '/nvim')
  let VIM_CONFIG_FILE=expand(XDG_CONFIG_HOME . '/nvim/init.vim')
  let VIM_DATA_DIR=expand(XDG_DATA_HOME . '/nvim/shada/main.shada')
endif

let VIM_BUNDLE_DIR=VIM_CONFIG_DIR . '/plugins'

let OS="linux"
if has("unix")
  let s:uname = substitute(system("uname -s"), "\n", '', '')
  if s:uname == "Darwin"
    let OS="osx"
  endif
else
  let OS="windows"
endif

" Plugins
" TODO: use git over curl as we are forced to have it
let vim_plug_file=VIM_CONFIG_DIR . "/autoload/plug.vim"
let vim_plug_url='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
if empty(glob(vim_plug_file))
  silent execute '!curl -fLo ' . vim_plug_file . ' --create-dirs ' . vim_plug_url
endif

if empty(glob(vim_plug_file))
  "vim-plug installation failed configuration is going to be messed up...
else
  call plug#begin(VIM_BUNDLE_DIR)
  call SourceFiles(HABITAT_DOTFILES, 'vimp')
  call plug#end()
endif

" Configuration
call SourceFiles(HABITAT_DOTFILES, 'vimc')
