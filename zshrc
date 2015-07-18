# Exports {{{
if [[ $TERM != linux ]] && [[ -f ${HOME}/.pyenv/bin/activate ]] && [[ -z $VIRTUAL_ENV ]]; then
    VIRTUAL_ENV_DISABLE_PROMPT=1
    source ${HOME}/.pyenv/bin/activate
fi

export WINEPREFIX="${HOME}/.wine/default"
# }}}

# Look and Feel {{{
#}}}

# Modules {{{
autoload -U colors && colors

fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

setopt extendedglob
#}}}

# Functions {{{
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

# Keybindings {{{
bindkey -e
# }}}

# History {{{
HISTFILE=${HOME}/.zsh_history
HISTSIZE="10000"
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE
# }}}

# PS1, window title and long process notification {{{
TIMEFMT=$'\a'"$fg[green]%J$reset_color time: $fg[blue]%*Es$reset_color, cpu: $fg[blue]%P$reset_color"
REPORTTIME=10

local host_if_inside_ssh=${SSH_CONNECTION+${HOST} }

# If SSH_CONNECTION is set, prepend PS1 with the hostname
PS1="%B${host_if_inside_ssh}%F{4}%1//%f%b "

# Adapted snippet from http://scarff.id.au/blog/2011/window-titles-in-screen-and-rxvt-from-zsh/ {{{
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
    rxvt*)
      print -Pn "\ek%-3~\e\\" # set screen title
      print -Pn "\e]2;${host_if_inside_ssh}%1//\a" # set xterm title, via screen "Operating System Command"
      ;;
  esac
}

#}}}
#}}}

# Aliases {{{
alias ccp="rsync -aPh"
alias cp="cp -R"
alias df="df -h"
alias du="du -h"
alias du="du -h"
alias ttyqr="ttyqr -b"
# }}}

case $(uname) in
	OpenBSD)
		:
		;;
	Linux)
		if [[ -f "/etc/os-release" ]]; then
			OS=$(grep NAME "/etc/os-release")
			case $OS in
				*Arch*)
					alias pacman="sudo pacman"
					alias iptables="sudo iptables"
					alias systemctl="sudo systemctl"
					;;
			esac
		fi
		;;
esac

# vim: foldmethod=marker ts=4 sts=4 sw=4
