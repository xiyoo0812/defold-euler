--checkbox.lua
local Widget = require("euler.widget")

local Checkbox = class(Widget)
local prop = property(Checkbox)
prop:reader("on_changed", nil)
prop:accessor("checked", true, true)

function Checkbox:__init(id, checked)
	self.checked = checked
	self.label = gui.get_node(id .. "/label")
	self.root = gui.get_node(id .. "/checkbox")
	self.capture = gui.get_node(id .. "/checkbox")
	self:add_child("checked", gui.get_node(id .. "/checked"))
	self:add_child("unchecked", gui.get_node(id .. "/unchecked"))
	self:on_prop_changed(checked)
end

function Checkbox:setup(euler)
	local size = gui.get_size(self.root)
	for _, child in pairs(self.childrens) do
		gui.set_size(child, size)
	end
	local pos = gui.get_position(self.label)
	pos.x = size.x + 5
	gui.set_position(self.label, pos)
end

function Checkbox:on_prop_changed(checked)
	self:show_child(checked and "checked" or "unchecked")
	if self.on_changed then
		self.on_changed(self, checked)
	end
end

function Checkbox:register_changed(func)
	self.on_changed = func
end

function Checkbox:on_lbutton_up(action)
	self:set_checked(not self.checked)
	return false
end

return Checkbox
