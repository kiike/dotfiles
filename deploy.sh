#!/bin/sh

set +eu

install() {
	src="$1"
	shift

	for dest in $*; do
		# Symlink $1 to $2
		[[ -d "$(dirname ${dest})" ]] || _mkdir "${dest}"
		[[ -e "${dest}" ]] || ln -sf ${FLAGS} "${PWD}/${src}" "${dest}"
	done
}

uninstall() {
	shift
	for dest in $*; do
		# Unlink destination path if destination path is link
		[[ -h "${dest}" ]] && rm ${FLAGS} "${dest}"
	done
}

_mkdir() {
	for dir in $*; do
		# Check whether the directory exists, otherwise create it
		[[ -e "$dir" ]] || mkdir ${FLAGS} -p "$dir"
	done
}

deploy_all() {
	# ZSH
	$action zlogin ${HOME}/.zlogin
	$action zprofile ${HOME}/.zprofile
	$action zshrc ${HOME}/.zshrc

	# BSPWM, hotkey daemon, panel
	$action bspwm ${XDG_CONFIG_HOME}/bspwm
	$action sxhkd ${XDG_CONFIG_HOME}/sxhkd
	$action panelrc ${HOME}/.panelrc

	$action compton.conf ${XDG_CONFIG_HOME}/compton.conf

	$action newsbeuter/config ${HOME}/.newsbeuter/config
	$action newsbeuter/urls ${HOME}/.newsbeuter/urls

	$action pentadactylrc ${HOME}/.pentadactylrc

	$action xinitrc ${HOME}/.xinitrc
	$action Xresources ${HOME}/.Xresources
	$action Xcompose ${HOME}/.Xcompose

	$action vifm ${HOME}/.vifm

	$action Xmodmaprc ${HOME}/.Xmodmaprc
	$action tmux.conf ${HOME}/.tmux.conf

	_mkdir ${HOME}/.vim
	ln -s ${FLAGS} ${HOME}/.vim ${HOME}/.nvim
	$action vimrc ${HOME}/.{,n}vimrc
}

# Main program starts here

# Check if the XDG CONFIG and DATA location variables are set...
# ... and create them if they don't exist
[[ -z $XDG_CONFIG_HOME ]] && XDG_CONFIG_HOME="${HOME}/.config"
[[ -e $XDG_CONFIG_HOME ]] || mkdir $XDG_CONFIG_HOME

[[ -z $XDG_DATA_HOME ]] && XDG_DATA_HOME="${HOME}/.local/share"
[[ -e $XDG_DATA_HOME ]] || mkdir -p $XDG_DATA_HOME

while getopts rv flag; do
	case $flag in
		r)    action=uninstall;;
		v)    FLAGS="-v";;
	esac
done

shift

[[ $action != uninstall ]] && action=install

deploy_all
