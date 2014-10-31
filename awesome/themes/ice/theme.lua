theme = {}

theme.font = "Source Code Pro 10"

theme.bg_normal   = "#00000060"
theme.bg_systray  = theme.bg_normal
theme.bg_focus    = theme.bg_normal
theme.bg_minimize = theme.bg_normal
theme.bg_urgent   = "#dc322f60"

theme.fg_normal    = "#aaaaaa"
theme.fg_focus     = "#ffffff"
theme.fg_urgent    = "#ffffff"
theme.fg_minimize  = "#ffffff"

theme.border_width  = 0
theme.border_normal = "#00000000"
theme.border_focus  = "#00000000"
theme.border_marked = "#00000000"

theme.menu_height       = "15"
theme.menu_width        = "100"
theme.menu_fg_normal    = "#aaaaaa"
theme.menu_border_color = "#000000ff"

theme.widget_mail_read = awehome .. "/themes/ice/mail_read.png"
theme.widget_mail_unread = awehome .. "/themes/ice/mail_unread.png"
theme.widget_battery = awehome .. "/themes/ice/battery.png"
theme.widget_date = awehome .. "/themes/ice/cal.png"

theme.awesome_icon = awehome .. "/themes/ice/awesome16.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
