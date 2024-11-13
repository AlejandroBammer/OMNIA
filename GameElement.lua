local mt = {
	id = 0,
	class = "",
	type = "",
	name = "",
	x = 0,
	y = 0,
	depth = 0,
	displayId = 0,
	visible = true,
	removed = false,
	scene = nil
}
mt.__index = mt


function mt:onAdd() end

function mt:update() end

function mt:draw() end

function mt:onRemove() end


return mt
