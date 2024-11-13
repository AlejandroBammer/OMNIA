local GameState = require("GameState")
local Sprite = require("Sprite")
local Palayer = require("game objects/Palayer")
local Collision = require("Collision")
local TiledMap = require("TiledMap")


local mt = {}
mt.__index = mt
setmetatable(mt, GameState)


function mt:draw()
	self:baseDraw()
	
	love.graphics.setColor(0, 1, 0, 0.5)
	for _, col in ipairs(self.scene.collision.items) do
		local a = col.area
		
		love.graphics.rectangle("fill", a.x, a.y, a.width, a.height)
	end
	love.graphics.setColor(1, 1, 1, 1)
end


return
{
	new = function()
		local nt = {}
		setmetatable(nt, mt)
		nt:baseNew()
		
		-- TestMap.
		local map = TiledMap.new("stage", "TestStage")
		nt.scene = map:toScene()
		
		return nt
	end
}
