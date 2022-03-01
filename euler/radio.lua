--radio.lua
local Widget = require("euler.widget")

local Radio = class(Widget)
local prop = property(Radio)
prop:reader("selected", nil)
prop:accessor("group", nil)
prop:accessor("value", nil)
prop:accessor("checked", true, true)

function Radio:__init(id, checked)
	self.root = gui.get_node(id .. "/radio")
	self.label = gui.get_node(id .. "/label")
	self.selected = gui.get_node(id .. "/selected")
	self:set_checked(checked)
end

function Radio:on_prop_changed(checked)
	gui.set_enabled(self.selected, checked)
	if checked and self.group then
		self.group:changed(self)
	end
end

function Radio:on_lbutton_up(action)
	self:set_checked(true)
	return true
end

return Radio