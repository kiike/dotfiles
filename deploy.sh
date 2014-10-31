#!/bin/sh

# Check if the XDG CONFIG and DATA location variables are set...
# ... and create them if they don't exist
test -z $XDG_CONFIG_HOME && XDG_CONFIG_HOME="${HOME}/.config"
test -e $XDG_CONFIG_HOME || mkdir $XDG_CONFIG_HOME

test -z $XDG_DATA_HOME && XDG_DATA_HOME="${HOME}/.local/share"
test -e $XDG_DATA_HOME || mkdir -p $XDG_DATA_HOME


function deploy {
	# Symlinks the first parameter into the second, as long as
	# the destination folder doesn't exist.

	if ! [[ -e "$2" ]]; then
		echo -n "Linking $1 to $2... "
		ln -s "${PWD}/$1" "$2" && echo "OK"
	fi
}

function check_or_mkdir {
	# Checks whether the directory exists, otherwise creates it

	if ! [[ -e "$1" ]]; then
		echo -n "Creating $1... "
		mkdir -p "$1" && echo "OK"
	fi
}
 
function deploy_all {
	deploy awesome ${XDG_CONFIG_HOME}/awesome
	deploy awesome ${XDG_DATA_HOME}/awesome

	deploy fonts ${HOME}/.fonts

	deploy vimperatorrc ${HOME}/.vimperatorrc

	deploy bspwm ${XDG_CONFIG_HOME}/bspwm
	deploy sxhkd ${XDG_CONFIG_HOME}/sxhkd

	deploy compton.conf ${XDG_CONFIG_HOME}/compton.conf

	deploy mutt ${HOME}/.mutt

	check_or_mkdir ${XDG_CONFIG_HOME}/newsbeuter/
	deploy newsbeuter/config ${XDG_CONFIG_HOME}/newsbeuter/config
	deploy newsbeuter/urls ${XDG_CONFIG_HOME}/newsbeuter/urls

	deploy panelrc ${HOME}/.panelrc
	deploy pentadactylrc ${HOME}/.pentadactylrc

	deploy tmux.conf ${HOME}/.tmux.conf

	deploy xinitrc ${HOME}/.xinitrc
	deploy Xresources ${HOME}/.Xresources

	deploy vifm ${HOME}/.vifm

	deploy vim ${HOME}/.vim
	deploy vim/vimrc ${HOME}/.vimrc
	check_or_mkdir ${HOME}/.vim/undo
	check_or_mkdir ${HOME}/.vim/backup
	check_or_mkdir ${HOME}/.vim/swap
	if [[ ! -e "${HOME}/.vim/bundle/vundle/.git" ]]; then
		git clone https://github.com/gmarik/vundle.git ${HOME}/.vim/bundle/
	fi

	deploy wgetrc ${HOME}/.wgetrc

	deploy Xmodmaprc ${HOME}/.Xmodmaprc

	deploy zshrc ${HOME}/.zshrc
	deploy zprofile ${HOME}/.zprofile

}

function deploy_basic {
	deploy tmux.conf ${HOME}/.tmux.conf

	deploy vim ${HOME}/.vim
	deploy vim/vimrc ${HOME}/.vimrc
	check_or_mkdir ${HOME}/.vim/undo
	check_or_mkdir ${HOME}/.vim/backup
	check_or_mkdir ${HOME}/.vim/swap
	if [[ ! -e "${HOME}/.vim/bundle/vundle/.git" ]]; then
		git clone https://github.com/gmarik/vundle.git ${HOME}/.vim/bundle/
	fi

	deploy zprofile ${HOME}/.zprofile
	deploy zshrc ${HOME}/.zshrc
}

case "$1" in
	all) deploy_all;;
	*)   deploy_basic;;
esac
