--switch.lua
local Widget = require("euler.widget")

local UIStatus	= enum("UIStatus")

local Switch = class(Widget)
local prop = property(Switch)
prop:reader("on_image", nil)
prop:reader("on_changed", nil)
prop:accessor("checked", true, true)

function Switch:__init(id, ison)
	self.root  = gui.get_node(id .. "/switch")
	self.label = gui.get_node(id .. "/label")
	self.on_image = gui.get_node(id .. "/on")
	self:set_checked(ison)
end

function Switch:on()
	self:set_checked(true)
end

function Switch:off()
	self:set_checked(false)
end

function Switch:on_prop_changed(checked)
	gui.set_enabled(self.on_image, checked)
	if self.on_changed then
		self.on_changed(self, checked)
	end
end

function Switch:register_changed(func)
	self.on_changed = func
end

function Switch:on_lbutton_up(action)
	self:set_checked(not self.checked)
	return true
end

return Switch
