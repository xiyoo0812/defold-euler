--image.lua
local Widget = require("euler.widget")

local Image = class(Widget)
local prop = property(Image)
prop:reader("on_click", nil)
prop:reader("image", nil)

function Image:__init(id, img)
	self.input_enable = false
	self.root  = gui.get_node(id .. "/image")
	if img then
		self:set_image(img)
	end
end

function Image:set_image(image)
	self.image = image
	gui.set_flipbook(self.root, image)
end

function Image:register_click(func)
	self.input_enable = true
	self.on_click = func
end

function Image:on_lbutton_up(action)
	if self.on_click then
		self.on_click(self)
	end
	return false
end

return Image