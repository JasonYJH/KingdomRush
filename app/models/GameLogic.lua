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
    dispatcher:addEvent(GameDefine.GAME_EVENT.ENMY_HURT,       self, self.handleEnmyGetHurt)
    dispatcher:addEvent(GameDefine.GAME_EVENT.ARMY_HURT,       self, self.handleArmyGetHurt)
    dispatcher:addEvent(GameDefine.GAME_EVENT.FIND_TARGET,     self, self.handleFindTarget)
end

function GameLogic:setCurrentLevel(lv)
    self._cLevel = checkint(lv)
end

function GameLogic:handleGameReady()

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

function GameLogic:handleEnmyGetHurt(Info)
    
    if isEmpty(self._cEnmyList) or isEmpty(Info) then
        return
    end

    for k, enmy in pairs(self._cEnmyList) do
        if(enmy == Info.target) then
            enmy._cLife = enmy._cLife - Info.damage
            if enmy._cLife <= 0 then    -- 敌人死亡
                if not isEmpty(enmy._gold) then
                    self._status.gold = self._status.gold + enmy._gold
                    self:sendStatus()
                end
                enmy:remove()
                enmy = nil
                self._cEnmyList =  table.values(self._cEnmyList)
                
                if isEmpty(self._cEnmyList) and isEmpty(self._fullEnmyList) then
                    --gameover
                elseif isEmpty(self._cEnmyList) then
                    -- 下一波准备
                end

            else
                enmy:setLifeBar()
            end
            break
        end 
    end

end

function GameLogic:handleArmyGetHurt(Info)

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

function GameLogic:sendStatus()
    dispatcher:postEvent(GameDefine.GAME_EVENT.STATUS_CHANGE,self._status)
end

function GameLogic:getLevelInfo()
    self._status, self._path, self._fullEnmyList = GameCenter:readLevelInfo(self._cLevel)
    self._status.wave = 0   -- 插入当前波数
    self:sendStatus()
end

function GameLogic:sendNextEnmyList()

    if isEmpty(self._fullEnmyList) then
        printError("enmy list empty")
        return
    end

    self._status.wave = self._status.wave + 1
    self:sendStatus()
    dispatcher:postEvent(GameDefine.GAME_EVENT.ENMY_CREATE,self._fullEnmyList[1])
    table.remove( self._fullEnmyList, 1 )
    
end


return GameLogic