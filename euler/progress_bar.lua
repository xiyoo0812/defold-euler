--progress_bar.lua
local Widget = require("euler.widget")

local ProgressBar = class(Widget)
local prop = property(ProgressBar)
prop:reader("value", nil)
prop:reader("percent", 0)
prop:accessor("max", 100, true)
prop:accessor("progress", 0, true)
prop:accessor("show_text", true, true)

function ProgressBar:__init(id, progress)
	self.label = gui.get_node(id .. "/label")
	self.value = gui.get_node(id .. "/value")
	self.root = gui.get_node(id .. "/progress_bar")
	self.progress_bar = gui.get_node(id .. "/progress")
	self:set_progress(progress)
end

function ProgressBar:on_prop_changed(value, name)
	if self.progress < 0 then
		self.progress = 0
	end
	if self.progress > self.max then
		self.progress = self.max
	end
	self.percent = self.progress / self.max
	self:update_value()
end

function ProgressBar:update_value()
	local size = gui.get_size(self.root)
	local bar_size = gui.get_size(self.progress_bar)
	bar_size.x = size.x * self.percent
	gui.set_size(self.progress_bar, bar_size)
	gui.set_enabled(self.value, self.show_text)
	if self.show_text then
		gui.set_text(self.value, string.format("%d/%d", self.progress, self.max))
	end
end

return ProgressBar
