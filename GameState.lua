local List = require("List")
local Scene = require("Scene")
local Global = require("Global")

local PRECISION = 0.0001


local mt = {
	name = ""
}
mt.__index = mt


local function sortByDepth(a, b)
	aDepth = a.depth + a.dId * PRECISION
	bDepth = b.depth + b.dId * PRECISION
	
	return aDepth < bDepth
end


function mt:baseNew()
    self.scene = Scene.new()
end


function mt:enter()
end


function mt:baseUpdate()
	self.scene:update()
end

function mt:update() self:baseUpdate() end


function mt:baseDraw()
	self.scene:draw()
end

function mt:draw() self:baseDraw() end


function mt:exit()
end


return mt
