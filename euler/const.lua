--const.lua

--动作id
local ActionID       = enum("ActionID", 0)
ActionID.TOUCH       = hash("touch")
ActionID.TEXT        = hash("text")
ActionID.BACKSPACE   = hash("backspace")
ActionID.MARKED_TEXT = hash("marked_text")

--UI 状态
local UIStatus        = enum("UIStatus", 0)
UIStatus.NORMAL       = 0
UIStatus.PRESSED      = 1
UIStatus.HOVERED      = 2
UIStatus.DISABLED     = 3
