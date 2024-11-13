local GameObject = require("GameObject")

local mt = {}
mt.__index = mt
setmetatable(mt, GameObject)


function mt:update()
    self:baseUpdate()
end


function mt:draw()
    self:baseDraw()
end


return {
    new = function(x, y)
        local nt = {
            x = x or 0,
            y = y or 0
        }
        setmetatable(nt, mt)
        nt:baseNew()

        return nt
    end
}
