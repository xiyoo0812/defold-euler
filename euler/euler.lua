--euler.lua

require("luaoop.enum")
require("luaoop.class")
require("luaoop.mixin")
require("luaoop.property")

--euler utils
require("euler.const")

local ActionID	= enum("ActionID")

local Image = require("euler.image")
local Radio  = require("euler.radio")
local Button = require("euler.button")
local Switch  = require("euler.switch")
local Slider  = require("euler.slider")
local Editbox  = require("euler.editbox")
local Checkbox  = require("euler.checkbox")
local ScrollBar = require("euler.scroll_bar")
local RadioGroup  = require("euler.radio_group")
local ProgressBar  = require("euler.progress_bar")

local Euler = class()
local prop = property(Euler)
prop:reader("widgets", {})
prop:reader("focus", nil)
prop:accessor("pressed", false)

function Euler:setup_widget(widget)
    table.insert(self.widgets, widget)
    widget:set_euler(self)
    widget:setup(self)
    return widget
end

function Euler:set_focus(widget)
    if self.focus then
        self.focus:set_focus(false)
    end
    widget:set_focus(true)
    self.focus = widget
end

function Euler:init_image(id, img)
    return self:setup_widget(Image(id, img))
end

function Euler:init_radio(id, checked)
    return self:setup_widget(Radio(id, checked))
end

function Euler:init_checkbox(id, checked)
    return self:setup_widget(Checkbox(id, checked))
end

function Euler:init_switch(id, ison)
    return self:setup_widget(Switch(id, ison))
end

function Euler:init_button(id)
    return self:setup_widget(Button(id))
end

function Euler:init_slider(id, value)
    return self:setup_widget(Slider(id, value))
end

function Euler:init_editbox(id, placeholder, text)
    return self:setup_widget(Editbox(id, placeholder, text))
end

function Euler:init_scroll_bar(id, position)
    return self:setup_widget(ScrollBar(id, position))
end

function Euler:init_progress_bar(id, progress)
    return self:setup_widget(ProgressBar(id, progress))
end

function Euler:init_radio_group()
    return RadioGroup()
end

function Euler:update()
    table.sort(self.widgets, function(a, b)
        local index_a = gui.get_index(a:get_root())
        local index_b = gui.get_index(a:get_root())
        return index_a > index_b
    end)
end

function Euler:on_input(action_id, action)
    if action_id == ActionID.LBUTTON then
        if action.pressed then
            self.pressed = true
        end
        if action.released then
            self.pressed = false
        end
    end
    local focus = self.focus
    if focus then
        if not focus:on_input(action_id, action) then
            return
        end
    end
    for _, widget in ipairs(self.widgets) do
        if widget ~= focus then
            if not widget:on_input(action_id, action) then
                break
            end
        end
    end
end

return Euler
