-- Awesome libraries
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")

local wibox = require("wibox")
local vicious = require("vicious")
local beautiful = require("beautiful")
local naughty = require("naughty")

local cardstack = require("cardstack")

local typicons = require("typicons")

local host = io.popen("hostname"):read("l")
local host_conf = io.open(host .. ".rc.lua", "r")
local kbd = require("kbd")
local uim = require("uim")
local pomodoro = require("pomodoro")
if host_conf then
	require(host_conf)
end

-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
		title = "Startup errors:",
		text = awesome.startup_errors
		})
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Error",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
home = os.getenv("HOME")
awehome = home .. "/.local/share/awesome"

modkey = "Mod4"

terminal = "sakura"
term_exec = terminal .. " -e "

editor = os.getenv("EDITOR")
editor_cmd = term_exec .. editor

-- Theme {{{
beautiful.init(awehome .. "/themes/gruvbox/theme.lua")
if beautiful.wallpaper then gears.wallpaper.maximized(beautiful.wallpaper, s, true) end
--
-- }}}

local layouts = {
    cardstack,
    awful.layout.suit.max,
    awful.layout.suit.tile
}


-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ '1', '2', '3', '4'}, s, layouts[1])
end
-- }}}

-- {{{ Menu

-- Create a laucher widget and a main menu
session_menu = {
    { "sys restart",  {{"confirm", "sudo systemctl reboot"}} },
    { "sys poweroff", {{"confirm", "sudo systemctl poweroff"}} },
    { "sys suspend", "sudo systemctl suspend" },
    { "sys lock", term_exec .. "i3lock" },
    { "wm restart", awesome.restart },
    { "wm quit", awesome.quit }
}

games_menu = {
    { "openttd", "openttd" },
    { "steam", "steam" },
    { "ticket to ride", "/opt/ticket-to-ride/ticket-to-ride" },
    { "rct2", "launch_game rct2" },
    { "terraria", "steam -applaunch 105600" },
    { "timeshock", "wine '.wine/drive_c/Timeshock!/Timeshock!.exe'" }
}

main_menu = {
    { "session", session_menu },
    { "games", games_menu },
    { "", ""},
    { "&alot", term_exec .. "alot"},
    { "&bitwig", "bitwig-studio"},
    { "&cmus", term_exec .. "cmus"},
    { "&firefox", "firefox" },
    { "&gimp", "gimp-2.8"},
    { "&jaikoz", "./Jaikoz/jaikoz.sh"},
    { "&newsbeuter", term_exec .. "newsbeuter" },
    { "&snes9x", "snes9x-gtk" },
    { "&vifm", term_exec .. "vifm" },
    { "&world clock", "scripts/tzdate a" },
    { "writer", "libreoffice --writer" },
    { "w&eechat", term_exec .. "weechat-curses"}
}

awesome_menu = awful.menu({ items = main_menu})

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = awful.menu({ items = main_menu })
                                  })
-- }}}

-- {{{ Widgets

-- Input method
uim.widget = wibox.widget.textbox()
local uim_exists = awful.util.file_readable("/usr/bin/uim-sh")
if uim_exists then
    uim.start()
end

-- Pomodoro
pomodoro.init()

-- Icon for the keyboard layout and IM indicators
widget_kbd_typicon = wibox.widget.textbox()
widget_kbd_typicon:set_markup(typicons.render("keyboard"))

-- Separator
separator = wibox.widget.textbox()
separator:set_text(' ')

widget_kbd = wibox.widget.textbox()
widget_kbd:set_text(kbd.layout[kbd.current][1])
-- }}}

-- {{{ Vicious widgets
   -- Battery widget
   widget_battery = wibox.widget.textbox()
   battery_exists = awful.util.dir_readable("/sys/class/power_supply/BAT0")
   if battery_exists then
       vicious.register(widget_battery, vicious.widgets.bat,
            function (widget, args)
                local charge = args[2]
                if charge > 75 then return typicons.render("battery_full")
                elseif charge > 50 then return typicons.render("battery_high")
                elseif charge > 25 then return typicons.render("battery_mid")
                else return typicons.render("battery_low")
                end
            end, 30, "BAT0")
    end

   -- Mail widget
   widget_mail = wibox.widget.textbox()
   local notmuch_exists = awful.util.file_readable("/usr/bin/notmuch")
   if notmuch_exists then
       vicious.register(widget_mail, vicious.contrib.notmuch,
           function (widget, args)
               if args["count"] > 0 then return typicons.render("mail")
               else return ""
               end
           end, 60, 'tag:inbox AND tag:unread AND NOT tag:killed')
   end

   -- Date widget
   widget_datetime = wibox.widget.textbox()
   vicious.register(widget_datetime, vicious.widgets.date, '%a %d %b, %H:%M')
    -- }}}

-- {{{ Wibox

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mytasklist = {}
mytaglist = {}

    s = 1
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.focused)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])
    left_layout:add(separator)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(separator)
    if notmuch_exists then
        right_layout:add(widget_mail)
        right_layout:add(separator)
    end
    right_layout:add(separator)
    right_layout:add(pomodoro.widget, separator)
	right_layout:add(widget_kbd_typicon)
    right_layout:add(separator)
    right_layout:add(widget_kbd)
    right_layout:add(separator)

    if uim_exists then
        right_layout:add(uim.widget)
        right_layout:add(separator)
        right_layout:add(separator)
    end

    if battery_exists then
        right_layout:add(widget_battery)
        right_layout:add(separator)
    end

    right_layout:add(separator)
    right_layout:add(widget_datetime)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)

-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    awful.key({ modkey,           }, "a",
        function () awesome_menu:show()
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),

    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),

    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),

    awful.key({ modkey, "Control" }, "r", awesome.restart),

    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l", function () awful.tag.incmwfact( 0.05) end),
    awful.key({ modkey,           }, "h", function () awful.tag.incmwfact(-0.05) end),

    awful.key({ modkey, "Shift"   }, "h", function () awful.tag.incnmaster( 1)   end),
    awful.key({ modkey, "Shift"   }, "l", function () awful.tag.incnmaster(-1)   end),

    awful.key({ modkey, "Control" }, "h", function () awful.tag.incncol( 1)      end),
    awful.key({ modkey, "Control" }, "l", function () awful.tag.incncol(-1)      end),

    -- Cycle tiling modes
    awful.key({ modkey,           }, "t", function () awful.layout.inc(layouts, 1) end),

    -- Manage volume
    awful.key({}, "XF86AudioLowerVolume", function () awful.util.spawn("volume d") end),
    awful.key({}, "XF86AudioRaiseVolume", function () awful.util.spawn("volume u") end),
    awful.key({}, "XF86AudioMute",        function () awful.util.spawn("volume m") end),

    awful.key({ modkey,           }, "r", function () awful.util.spawn("dmenu_raise -i") end),

    -- Manage cmus
    awful.key({}, "XF86AudioPrev", function () awful.util.spawn("remote prev") end),
    awful.key({}, "XF86AudioNext", function () awful.util.spawn("remote next") end),
    awful.key({}, "XF86AudioStop", function () awful.util.spawn("remote stop") end),
    awful.key({}, "XF86AudioPlay", function () awful.util.spawn("remote pause") end),

    awful.key({ modkey, "Shift"}, "c", function () awful.util.spawn("toggle_compton") end),

    -- Keyboard layout/input method switching
    awful.key({ modkey, "Shift" }, "i", function () kbd.switch() end),

    -- Launcher prompt
    awful.key({ modkey,         }, "space",  function () awful.util.spawn("dmenu_run_recent") end),
    awful.key({ modkey, "Shift" }, "space",  function () awful.util.spawn("dmenu_term_run_recent") end),
    awful.key({ modkey,         }, "p",      function () awful.util.spawn("passmenu --type") end),
    awful.key({ modkey, "Shift" }, "p",      function () awful.util.spawn("passmenu") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c) c.fullscreen = not c.fullscreen  end),

    awful.key({ modkey, }, "w", function (c) c:kill()  end),

    -- Toggle "Always-on-top"
    awful.key({ modkey, "Shift"   }, "t",
        function (c) c.ontop = not c.ontop            end),

    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),

    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end))
end

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { instance = "plugin-container" },
      properties = { floating = true, fullscreen = true },
      callback = awful.titlebar.add },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "Terraria.bin.x86_64" },
      properties = { maximized=true} },
    { rule = { class = "Terraria.bin" },
      properties = { maximized=true} },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { tag = tags[1][3],
			floating = true,
			switchtotag = true } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][3], switchtotag = true} },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    if not awesome.startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

-- Enable sloppy focus
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
-- vim: fdm=marker ts=4 sts=4 sw=4
