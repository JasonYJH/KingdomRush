
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("src/")
cc.FileUtils:getInstance():addSearchPath("res/")
--cc.FileUtils:getInstance():addSearchPath("res/level")

package.path = package.path .. "C:/Code/KingdomRush-L/src/?.lua;"

require "config"
require "cocos.init"
require "app.common.GlobalDefine"

local breakSocketHandle,debugXpCall = require("LuaDebugjit")("localhost",7003)
cc.Director:getInstance():getScheduler():scheduleScriptFunc(breakSocketHandle, 0.3, false) 
--如果已经存在 __G__TRACKBACK__ 请将 debugXpCall 直接加入 __G__TRACKBACK__ 即可
--__G__TRACKBACK__ 方法不是必须 debugXpCall是实现的是在lua 脚本调用错误时进行代码错误定位 
function __G__TRACKBACK__(errorMessage)  
    debugXpCall();  
end  

local function main()
    local layer = require("app.controller.SceneManager"):create():createLoginScene()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
