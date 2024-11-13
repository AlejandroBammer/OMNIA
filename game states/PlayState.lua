local GameState = require("GameState")
local Sprite = require("Sprite")
local Palayer = require("game objects/Palayer")
local Collision = require("Collision")
local TiledMap = require("TiledMap")
local Global = require("Global")


local mt = {}
mt.__index = mt
setmetatable(mt, GameState)


function mt:draw()
	self:baseDraw()
	
	if (Global.debug) then
		love.graphics.setColor(0, 1, 0, 0.5)
		for _, col in ipairs(self.scene.collision.items) do
			local a = col.area
			
			love.graphics.rectangle("fill", a.x, a.y, a.width, a.height)
		end
		love.graphics.setColor(1, 1, 1, 1)
	end
end


return
{
	new = function(stageName)
		local nt = {}
		setmetatable(nt, mt)
		nt:baseNew()
		
		require("Viewport").setBackgroundColor(0/255, 160/255, 220/255)
		
		-- Stage.
		local stage = TiledMap.new("stage", stageName)
		nt.scene = stage:toScene()
		
		return nt
	end
}
