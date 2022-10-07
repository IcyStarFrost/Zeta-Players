-----------------------------------------------
-- Toolgun Tools
--- This is where Zeta gets its toolgun functions
-----------------------------------------------

AddCSLuaFile()

local math = math
local util = util
local ents = ents

local oldisvalid = IsValid

local function IsValid( ent )
    if oldisvalid( ent ) and ent.IsZetaPlayer then
        
        return !ent.IsDead 
    else
        return oldisvalid( ent )
    end
end


    ENT.CurrentSpawnedLights = 0
    ENT.CurrentSpawnedRopes = 0
    ENT.CurrentSpawnedBalloons = 0
    ENT.CurrentSpawnedMusicboxes = 0
    ENT.CurrentSpawnedEmitters = 0
    ENT.CurrentSpawnedDynamite = 0
    ENT.CurrentSpawnedLamps = 0
    ENT.CurrentSpawnedThrusters = 0
    ENT.CurrentSpawnTABLE = {
        ["Wire Gate"] = 0,
        ["Wire Button"] = 0
    }

    function ENT:UseToolGunOn(ent) -- Fun toolgun effect
        if !IsValid(self) then return end
        if !IsValid(self.WeaponENT) then return end
        if IsValid(ent) then
        if self:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER) then
            self:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER)
        end
        local efdata = EffectData()
        local attach = self.WeaponENT:GetAttachment(1)

            if !attach then
                attach = {Pos = self.WeaponENT:GetPos(),Ang = self.WeaponENT:GetAngles()}
            end
            
        efdata:SetOrigin(ent:GetPos())
        efdata:SetStart(attach.Pos or self:GetPos())
        efdata:SetScale(4000)
        efdata:SetEntity(self.WeaponENT)

        util.Effect('ToolTracer',efdata,true,true)

        local efdata = EffectData()
        local trace = util.TraceLine({start = self:GetPos()+self:OBBCenter(),endpos = ent:GetPos(),filter = self})
        
            
        

        efdata:SetOrigin(trace.HitPos)
        efdata:SetStart(trace.HitPos)
        efdata:SetNormal(trace.Normal)
        efdata:SetEntity(ent)

        util.Effect('selection_indicator',efdata,true,true)
        self:EmitSound('weapons/airboat/airboat_gun_lastshot'..math.random(1,2)..'.wav',75)
        self:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,true)
            return trace.HitPos
        end
    end

    function ENT:UseToolGun(ignoreents)  
        if !IsValid(self.WeaponENT) then return end
        local ignore = false
        local origintrace
        if ignoreents then
            ignore = true
        end
        if self.WeaponENT then
        if self:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER) then
            self:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER)
        end
        local efdata = EffectData()
        local attach = self.WeaponENT:GetAttachment(1)

        if !attach or !attach.Pos then
            attach = {Pos = self.WeaponENT:GetPos(),Ang = self.WeaponENT:GetAngles()}
        end
        if ignore then
            origintrace = util.TraceLine({start = attach.Pos,endpos = self.WeaponENT:GetForward()*800000,filter = self,collisiongroup = COLLISION_GROUP_WORLD})
        else
            origintrace = util.TraceLine({start = attach.Pos,endpos = self.WeaponENT:GetForward()*800000,filter = self})
        end
        
        local origin = origintrace.HitPos
        efdata:SetOrigin(origin)
        efdata:SetStart(attach.Pos)
        efdata:SetScale(4000)
        efdata:SetEntity(self.WeaponENT)

        util.Effect('ToolTracer',efdata,true,true)

        local efdata = EffectData()
        
        
            
        

        efdata:SetOrigin(origin)
        efdata:SetStart(origin)
        efdata:SetNormal(origintrace.Normal)
        efdata:SetEntity(origintrace.Entity)

        util.Effect('selection_indicator',efdata,true,true)
        self:EmitSound('weapons/airboat/airboat_gun_lastshot'..math.random(1,2)..'.wav',75)
        self:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,true)
            return origintrace
        end
    end

function ENT:UseColorTool()
    if self.IsBuilding == true then return end
    if self.TypingInChat then return end
    local canuse = GetConVar('zetaplayer_allowcolortool'):GetInt()
    if canuse == 0 then return end

    self.IsBuilding = true 
    DebugText('Tool: Attempting to use Color Tool')
    

    local props = self:FindInSightPermission(700)

    
    

    local selectedprop = props[math.random(#props)]
   

    if selectedprop and selectedprop:IsValid() then
        self:Face(selectedprop)
        self:LookAt(selectedprop,'both')

        timer.Simple(math.random(0.5,1.5),function()
            if !self:IsValid() then return end
            if selectedprop and selectedprop:IsValid() and self.WeaponENT then
 

                self:UseToolGunOn(selectedprop)
                selectedprop:SetColor(Color(math.random(0,255),math.random(0,255),math.random(0,255)))
                self:StopFacing()
                self:StopLooking()
                self.IsBuilding = false
                DebugText('Tool: Changed prop color')
                if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
                    if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                        net.Start("zeta_sendonscreenlog",true)
                        net.WriteString(self.zetaname..' used tool Color Tool')
                        net.WriteColor(Color(255,255,255),false)
                        net.Broadcast()
                    end
                    MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' used tool Color Tool')
                end
            else
                self.IsBuilding = false
                DebugText('Tool: Selected prop is not valid x2')
            end

            if IsValid(selectedprop) then
                hook.Run("OnZetaUseToolgun",self,selectedprop,"Color")
            end

        end)
    else
        self.IsBuilding = false
        DebugText('Tool: Selected prop is not valid')
    end



while self.IsBuilding == true do
    coroutine.yield()
end

end


function ENT:UseMaterialTool()
    if self.TypingInChat then return end
    if self.IsBuilding == true then return end
    if !self.ValidMaterials then DebugText('There are no Valid Materials! Failed to read materials file?') return end
    local canuse = GetConVar('zetaplayer_allowmaterialtool'):GetInt()
    if canuse == 0 then return end


    self.IsBuilding = true 
    DebugText('Tool: Attempting to use Material Tool')
    
    

    local props = self:FindInSightPermission(700)
    local material = self.ValidMaterials[math.random(#self.ValidMaterials)]

    local selectedprop = props[math.random(#props)]

    if selectedprop and selectedprop:IsValid() then
        self:Face(selectedprop)
        self:LookAt(selectedprop,'both')
        timer.Simple(math.random(0.5,1.5),function()
            if !self:IsValid() then return end
        if selectedprop and selectedprop:IsValid() then

            self:UseToolGunOn(selectedprop)
            selectedprop:SetMaterial(material)
            self:StopFacing()
            self:StopLooking()
            self.IsBuilding = false
            DebugText('Tool: Changed prop material')
            if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
                if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                    net.Start("zeta_sendonscreenlog",true)
                    net.WriteString(self.zetaname..' used tool Material Tool')
                    net.WriteColor(Color(255,255,255),false)
                    net.Broadcast()
                end
                MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' used tool Material Tool')
            end
        else
            self.IsBuilding = false
            DebugText('Tool: Selected prop is not valid x2')
        end

            if IsValid(selectedprop) then
                hook.Run("OnZetaUseToolgun",self,selectedprop,"Material")
            end

        end)

    else
        self.IsBuilding = false
        DebugText('Tool: Selected prop is not valid')
    end


   
    while self.IsBuilding == true do
        coroutine.yield()
    end

end


function ENT:UseRopeTool()
    if self.TypingInChat then return end
    if self.IsBuilding == true then return end
    local canuse = GetConVar('zetaplayer_allowropetool'):GetInt()
    if canuse == 0 then return end
    if self.CurrentSpawnedRopes >= GetConVar('zetaplayer_ropelimit'):GetInt() then DebugText('Tool: Hit the Rope Limit!') return end

    self.IsBuilding = true 
    DebugText('Tool: Attempting to use Rope Tool')

    local ent1
    local ent2
    local pos1
    local pos2

    -- Find 2 entities we want to rope
    
        local props = self:FindInSightPermission(700)


        ent1 = props[math.random(#props)]
        ent2 = props[math.random(#props)]

        if ent1 == ent2 then DebugText('Tool: Ent1 is the same with Ent2') self.IsBuilding = false return end
        
        



    if ent1 and ent2 and ent1:IsValid() and ent2:IsValid() then
            self:Face(ent1)
            self:LookAt(ent1,'both')
        timer.Simple(math.random(0.5,1.5),function()
            if !self:IsValid() then return end
            if ent1 and ent1:IsValid() then

                local hitpos = self:UseToolGunOn(ent1)

                pos1 = ent1:WorldToLocal(hitpos)

                DebugText('Tool: Set Ent1..')
                self:StopFacing()
                self:StopLooking()
                    self:Face(ent2)
                    self:LookAt(ent2,'both')
                
                timer.Simple(math.random(0.5,1.5),function()
                    if !self:IsValid() then self.IsBuilding = false return end
                    if ent2 and ent2:IsValid() then
                        if !ent1:IsValid() then return end
                        local hitpos = self:UseToolGunOn(ent2)
                        pos2 = ent2:WorldToLocal(hitpos)
                        self:StopFacing()
                        self:StopLooking()
                        local rope = constraint.Rope(ent1,ent2,0,0,pos1,pos2,ent1:GetPos():Distance(ent2:GetPos()),math.random(0,200),0,math.random(1.0,10.0),self.RopeMats[math.random(#self.RopeMats)],false)
                        if !rope or !rope:IsValid() then self.IsBuilding = false return end
                        rope.IsZetaProp = true
                        table.insert(self.SpawnedENTS,rope)
                        self.CurrentSpawnedRopes = self.CurrentSpawnedRopes + 1
                        if ( SERVER ) then
                            rope:CallOnRemove('ropecallremove'..rope:EntIndex(),function()
                                if !self:IsValid() then return end
                                self.CurrentSpawnedRopes = self.CurrentSpawnedRopes - 1
                                if self.SpawnedENT then
                                    table.RemoveByValue(self.SpawnedENT,rope)
                                end
                            end)
                        end
                        if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
                            if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                                net.Start("zeta_sendonscreenlog",true)
                                net.WriteString(self.zetaname..' used tool Rope Tool')
                                net.WriteColor(Color(255,255,255),false)
                                net.Broadcast()
                            end
                            MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' used tool Rope Tool')
                        end
                        DebugText('Tool: Created Rope!')
                        self.IsBuilding = false
                    else
                        DebugText('Tool: Ent2 is not Valid!')
                        self.IsBuilding = false
                    end

                    if IsValid(ent1) then
                        hook.Run("OnZetaUseToolgun",self,ent1,"Rope")
                    end

                end)
            else
                DebugText('Tool: Ent1 is not Valid!')
                self.IsBuilding = false
            end

        end)

    else
        DebugText('Tool: Ent1('..tostring(ent1)..') '..'or Ent2('..tostring(ent2)..') '..'is not valid!')
        self.IsBuilding = false
        self:UseWorldRopeTool()
    end




    while self.IsBuilding == true do
        coroutine.yield()
    end

end


function ENT:UseLightTool()
    if self.TypingInChat then return end
    if GetConVar('zetaplayer_allowlighttool'):GetInt() == 0 then return end
    if self.CurrentSpawnedLights >= GetConVar('zetaplayer_lightlimit'):GetInt() then DebugText('Tool: Hit the Light Limit!') return end
    if self.IsBuilding == true then return end

    self.IsBuilding = true
    DebugText('Tool: Attempting to use Light Tool')

    local rndspot = self:GetPos()+Vector(math.random(-100,100),math.random(-100,100),math.random(-100,100))

    self:LookAt(rndspot,'both')

    timer.Simple(math.random(0.5,1.5),function()
        if !self:IsValid() then self.IsBuilding = false return end



        self:StopLooking()
        local hitdata = self:UseToolGun()

        local light = ents.Create('zeta_light') -- We use our own light

        light:SetPos(hitdata.HitPos+hitdata.Normal*-10)
        light:SetModel('models/maxofs2d/light_tubular.mdl')
        light.IsZetaProp = true
        light:SetOwner( self )
        light:Spawn()
        local min = light:OBBMins()
        light:SetPos( hitdata.HitPos - hitdata.HitNormal * min.z )
        table.insert(self.SpawnedENTS,light)
        self.CurrentSpawnedLights = self.CurrentSpawnedLights + 1
        DebugText('Tool: Created Light! Now have '..self.CurrentSpawnedLights..' Lights with the limit being, '..GetConVar('zetaplayer_lightlimit'):GetInt())
        if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
            if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                net.Start("zeta_sendonscreenlog",true)
                net.WriteString(self.zetaname..' used tool Light Tool')
                net.WriteColor(Color(255,255,255),false)
                net.Broadcast()
            end
            MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' used tool Light Tool')
        end
        if ( SERVER ) then
            
            light:CallOnRemove('lightcallremove'..light:EntIndex(),function()
                if !self:IsValid() then return end
                self.CurrentSpawnedLights = self.CurrentSpawnedLights - 1
                table.RemoveByValue(self.SpawnedENTS,light)
            end)
        end
        if light:IsValid() and hitdata.Entity:IsValid() or hitdata.Entity == Entity(0) then
            constraint.Rope(light,hitdata.Entity,0,0,Vector(0,0,0),hitdata.Entity:WorldToLocal(hitdata.HitPos),10,math.random(0,200),0,math.random(1.0,5.0),self.RopeMats[math.random(#self.RopeMats)],false)
        end
        self.IsBuilding = false

        if IsValid(hitdata.Entity) and hitdata.Entity.IsZetaProp then
            hook.Run("OnZetaUseToolgun",self,selectedprop,"Light")
        end
    end)




    while self.IsBuilding == true do
        coroutine.yield()
    end
end




local function DoRemoveEntity( ent )

	if ( !IsValid( ent ) || ent:IsPlayer() ) then return false end

	constraint.RemoveAll( ent )

	timer.Simple( 1, function() if ( IsValid( ent ) ) then ent:Remove() end end )

	ent:SetNotSolid( true )
	ent:SetMoveType( MOVETYPE_NONE )
	ent:SetNoDraw( true )

	local ed = EffectData()
		ed:SetOrigin( ent:GetPos() )
		ed:SetEntity( ent )
	util.Effect( "entity_remove", ed, true, true )

	return true

end


function ENT:UseRemoverTool(ent)
    if self.TypingInChat then return end
    if self.IsBuilding == true then return end
    local canuse = GetConVar('zetaplayer_allowremovertool'):GetInt()
    if canuse == 0 then return end

    self.IsBuilding = true 
    DebugText('Tool: Attempting to use Remover Tool')
    local selectedprop

    if !IsValid(ent) then
        local props = self:FindInSightPermission(700)

    
    

        selectedprop = props[math.random(#props)]
    else
        selectedprop= ent
    end
   

    if selectedprop and selectedprop:IsValid() then
        self:Face(selectedprop)
        self:LookAt(selectedprop,'both')

        timer.Simple(math.random(0.5,1.5),function()
            if !self:IsValid() then return end
            if selectedprop and selectedprop:IsValid() and self.WeaponENT then
 

                self:UseToolGunOn(selectedprop)


                

            
                if math.random( 1, 2 ) == 1 then
                    local ConstrainedEntities = constraint.GetAllConstrainedEntities( selectedprop )
                    
                    for _, Entity in pairs( ConstrainedEntities ) do
                
                        DoRemoveEntity( Entity )

                    end

                else

                    selectedprop:Remove()
                    
                end

                self.achievement_Remove = self.achievement_Remove + 1
                
                if self.achievement_Remove == self.achievement_RemoveMax then
                    self:AwardAchievement("Remover")
                end

                self:StopFacing()
                self:StopLooking()
                self.IsBuilding = false
                DebugText('Tool: Removed Entity!')
                if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
                    if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                        net.Start("zeta_sendonscreenlog",true)
                        net.WriteString(self.zetaname..' used tool Remover Tool')
                        net.WriteColor(Color(255,255,255),false)
                        net.Broadcast()
                    end
                    MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' used tool Remover Tool')
                end
            else
                self.IsBuilding = false
                DebugText('Tool: Selected prop is not valid x2')
            end

            if IsValid(selectedprop) then
                hook.Run("OnZetaUseToolgun",self,selectedprop,"Remover")
            end

        end)
    else
        self.IsBuilding = false
        DebugText('Tool: Selected prop is not valid')
    end

while self.IsBuilding == true do
    coroutine.yield()
end

end


function ENT:UseBalloonTool()
    if self.TypingInChat then return end
    if GetConVar('zetaplayer_allowballoontool'):GetInt() == 0 then return end
    if self.CurrentSpawnedBalloons >= GetConVar('zetaplayer_balloonlimit'):GetInt() then DebugText('Tool: Hit the Balloon Limit!') return end
    if self.IsBuilding == true then return end

    self.IsBuilding = true
    DebugText('Tool: Attempting to use Balloon Tool')
    local ent_pos

    if math.random(1,2) == 1 then
    ent_pos = self:GetPos()+Vector(math.random(-100,100),math.random(-100,100),math.random(-100,100))
    DebugText('Tool: Picking random position')
    else
        DebugText('Tool: Picking a entity')
        local entities = self:FindInSightPermission(700)

        if #entities == 0  then
            ent_pos = self:GetPos()+Vector(math.random(-100,100),math.random(-100,100),math.random(-100,100))
            DebugText('Tool: Failed to pick a entity falling back to a random spot')
        else
            ent_pos = entities[math.random(#entities)]
        end
    end
    

    self:LookAt(ent_pos,'both')

    if type(ent_pos) == 'Entity' or type(ent_pos) == 'NPC' then
        self:Face(ent_pos)
    end

    timer.Simple(math.random(0.5,1.5),function()
        if !self:IsValid() then return end
        if type(ent_pos) != 'Vector' and !ent_pos:IsValid() then self:StopFacing() self:StopLooking() DebugText('Tool: Ent is not Valid!') self.IsBuilding = false return end
        if !ent_pos then self:StopFacing() self:StopLooking() self.IsBuilding = false return end
        
        self:StopLooking()
        self:StopFacing()

        local hitdata = self:UseToolGun()

        local balloon = ents.Create('zeta_balloon') -- We use our own balloon

        balloon:SetPos(hitdata.HitPos+hitdata.Normal*-10)
        balloon.IsZetaProp = true
        balloon:SetOwner( self )
        balloon:Spawn()
        table.insert(self.SpawnedENTS,balloon)
        self.CurrentSpawnedBalloons = self.CurrentSpawnedBalloons + 1
        DebugText('Tool: Created Balloon! Now have '..self.CurrentSpawnedBalloons..' Balloons with the limit being, '..GetConVar('zetaplayer_balloonlimit'):GetInt())
        if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
            if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                net.Start("zeta_sendonscreenlog",true)
                net.WriteString(self.zetaname..' used tool Balloon Tool')
                net.WriteColor(Color(255,255,255),false)
                net.Broadcast()
            end
            MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' used tool Balloon Tool')
        end
        if ( SERVER ) then
            balloon:CallOnRemove('ballooncallremove'..balloon:EntIndex(),function()
                if !self:IsValid() then return end
                self.CurrentSpawnedBalloons = self.CurrentSpawnedBalloons - 1
                table.RemoveByValue(self.SpawnedENTS,balloon)
            end)
        end
        if balloon:IsValid() and self:IsValid() and hitdata.Entity:IsValid() or hitdata.Entity == Entity(0) then
            constraint.Rope(balloon,hitdata.Entity,0,0,Vector(0,0,0),hitdata.Entity:WorldToLocal(hitdata.HitPos),10,math.random(50,400),0,math.random(1.0,5.0),self.RopeMats[math.random(#self.RopeMats)],false)
        end
        self.IsBuilding = false

        if IsValid(hitdata.Entity) and hitdata.Entity.IsZetaProp then
            hook.Run("OnZetaUseToolgun",self,selectedprop,"Balloon")
        end
    end)




    while self.IsBuilding == true do
        coroutine.yield()
    end


end




function ENT:UseTrailsTool()
    if self.TypingInChat then return end
    if self.IsBuilding == true then return end
    local canuse = GetConVar('zetaplayer_allowtrailstool'):GetInt()
    if canuse == 0 then return end

    self.IsBuilding = true 
    DebugText('Tool: Attempting to use Trails Tool')
    

    local props = self:FindInSightPermission(700)

    
    

    local selectedprop = props[math.random(#props)]
   

    if selectedprop and selectedprop:IsValid() then
        self:Face(selectedprop)
        self:LookAt(selectedprop,'both')

        timer.Simple(math.random(0.5,1.5),function()
            if !self:IsValid() then return end
            if selectedprop and selectedprop:IsValid() and self.WeaponENT then
 

                self:UseToolGunOn(selectedprop)
                local start = math.random(0,128)
                local end_ = math.random(0,128)
                local trail = util.SpriteTrail( selectedprop, 0, Color(math.random(0,255),math.random(0,255),math.random(0,255)), false, start, end_, math.random(0.0,10.0), 1 / ( start + end_ ) * 0.59,self.TrailMats[math.random(#self.TrailMats)] )

                trail.IsZetaProp = true
                if ( SERVER ) then
                    trail:CallOnRemove('trailcallremove'..trail:EntIndex(),function()
                        if !self:IsValid() then return end
                            table.RemoveByValue(self.SpawnedENTS,trail)
                        
                    end)
                end
                self:StopFacing()
                self:StopLooking()
                self.IsBuilding = false
                table.insert(self.SpawnedENTS,trail)
                DebugText('Tool: Created Trail!')
                if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
                    if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                        net.Start("zeta_sendonscreenlog",true)
                        net.WriteString(self.zetaname..' used tool Trails Tool')
                        net.WriteColor(Color(255,255,255),false)
                        net.Broadcast()
                    end
                    MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' used tool Trails Tool')
                end
            else
                self.IsBuilding = false
                DebugText('Tool: Selected prop is not valid x2')
            end

            if IsValid(selectedprop) then
                hook.Run("OnZetaUseToolgun",self,selectedprop,"Trail")
            end

        end)
    else
        self.IsBuilding = false
        DebugText('Tool: Selected prop is not valid')
    end

while self.IsBuilding == true do
    coroutine.yield()
end

end


function ENT:UseMusicBoxTool()
    if self.TypingInChat then return end
    if GetConVar('zetaplayer_allowmusicboxtool'):GetInt() == 0 then return end
    if self.CurrentSpawnedMusicboxes >= GetConVar('zetaplayer_musicboxlimit'):GetInt() then DebugText('Tool: Hit the Music Box Limit!') return end
    if self.IsBuilding == true then return end

    self.IsBuilding = true
    DebugText('Tool: Attempting to use Music Box Tool')

    local rndspot = self:GetPos()+Vector(math.random(-100,100),math.random(-100,100),math.random(0,-100))

    self:LookAt(rndspot,'both')

    timer.Simple(math.random(0.5,1.5),function()
        if !self:IsValid() then self.IsBuilding = false return end



        self:StopLooking()
        local hitdata = self:UseToolGun()

        local mdls = {
            'models/props_lab/citizenradio.mdl',
            'models/props_lab/reciever01d.mdl',
            'models/props_lab/reciever01c.mdl',
        }

        local box = ents.Create('zeta_musicbox') -- Muuuuuusssiiiiiiiic!

        box:SetPos(hitdata.HitPos+hitdata.Normal*-10)
        box:SetOwner( self )
        box.IsZetaProp = true
        box:SetModel(mdls[math.random(1,3)])
        box:Spawn()
        local min = box:OBBMins()
        box:SetPos( hitdata.HitPos - hitdata.HitNormal * min.z )
        table.insert(self.SpawnedENTS,box)
        self.CurrentSpawnedMusicboxes = self.CurrentSpawnedMusicboxes + 1
        DebugText('Tool: Created Music Box! Now have '..self.CurrentSpawnedMusicboxes..' Music Boxes with the limit being, '..GetConVar('zetaplayer_musicboxlimit'):GetInt())
        if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
            if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                net.Start("zeta_sendonscreenlog",true)
                net.WriteString(self.zetaname..' used tool Music Box Tool')
                net.WriteColor(Color(255,255,255),false)
                net.Broadcast()
            end
            MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' used tool Music Box Tool')
        end
        if ( SERVER ) then
            box:CallOnRemove('boxcallremove'..box:EntIndex(),function()
                if !self:IsValid() then return end
                self.CurrentSpawnedMusicboxes = self.CurrentSpawnedMusicboxes - 1
                table.RemoveByValue(self.SpawnedENTS,box)
            end)
        end

            self.IsBuilding = false
    end)




    while self.IsBuilding == true do
        coroutine.yield()
    end
end




function ENT:UseIgniterTool()
    if self.TypingInChat then return end
    if self.IsBuilding == true then return end
    local canuse = GetConVar('zetaplayer_allowignitertool'):GetInt()
    if canuse == 0 then return end

    self.IsBuilding = true 
    DebugText('Tool: Attempting to use Igniter Tool')
    

    local props = self:FindInSightPermission(700)

    
    

    local selectedprop = props[math.random(#props)]
   

    if selectedprop and selectedprop:IsValid() then
        self:Face(selectedprop)
        self:LookAt(selectedprop,'both')

        timer.Simple(math.random(0.5,1.5),function()
            if !self:IsValid() then return end
            if selectedprop and selectedprop:IsValid() and self.WeaponENT then
 

                self:UseToolGunOn(selectedprop)
                selectedprop:Ignite(math.random(15,90))
                self:StopFacing()
                self:StopLooking()
                self.IsBuilding = false
                DebugText('Tool: Ignited a Prop')
                if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
                    if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                        net.Start("zeta_sendonscreenlog",true)
                        net.WriteString(self.zetaname..' used tool Igniter Tool')
                        net.WriteColor(Color(255,255,255),false)
                        net.Broadcast()
                    end
                    MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' used tool Igniter Tool')
                end
            else
                self.IsBuilding = false
                DebugText('Tool: Selected prop is not valid x2')
            end

            if IsValid(selectedprop) then
                hook.Run("OnZetaUseToolgun",self,selectedprop,"Igniter")
            end

        end)
    else
        self.IsBuilding = false
        DebugText('Tool: Selected prop is not valid')
    end

while self.IsBuilding == true do
    coroutine.yield()
end

end




function ENT:UseFacePoserTool()
    if self.TypingInChat then return end
    if self.IsBuilding == true then return end
    if GetConVar("zetaplayer_allowfaceposertool"):GetInt() == 0 then return end
    self.IsBuilding = true 
    DebugText('Tool: Attempting to use Face Poser Tool')
    

    local props = self:FindInSightPermission(700)

    for k,v in ipairs(props) do
        if v:GetClass() == "prop_ragdoll" then
            selectedprop = v
            break
        end
    end

    if selectedprop and selectedprop:IsValid() then
        self:Face(selectedprop)
        self:LookAt(selectedprop,'both')
        timer.Simple(math.random(0.5,1.5),function()
            if !self:IsValid() then return end
        if selectedprop and selectedprop:IsValid() then

            self:UseToolGunOn(selectedprop)

            for i = 0, selectedprop:GetFlexNum()-1 do
	
                selectedprop:SetFlexWeight(i, math.random()*math.random(5))
                
            end

            self:StopFacing()
            self:StopLooking()
            self.IsBuilding = false
            DebugText('Tool: Changed Ragdoll Flexes')
            if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
                if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                    net.Start("zeta_sendonscreenlog",true)
                    net.WriteString(self.zetaname..' used tool Face Poser Tool')
                    net.WriteColor(Color(255,255,255),false)
                    net.Broadcast()
                end
                MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' used tool Face Poser Tool')
            end
        else
            self.IsBuilding = false
            DebugText('Tool: Selected prop is not valid x2')
        end

            if IsValid(selectedprop) then
                hook.Run("OnZetaUseToolgun",self,selectedprop,"Faceposer")
            end

        end)

    else
        self.IsBuilding = false
        DebugText('Tool: Selected prop is not valid')
    end
   
    while self.IsBuilding == true do
        coroutine.yield()
    end

end





function ENT:UseEmitterTool()
    if self.TypingInChat then return end
    if GetConVar('zetaplayer_allowemittertool'):GetInt() == 0 then return end
    if self.CurrentSpawnedEmitters >= GetConVar('zetaplayer_emitterlimit'):GetInt() then DebugText('Tool: Hit the Emitter Limit!') return end
    if self.IsBuilding == true then return end

    self.IsBuilding = true
    DebugText('Tool: Attempting to use Emitter Tool')

    local rndspot = self:GetPos()+Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(-100,100))

    self:LookAt(rndspot,'both')

    timer.Simple(math.random(0.5,1.5),function()
        if !self:IsValid() then self.IsBuilding = false return end



        self:StopLooking()
        local hitdata = self:UseToolGun()

        local emitter = ents.Create('zeta_emitter') -- We use our own emitter 

        emitter:SetPos(hitdata.HitPos+hitdata.Normal)
        emitter:SetAngles(-hitdata.Normal:Angle())
        emitter.IsZetaProp = true
        emitter:SetOwner( self )
        emitter:Spawn()
        local min = emitter:OBBMins()
        emitter:SetPos( hitdata.HitPos - hitdata.HitNormal * min.z )

        table.insert(self.SpawnedENTS,emitter)
        self.CurrentSpawnedEmitters = self.CurrentSpawnedEmitters + 1
        DebugText('Tool: Created Emitter! Now have '..self.CurrentSpawnedEmitters..' Emitters with the limit being, '..GetConVar('zetaplayer_emitterlimit'):GetInt())
        if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
            if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                net.Start("zeta_sendonscreenlog",true)
                net.WriteString(self.zetaname..' used tool Emitter Tool')
                net.WriteColor(Color(255,255,255),false)
                net.Broadcast()
            end
            MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' used tool Emitter Tool')
        end
        if ( SERVER ) then
            emitter:CallOnRemove('Emittercallremove'..emitter:EntIndex(),function()
                if !self:IsValid() then return end
                self.CurrentSpawnedEmitters = self.CurrentSpawnedEmitters - 1
                table.RemoveByValue(self.SpawnedENTS,emitter)
            end)
        end
        self.IsBuilding = false


    end)




    while self.IsBuilding == true do
        coroutine.yield()
    end
end




function ENT:UseBoneManipulatorTool()
    if self.TypingInChat then return end
    if self.IsBuilding == true then return end
    if GetConVar("zetaplayer_bonemanipulatortool"):GetInt() == 0 then return end
    self.IsBuilding = true 
    DebugText('Tool: Attempting to use Bone Manipulator Tool')
    

    local props = self:FindInSightPermission(700)

    for k,v in ipairs(props) do
        if v:GetClass() == "prop_ragdoll" or v:IsNPC() then
            selectedprop = v
            break
        end
    end

    if selectedprop and selectedprop:IsValid() then
        self:Face(selectedprop)
        self:LookAt(selectedprop,'both')
        timer.Simple(math.random(0.5,1.5),function()
            if !self:IsValid() or !IsValid(self.WeaponENT) then return end
        if selectedprop and selectedprop:IsValid() then

            self:UseToolGunOn(selectedprop)

            local count = self:GetBoneCount()
            local rnd = math.random(1,3)
            if rnd == 1 then
                for i = 1, count do
                    if 100*math.random() < 40 then
                        selectedprop:ManipulateBoneAngles( i, AngleRand(-90,90) )
                    end
                end
            elseif rnd == 2 then
                for i = 1, count do
                    if 100*math.random() < 40 then
                        selectedprop:ManipulateBoneScale( i, VectorRand(0.00,5.00) )
                    end
                end
            elseif rnd == 3 then
                for i = 1, count do
                    if 100*math.random() < 10 then
                        local pos,ang = selectedprop:GetBonePosition( i )
                        if pos then
                            selectedprop:ManipulateBonePosition( i, pos+Vector(math.random(-2,2),math.random(-2,2),math.random(-2,2)) )
                        end
                    end
                end
            end

            self:StopFacing()
            self:StopLooking()
            self.IsBuilding = false
            DebugText('Tool: Changed Ragdoll Bones')
            if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
                if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                    net.Start("zeta_sendonscreenlog",true)
                    net.WriteString(self.zetaname..' used tool Bone Manipulator Tool')
                    net.WriteColor(Color(255,255,255),false)
                    net.Broadcast()
                end
                MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' used tool Bone Manipulator Tool')
            end
        else
            self.IsBuilding = false
            DebugText('Tool: Selected prop is not valid x2')
        end

            if IsValid(selectedprop) then
                hook.Run("OnZetaUseToolgun",self,selectedprop,"Bone")
            end

        end)

    else
        self.IsBuilding = false
        DebugText('Tool: Selected prop is not valid')
    end
   
    while self.IsBuilding == true do
        coroutine.yield()
    end

end




function ENT:UseDynamiteTool()
    if self.TypingInChat then return end
    if GetConVar('zetaplayer_allowdynamitetool'):GetInt() == 0 then return end
    if self.CurrentSpawnedEmitters >= GetConVar('zetaplayer_dynamitelimit'):GetInt() then DebugText('Tool: Hit the Dynamite Limit!') return end
    if self.IsBuilding == true then return end

    self.IsBuilding = true
    DebugText('Tool: Attempting to use Dynamite Tool')

    local rndspot = self:GetPos()+Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(-100,30))

    self:LookAt(rndspot,'both')

    timer.Simple(math.random(0.5,1.5),function()
        if !self:IsValid() or !IsValid(self.WeaponENT) then self.IsBuilding = false return end



        self:StopLooking()
        local hitdata = self:UseToolGun()

        local dynamite = ents.Create('zeta_dynamite') 

        dynamite:SetPos(hitdata.HitPos+hitdata.Normal)
        dynamite:SetAngles(-hitdata.Normal:Angle())
        dynamite.IsZetaProp = true
        dynamite:SetOwner( self )
        dynamite:Spawn()
        local min = dynamite:OBBMins()
        dynamite:SetPos( hitdata.HitPos - hitdata.HitNormal * min.z )

        table.insert(self.SpawnedENTS,dynamite)
        self.CurrentSpawnedDynamite = self.CurrentSpawnedDynamite + 1
        DebugText('Tool: Created Dynamite! Now have '..self.CurrentSpawnedDynamite..' Dynamite with the limit being, '..GetConVar('zetaplayer_dynamitelimit'):GetInt())
        if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
            if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                net.Start("zeta_sendonscreenlog",true)
                net.WriteString(self.zetaname..' used tool Dynamite Tool')
                net.WriteColor(Color(255,255,255),false)
                net.Broadcast()
            end
            MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' used tool Dynamite Tool')
        end
        if ( SERVER ) then
            dynamite:CallOnRemove('Dynamitecallremove'..dynamite:EntIndex(),function()
                if !self:IsValid() then return end
                self.CurrentSpawnedDynamite = self.CurrentSpawnedDynamite - 1
                table.RemoveByValue(self.SpawnedENTS,dynamite)
            end)
        end
        self.IsBuilding = false
    end)




    while self.IsBuilding == true do
        coroutine.yield()
    end
end



function ENT:UsePaintTool(repeattimes)
    if self.TypingInChat then return end
    if self.IsBuilding == true then return end
    if GetConVar("zetaplayer_allowpainttool"):GetInt() == 0 then return end
    self.IsBuilding = true 
    DebugText('Tool: Attempting to use Paint Tool')
    local times = 0
    if repeattimes and repeattimes != 0 then times = repeattimes end 
    
    local rndspot = self:GetPos()+Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(-100,30))

        self:LookAt(rndspot,'both')
        timer.Simple(math.random(0.5,1.5),function()
        if !self:IsValid() or !IsValid(self.WeaponENT) then return end

            self:EmitSound("player/sprayer.wav",80)

            util.Decal(self.Decals[math.random(#self.Decals)],self.WeaponENT:GetPos(),self.WeaponENT:GetPos()+self.WeaponENT:GetForward()*1000000)

            self:StopLooking()
            self.IsBuilding = false
            if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
                if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                    net.Start("zeta_sendonscreenlog",true)
                    net.WriteString(self.zetaname..' used tool Paint Tool')
                    net.WriteColor(Color(255,255,255),false)
                    net.Broadcast()
                end
                MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' used tool Paint Tool')
            end

        end)
   
    while self.IsBuilding == true do
        coroutine.yield()
    end

    if times > 0 then
        self:UsePaintTool(times-1)
    end

end





function ENT:UseWorldRopeTool()
    if self.TypingInChat then return end
    if self.IsBuilding == true then return end
    local canuse = GetConVar('zetaplayer_allowropetool'):GetInt()
    if canuse == 0 then return end
    if self.CurrentSpawnedRopes >= GetConVar('zetaplayer_ropelimit'):GetInt() then DebugText('Tool: Hit the Rope Limit!') return end

    self.IsBuilding = true 
    DebugText('Tool: Attempting to use Rope Tool')

    local pos1
    local pos2

     


    local pos = self:GetPos()+Vector(math.random(-100,100),math.random(-100,100),math.random(-100,300))

            self:Face(pos)
            self:LookAt(pos,'both')
        timer.Simple(math.random(0.5,1.5),function()
            if !self:IsValid() then return end

                local trace = self:UseToolGun(true)

                if !trace then return end

                pos1 = trace.HitPos

                DebugText('Tool: Set Pos 1..')
                self:StopFacing()
                self:StopLooking()
                local pos = self:GetPos()+Vector(math.random(-100,100),math.random(-100,100),math.random(-100,300))
                    self:Face(pos)
                    self:LookAt(pos,'both')
                
                timer.Simple(math.random(0.5,1.5),function()
                    if !self:IsValid() then return end
                        local trace = self:UseToolGun(true)
                        if !trace then return end
                        pos2 = trace.HitPos
                        self:StopFacing()
                        self:StopLooking()
                        local rope = constraint.Rope(Entity(0),Entity(0),0,0,pos1,pos2,pos1:Distance(pos2),math.random(0,200),0,math.random(1.0,10.0),self.RopeMats[math.random(#self.RopeMats)],false)
                        if !rope or !rope:IsValid() then self.IsBuilding = false return end
                        rope.IsZetaProp = true
                        table.insert(self.SpawnedENTS,rope)
                        self.CurrentSpawnedRopes = self.CurrentSpawnedRopes + 1
                        if ( SERVER ) then
                            rope:CallOnRemove('ropecallremove'..rope:EntIndex(),function()
                                if !self:IsValid() then return end
                                self.CurrentSpawnedRopes = self.CurrentSpawnedRopes - 1
                                if self.SpawnedENT then
                                    table.RemoveByValue(self.SpawnedENT,rope)
                                end
                            end)
                        end
                        if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
                            if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                                net.Start("zeta_sendonscreenlog",true)
                                net.WriteString(self.zetaname..' used tool Rope Tool')
                                net.WriteColor(Color(255,255,255),false)
                                net.Broadcast()
                            end
                            MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' used tool Rope Tool')
                        end
                        DebugText('Tool: Created Rope!')
                        self.IsBuilding = false

                end)

        end)


    while self.IsBuilding == true do
        coroutine.yield()
    end

end




function ENT:UseLampTool()
    if self.TypingInChat then return end
    if GetConVar('zetaplayer_allowlamptool'):GetInt() == 0 then return end
    if self.CurrentSpawnedLamps >= GetConVar('zetaplayer_lamplimit'):GetInt() then DebugText('Tool: Hit the Lamp Limit!') return end
    if self.IsBuilding == true then return end

    self.IsBuilding = true
    DebugText('Tool: Attempting to use Lamp Tool')

    local rndspot = self:GetPos()+Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(-100,100))

    self:LookAt(rndspot,'both')

    timer.Simple(math.random(0.5,1.5),function()
        if !self:IsValid() then self.IsBuilding = false return end



        self:StopLooking()
        local hitdata = self:UseToolGun()

        local lamp = ents.Create('zeta_lamp') -- We use our own lamp. Aaaagain another new ent 

        lamp:SetPos(hitdata.HitPos+hitdata.Normal*-50)
        lamp:SetAngles(Angle(0,math.random(-180,180),0))
        lamp.IsZetaProp = true
        lamp:SetOwner( self )
        lamp:Spawn()
        local min = lamp:OBBMins()
        lamp:SetPos( hitdata.HitPos - hitdata.HitNormal * min.z )


        table.insert(self.SpawnedENTS,lamp)
        self.CurrentSpawnedLamps = self.CurrentSpawnedLamps + 1
        DebugText('Tool: Created lamp! Now have '..self.CurrentSpawnedLamps..' Lamps with the limit being, '..GetConVar('zetaplayer_lamplimit'):GetInt())
        if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
            if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                net.Start("zeta_sendonscreenlog",true)
                net.WriteString(self.zetaname..' used tool Lamp Tool')
                net.WriteColor(Color(255,255,255),false)
                net.Broadcast()
            end
            MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' used tool Lamp Tool')
        end
        if ( SERVER ) then
            lamp:CallOnRemove('Lampcallremove'..lamp:EntIndex(),function()
                if !self:IsValid() then return end
                self.CurrentSpawnedLamps = self.CurrentSpawnedLamps - 1
                table.RemoveByValue(self.SpawnedENTS,lamp)
            end)
        end
        self.IsBuilding = false
    end)




    while self.IsBuilding == true do
        coroutine.yield()
    end
end






function ENT:UseThrusterTool()
    if self.TypingInChat then return end
    if GetConVar('zetaplayer_allowthrustertool'):GetInt() == 0 then return end
    if self.CurrentSpawnedThrusters >= GetConVar('zetaplayer_thrusterlimit'):GetInt() then DebugText('Tool: Hit the Thruster Limit!') return end
    if self.IsBuilding == true then return end

    self.IsBuilding = true
    DebugText('Tool: Attempting to use Thruster Tool')
    local ent_pos

    if math.random(1,3) == 1 then
    ent_pos = self:GetPos()+Vector(math.random(-100,100),math.random(-100,100),math.random(-100,100))
    DebugText('Tool: Picking random position')
    else
        DebugText('Tool: Picking a entity')
        local entities = self:FindInSightPermission(500)

        if #entities == 0  then
            ent_pos = self:GetPos()+Vector(math.random(-100,100),math.random(-100,100),math.random(-100,100))
            DebugText('Tool: Failed to pick a entity falling back to a random spot')
        else
            ent_pos = entities[math.random(#entities)]
            
        end
    end
    if type(ent_pos) != 'Vector' and !IsValid(ent_pos) then
        DebugText('Tool: Ent is not Valid! falling back to a random spot')
        ent_pos = self:GetPos()+Vector(math.random(-100,100),math.random(-100,100),math.random(-100,100))
    end
    

    self:LookAt(ent_pos,'both')

    if type(ent_pos) == 'Entity' or type(ent_pos) == 'NPC' then
        self:Face(ent_pos)
    end

    timer.Simple(math.random(0.5,1.5),function()
        if !self:IsValid() then return end
        if type(ent_pos) != 'Vector' and !ent_pos:IsValid() then self:StopFacing() self:StopLooking() DebugText('Tool: Ent is not Valid!') self.IsBuilding = false return end
        if !ent_pos then self:StopFacing() self:StopLooking() self.IsBuilding = false return end
        
        self:StopLooking()
        self:StopFacing()

        local hitdata = self:UseToolGun()

        local thruster = ents.Create('zeta_thruster') 

        thruster.IsZetaProp = true
        thruster:SetAngles(AngleRand(-180,180))
        thruster:SetOwner( self )
        thruster:Spawn()
        local min = thruster:OBBMins()
        thruster:SetPos( hitdata.HitPos - hitdata.HitNormal * min.z )
        table.insert(self.SpawnedENTS,thruster)
        self.CurrentSpawnedThrusters = self.CurrentSpawnedThrusters + 1
        DebugText('Tool: Created Thruster! Now have '..self.CurrentSpawnedThrusters..' Thrusters with the limit being, '..GetConVar('zetaplayer_thrusterlimit'):GetInt())
        if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
            if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                net.Start("zeta_sendonscreenlog",true)
                net.WriteString(self.zetaname..' used tool Thruster Tool')
                net.WriteColor(Color(255,255,255),false)
                net.Broadcast()
            end
            MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' used tool Thruster Tool')
        end
        if ( SERVER ) then
            thruster:CallOnRemove('thrustercallremove'..thruster:EntIndex(),function()
                if !self:IsValid() then return end
                self.CurrentSpawnedThrusters = self.CurrentSpawnedThrusters - 1
                table.RemoveByValue(self.SpawnedENTS,thruster)
            end)

            if thruster:IsValid() and self:IsValid() and type(ent_pos) != 'Vector' and ent_pos:IsValid() then
                thruster:SetAngles(hitdata.HitNormal:Angle()+Angle(90,0,0))
                constraint.Weld(thruster,ent_pos,0,0,0,true,true)
            end

        end

        self.IsBuilding = false

        if IsValid(thruster) and IsValid(self) and type(ent_pos) != 'Vector' and IsValid(ent_pos) then
            hook.Run("OnZetaUseToolgun",self,selectedprop,"Thruster")
        end
    end)




    while self.IsBuilding == true do
        coroutine.yield()
    end


end

function ENT:UseToolGunV2(targetpos,name,convarname,class,repeattimes)
    if self.TypingInChat then return end
    if GetConVar('zetaplayer_allow'..convarname..'tool'):GetInt() == 0 then return end
    if self.CurrentSpawnTABLE[name] >= GetConVar('zetaplayer_'..convarname..'limit'):GetInt() then DebugText('Tool: Hit the '..convarname..' Limit!') return end
    if self.IsBuilding == true then return end
    self.IsBuilding = true

    pos = isfunction(targetpos) and targetpos() or targetpos or self:GetPos()+Vector(math.random(-100,100),math.random(-100,100),math.random(-100,100))

    self:LookAt2("zetalookattoolpos",0,pos)
    self:Face2("zetafaceattoolpos",0,pos,5)
    local times = 0
    if repeattimes and repeattimes != 0 then times = repeattimes end 


    timer.Simple(math.Rand(0.5,1.5),function()
        if !IsValid(self) then return end
        local createdEntity

        self:RemoveThinkFunction("zetalookattoolpos")
        self:RemoveThinkFunction("zetafaceattoolpos")

        local hitdata = self:UseToolGun()

        if isfunction(class) then
            createdEntity = class(hitdata)
        else
            createdEntity = ents.Create(class)
            createdEntity:SetPos(hitdata.HitPos+hitdata.Normal*-50)
            createdEntity:SetAngles(Angle(0,math.random(-180,180),0))
            createdEntity:SetOwner( self )
            createdEntity:Spawn()
            local min = createdEntity:OBBMins()
            createdEntity:SetPos( hitdata.HitPos - hitdata.HitNormal * min.z )

        end

        if !IsValid(createdEntity) then return end

        createdEntity.IsZetaProp = true

        table.insert(self.SpawnedENTS,createdEntity)
        self.CurrentSpawnTABLE[name] = self.CurrentSpawnTABLE[name] + 1
        DebugText('Tool: Created '..name..'! Now have '..self.CurrentSpawnTABLE[name]..' '..name..'s with the limit being, '..GetConVar('zetaplayer_'..convarname..'limit'):GetInt())
        if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
            if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                net.Start("zeta_sendonscreenlog",true)
                net.WriteString(self.zetaname..' used tool '..name..' Tool')
                net.WriteColor(Color(255,255,255),false)
                net.Broadcast()
            end
            MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' used tool '..name..' Tool')
        end
        if ( SERVER ) then
            createdEntity:CallOnRemove(name..'callremove'..createdEntity:EntIndex(),function()
                if !IsValid(self) then return end
                self.CurrentSpawnTABLE[name] = self.CurrentSpawnTABLE[name] - 1
                table.RemoveByValue(self.SpawnedENTS,createdEntity)
            end)
        end

        self.IsBuilding = false

    end)

    while self.IsBuilding == true do
        coroutine.yield()
    end

    if times > 0 then
        self:UseToolGunV2(targetpos,name,convarname,class,times-1)
    end
end


local WireGATEMdls = {
    "models/bull/gates/capacitor.mdl",
    "models/bull/gates/microcontroller1.mdl",
    "models/bull/gates/microcontroller2.mdl",
    "models/bull/gates/microcontroller2_mini.mdl",
    "models/bull/gates/processor.mdl",
    "models/bull/gates/processor_mini.mdl",
    "models/bull/gates/resistor.mdl",
    "models/bull/gates/transistor1.mdl",
    "models/bull/gates/transistor2.mdl",
    "models/jaanus/wiretool/wiretool_gate.mdl",
    "models/jaanus/wiretool/wiretool_controlchip.mdl",
    "models/bull/gates/capacitor_mini.mdl",
    "models/bull/gates/capacitor_nano.mdl"
}

local WireButtonMdls = {
    "models/bull/buttons/key_switch.mdl",
    "models/bull/buttons/rocker_switch.mdl",
    "models/bull/buttons/toggle_switch.mdl",
    "models/cheeze/buttons/button_0.mdl",
    "models/cheeze/buttons/button_0.mdl",
    "models/cheeze/buttons/button_1.mdl",
    "models/cheeze/buttons/button_2.mdl",
    "models/cheeze/buttons/button_3.mdl",
    "models/cheeze/buttons/button_4.mdl",
    "models/cheeze/buttons/button_5.mdl",
    "models/cheeze/buttons/button_6.mdl",
    "models/cheeze/buttons/button_7.mdl",
    "models/cheeze/buttons/button_8.mdl",
    "models/cheeze/buttons/button_9.mdl",
    "models/cheeze/buttons/button_arm.mdl",
    "models/cheeze/buttons/button_clear.mdl",
    "models/cheeze/buttons/button_enter.mdl",
    "models/cheeze/buttons/button_fire.mdl",
    "models/cheeze/buttons/button_minus.mdl",
    "models/cheeze/buttons/button_muffin.mdl",
    "models/cheeze/buttons/button_plus.mdl",
    "models/cheeze/buttons/button_reset.mdl",
    "models/cheeze/buttons/button_set.mdl",
    "models/cheeze/buttons/button_start.mdl",
    "models/cheeze/buttons/button_stop.mdl",
    "models/cheeze/buttons2/0.mdl",
    "models/cheeze/buttons2/1.mdl",
    "models/cheeze/buttons2/2.mdl",
    "models/cheeze/buttons2/3.mdl",
    "models/cheeze/buttons2/4.mdl",
    "models/cheeze/buttons2/5.mdl",
    "models/cheeze/buttons2/6.mdl",
    "models/cheeze/buttons2/7.mdl",
    "models/cheeze/buttons2/8.mdl",
    "models/cheeze/buttons2/9.mdl",
    "models/cheeze/buttons2/activate.mdl",
    "models/cheeze/buttons2/aim.mdl",
    "models/cheeze/buttons2/air.mdl",
    "models/cheeze/buttons2/alert.mdl",
    "models/cheeze/buttons2/arm.mdl",
    "models/cheeze/buttons2/cake.mdl",
    "models/cheeze/buttons2/charge.mdl",
    "models/cheeze/buttons2/clear.mdl",
    "models/cheeze/buttons2/clock.mdl",
    "models/cheeze/buttons2/compile.mdl",
    "models/cheeze/buttons2/coolant.mdl",
    "models/cheeze/buttons2/deactivate.mdl",
    "models/cheeze/buttons2/divide.mdl",
    "models/cheeze/buttons2/down.mdl",
    "models/cheeze/buttons2/easy.mdl",
    "models/cheeze/buttons2/energy.mdl",
    "models/cheeze/buttons2/enter.mdl",
    "models/cheeze/buttons2/equals.mdl",
    "models/cheeze/buttons2/fire.mdl",
    "models/cheeze/buttons2/go.mdl",
    "models/cheeze/buttons2/left.mdl",
    "models/cheeze/buttons2/minus.mdl",
    "models/cheeze/buttons2/muffin.mdl",
    "models/cheeze/buttons2/multiply.mdl",
    "models/cheeze/buttons2/overide.mdl",
    "models/cheeze/buttons2/plus.mdl",
    "models/cheeze/buttons2/power.mdl",
    "models/cheeze/buttons2/pwr_blue.mdl",
    "models/cheeze/buttons2/pwr_green.mdl",
    "models/cheeze/buttons2/pwr_red.mdl",
    "models/cheeze/buttons2/reset.mdl",
    "models/cheeze/buttons2/right.mdl",
    "models/cheeze/buttons2/set.mdl",
    "models/cheeze/buttons2/start.mdl",
    "models/cheeze/buttons2/stop.mdl",
    "models/cheeze/buttons2/test.mdl",
    "models/cheeze/buttons2/toggle.mdl",
    "models/cheeze/buttons2/up.mdl",
    "models/maxofs2d/button_01.mdl",
    "models/dav0r/buttons/button.mdl",
    "models/dav0r/buttons/switch.mdl",
    "models/maxofs2d/button_02.mdl",
    "models/maxofs2d/button_03.mdl",
    "models/maxofs2d/button_04.mdl",
    "models/maxofs2d/button_05.mdl",
    "models/maxofs2d/button_06.mdl",
    "models/maxofs2d/button_slider.mdl",
        
}

function ENT:UseWireGateTool()
    if !WireLib then return end

    self:UseToolGunV2(nil,"Wire Gate","wiregate",function(hitdata)
    
        local createdEntity = ents.Create("gmod_wire_gate")
        createdEntity:SetPos(hitdata.HitPos+hitdata.Normal*-50)
        createdEntity:SetModel(WireGATEMdls[math.random(#WireGATEMdls)])
        createdEntity:SetAngles(hitdata.HitNormal:Angle()+Angle(90,math.random(-180,180),0))
        createdEntity:SetOwner( self )
        createdEntity:Spawn()
        createdEntity:Activate()
        local min = createdEntity:OBBMins()
        createdEntity:SetPos( hitdata.HitPos - hitdata.HitNormal * min.z )

        local phys = createdEntity:GetPhysicsObject()
        if IsValid(phys) then 
            phys:EnableMotion(false)
        end

        local keys = table.GetKeys( GateActions )
        local action = keys[math.random(#keys)]
        createdEntity:Setup(action, false )

        net.Start("zeta_changegetplayername",true)
            net.WriteEntity(createdEntity)
            net.WriteString(self.zetaname)
        net.Broadcast()
    
        return createdEntity
    end,math.random(1,5))
end

function ENT:UseWireButtonTool()
    if !WireLib then return end

    self:UseToolGunV2(nil,"Wire Button","wirebutton",function(hitdata)

        if !hitdata then return end
    
        local createdEntity = ents.Create("gmod_wire_button")
        createdEntity:SetPos(hitdata.HitPos+hitdata.Normal*-50)
        createdEntity:SetModel(WireButtonMdls[math.random(#WireButtonMdls)])
        createdEntity:SetAngles(hitdata.HitNormal:Angle()+Angle(90,math.random(-180,180),0))
        createdEntity:SetOwner( self )
        createdEntity:Spawn()
        createdEntity:Activate()
        local min = createdEntity:OBBMins()
        createdEntity:SetPos( hitdata.HitPos - hitdata.HitNormal * min.z )

        local phys = createdEntity:GetPhysicsObject()
        if IsValid(phys) then 
            phys:EnableMotion(false)
        end

        createdEntity:Setup(tobool(math.random(0,1)), math.random(-255,0), math.random(0,255), "", tobool(math.random(0,1)))

        net.Start("zeta_changegetplayername",true)
            net.WriteEntity(createdEntity)
            net.WriteString(self.zetaname)
        net.Broadcast()
    
        return createdEntity
    end,math.random(1,5))
end