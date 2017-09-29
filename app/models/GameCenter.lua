local GameCenter = {}
local json = require("json")
local GameDefine = require("app.models.GameDefine")

function GameCenter:readArchiveInfo( archive )

    if isEmpty(archive) then
        return 
    end

    local filePath = cc.FileUtils:getInstance():fullPathForFilename("app/models/archivesInfo.json")
    local file = io.open(filePath,"r")
    local info = file:read("*all")
    file.close()
    local infoJ = json.decode(info) -- json中解析得到table
    local root = infoJ.archives
    
    if isEmpty(root[archive]) then
        return nil
    end

    local achivement = root[archive].star
    local infoTable = {}

    for i=1,GameDefine.LEVELS_COUNT do
        local str = string.format( "lv%d",i )
        table:pushBack(infoTable,root[archive][str])
    end

    return archive,achivement,infoTable --关卡 成就 各关信息

end

function GameCenter:createArchive(archive)
    if isEmpty(archive) then
        return false
    end

    local filePath = cc.FileUtils:getInstance():fullPathForFilename("app/models/archivesInfo.json")
    local file = io.open(filePath,"r")
    local info = file:read("*all")
    file.close()
    local infoR = json.decode(info) -- json中解析得到table
    local root = infoR.archives

    if not isEmpty(root[archive]) then
        return false
    end

    root[archive] = {
        star = 0,
        lv1 = 0,
        lv2 = 0,
        lv3 = 0,
        lv4 = 0,
        lv5 = 0
    }

    info = json.encode(infoR)
    local file = io.open(filePath,"w")
    file:write(info)
    file.close()
    return true
end

function GameCenter:writeArchiveInfo(archive,star,msg)
    if isEmpty(archive) or isEmpty(level) or isEmpty(msg) then
        return 
    end

    local filePath = cc.FileUtils:getInstance():fullPathForFilename("app/models/archivesInfo.json")
    local file = io.open(filePath,"w+")
    local info = file:read("*all")
    local infoR = json.decode(info) -- json中解析得到table
    local root = infoR.archives
    
    if isEmpty(root[archive]) then
        printError("THE ARCHIVE INVALID")
        return false
    end

    root[archive].star = star

    local str = string.format( "lv%d",level )
    root[archive][str] = msg

    for i=1,GameDefine.LEVELS_COUNT do
        local str = string.format( "lv%d",i )
        root[archive][str] = msg[str]
    end

    -- 写入
    info = json.encode(infoR)
    file:write(info)
    file.close()
end

function GameCenter:readLevelInfo(levelID)
    local status = nil
    local path = nil
    local enmy = nil

    levelID = checkint(levelID)
    str = string.format( "app/models/level_%d.json",levelID )
    local filePath = cc.FileUtils:getInstance():fullPathForFilename(str)
    local file = io.open(filePath,"r")
    local info = file:read("*all")
    file.close()
    local infoR = json.decode(info)
    local root = infoR.level
    status = root.status

    path = root.path

    enmy = root.enmy
    return status, path, enmy
end

return GameCenter