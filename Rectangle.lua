local mt = {}
mt.__index = mt


function mt.new(x, y, width, height)
    local nt =
    {
        x = x or 0,
        y = y or 0,
        width = width or 0,
        height = height or 0
    }
    setmetatable(nt, mt)
    
    
    return nt
end


function mt:toBounds()
	return require("Bounds").new(self.x, self.y, self.width, self.height)
end


function mt:intersects(other)
    return  self:getRight()  > other:getLeft()  and
            self:getLeft()   < other:getRight() and
            self:getBottom() > other:getTop()   and
            self:getTop()    < other:getBottom()
end


function mt:getRight()  return self.x + self.width end
function mt:getLeft()   return self.x end
function mt:getBottom() return self.y + self.height end
function mt:getTop()    return self.y end


return mt
