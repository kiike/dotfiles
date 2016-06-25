--
-- Base16-based theme, translucent
--

local theme = {}

theme.base16 = {
    base00 = "#2d2d2d",
    base01 = "#393939",
    base02 = "#515151",
    base03 = "#747369",
    base04 = "#a09f93",
    base05 = "#d3d0c8",
    base06 = "#e8e6df",
    base07 = "#f2f0ec",
    base08 = "#f2777a",
    base09 = "#f99157",
    base0A = "#ffcc66",
    base0B = "#99cc99",
    base0C = "#66cccc",
    base0D = "#6699cc",
    base0E = "#cc99cc",
    base0F = "#d27b53"
    }

theme.colors = {
    black =  theme.base16.base00,
    blue = theme.base16.base0D,
    cyan = theme.base16.base0C,
    green = theme.base16.base0B,
    grey_dark =  theme.base16.base03,
    grey = theme.base16.base05,
    magenta = theme.base16.base0E,
    yellow = theme.base16.base0A,
    red =  theme.base16.base08,
    white = theme.base16.base07
    }


theme.bg_normal     = theme.colors.black .. "80"
theme.bg_focus      = theme.bg_normal
theme.bg_urgent     = theme.colors.red .. "80"
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = theme.colors.grey
theme.fg_focus      = theme.colors.white
theme.fg_urgent     = theme.fg_normal
theme.fg_minimize   = theme.fg_normal

theme.border_width  = 4
theme.border_normal = theme.colors.black
theme.border_focus  = theme.colors.grey
theme.border_marked = theme.colors.blue

theme.icon_theme = nil

theme.menu_height = 16
theme.menu_width  = 140

theme.taglist_bg_focus = theme.colors.blue
theme.taglist_fg_focus = theme.bg_focus

theme.tasklist_bg_focus = theme.bg_normal
theme.tasklist_disable_icon = true
theme.tasklist_fg_focus = theme.fg_normal

theme.tooltip_fg_color = theme.fg_normal
theme.tooltip_bg_color = theme.bg_normal

theme.wallpaper = "pictures/wallpaper"

theme.font = "Potipoti 10"

return theme
