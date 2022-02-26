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
--local Slider  = require("euler.slider")
local Editbox  = require("euler.editbox")
local Checkbox  = require("euler.checkbox")
local RadioGroup  = require("euler.radio_group")
--local ProgressBar  = require("euler.progress_bar")

local euler = {}

function euler.init_image(id, img)
    return Image(id, img)
end

function euler.init_radio(id, checked)
    return Radio(id, checked)
end

function euler.init_checkbox(id, checked)
    return Checkbox(id, checked)
end

function euler.init_switch(id, ison, off_img)
    return Switch(id, ison, off_img)
end

function euler.init_radio_group()
    return RadioGroup()
end

function euler.init_button(id)
    return Button(id)
end

function euler.init_slider(id, value)
    return Slider(id, value)
end

function euler.init_editbox(id, placeholder, text)
    return Editbox(id, placeholder, text)
end

function euler.init_progress_bar(id, value)
    return ProgressBar(id, value)
end

return euler
