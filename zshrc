#{{{ Exports
	export EDITOR="vim"
	export PAGER="less"
	export BROWSER="firefox"
	export PATH=$PATH:$HOME/.gem/ruby/1.9.1/bin
	export PATH="$HOME/scripts/:$PATH"
	export GPG_TTY=$(tty)
#}}}

#{{{ Modules
	setopt extendedglob
	autoload -U colors && colors
	autoload -U compinit && compinit
#}}}

#{{{ History
	HISTCONTROL=erasedups
	HISTFILE=~/.histfile
	HISTSIZE="10000"
	SAVEHIST="10000"
	setopt share_history
	setopt inc_append_history
#}}}

#{{{ Keybindings
	typeset -g -A key
	#bindkey '\e[3~' delete-char
	bindkey '\e[1~' beginning-of-line
	bindkey '\e[4~' end-of-line
	#bindkey '\e[2~' overwrite-mode
	bindkey '^?' backward-delete-char
	bindkey '^[[1~' beginning-of-line
	bindkey '^[[5~' up-line-or-history
	bindkey '^[[3~' delete-char
	bindkey '^[[4~' end-of-line
	bindkey '^[[6~' down-line-or-history
	bindkey '^[[A' up-line-or-search
	bindkey '^[[D' backward-char
	bindkey '^[[B' down-line-or-search
	bindkey '^[[C' forward-char 
#}}}

#{{{ PS1, window title
	case $(uname -n) in;
		guile) PS1="%B%F{13}%1//%f%b ";;
		balrog) PS1="%B%F{2}%1//%f%b ";;
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

#{{{ Aliases
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
#}}}

# Functions {{{

cdd() {
	cdd.sh
	if [ -e /tmp/cdd.tmp ]; then
		cd $(cat /tmp/cdd.tmp)
		rm -f /tmp/cdd.tmp
	fi
}

# vim: foldmethod=marker
