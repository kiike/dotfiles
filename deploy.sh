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
		ln -s "${PWD}/$1" "$2"
		[ $? = 0 ] && echo "OK"
	else
		echo "Skipping $1"
	fi
}

deploy awesome ${XDG_CONFIG_HOME}/awesome
deploy awesome ${XDG_DATA_HOME}/awesome
deploy mplayer ${HOME}/.mplayer
deploy mutt ${HOME}/.mutt
deploy tmux.conf ${HOME}/.tmux.conf
deploy vifm ${HOME}/.vifm
deploy vim ${HOME}/.vim
deploy vim/vimrc ${HOME}/.vimrc
deploy wgetrc ${HOME}/.wgetrc
deploy zshrc ${HOME}/.zshrc
