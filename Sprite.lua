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
	love.graphics.setColor(self.imageBlend[1], self.imageBlend[2], self.imageBlend[3], self.imageAlpha)
    love.graphics.draw(
    self.image,
    math.floor(self.x+0.5),
    math.floor(self.y+0.5),
    self.imageRotation,
    self.imageScaleX,
    self.imageScaleY,
    math.floor(self.imageOriginX+0.5),
    math.floor(self.imageOriginY+0.5))
    love.graphics.setColor(1, 1, 1, 1)
end


function mt:getBounds(index)
	local bounds
	
	if (index == nil) then
		bounds = self.bounds[self.imageIndex]
	else
		bounds = self.bounds[index]
	end

	bounds:setX(bounds.oX + self.x - self.imageOriginX)
	bounds:setY(bounds.oY + self.y - self.imageOriginY)
	
	return bounds
end


function mt:setBounds(bounds, index)
	bounds.oX = bounds:getX()
	bounds.oY = bounds:getY()

	bounds:setX(bounds.oX + self.x - self.imageOriginX)
	bounds:setY(bounds.oY + self.y - self.imageOriginY)
	
	
	if (index == nil) then
		self.bounds[1] = bounds
	else
		self.bounds[index] = bounds
	end
end


function mt:addBounds(bounds, index)
	bounds:setX(bounds:getX() + self.x - self.imageOriginX)
	bounds:setY(bounds:getY() + self.y - self.imageOriginY)

	self:getBounds(index or nil):add(bounds)
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
		love.graphics.setColor(self.imageBlend[1], self.imageBlend[2], self.imageBlend[3], self.imageAlpha)
        love.graphics.draw(
        self.image,
        self.grid[self.imageIndex],
        math.floor(self.x),
        math.floor(self.y),
        self.imageRotation,
        self.imageScaleX,
        self.imageScaleY,
        math.floor(self.imageOriginX+0.5),
        math.floor(self.imageOriginY+0.5))
        love.graphics.setColor(1, 1, 1, 1)
    end
end


return {
    new = function(image, x, y, imageRotation, imageScaleX, imageScaleY, imageOriginX, imageOriginY)
        local nt = {
			id = 0,
			depth = 0,
			image = type(image) ~= "string" and image or love.graphics.newImage(image),
			x = x or 0,
			y = y or 0,
			imageRotation = imageRotation or 0,
			imageScaleX   = imageScaleX   or 1,
			imageScaleY   = imageScaleY   or 1,
			imageOriginX  = imageOriginX  or 0,
			imageOriginY  = imageOriginY  or 0,
			grid = {},
			imageIndex  = 1,
			imageSpeed = 0,
			imageNumber = 0,
			imageBlend = { 1, 1, 1 },
			width,
			height,
			bounds = {},-- require("List").new(),
			imageTime = 0
        }
        setmetatable(nt, mt)
        nt.width, nt.height = nt.image:getDimensions()
        nt:setBounds(Bounds.new(0, 0, nt.width, nt.height))


        return nt
    end
}
