--
-- Base16-based theme, translucent
-- by Enric Morales 2014
--

theme = {}

theme.font          = "Source Code Pro 10"

theme.bg_normal     = "#15151580"
theme.bg_focus      = theme.bg_normal
theme.bg_urgent     = theme.bg_normal
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#d0d0d0FF"
theme.fg_focus      = "#12cfc0FF"
theme.fg_urgent     = "#fb9fb1FF"
theme.fg_minimize   = "#151515ff"

theme.border_width  = 2
theme.border_normal = "#151515FF"
theme.border_focus  = "#12cfc0FF"
theme.border_marked = "#91231c"

theme.menu_submenu_icon = "/usr/share/awesome/themes/default/submenu.png"
theme.menu_height = 16
theme.menu_width  = 120

theme.wallpaper = "/home/kiike/pictures/wallpaper"

-- Hide Awesome menu icon
theme.awesome_icon = nil

theme.icon_theme = nil

-- Remove icons from tasklist
theme.tasklist_disable_icon = true

return theme
