local List = require("List")
local Sprite = require("Sprite")
local GameObject = require("GameObject")
local Portrait = require("game objects/Portrait")

local mt = {}
mt.__index = mt
setmetatable(mt, GameObject)


function mt:setPortraits(selectData, index, selectPath, imageFile)
	for _, slot in ipairs(self.slotList.items) do
		slot.name = ""
		slot.sprite = nil
	end

	for i, element in ipairs(selectData[index]) do
		if (element ~= "empty") then
			local slot = self.slotList:get(i)
			slot.name = element
			
			slot.sprite = Sprite.new(selectPath .. "/" .. element .. "/" .. imageFile)
		end
	end
end


function mt:update()
	self:baseUpdate()
	
	-- Slots.
	for y = 1, self.rows, 1 do
		for x = 1, self.columns, 1 do
			local slot = self.slotList:get(x+((y-1)*self.columns))
			
			slot.x = (self.x-self.spaceX) + ((x-1) * self.sprSlot.width) + (x * self.spaceX)
			slot.y = (self.y-self.spaceY) + ((y-1) * self.sprSlot.height) + (y * self.spaceY)
		end
	end
end


function mt:draw()
	self:baseDraw()
	
	for _, slot in ipairs(self.slotList.items) do
		slot:draw()
	end
end


return
{
	new = function(slotImage, columns, rows, spaceX, spaceY, portraitXOffset, portraitYOffset)
		local nt = {
			sprSlot = Sprite.new(slotImage),
			slotList = List.new(),
			columns = columns,
			rows = rows,
			width = 0,
			height = 0
		}
		setmetatable(nt, mt)
		nt:baseNew()
		spaceX = spaceX ~= nil and spaceX or 0
		spaceY = spaceY ~= nil and spaceY or spaceX
		nt.spaceX = spaceX
		nt.spaceY = spaceY
		
		
		-- Slots.
		for y = 1, rows, 1 do
			for x = 1, columns, 1 do
				local slot = Portrait.new()
				slot.spriteXOffset = portraitXOffset
				slot.spriteYOffset = portraitYOffset
				slot:addSprite("sprite", nt.sprSlot)
				slot:setECB(0, 0, nt.sprSlot.width, nt.sprSlot.height)
				
				slot.x = ((x-1) * nt.sprSlot.width) + (x * spaceX)
				slot.y = ((y-1) * nt.sprSlot.height) + (y * spaceY)
				
				nt.slotList:add(slot)
				slot.id = nt.slotList.indexCount
			end
		end
		
		nt.width = (nt.sprSlot.width+spaceX)*nt.columns-spaceX
		nt.height = (nt.sprSlot.height+spaceY)*nt.rows-spaceY
		
		
		return nt
	end
}
