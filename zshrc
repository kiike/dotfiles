# Exports {{{ 
if [[ -f ${HOME}/.pyenv/bin/activate ]] && [[ -z $VIRTUAL_ENV ]]; then
	VIRTUAL_ENV_DISABLE_PROMPT=1
	source ${HOME}/.pyenv/bin/activate
fi
# }}}

# Modules {{{
autoload -U colors && colors
autoload -U compinit && compinit

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

zle-init zle-keymap-select () {
	case $KEYMAP in
		vicmd) echo -ne "\033]12;6\007";;
		viins|main) echo -ne "\033]12;7\007";;
	esac
	zle reset-prompt
}
zle -N zle-keymap-select
zle -N zle-init

# }}}

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

# PS1, window title and long process notification {{{
if [ -z ${SSH_CONNECTION} ];
	then    PS1="%B%F{4}%1//%f%b "
		EXTRA=""

	else    PS1="%B$HOST:%F{4}%1//%f%b "
		EXTRA="$HOST "
fi

if [[ $TERM == screen* ]] || [[ $TERM == rxvt* ]]; then
	CMD_NOTIFY_THRESHOLD=60
    BLACKLIST='(top|nmon|g?vi.*|less.*|cmus)'

	preexec () {
		CMD_START_DATE=$(date +%s)
		CMD_NAME=$1
		print -Pn "\e]0;${EXTRA}${~1:gs/%/%%}\a"
	}
	precmd () {
		if ! [[ -z $CMD_START_DATE ]]; then
			CMD_END_DATE=$(date +%s)
			CMD_ELAPSED_TIME=$(($CMD_END_DATE - $CMD_START_DATE))
			CMD_ELAPSED_TIME_NICE=$(format_seconds $CMD_ELAPSED_TIME)

			if [[ $CMD_ELAPSED_TIME -gt $CMD_NOTIFY_THRESHOLD ]]; then
				print -n '\a'

				if ! [[ $CMD_NAME =~ $BLACKLIST ]]; then
						notify-send "Job finished" "$CMD_NAME has finished in ${CMD_ELAPSED_TIME_NICE}."
				fi
			fi
			unset CMD_START_DATE
		fi
		print -Pn "\e]0;${EXTRA}%1//\a"

		# Set window title of RXVT windows
		if [[ $TERM == rxvt* ]]; then
			print -n "\e]12;7\007"
		fi
	}
fi

#}}}

# Aliases {{{
alias ccp="rsync -aAPh"
alias cp="cp -R"
alias df="df -h"
alias du="du -h"
alias ls='ls --color=auto'
alias nmon="echo -cdnm | nmon"
alias pacman="sudo pacman"
alias systemctl="sudo systemctl"

if [[ $HOST == "bison.*" ]]; then
	alias git="hub"
	alias sxiv="sxiv -f"
fi

# }}}

# vim: foldmethod=marker ts=4 sts=4
