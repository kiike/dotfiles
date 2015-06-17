which startx && [[ $TERM == linux ]] && startx

if [[ ! -z $SSH_CONNECTION ]]; then
	tmux attach || tmux
fi
