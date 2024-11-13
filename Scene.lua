local List = require("List")


local mt = {}
mt.__index = mt

local PRECISION = 0.00001


local function sortByDepth(a, b)
	aDepth = a.depth + a.displayId * PRECISION
	bDepth = b.depth + b.displayId * PRECISION
	
	return aDepth < bDepth
end


function mt:update()
	for _, spr in ipairs(self.sprite.items) do
		spr:update()
	end
	
	for _, go in ipairs(self.gameObject.items) do
		go:update()
    end
end


function mt:draw()
	local drawables = {}

	local dId = 0
	
    for _, spr in ipairs(self.sprite.items) do
		spr.displayId = dId
		table.insert(drawables, spr)
		dId = dId + 1
	end
	
    for _, go in ipairs(self.gameObject.items) do
		go.displayId = dId
		table.insert(drawables, go)
		dId = dId + 1 
	end
    
    
    table.sort(drawables, sortByDepth)
    for _, item in ipairs(drawables) do
		item:draw()
    end
end


function mt:add(item)
	objectList = item.class
	
	self[objectList]:add(item)
	item.id = self[objectList].indexCount
	item.scene = self
	item:onAdd()
end


function mt:remove(item, removeCallBack)
	objectList = item.class
	
	for i = #self[objectList].items, 1, -1 do
        if (self[objectList].items[i] == item) then
        
			if (removeCallBack == nil or removeCallBack == true) then
				item:onRemove()
				item.removed = true
			end
			
            self[objectList]:remove(i)
            
            break
        end
    end
end


function mt:find(gameElementClass, parameter, value, breakOnOne)
	objectList = gameElementClass

    return self[objectList]:find(parameter, value, breakOnOne)
end


return
{
    new = function()
        local nt = {
			gameObject = List.new(),
			sprite = List.new(),
			collision = List.new()
        }
        setmetatable(nt, mt)

        return nt
    end
}
