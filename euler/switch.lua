--switch.lua
local Widget = require("euler.widget")

local Switch = class(Widget)
local prop = property(Switch)
prop:reader("on_changed", nil)
prop:accessor("checked", true, true)

function Switch:__init(id, checked)
	self.checked = checked
	self.root  = gui.get_node(id .. "/switch")
	self.label = gui.get_node(id .. "/label")
	self:add_child("on", gui.get_node(id .. "/on"))
	self:add_child("off", gui.get_node(id .. "/off"))
	self:on_prop_changed(checked)
end

function Switch:setup(euler)
	local size = gui.get_size(self.root)
	for _, child in pairs(self.childrens) do
		gui.set_size(child, size)
	end
	local pos = gui.get_position(self.label)
	pos.x = size.x + 5
	gui.set_position(self.label, pos)
end

function Switch:on()
	self:set_checked(true)
end

function Switch:off()
	self:set_checked(false)
end

function Switch:on_prop_changed(checked)
	self:show_child(checked and "on" or "off")
	if self.on_changed then
		self.on_changed(self, checked)
	end
end

function Switch:register_changed(func)
	self.on_changed = func
end

function Switch:on_lbutton_up(action)
	self:set_checked(not self.checked)
	return false
end

return Switch
