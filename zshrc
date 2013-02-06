# Variables {{{
if [ -z $DISPLAY ];
	then VIMCMD="vim --remote-silent"
	else VIMCMD="gvim --remote-silent"
fi
# }}}

# Exports {{{ 
export EDITOR=$VIMCMD
export PAGER=less
export BROWSER=firefox
export PATH="~/scripts/:$PATH"
export GPG_TTY=$(tty)
export PYTHONDOCS=/usr/share/doc/python2/html/
# }}}

# Modules {{{
setopt extendedglob
autoload -U colors && colors
autoload -U compinit && compinit
#}}}

# Keybindings {{{
bindkey -v
# }}}

# History {{{
HISTCONTROL=erasedups
HISTFILE=~/.zsh_history
test -f $HISTFILE || touch $HISTFILE
HISTSIZE="1000"
SAVEHIST="1000"
setopt share_history
setopt inc_append_history
# }}}

# PS1, window title {{{
case $(uname -n) in;
	guile) PS1="%B%F{13}%1//%f%b ";;
	balrog) PS1="%B%F{2}%1//%f%b ";;
	sagat) PS1="%B%F{4}%1//%f%b ";;
	bison) PS1="%B%F{1}%1//%f%b ";;
	blanka) PS1="%B%F{9}%1//%f%b ";;
	vega) PS1="%B%F{2}%1//%f%b ";;
esac

case $TERM in;
	*xterm*|*screen*)
		precmd () { print -Pn "\e]0;%//\a" } 
		preexec () { print -Pn "\e]0;$1\a" } ;;
	*rxvt*)
		precmd () { print -Pn "\e]0;urxvt %1//\a" } 
		preexec () { print -Pn "\e]0;$1\a" } ;;
	*)
		PS1="%B%1//%f%b ";;
esac
#}}}

# Aliases {{{
alias aurget="cd /tmp; aurget"
alias ccp="rsync -aAPh"
alias cp="cp -R"
alias df="df -h"
alias du="du -h"
alias ls='ls --color=auto'
alias nmon="echo -cdnm | nmon"
alias netcfg="sudo netcfg"
alias pacman='sudo pacman'
alias rc.d='sudo systemctl'
alias sxiv="sxiv -f"
alias tmux="tmux -2"
alias gvim="gvim --remote-silent"
alias vim="vim --remote-silent"
# }}}

# Functions {{{

cdd() {
	cdd.sh
	if [ -e /tmp/cdd.tmp ]; then
		cd $(cat /tmp/cdd.tmp)
		rm -f /tmp/cdd.tmp
	fi
}

# vim: foldmethod=marker
