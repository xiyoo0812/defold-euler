--euler.lua

require("luaoop.init")

--euler utils
require("euler.const")

local ActionID	= enum("ActionID")

local Text = require("euler.text")
local Image = require("euler.image")
local Radio  = require("euler.radio")
local Button = require("euler.button")
local Switch  = require("euler.switch")
local Slider  = require("euler.slider")
local Editbox  = require("euler.editbox")
local Checkbox  = require("euler.checkbox")
local ScrollBar = require("euler.scroll_bar")
local ScrollView = require("euler.scroll_view")
local RadioGroup  = require("euler.radio_group")
local ImageButton = require("euler.image_button")
local ProgressBar  = require("euler.progress_bar")

local Euler = singleton()
local prop = property(Euler)
prop:reader("frame", 0)
prop:reader("focus", nil)
prop:reader("widgets", {})
prop:accessor("pressed", false)

function Euler:setup_widget(widget)
    table.insert(self.widgets, widget)
    widget:set_euler(self)
    widget:setup(self)
    return widget
end

function Euler:init_text(id, txt)
    return self:setup_widget(Text(id, txt))
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

function Euler:init_image_button(id)
    return self:setup_widget(ImageButton(id))
end

function Euler:init_slider(id, value)
    return self:setup_widget(Slider(id, value))
end

function Euler:init_editbox(id, text)
    return self:setup_widget(Editbox(id, text))
end

function Euler:init_number_box(id, text)
    local editbox = Editbox(id, text)
    editbox:set_numbered(true)
    return self:setup_widget(editbox)
end

function Euler:init_password_box(id, text)
    local editbox = Editbox(id, text)
    editbox:set_password(true)
    return self:setup_widget(editbox)
end

function Euler:init_scroll_bar(id, percent)
    return self:setup_widget(ScrollBar(id, percent))
end

function Euler:init_scroll_view(id, capture)
    return self:setup_widget(ScrollView(id, capture))
end

function Euler:init_progress_bar(id, progress)
    return self:setup_widget(ProgressBar(id, progress))
end

function Euler:init_radio_group()
    return RadioGroup()
end

function Euler:set_focus(widget)
    if self.focus == widget then
        return
    end
    if self.focus then
        self.focus:set_focus(false)
        self.focus:update(0)
    end
    if widget then
        widget:set_focus(true)
    end
    self.focus = widget
end

function Euler:refresh()
    table.sort(self.widgets, function(a, b)
        local index_a = gui.get_index(a:get_root())
        local index_b = gui.get_index(a:get_root())
        return index_a > index_b
    end)
end

function Euler:update(dt)
    self.frame = self.frame + 1
    if self.focus then
        self.focus:update(self.frame)
    end
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
    if action_id == ActionID.TEXT then
        return
    end
    for _, widget in ipairs(self.widgets) do
        if widget ~= focus then
            if not widget:on_input(action_id, action) then
                break
            end
        end
    end
end

_G.euler = Euler()

return _G.euler
