# Start tmux if running under SSH, else start X if it's installed and it's not already running

export PATH=~/bin:$PATH

# If we are connected with SSH and there's no tmux instance running
if test ! -z $SSH_CONNECTION && test -z $TMUX; then
	tmux attach || tmux
fi

# No Xorg running, has Xorg installed and we've just logged in
if ! pgrep -u $UID -x Xorg &>/dev/null && hash startx &>/dev/null && [[ $TERM == linux ]]; then
	startx
fi
