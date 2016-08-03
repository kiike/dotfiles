------------------------------------------------------------------------
-- card stack layout by Enric Morales
-- based on max.lua by Julien Danjou
------------------------------------------------------------------------
--

-- Grab environment we need
local pairs = pairs

--- card stack layout
local cardstack = {}


-- @param screen The screen to arrange.
cardstack.name = "card stack"

function cardstack.arrange(p)
    local function calc_offset(index, len_clients)
        if len_clients > 1 then
            return 32 * math.ceil(index - #p.clients / 2)
        else
            return 0
        end
    end

    local area = p.workarea

    for k, c in pairs(p.clients) do
        local x_offset = calc_offset(k, #p.clients)
        local width = math.min((area.width - c.border_width * 2) * c.screen.selected_tag.master_width_factor, 
                               area.width - c.border_width * 2)
                              
        local x = x_offset + ((area.width / 2) - (width / 2))

        local g = {
            height = area.height - c.border_width * 2,
            width = math.abs(width),
            x = math.abs(x),
            y = area.y,
        }

        c:geometry(g)
    end
end

return cardstack

-- vim: ft=lua sw=4 ts=4 sts=4 et
