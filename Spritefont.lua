local mt = {}
mt.__index = mt

function mt:print(text, x, y)
    x = x or 0
    y = y or 0

    --  Dibujado de carácteres  --
    love.graphics.setColor(self.imageBlend[1], self.imageBlend[1], self.imageBlend[3], self.imageAlpha)
    for i = 1, #text do
        local char = text:sub(i, i)

        local charGrid = self.charGrid[char] ~= nil and self.charGrid[char] or self.charGrid[" "]
        love.graphics.draw(
        self.imageFont,
        charGrid,
        math.floor(x + (self:getTextWidth(text, i-1)*self.scaleX)+0.5),
        math.floor(y+0.5),
        0,
        self.scaleX,
        self.scaleY)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function mt:getTextWidth(text, range)
    range = range or #text

    local x = 0
    for i = 1, range do
        local char = text:sub(i, i)
        x = x + self.charWidths[char] + self.spacing
    end
    return x
end

return {
    new = function(imageFont, characters, spacing, sepColor)
        local nt = {
            imageBlend = { 1, 1, 1 },
            imageAlpha = 1,
            scaleX = 1;
            scaleY = 1;
            spacing = spacing or 0,
            characters = characters,
            charGrid = {},
            charWidths = {},
            sepColor = sepColor
        }
        setmetatable(nt, mt)
        local imageFontData = love.image.newImageData(imageFont)
        nt.imageFont = love.graphics.newImage(imageFontData)
        nt.height = nt.imageFont:getHeight()

        -- Crea la rejilla de carácteres  --
        local j = 0
        local x = 0
        local width = 0
        for i = 1, nt.imageFont:getWidth()-1 do
            local r, g, b, a = imageFontData:getPixel(i, 0)
            if (r == nt.sepColor[1]) and (g == nt.sepColor[2]) and (b == nt.sepColor[3]) and (a == nt.sepColor[4]) then
                j = j + 1

                local char = nt.characters:sub(j, j)
                
                local q = love.graphics.newQuad(x+j, 0, width, nt.height, nt.imageFont:getDimensions())
                nt.charGrid[char] = q
                nt.charWidths[char] = width

                x = x + width
                width = 0
            else
                width = width + 1
            end
        end
        
        return nt
    end
}
