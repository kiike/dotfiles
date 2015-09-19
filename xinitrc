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


# Input method {{{
xmodmap ~/.Xmodmaprc
if hash uim-xim &>/dev/null; then
	export GTK_IM_MODULE='xim'
	export QT_IM_MODULE='uim'
	export XMODIFIERS=@im=uim
	uim-xim &
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
urxvtd -q -f -o

# Compositor
hash compton && compton -b

# Turn down the blue gamma (less eye strain???) on laptop displays
xrandr | grep -q LVDS1 && xgamma -bgamma 0.8

# Notifications
hash dunst && dunst &

# Wallpaper
imlibsetroot -s f ~/pictures/wallpaper

sxhkd &
exec bspwm
