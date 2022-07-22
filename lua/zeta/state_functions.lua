-----------------------------------------------
-- State Functions
--- This is where Zeta's Decision system resides
-----------------------------------------------
AddCSLuaFile()
    
local IsValid = IsValid
local zetamath = {}
zetamath.random = math.random

ENT.AllowedStates = { -- List of states that are allowed to have universal actions
    ['idle'] = true 
}
ENT.LookStates = {
    ['idle'] = true,
    ["watching"] = true,
    ["lookingbutton"] = true,
    ["findingconverse"] = true
}

function ENT:ChooseNextUniversalAction() -- Universal actions can happen anytime or restricted to idle
    if self.Weapon != "PHYSGUN" then 
        if self.Grabbing then
            local decide = zetamath.random(5)
            if decide == 1 then
                self:DropHeldprop()
            elseif decide == 2 then
                self:ThrowHeldprop()
            end
        end
    elseif 100 * zetamath.random() < self.PhysgunChance then
        self:DecideOnHeldEnt(true)
    end

    if GetConVar("zetaplayer_allowkillbind"):GetBool() and zetamath.random(100) == 1 and !self.PlayingPoker then
        self:Killbind()
    end

    if GetConVar("zetaplayer_allowcreatingvotes"):GetBool() and zetamath.random(1,300) < 5 then
        self:DispatchRandomVote()
    end

    if self:IsChasingSomeone() then
        local decide = zetamath.random(4)
        if decide == 1 and self.Weapon != "GRENADE" and GetConVar("zetaplayer_allowgrenades"):GetBool() and self:CanSee(self:GetEnemy()) then
            self:ThrowGrenade(self:GetEnemy())
        end
    else
        if self.HasRangedWeapon and self.CurrentAmmo < self.MaxAmmo and zetamath.random(2) == 1 then
            self:Reload()
        end

        if self.Weapon == "C4" and zetamath.random(4) == 1 then
            self:FireWeapon(self)
        end
    end

    if self.LookStates[self:GetState()] and GetConVar("zetaplayer_casuallooking"):GetBool() then
        local pos = self:GetPos() + VectorRand(-500, 500)
        if zetamath.random(3) == 1 then
            local insight = self:FindInSight(self.SightDistance, function(ent) return IsValid(ent) end)
            if #insight > 0 then pos = insight[zetamath.random(#insight)] end
        end

        local lookAtTicks = zetamath.random(100, 400)
        local lookAtChance = zetamath.random(2)
        if !self.IsMoving or lookAtChance == 1 then
            self:LookAt2("zetalookatboth", lookAtTicks, pos)
        end
        if self.IsMoving or lookAtChance == 1 then
            self:Face2("zetalookatboth2", lookAtTicks, pos, 5)
        end
    end

    local curState = self:GetState()
    local decisions = {
        function() if self.AllowedStates[curState] then self:ChooseDifferentWeapon() end end,
        function() if self.AllowedStates[curState] then self:LookAt2("zetalookat", 200, self:GetPos() + VectorRand(-100, 100)) end end,
        function() if self.AllowedStates[curState] and self.Grabbing then
            self:ApproachPhysgunDist(zetamath.random(150, 2000))
            DebugText('Changed Physgun Distance') 
        end end,
        function() if self.AllowedStates[curState] then self:LookAtTick(self:GetPos() + VectorRand(-300, 300), 'both', 200) end end,
        function() if self.AllowedStates[curState] then 
            self:CreateThinkFunction("UndoEntities", (zetamath.random(2, 10) / 10), zetamath.random(10), function()
                self:UndoLastEnt()
            end)
        end end,
        function() if self.AllowedStates[curState] then 
            if !self.InAir then
                self.IsJumping = true 
                self:SetLastActivity(self:GetActivity())
                self.loco:Jump()
            elseif self.IsMoving then
                self:CreateThinkFunction("JumpWhileMoving", 1, zetamath.random(3, 10), function()
                    if !self.IsMoving or !self.loco:IsOnGround() then return "stop" end
                    self.IsJumping = true 
                    self:SetLastActivity(self:GetActivity())
                    self.loco:Jump()
                end)
            end 
        end end,
        function() self:RequestViewShot() end,
        function() if self.AllowedStates[curState] and zetamath.random(5) == 1 then
            self:CancelMove()
            self:SetState("actcommands")
        end end,
        function() self:UseGestures() end,
        function() if self.IsAdmin and zetamath.random(2) == 1 and #self:GetAllowedCommands() > 0 then 
            self:CancelMove()
            self:SetState("usingcommand")
        end end,
        function() if self.AllowedStates[curState] and GetConVar("zetaplayer_allowconversations"):GetBool() and 100 * math.random() < GetConVar("zetaplayer_startconversationchance"):GetInt() then
            self:CancelMove()
            self:SetState("findingconverse")
        end end
    }
    decisions[zetamath.random(#decisions)]()
end



function ENT:ChooseNextIdleAction() -- New Decision System has been set in place V V V V V    
    local kothents = ents.FindByClass("zeta_koth")
    local flags = self:GetCTFFlags()
    local zones = self:GetCaptureZones()

    if #flags > 0 and self.zetaTeam then

        if !IsValid(self.Flagent) then
            self.Flagent = flags[zetamath.random(#flags)]
        elseif IsValid(self.Flagent) and zetamath.random(1,3) == 1 then
            self.Flagent = flags[zetamath.random(#flags)]
        end

        if !self.HasFlag then
            local rand = VectorRand(-50,50)
            rand[3] = 0
            moveToPos = self.Flagent:GetPos()+rand

            self:StartActivity(self:GetActivityWeapon('move'))
            self:SetLastActivity(self:GetActivityWeapon('move')) 
            self.loco:SetDesiredSpeed(self:GetTravelDistance(moveToPos) >= 1000 and 400 or 200)
            self:MoveToPos(moveToPos)
            self:StartActivity(self:GetActivityWeapon('idle')) 
        else
            local zone = zones[math.random(#zones)]
            if !zone then return end
            local rand = VectorRand(-50,50)
            rand[3] = 0
            moveToPos = zone:GetPos()+rand

            self:StartActivity(self:GetActivityWeapon('move'))
            self:SetLastActivity(self:GetActivityWeapon('move')) 
            self.loco:SetDesiredSpeed(self:GetTravelDistance(moveToPos) >= 1000 and 400 or 200)
            self:MoveToPos(moveToPos)
            self:StartActivity(self:GetActivityWeapon('idle')) 
        end


    return
    elseif #kothents > 0 and self.zetaTeam then

        if !IsValid(self.KOTHEnt) then
            self.KOTHEnt = kothents[zetamath.random(#kothents)]
        elseif IsValid(self.KOTHEnt) and zetamath.random(1,10) == 1 then
            self.KOTHEnt = kothents[zetamath.random(#kothents)]
        end
        local nav = navmesh.GetNearestNavArea(self.KOTHEnt:GetPos())
        moveToPos = nav and nav:IsValid() and nav:GetRandomPoint() or self.KOTHEnt:GetPos()+VectorRand(-500,500)

        self:StartActivity(self:GetActivityWeapon('move'))
        self:SetLastActivity(self:GetActivityWeapon('move')) 
        self.loco:SetDesiredSpeed(self:GetTravelDistance(moveToPos) >= 1000 and 400 or 200)
        self:MoveToPos(moveToPos)
        self:StartActivity(self:GetActivityWeapon('idle')) 

    return
    elseif zetamath.random(6) == 1 then
        local moveToPos = nil
        local justWander = false

        local rndfriend = ((GetConVar("zetaplayer_stickwithplayer"):GetBool() and self:HasPlayerFriend()) and self:GetPlayerFriend() or self:GetRandomFriend())
        if GetConVar("zetaplayer_friendsticknear"):GetBool() and IsValid(rndfriend) then
            moveToPos = self:FindRandomPositionNear(rndfriend:GetPos(), GetConVar("zetaplayer_friendstickneardistance"):GetInt())
        else
            local members = (self.zetaTeam != "SELF" and self:GetTeamMembers(self.zetaTeam) or ((self.IsAdmin and GetConVar("zetaplayer_adminshouldsticktogether"):GetBool()) and self:GetAdmins() or {}))
            if #members > 0 then
                local rndMember = members[zetamath.random(#members)]
                if IsValid(rndmember) then
                    moveToPos = (rndmember:GetPos() + Vector(zetamath.random(-100, 100), zetamath.random(-100, 100), 0))
                end
            end
        end
        
        if !moveToPos then
            moveToPos = self:FindRandomPosition(GetConVar('zetaplayer_wanderdistance'):GetInt()) 
            justWander = true
        end

        if (!self.IsAdmin and GetConVar("zetaplayer_allownoclip"):GetBool() or self.IsAdmin and GetConVar("zetaplayer_allowadminnoclip"):GetBool()) and zetamath.random(6) == 1 then
            self:ToggleNoclip(!self:IsInNoclip())
        end
        if self:IsInNoclip() then
            if justWander and zetamath.random(4) == 1 then
                local rndNav = _ZETANAVMESH[zetamath.random(#_ZETANAVMESH)]
                if IsValid(rndNav) then moveToPos = rndNav:GetRandomPoint() end
            end
            self:NoClipTo(self:GetNoclipSpot(moveToPos))
            return
        end

        self:StartActivity(self:GetActivityWeapon('move'))
        self:SetLastActivity(self:GetActivityWeapon('move')) 
        self.loco:SetDesiredSpeed(self:GetTravelDistance(moveToPos) >= 1000 and 400 or 200)
        self:MoveToPos(moveToPos)
        self:StartActivity(self:GetActivityWeapon('idle')) 
        return
    end

    

    self:ComputeChances()

   

end

function ENT:LookforTarget(hunt)
    if !self.HasLethalWeapon then self:ChooseLethalWeapon() end
    if hunt or GetConVar("zetaplayer_alwayshuntfortargets"):GetBool() then
        self:CreateThinkFunction("HuntForEnemies", 1, 0, function()
            if self:IsChasingSomeone() or IsValid(self:GetEnemy()) then return "abort" end
            self:FindEnemy()
        end)
        self:SetState("huntingtargets")
        return
    end
    self:FindEnemy()
end


function ENT:FindMusicBoxes()
    if !self.CanDance or self:IsChasingSomeone() or self:GetState() == 'panic' then return end
    for _, v in RandomPairs(ents.FindInSphere(self:GetPos(), self.SightDistance)) do
        if IsValid(v) and v:GetClass() == "zeta_musicbox" then
            self.MusicEnt = v
            self:CancelMove()
            self:SetState('dancing')
            self:FaceTick(v:GetPos(),200)
            self.SoundPos = v:GetPos()
            self.DanceWaittime = zetamath.random(0.5,1.5)
            self.CanDance = false 
            timer.Simple(30,function()
                if self and self:IsValid() then
                    self.CanDance = true
                end
            end)
            break
        end
    end
end

function ENT:FindPropToPickup()
    local enttbl = self:FindInSight(self.SightDistance, function(ent)
        local phys = ent:GetPhysicsObject()
        return (IsValid(ent) and ent:GetClass() == "prop_physics" and IsValid(phys) and phys:GetMass() < 35 and phys:IsMotionEnabled())
    end)
    if #enttbl > 0 then
        local prop = enttbl[zetamath.random(#enttbl)]

        self:StartActivity(self:GetActivityWeapon('move'))
        self:SetLastActivity(self:GetActivityWeapon('move')) 
        local status = self:MoveToPos(prop:GetPos() + self:GetNormalTo(self:GetPos(), prop:GetPos())*80, false)
        if status != "ok" or !IsValid(prop) then return end
        self:StartActivity( self:GetActivityWeapon('idle') ) 
        
        self:Face(prop)
        self:LookAt(prop:GetPos(),'both')
        coroutine.wait(1)
        self:StopLooking()
        self:StopFacing()
        self:PickupProp(prop)
    end
end

function ENT:MovetoRandomPos(dist)
    local pos = self:FindRandomPosition(dist or GetConVar('zetaplayer_wanderdistance'):GetInt())
    self:MovetoPosition(pos)
end

function ENT:MovetoPosition(pos)
    if !util.IsInWorld(pos) then return end
    self:StartActivity(self:GetActivityWeapon('move'))
    self:SetLastActivity(self:GetActivityWeapon('move'))
    self.loco:SetDesiredSpeed(self:GetTravelDistance(pos) >= 1000 and 400 or 200) 
    self:MoveToPos(pos)
    self:StartActivity(self:GetActivityWeapon('idle')) 
end

function ENT:GotoEntity(ent,stopdist)
    self:StartActivity(self:GetActivityWeapon('move'))
    self:SetLastActivity(self:GetActivityWeapon('move')) 
    self.loco:SetDesiredSpeed(self:GetTravelDistance(ent:GetPos()) >= 1000 and 400 or 200) 
    self:FollowEntity(ent, nil, stopdist)
    self:StartActivity(self:GetActivityWeapon('idle')) 
end

function ENT:ChooseDifferentWeapon()
    if self.IsBuilding or self.Grabbing then return end
    local useableWEPS = self:GetUseableWeapon()
    local weapon = useableWEPS[zetamath.random(#useableWEPS)]
    if weapon != self:GetWeapon() then
        self:ChangeWeapon(weapon)
    end
end

function ENT:ChooseLethalWeapon()
    if self.IsBuilding or self.Grabbing then return end
    local useableWEPS = self:GetUseableLethalWeapon()
    local weapon = useableWEPS[zetamath.random(#useableWEPS)]
    if weapon != self:GetWeapon() then
        self:ChangeWeapon(weapon)
    end
end

function ENT:UseATool()
    local tools = {
        function() self:UseColorTool() end,
        function() self:UseMaterialTool() end,
        function() return (zetamath.random(2) == 1 and self:UseRopeTool() or self:UseWorldRopeTool()) end,
        function() self:UseLightTool() end,
        function() self:UseRemoverTool() end,
        function() self:UseBalloonTool() end,
        function() self:UseMusicBoxTool() end,
        function() self:UseIgniterTool() end,
        function() self:UseTrailsTool() end,
        function() self:UseFacePoserTool() end,
        function() self:UseEmitterTool() end,
        function() self:UseBoneManipulatorTool() end,
        function() self:UseDynamiteTool() end,
        function() self:UsePaintTool(zetamath.random(0, 12)) end,
        function() self:UseThrusterTool() end,
        function() self:UseLampTool() end,
        function() self:UseWireButtonTool() end,
        function() self:UseWireGateTool() end ,
    }
    tools[math.random(#tools)]()
end

function ENT:DecideOnHeldEnt(isuniversal)
    if !self.Grabbing and !isuniversal then
        if 100 * zetamath.random() < self.CombatChance then
            local prop = self:SpawnProp(true)
            self:GrabEnt(prop)
            self:FindEnemy()
            return
        end
        self:FindEntToGrab()
    else
        local choices = {
            function() self:FreezeHeldObject() end,
            function() self:DropHeldObject() end,
            function() self:ThrowHeldObject() end,
            function() self:SlamHeldObject() end,
            function() self:SwingHeldObject() end
        }
        choices[zetamath.random(#choices)]()
    end
end

function ENT:FindEntToGrab()
    if self.Grabbing or self.Weapon != 'PHYSGUN' then return end
    local entities = self:FindInSightPermission(1300)
    if #entities > 0 then
        local target = entities[zetamath.random(#entities)]
        self:Face(target)
        self:LookAt(target, 'both')
        timer.Simple(zetamath.random(0.5,1.0),function()
            if !IsValid(self) then return end
            self:StopLooking()
            self:StopFacing()
            self:GrabEnt(target)
            DebugText('PHYSGUN: Grabbed '..tostring(target))
        end)
    else
        DebugText('PHYSGUN: Failed To Find a Ent! There are no ents to physgun!')
    end
end

function ENT:AttemptAttack()
    if !self.HasLethalWeapon then
        return self:MovetoRandomPos()
    end
    if zetamath.random(2) == 1 then
        self:FindEnemy()
    end
end

ZetaNavMesh_HidingSpots = nil
ZetaNavMesh_LastHidingSpotCheckAreaCount = 0
function ENT:Flee()
    self:StartActivity(ACT_HL2MP_RUN_PANICKED)
    self:SetLastActivity(ACT_HL2MP_RUN_PANICKED) 
    self.loco:SetDesiredSpeed(400) 

    local isFleeingFromSomething = IsValid(self.FleeFromTarget)
    local searchDist = GetConVar('zetaplayer_wanderdistance'):GetInt()
    local GetHidingSpot = function()
        local moveSpot = nil
        if ZetaNavMesh_HidingSpots and #ZetaNavMesh_HidingSpots > 0 then
            local spotArea = ZetaNavMesh_HidingSpots[zetamath.random(#ZetaNavMesh_HidingSpots)]
            if spotArea[1] and spotArea[1]:IsValid() and self.loco:IsAreaTraversable(spotArea[1]) then
                local newMoveSpot = spotArea[2][zetamath.random(#spotArea-1)] + Vector(0, 0, 36)
                if !IsValid(self.FleeFromTarget) then
                    if self:GetRangeSquaredTo(newMoveSpot) > (searchDist*searchDist) then
                        moveSpot = newMoveSpot
                    end
                else
                    local myCenteroid = (self:GetPos() + self:OBBCenter())
                    local targetPos = (self.FleeFromTarget:GetPos() + self.FleeFromTarget:OBBCenter())
                    if (targetPos - myCenteroid):Angle():Forward():Dot((newMoveSpot - myCenteroid):GetNormalized()) < 0.33 and !self:CanSeePosition(newMoveSpot, targetPos) and !self:CanSeePosition(newMoveSpot, myCenteroid) then
                        moveSpot = newMoveSpot
                    end
                end
            end
        end
        if !moveSpot then moveSpot = self:FindRandomPosition(searchDist) end
        return moveSpot
    end

    local encounterCheckT = CurTime() + 0.25
    self:ZETA_MoveTo(GetHidingSpot(), {tolerance=96, lookahead=600, repathdelay=0.4, repathoffset=32, customfunc=function(path)
        local curGoal = path:GetCurrentGoal().pos

        if CurTime() > encounterCheckT and IsValid(self.FleeFromTarget) then
            encounterCheckT = CurTime() + 0.25

            local myCenteroid = (self:GetPos() + self:OBBCenter())
            local targetPos = (self.FleeFromTarget:GetPos() + self.FleeFromTarget:OBBCenter())
            if (targetPos - myCenteroid):Angle():Forward():Dot((curGoal - myCenteroid):GetNormalized()) >= 0.66 and self:CanSeePosition(curGoal, myCenteroid, self.FleeFromTarget) and self:CanSee(self.FleeFromTarget) then
                path:Compute(self, GetHidingSpot(), self:PathGenerator())
                return
            end
        end

        if !GetConVar("zetaplayer_allowpanicbhop"):GetBool() then return end
        if self:GetRangeSquaredTo(curGoal) > (192*192) and (curGoal.z-self:GetPos().z) > -128 and self.loco:GetVelocity():Length() >= 350 and self.loco:IsOnGround() and ((self:GetPos()+self.loco:GetVelocity())-self:GetPos()):Angle():Forward():Dot((curGoal-self:GetPos()):GetNormalized()) >= 0.95 then
            self.IsJumping = true 
            self:SetLastActivity(self:GetActivity())
            self.loco:Jump()
            local jumpDir = (curGoal-(self:GetPos()+self:GetUp()*15)):Angle():Forward()
            self.loco:SetVelocity(self.loco:GetVelocity()+jumpDir*200)
            self.JumpDirection = jumpDir
        end
    end})

    self:StartActivity(ACT_HL2MP_IDLE_SCARED)
    if (!IsValid(self.FleeFromTarget) or self:GetTravelDistance(self.FleeFromTarget:GetPos()) > 2500 and !self:CanSee(self.FleeFromTarget)) then 
        self:Wait(zetamath.random(1, 3)) 
    end

    if isFleeingFromSomething and (!IsValid(self.FleeFromTarget) or (self:GetTravelDistance(self.FleeFromTarget:GetPos()) > 2500 or self.FleeFromTarget:IsPlayer() and !self.FleeFromTarget:Alive() or self.FleeFromTarget.IsZetaPlayer and self.FleeFromTarget.IsDead)) and timer.Exists("ZetaPanicTimeout"..self:EntIndex()) then
        timer.Remove("ZetaPanicTimeout"..self:EntIndex())
        self:SetState('idle')
        self.AllowVoice = true
        self.FleeFromTarget = NULL
        DebugText('Panic: No longer panicking')
    
        timer.Simple(30, function()
            if !IsValid(self) then return end
            self.AllowPanic = true
            DebugText('Panic: Can panic again')
        end)
    end
end

function ENT:BeginLaugh()
    if self.IsDriving then return end

    local rnd = zetamath.random(50 + self.LaughSoundCount)
    local snd = 'zetaplayer/vo/laugh'..rnd..'.wav'
    if self.LAUGHVOICEPACKEXISTS then
        snd = "zetaplayer/custom_vo/"..self.VoicePack.."/laugh/laugh"..zetamath.random(self.LaughSoundCount)..".wav"
    elseif rnd > 50 or self.UseCustomLaugh or self.Permafriend and GetConVar("zetaplayer_friendcustomlaughlinesonly"):GetBool() or GetConVar("zetaplayer_customlaughlinesonly"):GetBool() then
        snd = "zetaplayer/custom_vo/laugh/laugh"..zetamath.random(self.LaughSoundCount)..".wav"
    end
    self:ZetaPlayVoiceSound(snd, "zetastoplaugh"..self:EntIndex())

    self:PlaySequenceAndWait('taunt_laugh')
    self:StartActivity(self:GetActivityWeapon('idle'))
    self:StopFacing()
    self:SetState('idle')
end

function ENT:ChaseMeleeState()
    if !IsValid(self) or !IsValid(self:GetEnemy()) then 
        self:SetState('idle') 
        return 
    end

    if self:IsInNoclip() then
        self:ToggleNoclip(false)
    end
    
    local timeout = CurTime() + zetamath.random(30, 90)   
    self:CreateThinkFunction("zetabortattack", 0.1, 0, function()
        if self:GetState() != "chasemelee" then return "failed" end 
        if CurTime() > timeout then 
            self:SetNW2Bool('zeta_aggressor', false)
            self:StopFacing()
            self:CancelMove()
            self:SetState('idle')
            return "stop"
        end
    end)

    if self.Grabbing and self.Weapon != "PHYSGUN" then
        self:DropHeldprop()
    end

    local wpnTbl = self.WeaponDataTable[self.Weapon]
    local keepDistance = wpnTbl.keepDistance or 10
    local moveSpeed = wpnTbl.moveSpeed or 400

    self:StartActivity(self:GetActivityWeapon('move'))
    self:SetLastActivity(self:GetActivityWeapon('move')) 
    self:Face(self:GetEnemy())
    self.loco:SetDesiredSpeed(moveSpeed)

    local strafingCvar = GetConVar("zetaplayer_allowstrafing")
    self:ZETA_MoveTo(self:GetEnemy(), {update=true, tolerance=keepDistance, customfunc=function()
        if strafingCvar:GetBool() and self:CanSee(self:GetEnemy()) and zetamath.random(5) == 1 then
            self:CreateThinkFunction("StrafeMovement", 0, zetamath.random(500), function()
                if self.TypingInChat or !self:IsChasingSomeone() or !self:CanSee(self:GetEnemy()) or self:GetRangeSquaredTo(self:GetEnemy()) <= (150*150) then return "failed" end
                self.loco:SetVelocity(self.loco:GetVelocity() + self:GetRight()*(50*math.random(-1, 1)))
            end)
        end

        local wepData = self.WeaponDataTable[self.Weapon]
        local range = ((wepData != nil and wepData.fireData != nil) and wepData.fireData.range or 48)
        if self:GetRangeSquaredTo(self:GetEnemy()) <= (range*range) then
            self:UseMelee(self:GetEnemy())
        end
    end})

    self:StartActivity(self:GetActivityWeapon('idle')) 
end

function ENT:DisrespectState()
    if self.DisCount == 0 then
        self.AllowVoice = false 
        self:StartActivity( self:GetActivityWeapon('move'))
        self:SetLastActivity(self:GetActivityWeapon('move'))
        self.loco:SetDesiredSpeed(400)  
        self:MoveToPos(self.DisEntPos)
    end

    self:StartActivity( self:GetActivityWeapon('crouch'))
    coroutine.wait(0.3)
    self:StartActivity( self:GetActivityWeapon('idle'))

    self.DisCount = self.DisCount + 1
    if self.DisCount == self.DisAmount then
        self:SetState('idle')
    end
end

function ENT:ActCommandsState()
    local act = {"taunt_dance", "taunt_muscle", "taunt_cheer", "taunt_robot", "taunt_zombie"}
    self:PlaySequenceAndWait(act[zetamath.random(#act)])
    self:StartActivity( self:GetActivityWeapon('idle'))
    self:SetState('idle')
end

function ENT:DancingState()
    self.AllowVoice = false

    coroutine.wait(self.DanceWaittime)
    if self:GetTravelDistance(self.SoundPos) >= 350 then
        self.loco:SetDesiredSpeed(200)
        self:StartActivity(self:GetActivityWeapon('move'))
        self:SetLastActivity(self:GetActivityWeapon('move')) 
        self.loco:SetDesiredSpeed(self:GetTravelDistance(self.SoundPos) >= 1000 and 400 or 200)
        self:MoveToPos(self.SoundPos + Vector(zetamath.random(-150, 150), zetamath.random(-150, 150), 0))
    end

    local dances = {'taunt_dance', 'taunt_dance', 'taunt_robot'}
    if !IsValid(self.MusicEnt) then self.MusicEnt = nil self:SetState('idle') return end
    self:PlaySequenceAndWait(dances[zetamath.random(#dances)])
    if !IsValid(self.MusicEnt) then self.MusicEnt = nil self:SetState('idle') return end
    self:PlaySequenceAndWait(dances[zetamath.random(#dances)])
    if !IsValid(self.MusicEnt) then self.MusicEnt = nil self:SetState('idle') return end
    self:PlaySequenceAndWait(dances[zetamath.random(#dances)])

    self:StartActivity(self:GetActivityWeapon('idle'))
    if !IsValid(self.MusicEnt) or zetamath.random(3) == 1 then
        self:SetState('idle')
        self.MusicEnt = nil
    end
end

function ENT:RangedAttack()
    if !IsValid(self.Enemy) then self:SetState('idle') return end
    if self:IsInNoclip() then
        self:ToggleNoclip(false)
    end
    if !self.Delayattack then
        coroutine.wait(zetamath.random(10)/10)
        self.Delayattack = true
        if IsValid(self:GetEnemy()) then
            self:LookAtTick(self:GetEnemy(), 'both', 200, true)
        end
    end

    if self.Grabbing and self.Weapon != "PHYSGUN" then
        self:DropHeldprop()
    end

    local timeout = CurTime() + zetamath.random(30, 90)
    self:CreateThinkFunction("zetabortattack", 0.1, 0, function()
        if self:GetState() != "chaseranged" then return "failed" end 
        if CurTime() > timeout then 
            self:SetNW2Bool('zeta_aggressor', false)
            self:StopFacing()
            self:CancelMove()
            self:SetState('idle')
            return "stop"
        end
    end)

    local keepDistance = self.WeaponDataTable[self.Weapon].keepDistance or 300
    if IsValid(self:GetEnemy()) then
        if keepDistance < 1000 and (self:IsSanicNextBot(self:GetEnemy()) or self:GetEnemy():Health() >= 500 and !self:GetEnemy()._ZetaNoKeepdistance) then
            keepDistance = 1000
        end
        if !self.WeaponDataTable[self.Weapon].isExplosive and self.RPGTargets[self:GetEnemy():GetClass()] then
            local newWep = self.ExplosiveWeapons[math.random(#self.ExplosiveWeapons)]
            self:ChangeWeapon(newWep)
            keepDistance = self.WeaponDataTable[newWep].keepDistance or 300
        end
        self:CreateThinkFunction("zetafaceenemy", 0, 0, function()
            if !IsValid(self) or !IsValid(self:GetEnemy()) or self:GetState() != "chaseranged" then return "failed" end
            local pos = self.Enemy:GetPos()
            local towards = (pos - self:GetPos()):Angle()[2]
            local approach = math.ApproachAngle(self:GetAngles()[2], towards, (5 + (self.IsMoving and 15 or 0)))
            self:SetAngles(Angle(0, approach, 0))
        end)
    end

    local moveSpeed = self.WeaponDataTable[self.Weapon].moveSpeed or 400
    self.loco:SetDesiredSpeed(moveSpeed)

    self:CreateThinkFunction("FireWeapon", 0, 0, function()
        if self:GetState() != 'chaseranged' or !IsValid(self:GetEnemy()) then return "failed" end
        if !self:CanSee(self:GetEnemy()) then return end
        if self.Weapon == 'PHYSGUN' then
            self:ApproachPhysgunDist(self:GetRangeTo(self.Enemy))
            if zetamath.random(40) == 1 then
                if zetamath.random(2) == 1 then
                    self:SwingHeldObject()
                else
                    self:SlamHeldObject()
                end
            end
        else
            self:FireWeapon(self:GetEnemy())
        end
    end)

    self:MoveOnCondition(keepDistance, GetConVar("zetaplayer_allowstrafing"):GetBool())
    self:StartActivity(self:GetActivityWeapon("idle"))
end

function ENT:FindHurtEnt()
    local find = self:FindInSight(self.SightDistance, function(ent)
        if ent:IsPlayer() and GetConVar('ai_ignoreplayers'):GetBool() then return false end
        return (ent:IsPlayer() or ent.IsZetaPlayer) and ent:Health() < ent:GetMaxHealth()
    end)
    if #find != 0 then
        local hurtent = find[zetamath.random(#find)]
        self:StartActivity(self:GetActivityWeapon('move'))
        self:SetLastActivity(self:GetActivityWeapon('move'))
        self.loco:SetDesiredSpeed(self:GetTravelDistance(hurtent:GetPos()) >= 1000 and 400 or 200) 
        self:ChaseEnemy(hurtent,run) -- This isn't an enemy that's just the name of the function
        if !IsValid(hurtent) then self:SetState("idle") return end
        local spawnCount = math.random(1, math.max(1, math.ceil((hurtent:GetMaxHealth()-hurtent:Health())/25)))
        self:SpawnMedKit(spawnCount)
        self:StartActivity(self:GetActivityWeapon('idle'))
    end
end

function ENT:CheckSurroundingsMedia()
    local entities = self:FindInSphere(2000, function(ent)
        return (IsValid(ent) and ent:GetClass() == 'mediaplayer_tv')
    end)
    if #entities > 0 then
        self.MediaPlayer = entities[zetamath.random(#entities)]
        self.SitPos = {zetamath.random(100, 200), zetamath.random(-200, 200)}
        self:SetState('watching')
        timer.Simple(zetamath.random(10, 120),function()
            if !IsValid(self) or self:GetState() != 'watching' then return end
            self:SetState('idle')
        end)
    end
end

function ENT:WatchMediaPlayer()
    if !IsValid(self.MediaPlayer) then 
        self:SetState('idle') 
        if zetamath.random(2) == 1 then 
            self:ReacttoMediaPlayer() 
        end 
        return 
    end
    
    local pos = (self.MediaPlayer:GetPos() + self.MediaPlayer:GetForward()*self.SitPos[1] + self.MediaPlayer:GetRight()*self.SitPos[2])
    self.loco:SetDesiredSpeed(200)
    if self:GetRangeSquaredTo(pos) > (70*70) then
        self:StartActivity(self:GetActivityWeapon('move'))
        self:SetLastActivity(self:GetActivityWeapon('move')) 
        if self:GetRangeSquaredTo(pos) >= (10*10) then
            self:MoveToPos(pos)
        end
    end
    if zetamath.random(80) == 1 and GetConVar('zetaplayer_allowmediawatchvoice'):GetBool() then
        if 100 * zetamath.random() < self.TextChance and GetConVar("zetaplayer_allowtextchat"):GetBool() then
            self:TypeMessage("mediawatch")
        else
            self:PlayMediaWatchLine()
        end
    end
    
    if #self.MEDIADATA > 0 and zetamath.random(30) == 1 and IsValid(self.MediaPlayer) and !self.MediaPlayer:GetMediaPlayer():IsPlaying() and GetConVar("zetaplayer_allowrequestmedia"):GetBool() then
        local rndurl = self.MEDIADATA[zetamath.random(#self.MEDIADATA)]
        self:ZetaRequestMedia(rndurl[1], rndurl[2], rndurl[3])
    end

    self:FaceTick(self.MediaPlayer, 100)
    self:StartActivity(self:GetActivityWeapon('idle'))
end

function ENT:ChooseSpawnEnt()
    if zetamath.random(2) == 1 then
        self:SpawnNPC()
    else
        self:SpawnProp()
    end
end

function ENT:FindVehicle()
    local vehicle
    local foundVehicle = false 
    self:CreateThinkFunction("zetafindvehicle",0.5,0,function()
        for _, v in RandomPairs(ents.FindInSphere(self:GetPos(), 1500)) do
            if IsValid(v) and self:IsVehicleEnterable(v) then
                foundVehicle = true
                vehicle = v
                self:CancelMove()
                return "failed"
            end
        end
    end)

    local rndfriend = ((GetConVar("zetaplayer_stickwithplayer"):GetBool() and self:HasPlayerFriend()) and self:GetPlayerFriend() or self:GetRandomFriend())
    if IsValid(rndfriend) then
        local pos = self:FindRandomPositionNear(rndfriend:GetPos(), GetConVar("zetaplayer_friendstickneardistance"):GetInt())
        if util.IsInWorld(pos) then
            self:StartActivity(self:GetActivityWeapon('move'))
            self:SetLastActivity(self:GetActivityWeapon('move'))
            self.loco:SetDesiredSpeed(self:GetTravelDistance(pos) >= 1000 and 400 or 200)
            self:MoveToPos(pos)
            self:StartActivity(self:GetActivityWeapon('idle')) 
        end
    else
        self:MovetoRandomPos()
    end

    if foundVehicle then
        local closeabort = false
        self:StartActivity(self:GetActivityWeapon('move'))
        self:SetLastActivity(self:GetActivityWeapon('move'))
        self.loco:SetDesiredSpeed(self:GetTravelDistance(vehicle:GetPos()) >= 1000 and 400 or 200)
        local moveResult = self:ZETA_MoveTo(vehicle, {customfunc = function(path)
            if !self:IsVehicleEnterable(vehicle) then return "abort" end
            if self:GetRangeSquaredTo(vehicle) <= (100*100) then closeabort = true return "abort" end
        end})
        self:StartActivity(self:GetActivityWeapon('idle'))
        if isstring(moveResult) and moveResult != "ok" and !closeabort then return end
        self:Face(vehicle)
        self:LookAt(vehicle:GetPos(), 'both')
        self:Wait(math.Rand(0.1, 1.0))
        if !IsValid(self) or self:GetState() != 'idle' or !IsValid(vehicle) or !self:IsVehicleEnterable(vehicle) then return end
        self:StopLooking()
        self:PrepareResetPose()
        self:EnterVehicle(vehicle,!self:IsNormalSeat(vehicle))
    end
end

function ENT:ChooseVehicle()
    if !GetConVar('zetaplayer_allowvehicles'):GetBool() then return end

    -- Leave the vehicle if it's upside-down
    if math.abs(self.Vehicle:GetAngles().r) >= 100 and self.Vehicle:GetVelocity():Length() <= 10 then
        self:ExitVehicle()
        return
    end

    -- Leave the simfphys vehicle if it's on fire and goto panic state
    if self.Vehicle.IsSimfphyscar and self.Vehicle:OnFire() then
        self:ExitVehicle()
        self:Panic(self.Vehicle)
        return
    end

    local decide = zetamath.random(3)
    if decide == 1 and zetamath.random(2) == 1 and !self.PreventExitOnFirst then
        self:ExitVehicle()
    elseif decide == 2 and 100 * zetamath.random() < self.CombatChance then
        local target = self:FindTargetToRam()
        self:Drive(IsValid(target) and target or self:GetDrivableRandomPos())
    else
        self:Drive(self:GetDrivableRandomPos())
    end
    self.PreventExitOnFirst = false
end

function ENT:Huntfortargets()
    local kothents = ents.FindByClass("zeta_koth")

    if #kothents > 0 then

        if !IsValid(self.KOTHEnt) then
            self.KOTHEnt = kothents[zetamath.random(#kothents)]
        end
        local nav = navmesh.GetNearestNavArea(self.KOTHEnt:GetPos())
        local moveToPos = nav and nav:IsValid() and nav:GetRandomPoint() or self.KOTHEnt:GetPos()+VectorRand(-500,500)

        self:StartActivity(self:GetActivityWeapon('move'))
        self:SetLastActivity(self:GetActivityWeapon('move')) 
        self.loco:SetDesiredSpeed(self:GetTravelDistance(moveToPos) >= 1000 and 400 or 200)
        self:MoveToPos(moveToPos)
        self:StartActivity(self:GetActivityWeapon('idle')) 

    else

        local rndfriend = ((GetConVar("zetaplayer_stickwithplayer"):GetBool() and self:HasPlayerFriend()) and self:GetPlayerFriend() or self:GetRandomFriend())
        if IsValid(rndfriend) then
            local pos = self:FindRandomPositionNear(rndfriend:GetPos(), GetConVar("zetaplayer_friendstickneardistance"):GetInt())
            if util.IsInWorld(pos) then
                self:StartActivity(self:GetActivityWeapon('move'))
                self:SetLastActivity(self:GetActivityWeapon('move'))
                self.loco:SetDesiredSpeed(self:GetTravelDistance(pos) >= 1000 and 400 or 200)
                self:MoveToPos(pos)
                self:StartActivity(self:GetActivityWeapon('idle')) 
            end
        else
            self:MovetoRandomPos()
        end

    end
    
    if !IsValid(self:GetEnemy()) then
        self:SetState("idle")
    end
end

function ENT:ToolgunBurstState()
    if self.Weapon != "TOOLGUN" then
        self:ChangeWeapon('TOOLGUN')
    end
    if zetamath.random(6) == 1 then -- If 1, move in a small distance
        self:MovetoRandomPos(500)
    else
        self:UseATool()
        self.BurstCount = self.BurstCount + 1
    end
    if self.BurstCount >= self.MaxBurst then
        self:SetState("idle")
    end 
end

function ENT:BuildingState()
    if self.CurrentSpawnedProps >= GetConVar('zetaplayer_proplimit'):GetInt() then 
        self:SetState("idle") 
        return 
    end
    if zetamath.random(10) == 1 then -- If 1, move in a small distance
        self:MovetoRandomPos(300)
    else
        self:SpawnProp()
        self.BurstCount = self.BurstCount + 1
    end
    if self.BurstCount >= self.MaxBurst then
        self:SetState("idle")
    end 
end

local ruleReasons = {
    ['propkill']    = "Prop Killing",
    ['rdm']         = "RDMing",
    ['grief']       = "Altering ENTs they do not own"
}

function ENT:ConductAdminSit()
    local attacker = self.CurrentRuleData.offender
    local victim = self.CurrentRuleData.victim
    local inflictor = self.CurrentRuleData.inflictor 
    local brokenrule = self.CurrentRuleData.ruletype
    local reason = ruleReasons[brokenrule] or ""
    local lefttositarea = false

    if attacker.AdminHandled then 
        self:SetState("idle") 
        return 
    end
    attacker.AdminHandled = true
    self.HeldOffender = attacker

    if 100 * zetamath.random() < self.TextChance and GetConVar("zetaplayer_allowtextchat"):GetBool() then 
        self.UseTextChat = true 
    end

    if zetamath.random(2) == 1 then
        if !IsValid(self) then return end
        if !IsValid(attacker) then self:SetState("idle") self:RemoveGesture(ACT_GMOD_IN_CHAT) self:StopFacing() return end
        self:FacePos(attacker:GetPos())
        self:Wait(zetamath.random(0.0,1.0))
        
        if !IsValid(self) then return end
        if !IsValid(attacker) then self:SetState("idle") self:RemoveGesture(ACT_GMOD_IN_CHAT) self:StopFacing() return end
        self:AddGesture( ACT_GMOD_IN_CHAT,false )
        self:Wait(zetamath.random(0.5,3.0))
        
        if !IsValid(self) then return end
        if !IsValid(attacker) then self:SetState("idle") self:RemoveGesture(ACT_GMOD_IN_CHAT) self:StopFacing() return end
        self:StopFacing()
        self:RemoveGesture(ACT_GMOD_IN_CHAT)
        
        self:COMMAND_SetPos(self:FindAdminSitArea())
        lefttositarea = true
    end
    
    if !IsValid(self) then return end
    if !IsValid(attacker) then self:SetState("idle") self:RemoveGesture(ACT_GMOD_IN_CHAT) self:StopFacing() if lefttositarea then self:COMMAND_Return(self) end return end
    if zetamath.random(3) == 1 then
        self:Wait(math.Rand(0, 0.4))
        if !IsValid(self) then return end
        if !IsValid(attacker) then self:SetState("idle") self:RemoveGesture(ACT_GMOD_IN_CHAT) self:StopFacing() if lefttositarea then self:COMMAND_Return(self) end return end
        local nav = navmesh.GetNavArea(self:GetPos(),2)
        local pos = self:GetPos()+VectorRand(-100,100)
        if IsValid(nav) then pos = nav:GetRandomPoint() end
        self:MovetoPosition(pos)
    end
    local navarea = navmesh.GetNavArea(self:GetPos(), 2)
    if IsValid(navarea) then
        local pos = navarea:GetCenter()
        if pos then self:FacePos(pos) end
    end
    self:AddGesture( ACT_GMOD_IN_CHAT,false )
    self:Wait(zetamath.random(0.5,3.0))
    
    if !IsValid(self) then return end
    if !IsValid(attacker) then self:SetState("idle") self:RemoveGesture(ACT_GMOD_IN_CHAT) self:StopFacing() if lefttositarea then self:COMMAND_Return(self) end return end
    if IsValid(attacker) and attacker:IsPlayer() and !attacker:Alive() then attacker:Spawn() end
    self:StopFacing()
    self:RemoveGesture(ACT_GMOD_IN_CHAT)

    local rnd = zetamath.random(3)
    if rnd == 1 then
        self:COMMAND_Bring(attacker)
        attacker.Enemy = NULL
        attacker.SitAdmin = self
        attacker.InSit = true
        if attacker.IsZetaPlayer then attacker:CancelMove() attacker:SetState("jailed/held") if 100*math.random() < attacker.TextChance and GetConVar("zetaplayer_allowtextchat"):GetInt() == 1 then attacker.UseTextChat = true end  end
        self:Wait(zetamath.random(0.1,1.5))
        if !IsValid(self) then return end
        if !IsValid(attacker) then self:SetState("idle") self:RemoveGesture(ACT_GMOD_IN_CHAT) self:StopFacing() if lefttositarea then self:COMMAND_Return(self) end return end
            self:Interrogate(zetamath.random(1,10),attacker)
        self:Wait(zetamath.random(0.1,1.5))
        if !IsValid(self) then return end
        if !IsValid(attacker) then self:SetState("idle") self:RemoveGesture(ACT_GMOD_IN_CHAT) self:StopFacing() if lefttositarea then self:COMMAND_Return(self) end return end
        self:DecideOnOffender(attacker,reason)
        if IsValid(attacker) then
            attacker.AdminHandled = false 
            attacker.InSit = false
            attacker.SitAdmin = NULL
        end
        if lefttositarea then
            self:AddGesture( ACT_GMOD_IN_CHAT,false )
            self:Wait(zetamath.random(0.5,3.0))
            self:RemoveGesture(ACT_GMOD_IN_CHAT)

            self:COMMAND_Return(self)
        end
        self:SetState("idle")
    elseif rnd == 2 then
        self:COMMAND_TpJail(attacker)
        attacker.Enemy = NULL
        attacker.SitAdmin = self
        attacker.InSit = true
        if attacker.IsZetaPlayer then attacker:CancelMove() attacker:SetState("jailed/held") if 100*math.random() < attacker.TextChance and GetConVar("zetaplayer_allowtextchat"):GetInt() == 1 then attacker.UseTextChat = true end end

        self:FacePos(attacker:GetPos())
        self:Wait(zetamath.random(0.1,1.5))
        if !IsValid(self) then return end
        if !IsValid(attacker) then self:SetState("idle") self:RemoveGesture(ACT_GMOD_IN_CHAT) self:StopFacing() if lefttositarea then self:COMMAND_Return(self) end return end
        self:StopFacing()
            self:Interrogate(zetamath.random(1,10),attacker)
        self:Wait(zetamath.random(0.1,1.5))
        if !IsValid(self) then return end
        if !IsValid(attacker) then self:SetState("idle") self:RemoveGesture(ACT_GMOD_IN_CHAT) self:StopFacing() if lefttositarea then self:COMMAND_Return(self) end return end
        self:DecideOnOffender(attacker,reason)
        if IsValid(attacker) then
            attacker.AdminHandled = false 
            attacker.InSit = false
            attacker.SitAdmin = NULL
        end
        if lefttositarea then
            self:AddGesture( ACT_GMOD_IN_CHAT,false )
            self:Wait(zetamath.random(0.5,3.0))
            self:RemoveGesture(ACT_GMOD_IN_CHAT)

            self:COMMAND_Return(self)
        end
        self:SetState("idle")
    elseif rnd == 3 then
        self:COMMAND_Bring(attacker)
        attacker.Enemy = NULL
        attacker.SitAdmin = self
        attacker.InSit = true
        if attacker.IsZetaPlayer then attacker:CancelMove() attacker:SetState("jailed/held") if 100*math.random() < attacker.TextChance and GetConVar("zetaplayer_allowtextchat"):GetInt() == 1 then attacker.UseTextChat = true end end
        self:Wait(0.1)
        self:AddGesture( ACT_GMOD_IN_CHAT,false )
        self:Wait(zetamath.random(0.5,3.0))
        if !IsValid(self) then return end
        if !IsValid(attacker) then self:SetState("idle") self:RemoveGesture(ACT_GMOD_IN_CHAT) self:StopFacing() if lefttositarea then self:COMMAND_Return(self) end return end
        self:RemoveGesture(ACT_GMOD_IN_CHAT)

        self:COMMAND_Jail(attacker)

        self:MovetoPosition(attacker:GetPos()+self:GetNormalTo(self:GetPos(),attacker:GetPos())*150)
        if !IsValid(attacker) then self:SetState("idle") self:RemoveGesture(ACT_GMOD_IN_CHAT) self:StopFacing() if lefttositarea then self:COMMAND_Return(self) end return end
        self:FacePos(attacker:GetPos())
        self:Wait(zetamath.random(0.1,1.5))
        if !IsValid(self) then return end
        if !IsValid(attacker) then self:SetState("idle") self:RemoveGesture(ACT_GMOD_IN_CHAT) self:StopFacing() if lefttositarea then self:COMMAND_Return(self) end return end
        self:StopFacing()
            self:Interrogate(zetamath.random(1,10),attacker)
        self:Wait(zetamath.random(0.1,1.5))
        
        self:DecideOnOffender(attacker,reason)
        if IsValid(attacker) then
            attacker.AdminHandled = false 
            attacker.SitAdmin = NULL
            attacker.InSit = false
        end
        if lefttositarea then
            self:AddGesture( ACT_GMOD_IN_CHAT,false )
            self:Wait(zetamath.random(0.5,3.0))
            self:RemoveGesture(ACT_GMOD_IN_CHAT)

            self:COMMAND_Return(self)
        end

        self:SetState("idle")
    end
end

function ENT:WaitinSit()
    if !IsValid(self.SitAdmin) then 
        self:StopFacing() 
        self:SetState("idle") 
        return 
    end
    
    self:FacePos(self.SitAdmin:GetPos())
    if !self.InSit then
        self:StopFacing()
        self:SetState("idle")
    end

    self:InteraWait()
    self.AllowResponse = false

    while self.IsSpeaking do
        coroutine.yield()
    end
    
    local dur
    if self.UseTextChat then
        self.text_keyent = self.SitAdmin.zetaname
        dur = self:TypeMessage("response")
    else
        dur = self:RespondtoAdmin() 
    end

    timer.Simple(dur or 0, function()
        if !IsValid(self) or !IsValid(self.SitAdmin) then return end
        self.SitAdmin.AllowResponse = true
    end)
end

function ENT:TypingCommand()
    self:AddGesture( ACT_GMOD_IN_CHAT,false )
    self:Wait(zetamath.random(5, 30)/10)
    self:RemoveGesture(ACT_GMOD_IN_CHAT)
    local commands = self:GetAllowedCommands()
    local rndcommand = commands[zetamath.random(#commands)]
    if isfunction(rndcommand) then
        rndcommand()
    end
    self:SetState("idle")
end

function ENT:LookforButton()
    if IsValid(self.Enemy) then 
        self:SetState('chase'..(self.HasMelee and 'melee' or 'ranged')) 
        return 
    end
    
    local button = NULL
    self:CreateThinkFunction("FindButton", 0.5, 0, function()
        local sight = self:FindInSight(self.SightDistance, function(ent) 
            return (IsValid(ent) and (ent:GetClass() == "func_button" or ent:GetClass() == "gmod_button" or ent:GetClass() == "gmod_wire_button"))
        end)
        if #sight > 0 then
            button = sight[zetamath.random(#sight)]
            self:CancelMove()
            return "abort"
        end
    end)

    local rndfriend = ((GetConVar("zetaplayer_stickwithplayer"):GetBool() and self:HasPlayerFriend()) and self:GetPlayerFriend() or self:GetRandomFriend())
    if IsValid(rndfriend) then
        local pos = self:FindRandomPositionNear(rndfriend:GetPos(), GetConVar("zetaplayer_friendstickneardistance"):GetInt())
        if util.IsInWorld(pos) then
            self:StartActivity(self:GetActivityWeapon('move'))
            self:SetLastActivity(self:GetActivityWeapon('move'))
            self.loco:SetDesiredSpeed(self:GetTravelDistance(pos) >= 1000 and 400 or 200)
            self:MoveToPos(pos)
            self:StartActivity(self:GetActivityWeapon('idle')) 
        end
    else
        self:MovetoRandomPos()
    end

    if IsValid(self.Enemy) then 
        self:SetState('chase'..(self.HasMelee and 'melee' or 'ranged')) 
        return 
    end

    if IsValid(button) then
        local pos = button:GetPos()+self:GetNormalTo(self:GetPos(),button:GetPos())*80
        self:MovetoPosition(pos)
        if !IsValid(button) then self:SetState("idle") return end
        self:StartActivity( self:GetActivityWeapon('idle') ) 
        self:Face(button)
        self:LookAt(button:GetPos(),'both')
        coroutine.wait(1)
        if !IsValid(button) then self:SetState("idle") return end
        self:StopLooking()
        self:StopFacing()
        self:PressButton(button)
        self:SetState("idle")
    elseif !IsValid(self.Enemy) then
        self:SetState("idle")
    end
end

function ENT:FindConversPartner()
    local partner = NULL
    self:CreateThinkFunction("FindConversationPartner", 0.5, 0, function()
        local sight = self:FindInSight(self.SightDistance, function(ent) 
            return (IsValid(ent) and (ent.IsZetaPlayer and (ent:GetState() == "idle" or ent:GetState() == "findingconverse") or ent:IsPlayer() and !GetConVar("ai_ignoreplayers"):GetBool()) and !IsValid(ent.ConversePartner))
        end)
        if #sight > 0 then
            partner = sight[zetamath.random(#sight)]
            self:CancelMove()
            return "abort"
        end
    end)

    local rndfriend = ((GetConVar("zetaplayer_stickwithplayer"):GetBool() and self:HasPlayerFriend()) and self:GetPlayerFriend() or self:GetRandomFriend())
    if IsValid(rndfriend) then
        local pos = self:FindRandomPositionNear(rndfriend:GetPos(), GetConVar("zetaplayer_friendstickneardistance"):GetInt())
        if util.IsInWorld(pos) then
            self:StartActivity(self:GetActivityWeapon('move'))
            self:SetLastActivity(self:GetActivityWeapon('move'))
            self.loco:SetDesiredSpeed(self:GetTravelDistance(pos) >= 1000 and 400 or 200)
            self:MoveToPos(pos)
            self:StartActivity(self:GetActivityWeapon('idle')) 
        end
    else
        self:MovetoRandomPos()
    end

    if IsValid(partner) then
        self:SetState("conversation")
        self.ConversePartner = partner
        self.ConverseTimesMax = math.random(4,15)
        self.ConverseTimes = 0
        self.AllowResponse = true
        self.StartedConverse = true
        self.Question = true
        self.Respond = false
        self.ConverseBegan = false
        
        self.UseTextChat = (100 * zetamath.random() < self.TextChance and GetConVar("zetaplayer_allowtextchat"):GetBool())

        partner.ConversePartner = self
        if partner.IsZetaPlayer then
            partner:CancelMove()
            partner.AllowResponse = false
            partner.Respond = true
            partner.ConverseBegan = false
            partner.UseTextChat = (100 * zetamath.random() < partner.TextChance and GetConVar("zetaplayer_allowtextchat"):GetBool())
            partner.StartedConverse = false
            partner:SetState("conversation")
        end
    elseif !IsValid(self.ConversePartner) then
        self:SetState("idle")
    end
end

function ENT:Converse()
    local dur = 0
    local stop = false

    if !IsValid(self.ConversePartner) or self.ConversePartner.IsZetaPlayer and self.ConversePartner.ConverseBegan and self.ConversePartner:GetState() != "conversation" then 
        if self.ConversePartner.IsZetaPlayer and self.ConversePartner.ConverseBegan and self.ConversePartner:GetState() != "conversation" then
            stop = true
        end
        self:SetState("idle") 
        self.StartedConverse = false 
        return 
    end

    if self:GetRangeSquaredTo(self.ConversePartner) > (100*100) then
        local pos = (self.ConversePartner:GetPos() + self:GetNormalTo(self:GetPos(), self.ConversePartner:GetPos())*90)
        self:GotoEntity(self.ConversePartner, 90)
        if !IsValid(self.ConversePartner) then self:SetState("idle") return end
        self:StartActivity(self:GetActivityWeapon('idle')) 
        self:FaceTick(self.ConversePartner, 100)
    end

    self:ConverseWait()
    self.ConverseBegan = true
    if self.ConversePartner.IsZetaPlayer then
        self.ConversePartner.ConverseBegan = true
    end
    if self.StartedConverse then
        self.ConverseTimes = self.ConverseTimes + 1
    end

    if self.ConversePartner:IsPlayer() then
        if zetamath.random(2) == 1  then
            self.Question = true
            self.Respond = false
        else
            self.Question = false
            self.Respond = true
        end
    end

    if self.Question then
        if self.ConversePartner.IsZetaPlayer then
            if zetamath.random(4) == 1 then
                self.Respond = true
                self.Question = false 

                self.ConversePartner.Respond = false
                self.ConversePartner.Question = true
            else
                self.Question = false 
                self.ConversePartner.Respond = true
                self.ConversePartner.Question = false
            end
        end

        if !self.UseTextChat then
            dur = self:PlayQuestionLine() or 0
        else
            self.text_keyent = self.ConversePartner:IsPlayer() and self.ConversePartner:GetName() or self.ConversePartner.IsZetaPlayer and self.ConversePartner.zetaname
            dur = self:TypeMessage("idle")
        end
    elseif self.Respond then
        if self.ConversePartner.IsZetaPlayer then
            if zetamath.random(4) == 1  then
                self.Question = true
                self.Respond = false

                self.ConversePartner.Question = false 
                self.ConversePartner.Respond = true
            else
                self.Respond = false

                self.ConversePartner.Question = true 
                self.ConversePartner.Respond = false
            end
        end

        if !self.UseTextChat then
            dur = self:PlayRespondLine() or 0
        else
            self.text_keyent = self.ConversePartner:IsPlayer() and self.ConversePartner:GetName() or self.ConversePartner.IsZetaPlayer and self.ConversePartner.zetaname
            dur = self:TypeMessage("response")
        end
    end

    timer.Simple(dur, function()
        if !IsValid(self) then return end
        if self.StartedConverse and self.ConverseTimes >= self.ConverseTimesMax then
            self:SetState("idle")
            if self.ConversePartner.IsZetaPlayer then
                self.ConversePartner:SetState("idle")
            elseif self.ConversePartner:IsPlayer() then
                self.ConversePartner.ConversePartner = nil
            end
            stop = true 
            return
        end
        
        if !IsValid(self.ConversePartner) then return end
        if self.ConversePartner.IsZetaPlayer then
            self.ConversePartner.AllowResponse = true
        elseif self.ConversePartner:IsPlayer() then
            timer.Create("zetaconverse_playertimeout"..self:EntIndex(),10,1,function()
                if !IsValid(self) then return end
                self.AllowResponse = true
            end)
        end
    end) 

    while true do
        if !IsValid(self.ConversePartner) then break end
        if stop then break end
        if self.AllowResponse then break end
        if self:GetState() != "conversation" then
            if IsValid(self.ConversePartner) and self.ConversePartner:IsPlayer() then
                self.ConversePartner.ConversePartner = nil
            end
            break 
        end
        if self.ConversePartner.IsZetaPlayer and self.ConversePartner.ConverseBegan and self.ConversePartner:GetState() != "conversation" then self:SetState("idle") self.StartedConverse = false return end
        coroutine.yield()
    end
end

function ENT:SittingState()
    if zetamath.random(20) == 1 and !self.PlayingPoker then 
        self:ExitVehicle() 
        return 
    end
    if zetamath.random(2) == 1 then return end

    local pos = self:GetPos() + VectorRand(-500, 500)
    if zetamath.random(3) == 1 then
        local insight = self:FindInSight(self.SightDistance, function(ent) return IsValid(ent) end)
        if #insight > 0 then pos = insight[zetamath.random(#insight)] end
    end
    self:LookAt2("zetalookatboth", math.random(100,400), pos)
end

function ENT:FindGPokerTable()
    local pokerTbl = NULL
    self:CreateThinkFunction("zetafindpokertbl", 0.5, 0, function()
        local pokerTables = self:FindInSight(self.SightDistance, function(ent)
            return (IsValid(ent) and (ent:GetClass() == 'ent_poker_game' or ent:IsVehicle() and IsValid(ent:GetParent()) and ent:GetParent():GetClass() == 'ent_poker_game'))
        end)
        for _, v in RandomPairs(pokerTables) do
            if v:IsVehicle() then v = v:GetParent() end
            if ((v:GetBotsPlaceholder() and v:getPlayersAmount() < v:GetMaxPlayers()) or (#v.players < v:GetMaxPlayers())) then
                pokerTbl = v
                self:CancelMove()
                return "failed"
            end
        end
    end)

    local rndfriend = ((GetConVar("zetaplayer_stickwithplayer"):GetBool() and self:HasPlayerFriend()) and self:GetPlayerFriend() or self:GetRandomFriend())
    if IsValid(rndfriend) then
        local pos = self:FindRandomPositionNear(rndfriend:GetPos(), GetConVar("zetaplayer_friendstickneardistance"):GetInt())
        if util.IsInWorld(pos) then
            self:StartActivity(self:GetActivityWeapon('move'))
            self:SetLastActivity(self:GetActivityWeapon('move'))
            self.loco:SetDesiredSpeed(self:GetTravelDistance(pos) >= 1000 and 400 or 200)
            self:MoveToPos(pos)
            self:StartActivity(self:GetActivityWeapon('idle')) 
        end
    else
        self:MovetoRandomPos()
    end

    if IsValid(pokerTbl) then
        self:StartActivity(self:GetActivityWeapon('move'))
        self:SetLastActivity(self:GetActivityWeapon('move')) 
        self.loco:SetDesiredSpeed(self:GetTravelDistance(pokerTbl:GetPos()) > 1000 and 400 or 200)
        self:ZETA_MoveTo(pokerTbl, {tolerance=96})
        self:StartActivity(self:GetActivityWeapon('idle'))
        self:JoinPokerGame(pokerTbl)
    end
end