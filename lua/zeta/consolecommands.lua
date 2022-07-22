AddCSLuaFile()










function SetPlayerBirthday(ply,cmd,args,strin)
    file.Write("zetaplayerdata/player_birthday.txt",strin)
    ply:PrintMessage(HUD_PRINTCONSOLE,"Your birthday has been set to "..strin)
end

function CleanupZetaEnts(caller)
    if caller:IsPlayer() and !caller:IsAdmin() then 
            net.Start('zeta_notifycleanup',true)
            net.WriteString('Only Admins can Clean Up Zeta Entities!')
            net.WriteBool(true)
            net.Send(caller)
         return 
        end
        if caller:IsPlayer() then
            net.Start('zeta_notifycleanup',true)
            net.WriteString('Cleaned Up Zeta Entities!')
            net.WriteBool(false)
            net.Send(caller)
        end
    local entities = ents.GetAll()

    for k,v in ipairs(entities) do
        local ZetaTest = v.IsZetaProp

        if ZetaTest then
            v:Remove()
        end
    end

end

function _ZetaUpdateServerCache(caller)




    _SERVERTEXTDATA = util.JSONToTable(file.Read("zetaplayerdata/textchatdata.json","DATA"))

    print("SERVER Text Data Updated")
    

    _SERVERMEDIADATA = util.JSONToTable(file.Read("zetaplayerdata/mediaplayerdata.json","DATA"))

    print("SERVER Media Data Updated")

    _SERVERValidMaterials = util.JSONToTable(file.Read('zetaplayerdata/materials.json','DATA'))

    print("SERVER Materials Updated")

    _SERVERValidProps = util.JSONToTable(file.Read('zetaplayerdata/props.json','DATA'))

    print("SERVER Props Updated")

    _SERVERValidNPCS = util.JSONToTable(file.Read('zetaplayerdata/npcs.json','DATA'))

    print("SERVER NPCs Updated")

    _SERVERValidENTS = util.JSONToTable(file.Read('zetaplayerdata/ents.json','DATA'))

    print("SERVER Entities Updated")

    _SERVERNAMES = util.JSONToTable(file.Read('zetaplayerdata/names.json','DATA'))
    
    print("SERVER Profile Pictures Updated")

    _SERVERPFPS,_SERVERPFPDIRS = file.Find("zetaplayerdata/custom_avatars/*","DATA","nameasc")
    print("SERVER Names Updated")

    


    


    


    


    

    

    

    ----
    local managermodels = player_manager.AllValidModels()
    _SERVERPLAYERMODELS = table.Copy(managermodels)
    ----

    _SERVERPLAYERMODELS = table.ClearKeys( _SERVERPLAYERMODELS )


    local json = file.Read("zetaplayerdata/blockedplayermodels.json","DATA")
    local blockedmdls = util.JSONToTable(json)
    local add = ""
    if GetConVar("zetaplayer_enableblockmodels"):GetBool() then
        add = " with Playermodel Blocking modifications"
        if #blockedmdls > 0 then
            for k,v in ipairs(blockedmdls) do
                if !util.IsValidModel(v) then continue end
                local key = table.KeyFromValue( _SERVERPLAYERMODELS, v )
                
                table.remove(_SERVERPLAYERMODELS,key)
            end
        end
    end

    print("SERVER Playermodels Updated"..add)

    
    _SERVERDEFAULTMDLS = {
        'models/player/alyx.mdl',
        'models/player/arctic.mdl',
        'models/player/barney.mdl',
        'models/player/breen.mdl',
        'models/player/charple.mdl',
        'models/player/combine_soldier.mdl',
        'models/player/combine_soldier_prisonguard.mdl',
        'models/player/combine_super_soldier.mdl',
        'models/player/corpse1.mdl',
        'models/player/dod_american.mdl',
        'models/player/dod_german.mdl',
        'models/player/eli.mdl',
        'models/player/gasmask.mdl',
        'models/player/gman_high.mdl',
        'models/player/guerilla.mdl',
        'models/player/kleiner.mdl',
        'models/player/leet.mdl',
        'models/player/odessa.mdl',
        'models/player/phoenix.mdl',
        'models/player/police.mdl',
        'models/player/riot.mdl',
        'models/player/skeleton.mdl',
        'models/player/soldier_stripped.mdl',
        'models/player/swat.mdl',
        'models/player/urban.mdl',
        'models/player/group01/female_0'..math.random(1,6)..'.mdl',
        'models/player/group01/male_0'..math.random(1,9)..'.mdl',
        'models/player/group02/male_02.mdl',
        'models/player/group02/male_04.mdl',
        'models/player/group02/male_06.mdl',
        'models/player/group02/male_08.mdl',
        'models/player/group03/female_0'..math.random(1,6)..'.mdl',
        'models/player/group03/male_0'..math.random(1,9)..'.mdl',
        'models/player/group03m/female_0'..math.random(1,6)..'.mdl',
        'models/player/group03m/male_0'..math.random(1,9)..'.mdl',
        "models/player/zombie_soldier.mdl",
        "models/player/p2_chell.mdl",
        "models/player/mossman.mdl",
        "models/player/mossman_arctic.mdl",
        "models/player/magnusson.mdl",
        "models/player/monk.mdl",
        "models/player/zombie_fast.mdl"
    }

    add = ""
    if GetConVar("zetaplayer_enableblockmodels"):GetBool() then
        add = " with Playermodel Blocking modifications"
        local json = file.Read("zetaplayerdata/blockedplayermodels.json","DATA")
        local blockedmdls = util.JSONToTable(json)
        if #blockedmdls > 0 then
            for k,v in ipairs(blockedmdls) do
                if !util.IsValidModel(v) then continue end

                local key = table.KeyFromValue( _SERVERDEFAULTMDLS, v )
                
                table.remove(_SERVERDEFAULTMDLS,key)
            end
        end
    end

    print("SERVER Default Playermodels Updated"..add)

    PrintMessage(HUD_PRINTTALK,"\nFinished updating SERVER CACHE!")
    caller:EmitSound("buttons/combine_button"..math.random(1,3)..".wav")
    
end

function CleanupAllZetas(caller)
    if caller:IsPlayer() and !caller:IsAdmin() then 
            net.Start('zeta_notifycleanup',true)
            net.WriteString('Only Admins can Clean Up Zetas!')
            net.WriteBool(true)
            net.Send(caller)
         return 
        end
        if caller:IsPlayer() then
            net.Start('zeta_notifycleanup',true)
            net.WriteString('Cleaned Up All Zetas!')
            net.WriteBool(false)
            net.Send(caller)
        end
    local entities = ents.FindByClass('npc_zetaplayer')

    for k,v in ipairs(entities) do
        if v:IsValid() then
            v:Remove()
        end
    end

    entities = ents.FindByClass('zeta_zetaplayerspawner')

    for k,v in ipairs(entities) do
        if v:IsValid() then
            v:Remove()
        end
    end

end

function CreateServerJunk()
    local jsonfile = file.Read('zetaplayerdata/props.json','DATA')
    local decoded = util.JSONToTable(jsonfile)
    local count = GetConVar("zetaplayer_serverjunkcount"):GetInt()
    local function GetOverWaterNav()
        local areas = navmesh.GetAllNavAreas()
        local found = {}
        for k,v in ipairs(areas) do
            if IsValid(v) and !v:IsUnderwater() and v:GetSizeX() >= 70 and v:GetSizeY() >= 70 then
                table.insert(found,v)
            end
        end
        return found
    end
    
    local areas = GetOverWaterNav()
    local currentcount = 0
    
    if istable(areas) then

        for i=1, count do
            if currentcount >= count then break end
            local mdl = decoded[math.random(#decoded)]

            local area = areas[math.random(#areas)]
    
            if IsValid(area) then
                local prop = ents.Create("prop_physics")
                prop:SetModel(mdl)
                local mins = prop:OBBMins()
                prop:SetPos(area:GetRandomPoint() - prop:GetUp() * mins.z)
                prop:SetAngles(Angle(0,math.random(-180,180),0))
                prop.IsZetaProp = true 
                prop:Spawn()
                local phys = prop:GetPhysicsObject()
                if IsValid(phys) then
                    phys:EnableMotion(!GetConVar("zetaplayer_freezeserverjunk"):GetBool())
                end
                currentcount = currentcount + 1
            end
        end
            
            

    end

end

function testzetastate(caller)
    local tra = caller:GetEyeTrace()
    local zeta = tra.Entity
    print("--------- Zeta Debug ---------")
    print("Zeta State = ",zeta.State)
    print("Last State = ",zeta.LastState)
    print("Zeta Weapon = ",zeta.Weapon)
    print("Zeta Enemy = ",zeta.Enemy)
    print("Vehicle = ",zeta.Vehicle)
    print("Personality = ",zeta.Personality)
    print("Is Natural = ",zeta.IsNatural)
    print("------------------")

end

function PrecacheAllPlayermodels()

    for k,v in pairs(player_manager.AllValidModels()) do
        
        util.PrecacheModel(v)
    end
end



function TeleportRNDZeta(caller)
    local entities = ents.GetAll()
   
    for k,v in RandomPairs(entities) do
        if v:GetClass() == 'npc_zetaplayer' and IsValid(v) then
            caller:SetPos(v:GetPos()+Vector(math.random(-100,100),math.random(-100,100),0))
            caller:EmitSound('zetaplayer/misc/spawn_zeta.wav',60)
            break
        end
    end
end

function TeleportFriendZeta(caller)
    local entities = ents.GetAll()
   
    for k,v in RandomPairs(entities) do
        if v:GetClass() == 'npc_zetaplayer' and IsValid(v) and caller:GetNW2Entity('zeta_friend',NULL) == v then
            caller:SetPos(v:GetPos()+Vector(math.random(-100,100),math.random(-100,100),0))
            caller:EmitSound('zetaplayer/misc/spawn_zeta.wav',60)
            break
        end
    end
end

function TeleportFriendZetaToCaller(caller)
    local entities = ents.GetAll()
   
    for k,v in RandomPairs(entities) do
        if v:GetClass() == 'npc_zetaplayer' and IsValid(v) and caller:GetNW2Entity('zeta_friend',NULL) == v then
            v:SetPos(caller:GetPos()+Vector(math.random(-100,100),math.random(-100,100),0))
            v:EmitSound('zetaplayer/misc/spawn_zeta.wav',60)
            break
        end
    end
end

function PanicZetasAroundPlayer(caller)

    local distance = GetConVar('zetaplayer_forceradius'):GetInt() or 700

    for k,v in ipairs(ents.FindInSphere(caller:GetPos(), distance)) do
        if v.IsZetaPlayer then
            v:Panic(caller)
        end
    end
end

function PrintDebugOn(ent)
    print("--------- Zeta Debug ---------")
    print("Zeta Name = ",ent.zetaname,"\n")
    print("Ent Index = ",ent:EntIndex(),"\n")
    print("Zeta Weapon ENT = ",ent.WeaponENT,"\n")
    print("Profile Picture = ",ent.ProfilePicture,"\n")
    if ent.HasProperAttachment then
        print("This Zeta has proper attachments for their hand","\n")
    else
        print("This Zeta does not have the proper attachments for their hand. Currently using the fall backs","\n")
    end

    print("Conversation Partner = ",ent.ConversePartner,"\n")

    print("Zeta State = ",ent.State,"\n")

    print("Last State = ",ent.LastState,"\n")

    print("Zeta Weapon = ",ent.Weapon,"\n")

    print("Zeta Enemy = ",ent.Enemy,"\n")

    print("Friend List -- --\n")
    for _,v in pairs(ent.Friends) do
        
        print((v.IsZetaPlayer and v.zetaname or v:GetName())," Their Creation ID is "..v:GetCreationID())
    end
    print("\nEnd friend List -- --\n")

    print("Vehicle = ",ent.Vehicle,"\n")

    print("Personality = ",ent.Personality,"\n")

    print("Voice Pack = ",(ent.VoicePack != "none" and ent.VoicePack or "None"),"\n")

    print("Is Natural = ",ent.IsNatural,"\n")

    print(ent.zetaTeam != "SELF" and "This zeta is a member of, "..ent.zetaTeam.."\n" or "This Zeta is not in any team\n")

    print("Is Speaking = ",ent.IsSpeaking,"\n")

    print("Can Speak = ",ent.AllowVoice,"\n")
    
    print("DATA METHOD\n",ent.UsingSERVERCACHE and "This Zeta is using the SERVER Cache for its data\n" or "This Zeta is using its own data")

    print("\n\n--- Zeta State Trace backs ---\n\n")

    PrintTable(ent.LastStateTraces)
    
    print("------------------")
end

function PanicZetasInView(caller)

    local distance = GetConVar('zetaplayer_forceradius'):GetInt() or 700

    for k,v in ipairs(ents.FindInSphere(caller:GetPos(), distance)) do
        local cansee = util.TraceLine({
            start = caller:GetPos()+caller:OBBCenter(),
            endpos = v:GetPos()+v:OBBCenter(),
            filter = caller
        })
        if v.IsZetaPlayer and cansee.Entity == v then
            v:Panic(caller)
        end
    end
end

function ZetasLaughInView(caller)

    local distance = GetConVar('zetaplayer_forceradius'):GetInt() or 700

    for k,v in ipairs(ents.FindInSphere(caller:GetPos(), distance)) do
        local cansee = util.TraceLine({
            start = caller:GetPos()+caller:OBBCenter(),
            endpos = v:GetPos()+v:OBBCenter(),
            filter = caller
        })
        if v.IsZetaPlayer and cansee.Entity == v then
            v:LaughAt(caller)
        end
    end
end

function ZetasTargetPlayer(caller)

    local distance = GetConVar('zetaplayer_forceradius'):GetInt() or 700

    for k,v in ipairs(ents.FindInSphere(caller:GetPos(), distance)) do
        if v.IsZetaPlayer then
            v:SetEnemy(caller)
            v:AttackEnemy(caller)
        end
    end
end

--[[ function ZetasForceFindTable(caller)

    local distance = GetConVar('zetaplayer_forceradius'):GetInt() or 700

    for k,v in ipairs(ents.FindInSphere(caller:GetPos(), distance)) do
        if v.IsZetaPlayer and !v.PlayingPoker then
            v.RunThreadFunction = v.FindGPokerTable
            v:ResetState()
        end
    end
end ]]

function ZetasDiesAroundPlayer(caller)

    local distance = GetConVar('zetaplayer_forceradius'):GetInt() or 700

    for k,v in ipairs(ents.FindInSphere(caller:GetPos(), distance)) do
        if v.IsZetaPlayer then
            local dmginfo = DamageInfo()
            dmginfo:SetDamage(40)
            dmginfo:SetDamageForce(v.IsMoving and v:GetForward()*2000 or v:GetForward()*500)
            dmginfo:SetAttacker(v)
            dmginfo:SetInflictor(v)
            v:OnKilled(dmginfo)
        end
    end
end


function _ZetaTweakNavmesh()
    local areas = navmesh.GetAllNavAreas()
    for k,v in ipairs(areas) do
        local adjareas = v:GetAdjacentAreas()
        for i,l in ipairs(adjareas) do
            if v:ComputeAdjacentConnectionHeightChange(l) > 30 then 
                v:Disconnect(l)
            end
        end
    end
    PrintMessage(HUD_PRINTTALK,"Nav Mesh has been Edited to suit the Zetas!")
end

function _ZetaSavenavmesh()
    navmesh.Save()
    PrintMessage(HUD_PRINTTALK,"Nav Mesh has been saved!")
end


local funnyfailsnds = {
    "vo/k_lab/ba_whatthehell.wav",
    "vo/k_lab/ba_thingaway02.wav",
    "vo/k_lab/ba_pushinit.wav",
    "vo/k_lab/ba_pissinmeoff.wav",
    "vo/k_lab/ba_getitoff02.wav",
    "vo/k_lab/kl_whatisit.wav",
    "vo/k_lab/kl_ohdear.wav",
    "vo/k_lab/kl_interference.wav",
    "vo/k_lab/kl_fiddlesticks.wav",
    "vo/npc/male01/whoops01.wav",
    "vo/npc/male01/gethellout.wav",
    "vo/npc/male01/hacks01.wav",
    "vo/npc/male01/hacks02.wav",
    "vo/npc/male01/thehacks01.wav",
    "vo/npc/male01/thehacks02.wav",
    "vo/citadel/br_ohshit.wav",
    "vo/citadel/br_no.wav",
    "vo/npc/male01/question30.wav",
    "zetaplayer/vo/idle/idle74.wav",
    "zetaplayer/vo/idle/idle445.wav",
    "zetaplayer/vo/idle/idle481.wav",
    "zetaplayer/vo/idle/idle522.wav",
    "zetaplayer/vo/idle/idle532.wav",
    "zetaplayer/vo/idle/idle592.wav",
    "zetaplayer/vo/death/atlternatedeath4.wav",
    "zetaplayer/vo/death/atlternatedeath26.wav",
    "zetaplayer/vo/death/atlternatedeath27.wav",
    "zetaplayer/vo/death/atlternatedeath39.wav",
    "zetaplayer/vo/death/atlternatedeath40.wav",
    "zetaplayer/vo/death/atlternatedeath43.wav",
    "zetaplayer/vo/death/atlternatedeath44.wav",
    "zetaplayer/vo/death/atlternatedeath45.wav",
    "zetaplayer/vo/death/atlternatedeath46.wav",
    "zetaplayer/vo/death/atlternatedeath49.wav",
    "zetaplayer/vo/death/atlternatedeath50.wav",
    "zetaplayer/vo/laugh6.wav",
    "zetaplayer/vo/laugh22.wav",
    "zetaplayer/vo/laugh44.wav",
    "zetaplayer/vo/mediaremoved/mediaremove6.wav",
    "zetaplayer/vo/mediaremoved/mediaremove19.wav",
    "zetaplayer/vo/mediaremoved/mediaremove44.wav",
    "zetaplayer/vo/mediaremoved/mediaremove64.wav",
    "zetaplayer/vo/mediaremoved/mediaremove82.wav",
}

function ZetasForceFriendToPlayer(caller)

    local distance = GetConVar('zetaplayer_forceradius'):GetInt() or 700

    if !GetConVar("zetaplayer_allowfriendswithplayers"):GetBool() then
        caller:EmitSound(funnyfailsnds[math.random(#funnyfailsnds)], 65)
        caller:EmitSound("buttons/button8.wav",50)
        PrintMessage(HUD_PRINTTALK, "Force failed! Check console for solution!")
        print("Zeta Force Fail: Set zetaplayer_allowfriendswithplayers to 1")
        return 
    end

    for k,v in ipairs(ents.FindInSphere(caller:GetPos(), distance)) do
        if v.IsZetaPlayer then
            if IsValid(v) and v:CanBeFriendsWith(caller) then
                v:AddFriend(caller)
            end
        end
    end
end

