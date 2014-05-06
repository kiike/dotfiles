# Input method
export GTK_IM_MODULE='uim'
export QT_IM_MODULE='uim'
export XMODIFIERS=@im=uim
uim-xim &

# Wallpaper
imlibsetroot -s f ~/pictures/wallpaper 2>&1 > /dev/null

# URxvt config and daemon
xrdb -load ~/.Xresources
urxvtd -q -f -o

# Compositor
compton -b

# Keyboard shortcuts
sxhkd &


exec bspwm
