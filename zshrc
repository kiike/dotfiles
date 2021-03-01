# Some settings for Emacs TRAMP mode. Load early and return
if [[ "$TERM" == "dumb" ]]; then
    unsetopt zle
    unsetopt prompt_cr
    unsetopt prompt_subst
    unfunction precmd
    unfunction preexec
    PS1='$ '
    return
fi

# Overrides
if ! egrep -q 'alacritty|xterm|rxvt' <<< "$TERM"; then
    setopt nolistbeep
    setopt nohistbeep
    setopt nobeep
fi

setopt prompt_subst

# Functions
function cless () {
    pygmentize -f terminal $@ | less -R
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


# Modules
autoload -U colors && colors
autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr 'M' 
zstyle ':vcs_info:*' unstagedstr 'M' 
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' actionformats '%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats \
       '%F{5}[%F{2}%b%F{5}] %F{2}%c%F{3}%u%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' enable git 
+vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
	   [[ $(git ls-files --other --directory --exclude-standard | sed q | wc -l | tr -d ' ') == 1 ]] ; then
	hook_com[unstaged]+='%F{1}??%f'
    fi
}

fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

setopt extendedglob

# History
HISTFILE=$HOME/.zsh_history
[[ ! -f $HISTFILE ]] && touch $HISTFILE
HISTSIZE=100000
SAVEHIST=100000
setopt share_history
setopt histignoredups
setopt histignorespace

# Keybindings
bindkey -e

# PS1, window title and long process notification {{{
TIMEFMT=$'\a'"$fg[green]%J$reset_color time: $fg[blue]%*Es$reset_color, cpu: $fg[blue]%P$reset_color"
REPORTTIME=10

local host_if_inside_ssh=${SSH_CONNECTION+${HOST} }

# If SSH_CONNECTION is set, prepend PS1 with the hostname
PROMPT="%B${host_if_inside_ssh}%F{8}%1//%f%b "

# Adapted snippet from http://scarff.id.au/blog/2011/window-titles-in-screen-and-rxvt-from-zsh/
function preexec() {
    local a=${${1## *}[(w)1]}  # get the command
    local b=${a##*\/}   # get the command basename
    a="${b}${1#$a}"     # add back the parameters
    a=${a//\%/\%\%}     # escape print specials
    a=$(print -Pn "$a" | tr -d "\t\n\v\f\r")  # remove fancy whitespace
    a=${(V)a//\%/\%\%}  # escape non-visibles and print specials

    RPROMPT="${vcs_info_msg_0_}"

    case "$TERM" in
	screen|screen.*)
	    # See screen(1) "TITLES (naming windows)".
	    # "\ek" and "\e\" are the delimiters for screen(1) window titles
	    print -Pn "\ek%-3~ $a\e\\" # set screen title.  Fix vim: ".
	    ;;
	rxvt*|alacritty|xterm*)
	    print -Pn "\e]2;${host_if_inside_ssh}$a\a" # set xterm title, via screen "Operating System Command"
	    ;;
    esac
}

function precmd() {
    vcs_info
    case "$TERM" in
	rxvt*|xterm*|alacritty)
	    print -Pn "\ek%-3~\e\\" # set screen title
	    print -Pn "\e]2;${host_if_inside_ssh}%1//\a" # set xterm title, via screen "Operating System Command"
	    ;;
    esac
}

# Aliases and OS-dependent exports
alias ccp="rsync -aPh"
alias cp="cp -R"
alias df="df -h"
alias du="du -h"
alias du="du -h"
alias ttyqr="ttyqr -b"
