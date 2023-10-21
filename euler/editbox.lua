--editbox.lua
local utils = require("euler.utils")
local Widget = require("euler.widget")
local _, utf8 = pcall(require, "utf8")

local ActionID = enum("ActionID")

local Editbox = class(Widget)
local prop = property(Editbox)
prop:reader("inner", nil)
prop:reader("on_changed", nil)
prop:reader("show_cursor", false)
prop:accessor("password", false)
prop:accessor("numbered", false)
prop:accessor("length", false)
prop:accessor("text", "", true)
prop:accessor("cursor", 1, true)
prop:accessor("placeholder", "empty", true)

function Editbox:__init(id, text)
	self.text_capture = true
	self.move_capture = true
	self.repeated_capture = true
	self.root = gui.get_node(id .. "/editbox")
	self.label = gui.get_node(id .. "/content")
	self.capture = gui.get_node(id .. "/editbox")
	self:set_text(text or "")
end

function Editbox:setup(euler)
	local size = gui.get_size(self.root)
	size.x = size.x - 4
	gui.set_size(self.label, size)
	self.text_color = gui.get_color(self.label)
	self:update_text()
end

function Editbox:update(frame)
	if frame % 20 == 0 then
		self.show_cursor = not self.show_cursor
		self:update_text()
	end
end

function Editbox:update_text()
	local len = utf8.len(self.text)
	if not self.focus and len == 0 and #self.placeholder > 0 then
		gui.set_color(self.label, vmath.vector4(168/255,168/255,168/255,1))
		self:set_label(self.placeholder)
		return
	end
	local text = self.text
	if self.password then
		text = string.gsub(text, "(.)", "*")
	end
	gui.set_color(self.label, self.text_color)
	local input = (self.focus and self.show_cursor) and "|" or " "
	local new_text = utf8.insert(text, self.cursor, input)
	self:set_label(new_text)
	--根据光标调整label位置
	local size = gui.get_size(self.label)
	local pos = gui.get_position(self.label)
	local metrics = utils.get_text_metrics(self.label, self.text .. "|")
	if self.cursor < len then
		local front = utf8.sub(new_text, 1, self.cursor)
		local front_metrics = utils.get_text_metrics(self.label, front .. "|")
		pos.x = (front_metrics.width > size.x) and  size.x - front_metrics.width - 5 or 5
		gui.set_position(self.label, pos)
	else
		pos.x = (metrics.width > size.x) and  size.x - metrics.width - 5 or 5
		gui.set_position(self.label, pos)
	end
end

function Editbox:on_prop_changed(value, name)
	self:update_text()
	if name =="text" and self.on_changed then
		self.on_changed(self, sel.text)
	end
end

function Editbox:register_text_changed(func)
	self.on_changed = func
end

function Editbox:on_key_repeated(action_id, action)
	self:on_key_up(action_id, action)
end

function Editbox:on_key_up(action_id, action)
	if action_id == ActionID.BACKSPACE then
		local len = utf8.len(self.text)
		if len > 0 then
			local now_cursor = utils.clamp(self.cursor - 1, 1, len)
			self.text = utf8.remove(self.text, now_cursor, now_cursor + 1)
			self.cursor = now_cursor
			self:update_text()
		end
	end
	return false
end

function Editbox:on_lbutton_up(action)
	local len = utf8.len(self.text)
	if len > 0 then
		local rpos = gui.get_position(self.root)
		local lpos = gui.get_position(self.label)
		local metrics = utils.get_text_metrics(self.label, self.text)
		local pcursor = utils.round(len * (action.x - (rpos.x + lpos.x)) / metrics.width)
		self:set_cursor(utils.clamp(pcursor, 1, len + 1))
	end
	return false
end

function Editbox:on_mouse_wheel(action, arrow)
	local len = utf8.len(self.text)
	if len > 0 then
		local now_cursor = self.cursor + arrow
		self:set_cursor(utils.clamp(now_cursor, 1, len + 1))
	end
	return false
end

function Editbox:on_char(action)
	local text = action.text
	if self.numbered then
		local byte = utf8.byte(text)
		if byte < 48 or byte > 57 then
			return false
		end
	end
	if self.password then
		local byte = utf8.byte(text)
		if byte < 33 or byte > 127 then
			return false
		end
	end
	self.text = utf8.insert(self.text, self.cursor, text)
	self.cursor = self.cursor + utf8.len(text)
	self:update_text()
	return false
end

return Editbox
