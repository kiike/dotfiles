# Overrides
setopt nolistbeep
setopt nohistbeep
setopt nobeep

# Functions {{{
function cless () {
pygmentize -f terminal -N $@ | less -R
}

format_seconds () {
	# Formats seconds into minutes and seconds where seconds is $1.
	s=$1
	if [[ s -gt 60 ]]; then
		m=$(($s / 60))
		s=$(($s % 60))
		echo ${m}m${s}
	else
		echo ${s}s
	fi
}
# }}}
#
# Modules {{{
autoload -U colors && colors

fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

setopt extendedglob
#}}}

# History {{{
HISTFILE=$HOME/.zsh_history
[[ ! -f $HISTFILE ]] && touch $HISTFILE
HISTSIZE=10000
SAVEHIST=10000
setopt share_history
setopt histignoredups
setopt histignorespace
# }}}

# Keybindings {{{
bindkey -e
# }}}

# PS1, window title and long process notification {{{
TIMEFMT=$'\a'"$fg[green]%J$reset_color time: $fg[blue]%*Es$reset_color, cpu: $fg[blue]%P$reset_color"
REPORTTIME=10

local host_if_inside_ssh=${SSH_CONNECTION+${HOST} }

# If SSH_CONNECTION is set, prepend PS1 with the hostname
PS1="%B${host_if_inside_ssh}%F{4}%1//%f%b "

# Adapted snippet from http://scarff.id.au/blog/2011/window-titles-in-screen-and-rxvt-from-zsh/
function preexec() {
local a=${${1## *}[(w)1]}  # get the command
local b=${a##*\/}   # get the command basename
a="${b}${1#$a}"     # add back the parameters
a=${a//\%/\%\%}     # escape print specials
a=$(print -Pn "$a" | tr -d "\t\n\v\f\r")  # remove fancy whitespace
a=${(V)a//\%/\%\%}  # escape non-visibles and print specials

case "$TERM" in
	screen|screen.*)
		# See screen(1) "TITLES (naming windows)".
		# "\ek" and "\e\" are the delimiters for screen(1) window titles
		print -Pn "\ek%-3~ $a\e\\" # set screen title.  Fix vim: ".
		;;
	rxvt*|xterm*)
		print -Pn "\e]2;${host_if_inside_ssh}$a\a" # set xterm title, via screen "Operating System Command"
		;;
esac
}

function precmd() {
case "$TERM" in
	rxvt*|xterm*)
		print -Pn "\ek%-3~\e\\" # set screen title
		print -Pn "\e]2;${host_if_inside_ssh}%1//\a" # set xterm title, via screen "Operating System Command"
		;;
esac
}

#}}}

# {{{ TERM fix for xterm-termite
if [[ $TERM == "xterm-termite" ]]; then
	export TERM=xterm-256color
fi
#}}}

# Aliases and OS-dependent exports {{{
alias ccp="rsync -aPh"
alias cp="cp -R"
alias df="df -h"
alias du="du -h"
alias du="du -h"
alias ec="emacsclient -c"
alias ttyqr="ttyqr -b"
alias speedtest="curl -o /dev/null http://cachefly.cachefly.net/100mb.test"

case $(uname) in
	OpenBSD)
		alias sudo="doas"
		;;
	Linux)
		if [[ -f "/etc/os-release" ]]; then
			OS=$(grep NAME "/etc/os-release")
			case $OS in
				*Arch*)
					export BUILDDIR=/tmp
					alias pacman="sudo pacman"
					alias iptables="sudo iptables"
					alias systemctl="sudo systemctl"
					;;
			esac
		fi
		;;
esac

# }}}
# vim: fdm=marker sts=4 ts=4 sw=4
