local mt = {
	id = -1,
	class = "",
	type = "",
	name = "",
	depth = 0,
	visible = true,
	destroy = false,
	scene = nil
}
mt.__index = mt


function mt:update() end


function mt:draw() end


function mt:instanceDestroy()
	if (self.scene == nil) then return end
	
	self.scene:remove(self)
end


return mt
