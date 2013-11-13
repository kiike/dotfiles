#!/bin/bash

# Check if the XDG CONFIG and DATA location variables are set...
# ... and create them if they don't exist
test -z $XDG_CONFIG_HOME && XDG_CONFIG_HOME="${HOME}/.config"
test -e $XDG_CONFIG_HOME || mkdir $XDG_CONFIG_HOME

test -z $XDG_DATA_HOME && XDG_DATA_HOME="${HOME}/.local/share"
test -e $XDG_DATA_HOME || mkdir -p $XDG_DATA_HOME


deploy(){
	# Symlinks the first parameter into the second, as long as
	# the destination folder doesn't exist.

	if ! [ -e $2 ]; then
		echo -n "Linking "$1" to "$2"... "
		ln -s "${PWD}/$1" "$2"
		[ $? = 0 ] && echo "OK"
	else
		echo "Warning: $1 already exists, skipping."
	fi
}


deploy awesome ${XDG_CONFIG_HOME}/awesome
deploy awesome ${XDG_DATA_HOME}/awesome

deploy compton.conf ${XDG_CONFIG_HOME}/compton.conf

deploy mplayer ${HOME}/.mplayer

deploy mutt ${HOME}/.mutt

deploy newsbeuter ${XDG_CONFIG_HOME}/newsbeuter

deploy pentadactylrc ${HOME}/.pentadactylrc

deploy tmux.conf ${HOME}/.tmux.conf

deploy vifm ${HOME}/.vifm

deploy vim ${HOME}/.vim
deploy vim/vimrc ${HOME}/.vimrc

deploy wgetrc ${HOME}/.wgetrc

deploy zshrc ${HOME}/.zshrc
