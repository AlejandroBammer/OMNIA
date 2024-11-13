local GameState = require("GameState")
local Sprite = require("Sprite")
local Palayer = require("game objects/Palayer")


local mt = {}
mt.__index = mt
setmetatable(mt, GameState)

return
{
	new = function()
		local nt = {
			palayer = Palayer.new(42, 63)
		}
		setmetatable(nt, mt)
		nt:baseNew()
		
		nt.scene:add(nt.palayer)
		
		local sprite = Sprite.new("gfx/Weabo.png", 63, 63)
		sprite.imageOriginX = sprite.width/2
		sprite.imageOriginY = sprite.height
		sprite.depth = sprite.y
		sprite.imageBlend = { 1, 0, 0 }
		
		nt.scene:add(sprite)
		
		
		return nt
	end
}
