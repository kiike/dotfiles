-- Keyboard map indicator and changer
local kbd = {}

kbd.cmd = "setxkbmap"
kbd.layout = { { "us", "-option" },
               { "es", "-option" }
             }
kbd.current = 1
kbd.switch = function ()
        kbd.current = kbd.current % #(kbd.layout) + 1
        local t = kbd.layout[kbd.current]
        widget_kbd:set_text(t[1])
        os.execute(kbd.cmd .. " " .. t[1] .. " " .. t[2])
        os.execute("xmodmap ~/.Xmodmaprc")
        if t[1] == "us" then
            os.execute("xmodmap -e 'remove mod1 = Alt_R'")
            os.execute("xmodmap -e 'keysym Alt_R = Hangul'")
        end
    end

return kbd
