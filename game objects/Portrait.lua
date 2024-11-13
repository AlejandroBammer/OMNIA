local GameObject = require("GameObject")

local mt = {}
mt.__index = mt
setmetatable(mt, GameObject)


function mt:update()
	self:baseUpdate()
end


function mt:draw()
	self:baseDraw()
	
	if (self.sprite ~= nil) then
		self.sprite.x = self.x + self.spriteXOffset;
		self.sprite.y = self.y + self.spriteYOffset;
		self.sprite:draw()
	end
end


return
{
	new = function(sprite)
		local nt = {
			sprite = nil,
			spriteXOffset = 0,
			spriteYOffset = 0
		}
		setmetatable(nt, mt)
		nt:baseNew()
		nt:addSprite("sprite", sprite)
		
		return nt
	end
}
