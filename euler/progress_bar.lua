--progress_bar.lua
local utils = require("euler.utils")
local Widget = require("euler.widget")

local ProgressBar = class(Widget)
local prop = property(ProgressBar)
prop:reader("value", nil)
prop:reader("percent", 0)
prop:reader("on_changed", nil)
prop:accessor("max", 100, true)
prop:accessor("progress", 0, true)
prop:accessor("show_text", true, true)

function ProgressBar:__init(id, progress)
	self.input_enable = false
	self.label = gui.get_node(id .. "/label")
	self.root = gui.get_node(id .. "/progress_bar")
	self.progress_bar = gui.get_node(id .. "/progress")
	self:set_progress(progress)
end

function ProgressBar:on_prop_changed()
	self.progress = utils.clamp(self.progress, 0, self.max)
	self.percent = self.progress / self.max
	self:update_progress()
	if self.on_changed then
		self.on_changed(self, self.percent)
	end
end

function ProgressBar:register_changed(func)
	self.on_changed = func
end

function ProgressBar:update_progress()
	local size = gui.get_size(self.root)
	local bar_size = gui.get_size(self.progress_bar)
	bar_size.x = size.x * self.percent
	gui.set_size(self.progress_bar, bar_size)
	gui.set_enabled(self.label, self.show_text)
	if self.show_text then
		gui.set_text(self.label, string.format("%d/%d", self.progress, self.max))
	end
end

return ProgressBar
