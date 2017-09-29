local GameDefine = {}

GameDefine.LEVELS_COUNT = 5

GameDefine.SHOW_LEVEL_MAP_EVENT = "show_levelMap_scene"

GameDefine.INTRODUCE = {

"??"

}

GameDefine.ICON_TYPE = {
    BARRACK   = {70},
    ARCHER    = {70}, 
    MAGIC     = {100}, 
    ARTILLERY = {120}, 
    CELL      = {0}, 
    UPDATE    = {0}, 
    FLAG      = {0},
    LOCKED    = {0}
}

GameDefine.FRAME_EVENT = {
    LOGINSCENE_INIT_READY = "loginscene_init_ready",
    LEVEL_MAP_INIT    = "level_map_init",
    LEVEL_INIT        = "level_init"
}

GameDefine.GAME_EVENT = {
    GAME_READY        = "game_ready",
    STATUS_CHANGE     = "status_change",
    REQUEST_STATUS    = "request_status",
    NEXT_ENMY_READY   = "next_enmy_ready",
    ENMY_CREATE       = "enmy_create",
    ENMY_HURT         = "enmy_hurt",
    ARMY_HURT         = "army_hurt",
    ROLE_DEATH        = "role_death",
    FIND_TARGET       = "find_target",
    GET_TARGET        = "get_target"
}

return GameDefine