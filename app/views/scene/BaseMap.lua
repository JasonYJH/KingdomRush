local BaseMap = class("BaseMap",cc.Layer)

local Panel = require("app.views.ui.Panel")
local IconType = GameDefine.ICON_TYPE

function BaseMap:ctor()
    
end

function BaseMap:addTerrainCallBack(terrains)
    if type(terrains) ~= "table" or isEmpty(terrains) then
        error("prama invalid")
    end

    local function onClickCallBack(sender)
        local panel = Panel:create(
            {GameDefine.ICON_TYPE.BUILDING,GameDefine.TOWER_TYPE.BARRACK_1}, 
            {GameDefine.ICON_TYPE.BUILDING,GameDefine.TOWER_TYPE.ARCHER_1},
            {GameDefine.ICON_TYPE.BUILDING,GameDefine.TOWER_TYPE.MAGIC_1},
            {GameDefine.ICON_TYPE.BUILDING,GameDefine.TOWER_TYPE.ARTILLERY_1})
        panel:move(sender:getPosition())
        panel:addTo(sender:getParent(),sender:getLocalZOrder() + 1)
    end

    for _,terrain in pairs(terrains) do
        terrain:addClickEventListener(onClickCallBack)
    end
    
end

return BaseMap
