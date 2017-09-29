local LevelPriview = class("LevelPriview",cc.Layer)
local GameDefine = require("app.models.GameDefine")
LevelPriview.RESOURCE_FILENAME = "scene/level_priview.csb"
function LevelPriview:ctor(index)
    self._rootNode = nil
    self._priviewImg = nil
    self._startBtn = nil
    self._leaveBtn = nil
    self._introduceText = nil
    self:init()
    self:touchEvent()
    self:resetImg(index)
end

function LevelPriview:init()
    if not isEmpty(self.RESOURCE_FILENAME) then
        self._rootNode = cc.CSLoader:createNode(self.RESOURCE_FILENAME)
        self:addChild(self._rootNode)        
    end
    
    if isEmpty(self._rootNode) then
        return
    end

    self._priviewImg = self._rootNode:getChildByName("priview_img")
    self._startBtn = self._rootNode:getChildByName("start_btn")
    self._leaveBtn = self._rootNode:getChildByName("leave_btn")
    self._introduceText = self._rootNode:getChildByName("introduce_txt")

    assert(loadPlist("image/scene/map_spritesheet_16_a_3-hd.plist"),"function loadPlist param invalid")

end

function LevelPriview:touchEvent()
    self._leaveBtn:addTouchEventListener(function (sender,status)
        if status == TOUCH_EVENT_ENDED then 
            self:removeSelf()
        end
    end)

    self._startBtn:addTouchEventListener(function (sender,status)
        if status == TOUCH_EVENT_ENDED then
            -- body
        end
    end)
end

function LevelPriview:resetImg(index)
    local filename = string.format("thumb_stage%d.png",checkint(index))
    self._priviewImg:loadTexture(filename,1)
--    self._priviewImg:hide()
--    local img = ccui.ImageView:create(filename,1)
--    img:setAnchorPoint(cc.p(0.5,0.5)):setPosition(cc.p(x,y)):addTo(self)
--    x,y = img:getPosition()
--    local size = img:getContentSize()
    self._introduceText:setString(GameDefine.INTRODUCE[1])
        --:ignoreContentAdaptWithSize(false)
        --:setSize(cc.size(450,300))
end

return LevelPriview