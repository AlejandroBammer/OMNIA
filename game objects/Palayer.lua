local GameObject = require("GameObject")
local Sprite = require("Sprite")
local Input = require("Input")
local GameStateManager = require("GameStateManager")

local mt = {}
mt.__index = mt
setmetatable(mt, GameObject)


function mt:update()
	self:baseUpdate()
	
	------  Controles  ------
	self.spd = self.mSpd
	
	if (Input.get(1, "attack")) then self.spd = self.lSpd end
	if (Input.get(1, "guard")) then
		self:instanceDestroy()
	end
	
	if (Input.get(1, "down"))  then self.y = self.y + self.spd end
	if (Input.get(1, "right")) then self.x = self.x + self.spd end
	if (Input.get(1, "up"))    then self.y = self.y - self.spd end
	if (Input.get(1, "left"))  then self.x = self.x - self.spd end
	
	
	if (Input.get(1, "special") and not self.trgSpecial) then
		local weabo = Sprite.new("gfx/Weabo.png", self.x, self.y)
		weabo.imageOriginX = weabo.width/2
		weabo.imageOriginY = weabo.height
		weabo.depth = self.depth
	
		GameStateManager.getCurrent().scene:add(weabo)
		print(weabo.id)
	end
	self.trgSpecial = Input.get(1, "special")
	
	
	self.depth = self.y
end


return
{
	new = function(x, y)
		local nt = {
			x = x or 0,
			y = y or 0,
			spd = 2,
			mSpd = 2,
			lSpd = 1
		}
		setmetatable(nt, mt)
		nt:baseNew()
		
		local sprite = Sprite.new("gfx/Weabo.png")
		sprite.imageOriginX = sprite.width/2
		sprite.imageOriginY = sprite.height
		
		nt:addSprite("sprite", sprite)
		
		return nt
	end
}
