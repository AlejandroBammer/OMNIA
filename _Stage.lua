local Global    = require("Global")
local Fighter   = require("Fighter")
local BlastZone = require("BlastZone")
local Collision = require("Collision")
local Sprite    = require("Sprite")
local Camera    = require("Camera")
local Rectangle = require("Rectangle")
local Background = require("Background")

local mt = {}
mt.__index = mt

return {
    new = function(stageName, gameState)
        local nt = {
            map     = require("stage/" .. stageName .. "/" .. stageName),
            sprites = require("stage/" .. stageName .. "/" .. "sprites")
        }
        setmetatable(nt, mt)

        if (Global.music) then Global.music:stop() end
        if (nt.map.properties.Music) then
            Global.setMusic(nt.map.properties.Music)
            Global.music:setLooping(true)
            Global.music:play()
        end

        local stageZone

        for _, layer in ipairs(nt.map.layers) do
            if (layer.name == "Bounds") then
                for _, obj in ipairs(layer.objects) do
                    if (obj.name == "BlastZone") then
                        gameState.scene:add(BlastZone.new(obj.x, obj.y, obj.width, obj.height))
                    end

                    if (obj.name == "Camera") then
                        Camera.bounds = Rectangle.new(obj.x, obj.y, obj.width, obj.height)
                    end

                    if (obj.name == "StageZone") then
                        stageZone = Rectangle.new(obj.x, obj.y, obj.width, obj.height)
                    end
                end
                break
            else
                goto continue
            end
            ::continue::
        end

        for _, layer in ipairs(nt.map.layers) do
            if (layer.name == "Collisions") then
                for _, obj in ipairs(layer.objects) do
                    gameState.scene:add(Collision.new(obj.x, obj.y, obj.width, obj.height, obj.properties.platform))
                end
            end

            if (layer.name == "Spawners") then
                local platformX
                local platformY

                for _, obj in ipairs(layer.objects) do
                    if (obj.name == "Platform") then
                        platformX = obj.x
                        platformY = obj.y
                    end
                end
                
                for i = #Global.fighters, 1, -1 do
                    local fighter = Global.fighters[i]

                    if (fighter ~= "nil") then
                        for _, obj in ipairs(layer.objects) do
                            if (obj.name == "Fighter" .. i) then
                                local fighterIns = Fighter.new(fighter, i, Global.fightersIntelType[i], Global.fightersStocks[i], obj.x, obj.y)
                                if (Global.fightersIntelType[i] == "cpu") then fighterIns.stageZone = stageZone end
                                if (Global.gameMode == "VERSUS") then
                                    fighterIns.curIntelType = "none"
                                    fighterIns.aiTime = 240
                                end

                                if (platformX) then
                                    fighterIns.platformPosX = platformX
                                    fighterIns.platformPosY = platformY
                                end
                                
                                gameState.scene:add(fighterIns)
                            end
                        end
                    end
                end

            end

            if (layer.name == "Sprites") then
                for _, obj in ipairs(layer.objects) do
                    local image = obj.properties["sprite"]

                    gameState.scene:add(Sprite.new("stage/" .. stageName .. "/" .. image, obj.x, obj.y - obj.height))
                end
            end


            -- [[
            if (layer.name == "Background") then
                for _, obj in ipairs(layer.objects) do
                    local image = obj.properties["sprite"]

                    local sprite = Sprite.new("stage/" .. stageName .. "/" .. image)
                    local background = Background.new(sprite, obj.x, obj.y - obj.height, obj.properties.speed or 0)

                    gameState.scene:add(background)
                    table.insert(gameState.backgrounds, background)
                end
            end
            --]]

        end

        return nt
    end
}