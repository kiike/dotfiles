-- uim.lua
-- an Awesome WM plugin that monitors the UIM socket to listen for
-- changes and output them within the WM.
-- Credits: psychon, Enric Morales

-- Lua libraries
local glib = require("lgi").GLib
local gio = require("lgi").Gio
local naughty = require("naughty")

local uim = {}

uim.start = function ()
	local runtime_dir = os.getenv("XDG_RUNTIME_DIR")
	local socket_path = string.format("%s/uim/socket/uim-helper", runtime_dir)

	local socket = gio.Socket.new(gio.SocketFamily.UNIX, gio.SocketType.STREAM, gio.SocketProtocol.DEFAULT)

	--local success = false
	uim.connected = socket:connect(gio.UnixSocketAddress.new(socket_path))
	if uim.connected then
        naughty.notify({title="UIM Eye", text="UIM Eye active."})
    else
        return false
    end
	local fd = socket:get_fd()
	local stream = gio.DataInputStream.new(gio.UnixInputStream.new(fd, false))
	local start_read, finish_read
	local t = {}

	start_read = function()
		stream:read_line_async(glib.PRIORITY_DEFAULT, nil, finish_read)
	end
	finish_read = function(obj, res)
		local line, length = obj:read_line_finish(res)
		if type(length) ~= "number" then
			-- Error
			naughty.notify({title="UIM Eye", text="Read Error: " .. tostring(length)})
			stream:close()
			socket:shutdown(true, true)
		elseif #line ~= length then
			naughty.notify({title="UIM Eye", text="Read Error: End of file"})
			stream:close()
			socket:shutdown(true, true)
		else
			line = string.gsub(line, "\t", " ")
			local branch = string.match(line, "branch%s%S+%s(%S+)")

			if string.match(line, "^$") then
				if #t == 2 then
					uim.widget:set_text(string.format("%s %s", t[1], t[2]))
				end
				t = {}

				elseif branch then
					t[#t+1] = branch
				end
				start_read()
		end
	end
	start_read()
	return true
end
return uim
