-- Libraries
require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")
vicious=require("vicious")

-- Themes define colours, icons, and wallpapers
terminal = "evilvte"
term_exec = terminal .. " -e " 
modkey = "Mod4"
home = os.getenv("HOME")
awehome = os.getenv("XDG_DATA_HOME") .. "/awesome/"
beautiful.init(awehome .. "themes/ice/theme.lua")
local igor = io.popen("uname -n")
local hostname = igor:read("*line")
igor:close()


-- Autostart
awful.util.spawn("urxvtd")

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.max,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.max.fullscreen,
}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "!", "@", "#" }, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
session_menu = {   { "sys restart", "sudo systemctl reboot" },
		   { "sys poweroff", "sudo systemctl poweroff" },
		   { "sys suspend", "sudo pm-suspend" },
		   { "wm restart", awesome.restart },
		   { "wm quit", awesome.quit }
}

games_menu = {  { "openttd", "openttd" },
		{ "ivac", "wineexec '.wine/drive_c/Program Files/IVAO/IvAc/IvAc.exe'" },
		{ "teamspeak", "aoss TeamSpeak" },
		{ "pioneer", "pioneer" },
		{ "rct2", "wineexec '.wine/drive_c/Program Files/Infogrames/RollerCoaster Tycoon 2/rct2.exe'" },
		{ "timeshock", "wine '.wine/drive_c/Timeshock!/Timeshock!.exe'" }
}

main_menu = {	    { "session    >", session_menu },
		    { "games      >", games_menu },
		    { "------------", ""},
		    { "&cmus", term_exec .. "cmus"},
		    { "&firefox", "firefox -P kiike" },
		    { "&gimp", "gimp-2.8"},
		    { "&irssi", term_exec .. "irssi"},
		    { "&jaikoz", "./Jaikoz/jaikoz.sh"},
		    { "&luakit", "luakit"},
		    { "&newsbeuter", term_exec .. "newsbeuter" },
		    { "&mutt", term_exec .. "mutt"},
		    { "&qemu", "qemu-kvm -hda vm/WinXP -m 512 \
				-vga std -usb -usbdevice tablet \
				-device AC97,id=sound0,bus=pci.0,addr=0x4"},
		    { "&snes9x", "snes9x-gtk" },
		    { "&vifm", term_exec .. "vifm" },
		    { "&world clock", "scripts/tzdate a" }
	     }

awesome_menu = awful.menu({ items =  main_menu})

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = awesome_menu })
-- }}}

-- {{{ Misc widgets   
   -- Separator
   separator = widget({ type = "textbox", name = "separator" })
   separator.text = ' | '
-- }}}
                                 
-- {{{ Vicious widgets
   -- Battery widget
   vicious_bat = widget({ type = "textbox" })
   vicious.register(vicious_bat, vicious.widgets.bat, "↯$2%", 30, "BAT0")
 
   -- Date widget
   vicious_mail = widget({ type = "textbox" })
   vicious.register(vicious_mail, vicious.widgets.mdir, 
   function (widget, args)
	   if args[1] == 0
		   then return 
		   else return '✉ <span color="#dc322f">' .. args[1] .. "</span> | "
	   end
   end, 60, { home..'/mail/inbox' })
   

   --
   -- Date widget
   vicious_date = widget({ type = "textbox" })
   vicious.register(vicious_date, vicious.widgets.date, '%a %d %b, %H:%M')
-- }}}


-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if not c:isvisible() then
                                                  awful.tag.viewonly(c:tags()[1])
                                              end
                                              client.focus = c
                                              c:raise()
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        vicious_date,
        separator,
        vicious_bat,
	vicious_mail,
        s == 1 and mysystray or nil,
        mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
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
    awful.key({ modkey,           }, "a", function () awesome_menu:show({ keygrabber=true,
                                                                        coords={x=0,y=0}
                                                                     }) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
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

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),
    awful.key({ }, "XF86AudioLowerVolume", function () awful.util.spawn("./scripts/volume.sh s 3dB-") end),
    awful.key({ }, "XF86AudioRaiseVolume", function () awful.util.spawn("./scripts/volume.sh s 3dB+") end),
    awful.key({ }, "XF86AudioMute", function () awful.util.spawn("./scripts/volume.sh m") end),
    awful.key({ }, "XF86AudioPrev", function () awful.util.spawn("./scripts/remote.sh prev") end),
    awful.key({ }, "XF86AudioNext", function () awful.util.spawn("./scripts/remote.sh next") end),
    awful.key({ }, "XF86AudioStop", function () awful.util.spawn("./scripts/remote.sh stop") end),
    awful.key({ }, "XF86AudioPlay", function () awful.util.spawn("./scripts/remote.sh togglePause") end),

    -- Prompt
    awful.key({ modkey, "Shift"   }, "x",     function ()
	    					awful.util.spawn("/home/kiike/scripts/kblayout.sh")
						end),
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end)

)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "w",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
		     size_hints_honor = false,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { instance = "plugin-container" },
      properties = { floating = true, fullscreen = true },
      callback = awful.titlebar.add },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
	      properties = { 	tag = tags[1][3],
      			floating = true,
			switchtotag = true } },
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2], switchtotag = true} },
}

-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal( "focus",
	function(c)
			c.border_color = beautiful.border_focus
			c.opacity = 1
	end)

client.add_signal( "unfocus",
	function(c)
		if awful.layout.get(c.screen) == awful.layout.suit.max
		then
			c.border_color = beautiful.border_normal
			c.opacity = 0.1
		end

		-- will match terminals in other layouts
		if awful.layout.get(c.screen) ~= awful.layout.suit.max
		then
			c.border_color = beautiful.border_normal
			c.opacity = 0.7
		end
	end)
-- }}}

-- vim: fdm=marker
