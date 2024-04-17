local GameState = require("GameState")
local Global = require("Global")
local Viewport = require("Viewport")
local Sprite = require("Sprite")
local Button = require("game objects/Button")
local Portrait = require("game objects/Portrait")
local PlayerPointer = require("game objects/PlayerPointer")
local GameStateManager = require("GameStateManager")
local Spritefont = require("Spritefont")
local Select = require("data/Select")
local Input = require("Input")
local Mouse = require("Mouse")
local Rectangle = require("Rectangle")

------   Constantes   ------
--- Variables ---
local SLOT_ROWS = 2
local SLOT_COLUMNS = 9
local HAND_SPD = 3


--- Fuentes ---
local unknownFont = Spritefont.new("gfx/unknown.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.,:/", 1, { 38/255, 38/255, 38/255, 255/255 })


---  Sprites  ---
local PL_ARW_SPR = Sprite.new("gfx/menu/pl-arw.png")
PL_ARW_SPR:createGrid(2)

local PR_ARW_SPR = Sprite.new("gfx/menu/pr-arw.png")
PR_ARW_SPR:createGrid(2)

local IT_BTN_SPR = Sprite.new("gfx/menu/it-btn.png")
IT_BTN_SPR:createGrid(3)

local HAND_SPR = Sprite.new("gfx/menu/hands.png")
HAND_SPR:createGrid(8)
HAND_SPR.imageOriginX = HAND_SPR.width/2
HAND_SPR.imageOriginY = HAND_SPR.height/2



local mt = {}
mt.__index = mt
setmetatable(mt, GameState)


function mt:update()
	self:baseUpdate();
	
	self.rMouse.x = Mouse.getX()
	self.rMouse.y = Mouse.getY()
	
	
	---  Manos  ---
	for i, hand in ipairs(self.playersHands) do
		local anyMovement = Input.get(i, "down") or Input.get(i, "right") or Input.get(i, "up") or Input.get(i, "left")
		local token = self.playersTokens[i]
		
		if (anyMovement and not hand.visible) then
			hand.visible = true
			self.playersPageChangers[i][1].ownerPI = i
			self.playersPageChangers[i][2].ownerPI = i
		end
	
		if (hand.visible) then
			hand:update()
			
			if (Input.get(i, "down")) then hand.y = hand.y + HAND_SPD end
			if (Input.get(i, "right")) then hand.x = hand.x + HAND_SPD end
			if (Input.get(i, "up")) then hand.y = hand.y - HAND_SPD end
			if (Input.get(i, "left")) then hand.x = hand.x - HAND_SPD end
			
			if (hand.x < 0) then hand.x = 0 end
			if (hand.x > Viewport.width) then hand.x = Viewport.width end
			if (hand.y < 0) then hand.y = 0 end
			if (hand.y > Viewport.height) then hand.y = Viewport.height end
			
			
			if (Input.get(i, "attack") and not self._iAttackHBP[i]) then
				hand.select = true
			
				for _, otherToken in ipairs(self.playersTokens) do
					if (otherToken.objetive == hand and otherToken.follow) then
						hand.select = false
						otherToken.objetive = nil
						otherToken.follow = false
					else
						if (hand:getSpriteBounds():intersects(otherToken:getBounds())) then
							hand.select = false
							otherToken.follow = true
							otherToken.objetive = hand
						end
					end
				end
			end
			self._iAttackHBP[i] = Input.get(i, "attack")
			
			
			if (Input.get(i, "special")) then
				token.follow = true
				token.objetive = hand
			end
		end
	end
	
	
	---  Portraits  ---
	for _, portrait in ipairs(self.playersPortraits) do
		portrait.sprite = nil
	end
	
	---  Slots  ---
	for pi = 1, Global.fighterNum do
		for j = 0, SLOT_ROWS-1 do
			for i = 0, SLOT_COLUMNS-1 do
				local slot = self.playersSlots[pi][i+SLOT_COLUMNS*(j-1)]
				local page = self.playersPages[pi]
				slot.sprite = nil
				slot.name = ""
				
				
				local fighter = Select.fighter[page][i+1+SLOT_COLUMNS*(j)]
				
				if (fighter ~= "empty") then
					slot.sprite = Sprite.new("fighter/" .. fighter .. "/images/" .. "1.png")
					slot.name = fighter
					
					for i, token in ipairs(self.playersTokens) do
						if (not token.follow and Rectangle.new(token.x, token.y, 1, 1):intersects(slot:getSpriteBounds():getArea())) then
							self.playersPortraits[i].sprite = Sprite.new("fighter/" .. fighter .. "/images/" .. "2.png")
						end
					end
				end
			end
		end
	end
	
	
	---  Fichas  ---
	for i, token in ipairs(self.playersTokens) do
		if (token:getBounds():getArea():intersects(self.rMouse)) then
			if (Mouse.getLeftClick() and not token.follow) then
				token.objetive = self.rMouse; token.follow = true
			end
		end
		
		if (token.objetive == self.rMouse and not Mouse.getLeftClickHold()) then token.follow = false; token.objetive = nil end
		
		
		if (token.follow and token.objetive ~= nil) then
			token.x = token.objetive.x
			token.y = token.objetive.y
			
			for _, hand in ipairs(self.playersHands) do
				if (token.objetive == hand) then hand.imageIndex = hand.firstImageIndex + 1 end
			end
		end
	end
end


function mt:draw()
	self:baseDraw();
	
	-- Indice de página.
	for i = 1, Global.fighterNum do
		for j = 1, #Select.fighter do
			local x = self.playersSlotsPos[i].x + 64
			local y = self.playersSlotsPos[i].y - 8
			
			local curPage = "00"
			curPage = string.sub(curPage, 0, string.len(curPage) - string.len(tostring(self.playersPages[i])))
			curPage = curPage .. self.playersPages[i]
			
			local totalPages = "00"
			totalPages = string.sub(totalPages, 0, string.len(totalPages)-string.len(#Select.fighter))
			totalPages = totalPages .. #Select.fighter
			
			unknownFont:print(curPage .. "/" .. totalPages, x, y)
		end
	end
	
	-- Slots de cada página actual.
	-- Tokens.
	for i, token in ipairs(self.playersTokens) do token:draw() end
	
	-- Manos.
	for _, hand in ipairs(self.playersHands) do if (hand.visible) then hand:draw() end end
end


function mt:createPlayerSelector(PI, x, y)
	local slotSpr
	
	---  Slots  --
	for j = 0, SLOT_ROWS-1 do
		for i = 0, SLOT_COLUMNS-1 do
			slotSpr = Sprite.new("gfx/menu/slot.png")
			
			local slot = Portrait.new(slotSpr)
			slot.x = x + (i * (slotSpr.width-2))
			slot.y = y + (j * (slotSpr.height-2))
			slot.spriteXOffset = 2
			slot.spriteYOffset = 2
			self.playersSlots[PI][i+SLOT_COLUMNS*(j-1)] = slot
			
			
			self.scene:add(slot)
		end
	end
	
	local slotsWidth = (slotSpr.width-2)*9+2
	
	
	---  Felchas  ---
	local plArw = Button.new(PL_ARW_SPR); plArw.x = x - PL_ARW_SPR.width; plArw.y = y
	plArw.type = "pageChanger"
	plArw.ownerPI = 0
	self.scene:add(plArw)
	self.playersPageChangers[PI][1] = plArw
	
	function plArw:selectAction() -- Se podría usar "self" si se remplaza ":" por "."
		this = GameStateManager.getCurrent()
	
		this.playersPages[PI] = this.playersPages[PI] > 1 and this.playersPages[PI] - 1 or #Select.fighter
	end
	
	local prArw = Button.new(PR_ARW_SPR); prArw.x = x + slotsWidth; prArw.y = y
	prArw.type = "pageChanger"
	prArw.ownerPI = 0
	self.scene:add(prArw)
	self.playersPageChangers[PI][2] = prArw
	
	function prArw:selectAction()
		this = GameStateManager.getCurrent()
	
		this.playersPages[PI] = this.playersPages[PI] < #Select.fighter and this.playersPages[PI] + 1 or 1
	end
	
	
	--- Marcos  ---
	local portraitSpr = Sprite.new("gfx/menu/portraits.png")
	portraitSpr:createGrid(4)
	
	portrait = Portrait.new(portraitSpr)
	portrait.imageIndex = PI
	portrait.x = x
	portrait.y = y - portraitSpr.height
	self.scene:add(portrait)
	self.playersPortraits[PI] = portrait
	
	local pageLblSpr = Sprite.new("gfx/menu/pagelbl.png")
	pageLblSpr.x = x + 61
	pageLblSpr.y = y - pageLblSpr.height
	
	self.scene:add(pageLblSpr)
	
	-- Botones de inteligencia --
	local itBtn = Button.new(IT_BTN_SPR)
	itBtn.imageChange = false
	itBtn.x = x + 19
	itBtn.y = y - IT_BTN_SPR.height + 2
	
	function itBtn:selectAction()
		self.imageIndex = self.imageIndex + 1
		
		if (self.imageIndex > self:getSprite().imageNumber) then
			self.imageIndex = 1
		end
	end
	
	itBtn.imageIndex = PI ~= 1 and 2 or 1
	self.scene:add(itBtn)
	
	-- Manos --
	local hand = PlayerPointer.new(HAND_SPR, (PI+PI)-1, PI)
	hand.x = x + 6
	hand.y = y - 66
	hand.visible = false
	hand:setBounds(require("Bounds").new(0, 0, HAND_SPR.width/2, HAND_SPR.height/2))
	self.playersHands[PI] = hand
	-- self.scene:add(hand)
	
	
	-- Tokens --
	local token = Sprite.new("gfx/menu/tokens.png")
	token:createGrid(4)
	token.imageOriginX = token.width/2
	token.imageOriginY = token.height/2
	token.x = x + 6
	token.y = y - 66
	token.imageIndex = PI
	token.follow = false
	token.objective = nil
	self.playersTokens[PI] = token
	
	
	self.playersSlotsPos[PI].x = x
	self.playersSlotsPos[PI].y = y
end


return
{
	new = function()
		local nt = {
			fighterSlots = {},
			playersPortraits = {},
			playersSlots = {},
			playersSlotsPos = {},
			playersHands = {},
			playersTokens = {},
			playersPageChangers = {},
			playersPages = {},
			rMouse = Rectangle.new(0, 0, 1, 1),
			_iAttackHBP = {}
		}
		setmetatable(nt, mt)
		nt:baseNew()
		
		for i = 1, Global.fighterNum do
			nt.playersSlots[i] = {}
			nt.playersSlotsPos[i] = { x = 0, y = 0}
			nt.fighterSlots[i] = {}
			nt.playersPages[i] = 1
			nt.playersPageChangers[i] = { nil, nil }
			nt._iAttackHBP[i] = false
		end
		
		
		Viewport.setBackgroundColor(131/255, 13/255, 75/255)
		nt.scene:add(Sprite.new("gfx/menu/bar.png", 2, 2))
		
		local backSpr = Sprite.new("gfx/menu/back.png")
		backSpr:createGrid(2)
		
		local backBtn = Button.new(backSpr) backBtn.x = 9; backBtn.y = 4
		function backBtn:selectAction()
			GameStateManager.setCurrent("Menu")
		end
		
		nt.scene:add(backBtn)
		
		
		nt:createPlayerSelector(1, 42, 103)
		nt:createPlayerSelector(2, 283, 103)
		nt:createPlayerSelector(3, 42, 224)
		nt:createPlayerSelector(4, 283, 224)
		
		
		return nt
	end
}
