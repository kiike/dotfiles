#!/bin/sh
# Source all files in /etc/X11/xinit/xinitrc.d
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# Mouse {{{
touchpad=$(xinput | grep TouchPad | cut -f 2 | cut -d = -f 2)
[[ -n "$touchpad" ]] && xinput --disable $touchpad
xsetroot -cursor_name left_ptr
xset m 4/1 4
# }}}

# {{{ Screensaver and monitor blanking
xset s off
if [[ $(hostname) == dhalsim ]]; then
	xset dpms off
else
	xset dpms 0 0 300
fi
#}}}

# Input method {{{
xmodmap ~/.Xmodmaprc
if hash uim-xim  &>/dev/null; then
	export GTK_IM_MODULE='uim'
	export QT_IM_MODULE='uim'
	export XMODIFIERS=@im=uim
	xmodmap -e 'keysym Alt_R = Hangul'
fi

#}}}

if hash autocutsel; then
	# Sync clipboard and primary selection
	autocutsel -selection CLIPBOARD -fork
	autocutsel -selection PRIMARY -fork
fi

# URxvt config and daemon
xrdb -merge ~/.Xresources

# Compositor
hash compton && compton -b

# Turn down the blue gamma (less eye strain???) on laptop displays
hash redshift && redshift 41.38:2.15 &

wmname LG3D

hash pbns-wrap &> /dev/null && pbns-wrap &

[[ $(uname) == Linux ]] && pulseaudio --start

#exec awesome -c /etc/xdg/awesome/rc.lua
exec awesome
# vim: ft=sh
