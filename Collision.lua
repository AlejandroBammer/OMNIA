local Rectangle = require("Rectangle")
local GameElement = require("GameElement")

local mt = {}
mt.__index = mt
setmetatable(mt, GameElement)

return
{
	new = function(x, y, width, height)
		local nt = {
			class = "collision",
			type = "rect", -- [[ "rect", "ramp", "platform" ]] --
			face = "right", -- [[ "right", "left", "topRight", "topLeft" ]] --
			area = Rectangle.new(x, y, width, height),
		}
		setmetatable(nt, mt)
		
		return nt
	end
}
