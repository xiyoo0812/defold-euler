--image.lua
local Widget = require("euler.widget")

local Image = class(Widget)
local prop = property(Image)
prop:reader("on_click", nil)
prop:accessor("hovered_factor", 0)
prop:accessor("pressed_factor", 0)

function Image:__init(id, img)
	self.input_capture = false
	self.root  = gui.get_node(id .. "/image")
	if img then
		self:set_image(img)
	end
end

function Image:set_image(image)
	gui.set_flipbook(self.root, image)
end

function Image:register_click(func)
	self.input_capture = true
	if self.hovered_factor > 0 then
		self.move_capture = true
	end
	self.on_click = func
end

function Image:on_lbutton_repeated(action)
	if self.on_click then
		self.on_click(self)
	end
	return false
end

function Image:on_mouse_enter(action)
	if self.hovered_factor > 0 then
		gui.set_scale(self.root, vmath.vector4(1 + self.hovered_factor))
	end
end

function Image:on_mouse_leave(action)
	if self.hovered_factor > 0 then
		gui.set_scale(self.root, vmath.vector4(1))
	end
end

function Image:on_lbutton_down(action)
	if self.pressed_factor > 0 then
		local pos = gui.get_position(self.root)
		pos.y = pos.y - self.pressed_factor
		gui.set_position(self.root, pos)
	end
end

function Image:on_lbutton_up(action)
	if self.pressed_factor > 0 then
		local pos = gui.get_position(self.root)
		pos.y = pos.y + self.pressed_factor
		gui.set_position(self.root, pos)
	end
	if self.on_click then
		self.on_click(self)
	end
	return false
end

return Image