-----------------------------------------------
-- Vehicle Driving
--- This is where Zeta's drivers license is from
-----------------------------------------------
AddCSLuaFile()

if ( CLIENT ) then return end

local IsValid = IsValid

ENT.PreventExitOnFirst = true

function ENT:IsNormalSeat(ent)
    return (_ZETANORMALSEATS[ent:GetModel()] or false)
end

function ENT:EnterVehicle(vehicle,IsCar)
    if !IsValid(vehicle) or IsValid(vehicle:GetDriver()) and vehicle:GetDriver() != self then return end

    local entIndex = self:EntIndex()

    if vehicle.IsSimfphyscar then
        local seatEnt = vehicle:GetDriverSeat()
        if !IsValid(seatEnt) then return end

        vehicle:SetActive(true)
        vehicle:StartEngine()
        vehicle:SetDriver(self)

        if !vehicle.ZetaExitFunction then
            local hookTbl = hook.GetTable().PlayerLeaveVehicle
            if hookTbl and isfunction(hookTbl.simfphysVehicleExit) then
                vehicle.ZetaExitFunction = hookTbl.simfphysVehicleExit
            end
        end

        self:SetMoveType(MOVETYPE_NONE)
        self:SetPos(seatEnt:GetPos())
        self:SetAngles(seatEnt:GetAngles() + Angle(0,90,0))
        self:SetParent(vehicle)
    else
        local seatAttach = vehicle:LookupAttachment('vehicle_feet_passenger0')
        if seatAttach <= 0 then return end
        local seatData = vehicle:GetAttachment(seatAttach)

        if IsCar then vehicle:StartEngine(true) end
        vehicle:SetSaveValue("m_hNPCDriver", self)
        vehicle.SeatAttachment = seatAttach

        self:SetMoveType(MOVETYPE_NONE)
        self:SetPos(seatData.Pos)
        self:SetAngles(seatData.Ang)
        self:SetParent(vehicle)
    end

    self.Vehicle = vehicle
    self.PreventExitOnFirst = true
    self.IsDriving = true
    self:ChangeWeapon('NONE')
    self:CancelMove()
    self:StopFacing()

    self:StartActivity(IsCar and ACT_DRIVE_JEEP or ACT_GMOD_SIT_ROLLERCOASTER)
    self:SetState(IsCar and 'driving' or "sitting")

    vehicle.Zetadriven = true

    self:CreateThinkFunction("FixVehicleTransformations", 0, 0, function()
        if !IsValid(self.Vehicle) then return "stop" end
        if self.Vehicle.IsSimfphyscar then
            local seatEnt = self.Vehicle:GetDriverSeat()
            self:SetPos(seatEnt:GetPos())
            self:SetAngles(seatEnt:GetAngles() + Angle(0,90,0))
        else
            local seatData = self.Vehicle:GetAttachment(self.Vehicle.SeatAttachment)
            self:SetPos(seatData.Pos)
            self:SetAngles(seatData.Ang)
        end
        self.loco:SetVelocity(Vector(0,0,0))
        self:StartActivity(IsCar and ACT_DRIVE_JEEP or ACT_GMOD_SIT_ROLLERCOASTER)
    end)

    hook.Add('PhysgunPickup', 'ZetaVehicle_PreventPhysgun_'..entIndex, function(ply,ent)
        if !IsValid(self) or !IsValid(self.Vehicle) then hook.Remove('PhysgunPickup', 'ZetaVehicle_PreventPhysgun_'..entIndex) return end
        return (ent != self)
    end)
    hook.Add("EntityTakeDamage","zetavehicle_damageowner"..entIndex,function(ent,dmginfo)
        if !IsValid(self) or !IsValid(self.Vehicle) then hook.Remove("EntityTakeDamage","zetavehicle_damageowner"..entIndex) return end
        if ent == self.vehicle then
            local flDmg = dmginfo:GetDamage()
            local flRatio = (100-50/100)
            local flNew = flDmg * flRatio
            local flBonus = (dmginfo:IsExplosionDamage() and 2.0 or 1.0)

            flDmg = flNew
            dmginfo:SetDamage(flDmg)
            self:TakeDamageInfo(dmginfo)
        end
    end)
    hook.Add('EntityRemoved', 'ZetaVehicle_OnRemoved_'..entIndex, function(ent)
        if ent == self or IsValid(self.Vehicle) and ent == self.Vehicle then
            hook.Remove('EntityRemoved', 'ZetaVehicle_OnRemoved_'..entIndex)
            if IsValid(self.Vehicle) then
                if ent == self then
                    if self.Vehicle.IsSimfphyscar then
                        self.Vehicle:SetDriver(NULL)
                        self.Vehicle:SetActive(false)
                        self.Vehicle:StopEngine()
                    else
                        self.Vehicle:SetSaveValue("m_hNPCDriver", NULL)
                        self.Vehicle:StartEngine(false)
                    end
                    self.Vehicle.Zetadriven = false
                elseif ent == self.Vehicle then
                    self:SetParent(nil)
                    self:SetMoveType(MOVETYPE_CUSTOM)

                    self:SetState("idle")
                    self:StartActivity(self:GetActivityWeapon('idle'))
                    self.IsDriving = false
                    self:OnLeaveGround()

                    local exitPos = self:GetVehicleExitPosition()
                    if exitPos then
                        self:SetPos(exitPos)
                    end

                    self.Vehicle = NULL
                end
            end
        end
    end)
end

function ENT:GetInfoNum(cVarName, default) -- Doesn't starts the simfphys's engine without it for some reason
    return 0
end

function ENT:GetVehicleExitPosition()
    if self.Vehicle.ZetaExitFunction then
        self.GetVehicle_UseDriverSeat = true
        self.Vehicle.ZetaExitFunction(self, self.Vehicle)
        self.GetVehicle_UseDriverSeat = false
        return
    end

    local exitPoint = (!self.Vehicle.IsSimfphyscar and self.Vehicle:CheckExitPoint(self.Vehicle:GetAngles().y, 192) or nil) 
    if !exitPoint then
        local dirs = {
            self.Vehicle:GetRight()*128,
            self.Vehicle:GetRight()*-128,
            self.Vehicle:GetForward()*128,
            self.Vehicle:GetForward()*-128
        }
        for i = 1, #dirs do
            local exitPos = self.Vehicle:GetPos() + dirs[i]
            local tr = util.TraceLine({start = self.Vehicle:GetPos(),endpos = exitPos,filter = {self, self.Vehicle}})
            if !tr.Hit then exitPoint = exitPos break end
        end
    end
    return exitPoint
end

function ENT:ExitVehicle()
    if !IsValid(self.Vehicle) then return end

    -- This to avoid zeta instantly getting flung by vehicle's collision
    local oldGroup = self:GetCollisionGroup()
    self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
    timer.Simple(1, function()
        if !IsValid(self) then return end
        self:SetCollisionGroup(oldGroup)
    end)

    self.IsDriving = false
    self.Vehicle.Zetadriven = false
    
    self:SetParent(nil)
    self:SetMoveType(MOVETYPE_CUSTOM)
    self.PreventExitOnFirst = true
    self:SetState("idle")
    self:StartActivity(self:GetActivityWeapon('idle'))
    
    if self.Vehicle.IsSimfphyscar then
        self.Vehicle:SetDriver(NULL)
        self.Vehicle:SetActive(false)
        self.Vehicle:StopEngine()
    else
        self.Vehicle:SetSaveValue("m_hNPCDriver", NULL)
        self.Vehicle:StartEngine(false)
    end

    local exitPos = self:GetVehicleExitPosition()
    if exitPos then self:SetPos(exitPos) end

    if self.GPoker_QuitAction then
        if self.GPoker_QuitAction == 1 then
            local surroundings = self:FindInSight(self.SightDistance, function(ent)
                return (IsValid(ent) and !ent.PlayingPoker and self:CanTarget(ent))
            end)
            if #surroundings > 0 then self:AttackEnemy(surroundings[math.random(#surroundings)], true) end
        elseif self.GPoker_QuitAction == 2 then
            self:Panic(self.Vehicle)
        end
        self.GPoker_QuitAction = nil
    end
    self.Vehicle = NULL
end

function ENT:Drive(ent_pos)
    self.ThrottleOn = true

    local pathent = ents.Create('zeta_vehicle_path')
    pathent:SetPos(self:GetPos())
    pathent.VehicleOwner = self
    pathent:Spawn()
    self:DeleteOnRemove(pathent)

    local dist = 500
    if type(ent_pos) != 'Vector' then
        pathent.TargetEnt = ent_pos
        dist = 100
    end

    local timeout = CurTime() + 15
    timer.Simple(1,function()
        if !IsValid(self) or !IsValid(self.Vehicle) then return end
        
        self:CreateThinkFunction("DriveVehicle", 0, 0, function()
            if !IsValid(self.Vehicle) then return "stop" end

            if self.Vehicle.IsSimfphyscar and self.Vehicle:OnFire() or !IsValid(pathent) or !pathent.ContinuetoGoal and (CurTime() > timeout or !pathent.loco:IsAttemptingToMove() and pathent:GetRangeSquaredTo(self.Vehicle) <= (dist*dist))  then 
                if pathent.IsChasing then return end
                self.ThrottleOn = false
                self:SetPoseParameter('vehicle_steer', 0)

                if self.Vehicle.IsSimfphyscar then
                    self.Vehicle.PressedKeys["W"] = false
                    self.Vehicle.PressedKeys["S"] = false
                else
                    self.Vehicle:SetHandbrake(true)
                    self.Vehicle:SetThrottle(0)
                    self.Vehicle:SetSteering(0, 0)
                end

                if IsValid(pathent) then pathent:Remove() end
                return "stop" 
            end

            if self.Vehicle.IsSimfphyscar then
                self.Vehicle.PressedKeys["W"] = false
                self.Vehicle.PressedKeys["A"] = false
                self.Vehicle.PressedKeys["S"] = false                
                self.Vehicle.PressedKeys["D"] = false
            else
                self.Vehicle:SetHandbrake(false)
            end

            local loca = self:WorldToLocalAngles((pathent:GetPos() - self:GetPos()):Angle())
            local locathrottle = loca + Angle(0, 90, 0)
            if locathrottle.y < 0 or locathrottle.y > 180 then
                if self.Vehicle.IsSimfphyscar then 
                    self.Vehicle.PressedKeys["S"] = true
                    self.Vehicle:PlayerSteerVehicle(self, 0, 1)
                else
                    self.Vehicle:SetThrottle(-1)
                    self.Vehicle:SetSteering(1, 0)
                end
                self:SetPoseParameter('vehicle_steer', 1)
            else
                local steerMath = math.Clamp(-loca.y / 5, -1, 1)
                if self.Vehicle.IsSimfphyscar then 
                    self.Vehicle.PressedKeys["W"] = true
                    self.Vehicle:PlayerSteerVehicle(self, ((steerMath < 0) and -steerMath or 0), ((steerMath > 0) and steerMath or 0))
                else
                    self.Vehicle:SetThrottle(1)
                    self.Vehicle:SetSteering(steerMath, 0)
                end
                self:SetPoseParameter('vehicle_steer', steerMath)
            end
        end)
    end)

    while self.ThrottleOn do
        coroutine.yield()
    end
end

function ENT:FindTargetToRam()
    if !GetConVar('zetaplayer_allowattacking'):GetBool() then return end
    local surroundings = {}
    for _, v in ipairs(ents.FindInSphere(self:GetPos(), 1500)) do
        if IsValid(v) and v != self and (v:IsNPC() or (((v:IsPlayer() and !GetConVar("ai_ignoreplayers"):GetBool()) or v.IsZetaPlayer) and !self:IsFriendswith(v) and !self:IsInTeam(v))) then
            surroundings[#surroundings+1] = v
        end
    end
    return (#surroundings <= 0 and NULL or surroundings[math.random(#surroundings)])
end

function ENT:GetDrivableRandomPos()
    local drivePos = self:FindRandomPosition(math.max(1500, GetConVar('zetaplayer_wanderdistance'):GetInt()))
    return drivePos
end