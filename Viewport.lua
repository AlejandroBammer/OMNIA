local Viewport = {}
Viewport.canvas = nil
Viewport.x = 0
Viewport.y = 0
Viewport.width  = 0
Viewport.height = 0
Viewport.scaleX = 0
Viewport.scaleY = 0
Viewport.backgroundColor = { 0, 0, 0, 1 }


function Viewport.set(width, height, scaleX, scaleY)
    Viewport.width  = width
    Viewport.height = height
    Viewport.scaleX = scaleX
    Viewport.scaleY = scaleY
    Viewport.resize()
    
    if (Viewport.canvas ~= nil) then
		Viewport.canvas:release();
		Viewport.canvas = nil
    end
    
    Viewport.canvas = love.graphics.newCanvas(Viewport.width, Viewport.height)
    Viewport.canvas:setFilter("nearest", "nearest")
end

function Viewport.setBackgroundColor(r, g, b, a)
    Viewport.backgroundColor[1] = r or 0
    Viewport.backgroundColor[2] = g or 0
    Viewport.backgroundColor[3] = b or 0
    Viewport.backgroundColor[4] = a or 1
end

function Viewport.resize()
    local windowWidth  = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()

    local scaleX = 1 * windowHeight / Viewport.height
    local scaleY = 1 * windowHeight / Viewport.height

    local width  = scaleX * Viewport.width
    local height = scaleY * Viewport.height

    if (windowWidth < width) then
        scaleX = 1 * windowWidth / Viewport.width
        scaleY = 1 * windowWidth / Viewport.width

        width  = scaleX * Viewport.width
        height = scaleY * Viewport.height
    end

    Viewport.x = (windowWidth  - width)  / 2
    Viewport.y = (windowHeight - height) / 2
    
    Viewport.scaleX = scaleX
    Viewport.scaleY = scaleY
end

function Viewport.drawInit()
    love.graphics.setCanvas(Viewport.canvas)
    love.graphics.clear(
        Viewport.backgroundColor[1],
        Viewport.backgroundColor[2],
        Viewport.backgroundColor[3],
        Viewport.backgroundColor[4])
end

function Viewport.drawEnd()
    love.graphics.setCanvas()
    love.graphics.draw(Viewport.canvas, Viewport.x, Viewport.y, 0, Viewport.scaleX, Viewport.scaleY)
end

return Viewport
