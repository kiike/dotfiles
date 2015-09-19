# Start tmux if running under SSH, else start X if it's installed and it's not already running

export PATH=~/bin:$PATH

if [[ ! -z $SSH_CONNECTION ]]; then
	tmux attach || tmux

elif ! pgrep -u $UID -x Xorg &>/dev/null && hash startx && [[ $TERM == linux ]]; then
	startx
fi
