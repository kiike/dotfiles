#!/bin/bash

if [ -z $XDG_CONFIG_HOME ]; then
	XDG_CONFIG_HOME="${HOME}/.config"
fi

if [ -z $XDG_DATA_HOME ]; then
	XDG_DATA_HOME="${HOME}/.local/share"
fi

if ! [ -e $XDG_CONFIG_HOME ]; then
	mkdir $XDG_CONFIG_HOME
fi

if ! [ -e $XDG_DATA_HOME ]; then
	mkdir -p $XDG_DATA_HOME
fi

deploy(){
	if ! [ -e $2 ]; then
		echo -n "ln -s "${PWD}/$1" "$2"... "
		#ln -s "${PWD}/$1" "$2"
		#[ $? = 0 ] && echo "OK"
	else
		echo "Skipping $1"
	fi
}

PUT_IN_HOME=('zshrc' 'vim' 'mutt' 'tmux.conf' 'mplayer' 'wgetrc')

for i in ${PUT_IN_HOME[@]}; do
	deploy "$i" "${HOME}/.$i"
done

deploy awesome ${XDG_DATA_HOME}/awesome
deploy awesome ${XDG_CONFIG_HOME}/awesome
deploy lilyterm ${XDG_CONFIG_HOME}/lilyterm
deploy vimrc ${HOME}/.vim/vimrc
