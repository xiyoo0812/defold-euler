--editbox.lua
local Widget = require("euler.widget")

local Editbox = class(Widget)
local prop = property(Editbox)
prop:reader("on_text_changed", nil)

function Editbox:__init(id)
	self.root = gui.get_node(id .. "/editbox")
	self.label = gui.get_node(id .. "/label")
end

function Editbox:register_text_changed(func)
	self.on_text_changed = func
end

function Editbox:on_key_up(action)
	return true
end

function Editbox:on_text(action)
	return true
end

return Editbox