local GameState = require("GameState")
local Sprite = require("Sprite")
local GGameObject = require("GGameObject")
local Input = require("Input")
local Bounds = require("Bounds")


local mt = {}
mt.__index = mt
setmetatable(mt, GameState)


function mt:update()
	self:baseUpdate();
	
	if (Input.get(1, "right")) then
		self.bounds:setX(self.bounds:getX() + 2)
	end
	
	if (Input.get(1, "left")) then
		self.bounds:setX(self.bounds:getX() - 2)
	end
	
	if (Input.get(1, "down")) then
		self.bounds:setY(self.bounds:getY() + 2)
	end
	
	if (Input.get(1, "up")) then
		self.bounds:setY(self.bounds:getY() - 2)
	end
	
	
	self.bounds.color = { 1, 0, 0 }
	if (self.bounds:intersects(self.oBounds)) then
		self.bounds.color = { 0, 0, 1 }
	end
end


function mt:draw()
	self:baseDraw();
	
	self.bounds:draw()
	self.oBounds:draw()
end


return
{
	new = function()
		local nt = {}
		setmetatable(nt, mt)
		nt:baseNew()
		
		nt.bounds = Bounds.new(60, 60, 60, 60)
		nt.bounds.color = { 1, 0, 0 }
		nt.bounds.areaColor = { 0, 1, 0 }
		nt.bounds.areaAlpha = 0.5
		
		local b = Bounds.new(30, 30, 60, 60)
		b:add(Bounds.new(15, 15, 6, 6))
		nt.bounds:add(b)
		
		nt.oBounds = Bounds.new(180, 60, 60, 60)
		nt.oBounds.color = { 1, 0, 0 }
		nt.oBounds.areaColor = { 0, 1, 0 }
		nt.oBounds.areaAlpha = 0.5
		nt.oBounds:add(Bounds.new(150, 30, 60, 60))
		nt.oBounds:add(Bounds.new(180, 180, 15, 15))
		
		
		return nt
	end
}
