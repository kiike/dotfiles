#!/bin/sh

deploy() {
	src="$1"
	dest="$2"

	if [[ $REMOVE == "true" ]]; then
		# Unlink destination path if destination path is link
		[[ -h "${dest}" ]] && unlink "${dest}"
	else
		# Symlink $1 to $2
		[[ -d "$(dirname ${dest})" ]] || _mkdir "${dest}"
		[[ -e "${dest}" ]] || ln -s "${PWD}/${src}" "${dest}"
	fi
}

_mkdir() {
	# Check whether the directory exists, otherwise create it

	for dir in $*; do
		[[ -e "$dir" ]] || mkdir -p "$dir"
	done
}

deploy_all() {
	# ZSH
	deploy zlogin ${HOME}/.zlogin
	deploy zprofile ${HOME}/.zprofile
	deploy zshrc ${HOME}/.zshrc

	deploy awesome ${XDG_CONFIG_HOME}/awesome
	deploy awesome ${XDG_DATA_HOME}/awesome

	# BSPWM, hotkey daemon, panel
	deploy bspwm ${XDG_CONFIG_HOME}/bspwm
	deploy sxhkd ${XDG_CONFIG_HOME}/sxhkd
	deploy panelrc ${HOME}/.panelrc

	deploy compton.conf ${XDG_CONFIG_HOME}/compton.conf

	deploy mutt ${HOME}/.mutt

	deploy newsbeuter/config ${HOME}/.newsbeuter/config
	deploy newsbeuter/urls ${HOME}/.newsbeuter/urls

	deploy pentadactylrc ${HOME}/.pentadactylrc

	deploy xinitrc ${HOME}/.xinitrc
	deploy Xresources ${HOME}/.Xresources
	deploy Xcompose ${HOME}/.Xcompose

	deploy vifm ${HOME}/.vifm

	deploy Xmodmaprc ${HOME}/.Xmodmaprc
	deploy tmux.conf ${HOME}/.tmux.conf

	deploy vim ${HOME}/.vim
	deploy vim/vimrc ${HOME}/.vimrc
	_mkdir ${HOME}/.vim/{undo,backup,swap}
	if [[ ! -e "${HOME}/.vim/bundle/vundle/.git" ]] && [[ REMOVE == "false" ]]; then
		git clone https://github.com/gmarik/vundle.git ${HOME}/.vim/bundle/
	fi

}

# Main program starts here

# Check if the XDG CONFIG and DATA location variables are set...
# ... and create them if they don't exist
test -z $XDG_CONFIG_HOME && XDG_CONFIG_HOME="${HOME}/.config"
test -e $XDG_CONFIG_HOME || mkdir $XDG_CONFIG_HOME

test -z $XDG_DATA_HOME && XDG_DATA_HOME="${HOME}/.local/share"
test -e $XDG_DATA_HOME || mkdir -p $XDG_DATA_HOME

if [[ $2 == "-r" ]]; then
	export REMOVE="true"
	shift
else
	REMOVE="false"
fi

case "$1" in
	all)
		deploy_all
		;;

	*)
		[[ $1 == "-r" ]] && export REMOVE="true"
		deploy_basic
		;;
esac
