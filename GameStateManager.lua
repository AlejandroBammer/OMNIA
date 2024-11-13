local Gsm =
{
	states = {},
	capacity = nil
}

function Gsm.setCapacity(capacity)
	Gsm.capacity = capacity
	
	while (#Gsm.states > Gsm.capacity) do
		table.remove(Gsm.states, 1)
	end
end

function Gsm.peek()
	return Gsm.states[#Gsm.states]
end

function Gsm.push(gameStateName, ...)
	local newState = require("game states/" .. gameStateName .. "State").new(...)
	newState.name = gameStateName

	local lastState = Gsm.peek()
	if (lastState ~= nil) then lastState:exit() end
	
	table.insert(Gsm.states, newState)
	
	if (Gsm.capacity ~= nil and #Gsm.states > Gsm.capacity) then
		table.remove(Gsm.states, 1)
	end
	
	newState:enter()
end

function Gsm.pop()
	Gsm.peek():exit()
	
	table.remove(Gsm.states, #Gsm.states)
	
	Gsm.peek():enter()
end

function Gsm.clear()
	Gsm.states = {}
end


return Gsm
