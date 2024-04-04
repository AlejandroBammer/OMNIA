local mt = {
id = 0,
depth = 0
}
mt.__index = mt


function mt:update() end


function mt:draw() end


return mt
