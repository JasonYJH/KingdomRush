local BaseTower = class("BaseTower",cc.Node)

function BaseTower:ctor()
    self._range = 0
    self._damage = {}
    self._target = nil
    self._scheduleAttack = nil
    self._rootAction = nil
end

function BaseTower:construct()  -- 播放建造动画
    local build = cc.CSLoader:createNode("construct.csb")
        :addTo(self)
    local action = cc.CSLoader:createTimeLine("construct.csb")
    local bar = build:getChildByTag(1):getChildByTag(1)
    
    local function loadingBar(dt)
        if bar:getPercent() ~= 100 then
            bar:setPercent(bar:getPercent()+5)
        else
            self:createTower()
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(scheduler)
        end
    end

    local scheduler = self:getScheduler():scheduleScriptFunc(loadingBar, 1/20, false)
end

function BaseTower:createTower()
    
end

function BaseTower:attack()

    local function getRandDamge()
        math.randomseed( os.time() )
        return math.random( self._damage[1],self._damage[2] )
    end

    local info = {}
    if isEmpty(self._target) or isEmpty(self._scheduleAttack) then
        return
    end
    info.target = self._target
    info.damage = getRandDamge()
    cc.Director:getInstance():getEventDispatcher():postEvent(GameDefine.GAME_EVENT.ENMY_HURT,info)

    if self._target:getPosition():distance(self:getPosition()) > self._range then
        self:getScheduler():unscheduleScriptEntry(self._scheduleAttack)
        self._scheduleAttack = nil
    end

end

return BaseTower