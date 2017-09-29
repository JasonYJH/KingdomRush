local DialogLayer = class("DialogLayer",function ( ... )
    return cc.LayerColor:create(cc.c4b(0,0,0,0))
end)

function DialogLayer:ctor()
    
    self:setTouchMode(cc.TOUCHES_ONE_BY_ONE)
    
    local function onTouchEvent(event)
        
        if event.name == "began" then
            return true
        elseif event.name == "ended" then
            self:removeSelf()
        end
    end

    self:onTouch(onTouchEvent, false, true)

end

return DialogLayer