--euler.lua
--lua oop 支持
require("luaoop.enum")
require("luaoop.class")
require("luaoop.mixin")
require("luaoop.property")

--euler utils
require("euler.const")

local Button    = require("euler.button")
local Checkbox  = require("euler.checkbox")

local euler = {}

--初始化button
function euler.init_button(id, pressed_img, hovered_img, disabled_img)
    return Button(id, pressed_img, hovered_img, disabled_img)
end

--初始化checkbox
function euler.init_checkbox(id, checked)
    return Checkbox(id, checked)
end

return euler