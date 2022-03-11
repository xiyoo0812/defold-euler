--text.lua
local Widget = require("euler.widget")

local Text = class(Widget)

function Text:__init(id, txt)
	self.root = gui.get_node(id .. "/text")
	self.label = gui.get_node(id .. "/label")
	self.capture = gui.get_node(id .. "/text")
	if txt then
		self:set_text(txt)
	end
end

return Text
