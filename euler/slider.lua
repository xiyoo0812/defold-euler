--slider.lua
local utils = require("euler.utils")
local Widget = require("euler.widget")

local Slider = class(Widget)
local prop = property(Slider)
prop:reader("cursor", nil)
prop:reader("on_changed", nil)
prop:accessor("max", 100, true)
prop:accessor("percent", 0, true)

function Slider:__init(id, percent)
	self.move_capture = true
	self.root = gui.get_node(id .. "/slider")
	self.cursor = gui.get_node(id .. "/cursor")
	self.capture = gui.get_node(id .. "/slider")
	self:set_percent(percent)
end

function Slider:setup(euler)
	local rotation = gui.get_rotation(self.root)
	if rotation.z == 90 or rotation.z == -90 then
		self.vertical = true
	end
end

function Slider:on_prop_changed()
	self.percent = utils.clamp(self.percent, 0, self.max)
	self:update_progress()
	if self.on_changed then
		self.on_changed(self, self.percent)
	end
end

function Slider:update_progress()
	local size = gui.get_size(self.root)
	local pos = gui.get_position(self.cursor)
	local cur_size = gui.get_size(self.cursor)
	pos.x = (size.x - cur_size.x) * (self.percent / self.max)
	gui.set_position(self.cursor, pos)
end

function Slider:register_changed(func)
	self.on_changed = func
end

function Slider:on_mouse_move(action)
	if self.euler.pressed then
		self:update_percent(action)
		return false
	end
	return true
end

function Slider:on_lbutton_up(action)
	self:update_percent(action)
	return false
end

function Slider:update_percent(action)
	local size = gui.get_size(self.root)
	local pos = gui.get_position(self.root)
	if self.vertical then
		self:set_percent(utils.round(self.max * (pos.y - action.y) / size.x))
	else
		self:set_percent(utils.round(self.max * (action.x - pos.x) / size.x))
	end
end

return Slider
