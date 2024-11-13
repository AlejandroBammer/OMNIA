local FPS = require("FPS")
local Rectangle = require("Rectangle")
local Bounds = require("Bounds")
local GameElement = require("GameElement")

local mt = {}
mt.__index = mt
setmetatable(mt, GameElement)


function mt:update()
    if not ((self.imageNumber > 1) and (self.imageSpeed > 0)) then return end

    self.imageTime = self.imageTime + FPS.min_dt

    if (self.imageTime > self.imageSpeed/10) then
        self.imageTime = 0

        self.imageIndex = self.imageIndex + 1
        
        if (self.imageIndex > self.imageNumber) then self.imageIndex = 1 end
    end
end


function mt:draw()
	if (not self.visible) then return end

	love.graphics.setColor(self.imageBlend[1], self.imageBlend[2], self.imageBlend[3], self.imageAlpha)
    love.graphics.draw(
    self.image,
    math.floor(self.x+0.5),
    math.floor(self.y+0.5),
    self.rotation,
    self.scaleX,
    self.scaleY,
    math.floor(self.originX+0.5),
    math.floor(self.originY+0.5))
    love.graphics.setColor(1, 1, 1, 1)
end


function mt:getRect()
	return Rectangle.new(self.x - self.originX, self.y - self.originY, self.width, self.height)
end


function mt:setBounds(bounds, imageIndex)
	bounds.oX = bounds:getX()
	bounds.oY = bounds:getY()

	bounds:setX(bounds.oX + self.x - self.originX)
	bounds:setY(bounds.oY + self.y - self.originY)
	
	self.bounds[imageIndex or 1] = bounds
end


function mt:getBounds(imageIndex)
	local bounds
	
	if (imageIndex == nil) then
		bounds = self.bounds[1]
	else
		bounds = self.bounds[imageIndex] ~= nil and self.bounds[imageIndex] or self.bounds[1]
	end

	bounds:setX(bounds.oX + self.x - self.originX)
	bounds:setY(bounds.oY + self.y - self.originY)
	
	return bounds
end


function mt:addBounds(bounds, imageIndex)
	bounds:setX(bounds:getX() + self.x - self.originX)
	bounds:setY(bounds:getY() + self.y - self.originY)

	self:getBounds(imageIndex or nil):add(bounds)
end


function mt:createGrid(imageNumber, imagesPerRow, width, height, horizontalCellOffset, verticalCellOffset)

    --  Crea una nueva quad  --
    self.imageNumber  = imageNumber or 1
    local imagesPerRow = imagesPerRow or self.imageNumber
    
    if not ((width) and (height)) then
        -- Creara una rejilla horizontal si no se pasan estos argumentos.
        self.width  = math.floor(self.image:getWidth()/self.imageNumber)
        self.height = self.image:getHeight()
    else
        self.width  = width
        self.height = height
    end

    horizontalCellOffset = horizontalCellOffset or 0
    verticalCellOffset   = verticalCellOffset   or 0

    for i = 0, self.imageNumber-1 do
        local x = i % imagesPerRow * self.width
        local y = math.floor(i / imagesPerRow) * self.height

        table.insert(self.grid, love.graphics.newQuad(x+horizontalCellOffset*self.width, y+verticalCellOffset*self.height, self.width, self.height, self.image:getDimensions()))
    end

    self:setBounds(Bounds.new(self.x, self.y, self.width, self.height))

    --  Redefinición del método draw(Agrega el argumento grid)  --
    self.draw = function()
		if (not self.visible) then return end
    
		love.graphics.setColor(self.imageBlend[1], self.imageBlend[2], self.imageBlend[3], self.imageAlpha)
        love.graphics.draw(
        self.image,
        self.grid[self.imageIndex],
        math.floor(self.x),
        math.floor(self.y),
        self.rotation,
        self.scaleX,
        self.scaleY,
        math.floor(self.originX+0.5),
        math.floor(self.originY+0.5))
        love.graphics.setColor(1, 1, 1, 1)
    end
end


return {
    new = function(image, x, y, rotation, scaleX, scaleY, originX, originY)
        local nt = {
			id = 0,
			class = "sprite",
			depth = 0,
			image = type(image) ~= "string" and image or love.graphics.newImage(image),
			x = x or 0,
			y = y or 0,
			rotation = rotation or 0,
			scaleX   = scaleX   or 1,
			scaleY   = scaleY   or 1,
			originX  = originX  or 0,
			originY  = originY  or 0,
			grid = {},
			imageIndex  = 1,
			imageTime = 0,
			imageSpeed = 0,
			imageNumber = 0,
			imageBlend = { 1, 1, 1 },
			imageAlpha = 1,
			width,
			height,
			bounds = {},
        }
        setmetatable(nt, mt)
        nt.width, nt.height = nt.image:getDimensions()
        nt:setBounds(Bounds.new(0, 0, nt.width, nt.height))


        return nt
    end
}
