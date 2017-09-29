local LevelMap = class("LevelMap",cc.Layer)

LevelMap.RESOURCE_FILENAME = "scene/level_map.csb"
function LevelMap:ctor()
    self._rootNode = nil
    self._mapView = nil
    self._map = nil
    self._flag = {}
    self:init()
end

function LevelMap:init()
    if not isEmpty(self.RESOURCE_FILENAME) then
        self._rootNode = cc.CSLoader:createNode(self.RESOURCE_FILENAME)
        self:addChild(self._rootNode)
    end

    if isEmpty(self._rootNode) then
        return
    end
    
    self._mapView = self._rootNode:getChildByName("map_view")
        :setScrollBarEnabled(false)
    
    self._map = self._mapView:getChildByName("map_img")

    for i=1,GameDefine.LEVELS_COUNT do
        local v = self._map:getChildByName(string.format( "flag_%d_btn",i ))
        table:pushBack(self._flag,v)
    end

end

function LevelMap:setFlag(Info)

    local star = Info.star
    local levelInfo = Info.levelInfo
    
    if type(levelInfo) ~= "table" or isEmpty(levelInfo) then
        return
    end
    
    for k,v in pairs(levelInfo) do
        if isEmpty(v) then
            self._flag[k]:hide()
        end
        if v >= 1 then
            --self._flag[i]:setBright(true)
            self._flag[k]:getChildByTag(1):setBright(true)
        end
        if v >= 2 then
            self._flag[k]:getChildByTag(2):setBright(true)
        end
        if v >= 3 then
            self._flag[k]:getChildByTag(3):setBright(true)
        end

        self._flag[k]:addTouchEventListener(function(sender,status)
            if status == TOUCH_EVENT_ENDED then
                local priview = require("app.views.scene.LevelPriview"):create(3):addTo(self)                
            end
        end)
    end
end

--显示关卡预览界面
function LevelMap:showPriview(target,event)
    local str = event._usedata
    str = string.sub( str,-1 )
    self._priview = cc.CSLoader:create()
    self._priview:setContentSize(display.size)
    ccui.Helper:doLayout(self._priview)
    self:addChild(self._priview)
end

return LevelMap
