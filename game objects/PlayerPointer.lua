local GameObject = require("GameObject")
local GameStateManager = require("GameStateManager")
local Input = require("Input")
local Viewport = require("Viewport")
local Utils = require("Utils")


local mt = {}
mt.__index = mt
setmetatable(mt, GameObject)

local HAND_SPD = 2.4
local HAND_ACC = 0.6


function mt:update()
	self:baseUpdate()
	
	---  Interacción con botones  ---
	if (self.visible) then
		for _, btn in ipairs(self.scene:find("gameObject", "type", "button")) do
			local btnBounds = btn:getBounds()
		
			if (self:getECB():intersects(btnBounds:getArea()) and not self.grabbing) then
				if (btn:canImageChange()) then btn.imageIndex = 2 end
				
				if (self.select) then btn:selectAction() end
			end
		end
		self.select = false
		
		if (self.grabbing) then self.imageIndex = self.firstImageIndex + 1
		else self.imageIndex = self.firstImageIndex end
	end
	
	
	---  Movimiento  ---
	-- Inputs.
	local moveDown = Input.get(self.PID, "down")
	local moveRight = Input.get(self.PID, "right")
	local moveUp = Input.get(self.PID, "up")
	local moveLeft = Input.get(self.PID, "left")
	
	local hInput = moveRight and 1 or moveLeft and -1 or 0
	local vInput = moveDown and 1 or moveUp and -1 or 0
	
	
	-- Movimiento.
	self.movement.x = Utils.approach(self.movement.x, hInput * HAND_SPD, HAND_ACC)
	self.movement.y = Utils.approach(self.movement.y, vInput * HAND_SPD, HAND_ACC)
	
	
	-- Velocidad.
	self.x = self.x + self.movement.x
	self.y = self.y + self.movement.y
	
	
	-- Límites.
	if (self.x < 0) then self.x = 0 end
	if (self.x > Viewport.width) then self.x = Viewport.width end
	if (self.y < 0) then self.y = 0 end
	if (self.y > Viewport.height) then self.y = Viewport.height end
end


function mt:draw()
	self:baseDraw()
end


return
{
	new = function(sprite, firstImageIndex, PID)
		local nt = {
			type = "PlayerPointer",
			PID = PID or 0,
			select = false,
			grabbing = false,
			firstImageIndex = firstImageIndex,
			movement = { x = 0, y = 0 }
		}
		setmetatable(nt, mt)
		nt:baseNew()
		nt:addSprite("sprite", sprite)
		
		
		return nt
	end
}
