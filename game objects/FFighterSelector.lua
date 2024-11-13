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


local mt = {}
mt.__index = mt
setmetatable(mt, GameObject)


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


function mt:update()
	self:baseUpdate()
	
	if (not self.set) then
		self.set = true
		
		-- self.scene:add(self.hand)
		-- self:shitLoad()
	end
end


function mt:shitLoad()
	-- Listado.
	self.roster = Roster.new("gfx/menu/slot.png", 9, 2, -2, -2, 2, 2) -- FighterSelect.
	self.roster.prtOffsetX = 2; self.roster.prtOffsetY = 2
	
	self.roster:setPortraits(Select.fighter, self.page)
	
	-- [[
	-- Botones.
	self.arwLeft = Button.new(SL_ARW_SPR, self.x, self.y)
	self.arwRight = Button.new(SR_ARW_SPR, self.x, self.y)
	
	function self.arwLeft:selectAction()
		if (self.page > 0) then self.page = self.page - 1 end
		if (self.page < 1) then self.page = #Select.fighter end
		
		self.roster:setPortraits(Select.fighter, self.page)
		-- self:checkTokenPosition()
	end
	
	function self.arwRight:selectAction()
		if (self.page < #Select.fighter) then self.page = self.page + 1
		else self.page = 1 end
		
		self.roster:setPortraits(Select.fighter, self.page)
		-- self:checkTokenPosition()
	end
	
	-- Token.
	self.token = Sprite.new("gfx/menu/tokens.png")
	self.token:createGrid(4)
	self.token.imageOriginX = self.token.width/2
	self.token.imageOriginY = self.token.height/2
	self.token.x = self.x + 6
	self.token.y = self.y - 66
	self.token.imageIndex = self.PID
	self.token.depth = 1
	
	-- Mano.
	self.hand = PlayerPointer.new(HAND_SPR, (self.PID+self.PID)-1, self.PID)
	self.hand.x = self.x + 6
	self.hand.y = self.y - 66
	-- self.hand.visible = false
	self.hand.depth = 1
	self.hand:setECB(HAND_SPR.imageOriginX, HAND_SPR.imageOriginY, HAND_SPR.width * 0.7, HAND_SPR.height * 0.7)
	--]]
	
	self.scene:add(self.arwLeft)
	self.scene:add(self.arwRight)
	self.scene:add(self.token)
	-- self.scene:add(self.hand)
end


return
{
	new = function(PID, x, y)
		local nt = {
			PID = PID,
			page = 1,
			x = x,
			y = y,
		}
		setmetatable(nt, mt)
		nt:baseNew()
		
		return nt
	end
}
