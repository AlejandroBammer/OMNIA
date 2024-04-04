local Viewport = require("Viewport")

local Mouse = {
	leftClickHBP = false
}

function Mouse.getX()
    return love.mouse.getX()/Viewport.scaleX - Viewport.x/Viewport.scaleX
end

function Mouse.getY()
    return love.mouse.getY()/Viewport.scaleY - Viewport.y/Viewport.scaleY
end

function Mouse.getLeftClickHold()
	return love.mouse.isDown(1)
end

function Mouse.getLeftClick()
	local v = false
	
	local leftClick = love.mouse.isDown(1)
	
	if (leftClick and not Mouse.leftClickHBP) then
		v = true
		Mouse.leftClickHBP = true
	end
	
	if (not leftClick and Mouse.leftClickHBP) then
		Mouse.leftClickHBP = false
	end
	
	return v
end

return Mouse
