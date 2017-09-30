local BaseRole = class("BaseRole",cc.Node)

function BaseRole:ctor()
    self._mLife = 0     -- 总血量
    self._cLife = 0     -- 当前血量
    self._speed = 0
    self._gold  = 0
    self._range = 0
    self._damage = {}
    self._isEnmy = true
    self._fly = false
    self._lifeBar = nil
    self._roleAction = nil
end

function BaseRole:setLifeBar()
    
    if isEmpty(self._lifeBar) then
        return
    end

    self._lifeBar:setPercent(self._cLife * 100 / self._mLife)

end

function BaseRole:remove()
    
    if self._roleAction then
        self._roleAction:play("die",false)
        self._roleAction:setFrameEventCallFunc(frameEndCallBack)
    end
    
    local function frameEndCallBack(frame)
        local str = frame:getEvent()
        if str == "dieEnd" then
            performWithDelay(self,function()
                self:removeSelf()
            end,2)    --延迟两秒remove
        end
    end

end

function BaseRole:move( pos ,target, callback)
    pos = self:convertToNodeSpaceAR(pos)
    local time = cc.pGetDistance(cc.p(0,0),pos) / self._speed
    if isEmpty(target) or isEmpty(callback) then
        self:runAction(MoveBy:create(time,pos))
    else
        self:runAction(Sequence:create(MoveBy:create(time,pos),handler(target,callback)))
    end
end

function BaseRole:attack()

    local function getRandDamge()
        math.randomseed( os.time() )
        return math.random( self._damage[1],self._damage[2] )
    end

    self._info.damage = getRandDamge()
    cc.Director:getInstance():getEventDispatcher():postEvent(GameDefine.GAME_EVENT.ENMY_HURT,self._info)

    if self._info.target:getPosition():distance(self:getPosition()) > self._range then
        self:getScheduler():unscheduleScriptEntry(self._scheduleAttack)
        self._scheduleAttack = nil
    end

end

return BaseRole