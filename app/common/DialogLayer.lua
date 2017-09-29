local DialogLayer = class("DialogLayer",function ( ... )
    local arg = {...}
    if #arg == 0 then
        return cc.LayerColor:create(cc.c4b(0,0,0,0))
    else
        return cc.LayerColor:create(...)
    end
end)

function DialogLayer:ctor()
    
    self:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    
    local function onTouchEvent(event)
        
        if event == TOUCH_EVENT_BEGAN then
            return true
        elseif event == TOUCH_EVENT_ENDED then
            self:removeSelf()
        end
    end

    self:onTouch(onTouchEvent, false, true)

end

return DialogLayer