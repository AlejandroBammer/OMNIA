local GameObject = require("GameObject")
local Sprite = require("Sprite")
local Bounds = require("Bounds")
local Mouse = require("Mouse")

local mt = {}
mt.__index = mt
setmetatable(mt, GameObject)


function mt:selectAction()
end


function mt:_canChangeSubImage()
	if (self.enableSubImage and self:getSprite().imageNumber > 1) then
		return true
	else
		return false
	end
end


function mt:update()
	self:baseUpdate()
	
	-- Evento del ratón.
	if (self.enableMouse) then
		local bMouse = Bounds.new(Mouse.getX(), Mouse.getY(), 1, 1)
		
		if (bMouse:intersects(self:getSpriteBounds())) then
			if (self:_canChangeSubImage()) then self.imageIndex = 2 end
		
			if (Mouse.getLeftClick()) then
				self:selectAction()
			end
		else
			if (self:_canChangeSubImage()) then self.imageIndex = 1 end
		end
	end
end


function mt:draw()
	self:baseDraw()
	
	local bounds = self:getSpriteBounds()
	bounds:draw()
end


return
{
	new = function(sprite)
		local nt = {
			enableMouse = true,
			enableSubImage = true
		}
		setmetatable(nt, mt)
		nt:baseNew()
		
		if (sprite ~= nil) then
			nt:addSprite("sprite", sprite)
		end
		
		return nt
	end
}
