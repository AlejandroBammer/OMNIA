local GameState = require("GameState")
local Roster = require("game objects/Roster")
local Global = require("Global")
local Select = require("data/Select")
local Sprite = require("Sprite")
local Button = require("game objects/Button")
local FighterSelector = require("game objects/FighterSelector")
local FFighterSelector = require("game objects/FFighterSelector")
local Viewport = require("Viewport")
local GameStateManager = require("GameStateManager")
local Rectangle = require("Rectangle")
local Mouse = require("Mouse")
-- local PlayerPointer = require("game objects/PlayerPointer")

local SL_ARW_SPR = Sprite.new("gfx/menu/sl-arw.png")
SL_ARW_SPR:createGrid(2)

local SR_ARW_SPR = Sprite.new("gfx/menu/sr-arw.png")
SR_ARW_SPR:createGrid(2)


local mt = {}
mt.__index = mt
setmetatable(mt, GameState)


function mt:update()
	---  Mouse  ---
	--[[
	self.mousePos.x = Mouse:getX()
	self.mousePos.y = Mouse:getY()
	
	local rMouse = Rectangle.new(self.mousePos.x, self.mousePos.y, 1, 1)
	
	for i = 1, #self.fighterSelectors, 1 do
		local fsel = self.fighterSelectors[i]
		local token = fsel.token
		
		if (token:getRect():intersects(rMouse) and Mouse:getLeftClick()) then
			fsel.tokenObjective = self.mousePos
			fsel.tokenFollow = true
			self.mouseFSToken = fsel
		end
	end
	
	if (self.mouseFSToken ~= nil and not Mouse:getLeftClickHold()) then
		self.mouseFSToken.tokenFollow = false
		self.mouseFSToken = nil
	end
	--]]

	self:baseUpdate()
end


return
{
	new = function()
		local nt = {
			mousePos = { x = 0, y = 0 },
			mouseFSToken = nil,
			fighterSelectors = {}
		}
		setmetatable(nt, mt)
		nt:baseNew()
		require("Viewport").setBackgroundColor(131/255, 13/255, 75/255)
		
		Viewport.setBackgroundColor(131/255, 13/255, 75/255)
		nt.scene:add(Sprite.new("gfx/menu/bar.png", 2, 2))
		
		-- Regresar.
		local backSpr = Sprite.new("gfx/menu/back.png")
		backSpr:createGrid(2)
		
		local backBtn = Button.new(backSpr) backBtn.x = 9; backBtn.y = 4
		function backBtn:selectAction()
			GameStateManager.setCurrent("Menu")
		end
		
		nt.scene:add(backBtn)
		
		-- Selectores.
		nt.fighterSelectors[1] = FFighterSelector.new(1, 42, 103)
		nt.fighterSelectors[2] = FFighterSelector.new(2, 283, 103)
		nt.fighterSelectors[3] = FFighterSelector.new(3, 32, 224)
		nt.fighterSelectors[4] = FFighterSelector.new(4, 283, 224)
		
		for _, fsel in ipairs(nt.fighterSelectors) do
			nt.scene:add(fsel)
			fsel:shitLoad()
			--[[
			nt.scene:add(fsel.arwLeft)
			nt.scene:add(fsel.arwRight)
			nt.scene:add(fsel.token)
			nt.scene:add(fsel.hand)
			--]]
		end
		
		--[[
		local HAND_SPR = Sprite.new("gfx/menu/hands.png")
		HAND_SPR:createGrid(8)
		HAND_SPR.imageOriginX = HAND_SPR.width/2
		HAND_SPR.imageOriginY = HAND_SPR.height/2
		
		nt.hand = require("game objects/PlayerPointer").new(HAND_SPR, 1, 1)
		nt.hand.x = 60
		nt.hand.y = 60
		-- nt.hand.visible = false
		nt.hand.depth = 1
		nt.hand:setECB(HAND_SPR.imageOriginX, HAND_SPR.imageOriginY, HAND_SPR.width * 0.7, HAND_SPR.height * 0.7)
		nt.scene:add(nt.hand)
		--]]
		
		---  Hacer  ---
		-- [ ] Dividir el módulo select en 2 (cómo era antes).
		-- [ ] Hacer que las columnas y filas de los listados sean definidos por el módulo FighterSelect.
		
		return nt
	end
}
