local Icon = class("Icon",cc.Node)

Icon.RESOURCE_FILENAME = "icon.csb"

function Icon:ctor(iconType, cost)
    self._rootNode = nil
    self._iconImg = nil
    self._priceImg = nil
    self._priceText = nil

    self._cost = cost
    self._litImg = nil
    self._offImg = nil
    self:checkIcon(iconType)
    self:init(iconType)
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

    if isEmpty(self._cost) then -- icon类型1，无需金币
        self:litIcon()
        self._iconImg:addClickEventListener(handler(self,self.iconClickCallBack))
    else
        local disPatcher = cc.Director:getInstance():getEventDispatcher()
        self._iconImg:addTouchEventListener(handler(self,self.iconTouchCallBack))
        disPatcher:postEvent(GameDefine.GAME_EVENT.REQUEST_STATUS)
        disPatcher:addEvent(GameDefine.GAME_EVENT.STATUS_CHANGE,self,self.statusChangeCallBack)
    end
end

function Icon:onCreate()
    loadPlist("image/ui/common_spritesheet_16_a_2-hd.plist")
    self:createIcon()
    self.confirmName = "main_icons_0019.png"
    local icon = self:getResourceNode():getChildByTag(1)
    icon:addTouchEventListener(handler(self,self.touchCallBack))
end

function Icon:statusChangeCallBack(event)
    if self._cost > event[1] then -- 金币不足
        -- 图标暗
        self._lastStatus = self._lastStatus or true
        if self._lastStatus then
            self:offIcon()
            self._lastStatus = false
        end
    else
        -- 图标亮
        self._lastStatus = self._lastStatus or false
        if not self._lastStatus then
            self:litIcon()
            self._lastStatus = true
        end
    end
end

function Icon:iconClickCallBack(event)
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

function Icon:checkIcon(iconType)
    if iconType == GameDefine.ICON_TYPE.BARRACK then
        self._litImg = "main_icons_0002.png"
        self._offImg = "main_icons_disabled_0002.png"

    elseif iconType == GameDefine.ICON_TYPE.ARCHER then
        self._litImg = "main_icons_0001.png"
        self._offImg = "main_icons_disabled_0001.png"

    elseif iconType == GameDefine.ICON_TYPE.MAGIC then
        self._litImg = "main_icons_0003.png"
        self._offImg = "main_icons_disabled_0003.png"

    elseif iconType == GameDefine.ICON_TYPE.ARTILLERY then
        self._litImg = "main_icons_0004.png"
        self._offImg = "main_icons_disabled_0004.png"

    elseif iconType == GameDefine.ICON_TYPE.UPDATE then
        self._litImg = "main_icons_0005.png"
        self._offImg = "main_icons_disabled_0005.png"

    elseif iconType == GameDefine.ICON_TYPE.CELL then
        self._litImg = "ico_sell_0001.png"
        self._offImg = nil
    else
        self.price = GameDefine.ICON_TYPE.BARRACK
        self.litName = "main_icons_0002.png"
        self.offName = "main_icons_disabled_0002.png"
    end
    self:litIcon()
end

function Icon:litIcon()
    self._iconImg:setTouchEnabled(true)
    self._iconImg:loadTexture(self._litImg,1)
    if isEmpty(self._cost) then
        self._priceImg:hide()
    else
        self._priceText:setString(string.format("%d",self._cost))
    end
    self._priceText:setColor(cc.c3b(244, 226, 144))
end

function Icon:offIcon()
    self._iconImg:setTouchEnabled(false)
    self._iconImg:loadTexture(self._offImg,1)
    self._priceText:setString(string.format("%d",self._cost))
    self._priceText:setColor(cc.c3b(108, 106, 105))
end

return Icon