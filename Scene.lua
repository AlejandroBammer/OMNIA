local List = require("List")

local PRECISION = 0.0001


local mt = {}
mt.__index = mt


local function sortByDepth(a, b)
	aDepth = a.depth + a.id * PRECISION
	bDepth = b.depth + b.id * PRECISION
	
	return aDepth < bDepth
end


function mt:update()
	for _, obj in ipairs(self.gameElements) do
		obj:update()
    end
end


function mt:draw()
	table.sort(self.gameElements, sortByDepth)

    for _, obj in ipairs(self.gameElements) do
		obj:draw()
    end
end


function mt:add(item)
	self.idCount = self.idCount + 1
	item.id = self.idCount
	item.scene = self
	
	-- self.gameElements[self.idCount] = item
	table.insert(self.gameElements, item)
end


function mt:remove(item)
	for i = #self.gameElements, 1, -1 do
        if (self.gameElements[i] == item) then
            table.remove(self.gameElements, i)
        end
    end
end


return
{
    new = function()
        local nt = {
			idCount = 0,
			gameElements = {}
        }
        setmetatable(nt, mt)

        return nt
    end
}
