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
HISTCONTROL=erasedups
HISTFILE=~/.zsh_history
test -f $HISTFILE || touch $HISTFILE
HISTSIZE="10000"
SAVEHIST="10000"
setopt histignorealldups
setopt sharehistory
setopt incappendhistory
# }}}

# PS1, window title and long process notification {{{
if [ -z ${SSH_CONNECTION} ];
then    PS1="%B%F{4}%1//%f%b "
    EXTRA=""

else    PS1="%B$HOST:%F{4}%1//%f%b "
    EXTRA="$HOST "
fi

TIMEFMT="$fg[green]%J$reset_color time: $fg[blue]%*Es$reset_color, cpu: $fg[blue]%P$reset_color"
REPORTTIME=5

if [[ $TERM == screen* ]] || [[ $TERM == rxvt* ]]; then
    preexec () {
        CMD_NAME=$1
        print -Pn "\e]0;${EXTRA}${~1:gs/%/%%}\a"
    }
    precmd () {
        print -Pn "\e]0;${EXTRA}%1//\a"

        # Set window title of RXVT windows
        if [[ $TERM == rxvt* ]]; then
            print -n "\e]12;7\007"
        fi
    }
fi

#}}}

# Aliases {{{
alias ccp="rsync -aPh"
alias cp="cp -R"
alias df="df -h"
alias du="du -h"
alias du="du -h"
alias ttyqr="ttyqr -b"
# }}}

OS=$(grep NAME "/etc/os-release")
case $OS in
		*Arch*)
				alias pacman="sudo pacman"
				alias iptables="sudo iptables"
				alias systemctl="sudo systemctl"
				;;
esac

# vim: foldmethod=marker ts=4 sts=4 tw=4
