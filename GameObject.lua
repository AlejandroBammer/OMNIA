local GameStateManager = require("GameStateManager")
local FPS = require("FPS")
local GameElement = require("GameElement")
local Rectangle = require("Rectangle")


local mt = {
	class = "gameObject",
	type = "",
	name = "",
	tags = nil,
	depth = 0,
	visible = true,
	x = 0,
	y = 0,
	rotation = 0,
	scaleX = 1,
	scaleY = 1,
	imageIndex = 1,
	imageSpeed = 0,
	imageTime  = 0,
	imageAlpha = 1,
	imageBlend = nil,
	spriteDict = nil,
	spriteKey  = "nil",
	ECB = nil,
	ECBOffsetX = 0,
	ECBOffsetY = 0,
	ECBColor = nil,
	collisionTypes = nil
}
mt.__index = mt
setmetatable(mt, GameElement)


function mt:setTag(key, value) self.tags[key] = value end

function mt:getTag(key) return self.tags[key] end


function mt:setECB(offsetX, offsetY, width, height)
	self.ECBOffsetX = offsetX
	self.ECBOffsetY = offsetY
	
	self.ECB = Rectangle.new(offsetX, offsetY, width, height)
end


function mt:getECB()
	return Rectangle.new(self.x - self.ECBOffsetX, self.y - self.ECBOffsetY, self.ECB.width, self.ECB.height)
end


function mt:collisionTypesReset()
	self.collisionTypes = { right = false, left = false, bottom = false, false, top = false }
end


function mt:getBounds()
    local sprite = self:getSprite()
    
    sprite.x = self.x
    sprite.y = self.y

    return sprite:getBounds(self.imageIndex)
end


function mt:_getCollisions()
	local list = {}

	for _, col in ipairs(self.scene.collision.items) do
		if (self:getECB():intersects(col.area)) then
			table.insert(list, col)
		end
	end
	
	return list
end


function mt:move(movement)
	local ECB

	self.x = self.x + movement.x
	ECB = self:getECB()
	
	for _, col in ipairs(self:_getCollisions()) do
		local colArea = col.area
		
		if (ECB:intersects(colArea)) then
			if (movement.x > 0) then
				self.x = (colArea:getLeft() - ECB.width) + self.ECBOffsetX
				self.collisionTypes.right = true
			end
			
			if (movement.x < 0) then
				self.x = (colArea:getRight()) + self.ECBOffsetX
				self.collisionTypes.left = true
			end
		end
	end
	
	
	self.y = self.y + movement.y
	ECB = self:getECB()
	
	for _, col in ipairs(self:_getCollisions()) do
		local colArea = col.area
		
		if (ECB:intersects(colArea)) then
			if (self.movement.y > 0) then
				self.y = (colArea:getTop() - ECB.height) + self.ECBOffsetY
				self.collisionTypes.bottom = true
			end
			
			if (self.movement.y < 0) then
				self.y = (colArea:getBottom()) + self.ECBOffsetY
				self.collisionTypes.top = true
			end
		end
	end
end


function mt:getSprite(key)
	key = key ~= nil and key or self.spriteKey;
	
	if (self:hasSprite(key)) then
		return self.spriteDict[key];
	else
		return nil -- En su lugar devolver un sprite génerico.
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


function mt:drawECB()
	local r = self:getECB()

	love.graphics.setColor(self.ECBColor[1], self.ECBColor[2], self.ECBColor[3], self.ECBColor[4])
	love.graphics.rectangle("fill", r.x, r.y, r.width, r.height)
	love.graphics.setColor(1, 1, 1, 1)
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
    sprite.originX,
    sprite.originY)
end


function mt:baseUpdate()
	self:collisionTypesReset()

    if not (self:hasSprite() and self:getSprite().imageNumber > 1 and self.imageSpeed > 0) then return end

    self.imageTime = self.imageTime + FPS.min_dt

    if (self.imageTime > self.imageSpeed/10) then
        self.imageTime = 0

        self.imageIndex = self.imageIndex + 1
        
        if (self.imageIndex > self:getSprite().imageNumber) then self.imageIndex = 1 end
    end
end

function mt:update() self:baseUpdate() end


function mt:baseDraw()
    if not ((self.visible) and (self.spriteKey ~= "nil")) then return end

    love.graphics.setColor(self.imageBlend[1], self.imageBlend[2], self.imageBlend[3], self.imageAlpha)
    self:spriteDraw()
    love.graphics.setColor(1, 1, 1)
end

function mt:draw() self:baseDraw() end


function mt:baseNew()
	self.tags = {}
	self.ECB = Rectangle.new()
	self.ECBColor = { 0, 0, 1, 0.5 }
    self.imageBlend = { 1, 1, 1 }
    self.spriteDict = {}
    self:collisionTypesReset()
end


function mt.new(x, y)
	local nt = {
		x = x or 0,
		y = y or 0
	}
	setmetatable(nt, mt)
	nt:baseNew()

	return nt
end


return mt
