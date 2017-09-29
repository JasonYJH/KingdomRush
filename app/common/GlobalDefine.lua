-- 加载全局模块
cc.exports.GameDefine = require("app.models.GameDefine")

local tableEx = table

function tableEx:pushBack(t,v)
    if type(t) == "table" then
        t[#t + 1] = v
    else
        printError("use invalid table")
    end
end

function log(fmt,...)
    release_print(string.format(tostring(fmt),...))
end

function isEmpty(p)
    if p == nil then
        return true
    end
    
    local t = type(p)
    if t == "number" and p == 0 then
        return true
    elseif t == "string" and #p == 0 then
        return true
    elseif t == "table" and table.nums(p) == 0 then
        return true
    end

    return false
end

function loadPlist(plistName)
    if type(plistName) ~= "string" or isEmpty(plistName) then
        return false
    end

    local cache = cc.SpriteFrameCache:getInstance()

    if cache:isSpriteFramesWithFileLoaded(plistName) then
        return true
    end

    cache:addSpriteFrames(plistName)
    return true
end

-- event ex --------------------------
local EventEx = cc.Director:getInstance():getEventDispatcher()

function EventEx:addEvent(eventName,target,callBack)
    if isEmpty(eventName) or isEmpty(target) or isEmpty(callBack) then
        return
    end

    local listener = cc.EventListenerCustom:create(eventName,function(...)
        local event = {...}
        if event then
            event = event[1]._usedata
        end
        return callBack(target,event)
    end)
    cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(listener, 1)

    return listener
end

function EventEx:postEvent(eventName,...)
    if isEmpty(eventName) then
        return
    end

    local msg = {...}
    if isEmpty(msg) then
        msg = nil
    elseif #msg == 1 then
        msg = msg[1]
    end

    local customEvent = cc.EventCustom:new(eventName)
    customEvent._usedata = msg
    cc.Director:getInstance():getEventDispatcher():dispatchEvent(customEvent)
end

function EventEx:removeEvent(eventName)
    if isEmpty(eventName) then
        return
    end

    cc.Director:getInstance():getEventDispatcher():removeCustomEventListeners(eventName)
end