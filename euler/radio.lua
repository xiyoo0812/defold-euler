--radio.lua
local Widget = require("euler.widget")

local Radio = class(Widget)
local prop = property(Radio)
prop:reader("mask", nil)
prop:accessor("group", nil)
prop:accessor("value", nil)
prop:accessor("checked", true, true)

function Radio:__init(id, checked)
	self.checked = checked
	self.root = gui.get_node(id .. "/radio")
	self.label = gui.get_node(id .. "/label")
	self.capture = gui.get_node(id .. "/radio")
	self.mask = gui.get_node(id .. "/checked")
	self:on_prop_changed(checked)
end

function Radio:setup(euler)
	local size = gui.get_size(self.root)
	local pos = gui.get_position(self.label)
	pos.x = size.x + 5
	gui.set_position(self.label, pos)
end

function Radio:on_prop_changed(checked)
	gui.set_enabled(self.mask, checked)
	if checked and self.group then
		self.group:changed(self)
	end
end

function Radio:on_lbutton_up(action)
	self:set_checked(true)
	return false
end

return Radio