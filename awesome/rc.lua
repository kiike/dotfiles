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
local pomodoro = require("pomodoro")

local typicons = require("typicons")

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
            text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(awful.util.getdir("config") .. "/themes/xresources/theme.lua")
if beautiful.wallpaper then gears.wallpaper.maximized(beautiful.wallpaper, s, false) end

local modkey = "Mod4"
-- }}}

-- Find a suitable terminal emulator
local terminal = "xterm"
local terms = {"termite", "urxvt", "st"}
for _, term in pairs(terms) do
  if awful.util.file_readable("/usr/bin/" .. term) then
    terminal = "/usr/bin/" .. term
    break
  elseif awful.util.file_readable("/usr/local/bin/" .. term) then
    terminal = "/usr/local/bin/" .. term
    break
  end
end

local term_exec = terminal .. " -e "

-- {{{
local tiling_layouts = {
    cardstack,
    awful.layout.suit.max,
    awful.layout.suit.tile
}
awful.layout.layouts = tiling_layouts
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
local tags = {}
awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "!", "@", "#", "$" }, s,
      {tiling_layouts[1], tiling_layouts[1], tiling_layouts[2], tiling_layouts[1]})
end)
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
local session_menu = {
    { "sys reboot",  {{"confirm", "systemctl reboot"}} },
    { "sys poweroff", {{"confirm", "systemctl poweroff"}} },
    { "sys suspend", "systemctl suspend" },
    { "sys lock", term_exec .. "i3lock" },
    { "", nil},
    { "wm restart", awesome.restart},
    { "wm quit", function() awesome.quit() end}
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

local awesome_menu = awful.menu(main_menu)

-- {{{ Widgets
-- Draw an awesome Awesome icon (needs patched font)
local awesome_icon_color = beautiful.awesome_icon_color or beautiful.colors.color1 or "#FFFFFF"
local awesome_icon_markup = "<span font='Potipoti 24' fgcolor='%s'>&#57680;</span>"
local awesome_icon = wibox.widget.textbox(awesome_icon_markup:format(awesome_icon_color))
awesome_icon:buttons(gears.table.join(awful.button({ }, 1, function() awesome_menu:toggle() end)))

-- Now playing widget: to be set by scripts via awesome-client
now_playing_widget = wibox.widget.textbox()

-- Pomodoro
local my_pomodoro = pomodoro({always_show_timer=false})


-- Separators

local separator = wibox.widget.textbox()
separator:set_markup("<span font=\"Monospace\">  </span>")

local separator_small = wibox.widget.textbox()
separator_small:set_markup("<span font=\"Monospace\"> </span>")


-- {{{ Vicious widgets
-- Battery widget
local widget_battery = wibox.widget.textbox()
local battery_exists = awful.util.dir_readable("/sys/class/power_supply/BAT0") 
if battery_exists then
    vicious.register(widget_battery, vicious.widgets.bat,
        function (_, args)
            local charge = args[2]
            local icon
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
local widget_mail = wibox.widget.textbox()
local notmuch_exists = awful.util.file_readable("/usr/bin/notmuch")
if notmuch_exists then
    vicious.register(widget_mail, vicious.contrib.notmuch,
        function (_, args)
            if args["count"] > 0 then
                return typicons.render("mail")
            else
              return ""
            end
        end, 60, 'tag:inbox AND NOT tag:killed AND tag:unread AND NOT folder:trash')
end

-- Date widget
local widget_datetime = wibox.widget.textbox()
vicious.register(widget_datetime, vicious.widgets.date, '%a %d %b, %H:%M')

-- Powercircle
-- Like powerarrow, but with circles and similar to rectangular_tag, just ending
-- with a semicircle instead of a triangle.
local function powercircle(cr, w, h)
  local r = h/2
  cr:arc(r, r, r, 0, -math.pi/2)
  cr:line_to(w, 0)
  cr:line_to(w, h)
  cr:line_to(r, h)
  cr:close_path()
end

local function powercircle_inv(cr, w, h)
  local r = h/2
  cr:move_to(0,0)
  cr:line_to(w-r, 0)
  cr:arc(w-r, r, r, -math.pi/2, math.pi/2)
  cr:line_to(0, h)
  cr:close_path()
end


local function containerize(widget, bg, left_margin, right_margin, condition)
  if condition ~= nil and not condition then
    return
  end

  local c = wibox.container.background()
  c:setup({
      {
        {
          widget = widget
        },
        left  = left_margin or 0,
        right = right_margin or 0,
        widget = wibox.container.margin
      },
      fg     = beautiful.container_fg or beautiful.colors.fg_normal,
      bg     = bg or beautiful.colors.bg_normal,
      widget = wibox.container.background
  })
  return c
end

local container = wibox.container.background()
container:setup({
  -- parameters: widget, background color, left margin, right margin, condition
    containerize(widget_mail,          beautiful.colors.color1, 10, 10, notmuch_exists),

    containerize(my_pomodoro.icon_widget,   beautiful.colors.color2, 10,  0),
    containerize(my_pomodoro.timer_widget,   beautiful.colors.color3, 0,  20),

    containerize(widget_battery,       beautiful.colors.color4, 15, 15, battery_exists),
    containerize(widget_datetime,      beautiful.colors.color5, 15, 15),

    -- Add a small padding container
    {
      {
        left  = 5,
        right = 0,
        widget = wibox.container.margin
      },
      bg         = beautiful.colors.color5 .. "80",
      widget     = wibox.container.background
    },
    --shape = powercircle,
    spacing = 0,
    layout = wibox.layout.fixed.horizontal
})

local container_taglist = wibox.container.background()
container_taglist:setup({
    {
      {widget = separator},
      --shape = powercircle,
      bg = beautiful.taglist_bg_normal,
      widget = wibox.container.background
    },
    {
      {widget = awful.widget.taglist(1, awful.widget.taglist.filter.all)},
      bg = beautiful.taglist_bg_normal,
      widget = wibox.container.background
    },
    {
      {widget = separator},
      --shape = powercircle_inv,
      bg = beautiful.taglist_bg_normal,
      widget = wibox.container.background
    },
    spacing = 0,
    layout = wibox.layout.fixed.horizontal
})
-- {{{ Wibox

-- Create a wibox for each screen and add it
local mywibox = {}
local mypromptbox = {}
local mytasklist = {}

local s = 1
-- Create a promptbox for each screen
mypromptbox[s] = awful.widget.prompt()

-- Create a tasklist widget
mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.focused)

-- Create the wibox
mywibox[s] = awful.wibar({ position = "top", screen = s })

-- Widgets that are aligned to the left
local left_layout = wibox.layout.fixed.horizontal()
left_layout:add(separator_small, awesome_icon, separator)
left_layout:add(container_taglist)
left_layout:add(mypromptbox[s])
left_layout:add(separator)

-- Widgets that are aligned to the right
local right_layout = wibox.layout.fixed.horizontal()
if s == 1 then right_layout:add(wibox.widget.systray()) end

right_layout:add(container)

-- Now bring it all together (with the tasklist in the middle)
local layout = wibox.layout.align.horizontal()
layout:set_left(left_layout)
layout:set_middle(mytasklist[s])
layout:set_right(right_layout)

mywibox[s]:set_widget(layout)
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
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
    awful.key({ modkey,           }, "a", function () awesome_menu:show({coords = {x = 0, y = 0}}) end,
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
    awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn.spawn("emacsclient -nc") end,
      {description = "open an emacs window", group = "launcher"}),
    awful.key({ modkey,           }, "Return", function () awful.spawn.spawn(terminal) end,
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
                      client.focus = c c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),


    awful.key({ modkey, }, "r", function () awful.spawn.spawn("rofi -show window") end),
    awful.key({}, "Print", function ()
        local date = os.date("%Y%m%dT%H%M%S", os.time())
        local outdir = string.format("%s/pictures/screenshots", os.getenv("HOME"))
        local name = string.gsub(client.focus.name, " ", "_")
        local cmd = string.format("scrot %s/%s-%s.png", outdir, date, name)
        awful.spawn.spawn(cmd)
    end),

    -- Manage the music player
    awful.key({}, "XF86AudioPrev", function () awful.spawn.spawn("remote prev") end),
    awful.key({}, "XF86AudioNext", function () awful.spawn.spawn("remote next") end),
    awful.key({}, "XF86AudioStop", function () awful.spawn.spawn("remote stop") end),
    awful.key({}, "XF86AudioPlay", function () awful.spawn.spawn("remote pause") end),

    -- Manage volume
    awful.key({}, "XF86AudioLowerVolume", function () awful.spawn.spawn("volume d") end),
    awful.key({}, "XF86AudioRaiseVolume", function () awful.spawn.spawn("volume u") end),
    awful.key({}, "XF86AudioMute", function () awful.spawn.spawn("volume m") end),

    awful.key({modkey}, "m", function ()
        local matcher = function (c)
          return awful.rules.match(c, {class = 'ncmpcpp'})
        end
        local cmd = terminal .. " --class=ncmpcpp -e ncmpcpp"
        awful.client.run_or_raise(cmd, matcher)
    end),

    -- Kill or spawn compton
    awful.key({ modkey, "Shift"}, "c", function () awful.spawn.spawn("toggle_compton") end),

    -- Launcher prompt
    awful.key({ modkey, }, "space", function () awful.spawn.spawn("rofi -show run") end),
    awful.key({ modkey, "Shift" }, "space", function () awful.spawn.spawn("rofi -show window") end),
    awful.key({ modkey, }, "p", function () awful.spawn.spawn("passmenu --type") end),
    awful.key({ modkey, "Shift" }, "p", function () awful.spawn.spawn("passmenu") end),
    awful.key({ modkey, }, "c", function () awful.spawn.spawn("x t") end)
)

local clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),

    awful.key({ modkey, "Control" }, "i",
      function(c)
        local props = "name: %s\nclass: %s\ninstance: %s\nrole:%s\ntype:%s"
        props = props:format(c.name, c.class, c.instance, c.role, c.type)
        naughty.notify({text=props})
      end,
      {description="show client info", group="client"}),

    awful.key({ modkey,           }, "w",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey, "Shift"   }, "o",      function (c) c.always_opaque = not c.always_opaque    end,
              {description = "toggle always-opaque mode", group = "client"}),
    awful.key({ modkey, "Shift" }, "m",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.maximized = not c.maximized
        end ,
        {description = "toggle maximize", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"})
)

-- Bind all key numbers to tags.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 4 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
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
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
                     } },

    -- Always opaque
    { rule_any = {
        class = {
            "mpv"
        },
    },

    properties = { always_opaque = true }},

    -- Always opaque
    { rule_any = {
        class = {
	   "sun-awt-X11-XFramePeer"
        },
    },
	 properties = { floating = false, size_hints_honor = false }},


    -- Fullscreen games
    { rule_any = {
        class = {
          "OrcishInn.bin.x86_64"
	  "Euro Truck Simulator 2"
        },
    },
    properties = { fullscreen = true}},

    { rule = {
        name = "qutebrowser",
        instance = "qutebrowser",
        class = "qutebrowser",
        type = "utility"
    },
      properties = {
        floating = true
    }},
    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "pinentry",
          },

        name = {
          "Event Tester",  -- xev.
        },

        role = {
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)

                        if awesome.startup and
                          not c.size_hints.user_position
                        and not c.size_hints.program_position then
                          -- Prevent clients from being unreachable after screen count changes.
                          awful.placement.no_offscreen(c)
                        end

                        if client.focus then
                          client.opacity = 1.0
                        else
                          client.opacity = 0.6
                        end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
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
            buttons = buttons,
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
end)

-- Enable sloppy focus, so that focus follows mouse.
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
        if not c.always_opaque then
            c.opacity = 0.6
        end
    end)
-- }}}
