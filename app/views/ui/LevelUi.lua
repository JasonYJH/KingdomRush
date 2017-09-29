local LevelUi = class("LevelUi",cc.Layer)

LevelUi.RESOURCE_FILENAME = "ui/level_ui.csb"

function LevelUi:ctor()
    self._rootNode = nil
    self._top = nil
    self._bottom = nil
    self._statusNode = nil
    self._skill_1Box = nil
    self._skill_2Box = nil
    self._pauseBtn = nil
    self._lifeText = nil
    self._goldText = nil
    self._waveText = nil

    self._pausePanel = nil

    self:init()
end

function LevelUi:init()
    if not isEmpty(self.RESOURCE_FILENAME) then
        self._rootNode = cc.CSLoader:createNode(self.RESOURCE_FILENAME)
        self:addChild(self._rootNode)        
    end

    if isEmpty(self._rootNode) then
        return
    end

    self._top = self._rootNode:getChildByName("top_node")
    self._bottom = self._rootNode:getChildByName("bottom_node")
    self._pauseBtn = self._top:getChildByName("pause_btn")
    self._skill_1Box = self._bottom:getChildByName("skill_1_box")
    self._skill_2Box = self._bottom:getChildByName("skill_2_box")
    self._statusNode = self._top:getChildByName("status_node")
    self._lifeText = self._statusNode:getChildByName("lifes_txt")
    self._goldText = self._statusNode:getChildByName("golds_txt")
    self._waveText = self._statusNode:getChildByName("waves_txt")

    cc.Director:getInstance():getEventDispatcher():addEvent(GameDefine.GAME_EVENT.STATUS_CHANGE,self,self.statusChangeCallBack)
end

function LevelUi:statusChangeCallBack(event)
    self._lifeText:setString(tostring(event.life))
    self._goldText:setString(tostring(event.gold))
    self._waveText:setString(string.format( "0 / %d", event.waves ))
end

function LevelUi:setPauseBtn()
    if isEmpty(self._pauseBtn) then
        return
    end

    local function pauseCallBack( sender )
        self:move(self._top, cc.p(0,110), 0.5)
        self:move(self._bottom, cc.p(0,-140), 0.5)
        cc.Director:getInstance():pause() -- 暂停游戏
    end

    self._pauseBtn:addClickEventListener(pauseCallBack)

end

function LevelUi:showPausePanel()
    self._pausePanel:show()
    --self:move(self._pausePanel)
end

function LevelUi:move( target, pos, time )
    local action = cc.MoveBy:create(time, pos)
    target:runAction(action)
end

return LevelUi