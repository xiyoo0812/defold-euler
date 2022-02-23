--switch.lua
local Widget = require("euler.widget")

local UIStatus	= enum("UIStatus")

local Switch = class(Widget)
local prop = property(Switch)
prop:reader("on_changed", nil)
prop:reader("checked", true)

function Switch:__init(id, checked, off_img)
	self.root  = gui.get_node(id .. "/checkbox")
	self:set_checked(checked)
end

function Checkbox:set_checked(checked)
	self.checked = checked
	gui.set_enabled(self.selected, checked)
	if self.on_changed then
		self.on_changed(self, checked)
	end
end

function Checkbox:register_changed(func)
	self.on_changed = func
end

function Checkbox:on_lbutton_up(action)
	self:set_checked(not checked)
	return true
end

return Checkbox
