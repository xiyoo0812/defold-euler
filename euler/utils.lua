--utils.lua

local utils = {}

function utils.get_text_metrics(node, text)
    local font = gui.get_font(node)
    return gui.get_text_metrics(font, text, 0, false, 1, 0)
end

function utils.round(v)
    return math.floor(v + 0.5)
end

function utils.clamp(v, min, max)
    if v < min then
        return min
    elseif v > max then
        return max
    end
    return v
end

return utils