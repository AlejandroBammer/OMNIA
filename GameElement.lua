local mt = {
id = 0,
class = "",
name = "",
type = "",
depth = 0,
visible = true
}
mt.__index = mt


function mt:update() end


function mt:draw() end


return mt
