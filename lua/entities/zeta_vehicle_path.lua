AddCSLuaFile()
ENT.Base = "base_nextbot"





local HullTrace = util.TraceHull
local math = math
local util = util

ENT._ZetaVehicleLeader = true
ENT.IsChasing = false

function ENT:Initialize()
	if CLIENT then return end

	self:SetModel('models/hunter/plates/plate.mdl')
    --self:SetMaterial('models/wireframe')
	self:SetNoDraw(true)
	self:DrawShadow(false)
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:SetHealth(-1)

	local entindex = self:EntIndex()
	hook.Add("EntityTakeDamage","zetavehicleleaderpreventdamage"..entindex,function(ent,dmginfo)
		if !IsValid(self) then hook.Remove("EntityTakeDamage","zetavehicleleaderpreventdamage"..entindex) return end
		if ent == self then return true end
	end)
	self.loco:SetAcceleration(1000)

	self.MoveSpeed = 400
	self.Thinktime = CurTime()+1
	self.IsMoving = false
	self.ContinuetoGoal = false
end

function ENT:ChaseEntity(ent)
    if !IsValid(ent) then return end
    
	local path = Path('Follow')
    path:SetMinLookAheadDistance(1)
	path:SetGoalTolerance(0)
	path:Compute(self, ent:GetPos())
	if !path:IsValid() then return "failed" end
	self.IsChasing = true
	while path:IsValid() and ent:IsValid() do
        if path:GetAge() > 0.1 then
            path:Compute(self, ent:GetPos())
        end
        if GetConVar('zetaplayer_debug'):GetBool() then
			path:Draw()
        end
		
		if self.loco:IsStuck() then
			self:HandleStuck()
			return "stuck"
		end

		path:Update( self )
		coroutine.yield()
	end
	self.IsChasing = false

	return "ok"
end

local determinetracetbl = {}

function ENT:DetermineStuckNormal()
	local owner = self.VehicleOwner
	
	determinetracetbl.start = owner:GetPos()+owner:GetForward()*160
	determinetracetbl.endpos = owner:GetPos()+owner:GetForward()*160
	determinetracetbl.mins = Vector(-50,-50,-5)
	determinetracetbl.maxs = Vector(50,50,40) 
	determinetracetbl.filter = {owner,owner.Vehicle}
	local fronttrace = self:TraceHull(determinetracetbl,true)

	if fronttrace.Hit then
		return -owner:GetForward()
	else
		return owner:GetForward()
	end
end

function ENT:TraceHull(tbl,debugbool)
	local trace = HullTrace(tbl)
	if debugbool then
		debugoverlay.Box(tbl.start,tbl.mins,tbl.maxs,2,color_white) 
	end
	return trace
end

function ENT:Think()
	if CLIENT then return end
	if CurTime() < self.Thinktime then return end



	self.Thinktime = CurTime()+0.2


	if IsValid(self.VehicleOwner) then
		local distancetoowner = self:GetRangeTo(self.VehicleOwner)

		self.MoveSpeed = 400/(distancetoowner/400)
	end

	if IsValid(self.VehicleOwner.Vehicle) and self.VehicleOwner.Vehicle:GetVelocity():Length() <= 10 and !timer.Exists("vehicleleaderunstuckowner"..self:EntIndex()) then
		timer.Create("vehicleleaderunstuckowner"..self:EntIndex(),3,1,function()
			if !IsValid(self) then return end
			self.ContinuetoGoal = true
			self:SetPos(self.VehicleOwner:GetPos()+self:DetermineStuckNormal()*250)
			self:CancelMove()
			self.loco:ClearStuck()
		end)
		
	elseif IsValid(self.VehicleOwner.Vehicle) and self.VehicleOwner.Vehicle:GetVelocity():Length() >= 50 then
		timer.Remove("vehicleleaderunstuckowner"..self:EntIndex())
	end


	self.loco:SetDesiredSpeed(self.MoveSpeed)
end


function ENT:CancelMove()
	if self.IsMoving == true then
	  self.AbortMove = true
	end
  end

function ENT:GotoPos(pos)
	if !pos then return end
    local path = Path('Follow')
    path:SetMinLookAheadDistance(1)
	path:SetGoalTolerance(45)
	path:Compute(self, pos)
	if !path:IsValid() then return "failed" end

	self.IsMoving = true

	while path:IsValid() do
		if self.AbortMove then break end

        if GetConVar('zetaplayer_debug'):GetBool() then
			path:Draw()
        end
		
		if self.loco:IsStuck() then
			self:HandleStuck()
			return "stuck"
		end

		path:Update( self )
		coroutine.yield()
	end

	self.IsMoving = false
	return "ok"
end

function ENT:HandleStuck()
    self:Remove()
end

function ENT:GetRandomGlobalPos()
	for _,area in RandomPairs(_ZETANAVMESH) do
		if IsValid(area) and area:GetSizeX() > 100 and area:GetSizeY() > 100 and !area:IsUnderwater() then
			return area:GetRandomPoint()
		end
	end
	return self:GetPos() + VectorRand(-6000, 6000)
end

function ENT:GetDrivableRandomPos()
    local dist = 6000
    local drivePos = self:GetPos() + VectorRand(-dist, dist)
	if math.random(1,4) == 1 then
		drivepos = self:GetRandomGlobalPos()
	end
	if !util.IsInWorld(drivePos) then drivePos = self:GetPos() + VectorRand(-dist, dist) end
	return drivePos
end

function ENT:RunBehaviour()
	while true do

		if self.ContinuetoGoal then
			
			self:GotoPos(self.GoalPos or self:GetDrivableRandomPos())
			self.ContinuetoGoal = false
		else
			
			local ent = self.TargetEnt
			if IsValid(ent) then
				self:ChaseEntity(ent)
			else
				self.GoalPos = self.DrivePos or self:GetDrivableRandomPos()
				self:GotoPos(self.GoalPos)
			end

		end
		coroutine.wait(0.5)
	end
end