# Installation
add the following to .bashrc or .bash_profile:
```sh
export HABITAT_DIR="~/habitat2"
. "$HABITAT_DIR/habitat.sh"

# TODO:
* time should be able to be an env var too, just like debug
* path_push + path_unshift + path_remove
* vim
	* why the f can't I do a PlugInstall in the background?
	* cant go to start of whitespace line
	* xx rather than dd for cut
	* why doesn't DetectSyntax work on write or change?
	* NERDTree folder sidebar
	* switch between windows & splits
	* investigate these vim plugins:
		* https://github.com/jiangmiao/auto-pairs vs delimate
		* https://github.com/airblade/vim-gitgutter
		* https://github.com/Shougo/neocomplete.vim
		* https://github.com/SirVer/ultisnips
* add these to dotfiles:
	* https://news.ycombinator.com/item?id=10484653
	* https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/safe-paste/safe-paste.plugin.zsh
	* https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/rsync/rsync.plugin.zsh
	* https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/vundle/vundle.plugin.zsh
	* https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/tmuxinator/_tmuxinator
	* https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/tmux
	* https://github.com/alebcay/awesome-shell
* update habitat to support bpkg
* re-run on PROMPT_COMMAND when needed?
