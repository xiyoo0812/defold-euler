--scroll_bar.lua
local utils = require("euler.utils")
local Widget = require("euler.widget")

local ScrollBar = class(Widget)
local prop = property(ScrollBar)
prop:reader("left", nil)
prop:reader("right", nil)
prop:reader("cursor", nil)
prop:reader("vertical", false)
prop:reader("on_changed", nil)
prop:accessor("step", 3)
prop:accessor("page_size", 100, true)
prop:accessor("contont_size", 200, true)
prop:accessor("percent", 0, true)

function ScrollBar:__init(id, percent)
	self.move_capture = true
	self.root  = gui.get_node(id .. "/scroll")
	self.cursor = gui.get_node(id .. "/cursor")
	self:set_percent(percent)
end

function ScrollBar:setup(euler)
	self.left = euler:init_image(self.id .. "/left")
	self.right = euler:init_image(self.id .. "/right")
	self.left:set_repeated_capture(true)
	self.left:register_click(function()
		self:scroll_step(-1 * self.step)
	end)
	self.right:set_repeated_capture(true)
	self.right:register_click(function()
		self:scroll_step(1 * self.step)
	end)
	local rotation = gui.get_rotation(self.root)
	if rotation.z == 90 or rotation.z == -90 then
		self.vertical = true
	end
	self:update_cursor()
end

function ScrollBar:on_prop_changed(value, name)
	if name ~= "percent" then
		return self:update_cursor()
	end
	self.percent = utils.clamp(self.percent, 0, 100)
	self:update_progress()
	if self.on_changed then
		self.on_changed(self, self.percent)
	end
end

function ScrollBar:update_cursor()
	if self.page_size >= self.contont_size then
		self.page_size = self.contont_size - 1
	end
	local size = gui.get_size(self.root)
	local cur_size = gui.get_size(self.cursor)
	cur_size.x = size.x * (self.page_size / self.contont_size)
	gui.set_size(self.cursor, cur_size)
end

function ScrollBar:update_progress()
	local size = gui.get_size(self.root)
	local pos = gui.get_position(self.cursor)
	local cur_size = gui.get_size(self.cursor)
	pos.x = (size.x - cur_size.x) * (self.percent / 100)
	gui.set_position(self.cursor, pos)
end

function ScrollBar:scroll_step(step)
	self:set_percent(self.percent + step)
end

function ScrollBar:register_changed(func)
	self.on_changed = func
end

function ScrollBar:on_mouse_move(action)
	if self.euler.pressed then
		self:update_percent(action)
		return false
	end
	return true
end

function ScrollBar:on_lbutton_up(action)
	self:update_percent(action)
	return false
end

function ScrollBar:on_mouse_wheel(action, arrow)
	self:scroll_step(arrow * self.step)
	return false
end

function ScrollBar:update_percent(action)
	local size = gui.get_size(self.root)
	local pos = gui.get_position(self.root)
	if self.vertical then
		self:set_percent(utils.round(100 * (pos.y - action.y) / size.x))
	else
		self:set_percent(utils.round(100 * (action.x - pos.x) / size.x))
	end
end

return ScrollBar
