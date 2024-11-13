local GameObject = require("GameObject")
local GameStateManager = require("GameStateManager")


local mt = {}
mt.__index = mt
setmetatable(mt, GameObject)


function mt:update()
	self:baseUpdate()
	
	-- Interacción con botones.
	for _, btn in ipairs(GameStateManager.getCurrent().scene:find("class", "button")) do
		local btnBounds = btn:getSpriteBounds()
	
		if (self:getBounds():intersects(btnBounds) and (btn.type ~= "pageChanger" or (btn.ownerPI == self.ownerPI or btn.ownerPI == 0))) then
			if (btn:canImageChange()) then btn.imageIndex = 2 end
			
			if (not self.grabbing and self.select) then
				btn:selectAction()
			end
		end
	end
	self.select = false
	
	if (self.grabbing) then self.imageIndex = self.firstImageIndex + 1
	else self.imageIndex = self.firstImageIndex end
end


function mt:draw()
	self:baseDraw()
end


return
{
	new = function(sprite, firstImageIndex, ownerPI)
		local nt = {
			class = "playerPointer",
			ownerPI = ownerPI or 0,
			select = false,
			grabbing = false,
			firstImageIndex = firstImageIndex,
			item = nil
		}
		setmetatable(nt, mt)
		nt:baseNew()
		nt:addSprite("sprite", sprite)
		
		
		return nt
	end
}
