--radio_group.lua

local RadioGroup = class()
local prop = property(RadioGroup)
prop:reader("selected", nil)
prop:reader("childrens", {})
prop:reader("on_changed", nil)

function RadioGroup:__init()
end

function RadioGroup:add_radio(radio, value)
	if self.selected then
		radio:set_checked(false)
	else
		self.selected = radio
		radio:set_checked(true)	
	end
	radio:set_group(self)
	radio:set_value(value)
	self.childrens[#self.childrens + 1] = radio
end

function RadioGroup:register_changed(func)
	self.on_changed = func
end

function RadioGroup:changed(radio)
	self.selected:set_checked(false)
	self.selected = radio
	if self.on_changed then
		self.on_changed(radio:get_value())
	end
end

return Radio