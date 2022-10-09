-----------------------------------------------
-- Auto Run
--- Some things that need to be auto ran
-----------------------------------------------

local util = util
local ents = ents
local net = net
local table = table
local ipairs = ipairs
local pairs = pairs
local math = math
local Vector = Vector 
local Color = Color 
local Material = Material
local color_white = color_white

local oldisvalid = IsValid

local function IsValid( ent )
    if oldisvalid( ent ) and ent.IsZetaPlayer then
        
        return !ent.IsDead 
    else
        return oldisvalid( ent )
    end
end


_ZetasInstalled = true
_ZetaWarnMultiplayer = true

_bannedzetas = {}


-- Now no one can screw up the file writing process
function ZetaFileWrite( filename, contents )

	local f = file.Open( filename, "wb", "DATA" )
	if ( !f ) then return end

	f:Write( contents )
	f:Close()

end



include("zeta/zetamusicbox_net.lua")
include("zeta/consolecommands.lua")
include("zeta/zetafilehandling.lua")
include("zeta/zeta-voting.lua")
include("zeta/koth_funcs.lua")
include("zeta/ctf_funcs.lua")
include("zeta/metafunctions.lua")
include("zeta/tdm_funcs.lua")



if ( SERVER ) then

    

    function _ztrace()
        return Entity(1):GetEyeTrace().Entity
    end


    util.AddNetworkString('zeta_notifycleanup')
    util.AddNetworkString('zeta_notifycleanup')
    util.AddNetworkString('zeta_playermodelcolor')
    util.AddNetworkString('zeta_voiceicon')
    util.AddNetworkString('zeta_addkillfeed')
    util.AddNetworkString('zeta_requestviewshot')
    util.AddNetworkString('zeta_joinmessage')
    util.AddNetworkString("zeta_disconnectmessage")
    util.AddNetworkString("zeta_voicepopup")
    util.AddNetworkString("zeta_removevoicepopup")
    util.AddNetworkString("zeta_playvoicesound")
    util.AddNetworkString("zeta_usesprayer")
    util.AddNetworkString("zeta_sendonscreenlog")
    util.AddNetworkString("zeta_sendcoloredtext")
    util.AddNetworkString("zeta_createcsragdoll")
    util.AddNetworkString("zeta_createc4decal")
    util.AddNetworkString("zeta_changevoicespeaker")
    util.AddNetworkString("zeta_sendvoiceicon")
    util.AddNetworkString("zeta_csragdollexplode")
    util.AddNetworkString("zeta_chatsend")
    util.AddNetworkString("zeta_achievement")
    util.AddNetworkString("zetaplayer_eyetap")
    util.AddNetworkString("zeta_realplayerendvoice")
    util.AddNetworkString("zeta_changegetplayername")
    util.AddNetworkString("zeta_flashbang_emitflash")
    util.AddNetworkString( "zetaweaponcreator_updateweapons" )


    -- Team panel

end

-- Precache the default models
util.PrecacheModel('models/player/alyx.mdl')
util.PrecacheModel('models/player/arctic.mdl')
util.PrecacheModel('models/player/barney.mdl')
util.PrecacheModel('models/player/breen.mdl')
util.PrecacheModel('models/player/charple.mdl')
util.PrecacheModel('models/player/combine_soldier.mdl')
util.PrecacheModel('models/player/combine_soldier_prisonguard.mdl')
util.PrecacheModel('models/player/combine_super_soldier.mdl')
util.PrecacheModel('models/player/corpse1.mdl')
util.PrecacheModel('models/player/dod_american.mdl')
util.PrecacheModel('models/player/dod_german.mdl')
util.PrecacheModel('models/player/eli.mdl')
util.PrecacheModel('models/player/gasmask.mdl')
util.PrecacheModel('models/player/gman_high.mdl')
util.PrecacheModel('models/player/guerilla.mdl')
util.PrecacheModel('models/player/kleiner.mdl')
util.PrecacheModel('models/player/leet.mdl')
util.PrecacheModel('models/player/odessa.mdl')
util.PrecacheModel('models/player/phoenix.mdl')
util.PrecacheModel('models/player/police.mdl')
util.PrecacheModel('models/player/riot.mdl')
util.PrecacheModel('models/player/skeleton.mdl')
util.PrecacheModel('models/player/soldier_stripped.mdl')
util.PrecacheModel('models/player/swat.mdl')
util.PrecacheModel('models/player/urban.mdl')
util.PrecacheModel('models/player/group01/female_01.mdl')
util.PrecacheModel('models/player/group01/female_02.mdl')
util.PrecacheModel('models/player/group01/female_03.mdl')
util.PrecacheModel('models/player/group01/female_04.mdl')
util.PrecacheModel('models/player/group01/female_05.mdl')
util.PrecacheModel('models/player/group01/female_06.mdl')
util.PrecacheModel('models/player/group01/male_01.mdl')
util.PrecacheModel('models/player/group01/male_02.mdl')
util.PrecacheModel('models/player/group01/male_03.mdl')
util.PrecacheModel('models/player/group01/male_04.mdl')
util.PrecacheModel('models/player/group01/male_05.mdl')
util.PrecacheModel('models/player/group01/male_06.mdl')
util.PrecacheModel('models/player/group01/male_07.mdl')
util.PrecacheModel('models/player/group01/male_08.mdl')
util.PrecacheModel('models/player/group01/male_09.mdl')
util.PrecacheModel('models/player/group02/male_02.mdl')
util.PrecacheModel('models/player/group02/male_04.mdl')
util.PrecacheModel('models/player/group02/male_06.mdl')
util.PrecacheModel('models/player/group02/male_08.mdl')
util.PrecacheModel('models/player/group03/female_01.mdl')
util.PrecacheModel('models/player/group03/female_02.mdl')
util.PrecacheModel('models/player/group03/female_03.mdl')
util.PrecacheModel('models/player/group03/female_04.mdl')
util.PrecacheModel('models/player/group03/female_05.mdl')
util.PrecacheModel('models/player/group03/female_06.mdl')
util.PrecacheModel('models/player/group03/male_01.mdl')
util.PrecacheModel('models/player/group03/male_02.mdl')
util.PrecacheModel('models/player/group03/male_03.mdl')
util.PrecacheModel('models/player/group03/male_04.mdl')
util.PrecacheModel('models/player/group03/male_05.mdl')
util.PrecacheModel('models/player/group03/male_06.mdl')
util.PrecacheModel('models/player/group03/male_07.mdl')
util.PrecacheModel('models/player/group03/male_08.mdl')
util.PrecacheModel('models/player/group03/male_09.mdl')
util.PrecacheModel('models/player/group03m/female_01.mdl')
util.PrecacheModel('models/player/group03m/female_02.mdl')
util.PrecacheModel('models/player/group03m/female_03.mdl')
util.PrecacheModel('models/player/group03m/female_04.mdl')
util.PrecacheModel('models/player/group03m/female_05.mdl')
util.PrecacheModel('models/player/group03m/female_06.mdl')
util.PrecacheModel('models/player/group03m/male_01.mdl')
util.PrecacheModel('models/player/group03m/male_02.mdl')
util.PrecacheModel('models/player/group03m/male_03.mdl')
util.PrecacheModel('models/player/group03m/male_04.mdl')
util.PrecacheModel('models/player/group03m/male_05.mdl')
util.PrecacheModel('models/player/group03m/male_06.mdl')
util.PrecacheModel('models/player/group03m/male_07.mdl')
util.PrecacheModel('models/player/group03m/male_08.mdl')
util.PrecacheModel('models/player/group03m/male_09.mdl')
util.PrecacheModel("models/player/zombie_soldier.mdl")
util.PrecacheModel("models/player/p2_chell.mdl")
util.PrecacheModel("models/player/mossman.mdl")
util.PrecacheModel("models/player/mossman_arctic.mdl")
util.PrecacheModel("models/player/magnusson.mdl")
util.PrecacheModel("models/player/monk.mdl")
util.PrecacheModel("models/player/zombie_fast.mdl")



function _ZetaApplyPreset( convardata )

    for k, v in pairs( convardata ) do
        
        local result = pcall( function() GetConVar( k ):SetString( v ) end )

    end

end


if ( SERVER ) then

    net.Receive("zeta_realplayerendvoice",function(len,ply)
        hook.Run("ZetaRealPlayerEndVoice",ply)
    end)
    
    net.Receive( "zetapanel_setpresetsserverside", function( len, ply )
        if !ply:IsSuperAdmin() then return end

        local bytes = net.ReadUInt( 32 )
        local data = net.ReadData( bytes )

        data = util.Decompress( data )
        data = util.JSONToTable( data )
        
        _ZetaApplyPreset( data )
    
    end )

    net.Receive('zeta_csragdollexplode', function()
        local blastSrc = net.ReadVector()
        util.BlastDamage(Entity(0), Entity(0), blastSrc, 250, math.random(1,500))
    end)

    net.Receive('zeta_sendvoiceicon', function()
        local zeta = net.ReadEntity()
        local dur = net.ReadFloat()
    
        net.Start('zeta_voiceicon', true)
            net.WriteEntity(zeta)
            net.WriteFloat(dur)
        net.Broadcast()
    end)


    net.Receive('zetapanel_getnames',function(len,ply)
        local json = file.Read("zetaplayerdata/names.json","DATA")
        local tbl = util.JSONToTable(json)
        for k,name in ipairs(tbl) do
            local isdone = false
            if k == #tbl then
                isdone = true
            end
            net.Start("zetapanel_sendnames")
            net.WriteString(name)
            net.WriteBool(isdone)
            net.Send(ply)
        end
    end)

    net.Receive('zetapanel_resetnames',function(len,ply)
        ResetNamestoDefault(ply)
    end)

    net.Receive('zetapanel_removename',function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to remove names!') return end
        local _string = net.ReadString()
        
            local json = file.Read("zetaplayerdata/names.json","DATA")
            local decoded = util.JSONToTable(json)
            if !table.HasValue(decoded,_string) then ply:PrintMessage(HUD_PRINTCONSOLE,_string.." is not Registered!") return end
            table.RemoveByValue(decoded,_string)
            local encoded = util.TableToJSON(decoded,true)
            ZetaFileWrite("zetaplayerdata/names.json",encoded)
            ply:PrintMessage(HUD_PRINTCONSOLE,"Removed ".._string.." from Zeta's names")
    end)

    net.Receive('zetapanel_addname',function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to register names!') return end
        local _string = net.ReadString()


            local json = file.Read("zetaplayerdata/names.json","DATA")
            local decoded = util.JSONToTable(json)
            if table.HasValue(decoded,_string) then
                 ply:PrintMessage(HUD_PRINTCONSOLE,_string.." is already registered!")
                 net.Start('zeta_notifycleanup',true)
                 net.WriteString(_string..' is already registered!')
                 net.WriteBool(true)
                 net.Send(ply)
                  return
                 end
            table.insert(decoded,_string)
            local encoded = util.TableToJSON(decoded,true)
            ZetaFileWrite("zetaplayerdata/names.json",encoded)
            ply:PrintMessage(HUD_PRINTCONSOLE,"Added ".._string.." To Zeta's names")

            net.Start('zeta_notifycleanup',true)
            net.WriteString("Added ".._string.." To Zeta's names")
            net.WriteBool(false)
            net.Send(ply)
    end)


    net.Receive('zetapanel_resetteams',function(len,ply)
        ResetTeamstoDefault(ply)
    end)


    





    hook.Add("PlayerSpawnedProp","zeta_SetPropCreator",function(ply,mdl,prop)
        timer.Simple(0,function()
            if IsValid(prop) then
                prop:SetCreator(ply)
            end
        end)
    end)

    hook.Add("PlayerSpawnedVehicle","zeta_SetVehicleCreator",function(ply,vehicle)
        timer.Simple(0,function()
            if IsValid(vehicle) then
                vehicle:SetCreator(ply)
            end
        end)
    end)

    hook.Add("PlayerSpawnedRagdoll","zeta_SetRagdollCreator",function(ply,mdl,ragdoll)
        timer.Simple(0,function()
            if IsValid(ragdoll) then
                ragdoll:SetCreator(ply)
            end
        end)
    end)

    hook.Add("PlayerSpawnedEffect","zeta_SetEffectCreator",function(ply,mdl,effect)
        timer.Simple(0,function()
            if IsValid(effect) then
                effect:SetCreator(ply)
            end
        end)
    end)

    hook.Add("PlayerSpawnedSWEP","zeta_SetSwepCreator",function(ply,swep)
        timer.Simple(0,function()
            if IsValid(swep) then
                swep:SetCreator(ply)
            end
        end)
    end)
    
    
    
    hook.Add('PlayerSpawnedNPC','zetaSetCreator',function(ply,ent)
        timer.Simple(0, function()
            if IsValid(ent) and (ent:GetClass() == 'npc_zetaplayer') or IsValid(ent) and ent:GetClass() == "zeta_zetaplayerspawner" then
                ent:SetCreator(ply)
            end
        end)
    end)

    hook.Add("PostEntityPaste","zetaSetDupeCreator",function(ply,ent,tbl)
        for k,v in ipairs(tbl) do
            v:SetCreator(ply)
        end
    end)

    hook.Add("OnEntityCreated","zeta_Createmedkittimers",function(ent)
        timer.Simple(0, function()
            if IsValid(ent) then
                if ent:GetClass() == "item_healthkit" or ent:GetClass() == "item_healthvial" or ent:GetClass() == "sent_ball" or ent:GetClass() == "item_battery" then
                    ent.ZetaSpawnTimer = CurTime()+1
                end
            end
        end)
    
    end)



    hook.Add("PlayerSpawnedSENT","zeta_setmedkitcreators",function(ply,ent)
        timer.Simple(0,function()
            if IsValid(ent) then
                if ent:GetClass() == "item_healthkit" or ent:GetClass() == "item_healthvial" or ent:GetClass() == "sent_ball" or ent:GetClass() == "item_battery" then
                    ent:SetCreator(ply)
                end
            end
        end)
    end)

    hook.Add("PlayerInitialSpawn","zetaSpawnProps",function(ply)
        if GetConVar("zetaplayer_serverjunk"):GetInt() == 0 then return end
        if !game.SinglePlayer() then return end
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


    
    end)






    local hitScales = {
        [HITGROUP_HEAD] = GetConVar('sk_player_head'),
        [HITGROUP_LEFTARM] = GetConVar('sk_player_arm'),
        [HITGROUP_RIGHTARM] = GetConVar('sk_player_arm'),
        [HITGROUP_CHEST] = GetConVar('sk_player_chest'),
        [HITGROUP_STOMACH] = GetConVar('sk_player_stomach'),
        [HITGROUP_LEFTLEG] = GetConVar('sk_player_leg'),
        [HITGROUP_RIGHTARM] = GetConVar('sk_player_leg')
    }
    local boneHitgroups = {
        ["ValveBiped.Bip01_Head1"] = HITGROUP_HEAD,
        ["ValveBiped.Bip01_Neck1"] = HITGROUP_HEAD,
    
        ["ValveBiped.Bip01_L_Clavicle"] = HITGROUP_CHEST,
        ["ValveBiped.Bip01_R_Clavicle"] = HITGROUP_CHEST,
        ["ValveBiped.Bip01_Spine4"] = HITGROUP_CHEST,
        ["ValveBiped.Bip01_Spine2"] = HITGROUP_CHEST,
    
        ["ValveBiped.Bip01_Spine1"] = HITGROUP_STOMACH,
        ["ValveBiped.Bip01_Spine"] = HITGROUP_STOMACH,
        ["ValveBiped.Bip01_Pelvis"] = HITGROUP_STOMACH,
    
        ["ValveBiped.Bip01_L_UpperArm"] = HITGROUP_LEFTARM,
        ["ValveBiped.Bip01_L_Forearm"] = HITGROUP_LEFTARM,
        ["ValveBiped.Bip01_L_Hand"] = HITGROUP_LEFTARM,
    
        ["ValveBiped.Bip01_R_UpperArm"] = HITGROUP_RIGHTARM,
        ["ValveBiped.Bip01_R_Forearm"] = HITGROUP_RIGHTARM,
        ["ValveBiped.Bip01_R_Hand"] = HITGROUP_RIGHTARM,
    
        ["ValveBiped.Bip01_L_Thigh"] = HITGROUP_LEFTLEG,
        ["ValveBiped.Bip01_L_Calf"] = HITGROUP_LEFTLEG,
        ["ValveBiped.Bip01_L_Foot"] = HITGROUP_LEFTLEG,
        ["ValveBiped.Bip01_L_Toe0"] = HITGROUP_LEFTLEG,
    
        ["ValveBiped.Bip01_R_Thigh"] = HITGROUP_RIGHTLEG,
        ["ValveBiped.Bip01_R_Calf"] = HITGROUP_RIGHTLEG,
        ["ValveBiped.Bip01_R_Foot"] = HITGROUP_RIGHTLEG,
        ["ValveBiped.Bip01_R_Toe0"] = HITGROUP_RIGHTLEG
    }
    
    hook.Add('ScaleNPCDamage', 'zetaScaleDamage', function(ent,hit,dmginfo)
        if !ent.IsZetaPlayer then return end
        
        -- Workaround for playermodels with no hitboxes
        local hasHitBoxes = !(hit == 0 and dmginfo:IsBulletDamage())
        if !hasHitBoxes then
            local closestBone = {nil, math.huge}
            for i = 0, ent:GetBoneCount() - 1 do
                local boneName = ent:GetBoneName(i)
                if !boneHitgroups[boneName] then continue end
                local dist = dmginfo:GetDamagePosition():DistToSqr(ent:GetBonePosition(i))
                if dist < closestBone[2] then
                    closestBone = {boneName, dist}
                end
            end
    
            hit = (boneHitgroups[closestBone[1]] or HITGROUP_GENERIC)
        end
    
        if GetConVar('zetaplayer_userealplayerdmgscale'):GetBool() then
            if hasHitBoxes then
                if hit == HITGROUP_HEAD then
                    dmginfo:ScaleDamage(0.5)
                elseif hit == HITGROUP_LEFTARM or hit == HITGROUP_RIGHTARM or hit == HITGROUP_LEFTLEG or hit == HITGROUP_RIGHTLEG then
                    dmginfo:ScaleDamage(4)
                end
            end
            dmginfo:ScaleDamage((hitScales[hit] and hitScales[hit]:GetFloat() or 1.0))
        else
            if hit == HITGROUP_HEAD then
                dmginfo:ScaleDamage(hasHitBoxes and 2 or 4)
            elseif !hasHitBoxes and (hit == HITGROUP_LEFTARM or hit == HITGROUP_RIGHTARM or hit == HITGROUP_LEFTLEG or hit == HITGROUP_RIGHTLEG) then
                dmginfo:ScaleDamage(0.25)
            end
        end
    end)



    
    --Mws used to be here 
    -- It was moved to a new lua file cause that's more organized
    -- mapwidespawning.lua


    function FindZetaByName(name)
        if !name then return end
        local zetas = ents.FindByClass("npc_zetaplayer")
        local foundzeta
        name = string.lower(name)

        for i=1,#zetas do
            if !IsValid(zetas[i]) then continue end
            local find,b,c = string.find(string.lower(zetas[i].zetaname),name)
            if isnumber(find) then
                foundzeta = zetas[i]
                break
            end
        end

        return foundzeta
    end


    function ZetaGetPermanentFriends()
        local json = file.Read("zetaplayerdata/profiles.json")
        local friends = {}
        if json then
            
            local profiles = util.JSONToTable(json)

            for k,v in pairs(profiles) do
                if v.permafriend then
                    friends[#friends+1] = k
                end
            end
        end
        return friends
    end


    function _ZetaCheckCurrentDate()


        _ZetaSpecificDay = "None"
        local month = os.date("%B")
        local weekday = tonumber(os.date("%d"))
      
      
        local split
        local birthdaytxt = file.Read("zetaplayerdata/player_birthday.txt","DATA")
        
        if birthdaytxt then
          split = string.Explode(" ",birthdaytxt)
        end
        
         
        if birthdaytxt and split[1] and split[1] == month and split[2] and tonumber(split[2]) == weekday then
          _ZetaSpecificDay = "birthday"
          return
        elseif month == "July" and weekday == 4 then
          _ZetaSpecificDay = "4thjuly"
        elseif month == "November" and weekday == 24 then
          _ZetaSpecificDay = "thanksgiving"
        elseif month == "December" and weekday == 25 then
          _ZetaSpecificDay = "christmas"
        elseif month == "January" and weekday == 1 then
          _ZetaSpecificDay = "newyear"
        elseif month == "April" and weekday == 9 then
          _ZetaSpecificDay = "easter"
        elseif month == "April" and weekday == 7 then
          _ZetaSpecificDay = "addoncreatorbirthday"
        elseif month == "May" and weekday == 29 then
          _ZetaSpecificDay = "addoncreationday"
        end 
        
      end



    function ZetaCheckForMissingFiles( ply )

        print( "--- Profile Validator ---\n\n" )

        local hasproblem = false
        

        local profiles = file.Read( "zetaplayerdata/profiles.json" )

        if profiles then

            profiles = util.JSONToTable( profiles )
            
            for k, prf in pairs( profiles ) do
                
                if prf[ "playermodel" ] then
                    
                    local mdlexists = file.Exists( prf[ "playermodel" ], "GAME" )

                    

                    if !mdlexists then

                        hasproblem = true
                        
                        print( " Profile Validator Warning: " .. k .. " has a non existent model! (" .. prf[ "playermodel" ] .. ")" )

                    end

                end

                if prf[ "weapon" ] then
                    
                    if !_ZetaWeaponDataTable[ prf[ "weapon" ] ] then

                        hasproblem = true
                        
                        print( " Profile Validator Warning: " .. k .. " has a non existent weapon! (" .. prf[ "weapon" ] .. ")" )

                    end

                end

                if prf[ "favouriteweapon" ] then
                    
                    if !_ZetaWeaponDataTable[ prf[ "favouriteweapon" ] ] then

                        hasproblem = true
                        
                        print( " Profile Validator Warning: " .. k .. " has a non existent favorite weapon! (" .. prf[ "favouriteweapon" ] .. ")" )

                    end

                end

                if prf[ "voicepack" ] then

                    local addon = prf[ "voicepack" ].."/"

                    local exists = file.Exists( "sourceengine/sound/zetaplayer/custom_vo/"..addon.."idle", "BASE_PATH" ) or file.Exists( "sound/zetaplayer/custom_vo/"..addon.."idle", "GAME" )
                    
                    

                    if !exists then

                        hasproblem = true

                        print( " Profile Validator Warning: " .. k .. " has a non existent Voice Pack! (" .. prf[ "voicepack" ] .. ")" )
                        
                    end

                end

            end

            

        end

        print( "Profile Validation Done" )


        print( "\n\n--- Weapon Validator ---\n\n" )

        local weapondata = file.Read( "zetaplayerdata/weapondata.dat" )

        if weapondata then
            
            weapondata = util.Decompress( weapondata )
            weapondata = util.JSONToTable( weapondata )

            for weaponname, data in pairs( weapondata ) do
                
                if !file.Exists( data.mdl, "GAME" ) then
                    
                    hasproblem = true

                    print( "Custom Weapon Validator Warning: Custom Weapon " .. k .. " ".. "{" .. data.prettyPrint.. "}" .. " has a error model! (" .. data.mdl .. ")" )

                end

            end


        end

        print( "Weapon Validation Done" )



        print( "\n\n--- Data Files Validator ---\n\n" )

        local textdataok = pcall( function() util.JSONToTable(file.Read("zetaplayerdata/textchatdata.json","DATA")) end )

        if !textdataok then
            hasproblem = true

            print( "Data File Validator Warning: Text Chat Data failed to open/validate! Consider using console command zetaplayer_resettextdata to reset it" )
        end

        local mediadataok = pcall( function() util.JSONToTable(file.Read("zetaplayerdata/mediaplayerdata.json","DATA")) end )

        if !mediadataok then
            hasproblem = true

            print( "Data File Validator Warning: Media Data failed to open/validate! Consider using console command zetaplayer_reseturllist to reset it" )
        end
    
        local matsok = pcall( function() util.JSONToTable(file.Read('zetaplayerdata/materials.json','DATA')) end )

        if !matsok then
            hasproblem = true

            print( "Data File Validator Warning: Material Data failed to open/validate! Consider using console command zetaplayer_resetmateraillist to reset it" )
        end
    
        local propsok = pcall( function() util.JSONToTable(file.Read('zetaplayerdata/props.json','DATA')) end )

        if !propsok then
            hasproblem = true

            print( "Data File Validator Warning: Prop Data failed to open/validate! Consider using console command zetaplayer_resetproplist to reset it" )
        end
    
        local npcsok = pcall( function() util.JSONToTable(file.Read('zetaplayerdata/npcs.json','DATA')) end )

        if !npcsok then
            hasproblem = true

            print( "Data File Validator Warning: NPC Data failed to open/validate! Consider using console command zetaplayer_resetnpclist to reset it" )
        end
    
        local entsok = pcall( function() util.JSONToTable(file.Read('zetaplayerdata/ents.json','DATA')) end )

        if !entsok then
            hasproblem = true

            print( "Data File Validator Warning: Entity Data failed to open/validate! Consider using console command zetaplayer_resetentitylist to reset it" )
        end
    
        local namesok = pcall( function() util.JSONToTable(file.Read('zetaplayerdata/names.json','DATA')) end )

        if !namesok then
            hasproblem = true

            print( "Data File Validator Warning: Name Data failed to open/validate! Consider using console command zetaplayer_resetnamelist to reset it" )
        end
    
        local zetastatsok = pcall( function() util.JSONToTable(file.Read("zetaplayerdata/zetastats.json")) end )

        if !zetastatsok then
            hasproblem = true

            print( "Data File Validator Warning: Zeta Stats failed to open/validate! Consider using console command zetaplayer_resetzetastats to reset it" )
        end


        print( "Data File Validation Done" )


        print( hasproblem and "\nValidation finished. One or more issues were found" or "\nValidation successful! No problems found" )

    end

    concommand.Add( "zetaplayer_validatefiles", ZetaCheckForMissingFiles )
    
    
    
    -- More Erma's contributes v v v v v v
    hook.Add('OnEntityCreated', 'zetaSpawnedEntitySupport',function(ent)
        if !IsValid(ent) then return end 
            timer.Simple(0,function()
            if !IsValid(ent) then return end

            local entClass = ent:GetClass()
            if entClass == 'npc_sanic' or (ent:IsNextBot() and isfunction(ent.AttackNearbyTargets)) then
                ent.ZetaHook_ClosestZeta = NULL

                local id = ent:GetCreationID()
                hook.Add('Think', 'zeta_sanicNextbotsSupport_'..id, function()
                    if !IsValid(ent) then hook.Remove('Think', 'zeta_sanicNextbotsSupport_'..id) return end
                    
                    local scanTime = GetConVar(entClass..'_expensive_scan_interval'):GetInt() or 1
                    if (CurTime() - ent.LastTargetSearch) > scanTime then
                        ent.ZetaHook_ClosestZeta = NULL
                        
                        local lastDist = math.huge
                        local chaseDist = GetConVar(entClass..'_acquire_distance'):GetInt() or 2500
                        local zetas = ents.FindByClass('npc_zetaplayer')
                        for i=1, #zetas do
                            if !zetas[i].IsZetaPlayer or zetas[i].IsDead then continue end
                            local distSqr = ent:GetRangeSquaredTo(zetas[i])
                            if distSqr <= (chaseDist*chaseDist) and distSqr < lastDist then
                                ent.ZetaHook_ClosestZeta = zetas[i]
                                lastDist = distSqr
                            end
                        end
                    end

                    local closestZeta = ent.ZetaHook_ClosestZeta
                    if !IsValid(closestZeta) then return end 
                    
                    local curTarget = ent.CurrentTarget
                    local zetaDist = ent:GetRangeSquaredTo(closestZeta)
                    
                    if ent.CurrentTarget != closestZeta then
                        if !IsValid(curTarget) or (ent:GetRangeSquaredTo(curTarget) > zetaDist and closestZeta != curTarget) then
                            ent.CurrentTarget = closestZeta
                        end
                    elseif !closestZeta.IsDead then
                        local dmgDist = GetConVar(entClass..'_attack_distance'):GetInt() or 80
                        if zetaDist > (dmgDist*dmgDist) then return end
                        
                        local startHP = closestZeta:Health()

                        local attackForce = GetConVar(entClass..'_attack_force'):GetInt() or 800
                        if isfunction(ent.AttackOpponent) then
                            ent:AttackOpponent(closestZeta, ent:GetPos(), attackForce)
                        else
                            local dmgInfo = DamageInfo()
                            dmgInfo:SetAttacker(ent)
                            dmgInfo:SetInflictor(ent)
                            dmgInfo:SetDamage(1e8)
                            dmgInfo:SetDamagePosition(ent:GetPos())
                            dmgInfo:SetDamageForce(((closestZeta:GetPos() - ent:GetPos()):GetNormal()*attackForce + ent:GetUp()*500)*100)
                            closestZeta:TakeDamageInfo(dmgInfo)

                            ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 350, 120)
                        end

                        if closestZeta:Health() < startHP then 
                            if ent.TauntSounds and (CurTime() - ent.LastTaunt) > 1.2 then
                                ent.LastTaunt = CurTime()
                                local snd = ent.TauntSounds[math.random(#ent.TauntSounds)]
                                if snd == nil then snd = ent.TauntSounds end
                                if isstring(snd) then
                                    ent:EmitSound(snd, 350, 100)
                                end
                            end

                            

                            ent.LastTargetSearch = 0
                        end
                    end
                end)
            end

            if GetConVar('zetaplayer_triggermines'):GetInt() != 1 or ent:GetClass() != 'combine_mine' then return end
            
            // Initialize mine's variables
            ent.MineHopTarget = ent.MineHopTarget or NULL
            ent.MineCurrentState = ent.MineCurrentState or 1
            ent.NextMineThinkTime = ent.NextMineThinkTime or CurTime() + 0.1
            
            // Add think hook
            hook.Add('Think', 'mineZetaTrigger'..ent:EntIndex(), function()
                if !IsValid(ent) then hook.Remove('Think', 'mineZetaTrigger'..ent:EntIndex()) return end
                
                // If mine is not placed by a real player and it's at default state, search for zetas
                if CurTime() > ent.NextMineThinkTime and ent:GetInternalVariable('m_bPlacedByPlayer') != true then
                    if ent.MineCurrentState == 1 then 
                        if ent:GetInternalVariable('m_iMineState') == 3 then
                            // Loop through all entities with 'npc_zetaplayer' classname
                            local zetas = ents.FindByClass('npc_zetaplayer')
                            for i=1, #zetas do
                                // If zeta is near my by 100 units and visible to me, trigger the mine
                                if zetas[i]:GetPos():Distance(ent:GetPos()) <= 100 and ent:Visible(zetas[i]) then
                                    // Increment mine's state value
                                    ent.MineCurrentState = ent.MineCurrentState + 1
        
                                    // Set mine's target
                                    ent.MineHopTarget = zetas[i]
                                    
                                    // Disarm mine so it won't get interrupted by another target
                                    ent:Input('Disarm')
        
                                    // Play trigger sound
                                    ent:EmitSound('npc/roller/blade_in.wav', 70)
        
                                    // Nudge
                                    local phys = ent:GetPhysicsObject()
                                    if phys:IsValid() then
                                        local vecNudge = Vector(math.Rand(-1, 1), math.Rand(-1, 1), 1.5) * 350
                                        phys:Wake()
                                        phys:ApplyForceCenter(vecNudge)
                                    end
        
                                    // Set mine's next think time to ConVar's value
                                    ent.NextMineThinkTime = CurTime() + GetConVar('zetaplayer_triggermines_hoptime'):GetFloat()
                                    return
                                end
                            end
                        end
                    elseif ent.MineCurrentState == 2 then
                        // Play hop sound
                        ent:EmitSound('npc/roller/mine/rmine_blip3.wav', 70)
        
                        // The next code is adapted from HL2 source code
                        local phys = ent:GetPhysicsObject()
                        if phys:IsValid() then
                            local maxJumpHeight = 200
        
                            // Figure out how much headroom the mine has, and hop to within a few inches of that.
                            local tr = util.TraceLine({
                                start = ent:GetPos(),
                                endpos = ent:GetPos() + Vector(0, 0, maxJumpHeight),
                                mask = MASK_SHOT,
                                filter = {ent},
                                collisiongroup = COLLISION_GROUP_INTERACTIVE
                            })
        
                            local height
                            if IsValid(tr.Entity) and IsValid(tr.Entity:GetPhysicsObject()) then
                                // Physics object resting on me. Jump as hard as allowed to try to knock it away.
                                height = maxJumpHeight
                            else
                                height = tr.HitPos.z - ent:GetPos().z
                                height = height - 24
                                if height < 0.1 then height = 0.1 end
                            end
        
                            local gravity = GetConVar('sv_gravity'):GetFloat()
                            local time = math.sqrt( height / (0.5 * gravity) )
                            local velocity = gravity * time
        
                            // or you can just AddVelocity to the object instead of ApplyForce
                            local force = velocity * phys:GetMass()
        
                            phys:Wake()
                            phys:ApplyForceCenter( ent:GetUp() * force )
        
                            local target = ent.MineHopTarget
                            if IsValid(target) and !target.IsDead then
                                local vecPredict = target.loco:GetVelocity()
                                phys:ApplyForceCenter( vecPredict * 10 )
                            end
                        end
        
                        // Increment mine's state value
                        ent.MineCurrentState = ent.MineCurrentState + 1
        
                        // If mine touches something, explode
                        ent:AddCallback('PhysicsCollide', function(ent, data)                                 
                            // Create explosion
                            local explode = ents.Create('env_explosion')
                            explode:SetPos(ent:GetPos())
                            explode:SetAngles(ent:GetAngles())
                            explode:SetOwner(ent)
                            explode:SetKeyValue('iMagnitude', 150.0)        // Damage
                            explode:SetKeyValue('iRadiusOverride', 125.0)   // Radius
                            explode:Spawn()
                            explode:Input('Explode')                        // And finally, explode the explosion
        
                            // Remove the mine
                            ent:Remove()
                        end)
        
                        hook.Remove('Think', 'mineZetaTrigger'..ent:EntIndex())
                        return
                    end
        
                    ent.NextMineThinkTime = CurTime() + 0.1
                end
            end)
        end)
    end)



    local props = {
        ["prop_physics"] = true,
        ["prop_physics_multiplayer"] = true,
        ["prop_ragdoll"] = true
    
    }

    hook.Add("OnNPCKilled","zetaaddkillfeed_npc",function(NPC,attacker,inflictor)
    
        if IsValid(attacker) and attacker.IsZetaPlayer then
            local data
            local teamname = ""
      
            if attacker.zetaTeam then
              teamname = " {"..attacker.zetaTeam.."}"
            end
            local killIcon = _ZetaWeaponKillIcons[attacker.Weapon]

              data = {
                attacker = attacker.zetaname..teamname,
                attackerteam = 0,
                inflictor = killIcon or " ",
                victim = "#"..NPC:GetClass(),
                victimteam = -1,
                prettyprint = IsValid(inflictor) and inflictor:GetClass() == "prop_physics" and "Physics Prop" or attacker.PrettyPrintWeapon
              }
            
      
      
            net.Start('zeta_addkillfeed',true)
            net.WriteString(util.TableToJSON(data))
            net.WriteBool(killIcon != nil)
            net.Broadcast()  
        end
    
    end)

    hook.Add("PlayerDeath","zetaddkillfeed_player",function(ply,inflict,attacker)

        if IsValid(attacker) and attacker.IsZetaPlayer then
            local data
            local teamname = ""
      
            if attacker.zetaTeam then
              teamname = " {"..attacker.zetaTeam.."}"
            end
            local killIcon = _ZetaWeaponKillIcons[attacker.Weapon]
              data = {
                attacker = attacker.zetaname..teamname,
                attackerteam = 0,
                inflictor = killIcon or " ",
                victim = ply:GetName(),
                victimteam = ply:Team(),
                prettyprint = IsValid(inflict) and inflict:GetClass() == "prop_physics" and "Physics Prop" or attacker.PrettyPrintWeapon
              }
      
      
            net.Start('zeta_addkillfeed',true)
            net.WriteString(util.TableToJSON(data))
            net.WriteBool(killIcon != nil)
            net.Broadcast()  
        end

    end)


    hook.Add("PostEntityTakeDamage","zetaADMIN_Rules_Dmg",function(victim,dmginfo)
        if !game.SinglePlayer() then return end
        
        if victim.IsZetaPlayer or victim:IsPlayer() then

            local nopropkill = GetConVar("zetaplayer_adminrule_nopropkill"):GetBool()
            local noRDM = GetConVar("zetaplayer_adminrule_rdm"):GetBool()
        
            local inflictor = dmginfo:GetInflictor()
            local attacker = dmginfo:GetAttacker()
            local IsvictimDead = victim:Health() <= 0 
            local propkilled
            if IsValid(inflictor) then
                propkilled = props[inflictor:GetClass()]
            else
                propkilled = false
            end

            

            if attacker:IsNPC() then return end
            if victim == attacker then return end

            if IsValid(attacker) and attacker:IsPlayer() and GetConVar("zetaplayer_admintreatowner"):GetInt() == 1 then return end
        
            
        
            if nopropkill and IsValid(inflictor) and propkilled then
                hook.Run("ZetaAdminRuleViolate",victim,attacker,inflictor,"propkill")
            end
            --print(noRDM,IsValid(attacker),!attacker:IsPlayer(),attacker:GetNW2Bool( 'zeta_aggressor', false ),IsvictimDead,propkilled)
            if noRDM and IsValid(attacker) and !attacker:IsPlayer() and attacker:GetNW2Bool( 'zeta_aggressor', false ) and math.random(1,2) == 1 and !propkilled then
                hook.Run("ZetaAdminRuleViolate",victim,attacker,inflictor,"rdm")

            end

            if noRDM and IsValid(attacker) and attacker:IsPlayer() and !victim:GetNW2Bool( 'zeta_aggressor', false ) and math.random(1,2) == 1 and !propkilled then
                hook.Run("ZetaAdminRuleViolate",victim,attacker,inflictor,"rdm")

            end

        end
    
        
    
        
    
    end)


    hook.Add("CanTool","zetaAdmin_PlayerToolgun",function(ply,tr)
        if GetConVar("zetaplayer_adminrule_griefing"):GetInt() == 0 then return end

        local ent = tr.Entity

        if IsValid(ent) and ent:GetCreator() != ply and math.random(1,6) == 1 then
            hook.Run("ZetaAdminRuleViolate",ply,ply,ply,"grief")
        end
        
    end)


    hook.Add("OnZetaUseToolgun","zetaAdmin_Toolgunenforcement",function(zeta,ent,tool) -- The Zeta that used the tool. The Entity the Zeta used it on. The Tool that was used
        if zeta.IsAdmin then return end
        if !IsValid(zeta) or !IsValid(ent) then return end
        if GetConVar("zetaplayer_adminrule_griefing"):GetInt() == 0 then return end
        local isowner = (zeta == ent:GetOwner())

        if !isowner and math.random(1,6) == 1 then
            hook.Run("ZetaAdminRuleViolate",zeta,zeta,zeta,"grief")
        end

    end)


    hook.Add("PhysgunPickup","ZetaAdmin_Preventphysgun",function(ply,ent)
        if ply.IsJailed then return false end
        if ent.isjailent then return false end
    end)

    hook.Add("CanPlayerSuicide","ZetaAdmin_Preventdeath",function(ply)
        if ply.IsJailed then return false end
    end)

    hook.Add("PlayerNoClip","ZetaAdmin_PreventNoclip",function(ply,state)
        if ply.IsJailed then return false end
    end)

    hook.Add("EntityTakeDamage","ZetaAdmin_PreventDamage",function(targ,dmginfo)
        if IsValid(targ) and targ:IsPlayer() and targ.IsJailed then return true end
        if IsValid(targ) and targ.IsZetaPlayer and targ.IsJailed then return true end
        if IsValid(targ) and targ.zetaIngodmode then return true end
        if IsValid(targ) and targ:IsPlayer() and !GetConVar("zetaplayer_enablefriendlyfire"):GetBool() and IsInTeam(dmginfo:GetAttacker()) then return true end
        if IsValid(targ) and IsValid(dmginfo:GetAttacker()) and dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker().IsJailed then return true end
    end)

    hook.Add("CanProperty","ZetaAdmin_PreventProperty",function(ply,proper,ent)
        if ent.isjailent then return false end
    end)

    hook.Add("CanTool","ZetaAdmin_PreventToolgun",function(ply,tr)
        if IsValid(tr.Entity) and tr.Entity.isjailent then return false end
    end)

    hook.Add("EntityRemoved","ZetaAdmin_JailRemove",function(ent)
        if ent.IsZetaPlayer and ent.IsJailed then
            RemoveJailOnEnt(ent)
        end
    end)


    hook.Add("PlayerSpawn","Zetaspawnatteamspawn",function(ply)
        if GetConVar("zetaplayer_spawnatteamspawns"):GetBool() then
            local teamspawns = ents.FindByClass("zeta_teamspawnpoint")
            if #teamspawns > 0 then
                local spawns = {}
                for i=1, #teamspawns do
                    if teamspawns[i]:GetTeamSpawn() == GetConVar("zetaplayer_playerteam"):GetString() then
                        spawns[#spawns+1] = teamspawns[i]
                    end
                end
                local spawn = spawns[math.random(#spawns)]
                if IsValid(spawn) then
                    ply:SetPos(spawn:GetPos())
                end
            end
        end
    end)

    function IsInTeam(ent)

        if ent:IsNextBot() and ent.IsZetaPlayer then
          if GetConVar('zetaplayer_playerteam'):GetString() != '' and  ent.zetaTeam == GetConVar('zetaplayer_playerteam'):GetString() then
            return true
          else
            return false
          end
        end
      
      
      end

    function RemoveJailOnEnt(ply)
        
        if ply.zetaJailEnts then
            for i=1, #ply.zetaJailEnts do
                if IsValid(ply.zetaJailEnts[i]) then
                    ply.zetaJailEnts[i]:Remove()
                end
            end

            ply.zetaJailEnts = nil
        end
    
    end
    
    function CreateJailOnEnt(ply)
        ply.zetaJailEnts = {}
        local mdl1 = Model( "models/props_building_details/Storefront_Template001a_Bars.mdl" )
    
        local jail = { -- ULX Jail
            { Vector( 0, 0, -5 ), Angle( 90, 0, 0 )},
            { Vector( 0, 0, 97 ), Angle( 90, 0, 0 )},
            { Vector( 21, 31, 46 ), Angle( 0, 90, 0 )},
            { Vector( 21, -31, 46 ), Angle( 0, 90, 0 )},
            { Vector( -21, 31, 46 ), Angle( 0, 90, 0 )},
            { Vector( -21, -31, 46), Angle( 0, 90, 0 )},
            { Vector( -52, 0, 46 ), Angle( 0, 0, 0 )},
            { Vector( 52, 0, 46 ), Angle( 0, 0, 0 )},
        }
    
    
        if ply:IsPlayer() then
            ply:SetMoveType(MOVETYPE_WALK)
        end
    
        for i=1, #jail do
            local ent = ents.Create( "prop_physics" )
            ent:SetModel( mdl1 )
            ent:SetPos( ply:GetPos() + jail[i][1] )
            ent:SetAngles( jail[i][2] )
            ent:Spawn()
            ent:GetPhysicsObject():EnableMotion( false )
            ent:SetMoveType( MOVETYPE_NONE )
            ent.isjailent = true
            table.insert( ply.zetaJailEnts, ent )
        end
    
    
    end




    function ZetaPlayer_ApplySpawnOverridedata(zeta,name,mdl,personal,pfp,voicepack,Zetateam,accuracy,physguncolor,playercolor)
        local BuildChance = personal.build or math.random(60)
        local CombatChance = personal.combat or math.random(10)
        local ToolChance = personal.tool or math.random(60)
        local PhysgunChance = personal.phys or math.random(60)
        local DisrespectChance = personal.disre or math.random(60)
        local WatchMediaPlayerChance = personal.media or math.random(60)
        local FriendlyChance = personal.friendly or math.random(60)
        local VoiceChance = personal.voice or math.random(60)
        local VehicleChance = personal.vehicle or math.random(60)
        local TextChance = personal.text or math.random(20)
        local Voicepitch = personal.voicepitch or 100
        local Strictness = personal.strictness 

        local overridedata = {
            personality = {
                build = BuildChance,
                combat = CombatChance,
                tool = ToolChance,
                phys = PhysgunChance,
                disre = DisrespectChance,
                media = WatchMediaPlayerChance,
                friendly = FriendlyChance,
                voice = VoiceChance,
                vehicle = VehicleChance,
                text = TextChance,
                voicepitch = Voicepitch,
                strictness = Strictness,
            },
            accuratelevel = accuracy,
            pfp = pfp,
            vp = voicepack,
            zetateam = Zetateam,
            model = mdl,
            name = name,
            physgunclr = physguncolor,
            playerclr = playercolor
        }
        zeta.SpawnOVERRIDE = overridedata
    end






end

_zetaconvardefault = {}

-- Shared stuff

function zeta_NonPlayerNPC(ent) -- Returns if the entity is not any character
    if !ent:IsNPC() and !ent:IsNextBot() and !ent:IsPlayer() then
        return true
    else
        return false
    end
end

local TeamFortressPCF = {
    "bigboom.pcf",
    "flamethrower.pcf"
}

for k,pcf in pairs(TeamFortressPCF) do
    game.AddParticles("particles/"..pcf)
end

zetaWeaponConfigTable = {
    ['GMOD'] = {},
    ['CSS'] = {},
    ['TF2'] = {},
    ["HL1"] = {},
    ['DOD'] = {},
    ['L4D'] = {},
    ["CUSTOM"] = {},
    ["ADDON"] = {},
    ["MP1"] = {}
}

local function confighasvalue( cat, name, prettyname )

    for k, weptbl in pairs( zetaWeaponConfigTable[ cat ] ) do
        if weptbl[ 2 ] == name then weptbl[ 1 ] = prettyname return true end
    end

    return false
end

function RegisterZetaWeapon( category, name, prettyName, defaultvar )
    if prettyName == nil then prettyName = name end
    local cvarName = 'zetaplayer_allow'..string.lower(name)
    CreateConVar(cvarName,defaultvar,FCVAR_ARCHIVE,'Allows the Zeta to equip the '..prettyName,0,1)

    if !confighasvalue( category, name, prettyName ) then
        table.insert(zetaWeaponConfigTable[category], {prettyName, name, cvarName})
    end

    _zetaconvardefault[cvarName] = tostring( defaultvar )

end

if SERVER then
    net.Receive( "zetaweaponcreator_updateweapons", function( len, ply ) 

        zetaWeaponConfigTable = {
            ['GMOD'] = {},
            ['CSS'] = {},
            ['TF2'] = {},
            ["HL1"] = {},
            ['DOD'] = {},
            ['L4D'] = {},
            ["CUSTOM"] = {},
            ["ADDON"] = {},
            ["MP1"] = {}
        }
    
        include("zeta/weapon_tables.lua")

        _ZetaRegisterDefaultWeapons()
    
        ply:ConCommand( "spawnmenu_reload" )
    end )
end

include('zeta/weapon_tables.lua')

function _ZetaRegisterDefaultWeapons()

    RegisterZetaWeapon('L4D', 'L4D_PISTOL_P220','[L4D2] SIG Sauer P220',1)
    RegisterZetaWeapon('L4D', 'L4D_PISTOL_GLOCK26','[L4D2] Glock 26',1)
    RegisterZetaWeapon('L4D', 'L4D_PISTOL_MAGNUM','[L4D2] Magnum',1)
    RegisterZetaWeapon('L4D', 'L4D_SMG','[L4D2] Submachine Gun',1)
    RegisterZetaWeapon('L4D', 'L4D_SMG_SILENCED','[L4D2] Silenced Submachine Gun',1)
    RegisterZetaWeapon('L4D', 'L4D_SHOTGUN_PUMP','[L4D2] Pump Shotgun',1)
    RegisterZetaWeapon('L4D', 'L4D_SHOTGUN_CHROME','[L4D2] Chrome Shotgun',1)
    RegisterZetaWeapon('L4D', 'L4D_SHOTGUN_AUTOSHOT','[L4D2] Tactical Shotgun',1)
    RegisterZetaWeapon('L4D', 'L4D_SHOTGUN_SPAS12','[L4D2] Combat Shotgun',1)
    RegisterZetaWeapon('L4D', 'L4D_RIFLE_M16','[L4D2] M-16 Assault Rifle',1)
    RegisterZetaWeapon('L4D', 'L4D_RIFLE_AK47','[L4D2] AK47',1)
    RegisterZetaWeapon('L4D', 'L4D_RIFLE_SCARL','[L4D2] Combat Rifle',1)
    RegisterZetaWeapon('L4D', 'L4D_RIFLE_RUGER14','[L4D2] Hunting Rifle',1)
    RegisterZetaWeapon('L4D', 'L4D_RIFLE_MILITARYS','[L4D2] Military Rifle',1)
    RegisterZetaWeapon('L4D', 'L4D_PISTOL_M1911','[L4D1] M1911 Pistol',1)
    RegisterZetaWeapon('L4D', 'L4D_SPECIAL_CHAINSAW','[L4D2] Chainsaw', 1)

    -- Left 4 Dead 2 Melee Weapons
    RegisterZetaWeapon('L4D', 'L4D_MELEE_FIREAXE','[L4D2] Fireaxe',1)
    RegisterZetaWeapon('L4D', 'L4D_MELEE_GUITAR','[L4D2] Guitar',1)
    RegisterZetaWeapon('L4D', 'L4D_MELEE_GOLFCLUB','[L4D2] Golf Club',1)
    RegisterZetaWeapon('L4D', 'L4D_MELEE_TONFA','[L4D2] Nightstick',1)

    -- Left 4 Dead 2 Special Weapons
    RegisterZetaWeapon('L4D', 'L4D_SPECIAL_GL_DELAYED','[L4D2] Grenade Launcher (Non-Impact)',1)
    RegisterZetaWeapon('L4D', 'L4D_SPECIAL_GL_IMPACT','[L4D2] Grenade Launcher (Impact)',1)
    RegisterZetaWeapon('L4D', 'L4D_SPECIAL_M60','[L4D2] M60',1)


    -- Axis
    RegisterZetaWeapon('DOD', 'DODS_AXIS_SPADE','German Entrenching Spade Shovel',1)
    RegisterZetaWeapon('DOD', 'DODS_AXIS_P38','Walther P38',1)
    RegisterZetaWeapon('DOD', 'DODS_AXIS_C96','Mauser C96',1)
    RegisterZetaWeapon('DOD', 'DODS_AXIS_MP40','Maschinenpistole 40',1)
    RegisterZetaWeapon('DOD', 'DODS_AXIS_KAR98k','Karabiner 98k',1)
    RegisterZetaWeapon('DOD', 'DODS_AXIS_KAR98KSNIPER','Karabiner 98k Sniper',1)
    RegisterZetaWeapon('DOD', 'DODS_AXIS_MG42','Maschinengewehr 42',1)
    RegisterZetaWeapon('DOD', 'DODS_AXIS_PANZERSCHRECK','Panzerschreck 54',1)
    RegisterZetaWeapon('DOD', 'DODS_AXIS_MP44','Sturmgewehr 44',1)

    
    -- Allies
    RegisterZetaWeapon('DOD', 'DODS_US_AMERIKNIFE','M1 Trench Knife',1)
    RegisterZetaWeapon('DOD', 'DODS_US_COLT45','Colt .45',1)
    RegisterZetaWeapon('DOD', 'DODS_US_THOMPSON','M1 Thompson',1)
    RegisterZetaWeapon('DOD', 'DODS_US_GARAND','M1 Garand',1)
    RegisterZetaWeapon('DOD', 'DODS_US_M1CARBINE','M1 Carbine',1)
    RegisterZetaWeapon('DOD', 'DODS_US_BAR','M1918 Browning Auto Rifle',1)
    RegisterZetaWeapon('DOD', 'DODS_US_SPRINGFIELD','Springfield',1)
    RegisterZetaWeapon('DOD', 'DODS_US_30CAL','M1919 Browning Machine Gun',1)
    RegisterZetaWeapon('DOD', 'DODS_US_BAZOOKA','M1 Bazooka',1)



    RegisterZetaWeapon('CSS', 'GLOCK_AUTO',"Glock 18 Auto",1)
    RegisterZetaWeapon('CSS', 'GLOCK_SEMI',"Glock 18 Semi-Auto",1)
    RegisterZetaWeapon('CSS', 'UMP45','UMP-45',1)
    RegisterZetaWeapon('CSS', 'FAMAS','Famas',1)
    RegisterZetaWeapon('CSS', 'AUG','AUG',1)
    RegisterZetaWeapon('CSS', 'SG552','SG552',1)
    RegisterZetaWeapon('CSS', 'P90','P90',1)
    RegisterZetaWeapon('CSS', 'MAC10','Mac-10',1)
    RegisterZetaWeapon('CSS', 'SCOUT', 'Steyr Scout',1)
    RegisterZetaWeapon('CSS', 'XM1014','XM1014',1)
    RegisterZetaWeapon('CSS', 'FIVESEVEN',"Five-Seven",1)
    RegisterZetaWeapon('CSS', 'USPSILENCED',"USP-45",1)
    RegisterZetaWeapon('CSS', 'M3',"M3 Super 90",1)
    RegisterZetaWeapon('CSS', 'GALIL',"IMI Galil",1)
    RegisterZetaWeapon('CSS', 'TMP',"TMP",1)
    RegisterZetaWeapon('CSS', 'DUALELITES',"Dual Berettas",1)
    RegisterZetaWeapon("CSS", "FLASHGRENADE", "Flash Grenade", 1)
    RegisterZetaWeapon("CSS", "SMOKEGRENADE", "Smoke Grenade", 1)


    RegisterZetaWeapon('GMOD', 'HACKSMONITORS','Anti Hacks Monitors',1)
    RegisterZetaWeapon('GMOD', 'IMPACTGRENADE','Punch Activated Impact Grenade',1)
    RegisterZetaWeapon('GMOD', 'SHOVEL','Shovel',1)
    RegisterZetaWeapon('GMOD', 'VOLVER','Volver',0)
    RegisterZetaWeapon('GMOD', 'BUGBAIT','Bugbait',1)
    RegisterZetaWeapon('GMOD', 'PAN','Frying Pan',1)
    RegisterZetaWeapon('GMOD', 'MEATHOOK','Meat Hook',1)
    RegisterZetaWeapon('GMOD', 'C4','C4 Plastic Explosive',0)
    RegisterZetaWeapon('GMOD', 'LARGEGRENADE','Comically Large Grenade',1)
    RegisterZetaWeapon('GMOD', 'KATANA','Katana',1)
    RegisterZetaWeapon('GMOD', 'ALYXGUN','Alyx Gun',1)
    RegisterZetaWeapon('GMOD', 'ANNABELLE','Annabelle',1)
    RegisterZetaWeapon('GMOD', 'WOODENCHAIR','Wooden Chair',1)
    RegisterZetaWeapon('GMOD', 'THEKLEINER','Kleiner',1)
    RegisterZetaWeapon('GMOD', 'LARGESIGN','Large Sign Post',1)
    RegisterZetaWeapon('GMOD', 'CARDOOR','Car Door',1)
    RegisterZetaWeapon('GMOD', 'ZOMBIECLAWS','Zombie Claws',1)


    if istable(rb655_gForcePowers) then
        RegisterZetaWeapon('GMOD', 'LIGHTSABER', 'Lightsaber', 1)
    end

    if istable(mp1_lib) then
        RegisterZetaWeapon("MP1", "MP1_LEADPIPE", "[MP1] Lead Pipe", 1)
        RegisterZetaWeapon("MP1", "MP1_BASEBALLBAT", "[MP1] Baseball Bat", 1)
        RegisterZetaWeapon("MP1", "MP1_BERETTA", "[MP1] Beretta", 1)
        RegisterZetaWeapon("MP1", "MP1_DUALBERETTAS", "[MP1] Dual Berettas", 1)
        RegisterZetaWeapon("MP1", "MP1_DESERTEAGLE", "[MP1] Desert Eagle", 1)
        RegisterZetaWeapon("MP1", "MP1_INGRAM", "[MP1] Ingram Mac-10", 1)
        RegisterZetaWeapon("MP1", "MP1_DUALINGRAMS", "[MP1] Dual Ingrams", 1)
        RegisterZetaWeapon("MP1", "MP1_MP5", "[MP1] MP5", 1)
        RegisterZetaWeapon("MP1", "MP1_SAWEDOFFSHOTGUN", "[MP1] Sawed-Off Shotgun", 1)
        RegisterZetaWeapon("MP1", "MP1_PUMPSHOTGUN", "[MP1] Pump-Action Shotgun", 1)
        RegisterZetaWeapon("MP1", "MP1_COLTCOMMANDO", "[MP1] Colt Commando", 1)
        RegisterZetaWeapon("MP1", "MP1_JACKHAMMER", "[MP1] Jackhammer", 1)
        RegisterZetaWeapon("MP1", "MP1_SNIPERRIFLE", "[MP1] Sniper Rifle", 1)
        RegisterZetaWeapon("MP1", "MP1_M79", "[MP1] M79", 1)
        RegisterZetaWeapon("MP1", "MP1_COCKTAIL", "[MP1] Molotov Cocktail", 1)
        RegisterZetaWeapon("MP1", "MP1_GRENADE", "[MP1] Grenade", 1)
    end

    if file.Exists("weapons/weapon_nyangun.lua", "LUA") then
        RegisterZetaWeapon('GMOD', 'NYANGUN', 'Nyan Gun', 1)
    end




    RegisterZetaWeapon('TF2', 'BAT','Bat',1)
    RegisterZetaWeapon('TF2', 'SNIPERSMG','TF2 SMG',1)
    RegisterZetaWeapon('TF2', 'FORCEOFNATURE','Force of Nature',1)
    RegisterZetaWeapon('TF2', 'GRENADELAUNCHER','Grenade Launcher',1)
    RegisterZetaWeapon('TF2', 'FLAMETHROWER','Flamethrower',1)
    RegisterZetaWeapon("TF2", "TF2_MINIGUN", "Minigun", 1)

    RegisterZetaWeapon('HL1', 'HL1SMG','HL1 MP5',1)
    RegisterZetaWeapon('HL1', 'HL1GLOCK','HL1 Glock',1)
    RegisterZetaWeapon('HL1', 'HL1SPAS','HL1 Spas',1)
    RegisterZetaWeapon('HL1', 'HL1357','HL1 357',1)

    if SERVER then -- Just in case

        local TF2Mounted = IsMounted('tf')
        local HL1Mounted = IsMounted('hl1')
        local mountableWpns = {
            ["HL1SMG"] = HL1Mounted,
            ["HL1GLOCK"] = HL1Mounted,
            ["HL1SPAS"] = HL1Mounted,
            ["HL1357"] = HL1Mounted
        }

        _ZetaWeaponConVars = {}
        _ZetaExplosiveWeapons = {}
        
        for k, v in pairs(_ZetaWeaponDataTable) do
            if mountableWpns[k] == nil or mountableWpns[k] == true then
                local cvarName = "zetaplayer_allow"..string.lower(tostring(k))
                if k == "GRENADE" then cvarName = cvarName.."s" end
                local cvar = GetConVar(cvarName)
                if cvar then 
                    local isLethal = (k == "CAMERA" and GetConVar("zetaplayer_allowcameraaslethalweapon") or v.lethal)
                    _ZetaWeaponConVars[k] = {cvar, isLethal} 
                end

                if v.isExplosive then _ZetaExplosiveWeapons[#_ZetaExplosiveWeapons+1] = tostring(k) end
            end
        end

    end


end

_ZetaRegisterDefaultWeapons()

-- When adding convars, We now should use this for it to add to the preset system
local function AddZetaConvar(cvarname,save,value,helptext,min,max)
    CreateConVar(cvarname,value,save and FCVAR_ARCHIVE or !save and FCVAR_NONE,helptext,min,max)
    _zetaconvardefault[cvarname] = tostring( value )
end







AddZetaConvar('zetaplayer_debug',false,0,"Enables the Zeta's debug text",0,1)
AddZetaConvar('zetaplayer_consolelog',true,0,"Enables the Console logging of Zetas. Mimics ent spawning logs you see with players",0,1)
AddZetaConvar('zetaplayer_allowtoolgunnonworld',true,1,'Allows the Zeta to toolgun non world ents',0,1)
AddZetaConvar('zetaplayer_allowtoolgunworld',true,1,'Allows the Zeta to toolgun world ents',0,1)
AddZetaConvar('zetaplayer_allowphysgunnonworld',true,1,'Allows the Zeta to physgun non world ents',0,1)
AddZetaConvar('zetaplayer_allowphysgunworld',true,0,'Allows the Zeta to physgun world ents',0,1)
AddZetaConvar('zetaplayer_allowphysgunplayers',true,0,'Allows the Zeta to physgun players',0,1)
AddZetaConvar('zetaplayer_allowphysgunzetas',true,0,'Allows the Zeta to physgun other Zetas',0,1)
AddZetaConvar('zetaplayer_allowcolortool',true,1,'Allows the Zeta to use the Color Tool',0,1)
AddZetaConvar('zetaplayer_allowmaterialtool',true,1,'Allows the Zeta to use the Material Tool',0,1)
AddZetaConvar('zetaplayer_allowropetool',true,1,'Allows the Zeta to use the Rope Tool',0,1)
AddZetaConvar('zetaplayer_allowlighttool',true,1,'Allows the Zeta to use the Light Tool',0,1)
AddZetaConvar('zetaplayer_allowmusicboxtool',true,1,'Allows the Zeta to use the Music Box Tool',0,1)
AddZetaConvar('zetaplayer_allowtrailstool',true,1,'Allows the Zeta to use the Trails Tool',0,1)
AddZetaConvar('zetaplayer_allowignitertool',true,1,'Allows the Zeta to use the Igniter Tool',0,1)
AddZetaConvar('zetaplayer_allowballoontool',true,1,'Allows the Zeta to use the Balloon Tool',0,1)
AddZetaConvar('zetaplayer_randomplayermodelcolor',true,1,'If Zeta models should have a random color applied',0,1)
AddZetaConvar('zetaplayer_allowremovertool',true,0,'Allows the Zeta to use the Remover Tool',0,1)
AddZetaConvar('zetaplayer_allowattacking',true,1,'Allows the Zeta to attack people',0,1)
AddZetaConvar('zetaplayer_allowselfdefense',true,1,'Allows the Zeta to defend itself if it has a lethal weapon',0,1)
AddZetaConvar('zetaplayer_allowdefendothers',true,1,'Allows the Zeta to defend other players or zetas if they are getting attacked',0,1)
AddZetaConvar('zetaplayer_allowentities',true,0,'Allows the Zeta to spawn Entities',0,1)
AddZetaConvar('zetaplayer_allownpcs',true,0,'Allows the Zeta to spawn NPCS',0,1)
AddZetaConvar('zetaplayer_allowvehicles',true,1,'Allows the Zeta to use Vehicles',0,1)
AddZetaConvar('zetaplayer_npclimit',true,1,'How much npcs a Zeta is allowed to spawn',0,100)
AddZetaConvar('zetaplayer_allowfollowingfriend',true,1,'If Zetas are allowed to follow their friend',0,1)
AddZetaConvar('zetaplayer_allowlaughing',true,1,'If Zetas are allowed to laugh at dead people',0,1)
AddZetaConvar('zetaplayer_enablefriend',true,1,'Enable the Friend System',0,1)
AddZetaConvar('zetaplayer_alternateidlesounds',true,1,'Toggle Alternate Idle sounds',0,1)
AddZetaConvar('zetaplayer_wanderdistance',true,1500,'The max distance a Zeta can wander to',0,15000)
AddZetaConvar('zetaplayer_overridemodel',true,'','Override the spawning model of a Zeta')
AddZetaConvar('zetaplayer_spawnweapon',true,'NONE',"Change the Zeta's spawning weapon")
AddZetaConvar('zetaplayer_naturalspawnweapon',true,'NONE',"Change the natural Zeta's spawning weapon")
AddZetaConvar('zetaplayer_panicthreshold',true,0.3,"Health Threshold where if the a Zeta's health is below it, it may panic",0,1)
AddZetaConvar('zetaplayer_allowlargeprops',true,1,'If Zetas are allowed to spawn large props',0,1)
AddZetaConvar('zetaplayer_propspawnunfrozen',true,0,'If Props should spawn unfrozen. This will cause lag!',0,1)
AddZetaConvar('zetaplayer_mapwidespawning',true,0,'If Zetas should naturally spawn map wide. This will automatically create Zetas',0,1)
AddZetaConvar('zetaplayer_mapwidespawningzetaamount',true,10,'How many Zetas should spawn when using map wide spawning',1,300)
AddZetaConvar('zetaplayer_voicevolume',true,1,'The Volume of Zeta Voices',0.1,10.0)
AddZetaConvar('zetaplayer_removepropsondeath',true,1,"If a Zeta's props should be removed upon removal. You probably shouldn't touch this unless you want their props to be saved",0,1)
AddZetaConvar('zetaplayer_freezelargeprops',true,1,'If a large prop spawned by a Zeta should be frozen. To prevent any physics crash from large props',0,1)
AddZetaConvar('zetaplayer_ignorezetas',false,0,'If the Zetas should ignore each other',0,1)
AddZetaConvar('zetaplayer_randomplayermodels',true,0,'Allows the Zetas to have random playermodels',0,1)
AddZetaConvar('zetaplayer_randomdefaultplayermodels',true,0,'If the random playermodels should only be from the base game',0,1)
AddZetaConvar('zetaplayer_lightlimit',true,5,'How much lights a Zeta is allowed to spawn',1,30)
AddZetaConvar('zetaplayer_musicboxlimit',true,1,'How much music boxes a Zeta is allowed to spawn',1,30)
AddZetaConvar('zetaplayer_balloonlimit',true,5,'How much balloons a Zeta is allowed to spawn',1,100)
AddZetaConvar('zetaplayer_ropelimit',true,5,'How much ropes a Zeta is allowed to place',1,100)
AddZetaConvar('zetaplayer_proplimit',true,50,'How much props a Zeta is allowed to spawn',1,5000)
AddZetaConvar('zetaplayer_sentlimit',true,10,'How much SENTS a Zeta is allowed to spawn',1,200)
AddZetaConvar('zetaplayer_usealternatedeathsounds',true,0,'Play alternate deaths sounds apart from the kleiner death sound',0,1)
AddZetaConvar('zetaplayer_cleanupcorpse',true,0,'If dead Zetas should be cleaned',0,1)
AddZetaConvar('zetaplayer_cleanupcorpseeffect',true,1,'If Corpses should play a effect before being removed',0,1)
AddZetaConvar('zetaplayer_mapwidespawninguseplayerstart',true,0,'If Natural Zetas should spawn at Player Spawnpoints',0,1)
AddZetaConvar('zetaplayer_cleanupcorpsetime',true,15,'The time before corpses should be cleaned',1,190)
AddZetaConvar('zetaplayer_disabled',false,0,'Disables the Zeta from thinking',0,1)
AddZetaConvar('zetaplayer_custommusiconly',true,0,'If Custom Music should only be played by Zeta Music Boxes',0,1)
AddZetaConvar('zetaplayer_musicvolume',true,1,'The volume of music played by the Music Box',0,10)
AddZetaConvar('zetaplayer_allowpanicvoice',true,1,'If Zetas should make panic sounds',0,1)
AddZetaConvar('zetaplayer_allowidlevoice',true,1,'If Zetas should make idle sounds',0,1)
AddZetaConvar('zetaplayer_allowdeathvoice',true,1,'If Zetas should make death sounds',0,1)
AddZetaConvar('zetaplayer_allowar2altfire',true,1,'If Zetas are allowed to use the AR2 alt fire',0,1)
AddZetaConvar('zetaplayer_allowbackstabbing',true,1,'If Zetas are allowed to have increased attack damage when backstabbing with a knife',0,1)
AddZetaConvar('zetaplayer_allowwitnesssounds',true,1,'If Zetas are allowed to make witness sounds',0,1)
AddZetaConvar('zetaplayer_allowfalldamage',true,1,'If Zetas should take fall damage',0,1)
AddZetaConvar('zetaplayer_allowrealisticfalldamge',true,0,'If Zetas should take realistic fall damage. Note, Fall damage must be on for this to apply',0,1)
AddZetaConvar('zetaplayer_allowfaceposertool',true,1,'If Zetas are allowed to use the Faceposer tool',0,1)
AddZetaConvar('zetaplayer_allowemittertool',true,1,'If Zetas are allowed to use the Emitter tool',0,1)
AddZetaConvar('zetaplayer_emitterlimit',true,2,'How much emitters a Zeta is allowed to spawn',1,100)
AddZetaConvar('zetaplayer_allowmlgshots',true,1,'If Zetas are allowed to have increased attack damage randomly with the AWP',0,1)
AddZetaConvar('zetaplayer_drawcameraflashing',true,0,'If Zeta Cameras are allowed to emit a flash',0,1)
AddZetaConvar('zetaplayer_bonemanipulatortool',true,1,'If Zetas are allowed to use the Bone Manipulator Tool',0,1)
AddZetaConvar('zetaplayer_allowdynamitetool',true,1,'If Zetas are allowed to use the Dynamite tool',0,1)
AddZetaConvar('zetaplayer_dynamitelimit',true,2,'How much dynamite a Zeta is allowed to spawn',1,100)
AddZetaConvar('zetaplayer_allowcameraaslethalweapon',true,0,'If Zetas are allowed to equip the camera when trying to defend themselves',0,1)
AddZetaConvar('zetaplayer_allowpainttool',true,1,'If Zetas are allowed to use the Paint Tool',0,1)
AddZetaConvar('zetaplayer_allowkillvoice',true,1,'If Zetas can speak a line when killing someone',0,1)
AddZetaConvar('zetaplayer_allowtauntvoice',true,1,'If Zetas can taunt before attacking someone or defend themselves',0,1)
AddZetaConvar('zetaplayer_zetaspawnersaveidentity',true,1,'If Zeta Spawners should save identities',0,1)
AddZetaConvar('zetaplayer_allowzetascreenshots',true,0,'If Zetas are allowed to request and take screenshots',0,1)
AddZetaConvar('zetaplayer_ignoresmallnavareas',true,0,'If Zetas should ignore smaller nav areas',0,1)
AddZetaConvar('zetaplayer_allowdisconnecting',true,0,'If Zetas are allowed to disconnect from your game',0,1)
AddZetaConvar('zetaplayer_voicedsp',"normaltrue,","The DSP effect on the Zeta's voice",0,1)
AddZetaConvar('zetaplayer_allowvoicepopup',true,0,"If speaking Zetas should have a voice chat popup",0,1)
AddZetaConvar('zetaplayer_globalvoicechat',true,0,"If speaking Zeta voice should be hard globally just like real players",0,1)
AddZetaConvar('zetaplayer_usecustomavatars',true,0,"If Zetas should use custom profile pictures from custom_avatars",0,1)
AddZetaConvar('zetaplayer_limitdsp',true,1,"Limits the amount of Zetas that can have DSP effects. TURN THIS OFF AT YOUR OWN RISK! This is supposed to keep source from crashing because of all the sounds it has to process!",0,1)
AddZetaConvar('zetaplayer_showprofilepicturesintab',true,0,"If tab menu should display zeta profile pictures",0,1)
AddZetaConvar('zetaplayer_dsplimit',true,7,"The amount of Zetas that are allowed to have DSP effects",1,7)
AddZetaConvar('zetaplayer_zetahealth',true,100,"The amount of health Zetas will spawn with",1,10000)
AddZetaConvar('zetaplayer_naturalspawnrate',true,2,"The spawn rate in seconds for natural zetas to spawn",0.1,120)
AddZetaConvar('zetaplayer_permamentfriendalwaysspawn',true,0,"If your permament friend should always be in game",0,1)
AddZetaConvar('zetaplayer_allowassistsound',true,1,"If Zetas should speak on assists",0,1)
AddZetaConvar('zetaplayer_dropweapons',true,0,"If Zetas should drop their weapons if they die",0,1)
AddZetaConvar('zetaplayer_showpfpoverhealth',true,0,"If Zetas should show their profile picture when you hover over them",0,1)
AddZetaConvar('zetaplayer_naturalzetahealth',true,100,"The amount of health Natural Zetas will spawn with",1,10000)
AddZetaConvar('zetaplayer_allowstrafing',true,1,"If Zetas should strafe when attacking",0,1)
AddZetaConvar('zetaplayer_triggermines',true,1, 'Makes Zetas trigger nearby Combine Mines to explode', 0, 1)
AddZetaConvar('zetaplayer_triggermines_hoptime', true,0.5, 'Time required for the mine to hop towards a target after triggering it', 0, 5)
AddZetaConvar('zetaplayer_disableunstuck', true,0, 'Disable the Unstuck system. Why?', 0, 1)
AddZetaConvar('zetaplayer_killontouchnodraworsky', true, 1, 'If Zetas should die when they are touching a nodraw surface or sky surface', 0, 1)
AddZetaConvar('zetaplayer_customidlelinesonly', true, 0, 'If Custom Idle Lines should only be used', 0, 1)
AddZetaConvar('zetaplayer_customdeathlinesonly', true, 0, 'If Custom Death Lines should only be used', 0, 1)
AddZetaConvar('zetaplayer_customkilllinesonly', true, 0, 'If Custom Kill Lines should only be used', 0, 1)
AddZetaConvar('zetaplayer_customtauntlinesonly', true, 0, 'If Custom Kill Lines should only be used', 0, 1)
AddZetaConvar('zetaplayer_damagedivider', true, 1, 'The amount damage will be divided by', 1, 10)
AddZetaConvar('zetaplayer_explosivecorpsecleanup', true, 0, 'If Corpses should blow up when they are cleaned', 0, 10)
AddZetaConvar('zetaplayer_useprofilesystem',true,0,'Use Zeta Profile Database to load data from instead of randomizing it',0,1)
AddZetaConvar('zetaplayer_norepeatingpfps',true,0,'If enabled, prevents Zetas from having the same profile picture used again',0,1)
AddZetaConvar('zetaplayer_usenewvoicechatsystem',true,0,'If Zetas speaking should use the new voice chat system | Community Contribute',0,1)
AddZetaConvar('zetaplayer_allowsprays',true,0,'If Zetas are allowed to use sprays | Community Contribute',0,1)
AddZetaConvar('zetaplayer_alwayshuntfortargets',true,0,'If Zetas should always hunt for a target',0,1)
AddZetaConvar('zetaplayer_allowuse+onprops',true,1,'If Zetas are allowed to pickup props with use+',0,1)
AddZetaConvar('zetaplayer_allowlamptool',true,1,'If Zetas are allowed to use the Lamp tool',0,1)
AddZetaConvar('zetaplayer_lamplimit',true,1,'Lamp Limit',1,30)
AddZetaConvar('zetaplayer_allowthrustertool',true,1,'If Zetas are allowed to use the Thruster tool',0,1)
AddZetaConvar('zetaplayer_thrusterlimit',true,5,'Thruster Limit',1,60)
AddZetaConvar('zetaplayer_forceadd',true,0,'The amount to add to Damage Force',0,10000)
AddZetaConvar('zetaplayer_musicplayonce',true,0,'If Music Boxes should only play once and remove themselves',0,1)
AddZetaConvar('zetaplayer_musicshuffle',true,1,'If Music Boxes should pick music randomly',0,1)
AddZetaConvar('zetaplayer_showzetalogonscreen',true,0,'If Zeta Events should show up on screen',0,1)
AddZetaConvar('zetaplayer_thrusterunfreeze',true,0,'If Zeta Thrusters should unfreeze whatever they are welded to',0,1)
AddZetaConvar('zetaplayer_differentvoicepitch',true,0,'If Zetas should have different pitches in voice',0,1)
AddZetaConvar('zetaplayer_voicepitchmin',true,80,'Voice pitch min and max',10,100)
AddZetaConvar('zetaplayer_voicepitchmax',true,130,'Voice pitch min and max',100,255)
AddZetaConvar('zetaplayer_mingebag',true,0,'If Zetas should be a mingebag',0,1)
AddZetaConvar('zetaplayer_mapwidemingebag',true,0,'If Natural Zetas should be a mingebag',0,1)
AddZetaConvar('zetaplayer_mapwidemingebagspawnchance',true,10,'The chance a natural Zeta will spawn as a mingebag',1,100)
AddZetaConvar('zetaplayer_allowscoldvoice',true,1,'If Admins should scold their offender',0,1)
AddZetaConvar('zetaplayer_zetaspawnerrespawntime',true,1,'Respawning Zeta spawn rate',0,120)
AddZetaConvar('zetaplayer_playersizedsprays',true,1,'If Sprays should mimic the size of real player sprays',0,1)
AddZetaConvar('zetaplayer_enabledrowning',true,1,'If Zetas should drown in water',0,1)
AddZetaConvar('zetaplayer_bugbait_limit',true,4,'The amount of antlions a Zeta can summon',1,30)
AddZetaConvar('zetaplayer_bugbait_lifetime',true,10,'The amount of time antlions can live for',0,120)
AddZetaConvar('zetaplayer_bugbait_spawnhp',true,30,'The amount of health antlions will spawn with',1,500)
AddZetaConvar('zetaplayer_jpgpropamount',true,15,'The amount of props the JPG will fire',1,15)
AddZetaConvar('zetaplayer_c4debris',true,0,'If C4 should create debris on explosion',0,1)
AddZetaConvar('zetaplayer_c4card',true,0,'If C4 should show up in a MW2 Card if the addon is installed',0,1)

AddZetaConvar('zetaplayer_serverjunk',true,0,'If Props should be spawned when the player loads in',0,1)
AddZetaConvar('zetaplayer_freezeserverjunk',true,0,'If server junk should spawn frozen',0,1)
AddZetaConvar('zetaplayer_serverjunkcount',true,45,'The amount of props that will spawn on the map',0,400)



AddZetaConvar('zetaplayer_customwitnesslinesonly', true, 0, 'If Custom Witness Lines should only be used', 0, 1)
AddZetaConvar('zetaplayer_custompaniclinesonly', true, 0, 'If Custom Panic Lines should only be used', 0, 1)
AddZetaConvar('zetaplayer_customassistlinesonly', true, 0, 'If Custom Assist Lines should only be used', 0, 1)
AddZetaConvar('zetaplayer_customlaughlinesonly', true, 0, 'If Custom Laughing Lines should only be used', 0, 1)
AddZetaConvar('zetaplayer_customadminscoldlinesonly', true, 0, 'If Custom Admin Scolding Lines should only be used', 0, 1)





AddZetaConvar('zetaplayer_useteamsystem',true,0,'If Zetas should join a team if they can',0,1)
AddZetaConvar('zetaplayer_eachteammemberlimit',true,3,'How many members can be in a team',2,100)
AddZetaConvar('zetaplayer_playerteam',true,'','What Team real players should be in')
AddZetaConvar('zetaplayer_overrideteam',true,'','What Team Zetas should be forced in')


AddZetaConvar('zetaplayer_randombodygroups',true,1,'If Zetas should have random bodygroups',0,1)
AddZetaConvar('zetaplayer_randomskingroups',true,1,'If Zetas should have random skins',0,1)

AddZetaConvar('zetaplayer_personalitytype',true,'random','Type of personality the Zeta will be')
AddZetaConvar('zetaplayer_buildchance',true,30,'Personality Chance',0,100)
AddZetaConvar('zetaplayer_combatchance',true,30,'Personality Chance',0,100)
AddZetaConvar('zetaplayer_toolchance',true,30,'Personality Chance',0,100)
AddZetaConvar('zetaplayer_physgunchance',true,30,'Personality Chance',0,100)
AddZetaConvar('zetaplayer_disrespectchance',true,30,'Personality Chance',0,100)
AddZetaConvar('zetaplayer_watchmediaplayerchance',true,30,'Personality Chance',0,100)
AddZetaConvar('zetaplayer_friendlychance',true,30,'Personality Chance',0,100)
AddZetaConvar('zetaplayer_voicechance',true,30,'voice Chance',0,100)
AddZetaConvar('zetaplayer_vehiclechance',true,30,'Vehicle Chance',0,100)


AddZetaConvar('zetaplayer_naturalpersonalitytype',true,'random','Type of personality the Zeta will be')
AddZetaConvar('zetaplayer_naturalbuildchance',true,30,'Personality Chance',0,100)
AddZetaConvar('zetaplayer_naturalcombatchance',true,30,'Personality Chance',0,100)
AddZetaConvar('zetaplayer_naturaltoolchance',true,30,'Personality Chance',0,100)
AddZetaConvar('zetaplayer_naturalphysgunchance',true,30,'Personality Chance',0,100)
AddZetaConvar('zetaplayer_naturaldisrespectchance',true,30,'Personality Chance',0,100)
AddZetaConvar('zetaplayer_naturalwatchmediaplayerchance',true,30,'Personality Chance',0,100)
AddZetaConvar('zetaplayer_naturalfriendlychance',true,30,'Personality Chance',0,100)
AddZetaConvar('zetaplayer_naturalvoicechance',true,30,'voice Chance',0,100)
AddZetaConvar('zetaplayer_naturalvehiclechance',true,30,'Vehicle Chance',0,100)




-- Admin Convars 
AddZetaConvar('zetaplayer_admindisplaynameRed',true,0,'Red value of the display name color',0,255)
AddZetaConvar('zetaplayer_admindisplaynameGreen',true,148,'Green value of the display name color',0,255)
AddZetaConvar('zetaplayer_admindisplaynameBlue',true,255,'Blue value of the display name color',0,255)

AddZetaConvar('zetaplayer_adminoverridemodel',true,'models/player/police.mdl','Override the spawning model of a Admin Zeta')
AddZetaConvar('zetaplayer_spawnasadmin',true,0,'If Admins should spawn',0,1)
AddZetaConvar('zetaplayer_forcespawnadmins',true,0,'If Zetas that you spawn next should become admins',0,1)
AddZetaConvar('zetaplayer_adminrule_nopropkill',true,1,'Enforce no prop killing',0,1)
AddZetaConvar('zetaplayer_adminrule_rdm',true,1,'Enforce no random killing.',0,1)
AddZetaConvar('zetaplayer_adminrule_griefing',true,1,'Enforce no altering of other entities that you do not own.',0,1)
AddZetaConvar('zetaplayer_admintreatowner',true,0,'If admins should treat you as the owner and ignore your rulebreaking',0,1)
AddZetaConvar('zetaplayer_adminprintecho',true,1,'If admins using commands should have their commands echo into chat',0,1)
AddZetaConvar('zetaplayer_adminsctrictnessmin',true,0,'How Strict and harsh should the admins be',0,100)
AddZetaConvar('zetaplayer_adminsctrictnessmax',true,30,'How Strict and harsh should the admins be',0,100)
AddZetaConvar('zetaplayer_adminshouldsticktogether',true,0,'If admins should stick together most of the time',0,1)
AddZetaConvar('zetaplayer_admincount',true,1,'How many Admins can there be',1,100)


AddZetaConvar('zetaplayer_allowpistol',true,1,'Allows the Zeta to equip the pistol',0,1)
AddZetaConvar('zetaplayer_allowar2',true,1,'Allows the Zeta to equip the ar2',0,1)
AddZetaConvar('zetaplayer_allowshotgun',true,1,'Allows the Zeta to equip the shotgun',0,1)
AddZetaConvar('zetaplayer_allowsmg',true,1,'Allows the Zeta to equip the smg',0,1)
AddZetaConvar('zetaplayer_allowrpg',true,1,'Allows the Zeta to equip the rpg',0,1)
AddZetaConvar('zetaplayer_allowcrowbar',true,1,'Allows the Zeta to equip the crowbar',0,1)
AddZetaConvar('zetaplayer_allowstunstick',true,1,'Allows the Zeta to equip the stunstick',0,1)
AddZetaConvar('zetaplayer_allowrevolver',true,1,'Allows the Zeta to equip the revolver',0,1)
AddZetaConvar('zetaplayer_allowtoolgun',true,1,'Allows the Zeta to equip the toolgun',0,1)
AddZetaConvar('zetaplayer_allowphysgun',true,1,'Allows the Zeta to equip the physgun',0,1)
AddZetaConvar('zetaplayer_allowknife',true,1,'Allows the Zeta to equip the knife',0,1)
AddZetaConvar('zetaplayer_allowfist',true,1,'Allows the Zeta to use their fists',0,1)
AddZetaConvar('zetaplayer_allowcrossbow',true,1,'Allows the Zeta to use the crossbow',0,1)
AddZetaConvar('zetaplayer_allowm4a1',true,1,'Allows the Zeta to use the m4a1',0,1)
AddZetaConvar('zetaplayer_allowawp',true,1,'Allows the Zeta to use the awp',0,1)
AddZetaConvar('zetaplayer_allowcamera',true,1,'Allows the Zeta to use the camera',0,1)
AddZetaConvar('zetaplayer_allowwrench',true,1,'Allows the Zeta to use the Wrench',0,1)
AddZetaConvar('zetaplayer_allowscattergun',true,1,'Allows the Zeta to use the Scatter gun',0,1)
AddZetaConvar('zetaplayer_allowtf2pistol',true,1,'Allows the Zeta to use the TF2 Pistol',0,1)
AddZetaConvar('zetaplayer_allowak47',true,1,'Allows the Zeta to use the AK47',0,1)
AddZetaConvar('zetaplayer_allowmachinegun',true,1,'Allows the Zeta to use the Machine Gun',0,1)
AddZetaConvar('zetaplayer_allowdeagle',true,1,'Allows the Zeta to use the Desert Eagle',0,1)
AddZetaConvar('zetaplayer_allowtf2sniper',true,1,'Allows the Zeta to use the TF2 Sniper',0,1)
AddZetaConvar('zetaplayer_allowtf2shotgun',true,1,'Allows the Zeta to use the TF2 Shotgun',0,1)
AddZetaConvar('zetaplayer_allowgrenades',true,1,'Allows the Zeta to use Grenades',0,1)
AddZetaConvar('zetaplayer_allowmp5',true,1,'Allows the Zeta to use MP5',0,1)
AddZetaConvar('zetaplayer_allowjpg',true,1,'Allows the Zeta to use the JPG',0,1)


















AddZetaConvar("zetaplayer_customsitrespondlinesonly",true,0,"If Zetas should only use your custom sit respond lines",0,1)
AddZetaConvar("zetaplayer_custommediawatchlinesonly",true,0,"If Zetas should only use your custom Media Watch lines",0,1)


AddZetaConvar("zetaplayer_allowmediawatchvoice",true,1,"If Zetas should speak while watching a media player",0,1)

AddZetaConvar("zetaplayer_friendsticknear",true,0,"If Zetas should stick near their friend",0,1)
AddZetaConvar("zetaplayer_usedynamicpathfinding",true,0,"If Zetas should try to dynamically pathfind",0,1)
AddZetaConvar("zetaplayer_mapwidespawningrandom",true,0,"If MWS should use the rate value as the max of a random value",0,1)
AddZetaConvar("zetaplayer_bugbait_dmgscale",true,0,"Damage scaling for Zeta Antlions",0,100)
AddZetaConvar("zetaplayer_friendstickneardistance",true,1000,"The distance Zetas can wander from their friend",0,15000)

AddZetaConvar("zetaplayer_adminallowgodmode",true,1,"If Admins can use God Mode",0,1)
AddZetaConvar("zetaplayer_adminallowsethealth",true,1,"If Admins can set their health",0,1)
AddZetaConvar("zetaplayer_adminallowsetarmor",true,1,"If Admins can set their armor",0,1)
AddZetaConvar("zetaplayer_adminallowgoto",true,1,"If Admins can goto someone",0,1)
AddZetaConvar("zetaplayer_adminallowsetpos",true,1,"If Admins can set their position elsewhere",0,1)

AddZetaConvar("zetaplayer_profilesystemonly",true,0,"If Zetas should spawn using the profile system if possible",0,1)
AddZetaConvar("zetaplayer_allowfallingvoice",true,1,"If Zetas should speak when falling",0,1)

AddZetaConvar("zetaplayer_customfallinglinesonly",true,0,"If custom falling sounds should only be used",0,1)


AddZetaConvar("zetaplayer_customquestionlinesonly",true,0,"If custom question sounds should only be used",0,1)


AddZetaConvar("zetaplayer_customrespondlinesonly",true,0,"If custom respond sounds should only be used",0,1)


AddZetaConvar("zetaplayer_allowconversations",true,1,"If Zetas can walk up to somebody and have a conversation",0,1)


AddZetaConvar('zetaplayer_zetaarmor',true,0,"The amount of armor Zetas will spawn with",0,10000)
AddZetaConvar('zetaplayer_naturalzetaarmor',true,0,"The amount of armor Natural Zetas will spawn with",0,10000)
AddZetaConvar('zetaplayer_armorabsorbpercent',true,80,'How much percent of damage should zetas armor absorb',1,100)

AddZetaConvar('zetaplayer_startconversationchance',true,25,'The chance a zeta will look for someone to talk to when they attempt',1,100)
AddZetaConvar('zetaplayer_textchance',true,30,'The chance a zeta will type in text chat',0,100)
AddZetaConvar('zetaplayer_naturaltextchance',true,30,'The chance a zeta will type in text chat',0,100)
AddZetaConvar('zetaplayer_allowtextchat',true,1,'If Zetas are allowed to use text chat',0,1)

AddZetaConvar('zetaplayer_callonnpckilledhook',true,0,'If killed Zetas should call the onkilledhook',0,1)
AddZetaConvar('zetaplayer_alwaystargetnpcs',true,1,'If Zetas should always attack npcs regardless of combat chance',0,1)
AddZetaConvar('zetaplayer_customspawnsound',true,"",'Custom sound effect for when a zeta spawns')
AddZetaConvar('zetaplayer_customtextsendsound',true,"",'Custom sound effect for when a zeta sends a text message')
AddZetaConvar('zetaplayer_clearpath',true,0,'If Zetas should shoot objects that block the way and can break',0,1)
AddZetaConvar('zetaplayer_sourcecutdistance',true,800,'The distance Source cut can reach',100,10000)
AddZetaConvar('zetaplayer_allowsourcecut',true,0,'If Zetas can use Source Cut',0,1)


AddZetaConvar('zetaplayer_overridetextchance',true,0,'Override Text Chance Vars',0,1)
AddZetaConvar('zetaplayer_textchanceoverride',true,20,'The overriden chance of text chance',0,100)

AddZetaConvar('zetaplayer_fleefromsanics',true,0,'If Zetas should run away from sanic type nextbots',0,1)

AddZetaConvar('zetaplayer_allowrequestmedia',true,1,'If Zetas are allowed to request videos',0,1)

AddZetaConvar('zetaplayer_enablemoonbasettssupport',true,0,'If Zetas in text chat should use Moonbase tts if installed',0,1)

AddZetaConvar('zetaplayer_disablejumping',true,0,"If Zetas shouldn't jump over objects",0,1)

AddZetaConvar('zetaplayer_enableblockmodels',true,0,"If models that are considered block shouldn't be used",0,1)

AddZetaConvar('zetaplayer_customjoinsound',true,"zetaplayer/misc/zeta_nocon_sound.wav",'Custom sound effect for when a zeta joins the server')
AddZetaConvar('zetaplayer_customleavesound',true,"zetaplayer/misc/zeta_nocon_sound.wav",'Custom sound effect for when a zeta leaves the server')

AddZetaConvar('zetaplayer_fleefromdrgbasenextbots',true,0,"If Zetas should run from DRG Nextbots",0,1)

AddZetaConvar('zetaplayer_userealplayerdmgscale', true, 1, "If damage dealt to Zetas should scale like the real players one do.", 0, 1)

AddZetaConvar('zetaplayer_allowdstepssupport', true, 1, "If Zetas should use DSteps' footstep sounds if its installed", 0, 1)

AddZetaConvar('zetaplayer_ignorefriendlyfirebyzeta', true, 0, "If Zetas should ignore friendly fire caused by other zeta", 0, 1)

AddZetaConvar('zetaplayer_mwsspawnrespawningzetas', true, 0, "If Natural Zetas should respawn when they die", 0, 1)

AddZetaConvar('zetaplayer_allowkillbind', true, 0, "If Zetas are allowed to use their kill bind", 0, 1)

AddZetaConvar('zetaplayer_casuallooking', true, 0, "If Zetas should look around normally", 0, 1)

AddZetaConvar('zetaplayer_maxdisconnecttime', true, 600, "The max of time it will take before a Zeta decides to disconnect", 0, 3600)

AddZetaConvar('zetaplayer_displaynameRed',true,164,'Red value of the display name color',0,255)
AddZetaConvar('zetaplayer_displaynameGreen',true,182,'Green value of the display name color',0,255)
AddZetaConvar('zetaplayer_displaynameBlue',true,0,'Blue value of the display name color',0,255)

AddZetaConvar('zetaplayer_friendnamecolorR',true,0,"Friend Color",0,255)
AddZetaConvar('zetaplayer_friendnamecolorG',true,200,"Friend Color",0,255)
AddZetaConvar('zetaplayer_friendnamecolorB',true,0,"Friend Color",0,255)

AddZetaConvar('zetaplayer_playercolordisplaycolor', true, 0, "If display name colors should be based on the Zeta's Playermodel Color", 0, 1)

AddZetaConvar('zetaplayer_connectlines', true, 1, "If Zetas should say connect lines", 0, 1)
AddZetaConvar('zetaplayer_disconnectlines', true, 1, "If Zetas should say connect lines", 0, 1)

AddZetaConvar('zetaplayer_useservercacheddata', true, 0, "If Prop data and others should use the cache the server has saved", 0, 1)

AddZetaConvar('zetaplayer_allowinterrupting', true, 1, "If Zetas should send a message when they are interrupted", 0, 1)

AddZetaConvar('zetaplayer_forceradius',true, 700, "Radius for forcing certain actions on Zetaplayers", 150, 10000)

AddZetaConvar('zetaplayer_friendamount', true, 1, "How many friends a player or zeta can have at max", 1, 50)
AddZetaConvar('zetaplayer_allowfriendswithzetas', true, 0, "If Zetas are allowed to consider each other friends", 0, 1)
AddZetaConvar('zetaplayer_showhwosfriendwithwho', true, 0, "If Name Display should show who a zeta is friends with", 0, 1)
AddZetaConvar('zetaplayer_stickwithplayer', true, 0, "If Zetas who are friends with the player should always stick near them", 0, 1)
AddZetaConvar('zetaplayer_usefriendcolor', true, 1, "If Friend Zetas should use the friend color for their name display", 0, 1)
AddZetaConvar('zetaplayer_allowfriendswithplayers', true, 1, "If Zetas are allowed to consider players friends", 0, 1)
AddZetaConvar('zetaplayer_spawnasfriendchance', true, 10, "The chance a zeta will spawn as a friend to someone", 1, 100)
AddZetaConvar('zetaplayer_musicvisualizersamples', true, 4, "Amount of Sample the Visualizer will process. The higher the value the more smooth the visualizer will move", 0, 7)
AddZetaConvar('zetaplayer_enablemusicvisualizer', true, 0, "If Music Boxes should draw their Visualizers", 0, 1)
AddZetaConvar('zetaplayer_enabledynamiclightvisualizer', true, 0, "If Music Boxes should draw light with the music", 0, 1)
AddZetaConvar('zetaplayer_dancechance', true, 20, "The chance that Zetas will dance to music", 1, 100)
AddZetaConvar('zetaplayer_visualizerresolution', true, 100, "The resolution of the visualizer", 20, 200)


AddZetaConvar('zetaplayer_visualizerrenderdistance', true, 1500, "The distance the Visualizer is allowed to render", 200, 10000)

AddZetaConvar('zetaplayer_visualizerplayeronly', true, 0, "If the Visualizer should only be shown on music boxes spawned by a player", 0, 1)
AddZetaConvar('zetaplayer_surpressminormusicwarnings', true, 0, "If minor warnings should be surpressed", 0, 1)

AddZetaConvar('zetaplayer_allownoclip', true, 0, "If Zetas are allowed to noclip", 0, 1)
AddZetaConvar('zetaplayer_allowadminnoclip', true, 0, "If Admin Zetas are allowed to noclip", 0, 1)
AddZetaConvar('zetaplayer_allowpanicbhop', true, 0, "If Zetas should bhop when running away", 0, 1)

AddZetaConvar('zetaplayer_voicepackchance', true, 0, "The chance a Zeta will spawn with a voice pack", 0, 100)

AddZetaConvar('zetaplayer_friendvoicepack', true, "none", "Friend voice pack")

AddZetaConvar('zetaplayer_findpokertableonspawn', true, 0, "If Zetas should look for a poker table when they spawn", 0, 1)

AddZetaConvar('zetaplayer_allowwiregatetool', true, 1, "If Zetas are allowed to use the wire gate tool", 0, 1)
AddZetaConvar('zetaplayer_wiregatelimit', true, 10, "The amount of wire gates a zeta can spawn", 1, 100)

AddZetaConvar('zetaplayer_allowwirebuttontool', true, 1, "If Zetas are allowed to use the wire button tool", 0, 1)
AddZetaConvar('zetaplayer_wirebuttonlimit', true, 10, "The amount of wire buttons a zeta can spawn", 1, 100)

AddZetaConvar('zetaplayer_allowcreatingvotes', true, 0, "If Zetas are allowed to create votes", 0, 1)

AddZetaConvar('zetaplayer_motivatedkatana', true, 0, "Bury the light deep within!", 0, 1)

AddZetaConvar('zetaplayer_sticknearnonav', true, 0, "If Friend Zetas should not pick a random location based on navmesh", 0, 1)

AddZetaConvar('zetaplayer_allowjudgementcut', true, 0, "If Katana users can use Judgement Cut during combat", 0, 1)

AddZetaConvar('zetaplayer_waterairtime', true, 12, 'The amount of time zeta can swim in water before starting to drown', 1, 60)

AddZetaConvar('zetaplayer_eyetap_preventtilting', true, 1, "If the view from Zeta Eye Tapper shouldn't be tilted left and right", 0, 1)

AddZetaConvar('zetaplayer_usenewchancesystem', true, 0, "If the new chance system should be used", 0, 1)

AddZetaConvar('zetaplayer_teamsalwaysattack', true, 0, "If Teams should always attack each other", 0, 1)
AddZetaConvar('zetaplayer_spawnatteamspawns', true, 0, "If the player should spawn at their team spawn", 0, 1)
AddZetaConvar('zetaplayer_showkothpointsonhud', true, 0, "If KOTH points should show on your HUD", 0, 1)

AddZetaConvar('zetaplayer_10secondcountdownsound', true, "zetaplayer/koth/tensecond.mp3", "The sound that should play when the timer hits 10 seconds")
AddZetaConvar('zetaplayer_koth30secondssound', true, "zetaplayer/ctf/30seconds.mp3", "Sound that will play when the time reaches 30 seconds")

AddZetaConvar('zetaplayer_kothgameover', true, "zetaplayer/koth/loss.wav", "The sound that should play when game ends")
AddZetaConvar('zetaplayer_kothvictory', true, "zetaplayer/koth/won.wav", "The sound that should play when your team wins")
AddZetaConvar('zetaplayer_kothgamestart', true, "zetaplayer/koth/chooseteam.mp3", "The sound that should play when game starts")

AddZetaConvar('zetaplayer_kothmodetime', true, 190, "KOTH Time limit", 10)
AddZetaConvar('zetaplayer_kothcapturerate', true, 0.2, "The capture rate of koth points", 0.01, 5)
AddZetaConvar('zetaplayer_enablefriendlyfire', true, 0, "If friendly fire is enabled with teams", 0, 1)

AddZetaConvar('zetaplayer_ctfenemyflagstolensound', true, "zetaplayer/ctf/flagsteal.wav", "Sound that will play when a enemy flag is stolen")
AddZetaConvar('zetaplayer_ctfenemyflagcapturesound', true, "zetaplayer/ctf/flagcapture.wav", "Sound that will play when a enemy flag is captured")

AddZetaConvar('zetaplayer_ctfflagreturn', true, "zetaplayer/ctf/flagreturn.wav", "Sound that will play when a flag returns back to its zone")

AddZetaConvar('zetaplayer_ctfflagdropped', true, "zetaplayer/ctf/flagdropped.wav", "Sound that will play when a flag is dropped")

AddZetaConvar('zetaplayer_ctfourflagcapturesound', true, "zetaplayer/ctf/ourflagcaptured.wav", "Sound that will play when your team's flag is captured")
AddZetaConvar('zetaplayer_ctfourflagstolensound', true, "zetaplayer/ctf/ourflagstole.wav", "Sound that will play when your team's flag is stolen")

AddZetaConvar('zetaplayer_ctfmodetime', true, 280, "CTF Time limit", 10)
AddZetaConvar('zetaplayer_ctfcapturelimit', true, 3, "CTF Capture limit", 0)
AddZetaConvar('zetaplayer_ctf30secondssound', true, "zetaplayer/ctf/30seconds.mp3", "Sound that will play when the time reaches 30 seconds")
AddZetaConvar('zetaplayer_ctf10secondssound', true, "zetaplayer/ctf/10seconds.mp3", "Sound that will play when the time reaches 10 seconds")

AddZetaConvar('zetaplayer_ctfreturntime', true, 15, "CTF Capture limit", 0,120)


AddZetaConvar('zetaplayer_ctfgamestartsound', true, "zetaplayer/ctf/gamestart/*", "Sound that will play when the game starts")
AddZetaConvar('zetaplayer_ctfvictorysound', true, "zetaplayer/ctf/win/*", "Sound that will play when your team wins")
AddZetaConvar('zetaplayer_ctflosssound', true, "zetaplayer/ctf/loss/*", "Sound that will play when your team loses")

AddZetaConvar('zetaplayer_tdmmodetime', true, 280, "TDM Time limit", 10)
AddZetaConvar('zetaplayer_tdmkilllimit', true, 30, "TDM Time limit", 1)
AddZetaConvar('zetaplayer_tdm10killsremain', true, "zetaplayer/tdm/10killsleft.mp3", "Sound that will play when a team needs 10 more kills to win")
AddZetaConvar('zetaplayer_tdmgamestartsound', true, "zetaplayer/ctf/gamestart/*", "Sound that will play when the game starts")
AddZetaConvar('zetaplayer_tdm30secondssound', true, "zetaplayer/ctf/30seconds.mp3", "Sound that will play when the time reaches 30 seconds")
AddZetaConvar('zetaplayer_tdm10secondssound', true, "zetaplayer/ctf/10seconds.mp3", "Sound that will play when the time reaches 10 seconds")

AddZetaConvar('zetaplayer_tdmvictorysound', true, "zetaplayer/ctf/win/*", "Sound that will play when your team wins")
AddZetaConvar('zetaplayer_tdmlosssound', true, "zetaplayer/ctf/loss/*", "Sound that will play when your team loses")


AddZetaConvar('zetaplayer_textchatreceivedistance', true, 0, "How far you can receive text messages from Zetas. leave zero for global", 0, 10000)

AddZetaConvar('zetaplayer_grenade_throwchance', true, 25, "The chance of zeta to throw a grenade while panicking or in-combat", 0, 100)
AddZetaConvar('zetaplayer_grenade_switchtoweapon', true, 1, "If the zetas should switch to the grenade weapon in order to throw it instead of using the quicknade method", 0, 1)

AddZetaConvar('zetaplayer_flashbang_ignorethrower', true, 0, "If the flashbang should ignore the thrower", 0, 1)
AddZetaConvar('zetaplayer_flashbang_ignoreteammates', true, 0, "If the flashbang should ignore thrower's friends and teammates", 0, 1)
AddZetaConvar('zetaplayer_cssnades_changeweapons', true, 1, "If the Zetas should change their weapon once when they threw flashbang or smokegrenade", 0, 1)

AddZetaConvar('zetaplayer_voicepopup_useteamcolor', true, 1, "If the Zeta's voicechat popup should use its team color when currently in team", 0, 1)

AddZetaConvar('zetaplayer_eyetap_followcorpse', true, 1, "If the view from Zeta Eye Tapper should switch to zeta's corpse after death", 0, 1)

AddZetaConvar('zetaplayer_maxspeakingzetas', true, 0, "The amount of Zetas that can speak at the same time", 0, 100)

AddZetaConvar('zetaplayer_textchatslowtime', true, 0, "The time before a zeta can send a message in chat", 0, 10)

AddZetaConvar('zetaplayer_combataccuracylevel', true, 4, "The accuracy level of Zetas", 0, 4)

AddZetaConvar('zetaplayer_walkspeed', true, 200, "The walk speed", 100, 1500)
AddZetaConvar('zetaplayer_runspeed', true, 400, "The run speed", 100, 1500)

AddZetaConvar('zetaplayer_panelbgm', true, "", "Music that will play in the background while in a panel")

AddZetaConvar('zetaplayer_nohurtfriends', true, 0, "If friends should not be able to hurt each other", 0, 1)

AddZetaConvar('zetaplayer_paniconfire', true, 0, "If Zetas are on fire, they will panic", 0, 1)

AddZetaConvar('zetaplayer_allowprops', true, 1, "If Zetas are allowed to spawn props", 0, 1)

AddZetaConvar('zetaplayer_allowmedkits', true, 1, "If Zetas are allowed to spawn medkits to heal themselves or others", 0, 1)

AddZetaConvar('zetaplayer_allowarmorbatteries', true, 1, "If Zetas are allowed to spawn batteries to charge themselves or others", 0, 1)

AddZetaConvar('zetaplayer_timebasedmws', true, 0, "If MWS should dynamically change spawn times and zeta amount depending on your time", 0, 1)

AddZetaConvar('zetaplayer_teamsstickneareachother', true, 0, "If Teams should stick near each other", 0, 1)
AddZetaConvar("zetaplayer_teamsstickneardistance",true,300,"The distance Zetas can wander from their friend",0,15000)

AddZetaConvar('zetaplayer_noplycollisions', true, 0, "If Zetas are allowed to pass through the player", 0, 1)

AddZetaConvar('zetaplayer_building_nocollideprops', true, 0, "If Zetas manually building a dupe should no collide props before placing them into position", 0, 1)
AddZetaConvar('zetaplayer_building_allowduplications', true, 1, "If Zetas are allowed to spawn/build dupes", 0, 1)
AddZetaConvar('zetaplayer_building_useplayerdupes', true, 0, "If Zetas are allowed to use any and all dupes you have", 0, 1)
AddZetaConvar('zetaplayer_building_dupecooldown', true, 120, "The time until a zeta can spawn another duplication", 0, 1000)
AddZetaConvar('zetaplayer_building_allowaddingontoprops', true, 0, "If Zetas are allowed to build props on another prop", 0, 1)
AddZetaConvar('zetaplayer_building_placedupesinopenareas', true, 0, "If Zetas should only place dupes when they are in open spaces", 0, 1)
AddZetaConvar('zetaplayer_building_dupebuildmode', true, 0, "How should the zetas build dupes. 0 is for random between manual building and toolgun spawned dupes. 1 is for manual building only. 2 is for toolgun spawned dupes only", 0, 2)

AddZetaConvar('zetaplayer_building_buildconstraintsound', true, "zetaplayer/misc/buildconstraint.wav", "The sound that will play when a constraint is created in a dupe")
AddZetaConvar('zetaplayer_building_buildentitysound', true, "garrysmod/content_downloaded.wav", "The sound that will play when a entity is created in a dupe")
AddZetaConvar('zetaplayer_building_finishdupesound', true, "garrysmod/save_load1.wav", "The sound that will play when a dupe finishes building")

AddZetaConvar('zetaplayer_usepanicanimation', true, 1, "If panicking Zetas should use the panic animation", 0, 1)

AddZetaConvar('zetaplayer_zetaspawnerspawnatplayerspawns', true, 0, "If respawning Zetas should respawn at random player spawnpoints", 0, 1)

AddZetaConvar('zetaplayer_profileusechance', true, 0, "The chance a zeta will spawn using a random profile", 0, 100)

AddZetaConvar("zetaplayer_paig_sentrybustermode", true, 0, "If PAIG should use sounds and mechanics from TF2's Sentry Buster", 0, 1)

AddZetaConvar("zetaplayer_experimentalcombat", true, 0, "Enables the experimental combat behavior to zetas.", 0, 1)

AddZetaConvar("zetaplayer_textmixing", true, 0, "If text should be modified by sentence mixing", 0, 1)

-- DEBUG CONVARS
    AddZetaConvar('zetaplayer_debug_warnrapidstatechange', false, 0, "If rapid state changes should be warned", 0, 1)
    AddZetaConvar('zetaplayer_debug_displayspawntime', false, 0, "If the time it takes for a zeta to initialize and start their ai", 0, 1)
    AddZetaConvar('zetaplayer_debug_displaypathfindingpaths', false, 0, "If paths Zetas use for pathfinding should be rendered", 0, 1)
-- 



-- I was wondering why MWS wasn't working. turns out convars were not set yet
if SERVER then
    include("zeta/mapwidespawning.lua")
end



function ZetaGetTeamColor(zetateam)
    local teamdata = file.Read("zetaplayerdata/teams.json")
    teamdata = util.JSONToTable(teamdata)
    local foundteam = nil
    for i=1, #teamdata do
        if teamdata[i][1] == zetateam then
            foundteam = teamdata[i]
            break
        end
    end
    if istable(foundteam) then
        return foundteam[2]
    else
        return nil
    end
end

function ZetaGetTeamSpawns(zetateam)
    local teamspawns = ents.FindByClass("zeta_teamspawnpoint")
    local spawns = {}
  
    for i=1, #teamspawns do
      if teamspawns[i]:GetTeamSpawn() == zetateam then
        spawns[#spawns+1] = teamspawns[i]
      end
    end
  
    return spawns
  end

  

if ( CLIENT ) then

    
    include("zeta/zetaspawnmenusettings.lua")


    local zetarender = {}
    local draw = draw
    local surface = surface
    local Material = Material












    voiceChannels = {}
    speakingZetas = {}



    zetarender.SetMaterial = render.SetMaterial
    zetarender.DrawScreenQuadEx = render.DrawScreenQuadEx


    -- Saving these color objects once so they don't get recreated many times in a rendering hook
    -- This is nice optimization
    local zetaname_color = Color(0,0,0)
    local voicechat_color = Color(0,0,0)
    local voicechat_whitecolor = Color(255,255,255,255)
    local voicechat_whitecolor2 = Color(255,255,255,255)
    local zetavoicechat_black = Color(0,0,0,255)
    local zetatabmenu_color = Color(0,0,0)
    local zetafriend_text = Color(0,0,0)
    local zetateam_color = Color(0,0,0)
    local zetadisplay_name = Color(0,0,0)
    local zeta_halos = Color(0,0,0)

    local playerspeaking = false
    local playerspeakenddur = RealTime()+0.1
    local playervoicepopupexists = false


    if game.SinglePlayer() then
        local limit = false

        hook.Add("Think","zetaplayervoicechatthink",function()
            local playervoicechatbind = input.LookupBinding("+voicerecord")
            local numbind = playervoicechatbind and input.GetKeyCode(playervoicechatbind) or KEY_X
            
            if input.IsKeyDown( numbind ) and !limit then
                hook.Run("PlayerStartVoice",LocalPlayer())
                limit = true
                playerspeaking = true
                if !playervoicepopupexists then
                    table.insert(speakingZetas,LocalPlayer())
                end
            elseif !input.IsKeyDown( numbind ) and limit then
                hook.Run("PlayerEndVoice",LocalPlayer())
                limit = false
                playerspeakenddur = RealTime()+0.1
                playerspeaking = false
                net.Start("zeta_realplayerendvoice",true)
                net.SendToServer()
            end
        end)

        hook.Add("PlayerStartVoice","zetanodefaultvoiceicon",function(ply)
            return true
        end)
    end




    if !file.Exists('zetaplayerdata/zeta_viewshots','DATA') then
        file.CreateDir('zetaplayerdata/zeta_viewshots')
    end

    
    AddZetaConvar('zetaplayer_displayzetanames',true,1,'If Zetas should show their names when you hover over them',0,1)
    AddZetaConvar('zetaplayer_showfriends',true,1,'Show a Friend Tag above a Zeta who has considered you a friend',0,1)
    AddZetaConvar('zetaplayer_displayarmor',true,0,'If name displays should show armor',0,1)
    AddZetaConvar('zetaplayer_frienddisplaydistance',true,1400,'Distance to display the Friend Tag',0,10000)
    AddZetaConvar('zetaplayer_displaynamerainbow',true,0,'If the display names should change color linearly',0,1)
    AddZetaConvar('zetaplayer_drawvoiceicon',true,1,'If the Voice Icons should appear',0,1)
    AddZetaConvar('zetaplayer_drawfriendhalo',true,1,'If a Friend Zeta should have a halo drawn over it',0,1)
    AddZetaConvar('zetaplayer_drawfriendhalothroughworld',true,0,"If a Friend Zeta's halo should draw through the world",0,1)
    AddZetaConvar('zetaplayer_drawflashlight',true,1,'If Zeta Flashlights should draw',0,1)
    AddZetaConvar('zetaplayer_showconnectmessages',true,0,'If newly spawned Zetas should send a connect message in chat',0,1)
    AddZetaConvar('zetaplayer_zetascreenshotfov',true,90,'The FOV of the screenshots',10,180)
    AddZetaConvar('zetaplayer_zetascreenshotfiletype',true,'jpg','The file type of the screenshot')
    AddZetaConvar('zetaplayer_zetascreenshotchance',true,10,'The chance of a View Shot will render and saved each time a Zeta requests a view shot')
    AddZetaConvar('zetaplayer_voicepopupdrawdistance',true,0,'The distance a voice popup will be drawn. Set this to 0 for unlimited',0,15000)


    AddZetaConvar('zetaplayer_voicepopup_x',true,1.17,'Screencord',0,100)
    AddZetaConvar('zetaplayer_voicepopup_y',true,1.15,'Screencord',0,100)


    AddZetaConvar('zetaplayer_drawteamhalo',true,1,'If a team member should have a halo drawn over it',0,1)
    AddZetaConvar('zetaplayer_drawteamname',true,1,"If a team member should have it's team drawn over it",0,1)
    AddZetaConvar('zetaplayer_drawteamhalothroughworld',true,0,"If a team member's halo should draw through the world",0,1)
    AddZetaConvar('zetaplayer_teamnamedrawdistance',true,1400,'Distance to display the Team Tag',0,10000)
    AddZetaConvar('zetaplayer_teamcolorRed',true,0,'Red value of the team color',0,255)
    AddZetaConvar('zetaplayer_teamcolorGreen',true,180,'Green value of the team color',0,255)
    AddZetaConvar('zetaplayer_teamcolorBlue',true,180,'Blue value of the team color',0,255)







    concommand.Add('zetaplayer_cleanviewshotfolder',CleanViewShotFolder,nil,'Cleans the View Shot Folder')


    local refresh = CurTime()+0.2
    local SpawnedZetas 


    --if GetConVar("zetaplayer_usenewvoicechatsystem"):GetInt() == 1 then  

    net.Receive("zeta_changevoicespeaker", function()
        local old = net.ReadEntity()
        local oldID = net.ReadInt(32)
        local new = net.ReadEntity()
        
        hook.Remove('PreDrawEffects','zetavoiceicon'..oldID)
    
        if #voiceChannels > 0 then 
            for _, v in pairs(voiceChannels) do
                if v[5] == old then
                    v[5] = new
    
                    local time = (v[4] - v[1]:GetTime())
                    if time > 0 then
                        net.Start("zeta_sendvoiceicon", true)
                            net.WriteEntity(new)
                            net.WriteFloat(time)
                        net.SendToServer()
                    end
                    
                    break
                end
            end
        end
    end)
    
    net.Receive("zeta_removevoicepopup",function()
        local ID = net.ReadInt(32)
        for k,tbl in ipairs(speakingZetas) do
            if tbl[1] == ID then
                table.remove(speakingZetas,k)
            end
        end
    
    end)

    hook.Add('Tick', 'zeta_checkVoiceChannel', function()
        if #voiceChannels <= 0 then return end
	for k, v in pairs(voiceChannels) do
		local audio = v[1]
		if !audio:IsValid() then table.remove(voiceChannels, k) continue end
	
		local src = v[5]
		local len = v[4]
		local remove = v[6]
		
		-- This code prevents jaw to be wide open when sound ends with high sound level
		if src:IsValid() and audio:GetTime() >= len then src:MoveMouth(0) end
		
		-- The '+ 2.0' is to prevent voice popups appear when fading out and far away
		if audio:GetTime() >= len + 2.0 or remove == true and !src:IsValid() then
			audio:Stop()
			table.remove(voiceChannels, k)
			continue
		end
		
		local leftC, rightC = audio:GetLevel()
		local voiceLvl = ((leftC + rightC) / 2)
		v[3] = voiceLvl

		if src:IsValid() then
			audio:SetPos(src:GetPos())
			
			-- Such a mess... Just to make jaw always be wide open no matter the audio's level 
			v[7] = v[7] or 0.0
			v[8] = v[8] or RealTime()
			v[9] = v[9] or 0.0
			if RealTime() <= v[8] then
				if voiceLvl > v[7] then
					v[7] = voiceLvl 
				end
			else
				v[7] = 0.0
				v[8] = RealTime() + 1
			end
			
			v[9] = (v[7] <= 0.2 and v[9] or (voiceLvl / v[7]))
			
			-- Debugging code, you may remove it if you want to
			if src.IsZetaPlayer and GetConVar("developer"):GetInt() == 1 then
				local debugattach = src:GetAttachmentPoint("eyes")
				debugoverlay.Text(debugattach.Pos - Vector(0,0,3), "Jaw Value: "..math.Round(v[9], 2).."; "..math.Round(v[7], 2), 0)
			end	
			
			src:MoveMouth(v[9])
		end
	end
    end)

    net.Receive('zeta_playvoicesound',function()
        local zeta = net.ReadEntity()
        if !zeta or !zeta:IsValid() or zeta.IsDead == true then return end

        local ragdoll = zeta.DeathRagdoll
        if !IsValid(ragdoll) then ragdoll = zeta:GetNW2Entity('zeta_ragdoll', NULL) end
        if IsValid(ragdoll) then zeta = ragdoll end

        local ID = net.ReadInt(32)
        local sndName = net.ReadString()
        local playType = net.ReadString()
        local stopPlaying = net.ReadBool()
        local pitch = net.ReadInt(32)
        local pos = zeta:GetPos()
        

        if voiceChannels and #voiceChannels > 0 then
            for k, v in pairs(voiceChannels) do
                if v[2] == ID then
                    v[1]:Stop()
                    table.remove(voiceChannels, k)
                    break
                end
            end
        end

        local ragdoll = zeta.DeathRagdoll
        if !IsValid(ragdoll) then ragdoll = zeta:GetNW2Entity('zeta_ragdoll', NULL) end
        if IsValid(ragdoll) then zeta = ragdoll end

        sound.PlayFile(sndName, playType, function(speech, errorId, errorName)
            if IsValid(speech) then
                speech:SetVolume(GetConVar('zetaplayer_voicevolume'):GetFloat())
                speech:SetPlaybackRate((pitch/100))
                speech:SetPos(pos)
                

                table.insert(voiceChannels, {speech, ID, 0, speech:GetLength(), zeta, stopPlaying})
            else
                local errorcomment = "None"
                if errorName == "BASS_ERROR_NO3D" then
                    errorcomment = "This Error happens when a sound file has a Stereo Channel.\nTurn the indicated Sound File to Mono to prevent this from happening"
                elseif errorName == "BASS_ERROR_FILEOPEN" then
                    errorcomment = "Check the folder the sound file is from and make sure it is evenly sequential! Example, idle1 idle2 idle3 ect.. Make sure you placed the files in the right directory as well incase the first advice didn't work!"
                end
                print("Zeta VoiceChat V2: Audio Channel Error ID",errorId," Error Name ", errorName, " Sound file is, ",sndName,"\nDeveloper Comment: "..errorcomment)
            end
        end)
    end)


    net.Receive("zeta_voicepopup",function()
        local name = net.ReadString()
        local finalname = name
        if #name >= 20 then
            local trim = string.Left( name, 17 ).."..."
            finalname = trim
        end
        local model = net.ReadString()
        local dur = net.ReadFloat()
        local ID = net.ReadInt(32)
        local color = net.ReadColor()
        local mat

        if model != nil then

            if string.Explode("/",model)[4] == "custom_avatars" then
                mat = Material(model)

                if mat:IsError() then
                    mat = Material("spawnicons/"..string.sub(model,1,#model-4)..".png")
                    if mat:IsError() then
                        mat = Material("entities/npc_zetaplayer.png")
                    end
                end

            else
                mat = Material(model)

                if mat:IsError() then
                mat = Material("spawnicons/"..string.sub(model,1,#model-4)..".png")

                if mat:IsError() then
                    mat = Material("entities/npc_zetaplayer.png")
                end
                
             end

            end

        else
            mat = Material("entities/npc_zetaplayer.png")
        end


        if GetConVar("zetaplayer_usenewvoicechatsystem"):GetInt() == 1 then
            if #speakingZetas > 0 then
                for k,tbl in ipairs(speakingZetas) do
                    if tbl[2] == finalname then
                        tbl[4] = RealTime() + dur
                        return
                    end
                end
            end
        
        speakingZetas[#speakingZetas+1] = {ID,finalname,mat,RealTime()+dur,RealTime(),color}

    else
        local index = #speakingZetas+1
        speakingZetas[index] = {ID,finalname,mat}
        timer.Simple(dur,function()
            for k,tbl in ipairs(speakingZetas) do
                if tbl[1] == ID then
                    table.remove(speakingZetas,k)
                end
            end
        end)
        end
    end)

    local canprint = true
    local canprintTAB = true

    local logevents = {}

    net.Receive("zeta_sendonscreenlog",function()
        local log = net.ReadString()
        local color = net.ReadColor(false)
        table.insert(logevents, {log = log,dur = CurTime()+3,alpha = 255,color = color})
    end)

    local function GetClientZetaFriends()
        local zetas = ents.FindByClass("npc_zetaplayer")
        local friends = {}

        for _,ply in ipairs(zetas) do
            local isfriend = ply:GetNW2Bool("zeta_showfriendstat",false)
            if isfriend then
                table.insert(friends,ply)
            end
        end

        return friends
    end

    local showlist = false
    hook.Add("KeyRelease","zetascorehide",function(ply,key)
        if key == IN_SCORE then
            showlist = false
        end
    end)


    hook.Add("KeyPress","zetascoreshow",function(ply,key)
        if key == IN_SCORE then
            showlist = true
        end
    end)



    surface.CreateFont( "ZetaKothTime", {
        font = "ChatFont",
        extended = false,
        size = 25,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    } )






    hook.Add('HUDPaint','_zetahudpaint',function() -- Show Zeta stuff
        
        if GetGlobalBool("_ZetaKOTH_Gameactive") or GetGlobalBool("_ZetaCTF_Gameactive") or GetGlobalBool("_ZetaTDM_Gameactive") then
            local w = ScrW()/2
            local h = ScrH()/50
            local time = string.FormattedTime( GetGlobalInt("_ZetaKOTH_time",0), "%02i:%02i:%02i" )
            draw.SimpleTextOutlined("Time: "..time,"ZetaKothTime",w,h,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,color_black)
        end


        if GetConVar("zetaplayer_showkothpointsonhud"):GetBool() then
        local kothpoints = ents.FindByClass("zeta_koth")
            if #kothpoints > 0 then
                for i=1,#kothpoints do
                    local w = ScrW()/50
                    local h = (ScrH()/2)-i*20
                    draw.SimpleTextOutlined(kothpoints[i]:GetNW2String("zetakoth_identity","A0"),"ChatFont",w,h,kothpoints[i]:GetNW2Vector("zetakoth_color",Vector(1,1,1)):ToColor(),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,color_black)
                end
            end
        end

        if #logevents > 0 then
            for index,logdata in ipairs(logevents) do
                local y = ScrH()/50

                y = y + 15*index

                
                

                if logdata.dur < CurTime() then
                    logdata.alpha = logdata.alpha - 5
                    logdata.color.a = logdata.alpha
                    if logdata.alpha <= 0 then
                        
                        table.remove(logevents, index)
                    end
                end


                

                


                draw.TextShadow( {
                    text = logdata.log,
                    pos = {ScrW()/50,y},
                    font = "DebugFixedSmall",


                    color = logdata.color
                }, 1.2, logdata.alpha )
                --draw.DrawText( logdata.log, "DebugFixedSmall", ScrW()/50, y, Color(255,255,255,255), TEXT_ALIGN_LEFT )
                
            end
        end



        if GetConVar("zetaplayer_usenewvoicechatsystem"):GetInt() == 1 then
            if #speakingZetas > 0 then
                // Since now voice popups are able to not show when too far, instead of using table's index, create new local variable
                local popupCount = 1
                for index,vcdata in ipairs(speakingZetas) do
                    local x,y = ScrW()/GetConVar("zetaplayer_voicepopup_x"):GetFloat(), ScrH()/GetConVar("zetaplayer_voicepopup_y"):GetFloat()
                    y = y + popupCount*-60
                    local alpha = 255


                    if IsValid(vcdata) and vcdata:IsPlayer() then  -- This is somewhat hacky but it works
                        playervoicepopupexists = true
                        popupCount = popupCount + 1


                        if !IsValid(LocalPlayer()._zetaAvatar) then
                            LocalPlayer()._zetaAvatar = vgui.Create( "AvatarImage" )
                            LocalPlayer()._zetaAvatar:SetSize( 32, 32 )
                            LocalPlayer()._zetaAvatar:SetPos( x + 5, y + 9 )
                            LocalPlayer()._zetaAvatar:SetPlayer( LocalPlayer(), 32 )
                        end
                        if !playerspeaking then
                            alpha = (alpha - (RealTime() - playerspeakenddur) * 127.5)
                        end
                        if alpha <= 0 then
                            playervoicepopupexists = false
                            table.remove(speakingZetas, index)
                            LocalPlayer()._zetaAvatar:Remove()
                        else
                            voicechat_color.g = 0
                            voicechat_color.a = alpha
                            draw.RoundedBox( 4, x, y, 230, 50, voicechat_color )

                            LocalPlayer()._zetaAvatar:SetPos( x + 5, y + 9 )
                            LocalPlayer()._zetaAvatar:SetAlpha(alpha)

                            //render.SetMaterial(icon)
                            //render.DrawScreenQuadEx( x+5,   y+9, 32, 32 )
                            voicechat_whitecolor2.a = alpha
                            --surface.SetDrawColor(voicechat_whitecolor2)
                            --surface.SetMaterial(icon)
                            --surface.DrawTexturedRect(x + 5, y + 9, 32, 32)
                            voicechat_whitecolor.a = alpha
                            draw.DrawText( LocalPlayer():GetName(), "Trebuchet24", x+40, y+12, voicechat_whitecolor, TEXT_ALIGN_LEFT )
                        end
                        continue
                    end 


                    
                    local ID = vcdata[1]
                    local name = vcdata[2]
                    local icon = vcdata[3]
                    local dur = vcdata[4]
                    local color = vcdata[6]
                    

                    if GetConVar('zetaplayer_globalvoicechat'):GetInt() == 0 and (RealTime() - vcdata[5]) < 0.2 then continue end

                    

                    -- Use the new local variable instead of table's index
                    

                    local popColor = Color(0, 0, 0)
                    local tooFar = false
                    for k, v in pairs(voiceChannels) do
                    
                        if v[2] == ID then
                            if v[1]:Is3D() and GetConVar("zetaplayer_voicepopupdrawdistance"):GetInt() != 0 and v[1]:GetPos():Distance(LocalPlayer():GetPos()) > GetConVar("zetaplayer_voicepopupdrawdistance"):GetInt() then
                                -- If global chat is off and player if too far from speaker, don't show voice popup
                                tooFar = true
                            else
                                // Turn the box green depending on sound volume
                                popColor = Color(color.r * v[3], color.g * v[3], color.b * v[3])
                            end
                    
                            break;
                        end
                    end
                    
                    if alpha > 0 and !tooFar then
                    -- Increment the new local variable
                    popupCount = popupCount + 1
                    end

                    // Slowly fadeout

                    if !dur then return end
                    if RealTime() > dur then
                        alpha = (tooFar == true) and 0 or (alpha - (RealTime() - dur) * 127.5)
                    end
                    if alpha <= 0 then
                        table.remove(speakingZetas, index)
                    elseif !tooFar then
                        voicechat_color = Color(popColor.r, popColor.g, popColor.b, alpha-15) 
 
                        draw.RoundedBox( 4, x, y, 230, 50, voicechat_color )

                        //render.SetMaterial(icon)
                        //render.DrawScreenQuadEx( x+5,   y+9, 32, 32 )
                        voicechat_whitecolor2.a = alpha
                        surface.SetDrawColor(voicechat_whitecolor2)
                        surface.SetMaterial(icon)
                        surface.DrawTexturedRect(x + 5, y + 9, 32, 32)
                        voicechat_whitecolor.a = alpha
                        draw.DrawText( name, "Trebuchet24", x+40, y+12, voicechat_whitecolor, TEXT_ALIGN_LEFT )
                    end
                end
--[[                 for index,vcdata in ipairs(speakingZetas) do
                    local ID = vcdata[1]
                    local name = vcdata[2]
                    local icon = vcdata[3]

                    local x,y = ScrW()/GetConVar("zetaplayer_voicepopup_x"):GetFloat(), ScrH()/GetConVar("zetaplayer_voicepopup_y"):GetFloat()

                    y = y + index*-60

                    // Turn the box green depending on sound volume
                    local green = 0
                    for k, v in pairs(voiceChannels) do
                        if v[2] == ID then
                            green = 255 * v[3]
                            break;
                        end
                    end

                  draw.RoundedBox( 4, x, y, 230, 50, Color(0,green,0,255) )
                    
                    render.SetMaterial(icon)
                    render.DrawScreenQuadEx( x+5,   y+9, 32, 32 )

                    draw.DrawText( name, "Trebuchet24", x+40, y+12, Color(255,255,255), TEXT_ALIGN_LEFT ) 

                    // Slowly fadeout
                    local dur = vcdata[4]
                    local alpha = 255
                    if !dur then return end
                    if CurTime() > dur then
                        alpha = alpha - (CurTime() - dur) * 127.5
                    end
                    if alpha <= 0 then
                        table.remove(speakingZetas, index)
                    else
                        draw.RoundedBox( 4, x, y, 230, 50, Color(0,green,0,alpha-15) )

                        //render.SetMaterial(icon)
                        //render.DrawScreenQuadEx( x+5,   y+9, 32, 32 )

                        surface.SetDrawColor(255, 255, 255, alpha)
                        surface.SetMaterial(icon)
                        surface.DrawTexturedRect(x + 5, y + 9, 32, 32)

                        draw.DrawText( name, "Trebuchet24", x+40, y+12, Color(255,255,255,alpha), TEXT_ALIGN_LEFT )
                    end
                    
                end ]]

            end
        else
        if #speakingZetas > 0 then -- My system
            for index,vcdata in ipairs(speakingZetas) do

                local x,y = ScrW()/GetConVar("zetaplayer_voicepopup_x"):GetFloat(), ScrH()/GetConVar("zetaplayer_voicepopup_y"):GetFloat()

                y = y + index*-60
                if IsValid(vcdata) and vcdata:IsPlayer() then

                    if !IsValid(LocalPlayer()._zetaAvatar) then
                        LocalPlayer()._zetaAvatar = vgui.Create( "AvatarImage" )
                        LocalPlayer()._zetaAvatar:SetSize( 32, 32 )
                        LocalPlayer()._zetaAvatar:SetPos( x + 5, y + 9 )
                        LocalPlayer()._zetaAvatar:SetPlayer( LocalPlayer(), 32 )
                    end

                    if !playerspeaking then
                        table.remove(speakingZetas,index)
                        LocalPlayer()._zetaAvatar:Remove()
                    end

                    LocalPlayer()._zetaAvatar:SetPos( x + 5, y + 9 )

                    draw.RoundedBox( 4, x, y, 230, 50, zetavoicechat_black )
    
                    draw.DrawText( LocalPlayer():GetName(), "Trebuchet24", x+40, y+12, color_white, TEXT_ALIGN_LEFT )

                    continue
                end
                local name = vcdata[2]
                local icon = vcdata[3]

                
                draw.RoundedBox( 4, x, y, 230, 50, zetavoicechat_black )
                zetarender.SetMaterial(icon)
                zetarender.DrawScreenQuadEx( x+5,   y+9, 32, 32 )

                draw.DrawText( name, "Trebuchet24", x+40, y+12, color_white, TEXT_ALIGN_LEFT )
                
            end

        end
    end -- Voicechat system end
                   




        local candrawlist = hook.Run("ZetaDrawTabZetaList")

        if !candrawlist then

            if showlist then
                if CurTime() > refresh then
                    SpawnedZetas = ents.FindByClass('npc_zetaplayer')
                    refresh = CurTime()+0.2
                end
                local zetacount
                local r,g,b
    
                if #SpawnedZetas == 0 then
                    zetacount = 'None Existing Zetas'
                else
                    zetacount = 'Active Zetas '..#SpawnedZetas
                end
    
            
    
                -- Draw Title
            draw.SimpleTextOutlined('Zeta Players | '..zetacount, 'Trebuchet24', ScrW()/80, ScrH()/40, color_white, nil, nil, 1, color_black)

            for index,zeta in ipairs(SpawnedZetas) do
                if !IsValid(zeta) then continue end
                local mult 
                if GetConVar("zetaplayer_showprofilepicturesintab"):GetInt() == 1 and GetConVar("zetaplayer_usecustomavatars"):GetInt() == 1 then
                    mult = 30
                else
                    mult = 18
                end
                local row = (ScrH()/20)+index*mult
                local add = ''
                local teamadd = ''
                local adminadd = ""
                local isfriend = zeta:GetNW2Bool("zeta_showfriendstat",false)
                local name = zeta:GetNW2String('zeta_name','Zeta Player {could not get real name}')
                if isfriend then
                    add = '{ Friend }'
                else
                    add = ''
                end


                if zeta:GetNW2Bool("zeta_isadmin",false) then adminadd = "  | ADMIN " end

                if IsInTeam(zeta) then
                    teamadd = '{ '..GetConVar('zetaplayer_playerteam'):GetString()..' Member }'
                else
                    teamadd = ''
                end

                local r,g,b = zeta:GetColorByRank()

                zetatabmenu_color.r = r
                zetatabmenu_color.g = g
                zetatabmenu_color.b = b
                draw.SimpleTextOutlined(name..' '..add..' '..teamadd..adminadd, 'ChatFont', ScrW()/40, row, zetatabmenu_color, nil, nil, 0.1, color_black)
                surface.SetDrawColor( 0, 0, 0, 100 )
                local finalname = name..' '..add..' '..teamadd..adminadd
                surface.DrawRect(ScrW()/45, row,0+#finalname*9,20)

                if GetConVar("zetaplayer_showprofilepicturesintab"):GetInt() == 1 and GetConVar("zetaplayer_usecustomavatars"):GetInt() == 1 then
                    if IsValid(zeta) then
                        local pfp = zeta:GetNW2String('zeta_profilepicture',"none")
                        

                        if pfp != "none" then

                            if !zeta.zetapfpcache then
                                local mat = Material(pfp)
                                zeta.zetapfpcache = mat
                            end
                            zetarender.SetMaterial(zeta.zetapfpcache)
                            zetarender.DrawScreenQuadEx( ScrW()/200, row, 30, 30 )
                            if zeta.zetapfpcache:IsError() and canprintTAB then
                                canprintTAB = false
                            end
                        end
                    end
                end

            end

        end

        end


        if GetConVar('zetaplayer_showfriends'):GetInt() == 1 then
            local friends = GetClientZetaFriends()

            for _,zeta in ipairs(friends) do
                if zeta:IsValid() and zeta:GetPos():Distance(LocalPlayer():GetPos()) <= GetConVar('zetaplayer_frienddisplaydistance'):GetInt() and util.TraceLine({start = LocalPlayer():EyePos(),endpos = zeta:GetPos()+zeta:OBBCenter(),filter = function(ent) if ent == zeta then return true end end}).Entity == zeta then
                    local pos = zeta:GetPos()+Vector(0,0,95)
                    local screen = pos:ToScreen()
                    local r,g,b = zeta:GetColorByRank()
                    zetafriend_text.r = r
                    zetafriend_text.g = g
                    zetafriend_text.b = b
                    draw.DrawText('Friend','ChatFont',screen.x,screen.y,GetConVar("zetaplayer_usefriendcolor"):GetBool() and zetafriend_text or Color(r,g,b),TEXT_ALIGN_CENTER)
                end
            end
        end


        if GetConVar('zetaplayer_drawteamname'):GetInt() == 1 then
            local teammates = GetTeamMembers()

            for k,zeta in ipairs(teammates) do
               if IsValid(zeta) and zeta:GetPos():Distance(LocalPlayer():GetPos()) <= GetConVar('zetaplayer_teamnamedrawdistance'):GetInt() and util.TraceLine({start = LocalPlayer():EyePos(),endpos = zeta:GetPos()+zeta:OBBCenter(),filter = function(ent) if ent == zeta then return true end end}).Entity == zeta then
                   local pos = zeta:GetPos()+Vector(0,0,90)
                   local screen = pos:ToScreen()
                   local r,g,b = zeta:GetColorByRank()
                   zetateam_color.r = r
                   zetateam_color.g = g
                   zetateam_color.b = b
                    draw.DrawText(GetConVar('zetaplayer_playerteam'):GetString()..' Member','ChatFont',screen.x,screen.y,zetateam_color,TEXT_ALIGN_CENTER)
               end
            end
           end



        if GetConVar('zetaplayer_displayzetanames'):GetInt() == 0 then return end
        local w,h = ScrW(),ScrH()
        local trace = LocalPlayer():GetEyeTrace()
        local traceent = trace.Entity


        if IsValid(traceent) and traceent:GetClass() == 'npc_zetaplayer' then
            local r,g,b = traceent:GetColorByRank()
            zetadisplay_name.r = r
            zetadisplay_name.g = g
            zetadisplay_name.b = b
            local addname = ""
            local teamadd = ""
            if traceent:GetNW2String("zeta_team","") != "" then teamadd = " | "..traceent:GetNW2String("zeta_team","").." Member" end
            if traceent:GetNW2Bool("zeta_isadmin",false) then addname = "  | ADMIN " end

            local name = traceent:GetNW2String('zeta_name','Zeta Player')..teamadd..addname
 



            draw.DrawText(name,'ChatFont',w/2,h/2,zetadisplay_name,TEXT_ALIGN_CENTER)
            draw.DrawText(traceent:GetNW2Float('zeta_health','NAN')..'%','ChatFont',w/2,h/1.93,zetadisplay_name,TEXT_ALIGN_CENTER)
            
            if GetConVar("zetaplayer_displayarmor"):GetInt() == 1 then
                local armor = traceent:GetNW2Int("zeta_armor",0)
                draw.DrawText("Armor: "..armor..' %','ChatFont',w/2,h/1.85,zetadisplay_name,TEXT_ALIGN_CENTER)
            end

            local friendlist = traceent:GetNW2String("zeta_friendlist","none")
            if friendlist != "none" then
                draw.DrawText(friendlist, 'ChatFont', w/2, h/1.77, zetadisplay_name, TEXT_ALIGN_CENTER)
            end

            if GetConVar("zetaplayer_showpfpoverhealth"):GetInt() == 1 and game.SinglePlayer() then
                local pfp = traceent:GetNW2String('zeta_profilepicture',"none")
                    

                if pfp != "none" then
                    if !traceent.zetapfpcache then
                        local mat = Material(pfp)
                        traceent.zetapfpcache = mat
                    end
                    if traceent.zetapfpcache then
                        zetarender.SetMaterial(traceent.zetapfpcache)
                        zetarender.DrawScreenQuadEx( w/2+5*#name, h/2 , 40, 40 )
                        if traceent.zetapfpcache:IsError() and canprint then
                            canprint = false
                        end
                    end
                end

            end

        else
            canprint = true
        end

    end)


    hook.Add('PreDrawHalos','zetaHalos',function()

        if GetConVar('zetaplayer_drawteamhalo'):GetInt() == 1 then  
            local team_mates = GetTeamMembers()
           -- print(#team_mates)
           local dummyent = team_mates[math.random(#team_mates)]
            if #team_mates > 0 then

                local r,g,b = dummyent:GetColorByRank()
                halo.Add(team_mates,Color(r,g,b),1,1,2,true,GetConVar('zetaplayer_drawteamhalothroughworld'):GetBool())
            end
        end



        if GetConVar('zetaplayer_drawfriendhalo'):GetInt() == 1 then  
            local friends = GetClientZetaFriends()
            
            for _,zeta in ipairs(friends) do
                if zeta:IsValid() and zeta:GetPos():Distance(LocalPlayer():GetPos()) <= GetConVar('zetaplayer_frienddisplaydistance'):GetInt() then
                    local r,g,b = zeta:GetColorByRank()
                    zeta_halos.r = r
                    zeta_halos.g = g
                    zeta_halos.b = b
                    halo.Add({zeta},GetConVar("zetaplayer_usefriendcolor"):GetBool() and zeta_halos or Color(r,g,b),1,1,2,true,GetConVar('zetaplayer_drawfriendhalothroughworld'):GetBool())
                end
            end
        end

    end)



    function GetTeamMembers()
        local members = {}
        local entities = ents.FindByClass('npc_zetaplayer')
      
        for k,zeta in ipairs(entities) do
          if GetConVar('zetaplayer_playerteam'):GetString() != '' and zeta.zetaTeam == GetConVar('zetaplayer_playerteam'):GetString() then
            table.insert(members,zeta)
          end
        end
        return members
      end

      function IsInTeam(ent)

        if ent:IsNextBot() and ent.IsZetaPlayer then
          if GetConVar('zetaplayer_playerteam'):GetString() != '' and  ent.zetaTeam == GetConVar('zetaplayer_playerteam'):GetString() then
            return true
          else
            return false
          end
        end
      
      
      end


function CleanViewShotFolder(caller)
    local files, directories  = file.Find('zetaplayerdata/zeta_viewshots/*','DATA','namedesc')
    for _,image in ipairs(files) do
        file.Delete('zetaplayerdata/zeta_viewshots/'..image)
    end
    caller:PrintMessage(HUD_PRINTTALK,'View Shot folder Cleaned! Had '..#files..' files')
end







function GetAttachmentPoint(self,pointtype)

    if pointtype == "hand" then
  
      local lookup = self:LookupAttachment('anim_attachment_RH')
  
      if lookup == 0 then
          local bone = self:LookupBone("ValveBiped.Bip01_R_Hand")
  
          if !bone then
            return {Pos = (self:GetPos()+self:OBBCenter()),Ang = self:GetForward():Angle()}
          else
            return self:GetBonePosAngs(bone)
          end
          
      else
        return self:GetAttachment(lookup)
      end
  
    elseif pointtype == "eyes" then
      
      local lookup = self:LookupAttachment('eyes')
  
      if lookup == 0 then
          return {Pos = self:GetPos()+self:OBBCenter()+Vector(0,0,5),Ang = self:GetForward():Angle()+Angle(-20,0,0)}
      else
        return self:GetAttachment(lookup)
      end
  
    end
  
  end

function TakeZetaViewShot(self)

    if GetConVar('zetaplayer_allowzetascreenshots'):GetInt() == 0 then return end
    if 100 * math.random() > GetConVar('zetaplayer_zetascreenshotchance'):GetInt() then return end

    local attachment = GetAttachmentPoint(self,"eyes")
    local filetype = GetConVar('zetaplayer_zetascreenshotfiletype'):GetString()
    
    hook.Add('CalcView','zetaviewshotcalc'..self:EntIndex(),function(ply, origin,angles, fov, znear, zfar)
        if !IsValid(self) then hook.Remove('CalcView','zetaviewshotcalc'..self:EntIndex()) return end
        return {
            origin = attachment.Pos,
            angles = attachment.Ang,
            fov = GetConVar('zetaplayer_zetascreenshotfov'):GetInt(),
            drawviewer = true
        }
    end)
    hook.Add('PreDrawEffects','zetaviewshot'..self:EntIndex(),function()
        if !IsValid(self) then hook.Remove('PreDrawEffects','zetaviewshot'..self:EntIndex()) return end
            local viewshot = render.Capture({
                format = filetype,
                x = 0,
                y = 0,
                w = ScrW(),
                h = ScrH(),
                alpha = false
            } )

        local path = 'zetaplayerdata/zeta_viewshots/'..self:GetNW2String('zeta_name','Zeta Player')..'_'..game.GetMap()..'_'..tostring(math.random(1,100000))..'.png'
        
        
            ZetaFileWrite(path,viewshot)
            hook.Remove('CalcView','zetaviewshotcalc'..self:EntIndex())
            hook.Remove('PreDrawEffects','zetaviewshot'..self:EntIndex())
        
        
    end)

end



end



if ( CLIENT )  then


    net.Receive("zeta_flashbang_emitflash", function()
        local index = net.ReadInt(32)
        local emitPos = net.ReadVector()
        
        local dlight = DynamicLight(index)
        if dlight then
            dlight.pos = emitPos
            dlight.r = 255
            dlight.g = 255
            dlight.b = 255
            dlight.brightness = 2
            dlight.Decay = 768
            dlight.Size = 400
            dlight.DieTime = CurTime() + 0.1
        end
    end)

    net.Receive("zeta_changegetplayername",function()
        local ent = net.ReadEntity()
        local name = net.ReadString()
        if !IsValid(ent) then return end
        ent.GetPlayerName = function() return name end
    end)

    net.Receive("zeta_joinmessage",function()
        if GetConVar("zetaplayer_showconnectmessages"):GetInt() == 0 then return end
        local name = net.ReadString()
        local clr = net.ReadColor(false)

        chat.AddText( clr,name,Color(255,255,255)," connected to the server" )

        LocalPlayer():EmitSound(GetConVar("zetaplayer_customjoinsound"):GetString() != "" and GetConVar("zetaplayer_customjoinsound"):GetString() or 'friends/friend_join.wav')

    end)

    net.Receive("zeta_disconnectmessage",function()
        local name = net.ReadString()
        local clr = net.ReadColor(false)

        chat.AddText( clr,name,Color(255,255,255)," disconnected from server" )

        LocalPlayer():EmitSound(GetConVar("zetaplayer_customleavesound"):GetString() != "" and GetConVar("zetaplayer_customleavesound"):GetString() or 'friends/message.wav')


    end)




    local textchatcolor = Color(0,0,0)

    local eyetaptrace = {
        collisiongroup = COLLISION_GROUP_WORLD
    }

    local function ZetaTap(ent)
        local lastpos = Vector(0, 0, 0)
        local vectoradd = VectorRand(0, 1300)
        local frac = 0
        local add = 0.01
        local thirdPerson = false
        local followEnt = ent
        local isCorpse = false
    
        hook.Add("KeyPress", "zetaeyetap_abort", function(ply, key)
            if key == IN_JUMP then
                hook.Remove("KeyPress", "zetaeyetap_abort")
                hook.Remove("CalcView", "zetaeyeTap_Calcview")
                return
            end
            if key == IN_ATTACK2 then thirdPerson = !thirdPerson end
        end)
    
        hook.Add("CalcView", "zetaeyeTap_Calcview", function(ply, origin, angles, fov, znear, zfar)
            if !IsValid(followEnt) or isCorpse and !GetConVar("zetaplayer_eyetap_followcorpse"):GetBool() then
                if add > 0 then
                    frac = frac + add
                    add = add - 0.00007
                end
                local targetpos = (lastpos+vectoradd)
                eyetaptrace.start = lastpos
                eyetaptrace.endpos = targetpos
                local trace = util.TraceLine(eyetaptrace)
                local lerp = LerpVector(frac,lastpos,trace.HitPos)
                
                local returns = {
                    origin = lerp,
                    angles = (lastpos-lerp):Angle(),
                    fov = fov,
                    znear = znear,
                    zfar = zfar,
                    drawviewer = true
                }
                return returns
            end
    
            local ragdoll = followEnt:GetNW2Entity("zeta_ragdoll", NULL)
            if ragdoll != NULL then 
                followEnt = ragdoll
                isCorpse = true
            end
    
            local camPos = (isCorpse and followEnt:GetPos() + followEnt:GetUp()*16 or followEnt:GetCenteroid() + followEnt:GetUp()*32)
            local camAng = ply:EyeAngles()
    
            eyetaptrace.start = camPos
            eyetaptrace.endpos = camPos + camAng:Forward() * -128
            eyetaptrace.filter = {ply, followEnt}
            local wallCheck = util.TraceLine(eyetaptrace)
            camPos = camPos + camAng:Forward() * (-128 * (wallCheck.Fraction - 0.15))
    
            if !thirdPerson and !isCorpse then
                local attach = followEnt:GetAttachmentPoint("eyes")
                attach.Ang.z = (GetConVar("zetaplayer_eyetap_preventtilting"):GetBool() and 0 or attach.Ang.z)
    
                camPos = attach.Pos
                camAng = attach.Ang
            end
            lastpos = camPos or followEnt:GetPos()
    
            local returns = {
                origin = camPos,
                angles = camAng,
                fov = fov,
                znear = znear,
                zfar = zfar,
                drawviewer = true
            }
            return returns
        end)
    end

    net.Receive("zetaplayer_eyetap",function()
        local zeta = net.ReadEntity()
        if !IsValid(zeta) then return end
        ZetaTap(zeta)
    end)








    net.Receive("zeta_achievement",function()
        local zetaname = net.ReadString()
        local text = net.ReadString()
        local col = net.ReadColor(false)

        
        chat.AddText(col,zetaname,color_white," earned the achievement ",Color(238,255,0),text)
    end)


    net.Receive("zeta_chatsend", function()
        local zetaname = net.ReadString()
        local text = net.ReadString()
        local color = net.ReadColor(false)
        local isdead = net.ReadBool()
        local pos = net.ReadVector()

        local dist = GetConVar("zetaplayer_textchatreceivedistance"):GetInt()
        if dist > 0 and LocalPlayer():GetPos():Distance(pos) > dist then
            return
        end

        local deadadd = ""

        if isdead then
            deadadd = "*DEAD* "
        end
        
        chat.AddText(Color(177,0,0),deadadd,color,zetaname,color_white,":".." "..text)
    end)


    net.Receive("zeta_createc4decal",function()
        local result = net.ReadTable()
        if !result.Hit then return end

        local mat = util.DecalMaterial( "Scorch" )
        local imat = Material(mat)
        util.DecalEx( imat, Entity(0), result.HitPos, result.HitNormal, Color(255,255,255), 10,10 )
    end)


    net.Receive('zeta_createcsragdoll',function()
        local zeta = net.ReadEntity()
        local color = net.ReadVector()
        if !IsValid(zeta) or zeta:GetShouldServerRagdoll() then return end
    
        local ragdoll = zeta:BecomeRagdollOnClient()
        zeta.DeathRagdoll = ragdoll
    
        ragdoll.GetPlayerColor = function() return color end
    
        if GetConVar('zetaplayer_cleanupcorpse'):GetBool() then
            timer.Simple(GetConVar('zetaplayer_cleanupcorpsetime'):GetInt(), function()
                if !IsValid(ragdoll) then return end
                if GetConVar('zetaplayer_cleanupcorpseeffect'):GetBool() then
                    ragdoll:Disintegrate()
                    return
                end
                if GetConVar("zetaplayer_explosivecorpsecleanup"):GetBool() then
                    net.Start('zeta_csragdollexplode', true)
                        net.WriteVector(ragdoll:GetPos())
                    net.SendToServer()
    
                    local effectdata = EffectData()
                    effectdata:SetOrigin( ragdoll:GetPos() )
                    util.Effect( "Explosion", effectdata, true, true )
                    ragdoll:EmitSound("BaseExplosionEffect.Sound")
                end
                ragdoll:Remove()
            end)
        end
    end)


    net.Receive("zeta_sendcoloredtext",function()
        local json = net.ReadString()
        local textargs = util.JSONToTable(json)
        
        chat.AddText(unpack(textargs))
    end)


    net.Receive('zeta_usesprayer', function()
        local spray = net.ReadString()      // Spray Image Path
        local traceTbl = net.ReadTable()    // TraceResult table
        local sprayIndex = net.ReadInt(32)
        local sprayMat = nil
        if sprayIndex != -1 then
            // Create material from texture
            // sprayIndex is used to create unique material names
            sprayMat = CreateMaterial('zetaSpray'..sprayIndex, 'LightmappedGeneric', {
                ['$basetexture'] = spray,
                ['$translucent'] = 1,
                ['Proxies'] = {
                    ['AnimatedTexture'] = {
                        ['animatedTextureVar'] = '$basetexture',
                        ['animatedTextureFrameNumVar'] = '$frame',
                        ['animatedTextureFrameRate'] = 10
                    }
                }
            })
        else
            // Create material from image
            sprayMat = Material(spray)
        end
        if !sprayMat or sprayMat:IsError() then print("Zeta Sprays: "..spray.." Failed to load and or is a error!") return end
        if GetConVar("zetaplayer_playersizedsprays"):GetInt() == 1 then
            local texWidth = sprayMat:Width()
            local texHeight = sprayMat:Height()

            local widthPower = 256
            local heightPower = 256
            if texWidth > texHeight then
                heightPower = 128
            elseif texHeight > texWidth then
                widthPower = 128
            end

            if texWidth < 256 then
                texWidth = (texWidth / 256)
            else
                texWidth = (widthPower / (texWidth * 4))
            end

            if texHeight < 256 then
                texHeight = (texHeight / 256)
            else
                texHeight = (heightPower / (texHeight * 4))
            end

            -- Create spray decal
            util.DecalEx(sprayMat, Entity(0), traceTbl.HitPos, traceTbl.HitNormal, Color(255, 255, 255, 255), texWidth, texHeight)
        else
            -- Old method because it is funny to see large sprays
            local width = (sprayMat:Width() * 0.15) / sprayMat:Width()
            local height = (sprayMat:Height() * 0.15) / sprayMat:Height() 
            util.DecalEx(sprayMat, Entity(0), traceTbl.HitPos, traceTbl.HitNormal, Color(255, 255, 255, 255), width, height)
        end




    end)


--[[     net.Receive('zeta_usesprayer', function() -- New Spray System by Erma
        local spray = net.ReadString()      // Spray Image Path
        local traceTbl = net.ReadTable()    // TraceResult table

        // Create material from image
        local sprayMat = Material(spray)
        if sprayMat:IsError() then print("Zeta Sprays: "..spray.." Failed to load and or is a error!") return end

        // Scale the material
        local width = (sprayMat:Width() * 0.15) / sprayMat:Width()
        local height = (sprayMat:Height() * 0.15) / sprayMat:Height() 

        // Create spray decal
        if traceTbl.Entity == NULL or traceTbl.Entity == nil then return end -- Using this because IsValid() returns false if it is World Spawn
        util.DecalEx(sprayMat, Entity(0), traceTbl.HitPos, traceTbl.HitNormal, Color(255, 255, 255, 255), width, height)
    end) ]]

    matproxy.Add( {
        name = "ZetaPlayerWeaponColor",
    
        init = function( self, mat, values )
    
            self.ResultTo = values.resultvar
    
        end,
    
        bind = function( self, mat, ent )
    
            if ( !IsValid( ent ) ) then return end

            local wepClr = ent:GetNW2Vector('zeta_physcolor')
            if ( isvector(wepClr) and wepClr != Vector(0,0,0)) then
                local mul = ( 1 + math.sin( CurTime() * 5 ) ) * 0.5
                mat:SetVector( self.ResultTo, wepClr + wepClr * mul )
                return
            end
    
            local owner = ent:GetOwner()
            if ( !IsValid( owner ) or !owner.IsZetaPlayer ) then return end
    
            local col = owner:GetNW2Vector('zeta_physcolor',Vector(1,1,1))
            if ( !isvector( col ) ) then return end
    
            local mul = ( 1 + math.sin( CurTime() * 5 ) ) * 0.5

            mat:SetVector( self.ResultTo, col + col * mul )
    
        end
    } )


    local voiceicon = Material("voice/icntlk_pl")
    net.Receive('zeta_addkillfeed',function()
        local killfeednet = net.ReadString()
        local killfeeddata = util.JSONToTable(killfeednet)


        if table.IsEmpty(killfeeddata) then return end

        local killfeedicon = net.ReadBool()
        local add = ((!killfeedicon and killfeeddata.prettyprint) and " | using a "..killfeeddata.prettyprint or "") 

        if !killicon.Exists( killfeeddata.inflictor ) then
            killfeeddata.inflictor = "default"
        end
        
        GAMEMODE:AddDeathNotice(language.GetPhrase(killfeeddata.attacker)..add,killfeeddata.attackerteam,killfeeddata.inflictor,killfeeddata.victim,killfeeddata.victimteam)

    end)



    net.Receive('zeta_notifycleanup',function()
        local text = net.ReadString()
        local fail = net.ReadBool()
        if !fail then
            notification.AddLegacy(text,NOTIFY_CLEANUP,4)
            LocalPlayer():EmitSound('buttons/button15.wav')
        else
            notification.AddLegacy(text,NOTIFY_ERROR,4)
            LocalPlayer():EmitSound('buttons/button10.wav')
        end
    end)

    net.Receive('zeta_playermodelcolor',function()
        local ent = net.ReadEntity()
        local color = net.ReadVector()
        if ent:IsValid() then
            ent.GetPlayerColor = function() return color end
        end
    end)

    net.Receive('zeta_voiceicon',function()
        if GetConVar('zetaplayer_drawvoiceicon'):GetInt() == 0 then return end
        local zeta = net.ReadEntity()
        local time = net.ReadFloat()
        
        if zeta:IsValid() then

            local followEnt = zeta
            if IsValid(zeta.DeathRagdoll) then followEnt = zeta.DeathRagdoll 
            elseif IsValid(zeta:GetNW2Entity('zeta_ragdoll', NULL)) then followEnt = zeta:GetNW2Entity('zeta_ragdoll', NULL) end

            timer.Simple(time,function() hook.Remove('PreDrawEffects','zetavoiceicon'..followEnt:EntIndex()) end)
        hook.Add('PreDrawEffects','zetavoiceicon'..followEnt:EntIndex(),function()
            if !followEnt:IsValid() then hook.Remove('PreDrawEffects','zetavoiceicon'..followEnt:EntIndex()) return end
                local ang = EyeAngles()
                local pos = followEnt:GetPos() + Vector(0, 0, 80)
                ang:RotateAroundAxis(ang:Up(), -90)
                ang:RotateAroundAxis(ang:Forward(), 90)
        
                cam.Start3D2D(pos, ang, 1)
                surface.SetMaterial(voiceicon)
                surface.SetDrawColor(255, 255, 255)
                surface.DrawTexturedRect(-8, -8, 16, 16)
                cam.End3D2D()
            
        end)
        end
        end)

        net.Receive('zeta_requestviewshot',function()
            local zeta = net.ReadEntity()
            if IsValid(zeta) then
                TakeZetaViewShot(zeta)
            end
        end)




end 




if ( CLIENT ) then
    concommand.Add('zetaplayer_cleanviewshotfolder',CleanViewShotFolder,nil,'Cleans the View Shot Folder')
end


concommand.Add( 'zetaplayer_autotweaknavmesh', _ZetaTweakNavmesh, nil, "Edits the entire navigation mesh to suit the zetas")
concommand.Add( 'zetaplayer_savenavmesh', _ZetaSavenavmesh, nil, "Saves the navigation mesh edited by auto tweak")

--[[ concommand.Add( 'zetaplayer_force_findpokertable', ZetasForceFindTable, nil, "Force all nearby Zetas to find a poker table") ]]
concommand.Add( 'zetaplayer_force_panicaroundplayer', PanicZetasAroundPlayer, nil, "Panic all nearby Zetas that are around the player")
concommand.Add( 'zetaplayer_force_panicinviewofplayer', PanicZetasInView, nil, "Panic all Zetas that are in view of the player")
concommand.Add( 'zetaplayer_force_laughatplayer', ZetasLaughInView, nil, "Makes all nearby Zetas laugh at the player")
concommand.Add( 'zetaplayer_force_targetplayer', ZetasTargetPlayer, nil, "Makes all nearby Zetas attack at the player")
concommand.Add( 'zetaplayer_force_killall', ZetasDiesAroundPlayer, nil, "Makes all nearby Zetas commit suicide around the player")
-- Just in case.

concommand.Add( 'zetaplayer_registermaterial', RegisterMaterial, nil, "Adds a material that a zeta can use")
concommand.Add( 'zetaplayer_removematerial', RemoveMaterial, nil, "Removes a registered material")
concommand.Add( 'zetaplayer_registerprop', RegisterProp, nil, "Adds a prop that a zeta can spawn")
concommand.Add( 'zetaplayer_removeprop', RemoveProp, nil, "Removes a registered prop")

concommand.Add( 'zetaplayer_updateservercache', _ZetaUpdateServerCache, nil, "Updates the Data Cache")

concommand.Add( 'zetaplayer_registername', RegisterName, nil, "Adds a name a zeta can use")
concommand.Add( 'zetaplayer_removename', RemoveName, nil, "Removes a Zeta name")

concommand.Add( 'zetaplayer_registerentity', RegisterEntity, nil, "Adds a Entity that a zeta can spawn")
concommand.Add( 'zetaplayer_removeentity', RemoveEntity, nil, "Removes a registered Entity")

concommand.Add( 'zetaplayer_registernpc', RegisterNPC, nil, "Adds a NPC that a zeta can spawn")
concommand.Add( 'zetaplayer_removenpc', RemoveNPC, nil, "Removes a registered NPC")

concommand.Add( 'zetaplayer_cleanupents', CleanupZetaEnts, nil, "Removes all currently spawned Zeta Entities")
concommand.Add( 'zetaplayer_cleanupzetaplayers', CleanupAllZetas, nil, "Removes all currently spawned Zeta Players")

concommand.Add( 'zetaplayer_force_befriendplayer', ZetasForceFriendToPlayer, nil, "Force all nearby Zetas to befriend the player")

concommand.Add( 'zetaplayer_tptorandomzeta', TeleportRNDZeta, nil, "Teleport to a random Zeta")
concommand.Add( 'zetaplayer_tptofriendzeta', TeleportFriendZeta, nil, "Teleport to a Zeta who considers you as a friend")
concommand.Add( 'zetaplayer_tpfriendzetatoself', TeleportFriendZetaToCaller, nil, "Teleport to a Friend Zeta to your position")

concommand.Add( 'zetaplayer_debugzetainfo', testzetastate, nil, "Debug a Zeta's info")

concommand.Add( 'zetaplayer_cacheallmodels', PrecacheAllPlayermodels, nil, "Cache all Playermodels. WARNING! THIS WILL LAG YOUR GAME")

concommand.Add( 'zetaplayer_createserverjunk', CreateServerJunk, nil, "Spawn junk all over the map")
concommand.Add( 'zetaplayer_setplayerbirthday', SetPlayerBirthday, nil, "Enter your birthday here. EXAMPLE: December 5")

concommand.Add( 'zetaplayer_force_targetzeta', ZetasTargetOtherZetas, nil, "Makes all nearby Zetas attack other Zetas")


if SERVER then -- Cache all these values 

    _ZetaCheckCurrentDate()
    
    _SERVERTEXTDATA = util.JSONToTable(file.Read("zetaplayerdata/textchatdata.json","DATA"))

    _SERVERMEDIADATA = util.JSONToTable(file.Read("zetaplayerdata/mediaplayerdata.json","DATA"))

    _SERVERValidMaterials = util.JSONToTable(file.Read('zetaplayerdata/materials.json','DATA'))

    _SERVERValidProps = util.JSONToTable(file.Read('zetaplayerdata/props.json','DATA'))

    _SERVERValidNPCS = util.JSONToTable(file.Read('zetaplayerdata/npcs.json','DATA'))

    _SERVERValidENTS = util.JSONToTable(file.Read('zetaplayerdata/ents.json','DATA'))

    _SERVERNAMES = util.JSONToTable(file.Read('zetaplayerdata/names.json','DATA'))

    _SERVERPFPS,_SERVERPFPDIRS = file.Find("zetaplayerdata/custom_avatars/*","DATA","nameasc")
    
    ----
    local managermodels = player_manager.AllValidModels()
    _SERVERPLAYERMODELS = table.Copy(managermodels)
    ----

    _SERVERPLAYERMODELS = table.ClearKeys( _SERVERPLAYERMODELS )


    if GetConVar("zetaplayer_enableblockmodels"):GetBool() then
        local json = file.Read("zetaplayerdata/blockedplayermodels.json","DATA")
        local blockedmdls = util.JSONToTable(json)
        if #blockedmdls > 0 then
            for k,v in ipairs(blockedmdls) do
                if !util.IsValidModel(v) then continue end

                local key = table.KeyFromValue( _SERVERPLAYERMODELS, v )

                table.remove(_SERVERPLAYERMODELS,key)
            end
        end
    end
    
    
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

    if GetConVar("zetaplayer_enableblockmodels"):GetBool() then
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



    _ZETANAVMESH = {}

    timer.Simple(0, function()
        for _, v in ipairs(navmesh.GetAllNavAreas()) do
            if IsValid(v) and (v:GetSizeX() > 75 or v:GetSizeY() > 75) then
                _ZETANAVMESH[#_ZETANAVMESH+1] = v
            end
        end
    end)
    
end

_ZetaWeaponKillIcons = {
    ["CROWBAR"] = "weapon_crowbar",
    ["STUNSTICK"] = "weapon_stunstick",
    ["PISTOL"] = "weapon_pistol",
    ["REVOLVER"] = "weapon_357",
    ["SMG"] = "weapon_smg1",
    ["AR2"] = "weapon_ar2",
    ["SHOTGUN"] = "weapon_shotgun",
    ["CROSSBOW"] = "crossbow_bolt",
    ["GRENADE"] = "npc_grenade_frag",
    ["RPG"] = "rpg_missile",
    ["LIGHTSABER"] = "weapon_lightsaber",
    ["ZOMBIECLAWS"] = "zetaweapon_zombieclaws",
    ["THEKLEINER"] = "zetaweapon_kleiner",
    ["NYANGUN"] = "weapon_nyangun",

    ["SG552"] = "zetaweapon_css_sg552",
    ["USPSILENCED"] = "zetaweapon_css_usp",
    ["XM1014"] = "zetaweapon_css_xm1014",
    ["AK47"] = "zetaweapon_css_ak47",
    ["GLOCK_SEMI"] = "zetaweapon_css_glock",
    ["GLOCK_AUTO"] = "zetaweapon_css_glock",
    ["AUG"] = "zetaweapon_css_aug",
    ["DEAGLE"] = "zetaweapon_css_deagle",
    ["KNIFE"] = "zetaweapon_css_knife",
    ["MAC10"] = "zetaweapon_css_mac10",
    ["P90"] = "zetaweapon_css_p90",
    ["SCOUT"] = "zetaweapon_css_scout",
    ["UMP45"] = "zetaweapon_css_ump45",
    ["AWP"] = "zetaweapon_css_awp",
    ["FAMAS"] = "zetaweapon_css_famas",
    ["FIVESEVEN"] = "zetaweapon_css_fiveseven",
    ["M4A1"] = "zetaweapon_css_m4a1",
    ["MP5"] = "zetaweapon_css_mp5",
    ["MACHINEGUN"] = "zetaweapon_css_m249",
    ["GALIL"] = "zetaweapon_css_galil",
    ["M3"] = "zetaweapon_css_m3",
    ["TMP"] = "zetaweapon_css_tmp",
    ["DUALELITES"] = "zetaweapon_css_elites",
    ["FLASHGRENADE"] = "zetaweapon_css_flashbang",
    ["SMOKEGRENADE"] = "zetaweapon_css_smokegrenade",

    ["L4D_MELEE_TONFA"] = "zetaweapon_l4d2_melee_tonfa",
    ["L4D_MELEE_GUITAR"] = "zetaweapon_l4d2_melee_guitar",
    ["L4D_MELEE_GOLFCLUB"] = "zetaweapon_l4d2_melee_golfclub",
    ["L4D_MELEE_FIREAXE"] = "zetaweapon_l4d2_melee_fireaxe",
    ["L4D_PISTOL_M1911"] = "zetaweapon_l4d2_pistol_m1911",
    ["L4D_PISTOL_P220"] = "zetaweapon_l4d2_pistol_p220",
    ["L4D_PISTOL_GLOCK26"] = "zetaweapon_l4d2_pistol_glock",
    ["L4D_PISTOL_MAGNUM"] = "zetaweapon_l4d2_pistol_magnum",
    ["L4D_SMG"] = "zetaweapon_l4d2_smg",
    ["L4D_SMG_SILENCED"] = "zetaweapon_l4d2_smg_silenced",
    ["L4D_SHOTGUN_PUMP"] = "zetaweapon_l4d2_pumpshotgun",
    ["L4D_SHOTGUN_CHROME"] = "zetaweapon_l4d2_shotgun_chrome",
	["L4D_SHOTGUN_SPAS12"] = "zetaweapon_l4d2_shotgun_spas",
	["L4D_SHOTGUN_AUTOSHOT"] = "zetaweapon_l4d2_autoshotgun",
    ["L4D_RIFLE_M16"] = "zetaweapon_l4d2_rifle",
    ["L4D_RIFLE_AK47"] = "zetaweapon_l4d2_rifle_ak47",
    ["L4D_RIFLE_SCARL"] = "zetaweapon_l4d2_rifle_desert",
    ["L4D_RIFLE_RUGER14"] = "zetaweapon_l4d2_hunting_rifle",
    ["L4D_RIFLE_MILITARYS"] = "zetaweapon_l4d2_sniper_military",
    ["L4D_SPECIAL_M60"] = "zetaweapon_l4d2_rifle_m60",
    ["L4D_SPECIAL_GL_IMPACT"] = "zetaweapon_l4d2_grenade_launcher",
    ["L4D_SPECIAL_GL_DELAYED"] = "zetaweapon_l4d2_grenade_launcher",
    ["L4D_SPECIAL_CHAINSAW"] = "zetaweapon_l4d2_melee_chainsaw",

    ["DODS_US_AMERIKNIFE"] = "zetaweapon_dod_knife",
    ["DODS_US_COLT45"] = "zetaweapon_dod_colt1911",
    ["DODS_US_M1CARBINE"] = "zetaweapon_dod_m1carbine",
    ["DODS_US_THOMPSON"] = "zetaweapon_dod_thompspn",
    ["DODS_US_GARAND"] = "zetaweapon_dod_garand",
    ["DODS_US_BAR"] = "zetaweapon_dod_bar",
    ["DODS_US_SPRINGFIELD"] = "zetaweapon_dod_springfield",
    ["DODS_US_30CAL"] = "zetaweapon_dod_30cal",
    ["DODS_US_BAZOOKA"] = "zetaweapon_dod_bazooka",
    ["DODS_AXIS_SPADE"] = "zetaweapon_dod_spade",
    ["DODS_AXIS_P38"] = "zetaweapon_dod_p38",
    ["DODS_AXIS_C96"] = "zetaweapon_dod_c96",
    ["DODS_AXIS_MP40"] = "zetaweapon_dod_mp40",
    ["DODS_AXIS_MP44"] = "zetaweapon_dod_mp44",
    ["DODS_AXIS_KAR98k"] = "zetaweapon_dod_kar98",
    ["DODS_AXIS_KAR98KSNIPER"] = "zetaweapon_dod_kar98s", 
    ["DODS_AXIS_MG42"] = "zetaweapon_dod_mg42",
    ["DODS_AXIS_PANZERSCHRECK"] = "zetaweapon_dod_panzerschreck",

    ["HL1GLOCK"] = "zetaweapon_hl1_glock",
    ["HL1357"] = "zetaweapon_hl1_revolver",
    ["HL1SMG"] = "zetaweapon_hl1_smg",
    ["HL1SPAS"] = "zetaweapon_hl1_shotgun",

    ["BAT"] = "zetaweapon_tf2_bat",
    ["WRENCH"] = "zetaweapon_tf2_wrench",
    ["TF2PISTOL"] = "zetaweapon_tf2_pistol",
    ["TF2SHOTGUN"] = "zetaweapon_tf2_shotgun",
    ["SNIPERSMG"] = "zetaweapon_tf2_smg",
    ["TF2SNIPER"] = "zetaweapon_tf2_sniperrifle",
    ["SCATTERGUN"] = "zetaweapon_tf2_scattergun",
    ["FORCEOFNATURE"] = "zetaweapon_tf2_forceofnature",
    ["GRENADELAUNCHER"] = "zetaweapon_tf2_grenadelauncher",
    ["FLAMETHROWER"] = "zetaweapon_tf2_flamethrower",
    ["TF2_MINIGUN"] = "zetaweapon_tf2_minigun",

    ["FIST"] = "zetaweapon_fists",
    ["ALYXGUN"] = "zetaweapon_alyxgun",
    ["ANNABELLE"] = "zetaweapon_annabelle",
    ["HACKSMONITORS"] = "zetaweapon_hackmonitor",
    ["VOLVER"] = "zetaweapon_volver",
    ["IMPACTGRENADE"] = "npc_grenade_frag",
    ["JPG"] = "zetaweapon_junklauncher",
	["KATANA"] = "zetaweapon_katana",
	["MEATHOOK"] = "zetaweapon_meathook",
	["SHOVEL"] = "zetaweapon_shovel",
	["PAN"] = "zetaweapon_l4d2_melee_frying_pan",
    ["CARDOOR"] = "zetaweapon_cardoor",
    ["LARGESIGN"] = "zetaweapon_largesign",

    ["MP1_LEADPIPE"] = "weapon_mp1_leadpipe",
    ["MP1_BASEBALLBAT"] = "weapon_mp1_baseballbat",
    ["MP1_BERETTA"] = "weapon_mp1_beretta",
    ["MP1_DUALBERETTAS"] = "weapon_mp1_berettadual",
    ["MP1_DESERTEAGLE"] = "weapon_mp1_deserteagle",
    ["MP1_INGRAM"] = "weapon_mp1_ingram",
    ["MP1_DUALINGRAMS"] = "weapon_mp1_ingramdual",
    ["MP1_MP5"] = "weapon_mp1_mp5",
    ["MP1_SAWEDOFFSHOTGUN"] = "weapon_mp1_sawedshotgun",
    ["MP1_PUMPSHOTGUN"] = "weapon_mp1_pumpshotgun",
    ["MP1_COLTCOMMANDO"] = "weapon_mp1_coltcommando",
    ["MP1_JACKHAMMER"] = "weapon_mp1_jackhammer",
    ["MP1_SNIPERRIFLE"] = "weapon_mp1_sniperrifle",
    ["MP1_M79"] = "weapon_mp1_m79",
    ["MP1_COCKTAIL"] = "weapon_mp1_molotov",
    ["MP1_GRENADE"] = "weapon_mp1_grenade",
}

_ZETANORMALSEATS = {
    ["models/nova/airboat_seat.mdl"] = true,
    ["models/nova/chair_plastic01.mdl"] = true,
    ["models/nova/chair_wood01.mdl"] = true,
    ["models/nova/chair_plastic01.mdl"] = true,
    ["models/nova/chair_office02.mdl"] = true,
    ["models/nova/chair_office01.mdl"] = true,
    ["models/nova/jeep_seat.mdl"] = true,
    ["models/nova/jalopy_seat.mdl"] = true,
    ["models/props_phx/carseat2.mdl"] = true,
    ["models/props_phx/carseat3.mdl"] = true,
}

_ZETASMOKEGRENADES = {}

function _ZetaIsMinigameActive()
    return GetGlobalBool("_ZetaKOTH_Gameactive", false ) or GetGlobalBool("_ZetaCTF_Gameactive", false ) or GetGlobalBool("_ZetaTDM_Gameactive",false)
end



if gPoker and gPoker.betType then
    gPoker.betType[1].get = function(p)
        if p:IsPlayer() or p.IsZetaPlayer then
            return p:Health()
        else
            local ent = gPoker.getTableFromPlayer(p)
            if !IsValid(ent) then return 0 end
            local key = ent:getPlayerKey(p)
            return ent.players[key].health
        end
    end
    gPoker.betType[1].add = function(p, a, e)
        if CLIENT then return end
        if !IsValid(p) then return end
        
        a = a or 0

        local hp = gPoker.betType[e:GetBetType()].get(p) + a
        if hp < 1 then 
            e:removePlayerFromMatch(p)
            if p:IsPlayer() or p.IsZetaPlayer then p:Kill() end
        else
            if p:IsPlayer() or p.IsZetaPlayer then p:SetHealth(hp) else 
                e.players[e:getPlayerKey(p)].health = hp 
                e:updatePlayersTable() 
            end
        end

        e:SetPot(e:GetPot() - a)
    end
end

_ZETATEAMS = {}
    local teamData = util.JSONToTable(file.Read("zetaplayerdata/teams.json"))
    if teamData then
        for _, v in ipairs(teamData) do
            local teamName = v[1]
            local teamColor = (v[2] and v[2]:ToColor() or Color(255, 255, 100))
            local teamIndex = (table.Count(_ZETATEAMS)+1)

            if !_ZETATEAMS[teamName] then
                _ZETATEAMS[teamName] = teamIndex
                team.SetUp(teamIndex, teamName, teamColor, false)
            end
        end
    end

    if game.SinglePlayer() then
        cvars.RemoveChangeCallback("zetaplayer_useteamsystem", "ZetaPlayers_PlayerZetaTeamColor2") 
        cvars.AddChangeCallback("zetaplayer_useteamsystem", function(cvar, oldVal, newVal) 
            local plyTeam = GetConVar("zetaplayer_playerteam"):GetString()
            local newTeam = (tobool(newVal) == true and _ZETATEAMS[plyTeam]) and _ZETATEAMS[plyTeam] or 1001
            if Entity(1):Team() != newTeam then Entity(1):SetTeam(newTeam) end
        end, "ZetaPlayers_PlayerZetaTeamColor2")
    end

_ZETASPEAKINGLIMIT = 0 -- The amount of Zetas speaking
_ZETATEXTSLOWCUR = 0
_ZETACOUNT = 0

if !file.Exists("zetaplayerdata/zetastats.json","DATA") then
    ZetaFileWrite("zetaplayerdata/zetastats.json","[]")
end

if !file.Exists("zetaplayerdata/weapondata.dat","DATA") then
    ZetaFileWrite("zetaplayerdata/weapondata.dat", util.Compress( "[]" ) )
end

concommand.Add("zetaplayer_resetweapondata",function() 
    ZetaFileWrite("zetaplayerdata/weapondata.dat", util.Compress( "[]" ))
    print("Weapon Data Reset")
end)

concommand.Add("zetaplayer_resetzetastats",function() 
    ZetaFileWrite("zetaplayerdata/zetastats.json","[]")
    print("Zeta Stats Reset")
end)

timer.Create("_ZetaTimeCounter",1,0,function()
    if _ZETACOUNT > 0 then
        local zetastats = file.Read("zetaplayerdata/zetastats.json")

        if zetastats then
            zetastats = util.JSONToTable(zetastats)

            zetastats["timeplayed"] = zetastats["timeplayed"] and zetastats["timeplayed"]+1 or 1

            ZetaFileWrite("zetaplayerdata/zetastats.json",util.TableToJSON(zetastats,true))
        end
    end
end)
