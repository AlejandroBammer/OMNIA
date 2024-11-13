local List = require("List")
local Global = require("Global")
local PRECISION = 0.0001

local mt =
{
	name = ""
}
mt.__index = mt


local function sortByDepth(a, b)
	aDepth = a.depth + a.id * PRECISION
	bDepth = b.depth + b.id * PRECISION
	
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

function mt:update() self:baseUpdate() end


function mt:baseDraw()
	self.scene:sort(sortByDepth)

    for _, obj in ipairs(self.scene.items) do
        if (obj.draw) then
            obj:draw()
        end
    end
end

function mt:draw() self:baseDraw() end


return mt
