------------------------------------------------------------------------
-- card stack layout by Enric Morales
-- based on max.lua by Julien Danjou
------------------------------------------------------------------------
--

-- Grab environment we need
local pairs = pairs

--- card stack layout
local cardstack = {}
local tag = require("awful.tag")

local function fcardstack(p)
    local area = p.workarea
    for k, c in pairs(p.clients) do
        local x_offset = 24 * k
        local g = {
            height = area.height - c.border_width * 2,
            width = (area.width - c.border_width * 2) * (2 / 3 * tag.getmwfact() * 2),
            x = x_offset + area.width / (6 * tag.getmwfact() * 2),
            y = area.y,
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

-- vim: ft=lua sw=4 ts=4 sts=4 et
