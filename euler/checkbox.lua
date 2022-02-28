--checkbox.lua
local Widget = require("euler.widget")

local Checkbox = class(Widget)
local prop = property(Checkbox)
prop:reader("selected", nil)
prop:reader("on_changed", nil)
prop:accessor("checked", true, true)

function Checkbox:__init(id, checked)
	self.label = gui.get_node(id .. "/label")
	self.root  = gui.get_node(id .. "/checkbox")
	self.selected = gui.get_node(id .. "/selected")
	self:set_checked(checked)
end

function Checkbox:on_prop_changed(checked)
	gui.set_enabled(self.selected, checked)
	if self.on_changed then
		self.on_changed(self, checked)
	end
end

function Checkbox:register_changed(func)
	self.on_changed = func
end

function Checkbox:on_lbutton_up(action)
	self:set_checked(not self.checked)
	return true
end

return Checkbox
