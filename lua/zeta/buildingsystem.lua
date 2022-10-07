AddCSLuaFile()

local util = util
local math = math

local oldisvalid = IsValid

local function IsValid( ent )
    if oldisvalid( ent ) and ent.IsZetaPlayer then
        
        return !ent.IsDead 
    else
        return oldisvalid( ent )
    end
end


if SERVER then
    util.AddNetworkString("zetaplayer_getdupe")
    util.AddNetworkString("zetaplayer_returndupe")
    util.AddNetworkString("zetaplayer_createdupeicon")

    if !file.Exists("zetaplayerdata/duplications","DATA") then
        file.CreateDir("zetaplayerdata/duplications")
    end

    local function InitializeCoroutineThread(func,warnend) -- Coroutine thread for the PasteDuplication function. Actual code from a StarFall chip I made
        local thread = coroutine.create(func)
        local id = math.random(1000000)
        hook.Add("Think","zetacoroutineengine"..id,function()
            if coroutine.status(thread) != "dead" then
                coroutine.resume(thread)
            else
                hook.Remove("Think","zetacoroutineengine"..id)
                if warnend then
                    print("Coroutine Thread was returned!")    
                end
            end
        end)
    end

    local function MinsMaxsCenter(mins,maxs) -- Returns the center between a min and max vectors
        return LerpVector(0.5,mins,maxs)
    end

    local function CreateEntityFromTable( Player, EntTable,LocalPos,LocalAng )

        --
        -- Convert position/angle to `local`
        --
        if ( EntTable.Pos && EntTable.Angle ) then
    
            EntTable.Pos, EntTable.Angle = LocalToWorld( EntTable.Pos, EntTable.Angle, LocalPos, LocalAng )
    
        end
    
        local EntityClass = duplicator.FindEntityClass( EntTable.Class )
    
        -- This class is unregistered. Instead of failing try using a generic
        -- Duplication function to make a new copy..
        if ( !EntityClass ) then
    
            return duplicator.GenericDuplicatorFunction( Player, EntTable )
    
        end
    
        -- Build the argument list
        local ArgList = {}
    
        for iNumber, Key in pairs( EntityClass.Args ) do
    
            local Arg = nil
    
            -- Translate keys from old system
            if ( Key == "pos" or Key == "position" ) then Key = "Pos" end
            if ( Key == "ang" or Key == "Ang" or Key == "angle" ) then Key = "Angle" end
            if ( Key == "model" ) then Key = "Model" end
    
            Arg = EntTable[ Key ]
    
            -- Special keys
            if ( Key == "Data" ) then Arg = EntTable end
    
            -- If there's a missing argument then unpack will stop sending at that argument so send it as `false`
            if ( Arg == nil ) then Arg = false end
    
            ArgList[ iNumber ] = Arg
    
        end
    
        -- Create and return the entity
        return EntityClass.Func( Player, unpack( ArgList ) )
    
    end


    function ENT:GetRandomDupe(finishfunc)
        net.Start("zetaplayer_getdupe")
        net.Send(Entity(1))

        net.Receive("zetaplayer_returndupe",function()
            local filepath = net.ReadString()

            local dupedata = file.Read( filepath )

            if !dupedata then return end

            local decompressed = util.Decompress(dupedata)

            if !dupedata or !decompressed then return end

            dupedata = util.JSONToTable(decompressed)

            if !dupedata or !istable(dupedata) then return end
            finishfunc(dupedata)
        end)
    end


    function ENT:PasteDuplication(position,offsetangle,dupedata)
        position.z = position.z - dupedata.Mins.z
    
        duplicator.SetLocalPos(position)
        duplicator.SetLocalAng(offsetangle)
    
    
        local EntityList = table.Copy( dupedata.Entities )
        local ConstraintList = table.Copy( dupedata.Constraints )
    
        local Player = Entity(1)
    
        local CreatedEntities = {}
        local unfrozenents = {}
        local ragdollphysicobjects = {}

        InitializeCoroutineThread(function() -- Initialize the Thread and let's get creatin'!
            for k, v in pairs( EntityList ) do -- Create the entities..
                if !IsValid(self) then return end
                local e = nil
                local b = ProtectedCall( function() e = CreateEntityFromTable( Player, v,position,offsetangle ) end ) 
                if ( !b ) then continue end
    
                if ( IsValid( e ) ) then

                    e.IsZetaProp = true
                    self.SpawnedENTS[#self.SpawnedENTS+1] = e

                    self.CurrentSpawnedProps = self.CurrentSpawnedProps + 1

    
                    if ( e.RestoreNetworkVars ) then
                        e:RestoreNetworkVars( v.DT )
                    end
    
                    if ( e.OnDuplicated ) then
                        e:OnDuplicated( v )
                    end
    
                    if e:IsRagdoll() then
                        local count = e:GetPhysicsObjectCount()
                        for i=1,count do
                            local phys = e:GetPhysicsObjectNum(i)
                            if !IsValid(phys) then continue end
                            if !phys:IsMotionEnabled() then
                                unfrozenents[#unfrozenents+1] = phys
                            end
                            phys:EnableMotion(false)
                            ragdollphysicobjects[#ragdollphysicobjects+1] = {phys,phys:GetPos(),phys:GetAngles()}
                        end
                    end

                    local phys = e:GetPhysicsObject()
                    if IsValid(phys) and phys:IsMotionEnabled() then -- Save the unfrozen state for later
                        unfrozenents[#unfrozenents+1] = phys
                        phys:EnableMotion(false)
                    end
                    
                    e:EmitSound(GetConVar("zetaplayer_building_buildentitysound"):GetString(),60)
    
                end
    
                CreatedEntities[ k ] = e
    
                if ( CreatedEntities[ k ] ) then
    
                    CreatedEntities[ k ].BoneMods = table.Copy( v.BoneMods )
                    CreatedEntities[ k ].EntityMods = table.Copy( v.EntityMods )
                    CreatedEntities[ k ].PhysicsObjects = table.Copy( v.PhysicsObjects )
    
                else
    
                    CreatedEntities[ k ] = nil
    
                end
                coroutine.wait(0.05)
            end
    
    
            for EntID, Ent in pairs( CreatedEntities ) do -- Then we apply some modifications. Such as color and ect
                if !IsValid(Ent) then continue end

                duplicator.ApplyEntityModifiers( Player, Ent )
                duplicator.ApplyBoneModifiers( Player, Ent )
                
    
                if ( Ent.PostEntityPaste ) then
                    Ent:PostEntityPaste( Player || NULL, Ent, CreatedEntities )
                end
                coroutine.wait(0.05)
            end
    
    
            local CreatedConstraints = {}
    
    
            for k, Constraint in pairs( ConstraintList ) do -- Create the constraints
    
                local Entity = nil
                ProtectedCall( function() Entity = duplicator.CreateConstraintFromTable( Constraint, CreatedEntities, Player ) end )
    
                if ( IsValid( Entity ) ) then
                    table.insert( CreatedConstraints, Entity )

                    if Entity:GetPos() == Vector(0,0,0) then
                        sound.Play(GetConVar("zetaplayer_building_buildconstraintsound"):GetString(),position,60,100,1)
                    else
                        Entity:EmitSound(GetConVar("zetaplayer_building_buildconstraintsound"):GetString(),60)
                    end
                end

                coroutine.wait(0.05)
            end
    
            for k,phys in ipairs(unfrozenents) do -- Unfreeze the entities we froze earlier since all the constraints have been put into place. After that.. We are done here
                if IsValid(phys) then
                    phys:EnableMotion(true)
                end
            end
    
            sound.Play(GetConVar("zetaplayer_building_finishdupesound"):GetString(),position,80,100,1)
            duplicator.SetLocalPos(Vector(0,0,0))
            duplicator.SetLocalAng(Angle(0,0,0))



            
            return CreatedEntities, CreatedConstraints
        end)
    
    end

    local lostrace = {}

    function ENT:BuildADuplication(position,offsetangle)
        self.BuildingDupe = true


        net.Start("zetaplayer_getdupe")
        net.Send(Entity(1))
        local dupedata

        local retrievingdata = true

        local id = self:GetCreationID()
        timer.Create( "zetabuildingtimeout" .. id, 5, 1, function() 
            if !IsValid( self ) then return end 
            self.BuildingDupe = false
            self:SetState( "idle" )
        end )

        net.Receive("zetaplayer_returndupe",function()
            local filepath = net.ReadString()

            dupedata = file.Read( filepath )

            if !dupedata then self.BuildingDupe = false retrievingdata = false return end

            local decompressed = util.Decompress(dupedata)

            if !dupedata or !decompressed then self.BuildingDupe = false retrievingdata = false return end
            dupedata = util.JSONToTable(decompressed)
            retrievingdata = false
            
        end)

        local testcur =0
        
        while retrievingdata do if self:GetState() != "buildingdupe" then self.BuildingDupe = false return end coroutine.yield() end

        timer.Remove( "zetabuildingtimeout" .. id )

        if !dupedata or !istable(dupedata) then self.BuildingDupe = false return end
        local overallfar = 300


        position.z = position.z - dupedata.Mins.z

        overallfar = dupedata.Maxs:Length()


    
        local EntityList = table.Copy( dupedata.Entities )
        local ConstraintList = table.Copy( dupedata.Constraints )
    
        Player = Entity(1)
    
        local CreatedEntities = {}
        local unfrozenents = {}
        local ragdollphysicobjects = {}
            for k, v in pairs( EntityList ) do -- Create the entities..
                if !IsValid(self) then return end
                if self:GetState() != "buildingdupe" then self.BuildingDupe = false return end

                self:ChangeWeapon("PHYSGUN")
                if self.CurrentSpawnedProps >= GetConVar('zetaplayer_proplimit'):GetInt() then break end -- Skip through the for loop if the prop limit is reached

                if math.random(1,4) == 1 then
                    local rand = VectorRand(-overallfar-100,overallfar+100)
                    rand[3] = 0
                    local newpos = position+rand
                    
                    lostrace.start = position+MinsMaxsCenter(dupedata.Mins,dupedata.Maxs)
                    lostrace.endpos = newpos+Vector(0,0,5)
                    lostrace.collisiongroup = COLLISION_GROUP_WORLD
                    lostrace.mask = MASK_SOLID_BRUSHONLY
                    local LOStest = util.TraceLine(lostrace)

                    if !LOStest.Hit then
                        local speed,anim = self:GetMovementData(newpos)
                        self:StartActivity(anim)
                        self:SetLastActivity(anim) 
                        self.loco:SetDesiredSpeed(speed)
                        self:MoveToPos(newpos)
                        self:StartActivity(self:GetActivityWeapon('idle')) 
                    end
                end

                local z = math.random(-100,30)
            
                local rndspot = self:GetPos()+Vector(math.random(-500,500),math.random(-500,500),z)
            
                self:LookAt2("zetalookatboth",100,rndspot)

                coroutine.wait(1)
                if self:GetState() != "buildingdupe" then self.BuildingDupe = false return end

                local e = nil
                local b = ProtectedCall( function() e = CreateEntityFromTable( Player, v,position,offsetangle ) end ) 
                if ( !b ) then continue end
    
                if ( IsValid( e ) ) then
                    
                    e.IsZetaProp = true
                    self.SpawnedENTS[#self.SpawnedENTS+1] = e

                    self.CurrentSpawnedProps = self.CurrentSpawnedProps + 1


                    if ( e.RestoreNetworkVars ) then
                        e:RestoreNetworkVars( v.DT )
                    end
    
                    if ( e.OnDuplicated ) then
                        e:OnDuplicated( v )
                    end

                    if GetConVar("zetaplayer_building_nocollideprops"):GetBool() then
                        e:SetCollisionGroup(COLLISION_GROUP_WORLD)
                    end


                    if e:IsRagdoll() then
                        local count = e:GetPhysicsObjectCount()
                        for i=1,count do
                            local phys = e:GetPhysicsObjectNum(i)
                            if !IsValid(phys) then continue end
                            if phys:IsMotionEnabled() then
                                unfrozenents[#unfrozenents+1] = phys
                            end
                            ragdollphysicobjects[#ragdollphysicobjects+1] = {phys,phys:GetPos(),phys:GetAngles()}
                            phys:EnableMotion(true)
                        end
                    end

                    local phys = e:GetPhysicsObject()
                    if IsValid(phys) and phys:IsMotionEnabled() then -- Save the unfrozen state for later
                        unfrozenents[#unfrozenents+1] = phys
                    end

                    local lastpos = e:GetPos()
                    local lastang = e:GetAngles()
                    local mins,maxs = e:GetModelBounds()

                    if IsValid(phys) then
                        phys:SetPos(self:GetPos()+self:GetForward()*math.random(100,200))
                    end
                    e:SetPos(self:GetPos()+self:GetForward()*math.random(100,200))
                    e:SetAngles(Angle(0,self:GetAngles()[2],0))



                    local epos = e:GetPos()
                    epos.z = epos.z - mins.z
                    
                    e:SetPos((epos+Vector(0,0,5)))
                    if IsValid(phys) then
                        phys:SetPos((epos+Vector(0,0,5)))
                    end

                    coroutine.wait(0.5)
                    if self:GetState() != "buildingdupe" then self.BuildingDupe = false return end
                    self:GrabEnt(e)

                    coroutine.wait(1)
                    if self:GetState() != "buildingdupe" then self.BuildingDupe = false return end
                    if !IsValid(e) then continue end

                    local dist = lastpos:Distance(self:GetPos())

                    self:LookAt2("zetalookatboth",200,lastpos+Vector(0,0,30+(dist/20)))
                    self:Face2("zetalookatboth2",200,lastpos+Vector(0,0,30+(dist/20)),5)

                    coroutine.wait(0.5)

                    self.PhysgunHoldPos = lastpos
                    self.PhysgunHoldAng = lastang
                    --self.PhysgunBeamDistance = self:GetPos():Distance(lastpos)

                    coroutine.wait(2)
                    if self:GetState() != "buildingdupe" then self.BuildingDupe = false return end

                    if !IsValid(e) then continue end

                    self:DropHeldObject()

                    self.PhysgunHoldPos = nil
                    self.PhysgunHoldAng = nil



                    if e:IsRagdoll() then
                        if #ragdollphysicobjects > 0 then
                            e:SetPos(lastpos)
                            e:SetAngles(lastang)
                            for i=1,#ragdollphysicobjects do
                                local phys = ragdollphysicobjects[i][1]
                                local lastpos = ragdollphysicobjects[i][2]
                                local lastang = ragdollphysicobjects[i][3] 
                                if IsValid(phys) then
                                    local vec,ang = LocalToWorld(lastpos,lastang,position,offsetangle)
                                    phys:SetPos(vec)
                                    phys:SetAngles(ang)
                                    phys:EnableMotion(false)
                                end
                            end 
                        end
                    else

                        if IsValid(phys) then
                            phys:EnableMotion(false)
                            phys:SetPos(lastpos)
                        end
                    
                        
                        e:SetPos(lastpos)
                        e:SetAngles(lastang)

                    end

                    e:SetCollisionGroup(COLLISION_GROUP_NONE)

                    coroutine.wait(0.5)
                    if self:GetState() != "buildingdupe" then self.BuildingDupe = false return end
                    if !IsValid(e) then continue end
                    
                    e:EmitSound(GetConVar("zetaplayer_building_buildentitysound"):GetString(),60)
    
                end
    
                CreatedEntities[ k ] = e
    
                if ( CreatedEntities[ k ] ) then
    
                    CreatedEntities[ k ].BoneMods = table.Copy( v.BoneMods )
                    CreatedEntities[ k ].EntityMods = table.Copy( v.EntityMods )
                    CreatedEntities[ k ].PhysicsObjects = table.Copy( v.PhysicsObjects )
    
                else
    
                    CreatedEntities[ k ] = nil
    
                end
                coroutine.wait(0.05)
            end
    
            self:ChangeWeapon("TOOLGUN") -- Change the tool gun and get tooling

            for EntID, Ent in pairs( CreatedEntities ) do -- Then we apply some modifications on the entities.
                if !IsValid(Ent) or !IsValid(self) then continue end
                if self:GetState() != "buildingdupe" then self.BuildingDupe = false return end
                if math.random(1,4) == 1 then
                    local rand = VectorRand(-overallfar-100,overallfar+100)
                    rand[3] = 0
                    local newpos = position+rand

                    lostrace.start = position+MinsMaxsCenter(dupedata.Mins,dupedata.Maxs)
                    lostrace.endpos = newpos+Vector(0,0,5)
                    lostrace.collisiongroup = COLLISION_GROUP_WORLD
                    lostrace.mask = MASK_SOLID_BRUSHONLY
                    local LOStest = util.TraceLine(lostrace)

                    if !LOStest.Hit then
                        local speed,anim = self:GetMovementData(newpos)
                        self:StartActivity(anim)
                        self:SetLastActivity(anim) 
                        self.loco:SetDesiredSpeed(speed)
                        self:MoveToPos(newpos)
                        self:StartActivity(self:GetActivityWeapon('idle')) 
                    end
                end

                if !IsValid(Ent) or !IsValid(self) then continue end

                self:LookAt2("zetalookatboth",200,Ent:GetPos())
                self:Face2("zetalookatboth2",200,Ent:GetPos(),5)

                coroutine.wait(1)
                if self:GetState() != "buildingdupe" then self.BuildingDupe = false return end

                self:UseToolGunOn(Ent)
    
                duplicator.ApplyEntityModifiers( Player, Ent )
                duplicator.ApplyBoneModifiers( Player, Ent )
                
    
                if ( Ent.PostEntityPaste ) then
                    Ent:PostEntityPaste( Player || NULL, Ent, CreatedEntities )
                end
                coroutine.wait(0.05)
            end
    
    
            local CreatedConstraints = {}
    
    
            for k, Constraint in pairs( ConstraintList ) do -- Create the constraints
                if self:GetState() != "buildingdupe" then self.BuildingDupe = false return end
                local Entity = nil
                ProtectedCall( function() Entity = duplicator.CreateConstraintFromTable( Constraint, CreatedEntities, Player ) end )
    
                if ( IsValid( Entity ) ) then
                    table.insert( CreatedConstraints, Entity )

                    if Entity:GetPos() == Vector(0,0,0) then
                        sound.Play(GetConVar("zetaplayer_building_buildconstraintsound"):GetString(),position,60,100,1)
                    else -- Sometimes the constraints are spawned and stay at Vector 0 0 0. So we'll have this to make sure they are in position.
    
                        if math.random(1,4) == 1 then
                            local rand = VectorRand(-overallfar-100,overallfar+100)
                            rand[3] = 0
                            local newpos = position+rand

                            lostrace.start = position+MinsMaxsCenter(dupedata.Mins,dupedata.Maxs)
                            lostrace.endpos = newpos+Vector(0,0,5)
                            lostrace.collisiongroup = COLLISION_GROUP_WORLD
                            lostrace.mask = MASK_SOLID_BRUSHONLY
                            local LOStest = util.TraceLine(lostrace)
        
                            if !LOStest.Hit then
                                local speed,anim = self:GetMovementData(newpos)
                                self:StartActivity(anim)
                                self:SetLastActivity(anim) 
                                self.loco:SetDesiredSpeed(speed)
                                self:MoveToPos(newpos)
                                self:StartActivity(self:GetActivityWeapon('idle')) 
                            end
                        end
    
                        self:LookAt2("zetalookatboth",200,Entity:GetPos())
                        self:Face2("zetalookatboth2",200,Entity:GetPos(),5)
        
                        coroutine.wait(1)
        
                        self:UseToolGunOn(Entity)
    
                        Entity:EmitSound(GetConVar("zetaplayer_building_buildconstraintsound"):GetString(),60)
                    end


                end
                coroutine.wait(0.05)
            end
        

            for k,phys in ipairs(unfrozenents) do -- Unfreeze the entities we froze earlier since all the constraints have been put into place and won't break everything when we unfreeze
                if IsValid(phys) then
                    phys:EnableMotion(true)
                end
            end
    
            sound.Play(GetConVar("zetaplayer_building_finishdupesound"):GetString(),position,80,100,1)
            self.BuildingDupe = false -- Done!
    


    end

    local addontrace = {}

    function ENT:AddOntoProp(ent)
        if !IsValid(ent) then return end
        local overallfar = ent:OBBMaxs():Length()

        for i=1, math.random(1,8) do
            if !IsValid(ent) then continue end
            self:ChangeWeapon("PHYSGUN")

            if math.random(1,3) == 1 then
                local rand = VectorRand(-overallfar-100,overallfar+100)
                rand[3] = 0
                local newpos = (ent:GetPos()+ent:OBBCenter())+rand

                lostrace.start = ent:GetPos()+ent:OBBCenter()
                lostrace.endpos = newpos+Vector(0,0,5)
                lostrace.collisiongroup = COLLISION_GROUP_WORLD
                lostrace.mask = MASK_SOLID_BRUSHONLY
                local LOStest = util.TraceLine(lostrace)
                if !LOStest.Hit then
                    local speed,anim = self:GetMovementData(newpos)
                    self:StartActivity(anim)
                    self:SetLastActivity(anim) 
                    self.loco:SetDesiredSpeed(speed)
                    self:MoveToPos(newpos)
                    self:StartActivity(self:GetActivityWeapon('idle')) 
                end
            end

            local prop = self:SpawnProp(true)

            if !IsValid(prop) or !IsValid(ent) then continue end
            addontrace.start = self:GetCenteroid()
            addontrace.endpos = ent:GetPos()+ent:OBBCenter()
            addontrace.filter = function(entity) if entity == ent then return true end end
            local spot = util.TraceLine(addontrace)

            self:LookAt2("zetalookatboth",200,prop)
            self:Face2("zetalookatboth2",200,prop,5)

            coroutine.wait(math.Rand(0,1))
            if !IsValid(ent) or !IsValid(prop) then continue end

            self:GrabEnt(prop)

            coroutine.wait(math.Rand(0,1))

            self:LookAt2("zetalookatboth",200,spot.HitPos)
            self:Face2("zetalookatboth2",200,spot.HitPos,5)

            coroutine.wait(0.5)

            self.PhysgunHoldPos = spot.HitPos
            self.PhysgunHoldAng = AngleRand(-180,180)

            coroutine.wait(2)

            if !IsValid(ent) or !IsValid(prop) then continue end

            self:FreezeHeldObject()

            self.PhysgunHoldPos = nil
            self.PhysgunHoldAng = nil

            coroutine.wait(math.Rand(0,1))
            if !IsValid(ent) or !IsValid(prop) then continue end

            self:ChangeWeapon("TOOLGUN")

            self:LookAt2("zetalookatboth",200,prop:GetPos())
            self:Face2("zetalookatboth2",200,prop:GetPos(),5)

            coroutine.wait(math.Rand(0.3,1))
            if !IsValid(ent) or !IsValid(prop) then continue end

            self:UseToolGunOn(prop)

            self:LookAt2("zetalookatboth",200,ent:GetPos())
            self:Face2("zetalookatboth2",200,ent:GetPos(),5)

            coroutine.wait(math.Rand(0.3,1))
            if !IsValid(ent) or !IsValid(prop) then continue end

            self:UseToolGunOn(ent)
            constraint.Weld(ent,prop,0,0,0,false,false)

        end

    end


elseif CLIENT then

    net.Receive("zetaplayer_createdupeicon",function()
        local filepath = net.ReadString()
        local filename = net.ReadString()
        local Dupe = file.Read( filepath )

        if !Dupe then return end
        Dupe = util.Decompress(Dupe)
        Dupe = util.JSONToTable(Dupe)

        hook.Add( "PostRender", "RenderDupeIcon", function() -- Gmod's function to creating a icon for a duplication. We are using this too to make a icon in the data folder so players know what dupe is what via visual reference

            local FOV = 17

            --
            -- This is gonna take some cunning to look awesome!
            --
            local Size = Dupe.Maxs - Dupe.Mins
            local Radius = Size:Length() * 0.5
            local CamDist = Radius / math.sin( math.rad( FOV ) / 2 ) -- Works out how far the camera has to be away based on radius + fov!
            local Center = LerpVector( 0.5, Dupe.Mins, Dupe.Maxs )
            local CamPos = Center + Vector( -1, 0, 0.5 ):GetNormal() * CamDist
            local EyeAng = ( Center - CamPos ):GetNormal():Angle()

            --
            -- The base view
            --
            local view = {
                type	= "3D",
                origin	= CamPos,
                angles	= EyeAng,
                x		= 0,
                y		= 0,
                w		= 512,
                h		= 512,
                aspect	= 1,
                fov		= FOV
            }


            local entities = {}
            local i = 0
            for k, v in pairs( Dupe.Entities ) do

                if ( v.Class == "prop_ragdoll" ) then

                    entities[ k ] = ClientsideRagdoll( v.Model or "error.mdl", RENDERGROUP_OTHER )

                    if ( istable( v.PhysicsObjects ) ) then

                        for boneid, v in pairs( v.PhysicsObjects ) do

                            local obj = entities[ k ]:GetPhysicsObjectNum( boneid )
                            if ( IsValid( obj ) ) then
                                obj:SetPos( v.Pos )
                                obj:SetAngles( v.Angle )
                            end

                        end

                        entities[ k ]:InvalidateBoneCache()

                    end

                else

                    entities[ k ] = ClientsideModel( v.Model or "error.mdl", RENDERGROUP_OTHER )

                end
                i = i + 1

            end

            render.SetMaterial( Material( "dupe/bg.jpg" ) )
            render.DrawScreenQuadEx( 0, 0, 512, 512 )
            render.UpdateRefractTexture()


            --
            -- BLACK OUTLINE
            -- AWESOME BRUTE FORCE METHOD
            --
            render.SuppressEngineLighting( true )

            -- Rendering icon the way we do is kinda bad and will crash the game with too many entities in the dupe
            -- Try to mitigate that to some degree by not rendering the outline when we are above 800 entities
            -- 1000 was tested without problems, but we want to give it some space as 1000 was tested in "perfect conditions" with nothing else happening on the map
            if ( i < 800 ) then
                local BorderSize	= CamDist * 0.004
                local Up			= EyeAng:Up() * BorderSize
                local Right			= EyeAng:Right() * BorderSize

                render.SetColorModulation( 1, 1, 1, 1 )
                render.MaterialOverride( Material( "models/debug/debugwhite" ) )

                -- Render each entity in a circle
                for k, v in pairs( Dupe.Entities ) do

                    for i = 0, math.pi * 2, 0.2 do

                        view.origin = CamPos + Up * math.sin( i ) + Right * math.cos( i )

                        -- Set the skin and bodygroups
                        entities[ k ]:SetSkin( v.Skin or 0 )
                        for bg_k, bg_v in pairs( v.BodyG or {} ) do entities[ k ]:SetBodygroup( bg_k, bg_v ) end

                        cam.Start( view )

                            render.Model( {
                                model	= v.Model,
                                pos		= v.Pos,
                                angle	= v.Angle
                            }, entities[ k ] )

                        cam.End()

                    end

                end

                -- Because we just messed up the depth
                render.ClearDepth()
                render.SetColorModulation( 0, 0, 0, 1 )

                -- Try to keep the border size consistent with zoom size
                local BorderSize	= CamDist * 0.002
                local Up			= EyeAng:Up() * BorderSize
                local Right			= EyeAng:Right() * BorderSize

                -- Render each entity in a circle
                for k, v in pairs( Dupe.Entities ) do

                    for i = 0, math.pi * 2, 0.2 do

                        view.origin = CamPos + Up * math.sin( i ) + Right * math.cos( i )
                        cam.Start( view )

                        render.Model( {
                            model	= v.Model,
                            pos		= v.Pos,
                            angle	= v.Angle
                        }, entities[ k ] )

                        cam.End()

                    end

                end
            end

            --
            -- ACUAL RENDER!
            --

            -- We just fucked the depth up - so clean it
            render.ClearDepth()

            -- Set up the lighting. This is over-bright on purpose - to make the ents pop
            render.SetModelLighting( 0, 0, 0, 0 )
            render.SetModelLighting( 1, 2, 2, 2 )
            render.SetModelLighting( 2, 3, 2, 0 )
            render.SetModelLighting( 3, 0.5, 2.0, 2.5 )
            render.SetModelLighting( 4, 3, 3, 3 ) -- top
            render.SetModelLighting( 5, 0, 0, 0 )
            render.MaterialOverride( nil )

            view.origin = CamPos
            cam.Start( view )

            -- Render each model
            for k, v in pairs( Dupe.Entities ) do

                render.SetColorModulation( 1, 1, 1, 1 )

                -- EntityMods override this
                if ( v._DuplicatedColor ) then render.SetColorModulation( v._DuplicatedColor.r / 255, v._DuplicatedColor.g / 255, v._DuplicatedColor.b / 255, v._DuplicatedColor.a / 255 ) end
                if ( v._DuplicatedMaterial ) then render.MaterialOverride( Material( v._DuplicatedMaterial ) ) end

                if ( istable( v.EntityMods ) ) then

                    if ( istable( v.EntityMods.colour ) ) then
                        render.SetColorModulation( v.EntityMods.colour.Color.r / 255, v.EntityMods.colour.Color.g / 255, v.EntityMods.colour.Color.b / 255, v.EntityMods.colour.Color.a / 255 )
                    end

                    if ( istable( v.EntityMods.material ) ) then
                        render.MaterialOverride( Material( v.EntityMods.material.MaterialOverride ) )
                    end

                end

                render.Model( {
                    model	= v.Model,
                    pos		= v.Pos,
                    angle	= v.Angle
                }, entities[ k ] )

                render.MaterialOverride( nil )

            end

            cam.End()

            -- Enable lighting again (or it will affect outside of this loop!)
            render.SuppressEngineLighting( false )
            render.SetColorModulation( 1, 1, 1, 1 )

            --
            -- Finished with the entities - remove them all
            --
            for k, v in pairs( entities ) do
                v:Remove()
            end

            --
            -- This captures a square of the render target, copies it to a jpg file
            -- and returns it to us as a (binary) string.
            --
            local jpegdata = render.Capture( {
                format		=	"jpg",
                x			=	0,
                y			=	0,
                w			=	512,
                h			=	512,
                quality		=	95
            } )

            ZetaFileWrite("zetaplayerdata/duplications/"..filename..".jpg",jpegdata)
            
            hook.Remove("PostRender", "RenderDupeIcon")
        end )   

    end)
    
    -- Since the Server itself can't really read dupe files we have to rely on the client to get a dupe.
    -- Only Entity(1) gets this net message
    net.Receive("zetaplayer_getdupe",function()

        if GetConVar("zetaplayer_building_useplayerdupes"):GetBool() then

            local dupes,_ = file.Find("dupes/*.dupe","GAME","nameasc")
            local rnddupe = dupes[math.random(#dupes)]

            if !rnddupe or #dupes == 0 then net.Start("zetaplayer_returndupe") net.SendToServer() return end

            local dupedata = engine.OpenDupe("dupes/"..rnddupe)
            -- I've never worked with compressed data and stuff so this was a learning experience. Pretty useful one actually I might need to use this more
            local compresseddata = dupedata.data
            
            file.CreateDir("zetaplayerdata/NETTEMP")
            file.Write("zetaplayerdata/NETTEMP/".. string.StripExtension(rnddupe) ..".json",compresseddata)

            timer.Simple(3,function()
                file.Delete("zetaplayerdata/NETTEMP/".. string.StripExtension(rnddupe) ..".json")
            end)
            
            net.Start("zetaplayer_returndupe")
                net.WriteString("zetaplayerdata/NETTEMP/".. string.StripExtension(rnddupe) ..".json")
            net.SendToServer()

        else
            
            local dupes,_ = file.Find("zetaplayerdata/duplications/*.json","DATA","nameasc")
            local rnddupe = dupes[math.random(#dupes)]

            if !rnddupe or #dupes == 0 then net.Start("zetaplayer_returndupe") net.SendToServer() return end
    
            net.Start("zetaplayer_returndupe")
                net.WriteString( "zetaplayerdata/duplications/"..rnddupe )
            net.SendToServer()


        end
    end)

end