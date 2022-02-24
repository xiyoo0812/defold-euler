--switch.lua
local Widget = require("euler.widget")

local UIStatus	= enum("UIStatus")

local Switch = class(Widget)
local prop = property(Switch)
prop:reader("on", true)
prop:reader("on_changed", nil)
prop:accessor("on_image", nil)
prop:accessor("off_image", nil)

function Switch:__init(id, ison, off_img)
	self.root  = gui.get_node(id .. "/switch")
	self.label = gui.get_node(id .. "/label")
	local on_image = gui.get_flipbook(self.root)
	self.on_image = on_image
	self.off_image = off_img or on_image
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
	gui.play_flipbook(self.root, status and self.on_image or self.off_image)
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
