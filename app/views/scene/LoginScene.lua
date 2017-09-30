local LoginScene = class("LoginScene", cc.Layer)

LoginScene.RESOURCE_FILENAME = "scene/login_scene.csb"

function LoginScene:ctor()
    
    self._rootNode = nil
    self._action = nil
    self._logo = nil
    self._startBtn = nil
    self._ldPanel = nil
    self._ldButton = {}
    self._newGame = {}
    self._loadNode = {}
    self._archive = {}
    self._star = {}
    self._levelInfo = {}

    self:init()
    self:createLogo()

end 

function LoginScene:init()

    if not isEmpty(self.RESOURCE_FILENAME) then
        self._rootNode = cc.CSLoader:createNode(self.RESOURCE_FILENAME)
        self._rootNode:setContentSize(display.size)
        ccui.Helper:doLayout(self._rootNode)
        self:addChild(self._rootNode)        
    end      
    
    if isEmpty(self._rootNode) then
        return
    end
    self._action = cc.CSLoader:createTimeline(self.RESOURCE_FILENAME)
    self._logo = self._rootNode:getChildByName("logo_img")
    self._startBtn = self._rootNode:getChildByName("start_btn")
    self._ldPanel = self._rootNode:getChildByName("ac_panel")
    self._ldPanel:hide()

    for i = 1,3 do
        local button = self._ldPanel:getChildByName(string.format("ac%d_btn",i))
        table:pushBack(self._ldButton,button)
    end
    
    for i = 1,3 do
        local button = self._ldButton[i]:getChildByName("ngame_txt")
        table:pushBack(self._newGame,button)
    end

    for i = 1,3 do
        local button = self._ldButton[i]:getChildByName("load_node")
        table:pushBack(self._loadNode,button)
    end

end

function LoginScene:createLogo()

    self._logo:show()
    self._startBtn:show()
    self._rootNode:runAction(self._action)
    self._action:play("in",false)
    self._startBtn:addClickEventListener(handler(self,self.onStartBtnClick)) 

end

function LoginScene:createMenu()

    self._ldPanel:show()
    self._archive = self._archive or {}
    self._star = self._star or {}

    for i = 1, 3 do
        if self._archive[i] and self._star[i] then -- 有存档
            self._loadNode[i]:show()
            self._loadNode[i]:getChildByName("star_txt"):setString(tostring(self._star[i]))
            self._newGame[i]:hide()
            self._ldButton[i]:addClickEventListener(function (sender)
                local msg = {}
                msg.star = self._star[i]
                msg.levelInfo = self._levelInfo[i]
                self:getEventDispatcher():postEvent(GameDefine.FRAME_EVENT.LEVEL_MAP_INIT,msg)
            end)
        else
            self._loadNode[i]:hide() -- 无存档
            self._newGame[i]:show()
            self._ldButton[i]:addClickEventListener(function (sender)
                self._gm:createArchive(i)
                self:createMenu()
            end)
        end
    end

end

function LoginScene:onStartBtnClick(sender)

    self:getEventDispatcher():postEvent(GameDefine.FRAME_EVENT.LOGINSCENE_INIT_READY)
    local function frameEndCallBack(frame)
        local str = frame:getEvent()
        if str == "menuIn" then
            self._logo:hide()
            self._startBtn:hide()
            self:createMenu()
        end
    end

    self._action:play("out",false)
    self._action:setFrameEventCallFunc(frameEndCallBack)
    self:getEventDispatcher():postEvent("")

end

return LoginScene