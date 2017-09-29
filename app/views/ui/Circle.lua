local Circle = class("Circle",cc.Node)

Circle.RESOURCE_FILENAME = "circle.csb"

function Circle:ctor(range)
    self._rootNode = nil
    self._scalex = 1
    self._scaley = 0.6
    self._defaultRange = 160
    self:init()
    self:setRange(range)
end

function Circle:init()
    if not isEmpty(self.RESOURCE_FILENAME) then
        self._rootNode = cc.CSLoader:createNode(self.RESOURCE_FILENAME)
        self:addChild(self._rootNode)        
    end

    if isEmpty(self._rootNode) then
        return
    end
end

function Circle:setRange(range)
    local circle = self._rootNode:getChildByTag(1)
    if not isEmpty(range) then
        local mult = range / self._defaultRange
        circle:setScale(self._scalex * mult,self._scaley * mult)
    else
        circle:setScale(self._scalex, self._scaley)     -- 默认大小
    end
end

return Circle