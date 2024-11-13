local GameState = require("GameState")
local Viewport = require("Viewport")
local Sprite = require("Sprite")
local Bounds = require("Bounds")
local Input = require("Input")
local Mouse = require("Mouse")
local Button = require("game objects/Button")
local Spritefont = require("Spritefont")
local GameStateManager = require("GameStateManager")


local unknownFont2 = Spritefont.new("gfx/unknownS2.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZ",  1, { 77/255, 77/255, 77/255, 1 })
unknownFont2.imageBlend = { 82/255, 29/255, 182/255 }


local mt = {}
mt.__index = mt
setmetatable(mt, GameState)


function mt:update()
	self:baseUpdate()
	
	if (Input.get(1, "down")) then self.btn.y = self.btn.y + 3 end
	if (Input.get(1, "right")) then self.btn.x = self.btn.x + 3 end
	if (Input.get(1, "up")) then self.btn.y = self.btn.y - 3 end
	if (Input.get(1, "left")) then self.btn.x = self.btn.x - 3 end
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
		
		-- [[
		--- Fondo ---
		nt.scene:add(Sprite.new("gfx/menu/background1.png"))
		
		
		--- Título ---
		local paint = Sprite.new("gfx/menu/paint.png")
		paint.x = Viewport.width/2 - paint.width/2
		paint.y = 9
		
		nt.scene:add(paint)
		
		
		local OMNIACreatePos = function(pX, pY, ib)
			local sprite = Sprite.new("gfx/menu/OMNIAOMNIA.png")
			sprite:createGrid(2)
			sprite.x = Viewport.width/2 - sprite.width/2 + (pX or 0)
			sprite.y = 9 + (pY or 0)
			sprite.imageSpeed = 0.5
			sprite.imageBlend = ib or { 155/255, 255/255, 0 }
			
			nt.scene:add(sprite)
		end
		
		
		OMNIACreatePos(4, 0, { 82/255, 29/255, 182 })
		OMNIACreatePos(-4, 0, { 82/255, 29/255, 182 })
		OMNIACreatePos(0, 4, { 82/255, 29/255, 182 })
		OMNIACreatePos(0, -4, { 82/255, 29/255, 182 })
		
		
		OMNIACreatePos()
		--]]
		
		
		local btnSprite = Sprite.new("gfx/menu/button.png")
		btnSprite:createGrid(2)
		btnSprite:setBounds(Bounds.new(15, 0, 196, 32))
		
		
		--- Botones ---
		-- Versus.
		local button = Button.new(btnSprite); button.x = 15; button.y = 80; button.font = unknownFont2
		button.text = "VERSUS"
		button.textYOffset = -2
		nt.btn = button
		
		function button:selectAction() GameStateManager.setCurrent("FighterSelect") end
		
		nt.scene:add(button)
		
		-- Training
		local button = Button.new(btnSprite); button.x = 15; button.y = 128; button.font = unknownFont2
		button.text = "TRAINING"
		button.textYOffset = -2
		
		function button:selectAction() GameStateManager.setCurrent("FighterSelect") end
		
		nt.scene:add(button)
		
		-- Controles.
		local button = Button.new(btnSprite); button.x = 15; button.y = 176; button.font = unknownFont2
		button.text = "CONTROLES"
		button.textYOffset = -2
		
		function button:selectAction() GameStateManager.setCurrent("ControlConfig") end
		
		nt.scene:add(button)
		
		
		return nt
	end
}
