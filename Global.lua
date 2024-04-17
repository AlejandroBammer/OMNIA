local Global = {
	idCounter = 0,
    font = nil,
    music = nil,
    musicFileName = "",
    fighterNum = 4,
    scoreTypes = { "given", "taken", "kills", "deaths" },
    fighters = {},
    fightersIntelType = {},
    fightersStocks = {},
    fightersScores = {},
    fightersPlaces = {},
    debug = false,
    pause = 1,
    gameMode = "nil"
}


-- Inteligencia de peleadores.
for i = 1, Global.fighterNum, 1 do
    Global.fightersIntelType[i] = "cpu"
end


-- Reproductor de música.
function Global.setMusic(fileName)
    Global.musicFileName = fileName

    if (Global.music) and (Global.music:isPlaying()) then
        Global.music:stop()
    end
    Global.music = love.audio.newSource("music/" .. fileName, "stream")
end


-- Gestión de stocks de los peledores.
function Global.setFightersStocks(amount)
    for i = 1, Global.fighterNum, 1 do
        Global.fightersStocks[i] = amount
    end
end
Global.setFightersStocks(-1)


-- Peleadores.
function Global.resetFighters()
    for i = 1, Global.fighterNum, 1 do
        Global.fighters[i] = "nil"
    end
end
Global.resetFighters()


-- Puntuación de los peleadores.
for i = 1, Global.fighterNum, 1 do
    table.insert(Global.fightersScores, {})
end


-- Reincia la puntuación.
function Global.resetScore()
    for i = 1, Global.fighterNum, 1 do
        for _, score in ipairs(Global.scoreTypes) do
            Global.fightersScores[i][score] = 0
        end
    end

    Global.fightersPlaces = {}
end
Global.resetScore()


-- Añadir puntos.
function Global.scoreAdd(ID, scoreType, score)
    score = score or 1

    Global.fightersScores[ID][scoreType] = Global.fightersScores[ID][scoreType] + score
end


-- Reincia todo.
function Global.resetData()
    Global.resetScore()
    Global.resetFighters()
    Global.setFightersStocks(-1)
    Global.pause = 1
end

return Global
