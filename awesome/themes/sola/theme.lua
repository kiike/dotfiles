-- Translucent, solarized theme

theme = {}

theme.font          = "Source Code Pro 10"

theme.bg_normal     = "#07364280"
theme.bg_focus      = "#07364280"
theme.bg_urgent     = "#dc322f80"
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#839496"
theme.fg_focus      = "#eee8d5"
theme.fg_urgent     = theme.fg_normal
theme.fg_minimize   = theme.fg_normal

theme.border_width  = 2
theme.border_normal = theme.fg_normal
theme.border_focus  = theme.fg_focus
theme.border_marked = "#91231c"

theme.menu_submenu_icon = "/usr/share/awesome/themes/default/submenu.png"
theme.menu_height = 16
theme.menu_width  = 120

theme.wallpaper = "/home/kiike/pictures/pol.png"

-- Hide Awesome menu icon
theme.awesome_icon = nil

theme.icon_theme = nil

-- Remove icons from tasklist
theme.tasklist_disable_icon = true

return theme
