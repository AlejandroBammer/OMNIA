local GameState = require("GameState")
local Viewport = require("Viewport")
local Sprite = require("Sprite")
local Bounds = require("Bounds")
local Input = require("Input")
local Mouse = require("Mouse")
local Button = require("game objects/Button")

local mt = {}
mt.__index = mt
setmetatable(mt, GameState)


function mt:update()
	self:baseUpdate()
	
	
	if (Input.get(1, "right")) then
		self.button.x = self.button.x + 2
	end
	
	if (Input.get(1, "left")) then
		self.button.x = self.button.x - 2
	end
	
	if (Input.get(1, "down")) then
		self.button.y = self.button.y + 2
	end
	
	if (Input.get(1, "up")) then
		self.button.y = self.button.y - 2
	end
	
	
	local bMouse = Bounds.new(Mouse.getX(), Mouse.getY(), 1, 1)
	
	self.button:getSpriteBounds().color = { 1, 0, 0 }
	if (bMouse:intersects(self.button:getSpriteBounds())) then
		self.button:getSpriteBounds().color = { 0, 0, 1 }
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
		
		--[[
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
		btnSprite.imageOriginX = btnSprite.width/2
		btnSprite.imageOriginY = btnSprite.height/2
		btnSprite:setBounds(Bounds.new(15, 0, 196, 32))
		btnSprite:addBounds(Bounds.new(0, 0, 14, 32))
		btnSprite:setBounds(Bounds.new(15, 0, 225, 32), 2)
		btnSprite:addBounds(Bounds.new(241, 0, 32, 60), 2)
		
		
		-- Botones.
		nt.button = Button.new(btnSprite)
		nt.button.x = Viewport.width/2
		nt.button.y = Viewport.height/2
		
		nt.scene:add(nt.button)
		
		
		return nt
	end
}
