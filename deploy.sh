#!/bin/sh
set +eu

REMOVE=no
[[ -z $XDG_CONFIG_HOME ]] && XDG_CONFIG_HOME="${HOME}/.config"
[[ -z $XDG_DATA_HOME ]] && XDG_DATA_HOME="${HOME}/.local/share"

_action() {
	if [[ $REMOVE == yes ]]; then
		[[ -h $2 ]] && rm ${FLAGS} "$2"
	else
		ln -sf ${FLAGS} "${PWD}/$1" "$2"
	fi
}


while getopts rv flag; do
	case $flag in
		r)    REMOVE=yes;;
		v)    FLAGS="-v";;
	esac
done
[[ $# -gt 0 ]] && shift

if [[ $REMOVE == no ]]; then
	# Check if the XDG CONFIG and DATA location variables are set...
	# ... and create them if they don't exist
	[[ -e $XDG_CONFIG_HOME ]] || mkdir $XDG_CONFIG_HOME
	[[ -e   $XDG_DATA_HOME ]] || mkdir -p $XDG_DATA_HOME
fi

# ZSH
_action zlogin ${HOME}/.zlogin
_action zprofile ${HOME}/.zprofile
_action zshrc ${HOME}/.zshrc

# BSPWM, hotkey daemon, panel
_action bspwm ${XDG_CONFIG_HOME}/bspwm
_action sxhkd ${XDG_CONFIG_HOME}/sxhkd
_action panelrc ${HOME}/.panelrc

_action compton.conf ${XDG_CONFIG_HOME}/compton.conf

_action newsbeuter/config ${HOME}/.newsbeuter/config
_action newsbeuter/urls ${HOME}/.newsbeuter/urls

_action pentadactylrc ${HOME}/.pentadactylrc

_action xinitrc ${HOME}/.xinitrc
_action Xresources ${HOME}/.Xresources
_action Xcompose ${HOME}/.Xcompose

_action vifm ${HOME}/.vifm

_action Xmodmaprc ${HOME}/.Xmodmaprc
_action tmux.conf ${HOME}/.tmux.conf

if [[ ! -e ${HOME}/.vim ]]; then
	mkdir ${HOME}/.vim
	_action ${HOME}/.vim ${HOME}/.nvim
fi
_action vimrc ${HOME}/.vimrc ${HOME}/.nvimrc
