local GameObject = require("GameObject")
local Sprite = require("Sprite")
local Input = require("Input")
local GameStateManager = require("GameStateManager")
local Bounds = require("Bounds")

local mt = {}
mt.__index = mt
setmetatable(mt, GameObject)


function mt:inputHandle()
	if (self.inputRespond == false) then return end
	
	self.moveRight = Input.get(1, "right")
	self.moveLeft = Input.get(1, "left")
	self.moveJump = Input.get(1, "jump")
end


function mt:update()
	self:baseUpdate()
	
	self.spd = self.mSpd
	
	self:inputHandle()
	
	------  Movimiento  ------
	
	-- Velocidad de movimiento.
	self:move(self.movement)
	
	
	-- Movimiento horizontal.
	self.movement.x = 0
	
	if (self.moveRight) then self.movement.x = self.spd end
	if (self.moveLeft) then self.movement.x = -self.spd end
	
	
	-- Gravedad.
	if (not self.collisionTypes.bottom)  then
		if (self.movement.y < 4) then
			self.movement.y = self.movement.y + 0.3
		end
	else
		self.movement.y = 0.3
		
		if (self.moveJump and not self.trgJump) then
			self.movement.y = -6
		end
	end
	self.trgJump = self.moveJump
end


function mt:draw()
	self:baseDraw()
	
	self:drawECB()
	
	love.graphics.setColor(1, 0, 0, 0.5)
	love.graphics.rectangle("fill", self.x - 1, self.y - 1, 2, 2)
	love.graphics.setColor(1, 1, 1, 1)
end


function mt:resetCollisionTypes()
	self.collisionTypes = { right = false, left = false, bottom = false, top  = false }
end


return
{
	new = function(x, y)
		local nt = {
			inputRespond = true,
			x = x or 0,
			y = y or 0,
			movement = { x = 0, y = 0 },
			spd = 2,
			mSpd = 2,
			lSpd = 1,
			collisionTypes = { right = false, left = false, bottom = false, top  = false },
			moveRight = false,
			moveLeft = false,
			moveJump = false
		}
		setmetatable(nt, mt)
		nt:baseNew()
		
		local sprite = Sprite.new("gfx/Weabo.png")
		sprite.originX = sprite.width/2
		sprite.originY = sprite.height
		
		nt:addSprite("sprite", sprite)
		
		nt:setECB(15, 20, 30, 20)
		nt.eX = 15
		nt.eY = 20
		
		return nt
	end
}
