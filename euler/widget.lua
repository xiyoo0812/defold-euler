--widget.lua

local ActionID	= enum("ActionID")

local Widget = class()
local prop = property(Widget)
prop:reader("id", nil)
prop:reader("root", nil)
prop:reader("label", nil)
prop:reader("focus", false)
prop:reader("hover", false)
prop:reader("pressed", false)
prop:reader("childrens", {})
prop:accessor("input_enable", true)
prop:accessor("focus_enable", false)
prop:accessor("hover_enable", false)

function Widget:__init(id)
	self.id = id
end

function Widget:add_child(name, child)
	gui.set_parent(child, self.root)
	self.childrens[name] = child
end

function Widget:get_child(name)
	return self.childrens[name]
end

function Widget:show_child(name)
	for _name, child in pairs(self.childrens) do
		gui.set_enabled(child, _name == name)
	end
end

function Widget:set_image(name, image)
	local child = self.childrens[name]
	if child then
		gui.play_flipbook(child, image)
	end
end

function Widget:is_enable(func)
	return gui.is_enabled(self.root)
end

function Widget:set_enabled(enabled)
	return gui.set_enabled(self.root, enabled)
end

function Widget:get_text()
	if self.label then
		return gui.get_text(self.label)
	end
end

function Widget:set_text(text)
	if self.label then
		gui.set_text(self.label, text)
		self:on_text_changed(self.label, text)
	end
end

function Widget:hit_test(action)
	return gui.pick_node(self.root, action.x, action.y)
end

function Widget:on_input(action_id, action)
	if not gui.is_enabled(self.root) or (not self.input_enable) then
		return true
	end
	if not action_id then
		if self.hover_enable then
			local hit = self:hit_test(action)
			if hit then
				if not self.hover then
					self.hover = true
					self:on_mouse_enter(action)
				end
				return self:on_mouse_move(action)
			else
				self.pressed = false
				if self.hover then
					self.hover = false
					self:on_mouse_leave(action)
				end
			end
		end
		return true
	end
	if action_id == ActionID.TEXT then
		if self.focus_enable then
			return self:on_char(action)
		end
		return false
	end
	if action_id == ActionID.MARKED_TEXT then
		return false
	end
	if action_id == ActionID.LBUTTON then
		if self:hit_test(action) then
			if action.released then
				self.pressed = false
				return self:on_lbutton_up(action)
			else
				self.pressed = true
				return self:on_lbutton_down(action)
			end
		end
		return true
	end
	if action_id == ActionID.DWHEEL or action_id == ActionID.UWHEEL then
		if self.focus_enable then
			return self:on_mouse_wheel(action)
		end
		return true
	end
	if action.pressed then
		return self:on_key_down(action)
	end
	return self:on_key_up(action)
end

function Widget:on_mouse_enter(action)
end

function Widget:on_mouse_leave(action)
end

function Widget:on_mouse_move(action)
	return true
end

function Widget:on_mouse_wheel(action)
	return true
end

function Widget:on_lbutton_down(action)
	return true
end

function Widget:on_lbutton_up(action)
	return true
end

function Widget:on_key_down(action)
	return true
end

function Widget:on_key_up(action)
	return true
end

function Widget:on_char(action)
	return true
end

function Widget:on_text_changed(label, text)
end

return Widget
