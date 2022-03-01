--euler.lua

require("luaoop.enum")
require("luaoop.class")
require("luaoop.mixin")
require("luaoop.property")

--euler utils
require("euler.const")

local Image = require("euler.image")
local Radio  = require("euler.radio")
local Button = require("euler.button")
local Switch  = require("euler.switch")
local Slider  = require("euler.slider")
local Editbox  = require("euler.editbox")
local Checkbox  = require("euler.checkbox")
local RadioGroup  = require("euler.radio_group")
local ProgressBar  = require("euler.progress_bar")

local Euler = class()
local prop = property(Euler)
prop:reader("widgets", {})

function Euler:init_image(id, img)
    local widget = Image(id, img)
    table.insert(self.widgets, widget)
    return widget
end

function Euler:init_radio(id, checked)
    local widget = Radio(id, checked)
    table.insert(self.widgets, widget)
    return widget
end

function Euler:init_checkbox(id, checked)
    local widget = Checkbox(id, checked)
    table.insert(self.widgets, widget)
    return widget
end

function Euler:init_switch(id, ison)
    local widget = Switch(id, ison)
    table.insert(self.widgets, widget)
    return widget
end

function Euler:init_button(id)
    local widget = Button(id)
    table.insert(self.widgets, widget)
    return widget
end

function Euler:init_slider(id, value)
    local widget = Slider(id, value)
    table.insert(self.widgets, widget)
    return widget
end

function Euler:init_editbox(id, placeholder, text)
    local widget = Editbox(id, placeholder, text)
    table.insert(self.widgets, widget)
    return widget
end

function Euler:init_progress_bar(id, progress)
    local widget = ProgressBar(id, progress)
    table.insert(self.widgets, widget)
    return widget
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
    for _, widget in ipairs(self.widgets) do
        if not widget:on_input(action_id, action) then
            break
        end
    end
end

return Euler
