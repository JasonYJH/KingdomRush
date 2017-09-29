local baseMap = require("app.views.scene.BaseMap")

local Level_1 = class("Level_1",baseMap)
Level_1.RESOURCE_FILENAME = "scene/level_1.csb"

function Level_1:ctor()
    self.super.ctor(self)
    self._rootNode = nil
    self._mapView = nil
    self._mapImg = nil
    self._terrains = {}
    --gameManager:setStatus(10,80,0,7)
    self:init()
    self:addTerrainCallBack(self._terrains)
    --self:createMap()
end

function Level_1:init()
    if not isEmpty(self.RESOURCE_FILENAME) then
        self._rootNode = cc.CSLoader:createNode(self.RESOURCE_FILENAME)
        self:addChild(self._rootNode)        
    end

    if isEmpty(self._rootNode) then
        return
    end

    self._mapView = self._rootNode:getChildByName("map_view")
        :setScrollBarEnabled(false)
    self._mapImg = self._mapView:getChildByName("map_img")

    for i = 1, 5 do
        local terrain = self._mapImg:getChildByName(string.format("terrain_%d",i))
        table:pushBack(self._terrains,terrain)
    end
end

return Level_1
