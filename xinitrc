#!/bin/sh
# Source all files in /etc/X11/xinit/xinitrc.d
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

. ~/.profile

# Bell
xset b off

# Default pointer
xsetroot -cursor_name left_ptr

# Display power saving
xset s off
if [[ $(hostname) == dhalsim ]]; then
	xset -dpms
else
	xset dpms 300 450 600
fi


# Sync clipboard and primary selection
if hash autocutsel; then
	autocutsel -selection CLIPBOARD -fork
	autocutsel -selection PRIMARY -fork
fi

# D-Bus on non GNU/Linux systems
if [ -x /usr/local/bin/dbus-launch -a -z "${DBUS_SESSION_BUS_ADDRESS}" ]; then
        eval `dbus-launch --sh-syntax --exit-with-x11`
fi

# Input
[[ $(hostname) != dhalsim ]] && xmodmap ~/.Xmodmaprc
if hash ibus-daemon  &>/dev/null; then
	export GTK_IM_MODULE='ibus'
	export QT_IM_MODULE='ibus'
	export XMODIFIERS=@im=ibus
	xmodmap -e 'keysym Alt_R = Hangul'
	PATH=$HOME/.local/share/ibus/bin:$PATH ibus-daemon -dx
fi

if [[ $(hostname) == dhalsim ]] && ! pgrep -f scc; then
	rm -f $HOME/.config/scc/daemon.pid
	scc-daemon start
fi


# X resources
xrdb -merge ~/.Xresources

# Screenshots
hash flameshot && flameshot &>/dev/null &

# Compositor
hash picom && picom -b --experimental-backends

# Turn down the blue gamma (less eye strain???) on laptop displays
hash redshift && redshift -l manual -l 41.38:2.15 -b 1:0.9 &

wmname LG3D

hash pbns-wrap &> /dev/null && pbns-wrap &

emacs --bg-daemon &>/dev/null

exec awesome #-c /etc/xdg/awesome/rc.lua
