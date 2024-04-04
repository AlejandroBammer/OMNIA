local Rectangle = require("Rectangle")
local List = require("List")


local mt = {}
mt.__index = mt


function mt:getX()
	return self._x
end


function mt:getY()
	return self._y
end


function mt:setX(value)
	local oldX = self._x
	self._x = value
	
	for _, bounds in ipairs(self.boundsCollection.items) do
		bounds.rect.x = self._x + (bounds.rect.x - oldX)
	end
	
	self._areaX = self._areaX + self._x - oldX
end


function mt:setY(value)
	local oldY = self._y
	self._y = value
	
	for _, bounds in ipairs(self.boundsCollection.items) do
		bounds.rect.y = self._y + (bounds.rect.y - oldY)
	end
	
	self._areaY = self._areaY + self._y - oldY
end


function mt:add(bounds)
	if (#bounds.boundsCollection.items > 0) then
		for _, obounds in ipairs(bounds.boundsCollection.items) do
			self.boundsCollection:add(obounds)
		end
		
		-- Expansión del area por coordenadas.
		if (bounds._areaX < self._areaX) then
			self._areaWidth = self._areaWidth + self._areaX - bounds._areaX
			
			self._areaX = bounds._areaX
		end
		
		if (bounds._areaY < self._areaY) then
			self._areaHeight = self._areaHeight + self._areaY - bounds._areaY;
			
			self._areaY = bounds._areaY
		end
		
		-- Expansión del area por dimensiones.
		if (bounds._areaX + bounds._areaWidth > self._areaX + self._areaWidth) then
			self._areaWidth = self._areaWidth + (bounds._areaWidth - (self._areaX + self._areaWidth - bounds._areaX))
		end
		if (bounds._areaY + bounds._areaHeight > self._areaY + self._areaHeight) then
			self._areaHeight = self._areaHeight + (bounds._areaHeight - (self._areaY + self._areaHeight - bounds._areaY))
		end
	else
		self.boundsCollection:add(bounds)
		
		self._areaX = bounds.x
		self._areaY = bounds.y
		self._areaWidth = bounds.width
		self._areaHeight = bounds.height
	end
end


function mt:getArea()
	return Rectangle.new(self._areaX, self._areaY, self._areaWidth, self._areaHeight)
end


function mt:intersects(bounds)
	local r = false
	
	if (self:getArea():intersects(bounds:getArea())) then
		for _, tBounds in ipairs(self.boundsCollection.items) do
			for _, oBounds in ipairs(bounds.boundsCollection.items) do
				if (tBounds.rect:intersects(oBounds.rect)) then
					r = true;
				end
			end
		end
	end
		
	return r;
end


function mt:drawArea()
	love.graphics.setColor(self.areaColor[1], self.areaColor[2], self.areaColor[3], self.areaAlpha)
	love.graphics.rectangle("fill", self._areaX, self._areaY, self._areaWidth, self._areaHeight)
	love.graphics.setColor(1, 1, 1, 1)
end
	

function mt:draw()
	self:drawArea();
	
	for _, bounds in ipairs(self.boundsCollection.items) do
		love.graphics.setColor(self.color[1], self.color[2], self.color[3], self.alpha)
		love.graphics.rectangle("fill", bounds.rect.x, bounds.rect.y, bounds.rect.width, bounds.rect.height)
		love.graphics.setColor(1, 1, 1, 1)
	end
end


function mt:set(x, y, width, height)
	self._x = x or 0
	self._y = y or 0
	self._width = width or 0
	self._height = height or 0
	
	self.rect = Rectangle.new(self._x, self._y, self._width, self._height)
	
	if (#self.boundsCollection.items < 1) then
		self:add(self);
	end
end


return
{
	new = function(x, y, width, height)
		local nt = {
			boundsCollection = List.new(),
			color = { 0, 0, 1 },
			alpha = 0.5,
			_x = 0,
			_y = 0,
			_width = 0,
			_height = 0,
			areaColor = { 0, 1, 0 },
			areaAlpha = 0.5
		}
		setmetatable(nt, mt)
		
		nt:set(x, y, width, height)
		
		nt._areaX = nt._x
		nt._areaY = nt._y
		nt._areaWidth = nt._width
		nt._areaHeight = nt._height
		
		return nt
	end
}
