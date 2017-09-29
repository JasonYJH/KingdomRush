local GameManager = class("GameManager")
local gameCenter = require("app.models.GameCenter")
GameManager.status = {lifes = 0,golds = 0,wave = 0,maxWaves = 0}

GameManager._curArchive = nil
GameManager._curStar = nil
GameManager._curLevelInfo = nil

function GameManager:ctor()
    self._curArchive = nil
    self._curStar = nil
    self._curLevelInfo = nil
end

function GameManager:getInstance()
    if not isEmpty(self._instance) then
        return  GameManager._instance
    else
        GameManager._instance = GameManager.new()
    end
end

function GameManager:checkArchive(i)
    if GameManager._curArchive ~= i then
        GameManager._curArchive, GameManager._curStar,GameManager._curLevelInfo = gameCenter:readArchiveInfo(i)
    end

    if not isEmpty(GameManager._curArchive) then
        return true
    else
        return false
    end
end

function GameManager:createArchive(i)
    return gameCenter:createArchive(i)
end

function GameManager:getLevelInfo(i)
    if GameManager._curArchive == i and GameManager._curLevelInfo then
        return GameManager._curLevelInfo
    end
    
    GameManager._curArchive, GameManager._curStar,GameManager._curLevelInfo = gameCenter:readArchiveInfo(i)
    return GameManager._curLevelInfo
end

return GameManager