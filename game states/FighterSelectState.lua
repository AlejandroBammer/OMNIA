local GameState = require("GameState")
local Roster = require("game objects/Roster")
local Global = require("Global")
local Sprite = require("Sprite")
local Button = require("game objects/Button")
local FighterSelector = require("game objects/FighterSelector")
local Viewport = require("Viewport")
local GameStateManager = require("GameStateManager")
local Rectangle = require("Rectangle")
local Mouse = require("Mouse")
local Input = require("Input")

local SL_ARW_SPR = Sprite.new("gfx/menu/select arrow right.png")
SL_ARW_SPR:createGrid(2)

local SR_ARW_SPR = Sprite.new("gfx/menu/select arrow left.png")
SR_ARW_SPR:createGrid(2)


local mt = {}
mt.__index = mt
setmetatable(mt, GameState)


function mt:update()	
	---  Mouse  ---
	self.mousePos.x = Mouse:getX()
	self.mousePos.y = Mouse:getY()
	
	local rMouse = Rectangle.new(self.mousePos.x, self.mousePos.y, 1, 1)
	
	for i = 1, #self.fighterSelectors, 1 do
		local fsel = self.fighterSelectors[i]
		local token = fsel.token
		
		if (not fsel.tokenFollow and token:getRect():intersects(rMouse) and Mouse:getLeftClick()) then
			fsel.tokenObjective = self.mousePos
			fsel.tokenFollow = true
			self.mouseFSToken = fsel
		end
	end
	
	if (self.mouseFSToken ~= nil and self.mouseFSToken.tokenObjective == self.mousePos and not Mouse:getLeftClickHold()) then
		self.mouseFSToken.tokenFollow = false
		self.mouseFSToken = nil
	end
	
	
	self:baseUpdate()
	
	
	---  Entrar a la selección de escenario  ---
	if (Input.pauseGet()) then
		local playersReady = 0
		
		for _, fs in ipairs(self.fighterSelectors) do
			if (fs.portrait.sprite ~= nil) then
				playersReady = playersReady + 1
			end
		end
		
		if (playersReady > 1) then
			GameStateManager.push("StageSelect")
		end
	end
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
		
		Viewport.setBackgroundColor(131/255, 13/255, 75/255)
		nt.scene:add(Sprite.new("gfx/menu/bar.png", 2, 2))
		
		-- Regresar.
		local backSpr = Sprite.new("gfx/menu/back.png")
		backSpr:createGrid(2)
		
		local backBtn = Button.new(backSpr) backBtn.x = 9; backBtn.y = 4
		function backBtn:selectAction()
			GameStateManager.pop()
		end
		
		nt.scene:add(backBtn)
		
		-- Selectores.
		nt.fighterSelectors = {
			FighterSelector.new(1, 42, 103),
			FighterSelector.new(2, 283, 103),
			FighterSelector.new(3, 42, 224),
			FighterSelector.new(4, 283, 224)
		}
		for _, fsel in ipairs(nt.fighterSelectors) do nt.scene:add(fsel) end
		for _, fsel in ipairs(nt.fighterSelectors) do fsel:init(nt.fighterSelectors) end -- Esto se tiene que hacer en una segunda iteración.
		
		---  Hacer  ---
		-- [ ] Dividir el módulo select en 2 (cómo era antes).
		-- [ ] Hacer que las columnas y filas de los listados sean definidos por el módulo FighterSelect.
		
		return nt
	end
}
