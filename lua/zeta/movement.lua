-----------------------------------------------
-- Movement Functions
--- This is where Zeta's movement is from
-----------------------------------------------
AddCSLuaFile()



local trace = {}
trace.TraceLine = util.TraceLine
trace.TraceHull = util.TraceHull
trace.QuickTrace = util.QuickTrace
trace.TraceEntity = util.TraceEntity

local oldisvalid = IsValid

local function IsValid( ent )
    if oldisvalid( ent ) and ent.IsZetaPlayer then
        
        return !ent.IsDead 
    else
        return oldisvalid( ent )
    end
end


local math = math
local util = util


local collcheckdata = {} -- Local table so we aren't creating multiple tables. Optimization

function ENT:HandleStuck() -- Find a way to get self unstuck. This function is so fun to see in action
    if self.IsJailed then self.loco:ClearStuck() return end

    if GetConVar("zetaplayer_allowkillbind"):GetBool() and math.random(30) == 1 then
        self:Killbind()
    end

    if GetConVar("zetaplayer_disableunstuck"):GetInt() == 0 then
        collcheckdata.start = self:GetPos()
        collcheckdata.endpos = self:GetPos()
        collcheckdata.filter = self
        local selfcollcheck = trace.TraceEntity(collcheckdata, self)

        if selfcollcheck.Hit then
            self.UnstuckSelf = true
        else
            self.loco:ClearStuck()
        end
    
    else
        self.loco:ClearStuck()
    end
end

function ENT:ToggleNoclip(bool)
    self.InNoclip = bool
    if bool then
        self:AddGesture(ACT_GMOD_NOCLIP_LAYER,false)
    else
        self:RemoveGesture(ACT_GMOD_NOCLIP_LAYER)
    end
end

local tracetabl = {}

function ENT:GetNoclipSpot(pos)

    tracetabl.start = pos+Vector(0,0,10)
    tracetabl.endpos = pos+Vector(0,0,1000)
    local testtrace = trace.TraceLine(tracetabl)
    local spot = pos+Vector(0,0,math.random(0,1000)) 
    if testtrace.Hit then
        tracetabl.start = testtrace.HitPos
        tracetabl.endpos = testtrace.HitPos-Vector(0,0,100)
        local downtrace = trace.TraceLine(tracetabl)
        spot = downtrace.HitPos
    end
    return spot
end

function ENT:NoClipTo(pos)
    if !self:IsInNoclip() then self:ToggleNoclip(true) end
    self.IsMoving = true 
    local frac = 0
    local stop = false
    local distance = self:GetPos():Distance(pos)
    local dampen = distance/20

    local selfpos = self:GetPos()
    self:CreateThinkFunction("zetanoclip", 0, 0, function()
        if !self:IsInNoclip() then stop = true return "failed" end
        if frac >= 1 then stop = true self.IsMoving = false return "failed" end
        if self.AbortMove then 
            stop = true
            self.AbortMove = false 
            self.IsMoving = false 
            return 'failed' 
        end 
        if !self.TypingInChat then
            self.CurNoclipPos = LerpVector(frac,selfpos,pos)
            frac = frac + 1/dampen
        end
    end)

    self:Face2("zetalookatboth2",100,pos,0)

    while true do
        if stop then break end
        coroutine.yield()
    end
end


function ENT:ZETA_MoveTo(to, options)
    if self:IsInNoclip() then return "failed" end
    local isEntity = !isvector(to)
    if isEntity and !IsValid(to) then return end

    local options = options or {}
	local path = Path("Follow")
	path:SetMinLookAheadDistance(options.lookahead or 500)
	path:SetGoalTolerance(options.tolerance or 20)
    local maxOffset = options.repathoffset or 128
    local pathGenerator = options.generator or self.PathGenerator
    path:Compute(self, (isEntity and to:GetPos() or to), pathGenerator(self))
	if !path:IsValid() then return "failed" end
    self.IsMoving = true

	while (path:IsValid()) do
        if !IsValid(self) then return end
        if isEntity and !IsValid(to) then return "failed" end
        if self.AbortMove then 
            self.AbortMove = false 
            self.IsMoving = false 
            return 'aborted' 
        end 

		if self.loco:IsStuck() then
			self:HandleStuck()
            self.IsMoving = false
			return "stuck"  
		end

        if options.update then
            local updateTime = options.updatetime or math.max(0.1, 0.1 * (path:GetLength() / 400))
            if path:GetAge() > updateTime then
                path:Compute(self, (isEntity and to:GetPos() or to), pathGenerator(self))
            end
        end

        local canRepath = options.repath or true
        if canRepath and CurTime() > self.NextRepathCheckT then
            local area = path:GetCurrentGoal() and path:GetCurrentGoal().area or nil
            if IsValid(area) and area:IsValid() and self.loco:IsAreaTraversable(area) then
                local distOffset = self:GetRangeSquaredTo(path:GetClosestPosition(self:GetPos()))
                if distOffset > (maxOffset*maxOffset) then path:Compute(self, (isEntity and to:GetPos() or to), pathGenerator(self)) end
            end
            local interval = options.repathdelay or 1.0
            self.NextRepathCheckT = CurTime() + interval
        end

        if options.customfunc then 
            local shouldAbort = options.customfunc(path) 
            if shouldAbort == "abort" then return "aborted" end
        end

        if options.draw or GetConVar('zetaplayer_debug_displaypathfindingpaths'):GetBool() then
			path:Draw()
        end
        if !self.TypingInChat then
            path:Update( self )
        end

        local climbLadders = options.climbladders or true
        if climbLadders then self:CheckForLadders(path, (isEntity and to:GetPos() or to)) end

        self:Avoid()
        self:Adapt()

        coroutine.yield()
    end

    self.IsMoving = false
	return "ok"
end

function ENT:MoveToPos( pos, run, update )
    if self:IsInNoclip() then return "failed" end
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( 500 )
	path:SetGoalTolerance( 20 )
    local timeout = CurTime()+30
    
	path:Compute( self, pos, self:PathGenerator())

    
	if ( !path:IsValid() ) then  return   "failed" end


    self.IsMoving = true -- We are moving

	while ( path:IsValid() ) do
        if self.AbortMove == true then self.AbortMove = false self.IsMoving = false return 'aborted' end 

        if GetConVar('zetaplayer_debug_displaypathfindingpaths'):GetInt() == 1 then
			path:Draw()
        end
        
        if update then
            if path:GetAge() > 0.1 then
                path:Compute( self, pos, self:PathGenerator())
            end
        elseif CurTime() > self.NextRepathCheckT then
            local area = path:GetCurrentGoal().area
            if IsValid(area) and area:IsValid() and self.loco:IsAreaTraversable(area) then
                local distOffset = self:GetRangeSquaredTo(path:GetClosestPosition(self:GetPos()))
                if distOffset > (128*128) then path:Compute(self, pos, self:PathGenerator()) end
            end
            self.NextRepathCheckT = CurTime() + 1.0
        end





		
		if ( self.loco:IsStuck() )  then

			self:HandleStuck()
            self.IsMoving = false

			return "stuck"  
		end

        self:CheckForLadders(path, pos)
        if !self.TypingInChat then
            path:Update( self )
        end
        -- Custom Abort code incase we change our mind on the move


        
        self:Avoid()
        self:Adapt()


		coroutine.yield()
    
	end
    
    self.IsMoving = false

    
	return "ok"

end

function ENT:FollowEntity( ent, run, goaltoler )
    if self:IsInNoclip() then return "failed" end
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( 500 )
	path:SetGoalTolerance( goaltoler )

    
	path:Compute( self, ent:GetPos(), self:PathGenerator())

    
	if ( !path:IsValid() ) then  return   "failed" end


    self.IsMoving = true -- We are moving

	while ( path:IsValid() and IsValid(ent) ) do
        if self.AbortMove == true then self.AbortMove = false self.IsMoving = false  return 'aborted' end 

        if GetConVar('zetaplayer_debug_displaypathfindingpaths'):GetInt() == 1 then
			path:Draw()
        end
        
        if path:GetAge() > 0.1 then
            path:Compute( self, ent:GetPos(), self:PathGenerator())
        end








		
		if ( self.loco:IsStuck() )  then

			self:HandleStuck()
            self.IsMoving = false
			return "stuck"  
		end

        
        self:CheckForLadders(path, ent:GetPos())

        if !self.TypingInChat then
            path:Update( self )
        end



        self:Avoid()
        self:Adapt()


		coroutine.yield()
    
	end
    
    self.IsMoving = false

    
	return "ok"

end


function ENT:WalkBackWards(tick)
    local index = self:EntIndex()
    timer.Create('zetawalkback'..index, 0, tick, function()
        if !IsValid(self) then timer.Remove('zetawalkback'..index) return end
        self.loco:Approach(self:GetPos()+self:GetForward()*-500, 1)
        self:StartActivity(self:GetActivityWeapon('move'))
    end)
end

function ENT:WalkDir(dir)
    local time = CurTime()+0.1
    while true do
        if CurTime() > time then break end
        local direction =  self:GetPos()+(self:GetPos()-dir):Angle():Forward()*100
        debugoverlay.Sphere(direction,6,0.2,Color(100,100,100),true)
        --Entity(1):SetPos(direction)
        self.loco:FaceTowards(direction)
        self.loco:Approach(direction, 1)
        --self.loco:Approach(direction,1)
        coroutine.yield()
    end
end

function ENT:MoveDir(dir)
    local time = CurTime()+0.1
    while true do
        if CurTime() > time then break end
        local direction =  (self:GetPos()+dir)
        debugoverlay.Sphere(direction,6,0.2,Color(100,100,100),true)
        --Entity(1):SetPos(direction)
        self.loco:FaceTowards(direction)
        self.loco:Approach(direction, 1)
        --self.loco:Approach(direction,1)
        coroutine.yield()
    end
end




function ENT:DoorIsOpen( door )
	
	local doorClass = door:GetClass()

	if ( doorClass == "func_door" or doorClass == "func_door_rotating" ) then

		return door:GetInternalVariable( "m_toggle_state" ) == 0

	elseif ( doorClass == "prop_door_rotating" ) then

		return door:GetInternalVariable( "m_eDoorState" ) ~= 0

	else

		return false

	end

end

local hulltbl = {}
local doorClasses = {
    ["prop_door_rotating"]=true,
    ['func_door']=true,
    ['func_door_rotating']=true
}

function ENT:Adapt()
    if self.TypingInChat then return end
    -- This allows the bot to open doors infront of it so it doesn't just give up when it finds out doors exists
    local qt = trace.QuickTrace(self:GetPos()+self:OBBCenter(),self:GetForward()*45,self) 
    local qtent = qt.Entity
    if IsValid(qtent) then
        if doorClasses[qtent:GetClass()] and isfunction(qtent.Fire) and !self:DoorIsOpen(qtent) then
            qtent:Fire("Open")
            if qtent:GetClass() == 'prop_door_rotating' then
                self:WalkBackWards(20)
                local keys = qtent:GetKeyValues()
                local slavedoor = ents.FindByName( keys.slavename )
                if IsValid(slavedoor) then
                    slavedoor:Fire("Open")
                end
            end
        end

        if self.Weapon == "TOOLGUN" and GetConVar("zetaplayer_clearpath"):GetBool() and IsValid(qtent) and math.random(20) == 1 and zeta_NonPlayerNPC(qtent) then
            self:UseRemoverTool(qtent)
        end
        
        if GetConVar("zetaplayer_clearpath"):GetBool() and self.HasLethalWeapon and math.random(20) == 1 and qtent:Health() > 0 and zeta_NonPlayerNPC(qtent) then
            timer.Create("zetaspamshoot"..self:EntIndex(), 0, math.random(500), function()
                if !IsValid(self) or !IsValid(qtent) then return end
                if self.HasMelee then
                    self:UseMelee(qtent)
                else
                    self:FireWeapon(qtent)
                end
                self.loco:FaceTowards(qtent:GetPos())
            end)
        end
    end

    -- This let's the bot know that it needs to either crouch or jump depending on what it encountered. This is pretty cool
    -- util.QuickTrace(self:GetPos()+Vector(0,0,66),self:GetForward()*50,self)
    local headmins, headmaxs = Vector(-19, -19, 0),Vector(19, 19, 5)
    hulltbl.start = self:GetPos()+Vector(0,0,66)
    hulltbl.endpos = self:GetPos()+Vector(0,0,66)
    hulltbl.mins =  headmins
    hulltbl.maxs = headmaxs
    hulltbl.filter = {self,self.WeaponENT,self.GrabbedENT,self.PhysgunnedENT}
    local headtrace = trace.TraceHull(hulltbl) -- Crouch trace check
    debugoverlay.Box(self:GetPos()+Vector(0,0,66),headmins,headmaxs,0,Color(255,255,255,100))

    --util.QuickTrace(self:GetPos()+Vector(0,0,45),self:GetForward()*45,self)
    local legmins, legmaxs = Vector(-19, -19, -5), Vector(19, 19, 5)
    hulltbl.start = self:GetPos()+Vector(0,0,15)
    hulltbl.endpos = self:GetPos()+Vector(0,0,15)
    hulltbl.mins =  Vector(-17,-17,-5)
    hulltbl.maxs = Vector(17,17,5)
    hulltbl.filter = {self,self.WeaponENT,self.GrabbedENT,self.PhysgunnedENT}
    local legtrace = trace.TraceHull(hulltbl) -- Jump Trace check
    debugoverlay.Box(self:GetPos()+Vector(0,0,15),legmins,legmaxs,0,Color(255,255,255,100))

    local Standblocked = headtrace.Hit
    local Crouchblocked = legtrace.Hit

    if legtrace.Entity == self.GrabbedENT or legtrace.Entity == self.PhysgunnedENT then 
        Crouchblocked = false 
    end

    if !Standblocked or !Crouchblocked then -- Jump or crouch if there is something partially blocking our way.
        if Standblocked then 
            if headtrace.Entity:GetCollisionGroup() != COLLISION_GROUP_WORLD then
                self.IsCrouching = true
                self:StartActivity(self:GetActivityWeapon('crouch'))
            end
        else
            self.IsCrouching = false
            if self:GetActivity() != self:GetLastActivity() then
                self:StartActivity(self:GetLastActivity())
            end
        end

        if !GetConVar("zetaplayer_disablejumping"):GetBool() and Crouchblocked and !Standblocked and legtrace.Entity:GetCollisionGroup() != COLLISION_GROUP_WORLD and self.CanJump then    
            self.IsJumping = true 
            self:SetLastActivity(self:GetActivity())
            self.loco:Jump()
            self.JumpDirection = (legtrace.HitPos-(self:GetPos()+self:GetUp()*15)):Angle():Forward()
        end
    end
end


function ENT:CheckForLadders(path, pos)
    if !path or !path:IsValid() then return end
    if self.NextLadderClimbT and CurTime() <= self.NextLadderClimbT then return end
	local curGoal = path:GetCurrentGoal()
	if !istable(curGoal) then return end
	
	local moveType = curGoal.type
	if moveType != 4 and moveType != 5 then return end
	
    local ladder = curGoal.ladder
    if !ladder or !ladder:IsValid() then return end

	local ladderPos = (moveType == 4 and ladder:GetBottom() or ladder:GetTop())
	if self:GetRangeSquaredTo(ladderPos) < (64*64) then
		self.PreventFalldamage = true
		self:ClimbLadder(ladder, (moveType == 4 and "up" or "down"))
        self.NextLadderClimbT = CurTime() + 0.66
		path:Compute( self, pos, self:PathGenerator())
        self.InAir = false
		self.PreventFalldamage = false
	end
end

function ENT:ClimbLadder(ladder,dir)
	local nextSndTime = CurTime()

    self.IsClimbingLadder = true

	local startPos = ladder:GetTop()
	local goalPos = ladder:GetBottom()
	local finishPos = ladder:GetBottomArea():GetCenter()
	if dir == "up" then
		startPos = ladder:GetBottom()
		goalPos = ladder:GetTop()
		
		local possibleAreas = {}
		if IsValid(ladder:GetTopForwardArea()) then table.insert(possibleAreas, ladder:GetTopForwardArea()) end
		if IsValid(ladder:GetTopBehindArea()) then table.insert(possibleAreas, ladder:GetTopBehindArea()) end
		if IsValid(ladder:GetTopLeftArea()) then table.insert(possibleAreas, ladder:GetTopLeftArea()) end
		if IsValid(ladder:GetTopRightArea()) then table.insert(possibleAreas, ladder:GetTopRightArea()) end

		finishPos = possibleAreas[math.random(#possibleAreas)]:GetCenter()
	end

    local climbSpeed = math.Rand(2.5,4)
    local climbFract = 0

    local climbDur = (startPos:Distance(goalPos) / (climbSpeed*70))
	local forceStopTime = CurTime()+climbDur+5

    local preFinishPos = nil
    while ( true ) do
        if CurTime() > forceStopTime then break end

        if CurTime() > nextSndTime then
            self:EmitSound('player/footsteps/ladder'..math.random(4)..'.wav',75)
            nextSndTime = CurTime() + 0.466
        end

		self.loco:FaceTowards(self:GetPos()-ladder:GetNormal())
        
        climbFract = climbFract + climbSpeed
        local moveDir = (goalPos-startPos):Angle():Forward()
        self:SetPos((startPos + ladder:GetNormal()*10)+moveDir*climbFract)

        if climbFract >= startPos:Distance(goalPos) then
            if !preFinishPos then preFinishPos = self:GetPos() end
            climbFract = 0
            local fwd = (finishPos - self:GetPos()):Angle():Forward()
            while ( true ) do
                if CurTime() > forceStopTime  then break end
                climbFract = climbFract + climbSpeed
                self:SetPos(preFinishPos+fwd*climbFract)
                if climbFract >= preFinishPos:Distance(finishPos) then break end
                coroutine.yield()
            end
            break
        end

        coroutine.yield()
    end

    self.IsClimbingLadder = false
end


--[[ {
    start = area:GetCenter()+Vector(0,0,40),
    endpos = (fromArea:GetCenter()+Vector(0,0,40)),
    ignoreworld = true,
    filter = function(ent) if PointENTS[ent:GetClass()] then return true end end
} ]]

local PointENTS = {
    ["prop_physics"] = true,
    ["prop_physics_multiplayer"] = true,
    ["func_breakable"] = true,
    ["func_physbox"] = true

}

local PathTraceTable = {
    start = Vector(),
    endpos = Vector(),
    ignoreworld = true,
    filter = function(ent) if PointENTS[ent:GetClass()] then return true end end
}




local dynamicPathCvar = GetConVar("zetaplayer_usedynamicpathfinding")
function ENT:PathGenerator()
    local avoidObstacles = dynamicPathCvar:GetBool()
    local stepHeight = self.loco:GetStepHeight()
    local jumpHeight = self.loco:GetJumpHeight()
    local deathHeight = -self.loco:GetDeathDropHeight()

    return function(area, fromArea, ladder, elevator, length)
        if !IsValid(fromArea) then return 0 end
        if !self.loco:IsAreaTraversable(area) then return -1 end

        local dist = 0
        if IsValid(ladder) then
            dist = ladder:GetBottom():DistToSqr(ladder:GetTop())
        elseif length > 0 then
            dist = length
        else
            dist = fromArea:GetCenter():DistToSqr(area:GetCenter())
        end

        local cost = (dist + fromArea:GetCostSoFar())
        if !IsValid(ladder) then
            local deltaZ = fromArea:ComputeAdjacentConnectionHeightChange(area)
            if deltaZ > stepHeight then
                if deltaZ > jumpHeight then return -1 end
                local jumpPenalty = 10
                cost = cost + jumpPenalty * dist
            elseif deltaZ < deathHeight then
                return -1
            end
        end

        if avoidObstacles then
            PathTraceTable.start = (area:GetCenter() + Vector(0, 0, 36))
            PathTraceTable.endpos = (fromArea:GetCenter() + Vector(0, 0, 36))    
            local pointTr = trace.TraceLine(PathTraceTable)
            if pointTr.Hit then return -1 end
        end

        return cost
    end
end

--[[ function ENT:PathGenerator()
return function ( area, fromArea, ladder, elevator, length )


    if ( !IsValid( fromArea ) ) then

        // first area in path, no cost
        return 0
    
    else
    
        if ( !self.loco:IsAreaTraversable( area ) ) then
            // our locomotor says we can't move here

            return -1
        end


        // compute distance traveled along path so far
        local dist = 0

        if ( IsValid( ladder ) ) then
            dist = ladder:GetLength()
        elseif ( length > 0 ) then
            // optimization to avoid recomputing length
            dist = length
        else
            dist = ( area:GetCenter() - fromArea:GetCenter() ):Length()
        end

        local cost = dist + fromArea:GetCostSoFar()

        // check height change

        local deltaZ = fromArea:ComputeAdjacentConnectionHeightChange( area )

        if  !IsValid( ladder )  then
        if ( deltaZ >= 40 ) then

            // too high to reach
            return -1
        end


            // jumping is slower than flat ground
            local jumpPenalty = 5
            cost = cost + jumpPenalty * dist
        elseif ( deltaZ < -self.loco:GetDeathDropHeight() ) then
            // too far to drop
            return -1
        end



        local zetatrace = util.TraceLine({
            start = fromArea:GetClosestPointOnArea(self:GetPos())+Vector(0,0,40),
            endpos = (area:GetCenter()+Vector(0,0,40)),
            ignoreworld = true,
            filter = function(ent) if ent:GetClass() == "prop_physics" or ent:GetClass() == "prop_physics_multiplayer" then return true end end
        })

        debugoverlay.Line(area:GetClosestPointOnArea(self:GetPos())+Vector(0,0,40), (area:GetCenter()+Vector(0,0,40)), 4, Color(0,255,0),true)


        if zetatrace.Hit then
        print("Zeta sight Hit!",zetatrace.Entity)
            return -1
        end


        if GetConVar("zetaplayer_usedynamicpathfinding"):GetInt() == 1 then
            PathTraceTable.start = area:GetCenter()+Vector(0,0,40)
            PathTraceTable.endpos = (fromArea:GetCenter()+Vector(0,0,40))
            
            local pointrace = trace.TraceLine(PathTraceTable)

            

            if pointrace.Hit then 
                --print("Hit!",pointrace.Entity)
                --debugoverlay.Line(fromArea:GetCenter()+Vector(0,0,40), (area:GetCenter()+Vector(0,0,40)), 4, Color(255,0,0),true)
                return -1
            else
                --debugoverlay.Line(fromArea:GetCenter()+Vector(0,0,40), (area:GetCenter()+Vector(0,0,40)), 4, Color(255,255,255),true)
            end
        end



        return cost
    end
    
end


end ]]

function ENT:Avoid()
    if self.TypingInChat then return end
    local nw,ne,sw,se = self:CornerCheck()

    if nw.Hit and ne.Hit then self:MoveDir(self:GetForward()*-50)
    elseif sw.Hit and se.Hit then self:MoveDir(self:GetForward()*50)
    elseif nw.Hit and sw.Hit then self:MoveDir(self:GetRight()*-50)
    elseif ne.Hit and se.Hit then self:MoveDir(self:GetRight()*50)
    elseif nw.Hit then self:WalkDir(nw.HitPos)
    elseif ne.Hit then self:WalkDir(ne.HitPos)
    elseif sw.Hit then self:WalkDir(sw.HitPos)
    elseif se.Hit then self:WalkDir(se.HitPos)
    end
end

ENT.cornerchecktbls = {}

function ENT:CornerCheck()
    local hullmins,hullmaxs = self:GetCollisionBounds()
    hullmaxs[3] = 0
    hullmins[3] = 0
    local collmins,collmaxs = self:GetCollisionBounds()
    collmins[1] = collmins[1]/2
    collmins[2] = collmins[2]/2
    collmaxs[1] = collmaxs[1]/2
    collmaxs[2] = collmaxs[2]/2
    collmaxs[3] = 40

    debugoverlay.Box( self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20), collmins, collmaxs,0,Color(255,255,255,100))
    debugoverlay.Box( self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20), collmins, collmaxs,0,Color(255,255,255,100))
    debugoverlay.Box( self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20), collmins, collmaxs,0,Color(255,255,255,100))
    debugoverlay.Box( self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20), collmins, collmaxs,0,Color(255,255,255,100))

    debugoverlay.Text( self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20), 'NW', 0)
    debugoverlay.Text( self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20), 'NE', 0)
    debugoverlay.Text( self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20), 'SW', 0)
    debugoverlay.Text( self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20), 'SE', 0)

    self.cornerchecktbls.start = self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20)
    self.cornerchecktbls.endpos = self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20)
    self.cornerchecktbls.mins = collmins
    self.cornerchecktbls.maxs = collmaxs
    self.cornerchecktbls.filter = self.cornerchecktbls.filter or {self,self.PhysgunnedENT,self.GrabbedENT}
    local tr1 = trace.TraceHull(self.cornerchecktbls)

    self.cornerchecktbls.start = self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20)
    self.cornerchecktbls.endpos = self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20)
    self.cornerchecktbls.mins = collmins
    self.cornerchecktbls.maxs = collmaxs

    local tr2 = trace.TraceHull(self.cornerchecktbls)

    self.cornerchecktbls.start = self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20)
    self.cornerchecktbls.endpos = self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20)
    self.cornerchecktbls.mins = collmins
    self.cornerchecktbls.maxs = collmaxs

    local tr3 = trace.TraceHull(self.cornerchecktbls)

    self.cornerchecktbls.start = self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20)
    self.cornerchecktbls.endpos = self:GetPos()+Vector(-hullmaxs.x,-hullmaxs.y,20)
    self.cornerchecktbls.mins = collmins
    self.cornerchecktbls.maxs = collmaxs

    local tr4 = trace.TraceHull(self.cornerchecktbls)

return tr1,tr2,tr3,tr4

--[[ return util.TraceHull({start = self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20),endpos = self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20),mins = collmins,maxs = collmaxs,filter = {self,self.PhysgunnedENT,self.GrabbedENT}}),
util.TraceHull({start = self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20),endpos = self:GetPos()+self:GetForward()*hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20),mins = collmins,maxs = collmaxs,filter = {self,self.PhysgunnedENT,self.GrabbedENT}}),
util.TraceHull({start = self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20),endpos = self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*hullmaxs.y+Vector(0,0,20),mins = collmins,maxs = collmaxs,filter = {self,self.PhysgunnedENT,self.GrabbedENT}}),
util.TraceHull({start = self:GetPos()+self:GetForward()*-hullmaxs.x+self:GetRight()*-hullmaxs.y+Vector(0,0,20),endpos = self:GetPos()+Vector(-hullmaxs.x,-hullmaxs.y,20),mins = collmins,maxs = collmaxs,filter = {self,self.PhysgunnedENT,self.GrabbedENT}})
 ]]
end