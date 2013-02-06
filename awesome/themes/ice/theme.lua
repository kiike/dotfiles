-- Ice, a Solarized-based, simple theme by Enric Morales

theme = {}

theme.font = "Ubuntu 10"

theme.bg_normal   = "#00000060"
theme.bg_systray  = theme.bg_normal
theme.bg_focus    = "#073642ff"
theme.bg_urgent   = "#dc322f90"
theme.bg_minimize = "#44444490"

theme.fg_normal    = "#eeeeee"
theme.fg_focus     = "#ffffff"
theme.fg_urgent    = "#ffffff"
theme.fg_minimize  = "#ffffff"

-- {{{ Borders
theme.border_width  = 0
theme.border_normal = "#00000000"
theme.border_focus  = "#00000000"
theme.border_marked = "#00000000"

theme.menu_height = "15"
theme.menu_width  = "100"
theme.menu_fg_normal = "#aaaaaa"
theme.menu_border_color = "#000000ff"

-- Define the image to load
basedir = "/usr/share/awesome/themes/default/titlebar/"
theme.titlebar_close_button_normal = basedir .. "close_normal.png"
theme.titlebar_close_button_focus  = basedir .. "close_focus.png"

theme.titlebar_ontop_button_normal_inactive = basedir .. "ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = basedir .. "ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = basedir .. "ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = basedir .. "ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = basedir .. "sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = basedir .. "sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = basedir .. "sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = basedir .. "sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = basedir .. "floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = basedir .. "floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = basedir .. "floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = basedir .. "floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = basedir .. "maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = basedir .. "maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = basedir .. "maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = basedir .. "maximized_focus_active.png"

theme.awesome_icon = awehome .. "themes/ice/awesome16.png"

return theme
-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
