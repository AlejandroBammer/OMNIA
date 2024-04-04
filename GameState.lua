local List = require("List")
local Global = require("Global")

local mt = {}
mt.__index = mt


local function toDecimal(n)
	local z = "0.000000000000000"
	
	return tonumber(string.sub(z, 1, string.len(z) - string.len(n)) .. n)
end


local function sortByDepth(a, b)
	aDepth = a.depth + toDecimal(a.id)
	bDepth = b.depth + toDecimal(b.id)
	
	return aDepth < bDepth
end


function mt:baseNew()
    self.scene = List.new()
    
    self.scene.onAdd = function(object)
		object.id = Global.idCounter
		Global.idCounter = Global.idCounter + 1
    end
end


function mt:baseUpdate()
    for _, obj in ipairs(self.scene.items) do
        if (obj.update) then
            obj:update()
        end
    end

    for obj = #self.scene.items, 1, -1 do
        if (self.scene.items[obj].destroy) then
            self.scene:remove(obj)
        end
    end
end


function mt:baseDraw()
	self.scene:sort(sortByDepth)

    for _, obj in ipairs(self.scene.items) do
        if (obj.draw) then
            obj:draw()
        end
    end
end


return mt
