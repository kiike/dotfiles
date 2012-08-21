export EDITOR="vim"
export PAGER="vim -R"
export BROWSER="luakit"
export PATH="/home/kiike/scripts/:$PATH"

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

GPG_TTY=$(tty)
export GPG_TTY

# Keybindings

bindkey -v
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
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line

autoload colors; colors
case $TERM in;
	*rxvt*)
		[[ $(uname -n) == "guile" ]] && PS1="%B%F{13}%1//%f%b "
		[[ $(uname -n) == "bison" ]] && PS1="%B%F{1}%1//%f%b "
		[[ $(uname -n) == "blanka" ]] && PS1="%B%F{9}%1//%f%b "
		precmd () { print -Pn "\e]0;urxvt %1//\a" } 
		preexec () { print -Pn "\e]0;$1\a" } ;;
	*)
		PS1="%B%1//%f%b ";;
esac

setopt share_history
setopt inc_append_history


### Aliases

alias aurget="cd /tmp; aurget"
alias cp="cp -R"
alias df="df -h"
alias du="du -h"
alias ls='ls --color=auto'
alias less='vim -R -'
alias makepkg="makepkg -c"
alias netcfg="sudo netcfg"
alias pacman='sudo pacman'
alias sxiv="sxiv -f"
alias tmux="tmux -2"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm
