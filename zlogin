which startx &>/dev/null && [[ $TERM == linux ]] && startx

if [[ ! -z $SSH_CONNECTION ]]; then
	tmux attach || tmux
fi
