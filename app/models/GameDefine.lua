local GameDefine = {}

GameDefine.LEVELS_COUNT = 5

GameDefine.INTRODUCE = {

"??"

}

-- 图标类型
GameDefine.ICON_TYPE = {
    BUILDING  = "building",
    CELL      = "cell",
    UPDATE    = "update",
    FLAG      = "flag",
    LOCKED    = "lock"
}

-- 防御塔类型
GameDefine.TOWER_TYPE = {

    BARRACK_1   = { price = 70, rang = 150, airDefine = false},
    ARCHER_1    = { price = 70, rang = 150, airDefine = true},
    MAGIC_1     = { price = 100, rang = 150, airDefine = true},
    ARTILLERY_1 = { price = 120, rang = 120, airDefine = false}
}

-- 场景事件
GameDefine.FRAME_EVENT = {}
GameDefine.FRAME_EVENTLOGINSCENE_INIT_READY = "loginscene_init_ready"
GameDefine.FRAME_EVENTLEVEL_MAP_INIT    = "level_map_init"
GameDefine.FRAME_EVENTLEVEL_INIT        = "level_init"

-- 关卡内事件
GameDefine.GAME_EVENT = {}
GameDefine.GAME_EVENT.GAME_READY        = "game_ready"
GameDefine.GAME_EVENT.STATUS_CHANGE     = "status_change"
GameDefine.GAME_EVENT.REQUEST_STATUS    = "request_status"
GameDefine.GAME_EVENT.NEXT_ENMY_READY   = "next_enmy_ready"
GameDefine.GAME_EVENT.ENMY_CREATE       = "enmy_create"
GameDefine.GAME_EVENT.ENMY_HURT         = "enmy_hurt"
GameDefine.GAME_EVENT.ARMY_HURT         = "army_hurt"
GameDefine.GAME_EVENT.ROLE_DEATH        = "role_death"
GameDefine.GAME_EVENT.FIND_TARGET       = "find_target"
GameDefine.GAME_EVENT.GET_TARGET        = "get_target"

return GameDefine