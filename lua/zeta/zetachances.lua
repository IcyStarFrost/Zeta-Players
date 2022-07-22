AddCSLuaFile()

    
local IsValid = IsValid
local zetamath = {}
zetamath.random = math.random
local math = math
local util = util


function ENT:ComputeBuildChance()

    if zetamath.random(20) == 1 then
        if zetamath.random(2) == 1 and GetConVar("zetaplayer_allowphysgun"):GetBool() then
            self:ChangeWeapon('PHYSGUN')
        elseif GetConVar("zetaplayer_allowtoolgun"):GetBool() then
            self:ChangeWeapon('TOOLGUN')
        end
    end

    local buildoptions = {
        function() if !GetConVar('zetaplayer_allowentities'):GetBool() then return false end self:SpawnEntity() return true end,
        function() if !GetConVar('zetaplayer_allownpcs'):GetBool() then return false end self:SpawnNPC() return true end,
        function() if !GetConVar("zetaplayer_allowsprays"):GetBool() and zetamath.random(2) != 1 then return false end self:UseSprayer() return true end,
        function() if zetamath.random(3) != 1  then return false end self.BurstCount = 0 self.MaxBurst = zetamath.random(6, 24) self:SetState("building") return true end,
        function() if self:IsInNoclip() then return false end self:SetState("lookingbutton") return true end,
        function() self:SpawnProp() return true end,
    }

    DebugText('Decision: Chose Build ')

    for i=1, #buildoptions do
        local func = buildoptions[zetamath.random(#buildoptions)]
        local var = func()
        if var then break end
    end
end

function ENT:ComputePhysgunChance()

    DebugText('Decision: Chose Physgun')
    if self:GetWeapon() == 'PHYSGUN' then
        self:DecideOnHeldEnt()
    elseif !self.Grabbing and !self:IsInNoclip() and GetConVar("zetaplayer_allowuse+onprops"):GetBool() then
        self:FindPropToPickup()
    end

end

function ENT:ComputeCombatChance()

    local decide = zetamath.random(5)
    DebugText('Decision: Chose Combat '..decide)
    if decide == 1 and self:Health() < self:GetMaxHealth() then
        self:SpawnMedKit()
        return
    elseif decide == 2 and self.HasRangedWeapon and self.CurrentAmmo < self.MaxAmmo and self:IsChasingSomeone() then
        self:Reload()
    elseif decide == 3 and self.CurrentArmor < self.MaxArmor then
        self:SpawnArmorBattery()
        return
    elseif decide == 4 then
        if 100 * zetamath.random() < self.VoiceChance then
            self:PlayTauntSound()
        end
        self:LookforTarget(hunt)
    else
        self:LookforTarget()
        return
    end

end

function ENT:ComputeToolChance()

    DebugText('Decision: Chose Tool')
    if self:GetWeapon() == 'TOOLGUN' then
        if zetamath.random(3) == 1 then
            self.BurstCount = 0
            self.MaxBurst = zetamath.random(4, 16)
            self:SetState("toolgunbuilding")
        else
            self:UseATool()
        end
        return
    elseif 100 * zetamath.random() < 5 and GetConVar("zetaplayer_allowtoolgun"):GetBool() then
        self:ChangeWeapon('TOOLGUN')
    end

end
function ENT:ComputeWatchmediaChance()
    DebugText('Decision: Chose Media Player')
    self:CheckSurroundingsMedia()
end


function ENT:ComputeFriendlyChance()
    local decide = zetamath.random(3)
    if decide == 1 then
        self:FindHurtEnt()
        return
    elseif decide == 2 and zetamath.random(2) == 1 then
        self:FindMusicBoxes()
    elseif decide == 3 then
        self:FindGPokerTable()
    end
end



function ENT:ComputeVehicleChance()
    if GetConVar("zetaplayer_allowvehicles"):GetBool() then
        self:FindVehicle()
    end
end
