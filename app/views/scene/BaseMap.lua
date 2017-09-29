local BaseMap = class("BaseMap",cc.Layer)

local Panel = require("app.views.ui.Panel")
local IconType = GameDefine.ICON_TYPE

function BaseMap:ctor()
    self._isMenuOpen = false
end

function BaseMap:addTerrainCallBack(map,terrains)
    if type(terrains) ~= "table" or isEmpty(terrains) then
        error("prama invalid")
    end

    -- local function openPanel( pos ) -- 关闭panel
    --     Panel:create(IconType.BARRACK, IconType.ARCHER, IconType.MAGIC, IconType.ARTILLERY)
    --     :move( pos )
    --     :addTo(map,1,0) -- 显示在默认zorder上一级，预留tag = 0
    -- end

    -- local function terrainCallBack( sender )
    --     if self._isMenuOpen then
    --         -- close menu
    --         map:removeChildByTag(0)
    --         self._isMenuOpen = false
    --     else
    --         -- open menu
    --         openPanel(sender:getPosition())
    --         self._isMenuOpen = true
    --     end             
    -- end

    local function onClickCallBack(sender)
        Panel:create(IconType.BARRACK, IconType.ARCHER, IconType.MAGIC, IconType.ARTILLERY)
        Panel:move(sender:getPosition())
        Panel:addTo(sender:getParent(),sender:getZOrder() + 1)
    end

    for _,terrain in pairs(terrains) do
        terrain:addClickEventListener(onClickCallBack)
    end
    
end

return BaseMap
