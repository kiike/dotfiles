# Input method
export GTK_IM_MODULE='xim'
export QT_IM_MODULE='uim'
export XMODIFIERS=@im=uim
xmodmap ~/.Xmodmaprc
xmodmap -e 'keysym Alt_R = Hangul'
uim-xim &
uim-toolbar-gtk-systray &

# Sync clipboard and primary selection
autocutsel -selection CLIPBOARD -fork
autocutsel -selection PRIMARY -fork

# Mouse
xsetroot -cursor_name left_ptr

# Fonts
xset +fp ~/.fonts && xset fp rehash

# URxvt config and daemon
xrdb -load ~/.Xresources
urxvtd -q -f -o

# Compositor
compton -b

# Turn down the blue gamma (less eye strain???)
xgamma -bgamma 0.8

exec awesome
