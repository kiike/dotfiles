-- Gruvbox-based theme

local theme = {}

theme.font = "Noto Sans 10"

theme.colors = {
    black =	"#000000",
    white = "#ffffff",
    color50 = "#fff3e0",
    color100 = "#ffe0b2",
    color200 = "#ffcc80",
    color300 = "#ffb74d",
    color400 = "#ffa726",
    color500 = "#ff9800",
    color600 = "#fb8c00",
    color700 = "#f57c00",
    color800 = "#ef6c00",
    color900 = "#e65100",
    color100 = "#ffd180",
    color200 = "#ffab40",
    color300 = "#ff9100",
    color400 = "#ff6d00",
    blue = "#00bcd4",
    red = "#f44336",
    green = "#00C853"
    }


theme.bg_normal     = theme.colors.color500 .. "CC"
theme.bg_focus      = theme.bg_normal
theme.bg_urgent     = theme.colors.red .. "ff"
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = theme.colors.black
theme.fg_focus      = theme.colors.blue
theme.fg_urgent     = theme.fg_normal
theme.fg_minimize   = theme.fg_normal

theme.border_width  = 4
theme.border_normal = theme.colors.black
theme.border_focus  = theme.colors.blue
theme.border_marked = theme.colors.color500

theme.pomodoro_inactive = theme.fg_normal
theme.pomodoro_start = theme.colors.red
theme.pomodoro_end = theme.colors.green

theme.menu_height = 18
theme.menu_width  = 140
theme.menu_bg_normal  = theme.color100
theme.menu_width  = 140

theme.wallpaper = "pictures/wallpaper"
theme.awesome_icon = nil
theme.awesome_icon_color = theme.fg_focus .. "00"

theme.tasklist_bg_focus = theme.colors.color500 .. "00"
theme.tasklist_fg_focus = theme.fg_normal

theme.taglist_bg_focus = theme.colors.blue
theme.taglist_fg_focus = theme.colors.white

-- Hide icons
theme.icon_theme = nil
theme.tasklist_disable_icon = true

return theme
