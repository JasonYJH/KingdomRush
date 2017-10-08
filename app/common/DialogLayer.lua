-- local DialogLayer = class("DialogLayer",function ( ... )
--     return cc.Layer:create()
-- end)

local DialogLayer = class("DialogLayer", cc.Layer)

function DialogLayer:ctor()
    
    --self:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    
    local function onTouchEvent(event)
        if event.name == "began" then
            return true
        elseif event.name == "ended" then
            self:removeTouch()
            self:removeSelf()
            self = nil
        end
    end

    self:onTouch(onTouchEvent, false, true)

end

return DialogLayer