local GameStateManager = require("GameStateManager")
local GameObject = require("GameObject")
local Rectangle = require("Rectangle")
local Portrait = require("game objects/Portrait")
local Roster = require("game objects/Roster")
local Button = require("game objects/Button")
local Sprite = require("Sprite")
local Select = require("data/Select")
local Utils = require("Utils")
local PlayerPointer = require("game objects/PlayerPointer")
local Input = require("Input")

local SL_ARW_SPR = Sprite.new("gfx/menu/sl-arw.png")
SL_ARW_SPR:createGrid(2)

local SR_ARW_SPR = Sprite.new("gfx/menu/sr-arw.png")
SR_ARW_SPR:createGrid(2)

local PRT_SPR = Sprite.new("gfx/menu/portraits.png")
PRT_SPR:createGrid(4)

local HAND_SPR = Sprite.new("gfx/menu/hands.png")
HAND_SPR:createGrid(8)
HAND_SPR.imageOriginX = HAND_SPR.width/2
HAND_SPR.imageOriginY = HAND_SPR.height/2


local mt = {}
mt.__index = mt
setmetatable(mt, GameObject)


function mt:checkTokenPosition()
	local rToken = Rectangle.new(self.token.x, self.token.y, 1, 1)
			
	---  Selección  ---
	self.portrait.sprite = nil
	for _, fsel in ipairs(self.otherSelectors) do -- Permite seleccionar personajes de otros selectores :p.
		for _, slot in ipairs(fsel.roster.slotList.items) do
			if (rToken:intersects(slot:getECB())) then
				if (slot.name ~= "") then
					self.portrait.sprite = Sprite.new("fighter/" .. slot.name .. "/images/2.png")
				end
			end
		end
	end
end


function mt:update()
	self:baseUpdate()
	
	---  Posición  ---
	self.roster.x = self.x
	self.roster.y = self.y
	self.roster:update()
	
	self.arwLeft.x = self.roster.x - SL_ARW_SPR.width
	self.arwLeft.y = self.y
	
	self.arwRight.x = self.roster.x + self.roster.width
	self.arwRight.y = self.y
	
	self.portrait.x = self.x
	self.portrait.y = self.y - PRT_SPR.height
	
	self.pageLabel.x = self.x + 74
	self.pageLabel.y = self.y - self.pageLabel.height
	
	
	---  Inputs de la mano  ---
	if (not self.hand.visible) then
		if (Input.getPress(self.PID, "down") or Input.getPress(self.PID, "right") or Input.getPress(self.PID, "up") or Input.getPress(self.PID, "left")) then
			self.hand.visible = true
		end
	end
	
	if (Input.getPress(self.PID, "attack")) then
		self.hand.select = true
		
		if (self.tokenFollow) then
			self.tokenObjective = nil
			self.tokenFollow = false
			self.hand.grabbing = false
		end
	end
	
	if (Input.getPress(self.PID, "special")) then
		self.tokenObjective = self.hand;
		self.tokenFollow = true;
		self.hand.grabbing = true
	end
	
	
	---  Token  ---
	if (self.tokenFollow) then
		self.tokenFollowed = true
		
		if (self.tokenObjective ~= nil) then
			self.token.x = self.tokenObjective.x
			self.token.y = self.tokenObjective.y
		end
	else
		if (self.tokenFollowed) then
			self.tokenFollowed = false
			self:checkTokenPosition()
		end
	end
end


function mt:draw()
	self:baseDraw()
	
	self.roster:draw()
	self.portrait:draw()
	self.pageLabel:draw()
	
	-- Indice de página.
	local x = self.pageLabel.x + 3 
	local y = self.pageLabel.y + 3
	
	local curPage = "00"
	curPage = string.sub(curPage, 0, string.len(curPage) - string.len(tostring(self.page)))
	curPage = curPage .. self.page
	
	local totalPages = "00"
	totalPages = string.sub(totalPages, 0, string.len(totalPages)-string.len(#Select.fighter))
	totalPages = totalPages .. #Select.fighter
	
	Utils.unknownFont:print(curPage .. "/" .. totalPages, x, y)
end


function mt:load()
	--[[
	self.scene:add(self.arwLeft)
	self.scene:add(self.arwRight)
	self.scene:add(self.token)
	self.scene:add(self.hand)
	--]]
end


return
{
	new = function(otherSelectors, PID, x, y)
		local nt = {
			PID = PID,
			page = 1,
			portrait = nil,
			pageLabel = nil,
			token = nil,
			hand = nil,
			arwLeft = nil,
			arwRight = nil,
			tokenObjective = { x = 0, y = 0 },
			tokenFollow = false,
			tokenFollowed = false,
			otherSelectors = otherSelectors,
			x = x or 0,
			y = y or 0
		}
		setmetatable(nt, mt)
		nt:baseNew()
		
		-- Listado.
		nt.roster = Roster.new("gfx/menu/slot.png", 9, 2, -2, -2, 2, 2) -- FighterSelect.
		nt.roster.prtOffsetX = 2; nt.roster.prtOffsetY = 2
		
		nt.roster:setPortraits(Select.fighter, nt.page)
		
		-- Botones.
		nt.arwLeft = Button.new(SL_ARW_SPR, nt.roster.x - SL_ARW_SPR.width, nt.roster.y)
		nt.arwRight = Button.new(SR_ARW_SPR, nt.roster.x + nt.roster.width, nt.roster.y)
		
		function nt.arwLeft:selectAction()
			if (nt.page > 0) then nt.page = nt.page - 1 end
			if (nt.page < 1) then nt.page = #Select.fighter end
			
			nt.roster:setPortraits(Select.fighter, nt.page)
			nt:checkTokenPosition()
		end
		
		function nt.arwRight:selectAction()
			if (nt.page < #Select.fighter) then nt.page = nt.page + 1
			else nt.page = 1 end
			
			nt.roster:setPortraits(Select.fighter, nt.page)
			nt:checkTokenPosition()
		end
		
		
		-- Marco.
		nt.portrait = Portrait.new(PRT_SPR)
		nt.portrait.imageIndex = PID
		
		-- Pagina.
		nt.pageLabel = Sprite.new("gfx/menu/pagelbl.png")
		
		-- Token.
		nt.token = Sprite.new("gfx/menu/tokens.png")
		nt.token:createGrid(4)
		nt.token.imageOriginX = nt.token.width/2
		nt.token.imageOriginY = nt.token.height/2
		nt.token.x = x + 6
		nt.token.y = y - 66
		nt.token.imageIndex = PID
		nt.token.depth = 1
		
		-- Mano.
		nt.hand = PlayerPointer.new(HAND_SPR, (PID+PID)-1, PID)
		nt.hand.x = x + 6
		nt.hand.y = y - 66
		nt.hand.visible = false
		nt.hand.depth = 1
		nt.hand:setECB(HAND_SPR.imageOriginX, HAND_SPR.imageOriginY, HAND_SPR.width * 0.7, HAND_SPR.height * 0.7)
		
		nt:update()
		
		return nt
	end
}
