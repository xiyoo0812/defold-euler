--button.lua

local UIStatus	= enum("UIStatus")

local Button = class()
local prop = property(Button)
prop:accessor("id", nil)
prop:accessor("image", nil)
prop:accessor("label", nil)
prop:accessor("on_click", nil)
prop:accessor("status", UIStatus.NORMAL)

function Button:__init(id)
	self.id = id
	self.image = gui.get_node(id .. "/button")
	self.label = gui.get_node(id .. "/label")
end

function Button:set_text(text)
	gui.set_text(self.label, text)
end

function Button:update()
	if self.status == UIStatus.NORMAL then
		gui.play_flipbook(self.button, "button_normal")
	elseif self.status == UIStatus.PRESSED then
		gui.play_flipbook(self.button, "button_pressed")
	elseif self.status == UIStatus.HOVERED then
		gui.play_flipbook(self.button, "button_hovered")
	elseif self.status == UIStatus.DISABLED then
		gui.play_flipbook(self.button, "button_disabled")
	end
end

function Button:register_click(func)
	self.on_click = func
end

function Button:hit_test(action)
	if not gui.is_enabled(self.button) then
		return false
	end
	return gui.pick_node(self.button, action.x, action.y)
end

function Button:on_touch(action)
	if action.released then
		self:set_status(UIStatus.NORMAL)
		if self.on_click then
			self.on_click(self)
		end
	else
		self:set_status(UIStatus.PRESSED)
	end
	self:update()
end

return Button