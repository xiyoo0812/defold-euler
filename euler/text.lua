--text.lua
local utils = require("euler.utils")
local Widget = require("euler.widget")

local Text = class(Widget)
local prop = property(Text)
prop:reader("scroll_view", nil)

function Text:__init(id, txt)
	self.root = gui.get_node(id .. "/text")
	self.label = gui.get_node(id .. "/label")
	local text = gui.getlab
	self:set_label(txt or gui.get_text(self.label))
end

function Text:setup(euler)
	local size = gui.get_size(self.root)
	local lsize = gui.get_size(self.label)
	local content = gui.get_node(self.id .. "/content")
	self.scroll_view = euler:init_scroll_view(self.id .. "/scroll_view", content)
	self.scroll_view:set_size(size)
	self.scroll_view:set_contont_size(lsize)
	self.scroll_view:register_vertical(function(view, percent)
		local csize = gui.get_size(content)
		local pos = gui.get_position(self.label)
		pos.y = (lsize.y - csize.y) * percent / 100
		gui.set_position(self.label, pos)
	end)
	self.scroll_view:register_horizontal(function(view, percent)
		local csize = gui.get_size(content)
		local pos = gui.get_position(self.label)
		pos.x = (lsize.x - csize.x) * percent / -100
		gui.set_position(self.label, pos)
	end)
end

function Text:on_label_changed(label, text)
	local lsize = gui.get_size(label)
	local metrics = utils.get_text_metrics(self.label, text)
	lsize.x = metrics.width
	lsize.y = metrics.height
	gui.set_size(label, lsize)
	if self.scroll_view then
		self.scroll_view:set_contont_size(lsize)
	end
end

return Text
