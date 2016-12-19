-- Create a widget that shows mpd's current state

local awful = require("awful")
local mpc = require("mpc")
local tbox = require("wibox.widget.textbox")
local setmetatable = setmetatable

local mpd_mod = {}

local function ellipsize(str, len)
	local l = str:len()
	if l < len then
		return str
	end
	return str:sub(1, len - 3) .. "…"
end

local widget = tbox()
local state, title, artist, file = "stop", "", "", ""

local function get()
	if title and artist then
		return artist .. " - " .. title
	elseif title then
		return title
	elseif artist then
		return artist
	elseif file then
		return file
	else
		return "error"
	end
end

local function info()
	local song = ellipsize(get() or "ERROR", 40)

  local icons = {
		pause = "<span font='Noto Sans'>&#10074;&#10074;</span>",
		stop = "<span font='Noto Sans'>&#9726;</span>",
    play = "<span font='Noto Sans'>&#9658;</span>"
  }

	return string.format("%s %s", icons[state], awful.util.escape(song))
end

local function error_handler(err)
end

local c = mpc.new("localhost", 6600, "", error_handler, "status", function(_, result)
	state = result.state
end, "currentsong", function(_, result)
	title, artist, file = result.title, result.artist, result.file
	pcall(function() widget:set_markup(info()) end)
end)

function mpd_mod.toggle()
	c:toggle_play()
end

return setmetatable(mpd_mod, { __call = function (_) return widget end })
