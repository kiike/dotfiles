-- Translucent, solarized theme
--[[ ! Gruvbox colors
! hard contrast:
*background: #1d2021
*foreground: #ebdbb2
! Black + DarkGrey
*color0:  #282828
*color8:  #928374
! DarkRed + Red
*color1:  #cc241d
*color9:  #fb4934
! DarkGreen + Green
*color2:  #98971a
*color10: #b8bb26
! DarkYellow + Yellow
*color3:  #d79921
*color11: #fabd2f
! DarkBlue + Blue
*color4:  #458588
*color12: #83a598
! DarkMagenta + Magenta
*color5:  #b16286
*color13: #d3869b
! DarkCyan + Cyan
*color6:  #689d6a
*color14: #8ec07c
! LightGrey + White
*color7:  #a89984
*color15: #ebdbb2

]]--

theme = {}

theme.font          = "Source Code Pro 10"

theme.bg_normal     = "#1d2021"
theme.bg_focus      = theme.bg_normal
theme.bg_urgent     = "#cc241d"
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#a89984"
theme.fg_focus      = "#ebdbb2"
theme.fg_urgent     = theme.fg_normal
theme.fg_minimize   = theme.fg_normal

theme.border_width  = 2
theme.border_normal = theme.fg_normal
theme.border_focus  = theme.fg_focus
theme.border_marked = "#91231c"

theme.menu_submenu_icon = "/usr/share/awesome/themes/default/submenu.png"
theme.menu_height = 16
theme.menu_width  = 120

theme.wallpaper = "pictures/wallpaper"

-- Hide Awesome menu icon
theme.awesome_icon = nil

theme.icon_theme = nil

-- Remove icons from tasklist
theme.tasklist_disable_icon = true

return theme
