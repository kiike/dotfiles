if which uim-xim; then
	# Input method
	export GTK_IM_MODULE='xim'
	export QT_IM_MODULE='uim'
	export XMODIFIERS=@im=uim
	uim-xim &
fi

xmodmap ~/.Xmodmaprc
xmodmap -e 'keysym Alt_R = Hangul'

if which autocutsel; then
	# Sync clipboard and primary selection
	autocutsel -selection CLIPBOARD -fork
	autocutsel -selection PRIMARY -fork
fi

# Mouse
xsetroot -cursor_name left_ptr

# URxvt config and daemon
xrdb -load ~/.Xresources
urxvtd -q -f -o

# Compositor
which compton && compton -b

# Turn down the blue gamma (less eye strain???) on laptop displays
xrandr | grep -q LVDS1 && xgamma -bgamma 0.8

# Notifications
which compton && dunst &

# Wallpaper
imlibsetroot -s f ~/pictures/wallpaper

sxhkd &
exec bspwm
