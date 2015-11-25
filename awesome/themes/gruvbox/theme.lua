-- Gruvbox-based theme

theme = {}

theme.font = "Potipoti 10"

theme.colors = {
    black =	"#282828",
    grey_dark = "#928374",
    red_dark = "#cc241d",
    red = "#fb4934",
    green_dark = "#98971a",
    green = "#b8bb26",
    yellow_dark = "#d79921",
    yellow = "#fabd2f",
    blue_dark = "#458588",
    blue = "#83a598",
    magenta_dark = "#b16286",
    magenta = "#d3869b",
    cyan_dark = "#689d6a",
    cyan = "#8ec07c",
    grey = "#a89984",
    white = "#ebdbb2"
    }


theme.bg_normal     = theme.colors.black
theme.bg_focus      = theme.bg_normal
theme.bg_urgent     = theme.colors.red
theme.bg_minimize   = theme.bg_normal
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = theme.colors.grey_dark
theme.fg_focus      = theme.colors.white
theme.fg_urgent     = theme.fg_normal
theme.fg_minimize   = theme.fg_normal

theme.border_width  = 4
theme.border_normal = theme.colors.grey_dark
theme.border_focus  = theme.fg_focus
theme.border_marked = theme.colors.blue

theme.menu_height = 16
theme.menu_width  = 140

theme.wallpaper = "pictures/wallpaper"

-- Hide icons
theme.awesome_icon = nil
theme.icon_theme = nil
theme.tasklist_disable_icon = true

return theme
