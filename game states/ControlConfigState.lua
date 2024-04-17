local GameState = require("GameState")
local Spritefont = require("Spritefont")
local Sprite = require("Sprite")
local Button = require("game objects/Button")
local Input = require("Input")
local GameStateManager = require("GameStateManager")
local Global = require("Global")
local Viewport = require("Viewport")

local unknownFont = Spritefont.new("gfx/unknown.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz", 1, { 38/255, 38/255, 38/255, 255/255 })
local unknownFont2 = Spritefont.new("gfx/unknownS2.png", " ABCDEFGHIJKLMNOPQRSTUVWXYZ",  1, { 77/255, 77/255, 77/255, 1 })


local mt = {}
mt.__index = mt
setmetatable(mt, GameState)


function mt:update()
	self:baseUpdate();
end


function mt:draw()
	self:baseDraw();
	
	-- Select rect.
    love.graphics.rectangle("line", self.selectRect.x+1, self.selectRect.y+1, self.selectRect.width-1, self.selectRect.height-1)
    
	
	-- Salvapantallas de configuración de input.
	unknownFont.imageBlend = { 1, 1, 1 }
    if (self.setInput) then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, Viewport.width, Viewport.height)
        love.graphics.setColor(1, 1, 1, 1)

        local txt = "PRESS ANY KEY"
        local x = Viewport.width/2  - unknownFont2:getTextWidth(txt)/2
        local y = Viewport.height/2 - unknownFont2.height/2
        unknownFont2.imageBlend = { 1, 1, 1 }
        unknownFont2:print(txt, x, y)
        unknownFont2.imageBlend = { 82/255, 29/255, 182/255 }

        local txt = "Presiona DEL para eliminar"
        local x = Viewport.width/2  - unknownFont:getTextWidth(txt)/2
        local y = Viewport.height - unknownFont.height*2

        
        unknownFont:print(txt, x, y)
    end
    unknownFont.imageBlend = { 0, 0, 0 }
    
    
    -- Inputs de las teclas.
    for _, key in ipairs(self.keys) do
		local txt = Input.controls[self.playerIndex][key.name] or Input[key.name .. "Input"]
		if (txt == "unknown") then txt = "none" end

		local x = key.x + key:getSprite().width/2
		local y = key.y - 16
		local originX = love.graphics.newText(Global.font, txt):getWidth()/2

		
		love.graphics.print(txt, x, y, 0, 1, 1, originX, 0)
	end
end


-- Definición de controles.
function mt:keypressed(key, scancode, isrepeat)
    if (self.setInput) then
        if (key ~= "delete") then
			Input.set(self.playerIndex, self.inputToSet, scancode)
        else
            Input.set(self.playerIndex, self.inputToSet, "unknown")
        end
        
        self.setInput = false
        self.inputToSet = "none"
    end
end


return
{
	new = function()
		local nt =
		{
			setInput = false,
			inputToSet = "none",
			playerIndex = 1,
			selectRect = require("Rectangle").new(32, 64, 104, 40),
			keys = {}
		}
		setmetatable(nt, mt)
		nt:baseNew()
		
		local addKey = function(key)
			table.insert(nt.keys, key); nt.scene:add(key)
		end
		
		-- Fondo.
		nt.scene:add(Sprite.new("gfx/menu/cc-bg.png"))
		
		local plrsSpr = Sprite.new("gfx/menu/player tags.png")
		plrsSpr:createGrid(4)
		
		for i = 0, 3 do
			local btn = Button.new(plrsSpr)
			btn.imageChange = false
			btn.x = 32 + i * plrsSpr.width
			btn.y = 64
			btn.imageIndex = i+1
			
			function btn:selectAction()
				nt.selectRect.x = 32 + i * nt.selectRect.width
				nt.playerIndex = i+1
			end
			
			nt.scene:add(btn)
		end
		
		
		
		-- Botón para retroceder.
		local btnSpr = Sprite.new("gfx/menu/button.png")
		btnSpr:createGrid(2)
		
		local btnBack = Button.new(btnSpr); btnBack.x = 15; btnBack.y = 12; btnBack.font = unknownFont2
		btnBack.text = "VOLVER"
		btnBack.textYOffset = -2
		btnBack.font.imageBlend = { 82/255, 29/255, 182/255 }
		nt.scene:add(btnBack)
		
		function btnBack:selectAction()
			Input.saveControls()
            GameStateManager.setCurrent("Menu")
		end
		
		
		-- Tecla sprite.
		local keySpr = Sprite.new("gfx/menu/key.png"); keySpr:createGrid(2)
		
		
		--- Direccionales --
		local btnKDown = Button.new(keySpr); btnKDown.x = 114; btnKDown.y = 192
		btnKDown.name = "down"
		addKey(btnKDown)
		
		local btnKRight = Button.new(keySpr); btnKRight.x = 162; btnKRight.y = 192
		btnKRight.name = "right"
		addKey(btnKRight)
		
		local btnKUp = Button.new(keySpr); btnKUp.x = 114; btnKUp.y = 144
		btnKUp.name = "up"
		addKey(btnKUp)
		
		local btnKLeft = Button.new(keySpr); btnKLeft.x = 66; btnKLeft.y = 192
		btnKLeft.name = "left"
		addKey(btnKLeft)
		
		
		--- Acionales ---
        local btnKSpecial = Button.new(keySpr); btnKSpecial.x = 338; btnKSpecial.y = 192
		btnKSpecial.name = "special"
		addKey(btnKSpecial)
		
		local btnKGuard = Button.new(keySpr); btnKGuard.x = 386; btnKGuard.y = 192
		btnKGuard.name = "guard"
		addKey(btnKGuard)
		
		local btnKJump = Button.new(keySpr); btnKJump.x = 338; btnKJump.y = 144
		btnKJump.name = "jump"
		addKey(btnKJump)
		
		local btnKAttack = Button.new(keySpr); btnKAttack.x = 290; btnKAttack.y = 192
		btnKAttack.name = "attack"
		addKey(btnKAttack)
		
		
		--- Globales ---
		local space = 36
        
        local btnKPause = Button.new(keySpr); btnKPause.x = 226 - space; btnKPause.y = 138
        btnKPause.name = "pause"
        btnKPause.textYOffset = 22
		addKey(btnKPause)
		
		
		local btnKReturn = Button.new(keySpr); btnKReturn.x = 226 + space; btnKReturn.y = 138
        btnKReturn.name = "return"
        btnKReturn.textYOffset = 22
		addKey(btnKReturn)
		
		
		
		for _, key in ipairs(nt.keys) do
			-- Ubicación de su etiqueta.
			key.text = key.name
			key.font = unknownFont
			if (key.name == "up" or key.name == "jump") then key.textXOffset = 28
			else key.textYOffset = 22 end
			
			-- Declaración de función.
			function key:selectAction()
				nt.setInput = true
				nt.inputToSet = key.name
			end
		end
		
		
		return nt
	end
}
