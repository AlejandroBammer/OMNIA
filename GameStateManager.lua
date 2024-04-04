local GameStateManager = {}

function GameStateManager.setCurrent(stateName, args)
    GameStateManager.nextCurrent = require("game states/" .. stateName .. "State").new(args)

    if not GameStateManager.current then
        GameStateManager.update()
    end
end

function GameStateManager.getCurrent()
    return GameStateManager.current
end

function GameStateManager.update()
    GameStateManager.current = GameStateManager.nextCurrent
end

return GameStateManager
