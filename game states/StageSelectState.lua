local GameState = require("GameState")
local Sprite = require("Sprite")
local Input = require("Input")
local Roster = require("game objects/Roster")
local StageSelect = require("data/StageSelect")
local PlayerPointer = require("game objects/PlayerPointer")
local Rectangle = require("Rectangle")
local GameStateManager = require("GameStateManager")

local PTR_SPR = Sprite.new("gfx/menu/stage select pointer.png")
PTR_SPR:createGrid(4)
PTR_SPR.originX = PTR_SPR.width/2
PTR_SPR.originY = PTR_SPR.height/2


local mt = {}
mt.__index = mt
setmetatable(mt, GameState)


function mt:update()
	self:baseUpdate()
	
	---  Inputs del puntero  ---
	for i = 4, 1, -1 do
		local anyPlayerMove = Input.get(i, "down") or Input.get(i, "right") or Input.get(i, "up") or Input.get(i, "left")
		
		-- Cambio.
		if (anyPlayerMove and self.pointer.PID ~= i) then
			self.pointer.PID = i
			self.pointer.firstImageIndex = i
		end
		
		-- Elección.
		local rPtr = Rectangle.new(self.pointer.x, self.pointer.y, 1, 1)
		
		if (Input.getPress(i, "attack")) then
			self.pointer.PID = i
			self.pointer.firstImageIndex = i
			
			for _, slot in ipairs(self.roster.slotList.items) do
				if (rPtr:intersects(slot:getECB())) then
					if (slot.name ~= "") then
						GameStateManager.push("Play", slot.name)
					end
				end
			end
		end
	end
end


function mt:draw()
	self:baseDraw()
end


return
{
	new = function()
		local nt = {}
		setmetatable(nt, mt)
		nt:baseNew()
		
		nt.roster = Roster.new("gfx/menu/slot.png", StageSelect.columns, StageSelect.rows, -2, -2, 2, 2)
		nt.roster.prtOffsetX = 2; nt.roster.prtOffsetY = 2
		
		nt.roster:setPortraits(StageSelect.data, 1, "stage", "images/1.png")
		
		nt.scene:add(nt.roster)
		
		nt.pointer = PlayerPointer.new(PTR_SPR, 1, 1)
		nt.scene:add(nt.pointer)
		
		return nt
	end
}
