------------------------------------------------------------------------
-- card stack layout by Enric Morales
-- based on max.lua by Julien Danjou
------------------------------------------------------------------------

-- Grab environment we need
local pairs = pairs
local client = require("awful.client")

--- card stack layout
local cardstack = {}

local function fcardstack(p)
    area = p.workarea
    for k, c in pairs(p.clients) do
		local x_offset = 18 * k
        local g = {
			x = x_offset + area.width / 6,
			y = area.y,
			width = (area.width - c.border_width * 2) * (2 / 3),
			height = area.height - c.border_width * 2
			}
			c:geometry(g)
    end
end

-- @param screen The screen to arrange.
cardstack.name = "card stack"
function cardstack.arrange(p)
    return fcardstack(p)
end

return cardstack
