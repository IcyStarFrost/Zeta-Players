-----------------------------------------------
-- Zeta SpawnMenu
--- This is where Zeta's own spawnmenu resides. It's not that exciting lol
-----------------------------------------------
AddCSLuaFile()
    ENT.CurrentSpawnedProps = 0
    ENT.CurrentSpawnedNPCS = 0
    ENT.CurrentSpawnedSENTS = 0
    ENT.SpawnedENTS = {} -- Used to keep track of our spawned entities so we can undo them later if we want

    local IsValid = IsValid

function ENT:PressButton(button)

    if button:GetClass() == "func_button" then
        button:Fire("Press")
    elseif button:GetClass() == "gmod_button" then
        local ison = button:GetOn()
        if ison then
            button:Toggle( false, self )
        else
            button:Toggle( true, self )
        end
    elseif button:GetClass() == "gmod_wire_button" then
        local ison = button:GetOn()
        if ison then
            button:Switch(false)
        else
            button:Switch(true)
        end
    end

end
   
function ENT:SpawnProp(down)
    if self.TypingInChat then return end
    if self.IsBuilding == true then return end
    if self.Grabbing == true then return end
    if !GetConVar('zetaplayer_allowprops'):GetBool() then return end
    if self.CurrentSpawnedProps >= GetConVar('zetaplayer_proplimit'):GetInt() then return end
    if game.SinglePlayer() and !self:TestPVS( Entity(1) ) then return end
    self.IsBuilding = true
    local origintrace
    local prop

    DebugText('Spawnmenu: Attempting to spawn a prop')

    local z = math.random(-100,0)

    if down then
        z = -100
    end

    local rndspot = self:GetPos()+Vector(math.random(-500,500),math.random(-500,500),z)

    self:LookAt(rndspot,'both')

    timer.Simple(math.random(0.5,1.5),function()
        if !self:IsValid() then self.IsBuilding = false return end



        self:StopLooking()
        local attach = self:GetAttachmentPoint("eyes")

        local angleforward = attach.Ang:Forward()
        origintrace = util.TraceLine({start = attach.Pos,endpos = angleforward*800000,filter = self})
        self:EmitSound('ui/buttonclickrelease.wav',65)

        prop = ents.Create('prop_physics')
        prop:SetModel(self.ValidProps[math.random(#self.ValidProps)])
        local mins = prop:OBBMins()
        prop:SetPos(origintrace.HitPos - origintrace.HitNormal * mins.z)
        prop:SetAngles(self:GetAngles()+Angle(0,90,0))
        prop.IsZetaProp = true
        prop:SetOwner( self )
        prop:SetSpawnEffect( true )
        prop:Spawn()

        
        self.achievement_Creator = self.achievement_Creator + 1

        if self.achievement_Creator == self.achievement_CreatorMax then
            self:AwardAchievement("Creator")
        end

        if self.Weapon == 'TOOLGUN' and math.random(1,2) == 1 then
            self:UseToolGun()
        end

        if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
            if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                net.Start("zeta_sendonscreenlog",true)
                net.WriteString(self.zetaname..' spawned model ('..prop:GetModel()..')')
                net.WriteColor(Color(255,255,255),false)
                net.Broadcast()
            end
            MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' spawned model ('..prop:GetModel()..')')
        end

        local min,max = prop:GetModelBounds()
    if GetConVar('zetaplayer_allowlargeprops'):GetInt() == 1 then
        if GetConVar('zetaplayer_freezelargeprops'):GetInt() == 1 then
            if max.x > 70 and max.y > 70 then
                prop:GetPhysicsObject():EnableMotion(false)
                DebugText('Spawnmenu: Freeze Large Props is on! Froze '..tostring(prop)..'  Bound nums = '..max.x..' '..max.y..' '..max.z)
            end
        end

    else
        if max.x > 70 and max.y > 70 or max.z > 100 then
            prop:Remove()
            DebugText('Spawnmenu: Prop was considered large! Removed!')
            self.IsBuilding = false
            return
        end
    end

        if GetConVar('zetaplayer_propspawnunfrozen'):GetInt() == 0 then

            if math.random(1,2) == 1 then
                prop:GetPhysicsObject():EnableMotion(false)
            else
                timer.Simple(20,function()
                    if !self:IsValid() then return end
                    if !prop:IsValid() then return end
                    if !prop:GetPhysicsObject():IsValid() then return end
                    prop:GetPhysicsObject():EnableMotion(false)
                end)
            end

        end

        table.insert(self.SpawnedENTS,prop)
        self.CurrentSpawnedProps = self.CurrentSpawnedProps + 1

        DebugText('Spawnmenu: Created a Prop! Now have '..self.CurrentSpawnedProps..' Props with the limit being, '..GetConVar('zetaplayer_proplimit'):GetInt())

        if ( SERVER ) then
            prop:CallOnRemove('propcallremove'..prop:EntIndex(),function()
                if !self:IsValid() then return end
                self.CurrentSpawnedProps = self.CurrentSpawnedProps - 1
                table.RemoveByValue(self.SpawnedENTS,prop)
            end)
        end

        local zetastats = file.Read("zetaplayerdata/zetastats.json")

        if zetastats then
            zetastats = util.JSONToTable(zetastats)

            if zetastats then

                zetastats["spawnedpropscount"] = zetastats["spawnedpropscount"] and zetastats["spawnedpropscount"]+1 or 1

                ZetaFileWrite("zetaplayerdata/zetastats.json",util.TableToJSON(zetastats,true))
            else
                ZetaFileWrite("zetaplayerdata/zetastats.json","[]")
            end
        end

        
        self.IsBuilding = false
    end)




    while self.IsBuilding == true do
        coroutine.yield()
    end
    if !self.IsBuilding then
        return prop
    end
end

function ENT:UndoLastEnt()

    local lastent = self.SpawnedENTS[#self.SpawnedENTS]

    if lastent and lastent:IsValid() then
        
        self.achievement_Remove = self.achievement_Remove + 1
        if self.achievement_Remove == self.achievement_RemoveMax then
            self:AwardAchievement("Remover")
        end

        table.RemoveByValue(self.SpawnedENTS,lastent)
        lastent:Remove()
        self:EmitSound('buttons/button15.wav',70)
        DebugText('Spawnmenu: Undone '..tostring(lastent))
    else
        table.RemoveByValue(self.SpawnedENTS,lastent)
        DebugText('Spawnmenu: Failed to undo a entity. Entity was not valid')
    end

end





function ENT:SpawnMedKit(overrideCount)
    if self.TypingInChat then return end
    if self.IsBuilding == true then return end
    if self.Grabbing == true then return end
    if GetConVar('zetaplayer_allowmedkits'):GetInt() == 0 then return end
    if self.CurrentSpawnedSENTS >= GetConVar('zetaplayer_sentlimit'):GetInt() then return end
    self.IsBuilding = true

    DebugText('Spawnmenu: Attempting to spawn a medkit')

    local rndspot = self:GetPos()+Vector(math.random(-10,10),math.random(-10,10),math.random(0,-100))

    self:LookAt(rndspot,'both')

    local timerName = 'zetatimer_spawnmedkits_'..self:EntIndex()
    local useToolGun = (self.Weapon == 'TOOLGUN' and math.random(1,2) == 1)
    local spawnCount = overrideCount or math.random(1, math.max(1, math.ceil((self:GetMaxHealth()-self:Health())/25)))
    timer.Create(timerName, 0.4, spawnCount, function()
        if !IsValid(self) then return end
        
        local medkit = ents.Create('item_healthkit')
        medkit:SetModel('models/Items/HealthKit.mdl')
        medkit:SetPos(self:GetPos()+self:GetForward()*50+Vector(0,0,5))
        medkit.IsZetaProp = true
        medkit:SetOwner( self )
        medkit:SetSpawnEffect( true )
        
        if useToolGun then
            self:UseToolGun()
        else
            self:EmitSound('ui/buttonclickrelease.wav',65)
        end
        
        if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
            if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                net.Start("zeta_sendonscreenlog",true)
                net.WriteString(self.zetaname..' spawned SENT MedKit ('..medkit:GetModel()..')')
                net.WriteColor(Color(255,255,255),false)
                net.Broadcast()
            end
            MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' spawned SENT MedKit ('..medkit:GetModel()..')')
        end

        table.insert(self.SpawnedENTS,medkit)
        self.CurrentSpawnedSENTS = self.CurrentSpawnedSENTS + 1
        DebugText('Spawnmenu: Created a Medkit! Now have '..self.CurrentSpawnedSENTS..' SENTs with the limit being, '..GetConVar('zetaplayer_sentlimit'):GetInt())
        
        if ( SERVER ) then
            medkit:CallOnRemove('medkitcallremove'..medkit:EntIndex(),function()
                if !self:IsValid() then return end
                self.CurrentSpawnedSENTS = self.CurrentSpawnedSENTS - 1
                table.RemoveByValue(self.SpawnedENTS,medkit)
            end)
        end

        if timer.RepsLeft(timerName) == 0 then 
            self:StopLooking()
            self.IsBuilding = false 
        end

        medkit:Spawn()
    end)




    while self.IsBuilding == true do
        coroutine.yield()
    end
end



function ENT:SpawnArmorBattery()
    if self.TypingInChat then return end
    if self.IsBuilding == true then return end
    if self.Grabbing == true then return end
    if GetConVar('zetaplayer_allowarmorbatteries'):GetInt() == 0 then return end
    if self.CurrentSpawnedSENTS >= GetConVar('zetaplayer_sentlimit'):GetInt() then return end
    self.IsBuilding = true

    DebugText('Spawnmenu: Attempting to spawn a Battery')

    local rndspot = self:GetPos()+Vector(math.random(-10,10),math.random(-10,10),math.random(0,-100))

    self:LookAt(rndspot,'both')

    local timerName = 'zetatimer_spawnbatteries_'..self:EntIndex()
    local useToolGun = (self.Weapon == 'TOOLGUN' and math.random(1,2) == 1)
    local spawnCount = math.random(1, math.max(1, math.ceil((self.MaxArmor-self.CurrentArmor)/15)))
    timer.Create(timerName, 0.4, spawnCount, function()
        if !IsValid(self) then return end
        
        local battery = ents.Create('item_battery')
        battery:SetModel('models/Items/battery.mdl')
        battery:SetPos(self:GetPos()+self:GetForward()*50+Vector(0,0,5))
        battery.IsZetaProp = true
        battery:SetOwner( self )
        battery:SetSpawnEffect( true )
        
        if useToolGun then
            self:UseToolGun()
        else
            self:EmitSound('ui/buttonclickrelease.wav',65)
        end
        
        if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
            if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                net.Start("zeta_sendonscreenlog",true)
                net.WriteString(self.zetaname..' spawned SENT Armor Battery ('..battery:GetModel()..')')
                net.WriteColor(Color(255,255,255),false)
                net.Broadcast()
            end
            MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' spawned SENT Armor Battery ('..battery:GetModel()..')')
        end
        
        table.insert(self.SpawnedENTS,battery)
        self.CurrentSpawnedSENTS = self.CurrentSpawnedSENTS + 1
        DebugText('Spawnmenu: Created a Armor Battery! Now have '..self.CurrentSpawnedSENTS..' SENTs with the limit being, '..GetConVar('zetaplayer_sentlimit'):GetInt())
        
        if ( SERVER ) then
            battery:CallOnRemove('batterycallremove'..battery:EntIndex(),function()
                if !self:IsValid() then return end
                self.CurrentSpawnedSENTS = self.CurrentSpawnedSENTS - 1
                table.RemoveByValue(self.SpawnedENTS,battery)
            end)
        end

        if timer.RepsLeft(timerName) == 0 then 
            self:StopLooking()
            self.IsBuilding = false 
        end

        battery:Spawn()
    end)




    while self.IsBuilding == true do
        coroutine.yield()
    end
end





function ENT:SpawnNPC()
        if self.TypingInChat then return end
        if self.IsBuilding == true then return end
        if self.Grabbing == true then return end
        if GetConVar('zetaplayer_allownpcs'):GetInt() == 0 then return end
        if !self.ValidNPCS then print('WARNING: ZETA VALID NPCS IS NOT VALID!') return end
        if self.CurrentSpawnedNPCS >= GetConVar('zetaplayer_npclimit'):GetInt() then DebugText('Spawnmenu: NPC Limit Reached!') return end
        self.IsBuilding = true
        local origintrace

        DebugText('Spawnmenu: Attempting to spawn a NPC')

        local class = self.ValidNPCS[math.random(#self.ValidNPCS)]
        
    
        local rndspot = self:GetPos()+Vector(math.random(-2000,2000),math.random(-2000,2000),math.random(0,-50))
    
        self:LookAt(rndspot,'both')
    
        timer.Simple(math.random(0.5,1.5),function()
            if !self:IsValid() then self.IsBuilding = false return end
    
    
    
            self:StopLooking()
            local attach = self:GetAttachmentPoint("eyes")

                local angleforward = attach.Ang:Forward()
                origintrace = util.TraceLine({start = attach.Pos,endpos = angleforward*800000,filter = self})

    
            local npc = ents.Create(class)

            if !npc:IsValid() then
                self.IsBuilding = false
                return
            end

            self:EmitSound('ui/buttonclickrelease.wav',65)
            npc:SetPos(origintrace.HitPos+origintrace.Normal*-50)

            if ( SERVER ) then
                if GetConVar('zetaplayer_removepropsondeath'):GetInt() == 1 then
                self:CallOnRemove('zetaremoveondelete' .. npc:EntIndex(),function()
                    if npc:IsValid() then
                        npc:Remove()
                    end
                end)
                end
            end
            
            npc.IsZetaProp = true
            npc:SetSpawnEffect( true )
            npc:AttemptGiveWeapons()
            npc:Spawn()

            local mins = npc:OBBMins()
            local pos = npc:GetPos()

            pos.z = pos.z - mins.z 

            npc:SetPos(pos)

            self.achievement_ProCreator = self.achievement_ProCreator + 1

            if self.achievement_ProCreator == self.achievement_ProCreatorMax then
                self:AwardAchievement("ProCreator")
            end

            if self.Weapon == 'TOOLGUN' and math.random(1,2) == 1 then
                self:UseToolGun()
            end

            if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
                if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                    net.Start("zeta_sendonscreenlog",true)
                    net.WriteString(self.zetaname..' spawned NPC ('..npc:GetClass()..')')
                    net.WriteColor(Color(255,255,255),false)
                    net.Broadcast()
                end
                MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' spawned NPC ('..npc:GetClass()..')')
            end
    
            table.insert(self.SpawnedENTS,npc)

            self.CurrentSpawnedNPCS = self.CurrentSpawnedNPCS + 1
            DebugText('Spawnmenu: Created a NPC! Now have '..self.CurrentSpawnedNPCS..' NPCs with the limit being, '..GetConVar('zetaplayer_npclimit'):GetInt())
            
            if ( SERVER ) then
                npc:CallOnRemove('npccallremove'..npc:EntIndex(),function()
                    if !self:IsValid() then return end
                        self.CurrentSpawnedNPCS = self.CurrentSpawnedNPCS - 1
                    table.RemoveByValue(self.SpawnedENTS,npc)
                end)
            end
    
                self.IsBuilding = false
        end)
    
    
    
    
        while self.IsBuilding == true do
            coroutine.yield()
        end

end


function ENT:SpawnEntity()
    if self.TypingInChat then return end
    if self.IsBuilding == true then return end
    if self.Grabbing == true then return end
    if GetConVar('zetaplayer_allowentities'):GetInt() == 0 then return end
    if !self.ValidENTS then print('WARNING: ZETA VALID ENTITIES IS NOT VALID!') return end
    if self.CurrentSpawnedSENTS >= GetConVar('zetaplayer_sentlimit'):GetInt() then DebugText('Spawnmenu: Entity Limit Reached!') return end
    self.IsBuilding = true
    local origintrace

    DebugText('Spawnmenu: Attempting to spawn a Entity')

    local class = self.ValidENTS[math.random(#self.ValidENTS)]
    

    local rndspot = self:GetPos()+Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(0,-50))

    self:LookAt(rndspot,'both')

    timer.Simple(math.random(0.5,1.5),function()
        if !self:IsValid() then self.IsBuilding = false return end



        self:StopLooking()
        local attach = self:GetAttachmentPoint("eyes")

        local angleforward = attach.Ang:Forward()
        origintrace = util.TraceLine({start = attach.Pos,endpos = angleforward*800000,filter = self})


        local ent = ents.Create(class)

        if !IsValid(ent) then self.IsBuilding = false return end

        if ent:IsVehicle() then
            if GetConVar('zetaplayer_allowvehicles'):GetInt() == 1 then
            ent:SetModel('models/buggy.mdl')
            ent:SetKeyValue('vehiclescript','scripts/vehicles/jeep_test.txt')
            else
                self.IsBuilding = false
                ent:Remove()
                return
            end
        end

        self:EmitSound('ui/buttonclickrelease.wav',65)

        if ( SERVER ) then
            if GetConVar('zetaplayer_removepropsondeath'):GetInt() == 1 then
            self:CallOnRemove('zetaremoveondelete' .. ent:EntIndex(),function()
                if ent:IsValid() then
                    ent:Remove()
                end
            end)
            end
        end

        ent.IsZetaProp = true
        ent:SetSpawnEffect( true )
        ent:Spawn()
        if class == 'sent_ball' then 
            ent:SetBallSize(math.random(16, 48))
            if math.random(40) == 1 then
                ent:SetBallColor(Vector(1, 1, 1))
                self:AwardAchievement("Finally, A Grey One!")
            end
        end
        local mins = ent:OBBMins()
        ent:SetPos(origintrace.HitPos - origintrace.HitNormal * mins.z)



        if self.Weapon == 'TOOLGUN' and math.random(1,2) == 1 then
            self:UseToolGun()
        end
        if GetConVar('zetaplayer_consolelog'):GetInt() == 1 then
            if GetConVar("zetaplayer_showzetalogonscreen"):GetInt() == 1 then
                net.Start("zeta_sendonscreenlog",true)
                net.WriteString(self.zetaname..' spawned Entity ('..ent:GetClass()..')')
                net.WriteColor(Color(255,255,255),false)
                net.Broadcast()
            end
            MsgAll('ZETA: ',self:GetNW2String('zeta_name','Zeta Player')..' spawned Entity ('..ent:GetClass()..')')
        end

        table.insert(self.SpawnedENTS,ent)

        self.CurrentSpawnedSENTS = self.CurrentSpawnedSENTS + 1
        DebugText('Spawnmenu: Created a Entity! Now have '..self.CurrentSpawnedSENTS..' Entities with the limit being, '..GetConVar('zetaplayer_sentlimit'):GetInt())
        
        if ( SERVER ) then
            ent:CallOnRemove('entcallremove'..ent:EntIndex(),function()
                if !self:IsValid() then return end
                    self.CurrentSpawnedSENTS = self.CurrentSpawnedSENTS - 1
                table.RemoveByValue(self.SpawnedENTS,ent)
            end)
        end

            self.IsBuilding = false
    end)




    while self.IsBuilding == true do
        coroutine.yield()
    end

end



--[[ function ENT:UseSprayer() Old system
	if self.IsBuilding == true or self.Grabbing == true then return end
	self.IsBuilding = true

	local lookup = self:LookupAttachment('eyes')
	local eyes = self:GetAttachment(lookup)

	local rndspot = eyes.Pos + Vector(math.random(-328, 328), math.random(-328, 328), math.random(-328, 328))
	self:LookAt(rndspot, 'both')

	timer.Simple(math.random(0.5, 1.5),function()
		if !self:IsValid() then return end
		self.IsBuilding = false
		
        // Traceline from eye to rndspot
		local lookTrace = util.TraceLine({
		start = eyes.Pos,
		endpos = rndspot,
		filter = {self},
        collisiongroup = COLLISION_GROUP_DEBRIS
		})
		if !lookTrace.Hit then return end
		
        // The folder with sprays could probably be named 'custom_sprays'
        -- Yes it will
        local images,dirs = file.Find("zetaplayerdata/custom_sprays/*","DATA","nameasc")
        if !images then self.IsBuilding = false return end
		local sprayImage ="../data/zetaplayerdata/custom_sprays/"..images[math.random(#images)]
		net.Start('zeta_usesprayer',true)
			net.WriteString(sprayImage) // Spray Image Path
			net.WriteTable(lookTrace)   // TraceResult table
		net.Broadcast()

		self:EmitSound('player/sprayer.wav', 65)    // Play spray sound
		self:StopLooking()
	end)

	while self.IsBuilding == true do
		coroutine.yield()
	end
end ]]



function ENT:UseSprayer()
    if self.TypingInChat then return end
	if self.IsBuilding == true or self.Grabbing == true then return end
    if GetConVar("zetaplayer_allowsprays"):GetInt() == 0 then return end
	self.IsBuilding = true


	local eyes = self:GetAttachmentPoint("eyes")

	local rndspot = eyes.Pos + Vector(math.random(-328, 328), math.random(-328, 328), math.random(-328, 328))
	self:LookAt(rndspot, 'both')

	timer.Simple(math.random(0.5, 1.5),function()
		if !self:IsValid() then return end
		self.IsBuilding = false
		
        // Traceline from eye to rndspot
		local lookTrace = util.TraceLine({
		start = eyes.Pos,
		endpos = rndspot,
		filter = {self},
        collisiongroup = COLLISION_GROUP_DEBRIS
		})
		if !lookTrace.Hit then return end
		
		local sprayImage = nil

		// The folder with sprays could probably be named 'custom_sprays'
		-- Yes it will
		local images,dirs = file.Find("zetaplayerdata/custom_sprays/*","DATA","nameasc")
		if images and #images > 0 then sprayImage ="../data/zetaplayerdata/custom_sprays/"..images[math.random(#images)] end
		
		// Material files support (couldn't find a way to animate them tho)
		local isMaterial = -1
		local textures,dirs = file.Find("sourceengine/materials/zetasprays/*","BASE_PATH","nameasc")
		if textures and #textures > 0 then
			for k, v in ipairs(textures) do
				if !string.EndsWith(v, '.vtf') then table.remove(textures, k) continue end
			end
		
			if !images or #images <= 0 or math.random(1, (#images+#textures)) <= #textures then

				local matPath = 'zetasprays/'..textures[math.random(#textures)]
				sprayImage = string.Left(matPath, string.len(matPath) - 4)
				isMaterial = self:EntIndex() + math.random(10000, 99999)
			end
		end
		
		if sprayImage == nil then return end

        net.Start('zeta_usesprayer',true)
			net.WriteString(sprayImage) // Spray Image Path
			net.WriteTable(lookTrace)   // TraceResult table
            net.WriteInt(isMaterial, 32)
		net.Broadcast()

		self:EmitSound('player/sprayer.wav', 65)    // Play spray sound
		self:StopLooking()
	end)

	while self.IsBuilding == true do
		coroutine.yield()
	end
end

