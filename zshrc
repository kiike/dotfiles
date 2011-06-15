export EDITOR="vim"
export PAGER="less"
export BROWSER="luakit"
export PATH="/home/kiike/scripts/fb-uploader:$PATH"
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

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
		PS1="%B%F{10}%1//%f%b "
		precmd () { print -Pn "\e]0;urxvt %1//\a" } 
		preexec () { print -Pn "\e]0;$1\a" } ;;
	*)
		PS1="%B%1//%f%b ";;
esac


### Aliases

alias aurget="cd /tmp; aurget"
alias cp="cp -R"
alias df="df -h"
alias du="du -h"
alias feh="feh -T kiike"
alias ls='ls --color=auto'
alias makepkg="mppcadd; makepkg -c"
alias nano="nano -x"
alias netcfg="sudo netcfg"
alias pacman='sudo pacman'
alias suspend="sudo pm-suspend"
alias sxiv="sxiv -f"
