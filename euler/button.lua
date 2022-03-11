--button.lua
local Widget = require("euler.widget")

local UIStatus	= enum("UIStatus")

local Button = class(Widget)
local prop = property(Button)
prop:reader("on_click", nil)
prop:accessor("status", UIStatus.NORMAL)

function Button:__init(id)
	self.move_capture = true
	self.root = gui.get_node(id .. "/button")
	self.label = gui.get_node(id .. "/label")
	self.capture = gui.get_node(id .. "/button")
	self:add_child("normal", gui.get_node(id .. "/normal"))
	self:add_child("pressed", gui.get_node(id .. "/pressed"))
	self:add_child("hovered", gui.get_node(id .. "/hovered"))
	self:add_child("disabled", gui.get_node(id .. "/disabled"))
	self:show_child("normal")
end

function Button:setup(euler)
	local size = gui.get_size(self.root)
	for _, child in pairs(self.childrens) do
		gui.set_size(child, size)
	end
end

function Button:set_disabled(disabled)
	if disabled then
		self.input_capture = false
		self.status = UIStatus.DISABLED
		self:show_child("disabled")
	else
		self.input_capture = true
		self.status = UIStatus.NORMAL
		self:show_child("normal")
	end
end

function Button:register_click(func)
	self.on_click = func
end

function Button:on_mouse_enter(action)
	if self.status == UIStatus.NORMAL then
		self:show_child("hovered")
	end
end

function Button:on_mouse_leave(action)
	if self.status == UIStatus.NORMAL then
		self:show_child("normal")
	end
end

function Button:on_lbutton_down(action)
	if self.status == UIStatus.DISABLED then
		return false
	end
	self:show_child("pressed")
	self:set_status(UIStatus.PRESSED)
	gui.set_position(self.label, vmath.vector3(0.0, -2.0, 0.0))
	gui.set_size(self.root, vmath.vector3(300.0, 60.0, 0.0))
	return false
end

function Button:on_lbutton_repeated(action)
	if self.on_click then
		self.on_click(self)
	end
	return false
end

function Button:on_lbutton_up(action)
	if self.status == UIStatus.DISABLED then
		return false
	end
	self:set_status(UIStatus.NORMAL)
	self:show_child(self.hover and "hovered" or "normal")
	gui.set_position(self.label, vmath.vector3(0.0))
	if self.on_click then
		self.on_click(self)
	end
	return false
end

return Button
