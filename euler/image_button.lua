--image_button.lua
local Widget = require("euler.widget")

local ImageButton = class(Widget)
local prop = property(ImageButton)
prop:reader("on_click", nil)
prop:accessor("hovered_factor", 0.05)
prop:accessor("pressed_factor", 0.05)

function ImageButton:__init(id)
	self.move_capture = true
	self.root = gui.get_node(id .. "/button")
	self.label = gui.get_node(id .. "/label")
	self.capture = gui.get_node(id .. "/button")
end


function ImageButton:set_image(image)
	gui.set_flipbook(self.root, image)
end

function ImageButton:register_click(func)
	self.on_click = func
end

function ImageButton:on_mouse_enter(action)
	if self.hovered_factor > 0 then
		gui.set_scale(self.root, vmath.vector4(1 + self.hovered_factor))
	end
end

function ImageButton:on_mouse_leave(action)
	if self.hovered_factor > 0 then
		gui.set_scale(self.root, vmath.vector4(1))
	end
end

function ImageButton:on_lbutton_down(action)
	local pos = gui.get_position(self.root)
	pos.y = pos.y - self.pressed_factor
	gui.set_position(self.root, pos)
end

function ImageButton:on_lbutton_repeated(action)
	if self.on_click then
		self.on_click(self)
	end
	return false
end

function ImageButton:on_lbutton_up(action)
	local pos = gui.get_position(self.root)
	pos.y = pos.y + self.pressed_factor
	gui.set_position(self.root, pos)
	if self.on_click then
		self.on_click(self)
	end
	return false
end

return ImageButton