local Soldier = class("Soldier",require("app.views.role.BaseRole"))

Soldier.lv1 = {next = Soldier.lv2}
Soldier.lv2 = {next = Soldier.lv3}
Soldier.lv3 = {}

function Soldier:ctor(lv)
    self._cLv = nil
    self:initLv(checkint(lv))
    self:init()
end

function Soldier:init()
    self._isEnmy = false
end

function Soldier:initLv(lv)
    if lv == 1 then
        self._cLv = Soldier.lv1
    elseif lv == 2 then
        self._cLv = Soldier.lv2
    elseif lv == 3 then
        self._cLv = Soldier.lv3
    else
        self._cLv = Soldier.lv1
    end
    self._mLife = self._cLv.life
    self._cLife = self._mLife
    self._speed = self._cLv.speed
    self._damage = self._cLv.damage
end

function Soldier:upgrade()
    self._cLv = self._cLv.next
    self._mLife = self._cLv.life
    self._cLife = self._mLife
    self._speed = self._cLv.speed
    self._damage = self._cLv.damage
end

function Soldier:checkEnmy()
    
end

return Soldier