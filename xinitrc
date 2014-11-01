# Disable Touchpad
function _disable_input_device() {
 DEV=$(xinput | grep $1 | sed "s/.*id=\(..\).*/\1/")
 [[ -n "$DEV" ]] && xinput --disable "$DEV"
}

_disable_input_device TouchPad

# Input method
export GTK_IM_MODULE='uim'
export QT_IM_MODULE='uim'
export XMODIFIERS=@im=uim
xmodmap ~/.Xmodmaprc
uim-xim &

# Mouse
xsetroot -cursor_name left_ptr

# Fonts
xset +fp ~/.fonts && xset fp rehash

# URxvt config and daemon
xrdb -load ~/.Xresources
urxvtd -q -f -o

# Compositor
compton -b

exec awesome
