--euler.lua
--lua oop 支持
require("luaoop.enum")
require("luaoop.class")
require("luaoop.mixin")
require("luaoop.property")

--euler utils
require("euler.const")

local Button = require("euler.button")

local euler = {}

function euler.button(id)
    return Button(id)
end

return euler