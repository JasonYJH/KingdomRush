local ArcherTower = class("ArcherTower", require(app.views.tower.BaseTower))

ArcherTower.RESOURCE_FILENAME = ""
function ArcherTower:ctor()
    
    self.super.ctor(self)
    self._rootNode = nil
    self:init()

end

function ArcherTower:init()
    
    if not isEmpty(self.RESOURCE_FILENAME) then
        self._rootNode = cc.CSLoader:createNode(self.RESOURCE_FILENAME)
        self._rootAction = cc.CSLoader:createTimeline(self.RESOURCE_FILENAME)
        self:addChild(self._rootNode)
    end

    if isEmpty(self._rootNode) then
        return
    end

end

return ArcherTower