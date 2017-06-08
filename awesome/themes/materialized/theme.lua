-- Material Colors-based theme

local theme = {}

theme.colors = require("materialcolors")

theme.font         = "Noto Sans 10"
theme.taglist_font = "Noto Sans Bold 11"


theme.bg_normal     = theme.colors.black .. "80"
theme.bg_focus      = theme.bg_normal
theme.bg_urgent     = theme.colors.red.shade_500 .. "ff"
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = theme.colors.white .. "a0"
theme.fg_secondary  = theme.colors.black .. "a0"
theme.fg_focus      = theme.colors.blue.shade_500
theme.fg_urgent     = theme.fg_normal
theme.fg_minimize   = theme.fg_normal

theme.border_width  = 1
theme.border_normal = theme.colors.orange.shade_50
theme.border_focus  = theme.colors.orange.shade_500
theme.border_marked = theme.colors.blue.shade_500

theme.pomodoro_inactive = theme.fg_secondary
theme.pomodoro_work     = theme.colors.red.shade_500
theme.pomodoro_pause    = theme.colors.green.shade_500

theme.menu_height    = 18
theme.menu_width     = 140

theme.wallpaper = "pictures/wallpaper"

theme.awesome_icon_color = theme.fg_focus .. "00"

theme.tasklist_bg_focus = theme.bg_normal .. "00"
theme.tasklist_fg_focus = "#FFFFFF"
theme.tasklist_disable_icon = true

theme.taglist_bg_focus = theme.colors.blue.shade_400
theme.taglist_fg_focus = theme.bg_normal
theme.taglist_fg_occupied = "#404040"
theme.taglist_fg_empty = "#909090"
theme.taglist_bg_normal = theme.colors.orange.shade_500

theme.tooltip_fg = theme.fg_normal

theme.container_fg = theme.fg_secondary

theme.icon_theme = nil

return theme
