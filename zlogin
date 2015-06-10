[[ $TERM == linux ]] && startx
[[ -n $SSH_CONNECTION ]] && tmux attach || tmux
