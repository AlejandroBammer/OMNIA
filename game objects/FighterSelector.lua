local GameStateManager = require("GameStateManager")
local GameObject = require("GameObject")
local Rectangle = require("Rectangle")
local Portrait = require("game objects/Portrait")
local Roster = require("game objects/Roster")
local Button = require("game objects/Button")
local Sprite = require("Sprite")
local FighterSelect = require("data/FighterSelect")
local Utils = require("Utils")
local PlayerPointer = require("game objects/PlayerPointer")
local Input = require("Input")

local INTELBTN_SPR = Sprite.new("gfx/menu/intel-btn.png")
INTELBTN_SPR:createGrid(3)

local ARWR_SPR = Sprite.new("gfx/menu/select arrow right.png")
ARWR_SPR:createGrid(2)

local ARWL_SPR = Sprite.new("gfx/menu/select arrow left.png")
ARWL_SPR:createGrid(2)

local PRT_SPR = Sprite.new("gfx/menu/portraits.png")
PRT_SPR:createGrid(4)

local HAND_SPR = Sprite.new("gfx/menu/hands.png")
HAND_SPR:createGrid(8)
HAND_SPR.originX = HAND_SPR.width/2
HAND_SPR.originY = HAND_SPR.height/2


local mt = {}
mt.__index = mt
setmetatable(mt, GameObject)


function mt:checkTokenPosition()
	local rToken = Rectangle.new(self.token.x, self.token.y, 1, 1)
			
	---  Selección  ---
	self.portrait.sprite = nil
	for _, fsel in ipairs(self.selectors) do -- Permite seleccionar personajes de otros selectores :p.
		for _, slot in ipairs(fsel.roster.slotList.items) do
			if (rToken:intersects(slot:getECB())) then
				if (slot.name ~= "") then
					self.portrait.sprite = Sprite.new("fighter/" .. slot.name .. "/images/2.png")
				end
			end
		end
	end
end


function mt:setPositions()
	self.roster.x = self.x
	self.roster.y = self.y
	self.roster:update()
	
	self.intelBtn.x = self.x + PRT_SPR.width - INTELBTN_SPR.width - 3
	self.intelBtn.y = self.y - INTELBTN_SPR.height
	
	self.arwLeftBtn.x = self.roster.x - ARWR_SPR.width
	self.arwLeftBtn.y = self.y
	
	self.arwRightBtn.x = self.roster.x + self.roster.width
	self.arwRightBtn.y = self.y
	
	self.portrait.x = self.x
	self.portrait.y = self.y - PRT_SPR.height
	
	self.pageLabel.x = self.x + 74
	self.pageLabel.y = self.y - self.pageLabel.height
end


function mt:update()
	self:baseUpdate()
	
	self:setPositions()
	
	---  Inputs de la mano  ---
	if (not self.hand.visible) then
		local anyMove =
			(Input.getPress(self.PID, "down") or
			Input.getPress(self.PID, "right") or
			Input.getPress(self.PID, "up") or
			Input.getPress(self.PID, "left"))
		
		if (anyMove) then
			self.hand.visible = true
		end
	end
	
	if (Input.getPress(self.PID, "attack")) then
		-- Seleccionar.
		if (not self.hand.grabbing) then
			self.hand.select = true
		end
		
		for _, fsel in ipairs(self.selectors) do
			if (not self.hand.grabbing and not fsel.tokenFollow) then
				-- Tomar token.
				if (fsel.token:getRect():intersects(self.hand:getECB())) then
					fsel.tokenObjective = self.hand
					fsel.tokenFollow = true
					self.hand.grabbing = true
				end
			else
				-- Dejar token.
				if (self.hand.grabbing and fsel.tokenFollow and fsel.tokenObjective == self.hand) then
					fsel.tokenObjective = nil
					fsel.tokenFollow = false
					self.hand.grabbing = false
				end
			end
		end
	end
	
	if (Input.getPress(self.PID, "special") and self.hand.visible) then
		self.tokenObjective = self.hand
		self.tokenFollow = true
		self.hand.grabbing = true
	end
	
	
	---  Selección con token  ---
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
	totalPages = string.sub(totalPages, 0, string.len(totalPages)-string.len(#FighterSelect.data))
	totalPages = totalPages .. #FighterSelect.data
	
	Utils.unknownFont:print(curPage .. "/" .. totalPages, x, y)
end


function mt:init(selectors)
	self.selectors = selectors
	self.scene:add(self.hand)
end


function mt:onAdd()
	self.scene:add(self.intelBtn)
	self.scene:add(self.arwLeftBtn)
	self.scene:add(self.arwRightBtn)
	self.scene:add(self.token)
end


return
{
	new = function(PID, x, y)
		local nt = {
			PID = PID,
			page = 1,
			portrait = nil,
			pageLabel = nil,
			token = nil,
			hand = nil,
			arwLeftBtn = nil,
			arwRightBtn = nil,
			tokenObjective = { x = 0, y = 0 },
			tokenFollow = false,
			tokenFollowed = false,
			selectors = nil,
			x = x or 0,
			y = y or 0
		}
		setmetatable(nt, mt)
		nt:baseNew()
		
		-- Marco.
		nt.portrait = Portrait.new(PRT_SPR)
		nt.portrait.imageIndex = PID
		
		-- Listado.
		nt.roster = Roster.new("gfx/menu/slot.png", FighterSelect.columns, FighterSelect.rows, -2, -2, 2, 2) -- FighterSelect.
		nt.roster.prtOffsetX = 2; nt.roster.prtOffsetY = 2
		
		nt.roster:setPortraits(FighterSelect.data, nt.page, "fighter", "images/1.png")
		
		-- Botones.
		nt.arwLeftBtn = Button.new(ARWR_SPR, nt.roster.x - ARWR_SPR.width, nt.roster.y)
		nt.arwRightBtn = Button.new(ARWL_SPR, nt.roster.x + nt.roster.width, nt.roster.y)
		
		function nt.arwLeftBtn:selectAction()
			if (nt.page > 0) then nt.page = nt.page - 1 end
			if (nt.page < 1) then nt.page = #FighterSelect.data end
			
			nt.roster:setPortraits(FighterSelect.data, nt.page, "fighter", "images/1.png")
			nt:checkTokenPosition()
		end
		
		function nt.arwRightBtn:selectAction()
			if (nt.page < #FighterSelect.data) then nt.page = nt.page + 1
			else nt.page = 1 end
			
			nt.roster:setPortraits(FighterSelect.data, nt.page, "fighter", "images/1.png")
			nt:checkTokenPosition()
		end
		
		nt.intelBtn = Button.new(INTELBTN_SPR)
		nt.intelBtn.imageChange = false
		
		function nt.intelBtn:selectAction()
			self.imageIndex = self.imageIndex + 1
			
			if (self.imageIndex > INTELBTN_SPR.imageNumber) then
				self.imageIndex = 1
			end
		end
		
		-- Pagina.
		nt.pageLabel = Sprite.new("gfx/menu/page label.png")
		
		-- Token.
		nt.token = Sprite.new("gfx/menu/tokens.png")
		nt.token:createGrid(4)
		nt.token.originX = nt.token.width/2
		nt.token.originY = nt.token.height/2
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
		nt.hand:setECB(HAND_SPR.originX, HAND_SPR.originY, HAND_SPR.width * 0.7, HAND_SPR.height * 0.7)
		
		nt:setPositions()
		
		return nt
	end
}
