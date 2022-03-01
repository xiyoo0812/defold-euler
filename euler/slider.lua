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
	self.hover_enable = true
	self.root  = gui.get_node(id .. "/slider")
	self.label = gui.get_node(id .. "/label")
	self.cursor = gui.get_node(id .. "/cursor")
	self:set_percent(percent)
end

function Slider:on_prop_changed()
	self.percent = utils.clamp(self.percent, 0, self.max)
	self:update_progress()
	if self.on_changed then
		self.on_changed(self, percent)
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
	if self.pressed then
		self:calc_percent(action)
	end
	return false
end

function Slider:on_lbutton_up(action)
	self:calc_percent(action)
	return false
end

function Slider:calc_percent(action)
	local size = gui.get_size(self.root)
	local pos = gui.get_position(self.root)
	local percent = utils.round(self.max * (action.x - pos.x) / size.x)
	self:set_percent(percent)
end

return Slider
