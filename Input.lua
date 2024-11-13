local Global = require("Global")

local Input = {
    inputTypes = {
        "down",
        "right",
        "up",
        "left",
        "attack",
        "special",
        "guard",
        "jump"
    },
	inputPress = {},
    controls = {},
    pauseInput = "unknown",
    returnInput = "unknown",
    controlsFile = love.filesystem.newFile("controls.txt")
}


function Input.load()
	for i = 1, #Input.inputTypes, 1 do
		for j = 1, Global.FIGHTER_MAXNUM, 1 do
			local iType = Input.inputTypes[i]
		
			Input.inputPress[i] = { [iType] = false }
		end
	end
end


function Input.pauseSet(key)
    Input.pauseInput = key
end

function Input.pauseGet()
    return love.keyboard.isScancodeDown(Input.pauseInput)
end


function Input.returnSet(key)
    Input.returnInput = key
end

function Input.returnGet()
    return love.keyboard.isScancodeDown(Input.returnInput)
end


function Input.set(player, input, key)
    if (input == "pause" or input == "return") then
		Input[input .. "Input"] = key
    else
		Input.controls[player][input] = key
    end
end

function Input.get(player, input)
    return love.keyboard.isScancodeDown(Input.controls[player][input])
end

function Input.getPress(player, input)
	local v = false

	local iGet = Input.get(player, input)
	
	if (iGet and not Input.inputPress[player][input]) then
		v = true
	else
		v = false
	end
	
	Input.inputPress[player][input] = iGet
	
	return v
end


for i = 1, Global.FIGHTER_MAXNUM, 1 do
    table.insert(Input.controls, {})

    for j = 1, #Input.inputTypes, 1 do
        local input = Input.inputTypes[j]

        Input.set(i, input, "unknown")
    end
end


function Input.saveControls()
    local txt = ""

    for i = 1, #Input.controls, 1 do
        txt = txt .. "Player" .. i .. " Controls" .. "\n"
        for j = 1, #Input.inputTypes, 1 do
            txt = txt .. Input.controls[i][Input.inputTypes[j]] .. "\n"
        end
    end

    txt = txt .. "Pause" .. "\n"
    txt = txt .. Input.pauseInput .. "\n"

    txt = txt .. "Return" .. "\n"
    txt = txt .. Input.returnInput .. "\n"

    Input.controlsFile:open("w")
    Input.controlsFile:write(txt)
    Input.controlsFile:close()
end


function Input.loadControls()
    Input.controlsFile:open("r")

    local lines = Input.controlsFile:lines()
    local linesN = #Input.inputTypes*Global.FIGHTER_MAXNUM+Global.FIGHTER_MAXNUM + 4

    local p = 0
    for i = 1, linesN, 1 do
        local line = lines()

        if not (line) then
            Input.initialize()
            goto exit
        end

        if (p <= 4) then
            if (i%(#Input.inputTypes+1)-1 ~= 0) then
                local inputI = (i-p-1)%#Input.inputTypes+1
                Input.set(p, Input.inputTypes[inputI], line)
            else
                p = p + 1
            end
        end
        
        if (i == linesN-2) then
            Input.pauseSet(line)
        end

        if (i == linesN) then
            Input.returnSet(line)
        end
    end

    Input.controlsFile:close()

    ::exit::
end

function Input.initialize()
    local player1 = {
        "s",
        "d",
        "w",
        "a",
        "j",
        "u",
        "i",
        "k"
    }

    local player2 = {
        "down",
        "right",
        "up",
        "left",
        "kp1",
        "kp4",
        "kp5",
        "kp2"
    }

    for i = 1, #Input.inputTypes, 1 do
		local iType = Input.inputTypes[i]
    
        Input.set(1, iType, player1[i])
        Input.set(2, iType, player2[i])
    end

    Input.pauseSet("return")
    Input.returnSet("backspace")
        
    Input.saveControls()
end

return Input
