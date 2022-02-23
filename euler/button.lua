--button.lua
local Widget = require("euler.widget")

local UIStatus	= enum("UIStatus")

local Button = class(Widget)
local prop = property(Button)
prop:reader("on_click", nil)
prop:accessor("normal_image", nil)
prop:accessor("hovered_image", nil)
prop:accessor("pressed_image", nil)
prop:accessor("disabled_image", nil)
prop:accessor("status", UIStatus.NORMAL)

function Button:__init(id, pressed_img, hovered_img, disabled_img)
	self.hover_enable = true
	self.root = gui.get_node(id .. "/button")
	self.label = gui.get_node(id .. "/label")
	local normal_image = gui.get_flipbook(self.root)
	self.normal_image = normal_image
	self.pressed_image = pressed_img or normal_image
	self.hovered_image = hovered_img or normal_image
	self.disabled_image = disabled_img or normal_image
end

function Button:set_disabled(disabled)
	if disabled then
		self.status = UIStatus.DISABLED
		gui.play_flipbook(self.root, self.disabled_image)
	else
		self.status = UIStatus.NORMAL
		gui.play_flipbook(self.root, self.normal_image)
	end
end

function Button:register_click(func)
	self.on_click = func
end

function Button:on_mouse_enter(action)
	if self.status == UIStatus.NORMAL then
		gui.play_flipbook(self.root, self.hovered_image)
	end
	return true
end

function Button:on_mouse_leave(action)
	if self.status == UIStatus.NORMAL then
		gui.play_flipbook(self.root, self.normal_image)
	end
	return true
end

function Button:on_lbutton_down(action)
	self:set_status(UIStatus.PRESSED)
	gui.play_flipbook(self.root, self.pressed_image)
	gui.set_position(self.label, vmath.vector3(0.0, -2.0, 0.0))
	return true
end

function Button:on_lbutton_up(action)
	self:set_status(UIStatus.NORMAL)
	gui.set_position(self.label, vmath.vector3(0.0))
	if self.hover then
		gui.play_flipbook(self.root, self.hovered_image)
	end
	if self.on_click then
		self.on_click(self)
	end
	return true
end

return Button
