# Exports {{{ 
export EDITOR=vim
export PATH=$HOME/scripts:$PATH
export PATH=$HOME/.gem/ruby/2.0.0/bin:$PATH
export PAGER=less
export BROWSER=firefox
export GPG_TTY=$(tty)
export PYTHONDOCS=/usr/share/doc/python2/html/

source $HOME/.virtualenv/bin/activate
# }}}

# Modules {{{
autoload -U colors && colors
autoload -U compinit && compinit

setopt extendedglob
#}}}

# Keybindings {{{
bindkey -v

bindkey -M viins '^a'    beginning-of-line
bindkey -M viins '^e'    end-of-line
bindkey -M viins '^k'    kill-line
bindkey -M viins '^r'    history-incremental-pattern-search-backward
bindkey -M viins '^s'    history-incremental-pattern-search-forward
bindkey -M viins '^p'    up-line-or-history
bindkey -M viins '^n'    down-line-or-history
bindkey -M viins '^y'    yank
bindkey -M viins '^w'    backward-kill-word
bindkey -M viins '^u'    backward-kill-line
bindkey -M viins '^h'    backward-delete-char
bindkey -M viins '^?'    backward-delete-char
bindkey -M viins '^_'    undo
bindkey -M viins '^x^r'  redisplay
bindkey -M viins '\eOH'  beginning-of-line # Home
bindkey -M viins '\eOF'  end-of-line       # End
bindkey -M viins '\e[2~' overwrite-mode    # Insert
bindkey -M viins '\ef'   forward-word      # Alt-f
bindkey -M viins '\eb'   backward-word     # Alt-b
bindkey -M viins '\ed'   kill-word         # Alt-d
# }}}

# History {{{
HISTCONTROL=erasedups
HISTFILE=~/.zsh_history
test -f $HISTFILE || touch $HISTFILE
HISTSIZE="1000"
SAVEHIST="1000"
setopt histignorealldups
setopt sharehistory
setopt incappendhistory
# }}}

# PS1, window title {{{
if [ -z ${SSH_CONNECTION} ];
	then    PS1="%B%F{4}%1//%f%b "
		EXTRA=""

	else    PS1="%B$HOST:%F{4}%1//%f%b "
		EXTRA="$HOST "
fi

case $TERM in;
	*xterm*|*screen*)
		precmd () { print -Pn "\e]0;${EXTRA}%//\a" } 
		preexec () { print -Pn "\e]0;${EXTRA}$1\a" } ;;
	*rxvt*)
		precmd () { print -Pn "\e]0;${EXTRA}%1//\a" } 
		preexec () { print -Pn "\e]0;${EXTRA}${~1:gs/%/%%}\a" } ;;
esac
#}}}

# Aliases {{{
for a in apt-get aptitude systemctl pacman netcfg ip; do
	which $a >/dev/null && alias ${a}="sudo ${a}"
done

alias ccp="rsync -aAPh"
alias cp="cp -R"
alias df="df -h"
alias du="du -h"
alias ls='ls --color=auto'
alias nmon="echo -cdnm | nmon"

if [[ $HOST == "bison" ]]; then
	alias git="hub"
	alias sxiv="sxiv -f"
fi

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
