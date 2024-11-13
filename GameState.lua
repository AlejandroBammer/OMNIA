local List = require("List")
local Scene = require("Scene")
local Global = require("Global")
local PRECISION = 0.0001

local mt =
{
	name = ""
}
mt.__index = mt


function mt:baseNew()
    self.scene = Scene.new()
end


function mt:baseUpdate()
	self.scene:update()
end

function mt:update() self:baseUpdate() end


function mt:baseDraw()
	self.scene:draw()
end

function mt:draw() self:baseDraw() end


return mt
