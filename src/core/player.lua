ClassicLFGPlayer = {}
ClassicLFGPlayer.__index = ClassicLFGPlayer

setmetatable(ClassicLFGPlayer, {
    __call = function (cls, ...)
        return cls.new(...)
    end,
})

function ClassicLFGPlayer.new(name, guild, level, class, talents)
    local self = setmetatable({}, ClassicLFGPlayer)
    self.Invited = false
    if (name ~= nil) then
        self.Name = ClassicLFG:SplitString(name, "-")[1]
    else
        self.Name = UnitName("player")
    end
    self.Guild = guild or GetGuildInfo(self.Name)
    self.Level = level or UnitLevel(self.Name)
    print(self.Name)
    if (UnitClass(self.Name) ~= nil) then
        self.Class = class or ClassicLFG.Class[select(2, UnitClass(self.Name))].Name
    else
        -- ToDo: Get Class from Player differently somehow
        self.Class = ClassicLFG.Class.WARRIOR
    end
    self.Talents = talents or self:CreateTalents()
    return self
end

function ClassicLFGPlayer:CreateTalents()
    if(self.Name == UnitName("player")) then
        local talents = {}
        talents[1] = select(3, GetTalentTabInfo(1))
        talents[2] = select(3, GetTalentTabInfo(2))
        talents[3] = select(3, GetTalentTabInfo(3))
        return talents
    end
    return nil
end

function ClassicLFGPlayer:GetSpecialization()
    local highestTalents = 1
    if (self.Talents[2] > self.Talents[highestTalents]) then
        highestTalents = 2
    end
    if (self.Talents[3] > self.Talents[highestTalents]) then
        highestTalents = 3
    end
    return ClassicLFG.Class[self.Class:upper()].Specialization[highestTalents]
end

function ClassicLFGPlayer:Equals(otherPlayer)
    return otherPlayer.Name == self.Name
end