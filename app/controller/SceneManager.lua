local SceneManager = class("SceneManager")

--local GameDefine = require("app.models.GameDefine")

function SceneManager:ctor()
    self._gameLogic = require("app.models.GameLogic"):create()
    self._gameCenter = require("app.models.GameCenter")
    self._loginScene = require("app.views.scene.LoginScene")
    self._levelMap   = require("app.views.scene.LevelMap")
    self._level = nil
    self:addEvent()
end

function SceneManager:addEvent()

    cc.Director:getInstance():getEventDispatcher():addEvent(GameDefine.FRAME_EVENT.LOGINSCENE_INIT_READY, self, self.handleLoginReady)
    cc.Director:getInstance():getEventDispatcher():addEvent(GameDefine.FRAME_EVENT.LEVEL_MAP_INIT       , self, self.handleInitLevelMap)
    cc.Director:getInstance():getEventDispatcher():addEvent(GameDefine.GAME_EVENT.ENMY_CREATE           , self, self.handleEnmyCreate)

end

function SceneManager:handleLoginReady()

    for i=1,3 do
        local archive, star, levelInfo = self._gameCenter:readArchiveInfo(i)
        if isEmpty(archive) then
            self._loginScene._archive[i] = nil
            self._loginScene._star[i] = nil
            self._loginScene._levelInfo[i] = nil
        else
            self._loginScene._archive[i] = archive
            self._loginScene._star[i] = star
            self._loginScene._levelInfo[i] = levelInfo
        end
    end

end

function SceneManager:handleInitLevelMap(Info)
    
    self._levelMap = self._levelMap:create()
    local scene = display.newScene("levelMap")
    self._levelMap:addTo(scene,1)
    display.runScene(scene,FADE,0.5)

end

function SceneManager:createLoginScene()
 
    self._loginScene = self._loginScene:create()
    local scene = display.newScene("login")
    self._loginScene:addTo(scene,1)
    display.runScene(scene)
end

function SceneManager:createLevelMap()
    self._levelMapScene = display.newScene("levelMap")
    local layer = require("app.views.scene.LevelMap"):create():addTo(scene,1)
    display.runScene(self._levelMapScene)
end

function SceneManager:createLevel(levelID)

    local str = string.format( "app.views.scene.Level_%d", checkint(levelID) )
    local scene = display.newScene("level")
    self._level = require(str):create()
    self._level:addTo(scene, 1)
    local status = require("app.views.ui.LevelUi"):create():addTo(scene,2)
    display.runScene(scene)
    
    self._gameLogic:setCurrentLevel(levelID)
    cc.Director:getInstance():getEventDispatcher():postEvent(GameDefine.GAME_EVENT.GAME_READY)
    
end

function SceneManager:handleEnmyCreate(sender)

    if isEmpty(sender) then
        return
    end

    for _, role in pairs(sender) do
        if role.type == "robber" then
            
        end
    end
end


return SceneManager