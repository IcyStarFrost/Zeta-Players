-----------------------------------------------
-- Hook stuff
--- Most of this is pretty self explanatory 
-----------------------------------------------
AddCSLuaFile()

function ENT:BodyUpdate()
    self:BodyMoveXY()
end

local IsValid = IsValid


local oldisvalid = IsValid

local function IsValid( ent )
    if oldisvalid( ent ) and ent.IsZetaPlayer then
        
        return !ent.IsDead 
    else
        return oldisvalid( ent )
    end
end

function ENT:OnKilled(dmginfo)
    if self.IsDead then return end

    local zetastats = file.Read("zetaplayerdata/zetastats.json")

    if zetastats then
        zetastats = util.JSONToTable(zetastats)

        if zetastats then

            zetastats["kills"] = zetastats["kills"] and zetastats["kills"]+1 or 1

            zetastats["mostdeaths"] = zetastats["mostdeaths"] or {}

            local skillissuezetas = zetastats["mostdeaths"]

            skillissuezetas[self.zetaname] = skillissuezetas[self.zetaname] and skillissuezetas[self.zetaname]+1 or 1 

            ZetaFileWrite("zetaplayerdata/zetastats.json",util.TableToJSON(zetastats,true))
        else 
            ZetaFileWrite("zetaplayerdata/zetastats.json","[]")
        end
    end
    
    
    if ( SERVER ) then


        if IsValid( self.Spawner ) then
            self.Spawner.Friends = self.Friends
        end

        if IsValid(self.Vehicle) then
            self.Vehicle:SetSaveValue("m_hNPCDriver", NULL)
            self.Vehicle:StartEngine(false)
        end

        if GetConVar("zetaplayer_callonnpckilledhook"):GetBool() then
            hook.Run("OnNPCKilled",self,dmginfo:GetAttacker(),dmginfo:GetInflictor())
        end

        local color = self.PlayermodelColor


        net.Start('zeta_createcsragdoll', true)
            net.WriteEntity(self)
            net.WriteVector(color)
        net.Broadcast()

        local ragdoll = self:BecomeRagdoll( dmginfo )

        self.DeathRagdoll = ragdoll
        self:SetNW2Entity('zeta_ragdoll', ragdoll)
        if GetConVar("zetaplayer_allowvoicepopup"):GetInt() == 1 then
            local zetaID = self:GetCreationID()
            if self.ZetaSpawnerID != nil then zetaID = self.ZetaSpawnerID end
            net.Start("zeta_removevoicepopup",true)
            net.WriteInt(zetaID,32)
            net.Broadcast() 
        end

        self.Killed = true

        if IsValid(dmginfo:GetAttacker()) and dmginfo:GetAttacker():IsPlayer() then
            dmginfo:GetAttacker():AddFrags( 1 )
        end

        if dmginfo:GetDamageType() == DMG_FALL then
            self.KillReason = self.zetaname..' fell to their death '
            sound.Play("physics/body/body_medium_break"..math.random(2,4)..".wav", self:GetPos(), 80, 100, 1)
        elseif dmginfo:GetDamageType() == DMG_DROWN then
            self.KillReason = self.zetaname..' drowned '
        end


        self:DeathFunction(dmginfo)
        local weapon


        if GetConVar("zetaplayer_dropweapons"):GetInt() == 1 and !_ZetaWeaponDataTable[self.Weapon].hidewep and !_ZetaWeaponDataTable[self.Weapon].noweapondrop then
            weapon = ents.Create("prop_physics")
            if IsValid(weapon) then
                weapon:SetModel(self.WeaponENT:GetModel())
                weapon:SetPos(self.WeaponENT:GetPos())
                weapon:SetOwner(self)
                weapon.IsZetaProp = true
                weapon:SetAngles(self.WeaponENT:GetAngles())
                weapon:Spawn()
                weapon:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
                if self.Weapon == "PHYSGUN" then
                    for k, v in ipairs(weapon:GetMaterials()) do
                        if string.EndsWith(v, 'w_physics_sheet') then
                            weapon:SetSubMaterial(k, 'models/weapons/zetaphysgun/w_physics_sheet2')
                        end
                    end
                    weapon:SetNW2Vector('zeta_physcolor', self.PhysgunColor)
                    weapon:SetSkin(1)
                end
                local phys = weapon:GetPhysicsObject()
                if IsValid(phys) then
                    phys:SetMass(50)
                    phys:ApplyForceCenter(dmginfo:GetDamageForce())
                end
                if GetConVar('zetaplayer_cleanupcorpse'):GetInt() == 1 then
                    timer.Simple(GetConVar('zetaplayer_cleanupcorpsetime'):GetInt(),function()
                        if IsValid(weapon) then
                            weapon:Remove()
                        end
                    end)
                end
            end
        end

        if IsValid(dmginfo:GetInflictor()) and dmginfo:GetInflictor():GetClass() == 'prop_combine_ball' then
            ragdoll:Dissolve()
        else
        
        if isfunction(_ZetaWeaponDataTable[self.Weapon].dropCallback) then
            _ZetaWeaponDataTable[self.Weapon].dropCallback(self, self.WeaponENT, weapon)
        end

        if GetConVar('zetaplayer_cleanupcorpse'):GetInt() == 1 then
            local targ = ragdoll
            timer.Simple(GetConVar('zetaplayer_cleanupcorpsetime'):GetInt(),function()
                if !targ:IsValid() then return end
                if GetConVar('zetaplayer_cleanupcorpseeffect'):GetInt() == 1 then
                targ:Disintegrate()
                else
                    if GetConVar("zetaplayer_explosivecorpsecleanup"):GetInt() == 1 then
                        util.BlastDamage( targ, targ, targ:GetPos(), 250, math.random(1,500) )

                        local effectdata = EffectData()
                        effectdata:SetOrigin( targ:GetPos() )
                        targ:EmitSound("BaseExplosionEffect.Sound")
                        util.Effect( "Explosion", effectdata, true, true )
                    end
                    targ:Remove()
                end
            end)
        end
    end
        net.Start('zeta_playermodelcolor',true)
        net.WriteEntity(ragdoll)
        net.WriteVector(color)
        net.Broadcast()
    end
    
    timer.Simple( 0.1, function()
        
        if oldisvalid( self ) then
            self:Remove()
        end

    end )

    self.IsDead = true

end


function ENT:OnInjured(dmginfo)
    if self.PlayingPoker then return end
    local postHP = (self:Health() - dmginfo:GetDamage())
    if postHP <= 0 then return end


    if self.IsDriving then return end
    if IsValid(dmginfo:GetInflictor()) and dmginfo:GetInflictor():GetClass() == 'prop_physics' then return end

    local attacker = dmginfo:GetAttacker()
    if self:IsFriendswith(attacker) then
        -- UPD: If zeta no longer trusts his friend, continue executing the code below
        -- Otherwise, forgive him
        if math.random(10) == 1 then
            self:RemoveFriend(attacker)
        else
            return
        end

        if GetConVar("zetaplayer_nohurtfriends"):GetBool() then
            return
        end
    end

    if self:IsInTeam(attacker) then 

    return
    end

    if postHP <= (self:GetMaxHealth() * GetConVar('zetaplayer_panicthreshold'):GetFloat()) and math.random(3) == 1 then
        local fleeEnt = (string.StartWith(self.State, 'chase') and self.Enemy or attacker)
        self:Panic(fleeEnt)
        return
    end

    if !self.HasLethalWeapon and math.random(1,2) == 1 then
        self:ChooseLethalWeapon()
    end

    if self.HasLethalWeapon and attacker != self and self:GetState() != 'panic' and (attacker:IsPlayer() and !GetConVar('ai_ignoreplayers'):GetBool() or attacker:IsNPC() or attacker:IsNextBot() and (!attacker.IsZetaPlayer or (!GetConVar('zetaplayer_ignorefriendlyfirebyzeta'):GetBool() or attacker:GetEnemy() == self))) then
        -- UPD: If I'm already attacking someone and the attacker is closer to me than my enemy, change my enemy to the attacker
        if self:GetState() == 'chasemelee' or self:GetState() == 'chaseranged' then
            local curEne = self:GetEnemy()
            if IsValid(curEne) and curEne != attacker and self:GetRangeSquaredTo(curEne) > self:GetRangeSquaredTo(attacker) then

                self:SetEnemy(attacker)
                if self:GetState() == 'chasemelee' then
                    self:CancelMove()
                    self:SetState('idle')
                    self:SetState('chasemelee')
                end
            end
        -- Otherwise, if self-defense is enabled, defend from the attacker
        elseif GetConVar('zetaplayer_allowselfdefense'):GetBool() then
            if math.random(100) < self.VoiceChance then
                self:PlayTauntSound()
            end

            self.Delayattack = false
            self:CancelMove()
            self:SetEnemy(attacker)
            self:SetState('chase'..(self.HasMelee and 'melee' or 'ranged'))
        end
    end
end

function ENT:OnStuck()

end

function ENT:OnLeaveGround()
    if self.IsDriving or self:IsInNoclip() then return end
    if !self.IsJumping then
        self:SetLastActivity(self:GetActivity())
    elseif self.DSteps_ConVar:GetBool() and self.DSteps_Function then
        self.DStep_Fidget = true
        self:EmitStepSound(80, 1)
    end
    self.InAir = true
    self:StartActivity(self:GetActivityWeapon('jump'))
    local selfpos = (self:GetPos() + self:OBBCenter())
    local heightTest = util.TraceHull({start = selfpos, endpos = selfpos - self:GetUp()*9000000, maxs = self:OBBMaxs(), mins = self:OBBMins(), filter = {self}})
    if heightTest.HitPos:DistToSqr(selfpos) > (1024*1024) then
        self:PlayFallingSound()
    end
end



function ENT:OnLandOnGround()
    if self.IsDriving or self:IsInNoclip() then return end
    if self.FirstSpawned then self.FirstSpawned = false return end
    if !self.PreventFalldamage and self:WaterLevel() <= 0 and GetConVar("zetaplayer_allowfalldamage"):GetBool() then
        local fallDmg = (self.FallVelocity - 526.5) * (100.0 / (922.5 - 526.5))
        if fallDmg > 0 then
            local dmginfo = DamageInfo()
            dmginfo:SetDamage(!GetConVar("zetaplayer_allowrealisticfalldamge"):GetBool() and 10 or fallDmg)
            dmginfo:SetAttacker(self)
            dmginfo:SetInflictor(self)
            dmginfo:SetDamageType(DMG_FALL)
            self:TakeDamageInfo(dmginfo)
            sound.Play("Player.FallDamage", self:GetPos())
        end
    end
    if self.DSteps_ConVar:GetBool() and self.DSteps_Function then
        local speed = self:GetVelocity():Length()
        if speed > 150 then 
            self.DStep_HitGround = speed
            self:EmitStepSound(80, 1)
        end
    end
    self.JumpDirection = nil
    self.FallVelocity = 0
    self.InAir = false
    self.IsJumping = false
    self:StartActivity(self:GetActivityWeapon((self.IsMoving and "move" or "idle")))
    if !self.IsMingebag then
        self:RemoveGesture(ACT_LAND)
        self:AddGesture(ACT_LAND, true)
    end
end

function ENT:OnRemove()
    
    if SERVER then
        --PrintMessage(HUD_PRINTTALK, "Removed")
        _ZETACOUNT = _ZETACOUNT - 1

        

--[[         if timer.Exists( "zetaremovespeakinglimit" .. self:EntIndex() ) then
            _ZETASPEAKINGLIMIT = _ZETASPEAKINGLIMIT - 1
        end ]]

        local friends = self:GetFriends()
        for _,v in pairs(friends) do
            if istable(v.Friends) then
                v.Friends[self:GetCreationID()] = nil
            end
        end

        if GetConVar("zetaplayer_removepropsondeath"):GetBool() then
            for k,ent in ipairs(self.SpawnedENTS) do
                if IsValid(ent) then
                    ent:Remove()
                end
            end
        end

    end

    if SERVER and !self.Killed then
        -- DrGBase's Execution Support
        if self:IsFlagSet(FL_TRANSRAGDOLL) then
            local ragdoll = self
            for _, v in ipairs(ents.FindByClass("prop_ragdoll")) do
                if v:GetModel() == self:GetModel() and v.EntityClass != nil and !v.ZetaMarked then
                    ragdoll = v
                    ragdoll.ZetaMarked = true
                    net.Start('zeta_playermodelcolor', true)
                        net.WriteEntity(ragdoll)
                        net.WriteVector(self.PlayermodelColor)
                    net.Broadcast()
                    break
                end
            end
    
            if GetConVar('zetaplayer_allowdeathvoice'):GetBool() then
                local sndLvl = self:GetCurrentVoiceSNDLEVEL()
                local sndName = 'vo/k_lab/kl_ahhhh.wav'
                if self.DEATHVOICEPACKEXISTS then
                    sndName = "zetaplayer/custom_vo/"..self.VoicePack.."/".."death/death"..math.random(self.DeathSoundCount)..".wav"
                elseif GetConVar('zetaplayer_usealternatedeathsounds'):GetBool() then
                    local rnd = math.random(79 + self.DeathSoundCount)
                    if self.UseCustomDeath or rnd > 79 or GetConVar("zetaplayer_customdeathlinesonly"):GetBool() then
                        sndName = "zetaplayer/custom_vo/death/death"..math.random(self.DeathSoundCount)..".wav"
                    else
                        sndName = 'zetaplayer/vo/death/atlternatedeath'..rnd..'.wav'
                    end
                end

                local sndPitch = self.VoicePitch
                local sndDur = SoundDuration(sndName) * (100 / sndPitch)
                local sndID = self:GetCreationID()
                if self.ZetaSpawnerID != nil then sndID = self.ZetaSpawnerID end

                net.Start('zeta_voiceicon',true)
                    net.WriteEntity(ragdoll)
                    net.WriteFloat(sndDur)
                net.Broadcast()

                if GetConVar("zetaplayer_allowvoicepopup"):GetInt() == 1 then
                    local popupColor = ((self.TeamColor and GetConVar("zetaplayer_voicepopup_useteamcolor"):GetBool()) and self.TeamColor or Color(0, 255, 0))
                    net.Start("zeta_voicepopup",true)
                        net.WriteString(self.zetaname)
                        net.WriteString(self.ProfilePicture)
                        net.WriteFloat(sndDur)
                        net.WriteInt(sndID, 32) -- sndID for 'ENT:OnRemove()'
                        net.WriteColor(popupColor)
                    net.Broadcast()
                end

                if GetConVar("zetaplayer_usenewvoicechatsystem"):GetBool() then
                    local sndFlags = (sndLvl != 0) and '3d ' or ''
                    net.Start("zeta_playvoicesound", true)
                        net.WriteEntity(ragdoll)
                        net.WriteInt(sndID, 32)
                        net.WriteString('sound/'..sndName)
                        net.WriteString(sndFlags..'mono')
                        net.WriteBool(false)
                        net.WriteInt(sndPitch, 32)
                    net.Broadcast()
                else
                    ragdoll:EmitSound(sndName, sndLvl, sndPitch, GetConVar('zetaplayer_voicevolume'):GetFloat(), CHAN_AUTO, 0, self.VoiceDSP)
                end
            end

            local executer = NULL
            for _, v in ipairs(ents.FindByClass("npc_*")) do
                if v.IsDrGNextbot and v._DrGBaseGrabbedRagdolls[ragdoll] != nil then
                    executer = v
                    break
                end
            end
            if IsValid(executer) then
                local data = {
                    attacker = "#"..executer:GetClass(),
                    attackerteam = -1,
                    inflictor = " ",
                    victim = self.zetaname,
                    victimteam = self:GetRealTeamIndex()
                }
            
                net.Start('zeta_addkillfeed', true)
                    net.WriteString(util.TableToJSON(data))
                    net.WriteBool(false)
                net.Broadcast()  
        
                if GetConVar('zetaplayer_consolelog'):GetBool() then
                    local logText = (self.zetaname..' was killed by '..tostring(executer))
                    MsgAll('ZETA: '..logText)
                    if GetConVar("zetaplayer_showzetalogonscreen"):GetBool() then
                        net.Start("zeta_sendonscreenlog", true)
                            net.WriteString(logText)
                            net.WriteColor(Color(255, 38, 38), false)
                        net.Broadcast()
                    end
                end
            end
        else
            if GetConVar("zetaplayer_allowvoicepopup"):GetInt() == 1 and self.IsSpeaking then
                local zetaID = self:GetCreationID()
                if self.ZetaSpawnerID != nil then zetaID = self.ZetaSpawnerID end
                net.Start("zeta_removevoicepopup",true)
                net.WriteInt(zetaID,32)
                net.Broadcast() 
            end
        end

        timer.Remove("zetafireweapon"..self:EntIndex())
        hook.Remove("ZetaPlayerSay","zetaplayersayhook"..self:EntIndex())
        hook.Remove("PlayerSay","zetarealplayersay"..self:EntIndex())
        hook.Remove("ZetaRealPlayerEndVoice","zetarealplayerspoke"..self:EntIndex())
    end
    self.IsDead = true

    if IsValid(self.ConversePartner) and self.ConversePartner:IsPlayer() then
        self.ConversePartner.ConversePartner = nil
    end
    if IsValid(self.HeldOffender) then
        self.HeldOffender.AdminHandled = false
        if self.HeldOffender.IsJailed then
            self:COMMAND_UnJail(self.HeldOffender)
        end
        self.HeldOffender.IsJailed = false
        self.HeldOffender.InSit = false
    end

    if ( CLIENT ) then
        if IsValid(self.proj) then
            self.proj:Remove()
        end
    end
end

function ENT:OnOtherKilled(victim,dmginfo)

    local attacker = dmginfo:GetAttacker()


    if attacker == self then
        local wepData = _ZetaWeaponDataTable[self.Weapon]
        if wepData and wepData.onKillCallback then
            wepData:onKillCallback(self, self.WeaponENT, victim, dmginfo)
        end
        self.Kills = self.Kills + 1
        self:SetNW2Int("zeta_kills",self.Kills)
    end

    if self:GetState() == 'driving' then return end
    if !self:IsValid() then return end
    if self:GetState() == 'chasemelee' or self:GetState() == 'chaseranged' then

        
        if IsValid(attacker) and (victim:IsPlayer() or victim.IsZetaPlayer) and attacker == self then
            local zetastats = file.Read("zetaplayerdata/zetastats.json")

            if zetastats then
                zetastats = util.JSONToTable(zetastats)

                if zetastats then
                    zetastats["topzetas"] = zetastats["topzetas"] or {}

                    local topzetas = zetastats["topzetas"]

                    topzetas[self.zetaname] = topzetas[self.zetaname] and topzetas[self.zetaname]+1 or 1 

                    ZetaFileWrite("zetaplayerdata/zetastats.json",util.TableToJSON(zetastats,true))
                else 
                    ZetaFileWrite("zetaplayerdata/zetastats.json","[]")
                end
            end
        end


        if victim == self:GetEnemy() then
            if !self:IsValid() then return end
            timer.Remove("zetastrafe"..self:EntIndex())
            self:CancelMove()
            self:SetState('idle')
            if attacker == self then
                if 100 * math.random() < self.VoiceChance then
                    self:PlayKillSound()
                end
                if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
                    if victim:GetClass() == 'npc_zetaplayer' then
                    MsgAll('ZETA: ',self.zetaname..' killed ',victim:GetNW2String('zeta_name','Zeta Player')," using a "..self.PrettyPrintWeapon)
                    if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                        net.Start("zeta_sendonscreenlog",true)
                        net.WriteString(self.zetaname..' killed ',victim:GetNW2String('zeta_name','Zeta Player')," using a "..self.PrettyPrintWeapon)
                        net.WriteColor(Color(255,38,38),false)
                        net.Broadcast()
                    end
                    else
                        if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                            net.Start("zeta_sendonscreenlog",true)
                            net.WriteString(self.zetaname..' killed ',tostring(victim)," using a "..self.PrettyPrintWeapon)
                            net.WriteColor(Color(255,38,38),false)
                            net.Broadcast()
                        end
                        MsgAll('ZETA: ',self.zetaname..' killed ',victim," using a ",self.PrettyPrintWeapon)
                    end
                end
                
            end

            if IsValid(attacker) and attacker != self then
                if 100 * math.random() < self.VoiceChance then
                    timer.Simple(math.random(0.0,1.0),function()
                        if !IsValid(self) then return end
                        self:PlayAssistSound()
                    end)
                end
            end



            self:SetEnemy(nil)
            self:StopFacing()
            self:StopLooking()
            hook.Run('OnChangePoseParam')
            if math.random(0,self.DisrespectChance) == self.DisrespectChance then
                self:Disrespect(victim:GetPos())
            end
            timer.Simple(0,function()
                if !IsValid(self) then return end
                self:SetNW2Bool( 'zeta_aggressor', false )
            end)

            if IsValid(attacker) and (attacker:IsPlayer() or attacker.IsZetaPlayer) and self:GetEnemy() != attacker and math.random(1,15) == 1 then
                if GetConVar("zetaplayer_enablefriend"):GetInt() == 1 then
                    self:AddFriend(attacker)
                end
            end


            if IsValid(attacker) and victim:IsPlayer() and attacker == self then
                self.achievement_PlayerKiller = self.achievement_PlayerKiller + 1

                if self.achievement_PlayerKiller == self.achievement_PlayerKillerMax then
                    self:AwardAchievement("Real Player Nemesis")
                end
            elseif IsValid(attacker) and attacker == self and victim.IsZetaPlayer then
                self.achievement_Berserker = self.achievement_Berserker + 1

                if self.achievement_Berserker == self.achievement_BerserkerMax then
                    self:AwardAchievement("Berserker")
                end
            end

            if 100 * math.random() < self.TextChance and GetConVar("zetaplayer_allowtextchat"):GetInt() == 1 then
                if victim:IsPlayer() or victim.IsZetaPlayer then
                    self.text_keyent = victim:IsPlayer() and victim:GetName() or victim.IsZetaPlayer and victim.zetaname
                    self:TypeMessage("insult")
                end
            end
        end

    end

    if IsValid(attacker) and attacker:IsNPC() and attacker:Health() >= 250 and math.random(1,3) == 1 then
        if !self:CanSee(attacker) then return end
        if !self.HasLethalWeapon then
            self:ChooseLethalWeapon()
        end

        if self.HasMelee and self:GetState() != 'panic' and attacker != self then
            if GetConVar('zetaplayer_allowdefendothers'):GetInt() == 0 then return end
            if self.Weapon == 'NONE' then return end
            if attacker:IsPlayer() and GetConVar('ai_ignoreplayers'):GetInt() == 1 then return end
            self.Delayattack = false
            self:CancelMove()
            self:SetEnemy(attacker)
            self:SetState('chasemelee')
            return
        end

        if !self.HasMelee and self:GetState() != 'panic' and attacker != self then
            if GetConVar('zetaplayer_allowdefendothers'):GetInt() == 0 then return end
            if attacker:IsPlayer() and GetConVar('ai_ignoreplayers'):GetInt() == 1 then return end
            if self.Weapon == 'NONE' then return end
            if self.Weapon == 'PHYSGUN' and !self.Grabbing then return end
            self.Delayattack = false
            self:CancelMove()
            self:SetEnemy(attacker)
            self:SetState('chaseranged')
            
            return
        end
    end
    if victim:GetPos():Distance(self:GetPos()) <= self.SightDistance then
        local pos = victim:GetPos()
    local witnesstest = util.TraceLine({start = self:GetPos()+Vector(0,0,60),endpos = victim:GetPos()+Vector(0,0,60),filter = self})
    if !witnesstest.Hit then
        if self.Debug == true then
            DebugText('DeathWitness: Witnessed a death and reacting')
        end


    
        if math.random(1,20) == 1 then
            if self.IsMoving == true then
                self:CancelMove()
            end
            self:Panic(attacker)
        else
            local rnd = math.random(1,10)
        if rnd == 1 then

            if GetConVar('zetaplayer_allowwitnesssounds'):GetInt() == 1 then
                self:PlayWitnessSound(victim)
            end

            self:LookAt(victim:GetPos(),'head',3)

        elseif rnd == 2 then

            if GetConVar('zetaplayer_allowlaughing'):GetInt() == 1 then
                self:LaughAt(victim)
            end

        end
        end
    else
        if self.Debug == true then
            DebugText("DeathWitness: A Death happened nearby but I didn't see it. "..'Only saw '..tostring(witnesstest.Entity))
        end
    end
else
    if self.Debug == true then
        DebugText("DeathWitness: A Death happened but it was far")
    end
end
end


function ENT:OnNavAreaChanged(  old,  new )
    if !IsValid(new) or !IsValid(old) then return end
    self.CurrentNavArea = new
    local attributes = new:GetAttributes()
    self.CanJump = (attributes != NAV_MESH_STAIRS and attributes != NAV_MESH_NO_JUMP)
end


-----------------------------------------------