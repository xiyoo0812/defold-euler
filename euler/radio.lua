--radio.lua
local Widget = require("euler.widget")

local Radio = class(Widget)
local prop = property(Radio)
prop:reader("checked", true)
prop:reader("selected", nil)
prop:accessor("group", nil)
prop:accessor("value", nil)

function Radio:__init(id, checked)
	self.label = gui.get_node(id .. "/label")
	self.root  = gui.get_node(id .. "/radio")
	self.selected = gui.get_node(id .. "/selected")
	self:set_checked(checked)
end

function Radio:set_checked(checked)
	if self.checked == checked then
		return
	end
	self.checked = checked
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