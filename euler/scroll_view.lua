--scroll_view.lua
local utils = require("euler.utils")
local Widget = require("euler.widget")

local ScrollView = class(Widget)
local prop = property(ScrollView)
prop:reader("vertical", nil)
prop:reader("horizontal", nil)
prop:reader("on_vertical", nil)
prop:reader("on_horizontal", nil)
prop:accessor("capture", nil)
prop:accessor("contont_size", nil, true)

function ScrollView:__init(id, capture)
	self.move_capture = true
	self.capture = capture
	self.root = gui.get_node(id .. "/scroll_view")
end

function ScrollView:setup(euler)
	self.vertical = euler:init_scroll_bar(self.id .. "/vertical")
	self.horizontal = euler:init_scroll_bar(self.id .. "/horizontal")
	self.vertical:register_changed(function(bar, percent)
		self:scroll_vertical(percent)
	end)
	self.horizontal:register_changed(function(bar, percent)
		self:scroll_horizontal(percent)
	end)
	--更新子控件的尺寸
	local size = gui.get_size(self.root)
	local vsize = self.vertical:get_size()
	local hsize = self.horizontal:get_size()
	local vpos = self.vertical:get_position()
	local hpos = self.horizontal:get_position()
	vsize.x = size.y
	hsize.x = size.x - hsize.y
	vpos.x = size.x - hsize.y / 2
	hpos.y = hsize.y / 2 - size.y
	self.vertical:set_size(vsize)
	self.horizontal:set_size(hsize)
	self.vertical:set_position(vpos)
	self.horizontal:set_position(hpos)
	self.vertical:set_enabled(false)
	self.horizontal:set_enabled(false)
	gui.set_size(self.capture, size)
	self.contont_size = size
end

function ScrollView:on_prop_changed(contont_size)
	local size = gui.get_size(self.root)
	local csize = gui.get_size(self.capture)
	local vsize = self.vertical:get_size()
	local hsize = self.horizontal:get_size()
	if contont_size.x > csize.x then
		csize.x = size.x - vsize.y
	end
	if contont_size.y > csize.y then
		csize.y = size.y - hsize.y
	end
	self.vertical:set_page_size(csize.y)
	self.horizontal:set_page_size(csize.x)
	self.vertical:set_contont_size(contont_size.y)
	self.horizontal:set_contont_size(contont_size.x)
	self.vertical:set_enabled(contont_size.y > csize.y)
	self.horizontal:set_enabled(contont_size.x > csize.x)
	gui.set_size(self.capture, csize)
end

function ScrollView:register_vertical(func)
	self.on_vertical = func
end

function ScrollView:register_horizontal(func)
	self.on_horizontal = func
end

function ScrollView:scroll_vertical(percent)
	if self.on_vertical then
		self.on_vertical(self, percent)
	end
end

function ScrollView:scroll_horizontal(percent)
	if self.on_horizontal then
		self.on_horizontal(self, percent)
	end
end

function ScrollView:on_mouse_wheel(action, arrow)
	if self.vertical:is_enabled() then
		return self.vertical:on_mouse_wheel(action, arrow) 
	end
	if self.horizontal:is_enabled() then
		return self.horizontal:on_mouse_wheel(action, arrow)
	end
	return false
end

return ScrollView
