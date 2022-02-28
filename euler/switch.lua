--switch.lua
local Widget = require("euler.widget")

local UIStatus	= enum("UIStatus")

local Switch = class(Widget)
local prop = property(Switch)
prop:reader("on", true)
prop:reader("on_image", nil)
prop:reader("on_changed", nil)

function Switch:__init(id, ison)
	self.root  = gui.get_node(id .. "/switch")
	self.label = gui.get_node(id .. "/label")
	self.on_image = gui.get_node(id .. "/on")
	self:set_status(ison)
end

function Switch:on()
	self:set_status(true)
end

function Switch:off()
	self:set_status(false)
end

function Switch:set_status(status)
	if self.on == status then
		return
	end
	self.on = status
	gui.set_enabled(self.on_image, status)
	if self.on_changed then
		self.on_changed(self, status)
	end
end

function Switch:register_changed(func)
	self.on_changed = func
end

function Switch:on_lbutton_up(action)
	self:set_status(not self.on)
	return true
end

return Switch
