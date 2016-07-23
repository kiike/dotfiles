-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
local vicious = require("vicious")
-- Notification library
local naughty = require("naughty")

local hotkeys_popup = require("awful.hotkeys_popup").widget
local cardstack = require("cardstack")

local typicons = require("typicons")

local kbd = require("kbd")
local uim = require("uim")
local pomodoro = require("pomodoro")

local host = io.popen("hostname"):read("l")
local host_conf = io.open(host .. ".rc.lua", "r")
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
-- Themes define colours, icons, font and wallpapers.
beautiful.init(awful.util.getdir("config") .. "/themes/base16/theme.lua")
if beautiful.wallpaper then gears.wallpaper.maximized(beautiful.wallpaper, s, true) end

local home = os.getenv("HOME")
local modkey = "Mod4"
-- }}}

-- Find terminals and set the first available one
local terms = {"termite", "urxvt", "st", "xterm"}
for term in pairs(terms) do
    if awful.util.file_readable("/usr/bin/" .. terms[term]) then
        terminal = "/usr/bin/" .. terms[term]
        break
    end
end

term_exec = terminal .. " -e "
editor_cmd = term_exec .. os.getenv("EDITOR")


-- {{{
awful.layout.layouts = {
    cardstack,
    awful.layout.suit.max,
    awful.layout.suit.tile
}
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4 }, s, awful.layout.layouts[1])
end)
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
local session_menu = {
    { "sys restart", {{"confirm", "sudo systemctl reboot"}} },
    { "sys poweroff", {{"confirm", "sudo systemctl poweroff"}} },
    { "sys suspend", "sudo systemctl suspend" },
    { "sys lock", term_exec .. "i3lock" },
    { "wm restart", awesome.restart },
    { "wm quit", awesome.quit }
}

local games_menu = {
    { "openttd", "openttd" },
    { "steam", "steam" },
    { "ticket to ride", "/opt/ticket-to-ride/ticket-to-ride" },
    { "rct2", "launch_game rct2" },
    { "terraria", "steam -applaunch 105600" },
    { "timeshock", "wine '.wine/drive_c/Timeshock!/Timeshock!.exe'" }
}

local main_menu = {
    { "session", session_menu },
    { "games", games_menu },
    { "", nil},
    { "&alot", term_exec .. "alot"},
    { "&bitwig", "bitwig-studio"},
    { "&firefox", "firefox" },
    { "&gimp", "gimp-2.8"},
    { "&jaikoz", "./Jaikoz/jaikoz.sh"},
    { "&mocp", term_exec .. "mocp"},
    { "&newsbeuter", term_exec .. "newsbeuter" },
    { "&snes9x", "snes9x-gtk" },
    { "&vifm", term_exec .. "vifm" },
    { "&world clock", "scripts/tzdate a" },
    { "writer", "libreoffice --writer" },
    { "w&eechat", term_exec .. "weechat-curses"}
}

local awesome_menu = awful.menu({items = main_menu})

-- {{{ Widgets
-- Draw an awesome Awesome icon (needs patched font)
local awesome_icon_markup = "<span font='24' fgcolor='%s'>&#57680;</span>"
local awesome_icon = wibox.widget.textbox(awesome_icon_markup:format(beautiful.colors.blue))
awesome_icon:buttons(awful.util.table.join(awful.button({ }, 1, function() awesome_menu:toggle() end)))

-- Now playing widget: to be set by scripts via awesome-client
now_playing_widget = wibox.widget.textbox()

-- Input method
uim.widget = wibox.widget.textbox()
local uim_exists = awful.util.file_readable("/usr/bin/uim-sh")
local check_uim = function()
    local uim_timer = timer({timeout = 15})
    uim_timer:connect_signal("timeout", function()
        uim.start()
        if uim.connected then
            uim_timer:stop()
        else
            uim_timer:restart()
        end

    end)
    uim_timer:start()
end

if uim_exists then
    uim.start()
    if not uim.connected then
        check_uim()
    end
end

-- Pomodoro
pomodoro.init()

-- Icon for the keyboard layout and IM indicators
widget_kbd_typicon = wibox.widget.textbox()
widget_kbd_typicon:set_markup(typicons.render("keyboard"))

-- Separators

local function make_separator(color)
    local separator = wibox.widget.textbox()
    local markup = "<span fgcolor='%s'> | </span>"
    separator:set_markup(markup:format(color))
    return separator
end

separator = wibox.widget.textbox()
separator:set_text(" ")

separator_green = make_separator(beautiful.colors.green)
separator_yellow = make_separator(beautiful.colors.yellow)
separator_magenta = make_separator(beautiful.colors.magenta)
separator_red = make_separator(beautiful.colors.red)
separator_blue = make_separator(beautiful.colors.blue)

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
            if charge > 75 then icon = typicons.render("battery_full")
            elseif charge > 50 then icon = typicons.render("battery_high")
            elseif charge > 25 then icon = typicons.render("battery_mid")
            else icon = typicons.render("battery_low")
            end

            local state = args[1]
            if state == "−" then
                return string.format("%s %s", icon, args[3])
            else
                return icon
            end
        end, 30, "BAT0")
end

-- Mail widget
widget_mail = wibox.widget.textbox()
local notmuch_exists = awful.util.file_readable("/usr/bin/notmuch")
if notmuch_exists then
    vicious.register(widget_mail, vicious.contrib.notmuch,
        function (widget, args)
            if args["count"] > 0 then
                return typicons.render("mail")
            else
              return ""
            end
        end, 60, 'tag:inbox AND NOT tag:killed AND tag:unread AND NOT folder:trash')
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
mywibox[s] = awful.wibar({ position = "top", screen = s })

-- Widgets that are aligned to the left
local left_layout = wibox.layout.fixed.horizontal()
left_layout:add(separator, awesome_icon, separator)
left_layout:add(mytaglist[s])
left_layout:add(mypromptbox[s])
left_layout:add(separator)

-- Widgets that are aligned to the right
local right_layout = wibox.layout.fixed.horizontal()
if s == 1 then right_layout:add(wibox.widget.systray()) end

right_layout:add(now_playing_widget, separator)

if notmuch_exists then
    right_layout:add(widget_mail, separator)
end

right_layout:add(pomodoro.icon_widget, pomodoro.widget, separator_yellow)
right_layout:add(widget_kbd_typicon, separator)
right_layout:add(widget_kbd, separator)

if uim_exists then
    right_layout:add(uim.widget)
end

if battery_exists then
    right_layout:add(separator_green, widget_battery, separator_blue)
end

right_layout:add(widget_datetime)

-- Now bring it all together (with the tasklist in the middle)
local layout = wibox.layout.align.horizontal()
layout:set_left(left_layout)
layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

mywibox[s]:set_widget(layout)

-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "a", function () awesome_menu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol(1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "t", function () awful.layout.inc(1)                end,
              {description = "select next", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Manage volume
    awful.key({}, "XF86AudioLowerVolume", function () awful.util.spawn("volume d") end),
    awful.key({}, "XF86AudioRaiseVolume", function () awful.util.spawn("volume u") end),
    awful.key({}, "XF86AudioMute", function () awful.util.spawn("volume m") end),

    awful.key({ modkey, }, "r", function () awful.util.spawn("dmenu_raise -i") end),

    -- Manage the music player
    awful.key({}, "XF86AudioPrev", function () awful.util.spawn("remote prev") end),
    awful.key({}, "XF86AudioNext", function () awful.util.spawn("remote next") end),
    awful.key({}, "XF86AudioStop", function () awful.util.spawn("remote stop") end),
    awful.key({}, "XF86AudioPlay", function () awful.util.spawn("remote pause") end),

    -- Kill or spawn compton
    awful.key({ modkey, "Shift"}, "c", function () awful.util.spawn("toggle_compton") end),

    -- Keyboard layout/input method switching
    awful.key({ modkey, "Shift" }, "i", function () kbd.switch() end),

    -- Launcher prompt
    awful.key({ modkey, }, "space", function () awful.util.spawn("dmenu_run_recent") end),
    awful.key({ modkey, "Shift" }, "space", function () awful.util.spawn("dmenu_term_run_recent") end),
    awful.key({ modkey, }, "p", function () awful.util.spawn("passmenu --type") end),
    awful.key({ modkey, "Shift" }, "p", function () awful.util.spawn("passmenu") end),
    awful.key({ modkey, }, "c", function () awful.util.spawn("x t") end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end),
    awful.key({ modkey,           }, "w",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey, "Shift"   }, "o",      function (c) c.always_opaque = not c.always_opaque    end,
              {description = "toggle always-opaque mode", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 4 do
    globalkeys = awful.util.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
     awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.movetotag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = awful.tag.gettags(client.focus.screen)[i]
                          if tag then
                              awful.client.toggletag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     always_opaque = false,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },

    -- Always opaque
    { rule_any = {
        class = {
            "mpv"
        },
    },

    properties = { always_opaque = true }},

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    if not awesome.startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they do not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    elseif not c.size_hints.user_position and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    if client.focus then
        client.opacity = 1.0
    else
        client.opacity = 0.6
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

        -- Titlebar config
        awful.titlebar(c) : setup {
            { -- Left
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout  = wibox.layout.fixed.horizontal
            },
            { -- Middle
                { -- Title
                    align  = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                bttons = buttons,
                layout  = wibox.layout.flex.horizontal
            },
            { -- Right
                awful.titlebar.widget.floatingbutton (c),
                awful.titlebar.widget.maximizedbutton(c),
                awful.titlebar.widget.stickybutton   (c),
                awful.titlebar.widget.ontopbutton    (c),
                awful.titlebar.widget.closebutton    (c),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        }

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

client.connect_signal("focus",
    function(c)
        c.border_color = beautiful.border_focus
        c.opacity = 1
    end)

client.connect_signal("unfocus",
    function(c)
        c.border_color = beautiful.border_normal
        if c.always_opaque then
            c.opacity = 0.6
        end
    end)
-- }}}
