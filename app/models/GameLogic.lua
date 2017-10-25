local GameLogic = class("GameLogic",cc.Node)

--local GameDefine = require("app.models.GameDefine")
local GameCenter = require("app.models.GameCenter")
local dispatcher = cc.Director:getInstance():getEventDispatcher()

function GameLogic:ctor()
    -- 当前存档
    self._curArchive = nil
    self._curStar = nil
    self._curLevelInfo = nil

    -- 当前关卡
    self._cLevel = 0
    self._status = {}               -- 保存关卡当前状态
    self._path = {}                 -- 保存关卡的路线
    self._fullEnmyList = {}         -- 保存关卡的怪物列表
    self._cEnmyList = {}            -- 保存当前存活的怪物列表
    self._cArmyList = {}
    self:handlerEvent()
end

function GameLogic:getInstance()
    if not isEmpty(GameLogic._instance) then
        return  GameLogic._instance
    else
        GameLogic._instance = GameLogic.new()
        return GameLogic._instance
    end
end

function GameLogic:reset()
    self._cLevel = 0
    self._status = {}              -- 保存关卡当前状态
    self._path = {}                -- 保存关卡的路线
    self._fullEnmyList = {}        -- 保存关卡的怪物列表
    self._cEnmyList = {}
    self._cArmyList = {}
end

function GameLogic:handlerEvent()   
    dispatcher:addEvent(GameDefine.GAME_EVENT.REQUEST_STATUS,  self, self.sendStatus)
    dispatcher:addEvent(GameDefine.GAME_EVENT.GAME_READY,      self, self.handleGameReady)
    dispatcher:addEvent(GameDefine.GAME_EVENT.NEXT_ENMY_READY, self, self.sendNextEnmyList)
    dispatcher:addEvent(GameDefine.GAME_EVENT.ROLE_DEATH,      self, self.handleRoleDeath)
    dispatcher:addEvent(GameDefine.GAME_EVENT.FIND_TARGET,     self, self.handleFindTarget)
end

function GameLogic:setCurrentLevel(lv)
    self._cLevel = checkint(lv)
end

function GameLogic:handleGameReady(Info)

    if isEmpty(self._cLevel) then
        printLog("GameLogic current level invalid")
        return
    end

    -- 加载关卡信息
    self._status, self._path, self._fullEnmyList = GameCenter:readLevelInfo(self._cLevel)
    self._status.wave = 0   -- 插入当前波数
    self:sendStatus()
    
    performWithDelay(self, handler(self,self.sendNextEnmyList),30)


end

function GameLogic:handleRoleDeath(sender)
    
    if isEmpty(sender) then
        return
    end

    if sender._isEnmy then
        for _, role in pairs(self._cEnmyList) do
            if role == sender then
                if not isEmpty(sender._gold) then
                    self._status.gold = self._status.gold + role._gold
                    self:sendStatus()
                end
                role = nil
                self._cEnmyList = table.values(self._cEnmyList)
                break
            end
        end
        if isEmpty(self._cEnmyList) then
            -- 下一波敌人
        end
    else
        for _, role in pairs(self._cArmyList) do
            if role == sender then
                role = nil
                self._cArmyList = table.values(self._cArmyList)
                break
            end
        end
    end

end

function GameLogic:handleFindTarget(Info)
    
    local targetList = {}
    local this = Info.this
    if this._isEnmy then
        targetList = self._cEnmyList
    else
        targetList = self._cArmyList
    end

    if Info.airDefence then --能对空
        for _, target in pairs(targetList) do 
            if target:getPosition():distance(this._isEnmy:getPosition()) <= Info.range then
                dispatcher:postEvent(GameDefine.GAME_EVENT.GET_TARGET, target)
                break
            end
        end
    else
        for _, target in pairs(targetList) do 
            if target._fly and target:getPosition():distance(this._isEnmy:getPosition()) <= Info.range then
                dispatcher:postEvent(GameDefine.GAME_EVENT.GET_TARGET, target)
                break
            end
        end
    end

end

function GameLogic:setStatus( status )
    if not isEmpty(status) then
        self._status = status
        self:sendStatus()
    end
end

function GameLogic:sendStatus(Info)
    dispatcher:postEvent(GameDefine.GAME_EVENT.STATUS_CHANGE,self._status)
end

function GameLogic:getLevelInfo()
    self._status, self._path, self._fullEnmyList = GameCenter:readLevelInfo(self._cLevel)
    self._status.wave = 0   -- 插入当前波数
    self:sendStatus()
end

function GameLogic:sendNextEnmyList()

    if isEmpty(self._fullEnmyList) then
        printError("fullEnmyList empty")
        return
    end

    if type(self._fullEnmyList[1] ~= "table") then
        printError("fullEnmyList error")
        return
    end
    
    self._status.wave = self._status.wave + 1
    self:sendStatus()
    dispatcher:postEvent(GameDefine.GAME_EVENT.ENMY_CREATE,self._fullEnmyList[1])
    table.remove( self._fullEnmyList, 1 )
    
end


return GameLogic