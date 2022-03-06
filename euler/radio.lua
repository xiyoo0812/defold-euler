--radio.lua
local Widget = require("euler.widget")

local Radio = class(Widget)
local prop = property(Radio)
prop:accessor("group", nil)
prop:accessor("value", nil)
prop:accessor("checked", true, true)

function Radio:__init(id, checked)
	self.checked = checked
	self.root = gui.get_node(id .. "/radio")
	self.label = gui.get_node(id .. "/label")
	self:add_child("checked", gui.get_node(id .. "/checked"))
	self:add_child("unchecked", gui.get_node(id .. "/unchecked"))
	self:on_prop_changed(checked)
end

function Radio:setup(euler)
	local size = gui.get_size(self.root)
	for _, child in pairs(self.childrens) do
		gui.set_size(child, size)
	end
	local pos = gui.get_position(self.label)
	pos.x = size.x + 5
	gui.set_position(self.label, pos)
end

function Radio:on_prop_changed(checked)
	self:show_child(checked and "checked" or "unchecked")
	if checked and self.group then
		self.group:changed(self)
	end
end

function Radio:on_lbutton_up(action)
	self:set_checked(true)
	return false
end

return Radio