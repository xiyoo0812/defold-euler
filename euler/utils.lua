--utils.lua

local utils = {}

function utils.get_text_metrics(node, text)
    local font = gui.get_font(node)
    return gui.get_text_metrics(font, text, 0, false, 0, 0)
end

return utils