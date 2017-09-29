local Panel = class("Panel",require("app.common.DialogLayer"))

local Icon = require("app.views.ui.Icon")
local iconType = require("app.models.GameDefine").ICON_TYPE

Panel.RESOURCE_FILENAME = "panel.csb"

function Panel:ctor(...)
    self.super.ctor(self)
    self._rootNode = nil
    self:init()
    self:addIcon(...)
end

function Panel:init()
    if not isEmpty(self.RESOURCE_FILENAME) then
        self._rootNode = cc.CSLoader:createNode(self.RESOURCE_FILENAME)
        self:addChild(self._rootNode)        
    end

    if isEmpty(self._rootNode) then
        return
    end
end

function Panel:addIcon(...)
    local icons = {...}
    for _,v in pairs(icons) do
        if v == iconType.BARRACK then
            local icon = Icon:create(v)
            self._rootNode:getChildByTag(1):add(icon)
        elseif v == iconType.ARCHER then
            local icon = Icon:create(v)
            self._rootNode:getChildByTag(2):add(icon)
        elseif v == iconType.MAGIC then
            local icon = Icon:create(v)
            self._rootNode:getChildByTag(3):add(icon)
        elseif v == iconType.ARTILLERY then
            local icon = Icon:create(v)
            self._rootNode:getChildByTag(4):add(icon)
        elseif v == iconType.CELL then
            local icon = Icon:create(v)
            self._rootNode:getChildByTag(6):add(icon)
        --elseif v == iconType.FLAG then
        --elseif v == iconType.LOCKED then
        else
            local icon = Icon:create(v)
            self._rootNode:getChildByTag(5):add(icon)
        end
    end
end

return Panel