local GameState = require("GameState")


local mt = {}
mt.__index = mt
setmetatable(mt, GameState)


function mt:update()
	self:baseUpdate();
end


function mt:draw()
	self:baseDraw();
end


return
{
	new = function()
		local nt = {}
		setmetatable(nt, mt)
		nt:baseNew()
		
		
		return nt
	end
}
