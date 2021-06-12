-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- Personal modules
--local cardstack = require("cardstack")
local typicons = require("typicons")
local vicious = require("vicious")
local pomodoro = require("pomodoro")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(awful.util.getdir("config") .. "/themes/xresources/theme.lua")

-- This is used later as the default terminal and editor to run.
local editor = os.getenv("EDITOR") or "nano"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"

local function take_screenshot(mode)
   local date = os.date("%Y%m%dT%H%M%S", os.time())
   local outdir = string.format("%s/pictures/screenshots", os.getenv("HOME"))

   local name = string.gsub(client.focus.name, " ", "_")
   name = string.gsub(name, "-", "_")
   name = string.gsub(name, "/", "_")

   local path = string.format("%s/%s-%s.png", outdir, date, name)

   print("Taking screenshot with mode", mode, "and storing it into", path)
   awful.spawn.easy_async({"take_screenshot", mode, path}, function() end)
end

-- Find a suitable X11 locker
local locker
for _, program in pairs({ "xlock", "slock", "i3lock"}) do
   for _, dir in pairs({ ("%s/%s"):format(home, "bin"), "/usr/X11R6/bin",
	                 "/usr/local/bin", "/usr/bin" }) do
      if gears.filesystem.is_dir(dir) and not locker then
	 local path = ("%s/%s"):format(dir, program)
	 if gears.filesystem.file_executable(path) then
	       locker = path
	       break
	 end
      end
   end
end

local home = os.getenv("HOME")

-- Find a suitable terminal emulator
local terminal
for _, term in pairs({ "termite", "alacritty", "urxvt", "xiate", "st", "xterm" }) do
   for _, dir in pairs({ ("%s/%s"):format(home, "bin"), "/usr/X11R6/bin",
	                 "/usr/local/bin", "/usr/bin" }) do
      if gears.filesystem.is_dir(dir) and not terminal then
	 local path = ("%s/%s"):format(dir, term)
	 if gears.filesystem.file_executable(path) then
	       terminal = path
	       break
	 end
      end
   end
end

local term_exec = terminal .. " -e "

-- Table of layouts to cover with awful.layout.inc, order matters.
-- TODO: Add cardstack,
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local session_menu = {
    { "sys reboot",  {{"confirm", "systemctl reboot"}} },
    { "sys poweroff", {{"confirm", "systemctl poweroff"}} },
    { "sys suspend", "systemctl suspend" },
    { "sys lock", locker },
    { "", nil},
    { "wm toggle notifications", function() naughty.suspended = not naughty.suspended end},
    { "wm restart", awesome.restart},
    { "wm quit", function() awesome.quit() end}
}

local games_menu = {
    { "steam", "steam" }
}

local main_menu = {
    { "session", session_menu },
    { "games", games_menu },
}

local menu = awful.menu(main_menu)
local launcher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                         menu = menu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Pomodoro
local my_pomodoro = pomodoro({always_show_timer=false})


-- Separators

local separator = wibox.widget.textbox()
separator:set_markup("<span font=\"Monospace\">  </span>")

local separator_small = wibox.widget.textbox()
separator_small:set_markup("<span font=\"Monospace\"> </span>")


-- {{{ Vicious widgets
local function get_battery()
    local ret = {false, nil}
    if #io.popen("sysctl -a 2>/dev/null| grep acpibat"):read("*all") > 0 then
       ret[1] = true
    end
    if awful.util.dir_readable("/sys/class/power_supply/BAT0") then
       ret[1] = true
       ret[2] = "BAT0"
    end
    return ret
end
-- Battery widget
local battery_present, battery_id = table.unpack(get_battery())
local widget_battery = wibox.widget.textbox()
if battery_present then
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
            if state == "−" or state == "-" then
                return string.format("%s %s", icon, args[3])
            else
                return icon
            end
        end, 30, battery_id)
end

-- Mail widget
local widget_mail = wibox.widget.textbox()
local notmuch_exists = awful.util.file_readable("/usr/bin/notmuch") or
		       awful.util.file_readable("/usr/local/bin/notmuch")

if notmuch_exists then -- notmuch_exists then
    vicious.register(widget_mail, vicious.widgets.notmuch,
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
  if condition ~= nil and not condition then return end

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
    shape = powercircle,
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

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.fit(wallpaper, s, "#000000")
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
      naughty.notify({title="Awesome WM", text=string.format("Preparing desktop for screen %d", s.index)})
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.focused,
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            launcher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            container,
        },
    }
end)
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey, "Mod1"    }, "l", function () awful.spawn.easy_async("slock", function() end) end,
              {description = "lock screen", group = "awesome"}),
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
    awful.key({ modkey,           }, "a", function () menu:show({coords = {x = 0, y = 0}}) end,
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
    awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn("ec") end,
       {description = "open an emacs window", group = "launcher"}),
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
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
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "t", function ()
          awful.layout.inc( 1)
          local message = "Activated layout: %s"
          message = message:format(awful.layout.getname())
          naughty.notify({text=message})
                                          end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "t", function () awful.layout.inc(-1)
          local message = "Activated layout: %s"
          message = message:format(awful.layout.getname())
          naughty.notify({text=message})
                                          end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey, "Shift"}, "r",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey, }, "r", function () awful.spawn("rofi -show window") end),
    awful.key({}, "Print", function () awful.spawn.easy_async("flameshot gui", function() end) end),
    awful.key({"Shift"}, "Print", function () take_screenshot("screen") end),
    awful.key({"Control", "Shift"}, "Print", function () take_screenshot("full") end),

    -- Manage the music player
    awful.key({}, "XF86AudioPrev", function () awful.spawn.easy_async("remote prev", function() end) end),
    awful.key({}, "XF86AudioNext", function () awful.spawn.easy_async("remote next", function() end) end),
    awful.key({}, "XF86AudioStop", function () awful.spawn.easy_async("remote stop", function() end) end),
    awful.key({}, "XF86AudioPlay", function () awful.spawn.easy_async("remote pause", function() end) end),

    -- Manage brightness
    awful.key({}, "XF86MonBrightnessUp", function () awful.spawn.easy_async("xbacklight +10", function() end) end),
    awful.key({}, "XF86MonBrightnessDown", function () awful.spawn.easy_async("xbacklight -10", function() end) end),

    -- Manage volume
    awful.key({}, "XF86AudioLowerVolume", function () awful.spawn.easy_async("volume d", function() end) end),
    awful.key({}, "XF86AudioRaiseVolume", function () awful.spawn.easy_async("volume u", function() end) end),
    awful.key({}, "XF86AudioMute", function () awful.spawn.easy_async("volume m", function() end) end),

    -- Kill or spawn compton
    awful.key({ modkey, "Shift"}, "c", function () awful.spawn("toggle_compton", function() end) end),

    -- Launcher prompt
    awful.key({ modkey, }, "space", function () awful.spawn.easy_async("rofi -show run", function() end) end),
    awful.key({ modkey, "Shift" }, "space", function () awful.spawn.easy_async("rofi -show window", function() end) end),
    awful.key({ modkey, "Control" }, "p", function () awful.spawn.easy_async("passes type -e", function() end) end),
    awful.key({ modkey, }, "p", function () awful.spawn.easy_async("passes type -e", function() end) end),
    awful.key({ modkey, }, "p", function () awful.spawn.easy_async("passes type", function() end) end),
    awful.key({ modkey, "Shift" }, "p", function () awful.spawn.easy_async("passes copy", function() end) end),
    awful.key({ modkey, }, "c", function () awful.spawn.easy_async("x t", function() end) end)
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey,           }, "w",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey, "Control" }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
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
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"}),
    
    awful.key({ modkey, "Control" }, "i",
      function(c)
        local props = "name: %s\nclass: %s\ninstance: %s\nrole: %s\ntype: %s"
        props = props:format(c.name, c.class, c.instance, c.role, c.type)
        naughty.notify({text=props})
      end,
      {description="show client info", group="client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
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
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = {
         focus = awful.client.focus.filter,
         raise = true,
         keys = clientkeys,
         buttons = clientbuttons,
         screen = awful.screen.preferred,
         placement = awful.placement.no_overlap+awful.placement.no_offscreen
      }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    if true or client.focus then
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
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
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
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal(
  'property::fullscreen', function(c)
    if c.fullscreen then
      gears.timer.delayed_call(
        function()
          gears.surface.apply_shape_bounding(c, gears.shape.rounded_rect, 0)
        end)
    else
      gears.timer.delayed_call(
        function()
          gears.surface.apply_shape_bounding(
            c, gears.shape.rounded_rect, beautiful.client_radius)
        end)
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
end)

naughty.config.notify_callback = function(notification)
   -- Ensmall size of icons
   notification.icon_size = 64
   -- Notificaions will no longer have infinite timeout
   if notification.timeout == 0 then notification.timeout = 5 end
   return notification
end
