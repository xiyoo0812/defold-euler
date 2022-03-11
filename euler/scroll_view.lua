--scroll_view.lua
local utils = require("euler.utils")
local Widget = require("euler.widget")

local ScrollView = class(Widget)
local prop = property(ScrollView)
prop:reader("base", nil)
prop:reader("holder", nil)
prop:reader("vertical", nil)
prop:reader("horizontal", nil)
prop:accessor("target", nil, true)
prop:accessor("contont_size", nil, true)

function ScrollView:__init(id)
	self.move_capture = true
	self.capture = gui.get_node(id .. "/content")
	self.root = gui.get_node(id .. "/scroll_view")
end

function ScrollView:setup(euler)
	self.vertical = euler:init_scroll_bar(self.id .. "/vertical")
	self.horizontal = euler:init_scroll_bar(self.id .. "/horizontal")
	self.vertical:register_changed(function(percent)
		self:scroll_vertical(percent)
	end)
	self.horizontal:register_changed(function(percent)
		self:scroll_horizontal(percent)
	end)
	--更新子控件的尺寸
	local size = gui.get_size(self.root)
	--local csize = gui.get_size(self.capture)
	local vsize = self.vertical:get_size()
	local hsize = self.horizontal:get_size()
	local vpos = self.vertical:get_position()
	local hpos = self.horizontal:get_position()
	vsize.x = size.y
	--csize.x = size.x - hsize.y
	hsize.x = size.x - vsize.y
	vpos.x = size.x - vsize.y / 2
	hpos.y = vsize.y / 2 - size.y
	self.vertical:set_size(vsize)
	self.horizontal:set_size(hsize)
	self.vertical:set_position(vpos)
	self.horizontal:set_position(hpos)
	gui.set_size(self.capture, size)
	self.vertical:set_enable(false)
	self.horizontal:set_enable(false)
	self.contont_size = size
end

function ScrollView:on_prop_changed(value, name)
	if name == "target" then
		self:set_contont_size(gui.get_size(value))
		return
	end
	--contont_size
	local size = gui.get_size(self.root)
	local csize = gui.get_size(self.capture)
	local vsize = self.vertical:get_size()
	local hsize = self.horizontal:get_size()
	if value.x > csize.x then
		csize.x = size.x - vsize.y
		self.horizontal:set_enable(true)
		self.horizontal:set_page_size(csize.x)
		self.horizontal:set_contont_size(value.x)
	end
	if value.y > csize.y then
		csize.y = size.y- hsize.y
		self.vertical:set_enable(true)
		self.vertical:set_page_size(csize.y)
		self.vertical:set_contont_size(value.y)
	end
	gui.set_size(self.capture, csize)
end

function ScrollView:scroll_vertical(percent)
	if self.target then
		local pos = gui.get_position(self.target)
		local csize = gui.get_size(self.capture)
		pos.y = (self.contont_size.y - csize.y) * percent / 100
		gui.set_position(self.target, pos)
	end
end

function ScrollView:scroll_horizontal(percent)
	if self.target then
		local pos = gui.get_position(self.target)
		local csize = gui.get_size(self.capture)
		pos.x = (self.contont_size.x - csize.x) * percent / 100
		gui.set_position(self.target, pos)
	end
end

function ScrollView:on_mouse_wheel(action, arrow)
	return false
end

return ScrollView
