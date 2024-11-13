local GameObject = require("GameObject")
local Sprite = require("Sprite")
local Bounds = require("Bounds")
local Mouse = require("Mouse")
-- local Spritefont = require("Spritefont")


local mt = {}
mt.__index = mt
setmetatable(mt, GameObject)


function mt:selectAction()
end


function mt:canImageChange()
	if (self.imageChange and self:getSprite().imageNumber > 1) then
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
			if (self:canImageChange()) then self.imageIndex = 2 end
		
			if (Mouse.getLeftClick()) then
				self:selectAction()
			end
		else
			if (self:canImageChange()) then self.imageIndex = 1 end
		end
	end
end


function mt:draw()
	self:baseDraw()
	
	-- self:getSpriteBounds():draw()
	
	if (self.font ~= nil and self.text ~= "") then
		local txtCenterX = self.font:getTextWidth(self.text)/2
		self.font:print(self.text, (self.x + self.centerX) - txtCenterX + self.textXOffset, (self.y + self.centerY) - (self.font.height/2) + self.textYOffset)
	end
end


return
{
	new = function(sprite, x, y)
		local nt = {
			class = "button",
			enableMouse = true,
			imageChange = true,
			x = x or 0,
			y = y or 0,
			font = nil, -- Spritefont.new()
			text = "",
			textXOffset = 0,
			textYOffset = 0,
			centerX = 0,
			centerY = 0
		}
		setmetatable(nt, mt)
		nt:baseNew()
		
		
		nt:addSprite("sprite", sprite)
		
		nt.centerX = sprite.width/2
		nt.centerY = sprite.height/2
		
		return nt
	end
}
