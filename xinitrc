# Java workaround for Awesome WM
export _JAVA_AWT_WM_NONREPARENTING=1

# Input method and keyboard settings
export GTK_IM_MODULE='uim'
export QT_IM_MODULE='uim'
export XMODIFIERS='@im=uim'
uim-xim &
xmodmap ~/.Xmodmaprc

xrdb ${HOME}/.Xresources &

# Wine
export WINEARCH=win32

DisableInputDevice() {
	DEV=$(xinput | grep $1 | sed "s/.*id=\(..\).*/\1/")
	xinput --disable $DEV
}

DisableInputDevice TouchPad


# Color calibration and compositing
xcalib ~/.color.icm
compton -b --conf ~/.config/compton.conf

# Start URxvt daemon
urxvtd -q -f -o

# Clipboard synchronization and management
#autocutsel -selection PRIMARY -fork
#autocutsel -selection CLIPBOARD -fork
#anamnesis --start

# Wallpaper
imlibsetroot -s f ~/pictures/wallpaper

#exec awesome
sxhkd &
exec bspwm
