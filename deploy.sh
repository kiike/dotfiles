#!/bin/sh
set +eu

REMOVE=no
[[ -z $XDG_CONFIG_HOME ]] && XDG_CONFIG_HOME="${HOME}/.config"
[[ -z $XDG_DATA_HOME ]] && XDG_DATA_HOME="${HOME}/.local/share"

_action() {
	if [[ $REMOVE == yes ]]; then
		[[ -h $2 ]] && rm ${FLAGS} "$2"
	else
		source_dir=$(dirname "$1")
		target_dir=$(dirname "$2")
		if [[ -d "${source_dir}" ]] && [[ ! -d "${target_dir}" ]]; then
			mkdir -p "${target_dir}"
		fi

		[[ -h "$2" ]] && rm ${FLAGS} "$2"
		ln -s ${FLAGS} "$1" "$2"
	fi
}


while getopts aRv flag; do
	case $flag in
		R)    REMOVE=yes;;
		v)    FLAGS="-v";;
		a)    ALL=yes;;
	esac
done
[[ $# -gt 0 ]] && shift

if [[ $REMOVE == no ]]; then
	# Check if the XDG CONFIG and DATA location variables are set...
	# ... and create them if they don't exist
	[[ -e $XDG_CONFIG_HOME ]] || mkdir $XDG_CONFIG_HOME
	[[ -e   $XDG_DATA_HOME ]] || mkdir -p $XDG_DATA_HOME
fi


_action ${PWD}/bin ${HOME}/bin

_action ${PWD}/mksh/mkshrc ${HOME}/.mkshrc
_action ${PWD}/mksh/profile ${HOME}/.profile

_action ${PWD}/ksh/kshrc ${HOME}/.kshrc

_action ${PWD}/zlogin ${HOME}/.zlogin
_action ${PWD}/zprofile ${HOME}/.zprofile
_action ${PWD}/zshrc ${HOME}/.zshrc
_action ${PWD}/tmux.conf ${HOME}/.tmux.conf

_action ${PWD}/spacemacs ${HOME}/.spacemacs.d

_action ${PWD}/nvim/init.vim ${HOME}/.config/nvim/init.vim

if [[ $ALL == yes ]]; then
	_action ${PWD}/awesome ${XDG_CONFIG_HOME}/awesome
	_action ${PWD}/awesome ${XDG_DATA_HOME}/awesome

	_action ${PWD}/moc/config ${HOME}/.moc/config
	_action ${PWD}/moc/themes ${HOME}/.moc/themes
	_action ${PWD}/moc/keymap ${HOME}/.moc/keymap

	_action ${PWD}/compton.conf ${XDG_CONFIG_HOME}/compton.conf

	_action ${PWD}/newsbeuter/config ${HOME}/.newsbeuter/config
	_action ${PWD}/newsbeuter/urls ${HOME}/.newsbeuter/urls

	_action ${PWD}/xinitrc ${HOME}/.xinitrc
	_action ${PWD}/Xresources ${HOME}/.Xresources
	_action ${PWD}/Xcompose ${HOME}/.Xcompose
	_action ${PWD}/Xmodmaprc ${HOME}/.Xmodmaprc

	_action ${PWD}/termite/config ${XDG_CONFIG_HOME}/termite/config

	_action ${PWD}/vifm/vifmrc ${HOME}/.vifm/vifmrc
	_action ${PWD}/vifm/colors/Default.vifm ${HOME}/.vifm/colors/Default.vifm

	_action ${PWD}/vimrc ${HOME}/.vimrc

	_action ${PWD}/systemd ${XDG_CONFIG_HOME}/systemd/user
fi

git submodule update --recursive
