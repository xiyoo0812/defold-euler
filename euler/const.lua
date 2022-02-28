--const.lua

--动作id
local ActionID       = enum("ActionID", 0)
ActionID.LBUTTON     = hash("lbutton")
ActionID.DWHEEL      = hash("dwheel")
ActionID.UWHEEL      = hash("uwheel")
ActionID.TEXT        = hash("text")
ActionID.MARKED_TEXT = hash("marked_text")
ActionID.BACKSPACE   = hash("backspace")

--UI 状态
local UIStatus        = enum("UIStatus", 0)
UIStatus.NORMAL       = 0
UIStatus.PRESSED      = 1
UIStatus.DISABLED     = 2