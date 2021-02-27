#!/bin/sh

set +eu

COMMAND=add
[[ -z $XDG_CONFIG_HOME ]] && XDG_CONFIG_HOME="${HOME}/.config"
[[ -z $XDG_DATA_HOME ]] && XDG_DATA_HOME="${HOME}/.local/share"

_link() {
    source_dir=$(dirname "$1")
    target_dir=$(dirname "$2")
    if [[ -d "${source_dir}" ]] && [[ ! -d "${target_dir}" ]]; then
	mkdir -p "${target_dir}"
    fi

    ln -fs ${FLAGS} "$1" "$2"
}


remove() {
    [[ -h $2 ]] && rm ${FLAGS} "$2"
}

add() {
    if [ $# == 3 ]; then
	if hash "$3" 2>/dev/null; then
	    _link "$1" "$2"
	fi
    else
	_link "$1" "$2"
    fi
}

while getopts aRv option; do
    case $option in
	    R)    COMMAND=remove;;
	    v)    FLAGS="-v";;
	    a)    ALL=yes;;
    esac
done
[[ $# -gt 0 ]] && shift

if [[ $REMOVE == no ]]; then
    # Check if the XDG CONFIG and DATA location variables are set
    # and create them if they don't exist
    [[ -e $XDG_CONFIG_HOME ]] || mkdir $XDG_CONFIG_HOME
    [[ -e   $XDG_DATA_HOME ]] || mkdir -p $XDG_DATA_HOME
fi


$COMMAND ${PWD}/bin ${HOME}/bin
$COMMAND ${PWD}/tmux.conf ${HOME}/.tmux.conf

$COMMAND ${PWD}/mksh/mkshrc ${HOME}/.mkshrc mksh
$COMMAND ${PWD}/mksh/profile ${HOME}/.profile mksh

$COMMAND ${PWD}/ksh/kshrc ${HOME}/.kshrc ksh

$COMMAND ${PWD}/zlogin ${HOME}/.zlogin zsh
$COMMAND ${PWD}/zprofile ${HOME}/.zprofile zsh
$COMMAND ${PWD}/zshrc ${HOME}/.zshrc zsh

$COMMAND ${PWD}/afew ${XDG_CONFIG_HOME}/afew afew

$COMMAND ${PWD}/awesome ${XDG_CONFIG_HOME}/awesome awesome
$COMMAND ${PWD}/awesome ${XDG_DATA_HOME}/awesome awesome

$COMMAND ${PWD}/picom.conf ${XDG_CONFIG_HOME}/picom.conf picom

$COMMAND ${PWD}/latexmk ${XDG_CONFIG_HOME}/latexmk latexmk

$COMMAND ${PWD}/xinitrc ${HOME}/.xinitrc X
$COMMAND ${PWD}/Xresources ${HOME}/.Xresources X
$COMMAND ${PWD}/Xcompose ${HOME}/.Xcompose X
$COMMAND ${PWD}/Xmodmaprc ${HOME}/.Xmodmaprc X

$COMMAND ${PWD}/termite/config ${XDG_CONFIG_HOME}/termite/config termite

$COMMAND ${PWD}/vifm/vifmrc ${HOME}/.vifm/vifmrc vifm
$COMMAND ${PWD}/vifm/colors/Default.vifm ${HOME}/.vifm/colors/Default.vifm vifm

$COMMAND ${PWD}/vimrc ${HOME}/.vimrc vim

$COMMAND ${PWD}/emacs/init.el ${HOME}/.emacs.d/init.el emacs
$COMMAND ${PWD}/emacs/base16-material ${HOME}/.emacs.d/base16-material emacs

$COMMAND ${PWD}/systemd ${XDG_CONFIG_HOME}/systemd/user systemctl

$COMMAND ${PWD}/ibus/bin/setxkbmap ${XDG_DATA_HOME}/ibus/bin/setxkbmap ibus-daemon
$COMMAND ${PWD}/ibus/bin/find ${XDG_DATA_HOME}/ibus/bin/find ibus-daemon

$COMMAND ${PWD}/alacritty/alacritty.yml ${XDG_CONFIG_HOME}/alacritty/alacritty.yml alacritty

git submodule update --recursive
