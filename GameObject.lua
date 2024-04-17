local GameStateManager = require("GameStateManager")
local FPS = require("FPS")
local Bounds = require("Bounds")
local GameElement = require("GameElement")


local mt = {
	id = 0,
	class = "",
	name = "",
	type = "",
	destroy = false,
	visible = true,
	depth = 0,
	x = 0,
	y = 0,
	scaleX = 1,
	scaleY = 1,
	rotation = 0,
	imageIndex = 1,
	imageSpeed = 0,
	imageTime  = 0,
	imageAlpha = 1,
	imageBlend = nil,
	spriteDict = nil,
	spriteKey  = "nil",
	_bounds = Bounds.new()
}
mt.__index = mt
setmetatable(mt, GameElement)


function mt:baseNew()
    self.imageBlend = { 1, 1, 1 }
    self.spriteDict = {}
end


function mt:setBounds(bounds, index)
	local imageOriginX = self:getSprite().imageOriginX or 0
	local imageOriginY = self:getSprite().imageOriginY or 0

	bounds.oX = bounds:getX()
	bounds.oY = bounds:getY()

	bounds:setX(bounds.oX + self.x - imageOriginX)
	bounds:setY(bounds.oY + self.y - imageOriginY)
	
	self._bounds = bounds
end


function mt:getBounds(index)
	local imageOriginX = self:getSprite().imageOriginX or 0
	local imageOriginY = self:getSprite().imageOriginY or 0

	self._bounds:setX((self._bounds.oX or 0) + self.x - imageOriginX)
	self._bounds:setY((self._bounds.oY or 0) + self.y - imageOriginY)
	
	return self._bounds
end


function mt:getSpriteBounds()
    local sprite = self:getSprite()
    
    sprite.x = self.x
    sprite.y = self.y

    return sprite:getBounds(self.imageIndex)
end


function mt:intersect(param)
    local r = false

    for _, obj in ipairs(GameStateManager.getCurrent().scene) do
        if ((obj[param]) and (obj ~= self)) then
            if (self:getRectangleMask():intersect(obj:getRectangleMask())) then r = true end
        end
    end

    return r
end


function mt:getSprite(key)
	key = key ~= nil and key or self.spriteKey;
	
	if (self:hasSprite(key)) then
		return self.spriteDict[key];
	else
		-- return print("No se encontró el sprite: " .. key)
		return nil
	end
end


function mt:hasSprite(key)
	key = key ~= nil and key or self.spriteKey;
	
	if (self.spriteDict[key] ~= nil) then
		return true
	else
		return false
	end
end


function mt:addSprite(key, sprite)
    if (self.spriteKey == "nil") then
        self.spriteKey = key
    end

    self.spriteDict[key] = sprite
end


function mt:spriteDraw()
    local sprite = self:getSprite()

    local quad
    if (#sprite.grid > 0) then
        quad = sprite.grid[self.imageIndex] or sprite.grid[sprite.imageNumber]
    else
        quad = love.graphics.newQuad(0, 0, sprite.image:getWidth(), sprite.image:getHeight(), sprite.image)
    end

    love.graphics.draw(
    sprite.image,
    quad,
    math.floor(self.x+0.5),
    math.floor(self.y+0.5),
    self.rotation,
    self.scaleX,
    self.scaleY,
    sprite.imageOriginX,
    sprite.imageOriginY)
end


function mt:baseUpdate()
    if not (self:hasSprite() and self:getSprite().imageNumber > 1 and self.imageSpeed > 0) then return end

    self.imageTime = self.imageTime + FPS.min_dt

    if (self.imageTime > self.imageSpeed/10) then
        self.imageTime = 0

        self.imageIndex = self.imageIndex + 1
        
        if (self.imageIndex > self:getSprite().imageNumber) then self.imageIndex = 1 end
    end
end


function mt:baseDraw()
    if not ((self.visible) and (self.spriteKey ~= "nil")) then return end

    love.graphics.setColor(self.imageBlend[1], self.imageBlend[2], self.imageBlend[3], self.imageAlpha)
    self:spriteDraw()
    love.graphics.setColor(1, 1, 1)
end


return mt
