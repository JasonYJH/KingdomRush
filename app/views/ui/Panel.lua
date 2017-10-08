--local Panel = class("Panel",cc.Layer)
local Panel = class("Panel",require("app.common.DialogLayer"))
local Icon = require("app.views.ui.Icon")

Panel.RESOURCE_FILENAME = "ui/panel.csb"

function Panel:ctor(...)
    self.super.ctor(self)
    self._rootNode = nil
    self._posIcon = {}
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

    for i=1,6 do
        self._posIcon[i] = self._rootNode:getChildByName("panel"):getChildByName("icon_" .. i)
    end

end

function Panel:addIcon(...)
    local icons = {...}
    if #icons == 4 then
        local icon_1 = Icon:create(icons[1][1],icons[1][2])
        local icon_2 = Icon:create(icons[2][1],icons[2][2])
        local icon_3 = Icon:create(icons[3][1],icons[3][2])
        local icon_4 = Icon:create(icons[4][1],icons[4][2])
        self._posIcon[1]:addChild(icon_1)
        self._posIcon[2]:addChild(icon_2)
        self._posIcon[3]:addChild(icon_3)
        self._posIcon[4]:addChild(icon_4)
    elseif #icons == 3 then
        local icon_1 = Icon:create(icons[1][1],icons[1][2])
        local icon_2 = Icon:create(icons[2][1],icons[2][2])
        local icon_3 = Icon:create(icons[3][1],icons[3][2])
        self._posIcon[5]:addChild(icon_1)
        self._posIcon[6]:addChild(icon_2)
        self._posIcon[7]:addChild(icon_3)
    elseif #icons == 2 then
        local icon_1 = Icon:create(icons[1][1],icons[1][2])
        local icon_2 = Icon:create(icons[2][1],icons[2][2])
        self._posIcon[5]:addChild(icon_1)
        self._posIcon[6]:addChild(icon_2)
    elseif #icons == 1 then
        local icon_1 = Icon:create(icons[1][1],icons[1][2])
        self._posIcon[6]:addChild(icon_1)
    end
    performWithDelay(self, function ()
        self:getEventDispatcher():postEvent(GameDefine.GAME_EVENT.REQUEST_STATUS)
    end,0.02)
end

return Panel