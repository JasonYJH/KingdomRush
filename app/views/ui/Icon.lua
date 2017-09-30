local Icon = class("Icon",cc.Node)

Icon.RESOURCE_FILENAME = "ui/icon.csb"

function Icon:ctor(iconType, attributes)
    self._rootNode = nil
    self._iconImg = nil
    self._priceImg = nil
    self._priceText = nil

    self._cost = nil
    self._type = nil
    self:init()
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

    self._iconImg = self._rootNode:getChildByName("icon_img")
    self._priceImg = self._rootNode:getChildByName("price_img")
    self._priceText = self._rootNode:getChildByName("price_txt")

    loadPlist("image/ui/common_spritesheet_16_a_2-hd.plist")

    self._iconImg:addTouchEventListener(handler(self,self.onIconClick))
   
    cc.Director:getInstance():getEventDispatcher():addEvent(GameDefine.GAME_EVENT.STATUS_CHANGE,self,self.handleStatusChange)
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
    self:getParent():getParent():removeSelf()   --  移除panel

end

function Icon:touchCallBack(target,status)
    if status == TOUCH_EVENT_ENDED then
        self.confirm = self.confirm or false
        if not self.confirm then
            local icon = self:getResourceNode():getChildByTag(1)
            icon:loadTexture(self.confirmName,1)
            self.confirm = true
        else
            self.confirm = false
        end
    end
end


function Icon:setIconEnable(enable)
    
    if enable then
        self._iconImg:setEnabled(true)
        if not isEmpty(self._cost) then
            self._priceText:setColor(cc.c3b(244, 226, 144))
        end
    else
        self._iconImg:setEnabled(false)
        if not isEmpty(self._cost) then
            self._priceText:setColor(cc.c3b(108, 106, 105))
        end
    end

end

function Icon:checkIcon(iconType, attributes)

    if iconType == GameDefine.ICON_TYPE.BUILDING then
        if attributes == GameDefine.TOWER_TYPE.BARRACK_1 then
            self._iconImg:loadTexture("main_icons_0002.png",1)
            self._cost = GameDefine.TOWER_TYPE.BARRACK_1.price
        elseif attributes == GameDefine.TOWER_TYPE.ARCHER_1 then
            self._iconImg:loadTexture("main_icons_0001.png",1)
            self._cost = GameDefine.TOWER_TYPE.ARCHER_1.price
        elseif attributes == GameDefine.TOWER_TYPE.MAGIC_1 then
            self._iconImg:loadTexture("main_icons_0003.png",1)
            self._cost = GameDefine.TOWER_TYPE.MAGIC_1.price
        elseif attributes == GameDefine.TOWER_TYPE.ARTILLERY_1 then
            self._iconImg:loadTexture("main_icons_0004.png",1)
            self._cost = GameDefine.TOWER_TYPE.ARTILLERY_1.price
        else
            return
        end
        self._priceText:setString(string.format("%d",self._cost))

    elseif iconType == GameDefine.ICON_TYPE.UPDATE then
        for _, type in pairs(GameDefine.TOWER_TYPE) do
            if type == attributes then
                self._iconImg:loadTexture("main_icons_0005.png",1)
                self._cost = type.price
                break
            end
        end
        self._priceText:setString(string.format("%d",self._cost))

    elseif iconType == GameDefine.ICON_TYPE.CELL then
        for _, type in pairs(GameDefine.TOWER_TYPE) do
            if type == attributes then
                self._iconImg:loadTexture("ico_sell_0001.png",1)
                self._cost = checkint(type.price * 0.6)
                break
            end
        end
        self._priceText:setString(string.format("%d",self._cost))

    elseif iconType == GameDefine.ICON_TYPE.LOCKED then
        self._priceImg:hide()
    elseif iconType == GameDefine.ICON_TYPE.FLAG then
        self._priceImg:hide()
    else
        return
    end

    cc.Director:getInstance():getEventDispatcher():postEvent(GameDefine.GAME_EVENT.REQUEST_STATUS)

end

return Icon