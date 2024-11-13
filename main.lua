local GameStateManager = require("GameStateManager")
local Viewport = require("Viewport")
local FPS      = require("FPS")
local Global   = require("Global")
local Input    = require("Input")

math.randomseed(os.time())

function love.load()
    -- Configuración gráfica.
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setLineStyle("rough")

    Global.font = love.graphics.newFont("FreePixel.ttf", 16)
    Global.font:setFilter("nearest", "nearest")

    FPS.set(60)
    Viewport.set(480, 270)
    Viewport.setBackgroundColor(0/255, 160/255, 220/255)
    

    -- Inputs.
    local controlsFileExists = love.filesystem.getInfo("controls.txt")
    
    if not (controlsFileExists) then
        Input.initialize()
    else
        Input.loadControls()
    end
    
    Input.load()
    

    -- Manejo de estados.
    GameStateManager.setCapacity(2)
    GameStateManager.push("Menu")
end

function love.update(dt)
    FPS.update()
    GameStateManager.peek():update()
end

function love.resize()
    Viewport.resize()
end

function love.keypressed(key, scancode, isrepeat)
    if (key == "f4") then
        love.window.setFullscreen(not love.window.getFullscreen())
        Viewport.resize()
    end

    -- Reinicia el juego.
    if (key == "f1") then
        -- love.event.quit("restart")
        -- Global.resetData()
        GameStateManager.push("Menu")
    end

    -- Salta al menú.
    if (key == "f2") then
        -- Global.resetData()
        GameStateManager.push("Play", "TestStage")
    end

    -- Gameplay.
    if (key == "f3") then
        
    end

    -- Activa el modo debug.
    if (key == "-") then
        Global.debug = not Global.debug
    end
end

function love.draw()
    FPS.draw()
    love.graphics.setFont(Global.font)

    Viewport.drawInit()

    GameStateManager.peek():draw()
	
	if (Global.debug) then
		love.graphics.print("FPS: " .. love.timer.getFPS())
	end

    Viewport.drawEnd()
end
