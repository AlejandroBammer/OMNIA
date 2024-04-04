local Sprite    = require("Sprite")
local Mouse     = require("Mouse")
local Rectangle = require("Rectangle")
local Object    = require("Object")
local Spritefont = require("Spritefont")
local Sound = require("Sound")

local LEFTCLICK = 1

local mt = {}
mt.__index = mt
setmetatable(mt, Object)

function mt:update()
    if (not self.isHovering) then self.hoverTrigger = false end

    -- Captura las coordenadas del mouse.
    local mouse = Rectangle.new(Mouse.getX(), Mouse.getY(), 0, 0)

    -- Comprueba el mouse se encontra por encima suyo.
    local rect = self:getRect()

    self.isDown = false
    local leftClick = love.mouse.isDown(1)
    if (self.isHovering) and (self.start) then
        
        -- Pasa a la siguiente imagen.
        if ((self.change) and (self:getCurrentSprite().imageNumber > 1)) then        
            self.imageIndex = self:getNextImageIndex()
        end

        -- Sonido.
        if (self.hoverSnd ~= nil) then
            if (not self.hoverTrigger) then
                Sound.play(self.hoverSnd)
                self.hoverTrigger = true
            end
        end

        -- Evento del mouse.
        if (self.visible) and (leftClick) and not (self._leftClick) then
            self:setIsDown(true)
        end

        -- Vuelve a la imagen anterior.
    else self.imageIndex = self.firImageIndex end
    self._leftClick = leftClick
    self.isHovering = rect:intersect(mouse)

    -- Se tardara 1 frame en ser activado.
    if not (self.start) then self.start = true end
end

function mt:draw()
    self:baseDraw()
    
    if ((self.spritefont ~= nil) and (self.visible)) then
        local textOriginX = self.x + self.width/2  - self.spritefont:getTextWidth(self.pText)/2
        local textOriginY = self.y + self.height/2 - self.spritefont.height/2

        self.spritefont:print(self.pText, textOriginX + self.textXOffset, textOriginY + self.textYOffset)
    end
end

function mt:isPressed()
    return self.isDown
end

function mt:setIsDown(bool)
    if (self.acceptSnd ~= nil) then
        if (bool == true and self.isDown == false) then
            Sound.play(self.acceptSnd)
        end
    end

    self.isDown = bool
end

function mt:getNextImageIndex()
    local imageIndex

    if (self.firImageIndex ~= self:getCurrentSprite().imageNumber) then imageIndex = self.firImageIndex+1
    else imageIndex = 1 end

    return imageIndex
end

function mt:getRect()
    return Rectangle.new(self.x, self.y, self:getCurrentSprite().width, self:getCurrentSprite().height)
end

return {
    new = function(ID, group, sprite, spritefont, x, y, visible, imageNumber, firImageIndex, change)
        local nt = {
            is_button = true,
            ID = ID or "nil",
            pText = "",
            group = group or "nil",
            spritefont = spritefont,
            width = 0,
            height = 0,
            textXOffset = 0,
            textYOffset = 0,
            textOriginX = 0,
            textOriginY = 0,
            visible = visible,
            notOperate = notOperate,
            firImageIndex = firImageIndex or 1,
            isHovering = false,
            isDown = false,
            start = false,
            change = true,
            hoverSnd = "menu-click",
            acceptSnd = "menu-accept",
            hoverTrigger = false
        }
        setmetatable(nt, mt)
        nt:baseNew()
        nt.x = x or 0
        nt.y = y or 0
        nt.pText = nt.ID

        if (visible == nil) then nt.visible = true end

        if (change ~= nil) then
            nt.change = change
        end

        function nt:drawFont() return end
        
        local bSprite
        if (type(sprite) == "string") then
            bSprite = Sprite.new(sprite)
            bSprite:createGrid(imageNumber or 2)
        else
            bSprite = sprite
        end

        nt.width  = bSprite.width
        nt.height = bSprite.height

        nt:spriteAdd(sprite, bSprite)

        return nt
    end
}