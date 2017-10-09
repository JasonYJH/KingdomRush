local Icon = class("Icon",cc.Layer)

Icon.RESOURCE_FILENAME = "ui/icon.csb"

function Icon:ctor(iconType, attributes)
    self._rootNode = nil
    self._iconBtn = nil
    self._priceImg = nil
    self._priceText = nil

    self._cost = nil
    self._type = nil
    self:init()
    self:addEvent()
    self:checkIcon(iconType, attributes)
end

function Icon:init()
    if not isEmpty(self.RESOURCE_FILENAME) then
        self._rootNode = cc.CSLoader:createNode(self.RESOURCE_FILENAME)
        self:addChild(self._rootNode)        
    end

    if isEmpty(self._rootNode) then
        return
    end

    self._iconBtn = self._rootNode:getChildByName("icon_btn")
    self._priceImg = self._rootNode:getChildByName("price_img")
    self._priceText = self._priceImg:getChildByName("price_txt")

    loadPlist("image/ui/common_spritesheet_16_a_2-hd.plist")

    self._iconBtn:addTouchEventListener(handler(self,self.onIconClick))
   
    self:getEventDispatcher():addEvent(GameDefine.GAME_EVENT.STATUS_CHANGE, self, self.handleStatusChange)
end

function Icon:addEvent()
    
    local function onNodeEvent(event)
        if event == "exit" then
            self:getEventDispatcher():removeEvent(GameDefine.GAME_EVENT.STATUS_CHANGE)
        end
    end
    self:registerScriptHandler(onNodeEvent)

end

function Icon:handleStatusChange(Info)

    if isEmpty(self._cost) then
        self:setIconEnable(true)
        return
    end

    if self._cost > Info.gold then -- 金币不足
        self:setIconEnable(false)
    else
        self:setIconEnable(true)
    end

end

function Icon:onIconClick(sender)

    if self._type == GameDefine.ICON_TYPE.BUILDING then
        cc.Director:getInstance():getEventDispatcher():postEvent()
    elseif self._type == GameDefine.ICON_TYPE.UPDATE then
        cc.Director:getInstance():getEventDispatcher():postEvent()
    elseif self._type == GameDefine.ICON_TYPE.CELL then
        cc.Director:getInstance():getEventDispatcher():postEvent()
    end
    self:getParent():getParent():getParent():removeSelf()   --  移除panel

end

function Icon:setIconEnable(enable)
    
    if enable then
        self._iconBtn:setEnabled(true)
        if not isEmpty(self._cost) then
            self._priceText:setColor(cc.c3b(244, 226, 144))
        end
    else
        self._iconBtn:setEnabled(false)
        if not isEmpty(self._cost) then
            self._priceText:setColor(cc.c3b(108, 106, 105))
        end
    end

end

function Icon:checkIcon(iconType, attributes)

    if iconType == GameDefine.ICON_TYPE.BUILDING then
        if attributes == GameDefine.TOWER_TYPE.BARRACK_1 then
            self._iconBtn:loadTextureNormal("main_icons_0002.png",ccui.TextureResType.plistType)
            self._cost = GameDefine.TOWER_TYPE.BARRACK_1.price
        elseif attributes == GameDefine.TOWER_TYPE.ARCHER_1 then
            self._iconBtn:loadTextureNormal("main_icons_0001.png",ccui.TextureResType.plistType)
            self._cost = GameDefine.TOWER_TYPE.ARCHER_1.price
        elseif attributes == GameDefine.TOWER_TYPE.MAGIC_1 then
            self._iconBtn:loadTextureNormal("main_icons_0003.png",ccui.TextureResType.plistType)
            self._cost = GameDefine.TOWER_TYPE.MAGIC_1.price
        elseif attributes == GameDefine.TOWER_TYPE.ARTILLERY_1 then
            self._iconBtn:loadTextureNormal("main_icons_0004.png",ccui.TextureResType.plistType)
            self._cost = GameDefine.TOWER_TYPE.ARTILLERY_1.price
        else
            return
        end
        self._priceText:setString(tostring(self._cost))

    elseif iconType == GameDefine.ICON_TYPE.UPDATE then
        for _, type in pairs(GameDefine.TOWER_TYPE) do
            if type == attributes then
                self._iconBtn:loadTextureNormal("main_icons_0005.png",ccui.TextureResType.plistType)
                self._cost = type.price
                break
            end
        end
        self._priceText:setString(tostring(self._cost))

    elseif iconType == GameDefine.ICON_TYPE.CELL then
        for _, type in pairs(GameDefine.TOWER_TYPE) do
            if type == attributes then
                self._iconBtn:loadTextureNormal("ico_sell_0001.png",ccui.TextureResType.plistType)
                self._cost = checkint(type.price * 0.6)
                break
            end
        end
        self._priceText:setString(tostring(self._cost))

    elseif iconType == GameDefine.ICON_TYPE.LOCKED then
        self._priceImg:hide()
    elseif iconType == GameDefine.ICON_TYPE.FLAG then
        self._priceImg:hide()
    else
        return
    end

    

end

return Icon