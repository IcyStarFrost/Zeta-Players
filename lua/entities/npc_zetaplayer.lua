

-- Welcome to the Zeta's code! The stuff that makes these guys tick.
-- Please note my code isn't the best for sure but at least it won't be performance heavy.
-- So go on and take a look at the code cause I assume that is why you are here but you know, could be anything.




-- 3/1/2022: It's all over the place kinda so uhhhhhhhhh good luck trying to read it lol. Very inconsistent


AddCSLuaFile()
include('zeta/state_functions.lua')
include("zeta/zetachances.lua")
include('zeta/util.lua')
include('zeta/hooks.lua')
include('zeta/weapon_handling.lua')
include('zeta/sounds.lua')
include('zeta/toolgun_tools.lua')
include('zeta/movement.lua')
include('zeta/zeta_spawnmenu.lua')
include('zeta/physgun.lua')
include('zeta/vehicle_system.lua')
include('zeta/camera.lua')
include('zeta/admin.lua')
include('zeta/textchat.lua')
include("zeta/buildingsystem.lua")

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true

ENT.IsZetaPlayer = true

ENT.PrintName         = "Zeta Player"
if CLIENT then
    language.Add('npc_zetaplayer', ENT.PrintName)
end


local oldisvalid = IsValid

local function IsValid( ent )
    if oldisvalid( ent ) and ent.IsZetaPlayer then
        
        return !ent.IsDead 
    else
        return oldisvalid( ent )
    end
end


local math = math
local table = table
local util = util
local navmesh = navmesh

local trace = {}
trace.TraceLine = util.TraceLine
trace.TraceHull = util.TraceHull
trace.QuickTrace = util.QuickTrace
trace.TraceEntity = util.TraceEntity

local zetamath = {}
zetamath.random = math.random
zetamath.Rand = math.Rand

local RandomPairs = RandomPairs
local ipairs = ipairs
local pairs = pairs
local ents_FindByClass = ents.FindByClass
local ents_Create = ents.Create


-- table localization

local table_Empty = table.Empty
local table_Copy = table.Copy
local table_ClearKeys = table.ClearKeys
local table_KeyFromValue = table.KeyFromValue
local table_Count = table.Count
local table_Merge = table.Merge
local table_HasValue = table.HasValue
local table_IsEmpty = table.IsEmpty
local table_sort = table.sort
local table_insert = table.insert


local PhysgunGlowMat = Material('sprites/physg_glow1')
local PhysgunGlowMat2 = Material('sprites/physg_glow2')
local PhysgunBeam = Material("sprites/physbeama")
local FlashlightSprite = Material( "sprites/light_glow02_add")



local unstuckdata = {
    ignoreworld = true,
}

local physguntracedata = {
    filter = self,
    ignoreworld = true,
    collisiongroup = COLLISION_GROUP_DEBRIS
}
local surrounding = {}




local accuracylevels = {
    [1] = 0.4,
    [2] = 0.25,
    [3] = 0.15,
    [4] = 0
}




function ENT:Initialize()
    local spawnmdl = "models/player/kleiner.mdl"

    local zetas = ents_FindByClass('npc_zetaplayer')
    local spawners = ents_FindByClass('zeta_zetaplayerspawner')


    if ( SERVER ) then 

        if !game.SinglePlayer() and _ZetaWarnMultiplayer then
            PrintMessage(HUD_PRINTTALK,"Zeta Player warning: Zetas are meant to be played in singleplayer only! Any issues you encounter here WILL be ignored if reported!")
            _ZetaWarnMultiplayer = false
        end

        _ZETACOUNT = _ZETACOUNT + 1
        self.spawntime = SysTime()

        if !self.ZetaSpawnerID then
            local zetastats = file.Read("zetaplayerdata/zetastats.json")

            if zetastats then
                zetastats = util.JSONToTable(zetastats)

                if zetastats then 
    
                    zetastats["connectcount"] = zetastats["connectcount"] and zetastats["connectcount"]+1 or 1
        
                    ZetaFileWrite("zetaplayerdata/zetastats.json",util.TableToJSON(zetastats,true))

                else
                    ZetaFileWrite("zetaplayerdata/zetastats.json","[]")
                end
            end
        end

        local UseSERVERCACHE = GetConVar("zetaplayer_useservercacheddata"):GetBool()
        
        self.IsAdmin = GetConVar("zetaplayer_forcespawnadmins"):GetBool()

        if self.ShouldSpawnAdmin != nil then 
            self.IsAdmin = self.ShouldSpawnAdmin
        else
            local count = GetConVar("zetaplayer_admincount"):GetInt()
            if game.SinglePlayer() and count > 0 and GetConVar("zetaplayer_spawnasadmin"):GetBool() then
                local admins = #self:GetAdmins()

                for i=1, #spawners do
                    if spawners[i].IsAdmin and !IsValid(spawners[i].SpawnedZeta) then admins = admins + 1 end
                end

                if admins < count then
                    self.IsAdmin = true
                elseif admins > count then
                    self.IsAdmin = false
                end
            end
        end


        --_SERVERPLAYERMODELS
        --_SERVERDEFAULTMDLS

        local overrideMdl = GetConVar('zetaplayer_overridemodel'):GetString()

        if self.IsAdmin == true then overrideMdl = GetConVar('zetaplayer_adminoverridemodel'):GetString() end

        if overrideMdl != '' then
            local cvarMdls = string.Explode(',', overrideMdl)
            for i=1, #cvarMdls do
                if util.IsValidModel(cvarMdls[i]) then continue end
                cvarMdls[i] = nil
            end
            if #cvarMdls > 0 then 
                spawnmdl = cvarMdls[zetamath.random(#cvarMdls)] 
            end
        elseif GetConVar('zetaplayer_randomplayermodels'):GetBool() then
            if !GetConVar('zetaplayer_randomdefaultplayermodels'):GetBool() then


                if !UseSERVERCACHE then
                    if GetConVar("zetaplayer_enableblockmodels"):GetBool() then
                        local validplayermodels = player_manager.AllValidModels()


                        local json = file.Read("zetaplayerdata/blockedplayermodels.json","DATA")
                        local blockedmdls = util.JSONToTable(json)

                        local copyvalidplayermodels = table_Copy(validplayermodels)
                        copyvalidplayermodels = table_ClearKeys( copyvalidplayermodels )
                        if #blockedmdls > 0 then
                            for i=1, #blockedmdls do

                                local key = table_KeyFromValue( copyvalidplayermodels, blockedmdls[i] )
                                
                                if key then

                                    copyvalidplayermodels[key] = nil

                                end
                            end
                        end

                        for k,v in RandomPairs(copyvalidplayermodels) do
                            spawnmdl = v
                            break
                        end
                    else
                        for k,v in RandomPairs(player_manager.AllValidModels()) do
                            spawnmdl = v
                            break
                        end
                    end

                else -- server cache true

                    if #_SERVERPLAYERMODELS > 0 then -- Just in case someone decided to block every model possible.        ...Why?
                        spawnmdl = _SERVERPLAYERMODELS[zetamath.random(#_SERVERPLAYERMODELS)]
                    else
                        spawnmdl = "models/player/kleiner.mdl"
                    end

                end -- SERVER CACHE End

                
            else
                if !UseSERVERCACHE then
                    local mdls = {
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
                        'models/player/group01/female_0'..zetamath.random(1,6)..'.mdl',
                        'models/player/group01/male_0'..zetamath.random(1,9)..'.mdl',
                        'models/player/group02/male_02.mdl',
                        'models/player/group02/male_04.mdl',
                        'models/player/group02/male_06.mdl',
                        'models/player/group02/male_08.mdl',
                        'models/player/group03/female_0'..zetamath.random(1,6)..'.mdl',
                        'models/player/group03/male_0'..zetamath.random(1,9)..'.mdl',
                        'models/player/group03m/female_0'..zetamath.random(1,6)..'.mdl',
                        'models/player/group03m/male_0'..zetamath.random(1,9)..'.mdl',
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
                            for k, v in ipairs( blockedmdls ) do

                                local key = table_KeyFromValue( mdls, v)
                                
                                if key then

                                    mdls[key] = nil

                                end
                            end
                        end
                    end
                    
                    if #mdls > 0 then
                        spawnmdl = mdls[zetamath.random(#mdls)]
                    else
                        spawnmdl = "models/player/kleiner.mdl"
                    end

                else -- Server cache true
                    
                    if #_SERVERDEFAULTMDLS > 0 then
                        spawnmdl = _SERVERDEFAULTMDLS[zetamath.random(#_SERVERDEFAULTMDLS)]
                    else
                        spawnmdl = "models/player/kleiner.mdl"
                    end

                end -- SERVER CACHE END
            end
        end
    end   

    local col = GetConVar('zetaplayer_randomplayermodelcolor'):GetBool() and Vector(zetamath.random(255)/255, zetamath.random(255)/255, zetamath.random(255)/255) or Vector( 1, 1, 1 )




    self.VJ_AddEntityToSNPCAttackList = true
    self.FallVelocity = 0
    self.BurstCount = 0
    self.Kills = 0
    self.MaxBurst = 0
    self.Accuracy = 4
    self.SightDistance = 1500
    self.State = 'idle' -- The State System
    self.LastState = 'idle'
    self.Weapon = 'NONE' -- The active Weapon the Zeta Uses
    self.ThinkFunctions = {}
    self.ThinkFunctionCount = 0
    self.PrettyPrintWeapon = "Holster"
    self.DrowningRecoverHealth = 0
    self.PhysgunBeamDistance = 100
    self.Friends = {}
    self.FirstSpawned = true
    self.CanJump = true
    self.CanPlayFootstep = true
    self.AllowVoice = true -- Used to prevent the bot from speaking
    self.AllowPanic = true -- Used to allow a cooldown on panic
    self.CanDance = true -- Used to cooldown dancing
    self.VoicePack = "none"
    self.zetaname = "Zeta Player"
    self.DupeCooldown = 0
    self.unstuckmin = -50
    self.unstuckmax = 50



    
    self:SetNW2String("zeta_weaponname", self.Weapon)
    self.PhysgunColor = Vector(zetamath.random(255)/255, zetamath.random(255)/255, zetamath.random(255)/255)
    self.PlayermodelColor = col
    self.VoicePitch = (GetConVar('zetaplayer_differentvoicepitch'):GetBool() and zetamath.random(GetConVar("zetaplayer_voicepitchmin"):GetInt(), GetConVar("zetaplayer_voicepitchmax"):GetInt()) or 100)
    self.SpawnPos = self:GetPos()
    self.NextRepathCheckT = CurTime() + 1
    local selfpos = self:GetPos()
    selfpos.x = 0
    selfpos.y = 0
    self.FallHeight = selfpos


    local accuracy = GetConVar("zetaplayer_combataccuracylevel"):GetInt()
    if accuracy != 0 then
        self.Accuracy = accuracylevels[accuracy]
    else
        self.Accuracy = accuracylevels[zetamath.random(4)]
    end


    ---- These fixed some weird state issues and is generally is easier to work with.
    self.CheckforNPCS = CurTime()+zetamath.Rand(0, 3)
    self.CheckforNextBots = CurTime()+zetamath.Rand(0, 1)
    self.CurNoclipPos = self:GetPos()
    self.UpdatePhys = CurTime()+0.1
    self.NextFallingSoundT = CurTime()
    self.checkfloor = CurTime()+2
    self.NextFootstepSnd = CurTime()
    self.HealThanksCooldown = CurTime()
    self.PhysgunWheelSpeed = zetamath.random(400,4000)

    ---- 

    if ( SERVER ) then


        local UseSERVERCACHE = GetConVar("zetaplayer_useservercacheddata"):GetBool()

        if UseSERVERCACHE then
            self.UsingSERVERCACHE = true
        end


        self.TEXTDATA = UseSERVERCACHE and _SERVERTEXTDATA or util.JSONToTable(file.Read("zetaplayerdata/textchatdata.json","DATA"))

        self.MEDIADATA = UseSERVERCACHE and _SERVERMEDIADATA or  util.JSONToTable(file.Read("zetaplayerdata/mediaplayerdata.json","DATA"))

        self.ValidMaterials = UseSERVERCACHE and _SERVERValidMaterials or util.JSONToTable(file.Read('zetaplayerdata/materials.json','DATA'))

        self.ValidProps = UseSERVERCACHE and _SERVERValidProps or util.JSONToTable(file.Read('zetaplayerdata/props.json','DATA'))

        self.ValidNPCS = UseSERVERCACHE and _SERVERValidNPCS or util.JSONToTable(file.Read('zetaplayerdata/npcs.json','DATA'))
        
        self.ValidENTS = UseSERVERCACHE and _SERVERValidENTS or util.JSONToTable(file.Read('zetaplayerdata/ents.json','DATA'))

        
        local decoded = UseSERVERCACHE and _SERVERNAMES or util.JSONToTable(file.Read('zetaplayerdata/names.json','DATA'))

        local nameList = {}
        for i=1, #decoded do
            nameList[decoded[i]] = true
        end
        
        local names = nameList
        for i=1, table_Count(_bannedzetas) do
            if names[_bannedzetas[i]] then names[_bannedzetas[i]] = nil end
        end


        for i=1, #zetas do
            if zetas[i] != self and names[zetas[i].zetaname] then names[zetas[i].zetaname] = nil end
        end

        for i=1, #spawners do
            if names[spawners[i].zetaname] then names[spawners[i].zetaname] = nil end
        end

        if table_Count(names) <= 0 then -- If that ever happens
            names = {}
            for i=1, #decoded do
                names[decoded[i]] = true
            end
        end

        for k, _ in RandomPairs(names) do
            self.zetaname = k
            self:SetNW2String('zeta_name', k)
            break
        end


        if zetamath.random(1,100) < GetConVar("zetaplayer_voicepackchance"):GetInt() and !self.ZetaSpawnerID then
            local _,folders = file.Find("sourceengine/sound/zetaplayer/custom_vo/*","BASE_PATH","namedesc")
            local _,addonfolders = file.Find("sound/zetaplayer/custom_vo/*","GAME","namedesc")
    
            table_Merge(folders,addonfolders)
            
            for _,v in RandomPairs(folders) do
                local IsVP = string.find(v,"vp_")
                if isnumber(IsVP) then
                    self.VoicePack = v
                    break
                end
            end

        end


        if GetConVar('zetaplayer_enablefriend'):GetBool() then

            if game.SinglePlayer() and IsValid(Entity(1)) and GetConVar("zetaplayer_permamentfriendalwaysspawn"):GetBool() and GetConVar('zetaplayer_enablefriend'):GetInt() == 1 then
                local permanentfriends = ZetaGetPermanentFriends()
                local friendtbl = {}

                for k,v in ipairs(permanentfriends) do
                    friendtbl[v] = true
                end

                for k,v in ipairs(zetas) do
                    if friendtbl[v.zetaname] then friendtbl[v.zetaname] = nil end
                end


                    
                for k,v in ipairs(spawners) do
                    if friendtbl[v.zetaname] then friendtbl[v.zetaname] = nil end
                end

                if table_Count(friendtbl) > 0 then
                    for k,v in RandomPairs(friendtbl) do
                        self.zetaname = k
                        break
                    end
                    self:SetNW2String('zeta_name', self.zetaname)
                end
            end

            if zetamath.random(1,100) < GetConVar("zetaplayer_spawnasfriendchance"):GetInt()  then
                local plys = self:GetPlayerZetas()

                for _,ply in RandomPairs(plys) do
                    if ply.IsZetaPlayer and !GetConVar("zetaplayer_allowfriendswithzetas"):GetBool() then continue end
                    if ply:IsPlayer() and !GetConVar("zetaplayer_allowfriendswithplayers"):GetBool() then continue end
                    
                    if IsValid(ply) and self:CanBeFriendsWith(ply) then
                        self:AddFriend(ply)
                        break
                    end
                end

            end


        end

        if GetConVar("zetaplayer_usecustomavatars"):GetBool() then
            local avatars = self:FindVoiceChatAvatar()
            if avatars and #avatars > 0 then
                self.ProfilePicture = avatars[zetamath.random(#avatars)]
            end
            if !self.UsingSERVERCACHE then
                table_Empty(avatars)
            end
        end
        if self.ProfilePicture == nil then
            self.ProfilePicture = "none"
        end
        self:SetNW2String('zeta_profilepicture', self.ProfilePicture)

        if GetConVar('zetaplayer_useteamsystem'):GetBool() then
            local decoded = self:GetTeamSpawnTeams()
            local joinableTeams = {}
            local overrideTeam = GetConVar('zetaplayer_overrideteam'):GetString()
            local teamLimit = GetConVar('zetaplayer_eachteammemberlimit'):GetInt()
            for i=1, #decoded do
                if decoded[i][1] == overrideTeam and overrideTeam != "" then
                    joinableTeams = {decoded[i]}
                    break
                end
                local members = self:GetTeamMembers(decoded[i][1])
                if #members >= teamLimit then
                    DebugText('Team '..decoded[i][1]..' is full! Moving on...')
                    continue
                end
                joinableTeams[#joinableTeams+1] = decoded[i]
            end
            if #joinableTeams > 0 then
                local teamData = joinableTeams[zetamath.random(#joinableTeams)]
        
                self.zetaTeam = teamData[1]
                self:SetNW2String('zeta_team', self.zetaTeam or "")
        
                if teamData[2] then
                    self.PlayermodelColor = teamData[2]
                    self.TeamColor = teamData[2]:ToColor()
                    self:SetNW2Vector('zeta_modelcolor', teamData[2])   
                    self:SetNW2Vector('zeta_teamcolor', teamData[2])   
                end
        
                if teamData.teammodel then
                    spawnmdl = teamData.teammodel
                end
        
                local spawns = self:GetTeamSpawns()
                if #spawns > 0 then
                    local spawn = spawns[zetamath.random(#spawns)]
                    if IsValid(spawn) then self:SetPos(spawn:GetPos()) self.SpawnPos = spawn:GetPos() end
                end
            end
        end

    end

    if ( SERVER ) then 
        if !navmesh.IsLoaded() then
            PrintMessage(HUD_PRINTTALK,'Map has no Navigation Mesh! Create one by using the console command nav_generate')
        end

        local naturalPrefix = (self.IsNatural and "natural" or "")
        self:SetMaxHealth(GetConVar("zetaplayer_"..naturalPrefix.."zetahealth"):GetInt())
        self:SetHealth(self:GetMaxHealth())

        self.Strictness = zetamath.random(GetConVar("zetaplayer_adminsctrictnessmin"):GetInt(),GetConVar("zetaplayer_adminsctrictnessmax"):GetInt())
        
        
        if self.SpawnOVERRIDE then
            

            spawnmdl = self.SpawnOVERRIDE.model or spawnmdl

            local personal = self.SpawnOVERRIDE.personality

            self.BuildChance = personal.build or zetamath.random(60)
            self.CombatChance = personal.combat or zetamath.random(10)
            self.ToolChance = personal.tool or zetamath.random(60)
            self.PhysgunChance = personal.phys or zetamath.random(60)
            self.DisrespectChance = personal.disre or zetamath.random(60)
            self.WatchMediaPlayerChance = personal.media or zetamath.random(60)
            self.FriendlyChance = personal.friendly or zetamath.random(60)
            self.VoiceChance = personal.voice or zetamath.random(60)
            self.VehicleChance = personal.vehicle or zetamath.random(60)
            self.VoicePitch = personal.voicepitch or 100
            self.Strictness = personal.strictness or self.Strictness
            self.TextChance = personal.text or zetamath.random(20)

            self.PERSCHANCES = {
                {"Build",chance = self.BuildChance,func = function() self:ComputeBuildChance() end},
                {"Combat",chance = self.CombatChance,func = function() self:ComputeCombatChance() end},
                {"Tool",chance = self.ToolChance,func = function() self:ComputeToolChance() end},
                {"Phys",chance = self.PhysgunChance,func = function() self:ComputePhysgunChance() end},
                
                {"Watch",chance = self.WatchMediaPlayerChance,func = function() self:ComputeWatchmediaChance() end},
                {"Friendly",chance = self.FriendlyChance,func = function() self:ComputeFriendlyChance() end},
                {"Vehicle",chance = self.VehicleChance,func = function() self:ComputeVehicleChance() end},
            }
            
            self.PhysgunColor = self.SpawnOVERRIDE.physgunclr or self.PhysgunColor

            self.PlayermodelColor = self.SpawnOVERRIDE.playerclr or self.PlayermodelColor

            self.zetaname = self.SpawnOVERRIDE.name or self.zetaname
            self:SetNW2String('zeta_name', self.zetaname)
            
            self.zetaTeam = self.SpawnOVERRIDE.zetateam or self.zetaTeam
            self.TeamColor = self.overrideTeamColor or self.TeamColor

            self.Accuracy = self.SpawnOVERRIDE.accuratelevel or self.Accuracy

            if self.TeamColor then
                self:SetNW2Vector('zeta_teamcolor', self.TeamColor:ToVector())
            end
            self:SetNW2String('zeta_team', self.zetaTeam or "")

            self.ProfilePicture = self.SpawnOVERRIDE.pfp or self.ProfilePicture
            self.VoicePack = self.SpawnOVERRIDE.vp or self.VoicePack 

            local physcol = !isvector(self.PhysgunColor) and self.PhysgunColor:ToVector() or self.PhysgunColor

            self:SetNW2Vector('zeta_physcolor', physcol)
            self:SetNW2String('zeta_profilepicture', self.ProfilePicture)
            self:SetNW2Vector('zeta_modelcolor', self.PlayermodelColor)
        else
            local personalityCvar = GetConVar('zetaplayer_'..naturalPrefix..'personalitytype'):GetString()

            if personalityCvar == 'random' then

                
                self.BuildChance = zetamath.random(60)
                self.CombatChance = zetamath.random(10)
                self.ToolChance = zetamath.random(60)
                self.PhysgunChance = zetamath.random(60)
                self.DisrespectChance = zetamath.random(60)
                self.WatchMediaPlayerChance = zetamath.random(60)
                self.FriendlyChance = zetamath.random(60)
                self.VoiceChance = zetamath.random(60)
                self.VehicleChance = zetamath.random(60)
                self.TextChance = zetamath.random(20)

                self.PERSCHANCES = {
                    {"Build",chance = self.BuildChance,func = function() self:ComputeBuildChance() end},
                    {"Combat",chance = self.CombatChance,func = function() self:ComputeCombatChance() end},
                    {"Tool",chance = self.ToolChance,func = function() self:ComputeToolChance() end},
                    {"Phys",chance = self.PhysgunChance,func = function() self:ComputePhysgunChance() end},
                    
                    {"Watch",chance = self.WatchMediaPlayerChance,func = function() self:ComputeWatchmediaChance() end},
                    {"Friendly",chance = self.FriendlyChance,func = function() self:ComputeFriendlyChance() end},
                    {"Vehicle",chance = self.VehicleChance,func = function() self:ComputeVehicleChance() end},
                }

                self.Personality = "Random"
            elseif personalityCvar == 'random++' then
                self.BuildChance = zetamath.random(1,100) 
                self.CombatChance = zetamath.random(1,100) 
                self.ToolChance = zetamath.random(1,100) 
                self.PhysgunChance = zetamath.random(1,100) 
                self.DisrespectChance = zetamath.random(1,100) 
                self.WatchMediaPlayerChance = zetamath.random(1,100) 
                self.FriendlyChance = zetamath.random(1,100) 
                self.VoiceChance = zetamath.random(1,100) 
                self.VehicleChance = zetamath.random(1,100) 
                self.TextChance = zetamath.random(1,100)

                self.PERSCHANCES = {
                    {"Build",chance = self.BuildChance,func = function() self:ComputeBuildChance() end},
                    {"Combat",chance = self.CombatChance,func = function() self:ComputeCombatChance() end},
                    {"Tool",chance = self.ToolChance,func = function() self:ComputeToolChance() end},
                    {"Phys",chance = self.PhysgunChance,func = function() self:ComputePhysgunChance() end},
                    
                    {"Watch",chance = self.WatchMediaPlayerChance,func = function() self:ComputeWatchmediaChance() end},
                    {"Friendly",chance = self.FriendlyChance,func = function() self:ComputeFriendlyChance() end},
                    {"Vehicle",chance = self.VehicleChance,func = function() self:ComputeVehicleChance() end},
                }

                self.Personality = "Random +"
            elseif personalityCvar == 'builder' then
                self.BuildChance = 70
                self.CombatChance = 1
                self.ToolChance = 70
                self.PhysgunChance = 40
                self.DisrespectChance = 10
                self.WatchMediaPlayerChance = 10
                self.FriendlyChance = 10
                self.VoiceChance = 30
                self.VehicleChance = 50
                self.TextChance = zetamath.random(30)

                self.PERSCHANCES = {
                    {"Build",chance = self.BuildChance,func = function() self:ComputeBuildChance() end},
                    {"Combat",chance = self.CombatChance,func = function() self:ComputeCombatChance() end},
                    {"Tool",chance = self.ToolChance,func = function() self:ComputeToolChance() end},
                    {"Phys",chance = self.PhysgunChance,func = function() self:ComputePhysgunChance() end},
                    
                    {"Watch",chance = self.WatchMediaPlayerChance,func = function() self:ComputeWatchmediaChance() end},
                    {"Friendly",chance = self.FriendlyChance,func = function() self:ComputeFriendlyChance() end},
                    {"Vehicle",chance = self.VehicleChance,func = function() self:ComputeVehicleChance() end},
                }

                self.Personality = "Builder"
            elseif personalityCvar == 'berserk' then
                self.BuildChance = 5
                self.CombatChance = 80
                self.ToolChance = 5
                self.PhysgunChance = 70
                self.DisrespectChance = 70
                self.WatchMediaPlayerChance = 3
                self.FriendlyChance = 1
                self.VoiceChance = 30
                self.VehicleChance = 1
                self.TextChance = zetamath.random(30)

                self.PERSCHANCES = {
                    {"Build",chance = self.BuildChance,func = function() self:ComputeBuildChance() end},
                    {"Combat",chance = self.CombatChance,func = function() self:ComputeCombatChance() end},
                    {"Tool",chance = self.ToolChance,func = function() self:ComputeToolChance() end},
                    {"Phys",chance = self.PhysgunChance,func = function() self:ComputePhysgunChance() end},
                    
                    {"Watch",chance = self.WatchMediaPlayerChance,func = function() self:ComputeWatchmediaChance() end},
                    {"Friendly",chance = self.FriendlyChance,func = function() self:ComputeFriendlyChance() end},
                    {"Vehicle",chance = self.VehicleChance,func = function() self:ComputeVehicleChance() end},
                }

                self.Personality = "Aggressor"
            elseif personalityCvar == 'custom' then 
                self.BuildChance = GetConVar('zetaplayer_'..naturalPrefix..'buildchance'):GetInt()
                self.CombatChance = GetConVar('zetaplayer_'..naturalPrefix..'combatchance'):GetInt()
                self.ToolChance = GetConVar('zetaplayer_'..naturalPrefix..'toolchance'):GetInt()
                self.PhysgunChance = GetConVar('zetaplayer_'..naturalPrefix..'physgunchance'):GetInt()
                self.DisrespectChance = GetConVar('zetaplayer_'..naturalPrefix..'disrespectchance'):GetInt()
                self.WatchMediaPlayerChance = GetConVar('zetaplayer_'..naturalPrefix..'watchmediaplayerchance'):GetInt()
                self.FriendlyChance = GetConVar('zetaplayer_'..naturalPrefix..'friendlychance'):GetInt()
                self.VoiceChance = GetConVar('zetaplayer_'..naturalPrefix..'voicechance'):GetInt()
                self.VehicleChance = GetConVar('zetaplayer_'..naturalPrefix..'vehiclechance'):GetInt()
                self.TextChance = GetConVar('zetaplayer_'..naturalPrefix..'textchance'):GetInt()

                self.PERSCHANCES = {
                    {"Build",chance = self.BuildChance,func = function() self:ComputeBuildChance() end},
                    {"Combat",chance = self.CombatChance,func = function() self:ComputeCombatChance() end},
                    {"Tool",chance = self.ToolChance,func = function() self:ComputeToolChance() end},
                    {"Phys",chance = self.PhysgunChance,func = function() self:ComputePhysgunChance() end},
                    
                    {"Watch",chance = self.WatchMediaPlayerChance,func = function() self:ComputeWatchmediaChance() end},
                    {"Friendly",chance = self.FriendlyChance,func = function() self:ComputeFriendlyChance() end},
                    {"Vehicle",chance = self.VehicleChance,func = function() self:ComputeVehicleChance() end},
                }

                self.Personality = "Custom"
            end

            self:SetNW2Vector('zeta_physcolor',self.PhysgunColor)
            self:SetNW2Vector('zeta_modelcolor',self.PlayermodelColor)
        end

        if GetConVar('zetaplayer_useprofilesystem'):GetBool() and !self.ZetaSpawnerID then
            local json = file.Read('zetaplayerdata/profiles.json','DATA')
            local decoded = util.JSONToTable(json)
        
            for k, _ in pairs(decoded) do
                if table_HasValue(_bannedzetas,k) then decoded[k] = nil end
            end
            
            for i=1, #zetas do
                if zetas[i] != self and zetas[i].zetaname and decoded[zetas[i].zetaname] then decoded[zetas[i].zetaname] = nil end
            end
            for i=1, #spawners do
                if spawners[i].zetaname and decoded[spawners[i].zetaname] then decoded[spawners[i].zetaname] = nil end
            end
        
            local searchProfile = nil
            local spawnerData = self:GetNW2String('zeta_spawneroverride','none')
            if spawnerData != 'none' then
                searchProfile = string.Explode(',',spawnerData)[10]
            end
        
            local name, profileData
            if !searchProfile then
                if ( GetConVar("zetaplayer_profilesystemonly"):GetBool() or math.random( 1, 100 ) < GetConVar("zetaplayer_profileusechance"):GetInt() ) and !table_IsEmpty(decoded) then
                    for k, v in RandomPairs(decoded) do
                        name = k
                        profileData = v
                        break
                    end
                elseif decoded[self.zetaname] then
                    name = self.zetaname 
                    profileData = decoded[name]
                end
            else
                name = searchProfile
                profileData = decoded[name]
            end
        
            if name != nil and profileData then
                self.zetaname = name
                self:SetNW2String('zeta_name', name)
            
                local model = profileData['playermodel']
                if model != nil and util.IsValidModel(model) then
                    spawnmdl = model
                end
            
                if profileData['avatar'] then
                    local pfp = profileData['avatar']
                    local avatar = 'zetaplayerdata/custom_avatars/'..pfp
                    if pfp == model or file.Exists(avatar, 'DATA') then
                        if pfp != model then
                            self.ProfilePicture = '../data/'..avatar
                        else
                            self.ProfilePicture = 'none'
                        end
                        self:SetNW2String('zeta_profilepicture', self.ProfilePicture)
                    end
                end
            
                local personality = profileData['personality']
                if personality != nil then
                    self.BuildChance = tonumber(personality['build']) or self.BuildChance
                    self.CombatChance = tonumber(personality['combat']) or self.CombatChance
                    self.ToolChance = tonumber(personality['tool']) or self.ToolChance
                    self.PhysgunChance = tonumber(personality['physgun']) or self.PhysgunChance
                    self.DisrespectChance = tonumber(personality['disrespect']) or self.DisrespectChance
                    self.WatchMediaPlayerChance = tonumber(personality['watchmedia']) or self.WatchMediaPlayerChance
                    self.FriendlyChance = tonumber(personality['friendly']) or self.FriendlyChance
                    self.VoiceChance = tonumber(personality['voice']) or self.VoiceChance
                    self.VehicleChance = tonumber(personality['vehicle']) or self.VehicleChance
                    self.TextChance = tonumber(personality['text']) or self.TextChance

                    self.PERSCHANCES = {
                        {"Build",chance = self.BuildChance,func = function() self:ComputeBuildChance() end},
                        {"Combat",chance = self.CombatChance,func = function() self:ComputeCombatChance() end},
                        {"Tool",chance = self.ToolChance,func = function() self:ComputeToolChance() end},
                        {"Phys",chance = self.PhysgunChance,func = function() self:ComputePhysgunChance() end},
                        
                        {"Watch",chance = self.WatchMediaPlayerChance,func = function() self:ComputeWatchmediaChance() end},
                        {"Friendly",chance = self.FriendlyChance,func = function() self:ComputeFriendlyChance() end},
                        {"Vehicle",chance = self.VehicleChance,func = function() self:ComputeVehicleChance() end},
                    }

                    self.Personality = "PROFILE"
                end

                self.IsAdmin = false
            
                if profileData["admindata"] then
                    self.IsAdmin = profileData["admindata"]["isadmin"] or self.IsAdmin
                    self.Strictness = profileData["admindata"]["strictness"] or self.Strictness
                end
                
                self.IsMingebag = profileData["mingebag"] 

                local overrideTeam = profileData["teamoverride"]
                if overrideTeam and GetConVar('zetaplayer_useteamsystem'):GetBool() then
                    local teams = file.Read('zetaplayerdata/teams.json','DATA')
                    decoded = util.JSONToTable(teams)
                    
                    local teamData = nil
                    for i=1, #decoded do
                        if decoded[i][1] != overrideTeam then continue end
                        teamData = decoded[i]
                        break
                    end
                    if teamData then
                        self.zetaTeam = teamData[1]
                        self:SetNW2String('zeta_team', self.zetaTeam or "")

                        if teamData[2] then
                            self.PlayermodelColor = teamData[2]
                            self.TeamColor = teamData[2]:ToColor()
                            self:SetNW2Vector('zeta_modelcolor', teamData[2])   
                            self:SetNW2Vector('zeta_teamcolor', teamData[2])   
                        end

                        if teamData.teammodel then
                            spawnmdl = teamData.teammodel
                        end

                        local spawns = self:GetTeamSpawns()
                        if #spawns > 0 then
                            local spawn = spawns[zetamath.random(#spawns)]
                            if IsValid(spawn) then self:SetPos(spawn:GetPos()) end
                        end
                    end
                end

                self.profilebodygroups = profileData["bodygroups"] or nil
                 
                self.profileSkin = profileData["skin"] or nil


                self.UsingaProfile = true 
                self.VoicePack = profileData["voicepack"] or self.VoicePack
                self.VoicePitch = profileData["voicepitch"] or self.VoicePitch
                self.CustomSpawnWeapon = profileData["weapon"] or nil 

                self.PhysgunColor = profileData["physguncolor"] or self.PhysgunColor
                self.PlayermodelColor = profileData["playermodelcolor"] or self.PlayermodelColor

                if profileData["permafriend"] then
                    self:AddFriend(Entity(1),true)
                end

                local level = profileData["accuracylevel"]

                
                if level and level != 0 then
                    self.Accuracy = accuracylevels[level] or self.Accuracy
                elseif level then
                    self.Accuracy = accuracylevels[zetamath.random(1,4)] or self.Accuracy
                end

                if self.PlayermodelColor and !isvector(self.PlayermodelColor) then
                    self.PlayermodelColor = Color(profileData["playermodelcolor"].r,profileData["playermodelcolor"].g,profileData["playermodelcolor"].b):ToVector()
                end

                if self.PhysgunColor and !isvector(self.PhysgunColor) then
                    self.PhysgunColor = Color(profileData["physguncolor"].r,profileData["physguncolor"].g,profileData["physguncolor"].b):ToVector()
                end

                self.nodisconnect = profileData["nodisconnect"]

                self:SetNW2Vector('zeta_physcolor',self.PhysgunColor)
                self:SetNW2Vector('zeta_modelcolor',self.PlayermodelColor)

                if profileData["health"] then
                    self:SetMaxHealth(profileData["health"])
                    self:SetHealth(profileData["health"])
                end

                if profileData["armor"] then
                    timer.Simple(0,function()
                        self.MaxArmor = math.max(100, profileData["armor"])
                        self.CurrentArmor = profileData["armor"]
                    end)
                end

                
                self.FavouriteWeapon = profileData["favouriteweapon"] or nil

                self.UseCustomIdle = profileData["usecustomidle"] or nil
                self.UseCustomDeath = profileData["usecustomdeath"] or nil
                self.UseCustomKill = profileData["usecustomkill"] or nil
                self.UseCustomTaunt = profileData["usecustomtaunt"] or nil
                self.UseCustomPanic = profileData["usecustompanic"] or nil
                self.UseCustomAssist = profileData["usecustomassist"] or nil
                self.UseCustomLaugh = profileData["usecustomlaugh"] or nil
                self.UseCustomWitness = profileData["usecustomwitness"] or nil
                self.UseCustomAdminScold = profileData["usecustomadminscold"] or nil
                self.UseCustomFalling = profileData["usecustomFalling"] or nil
                self.UseCustomSitRespond = profileData["usecustomSitRespond"] or nil
                self.UseCustomQuestion = profileData["usecustomQuestion"] or nil
                self.UseCustomConRespond = profileData["usecustomConRespond"] or nil
                self.UseCustomMediaWatch = profileData["usecustomMediaWatch"] or nil
            end
        end

        if !self.IsNatural and GetConVar("zetaplayer_mingebag"):GetBool() or self.IsNatural and GetConVar("zetaplayer_mapwidemingebag"):GetBool() and zetamath.random(100) <= GetConVar("zetaplayer_mapwidemingebagspawnchance"):GetInt() then
            self.IsMingebag = true 
        end

        if self.IsAdmin then
            self.IsMingebag = false
            self:SetNW2Bool("zeta_isadmin", true)
        end

        if self.IsMingebag then
            self.CanPlayFootstep = false
            spawnmdl = "models/Kleiner.mdl" 
        end

        if GetConVar("zetaplayer_overridetextchance"):GetBool() then
            self.TextChance = GetConVar("zetaplayer_textchanceoverride"):GetInt()
        end

        if GetConVar("zetaplayer_usenewchancesystem"):GetBool() then
            table_sort(self.PERSCHANCES,function(a,b) return a.chance > b.chance end)
        end


        self:SetModel(spawnmdl)
        self.CurrentNavArea = navmesh.GetNavArea(self:GetPos(),10000) 
        self:AddFlags(FL_OBJECT+FL_NPC)
        self:SetCollisionBounds(Vector(-10,-10,0),Vector(10,10,72))
        self:PhysicsInitShadow()

        if !GetConVar("zetaplayer_noplycollisions"):GetBool() then
            self:SetCollisionGroup(COLLISION_GROUP_NPC)
        else
            self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
        end

        self:AddCallback('PhysicsCollide',function(self,data)
            self:HandleCollision(data)
        end) 
        self.loco:SetJumpHeight(70)
        self.loco:SetGravity(GetConVar("sv_gravity"):GetFloat())
        self.loco:SetAcceleration(800)
        self.loco:SetDeathDropHeight( 150 )

        self:SetupAchievements()
        


        if !self.SpawnOVERRIDE then
            self:ConnectMessage()
        end

        if self.ProfilePicture == "none" then
            self.ProfilePicture = "spawnicons/"..string.StripExtension(self:GetModel())..".png"
            self:SetNW2String('zeta_profilepicture',self.ProfilePicture)
        end

        
        self:SetNW2Vector("zeta_playermodelcolor", self.PlayermodelColor)


        if !self.IsMingebag and !self.UsingaProfile then
            if self.BodygroupData != nil then        
                for i = 1, #self.BodygroupData do
                    self:SetBodygroup(self.BodygroupData[i][1], self.BodygroupData[i][2])
                end
            elseif GetConVar("zetaplayer_randombodygroups"):GetBool() then
                local groups = self:GetBodyGroups()
                for i=1, #groups do
                    local count = groups[i].num
                    local bodygroup = groups[i].id
            
                    self:SetBodygroup( bodygroup, zetamath.random(count) )
                end
            end

            if self.SkinData != nil then
                self:SetSkin(self.SkinData)
            elseif GetConVar("zetaplayer_randomskingroups"):GetBool() then
                local skins = self:SkinCount()
                self:SetSkin(zetamath.random(0, skins-1))
            end
        end

        if self.profilebodygroups then
            for i=1, #self.profilebodygroups do
                self:SetBodygroup(self.profilebodygroups[i][2],self.profilebodygroups[i][1])
            end
        end

        if self.profileSkin then
            self:SetSkin(self.profileSkin)
        end

        if GetConVar("zetaplayer_usenewvoicechatsystem"):GetBool() then
            local mouth_sideways = self:GetFlexIDByName( "mouth_sideways" )
            if mouth_sideways and self:GetFlexBounds(mouth_sideways) == -1 and self:GetFlexWeight(mouth_sideways) == 0.0 then
                self:SetFlexWeight(mouth_sideways, 0.5)
            end
            local jaw_sideways = self:GetFlexIDByName( "jaw_sideways" )
            if jaw_sideways and self:GetFlexBounds(jaw_sideways) == -1 and self:GetFlexWeight(jaw_sideways) == 0.0 then
                self:SetFlexWeight(jaw_sideways, 0.5)
            end

            -- Setting up the flexes if we have it
            local jaw_drop = self:GetFlexIDByName( "jaw_drop" )
            local rmouth_drop = self:GetFlexIDByName( "right_mouth_drop" )
            local lmouth_drop = self:GetFlexIDByName( "left_mouth_drop" )

            if jaw_drop and rmouth_drop and lmouth_drop then
                self:SetFlexWeight( jaw_drop, 0 )
                self:SetFlexWeight( rmouth_drop, 0 )
                self:SetFlexWeight( lmouth_drop, 0 )
            end
        end

        local lookup = self:LookupAttachment('anim_attachment_RH')
        local attachment = self:GetAttachmentPoint("hand")

        if lookup != 0 and !self.IsMingebag then
            self.HasProperAttachment = true
        end
    
        self.WeaponENT = ents_Create('base_anim') -- Create the Fake weapon
        self.WeaponENT:SetOwner(self)
        self.WeaponENT.IsWeaponEnt = true
        self.WeaponENT:AddEffects(EF_BONEMERGE)
        self.WeaponENT:SetMoveType(MOVETYPE_NONE)
        self.WeaponENT:SetPos(attachment.Pos)
        self.WeaponENT:SetAngles(attachment.Ang)
        if !self.IsMingebag then
            self.WeaponENT:SetParent(self, lookup)
        else
            self.WeaponENT:SetParent(self)
        end
        self.WeaponENT:SetModel('models/hunter/plates/plate.mdl') -- Yes it starts off as a cube
        self.WeaponENT:SetMaterial('null')
        self:SetNW2Entity( 'zeta_weaponent', self.WeaponENT )


        
        self:InitializeHooks() -- All hooks are in util.lua. Organizing purposes

        if (!ZetaNavMesh_HidingSpots or navmesh.GetNavAreaCount() != ZetaNavMesh_LastHidingSpotCheckAreaCount) and navmesh.IsLoaded() then
            ZetaNavMesh_HidingSpots = {}
            ZetaNavMesh_LastHidingSpotCheckAreaCount = navmesh.GetNavAreaCount()
            for i=1, #_ZETANAVMESH do
                if _ZETANAVMESH[i] and _ZETANAVMESH[i]:IsValid() and !_ZETANAVMESH[i]:IsUnderwater() then
                    local hSpots = _ZETANAVMESH[i]:GetHidingSpots()
                    if #hSpots > 0 then
                        table_insert(ZetaNavMesh_HidingSpots, {_ZETANAVMESH[i], hSpots})
                    end
                end
            end
        end
        

    end

    if ( CLIENT ) then

        local zetarender = {}

        zetarender.SetMaterial = render.SetMaterial
        zetarender.DrawSprite = render.DrawSprite
        zetarender.StartBeam = render.StartBeam
        zetarender.EndBeam = render.EndBeam
        zetarender.AddBeam = render.AddBeam

        self.GetPlayerColor = function() return self:GetNW2Vector("zeta_playermodelcolor",Vector( 1, 1, 1 )) end


        hook.Add('PreDrawEffects','zetaPhysguneffects'..self:EntIndex(),function()
            if !IsValid(self) then hook.Remove('PreDrawEffects','zetaPhysguneffects'..self:EntIndex()) return end

            local attachment
            local weapon = self:GetNW2Entity('zeta_weaponent',self)
            local lookup = self:LookupAttachment('anim_attachment_RH')
            if lookup != 0 then
                attachment = self:GetAttachment(lookup)
            else
                attachment = {Pos = self:GetPos()+self:OBBCenter(),Ang = Angle(0,0,0)}
            end
            
            if GetConVar('zetaplayer_drawflashlight'):GetBool() and self.FlashlightEnabled then
                zetarender.SetMaterial( FlashlightSprite )
                if lookup != 0 then
                    zetarender.DrawSprite( attachment.Pos+attachment.Ang:Forward()*3, 4, 4, Color(255,255,255,249) )
                elseif IsValid(weapon) then
                    zetarender.DrawSprite( weapon:GetPos()+weapon:GetForward()*3, 4, 4, Color(255,255,255,249) )
                else
                    zetarender.DrawSprite( self:GetPos(), 4, 4, Color(255,255,255,249) )
                end
            end
            
            if !IsValid(weapon) or weapon:GetModel() != 'models/weapons/w_physics.mdl' then return end
            
            local color = self:GetNW2Vector('zeta_physcolor',Vector(1,1,1)):ToColor()
            local size = zetamath.random(30,50)
            zetarender.SetMaterial( PhysgunGlowMat )
            zetarender.DrawSprite( (weapon:GetPos()+Vector(0,0,2))+weapon:GetForward()*25, size, size, color )
            zetarender.SetMaterial( PhysgunGlowMat2 )
            zetarender.DrawSprite( (weapon:GetPos()+Vector(0,0,2))+weapon:GetForward()*30, size, size, color )

            local shoulddraw = self:GetNW2Bool('zeta_drawphysgunbeam',false)
            if shoulddraw and IsValid(self) and IsValid(weapon) and weapon:GetModel() == 'models/weapons/w_physics.mdl' then
                local startpos = weapon:GetAttachment(1).Pos
                local ang = weapon:GetAttachment(1).Ang
                local ends = self:GetNW2Vector("zeta_physgunendbeam",Vector(0,0,0))
                zetarender.SetMaterial( PhysgunBeam )
                
                zetarender.StartBeam(11)
                zetarender.AddBeam( startpos, zetamath.random(2,5), zetamath.random(20,50), color)
                    zetarender.AddBeam( LerpVector(0.02,startpos+ang:Forward()*20,ends), zetamath.random(2,5), zetamath.random(20,50), color)
                    for i = 1, 8 do
                        zetarender.AddBeam( LerpVector(i/20,startpos+ang:Forward()*(30+i*10),ends), zetamath.random(2,5), zetamath.random(20,50), color)
                    end
                    zetarender.AddBeam( ends, zetamath.random(2,5), zetamath.random(20,50), color)
                zetarender.EndBeam()
                
                zetarender.SetMaterial( PhysgunGlowMat )
                local sizepointer = zetamath.random(10,15)
                zetarender.DrawSprite( ends, sizepointer, sizepointer, color )
            end
        end)
    end


    if SERVER then

    local addon = ""

    if self.VoicePack != "none" then
        addon = self.VoicePack.."/"
        local exists = file.Exists( "sourceengine/sound/zetaplayer/custom_vo/"..addon.."idle", "BASE_PATH" ) or file.Exists( "sound/zetaplayer/custom_vo/"..addon.."idle", "GAME" )
        if !exists then
            addon = ""
        else
            self.IDLEVOICEPACKEXISTS = true
        end
        
    end

    local dirSnds = file.Find("sourceengine/sound/zetaplayer/custom_vo/"..addon.."idle/*","BASE_PATH","namedesc")
    local addondirSnds = file.Find("sound/zetaplayer/custom_vo/"..addon.."idle/*","GAME","namedesc")

    self.IdleSoundCount = (!self.IDLEVOICEPACKEXISTS and (!dirSnds) and 0 or !self.IDLEVOICEPACKEXISTS and #dirSnds) or (self.IDLEVOICEPACKEXISTS and (!addondirSnds) and 0 or self.IDLEVOICEPACKEXISTS and #addondirSnds)
    --print("Found ",self.IdleSoundCount," idle sound Files")
    table_Empty(dirSnds)

    if self.VoicePack != "none" then
        addon = self.VoicePack.."/"
        local exists = file.Exists( "sourceengine/sound/zetaplayer/custom_vo/"..addon.."death", "BASE_PATH" ) or file.Exists( "sound/zetaplayer/custom_vo/"..addon.."death", "GAME" )
        if !exists then
            addon = ""
        else
            self.DEATHVOICEPACKEXISTS = true
        end
    end


    dirSnds = file.Find("sourceengine/sound/zetaplayer/custom_vo/"..addon.."death/*","BASE_PATH","namedesc")
    local addondirSnds = file.Find("sound/zetaplayer/custom_vo/"..addon.."death/*","GAME","namedesc")

    self.DeathSoundCount = (!self.DEATHVOICEPACKEXISTS and (!dirSnds) and 0 or !self.DEATHVOICEPACKEXISTS and #dirSnds) or (self.DEATHVOICEPACKEXISTS and (!addondirSnds) and 0 or self.DEATHVOICEPACKEXISTS and #addondirSnds)

    --print("Found ",self.DeathSoundCount," death sound Files")
    table_Empty(dirSnds)

    if self.VoicePack != "none" then
        addon = self.VoicePack.."/"
        local exists = file.Exists( "sourceengine/sound/zetaplayer/custom_vo/"..addon.."kill", "BASE_PATH" ) or file.Exists( "sound/zetaplayer/custom_vo/"..addon.."kill", "GAME" )
        if !exists then
            addon = ""
        else
            self.KILLVOICEPACKEXISTS = true
        end
    end

    dirSnds = file.Find("sourceengine/sound/zetaplayer/custom_vo/"..addon.."kill/*","BASE_PATH","namedesc")
    local addondirSnds = file.Find("sound/zetaplayer/custom_vo/"..addon.."kill/*","GAME","namedesc")
    self.KillSoundCount = (!self.KILLVOICEPACKEXISTS and (!dirSnds) and 0 or !self.KILLVOICEPACKEXISTS and #dirSnds) or (self.KILLVOICEPACKEXISTS and (!addondirSnds) and 0 or self.KILLVOICEPACKEXISTS and #addondirSnds)
    --print("Found ",self.KillSoundCount," kill sound Files")
    table_Empty(dirSnds)

    if self.VoicePack != "none" then
        addon = self.VoicePack.."/"
        local exists = file.Exists( "sourceengine/sound/zetaplayer/custom_vo/"..addon.."taunt", "BASE_PATH" ) or file.Exists( "sound/zetaplayer/custom_vo/"..addon.."taunt", "GAME" )
        if !exists then
            addon = ""
        else
            self.TAUNTVOICEPACKEXISTS = true
        end
    end

    dirSnds = file.Find("sourceengine/sound/zetaplayer/custom_vo/"..addon.."taunt/*","BASE_PATH","namedesc")
    local addondirSnds = file.Find("sound/zetaplayer/custom_vo/"..addon.."taunt/*","GAME","namedesc")
    self.TauntSoundCount = (!self.TAUNTVOICEPACKEXISTS and (!dirSnds) and 0 or !self.TAUNTVOICEPACKEXISTS and #dirSnds) or (self.TAUNTVOICEPACKEXISTS and (!addondirSnds) and 0 or self.TAUNTVOICEPACKEXISTS and #addondirSnds)

    --print("Found ",self.TauntSoundCount," taunt sound Files")
    table_Empty(dirSnds)

    if self.VoicePack != "none" then
        addon = self.VoicePack.."/"
        local exists = file.Exists( "sourceengine/sound/zetaplayer/custom_vo/"..addon.."witness", "BASE_PATH" ) or file.Exists( "sound/zetaplayer/custom_vo/"..addon.."witness", "GAME" )
        if !exists then
            addon = ""
        else
            self.WITNESSVOICEPACKEXISTS = true
        end
    end

    dirSnds = file.Find("sourceengine/sound/zetaplayer/custom_vo/"..addon.."witness/*","BASE_PATH","namedesc")
    local addondirSnds = file.Find("sound/zetaplayer/custom_vo/"..addon.."witness/*","GAME","namedesc")
    self.WitnessSoundCount = (!self.WITNESSVOICEPACKEXISTS and (!dirSnds) and 0 or !self.WITNESSVOICEPACKEXISTS and #dirSnds) or (self.WITNESSVOICEPACKEXISTS and (!addondirSnds) and 0 or self.WITNESSVOICEPACKEXISTS and #addondirSnds)


    --print("Found ",self.WitnessSoundCount," witness sound Files")
    table_Empty(dirSnds)

    if self.VoicePack != "none" then
        addon = self.VoicePack.."/"
        local exists = file.Exists( "sourceengine/sound/zetaplayer/custom_vo/"..addon.."assist", "BASE_PATH" ) or file.Exists( "sound/zetaplayer/custom_vo/"..addon.."assist", "GAME" )
        if !exists then
            addon = ""
        else
            self.ASSISTVOICEPACKEXISTS = true
        end
    end

    dirSnds = file.Find("sourceengine/sound/zetaplayer/custom_vo/"..addon.."assist/*","BASE_PATH","namedesc")
    local addondirSnds = file.Find("sound/zetaplayer/custom_vo/"..addon.."assist/*","GAME","namedesc")
    self.AssistSoundCount = (!self.ASSISTVOICEPACKEXISTS and (!dirSnds) and 0 or !self.ASSISTVOICEPACKEXISTS and #dirSnds) or (self.ASSISTVOICEPACKEXISTS and (!addondirSnds) and 0 or self.ASSISTVOICEPACKEXISTS and #addondirSnds)

    --print("Found ",self.AssistSoundCount," assist sound Files")
    table_Empty(dirSnds)

    if self.VoicePack != "none" then
        addon = self.VoicePack.."/"
        local exists = file.Exists( "sourceengine/sound/zetaplayer/custom_vo/"..addon.."laugh", "BASE_PATH" ) or file.Exists( "sound/zetaplayer/custom_vo/"..addon.."laugh", "GAME" )
        if !exists then
            addon = ""
        else
            self.LAUGHVOICEPACKEXISTS = true
        end
    end

    dirSnds = file.Find("sourceengine/sound/zetaplayer/custom_vo/"..addon.."laugh/*","BASE_PATH","namedesc")
    local addondirSnds = file.Find("sound/zetaplayer/custom_vo/"..addon.."laugh/*","GAME","namedesc")
    self.LaughSoundCount = (!self.LAUGHVOICEPACKEXISTS and (!dirSnds) and 0 or !self.LAUGHVOICEPACKEXISTS and #dirSnds) or (self.LAUGHVOICEPACKEXISTS and (!addondirSnds) and 0 or self.LAUGHVOICEPACKEXISTS and #addondirSnds)

    --print("Found ",self.LaughSoundCount," laugh sound Files")
    table_Empty(dirSnds)

    if self.VoicePack != "none" then
        addon = self.VoicePack.."/"
        local exists = file.Exists( "sourceengine/sound/zetaplayer/custom_vo/"..addon.."panic", "BASE_PATH" ) or file.Exists( "sound/zetaplayer/custom_vo/"..addon.."panic", "GAME" )
        if !exists then
            addon = ""
        else
            self.PANICVOICEPACKEXISTS = true
        end
    end

    dirSnds = file.Find("sourceengine/sound/zetaplayer/custom_vo/"..addon.."panic/*","BASE_PATH","namedesc")
    local addondirSnds = file.Find("sound/zetaplayer/custom_vo/"..addon.."panic/*","GAME","namedesc")
    self.PanicSoundCount = (!self.PANICVOICEPACKEXISTS and (!dirSnds) and 0 or !self.PANICVOICEPACKEXISTS and #dirSnds) or (self.PANICVOICEPACKEXISTS and (!addondirSnds) and 0 or self.PANICVOICEPACKEXISTS and #addondirSnds)

    --print("Found ",self.PanicSoundCount," panic sound Files")
    table_Empty(dirSnds)

    if self.VoicePack != "none" then
        addon = self.VoicePack.."/"
        local exists = file.Exists( "sourceengine/sound/zetaplayer/custom_vo/"..addon.."adminscold", "BASE_PATH" ) or file.Exists( "sound/zetaplayer/custom_vo/"..addon.."adminscold", "GAME" )
        if !exists then
            addon = ""
        else
            self.ADMINSCOLDVOICEPACKEXISTS = true
        end
    end

    dirSnds = file.Find("sourceengine/sound/zetaplayer/custom_vo/"..addon.."adminscold/*","BASE_PATH","namedesc")
    local addondirSnds = file.Find("sound/zetaplayer/custom_vo/"..addon.."adminscold/*","GAME","namedesc")
    self.AdminScoldSoundCount = (!self.ADMINSCOLDVOICEPACKEXISTS and (!dirSnds) and 0 or !self.ADMINSCOLDVOICEPACKEXISTS and #dirSnds) or (self.ADMINSCOLDVOICEPACKEXISTS and (!addondirSnds) and 0 or self.ADMINSCOLDVOICEPACKEXISTS and #addondirSnds)

    --print("Found ",self.PanicSoundCount," panic sound Files")
    table_Empty(dirSnds)

    if self.VoicePack != "none" then
        addon = self.VoicePack.."/"
        local exists = file.Exists( "sourceengine/sound/zetaplayer/custom_vo/"..addon.."sitrespond", "BASE_PATH" ) or file.Exists( "sound/zetaplayer/custom_vo/"..addon.."sitrespond", "GAME" )
        if !exists then
            addon = ""
        else
            self.SITRESPONDVOICEPACKEXISTS = true
        end
    end

    dirSnds = file.Find("sourceengine/sound/zetaplayer/custom_vo/"..addon.."sitrespond/*","BASE_PATH","namedesc")
    local addondirSnds = file.Find("sound/zetaplayer/custom_vo/"..addon.."sitrespond/*","GAME","namedesc")
    self.SitRespondSoundCount = (!self.SITRESPONDVOICEPACKEXISTS and (!dirSnds) and 0 or !self.SITRESPONDVOICEPACKEXISTS and #dirSnds) or (self.SITRESPONDVOICEPACKEXISTS and (!addondirSnds) and 0 or self.SITRESPONDVOICEPACKEXISTS and #addondirSnds)

    --print("Found ",self.SitRespondSoundCount," sit respond sound Files")
    table_Empty(dirSnds)

    if self.VoicePack != "none" then
        addon = self.VoicePack.."/"
        local exists = file.Exists( "sourceengine/sound/zetaplayer/custom_vo/"..addon.."fall", "BASE_PATH" ) or file.Exists( "sound/zetaplayer/custom_vo/"..addon.."fall", "GAME" )
        if !exists then
            addon = ""
        else
            self.FALLVOICEPACKEXISTS = true
        end
    end

    dirSnds = file.Find("sourceengine/sound/zetaplayer/custom_vo/"..addon.."fall/*","BASE_PATH","namedesc")
    local addondirSnds = file.Find("sound/zetaplayer/custom_vo/"..addon.."fall/*","GAME","namedesc")
    self.FallingSoundCount = (!self.FALLVOICEPACKEXISTS and (!dirSnds) and 0 or !self.FALLVOICEPACKEXISTS and #dirSnds) or (self.FALLVOICEPACKEXISTS and (!addondirSnds) and 0 or self.FALLVOICEPACKEXISTS and #addondirSnds)


    --print("Found ",self.SitRespondSoundCount," sit respond sound Files")
    table_Empty(dirSnds)

    if self.VoicePack != "none" then
        addon = self.VoicePack.."/"
        local exists = file.Exists( "sourceengine/sound/zetaplayer/custom_vo/"..addon.."conquestion", "BASE_PATH" ) or file.Exists( "sound/zetaplayer/custom_vo/"..addon.."conquestion", "GAME" )
        if !exists then
            addon = ""
        else
            self.CONQUESTIONVOICEPACKEXISTS = true
        end
    end

    dirSnds = file.Find("sourceengine/sound/zetaplayer/custom_vo/"..addon.."conquestion/*","BASE_PATH","namedesc")
    local addondirSnds = file.Find("sound/zetaplayer/custom_vo/"..addon.."conquestion/*","GAME","namedesc")
    self.QuestionSoundCount = (!self.CONQUESTIONVOICEPACKEXISTS and (!dirSnds) and 0 or !self.CONQUESTIONVOICEPACKEXISTS and #dirSnds) or (self.CONQUESTIONVOICEPACKEXISTS and (!addondirSnds) and 0 or self.CONQUESTIONVOICEPACKEXISTS and #addondirSnds)

    --print("Found ",self.QuestionSoundCount," question sound Files")
    table_Empty(dirSnds)

    if self.VoicePack != "none" then
        addon = self.VoicePack.."/"
        local exists = file.Exists( "sourceengine/sound/zetaplayer/custom_vo/"..addon.."conrespond", "BASE_PATH" ) or file.Exists( "sound/zetaplayer/custom_vo/"..addon.."conrespond", "GAME" )
        if !exists then
            addon = ""
        else
            self.CONRESPONDVOICEPACKEXISTS = true
        end
    end

    dirSnds = file.Find("sourceengine/sound/zetaplayer/custom_vo/"..addon.."conrespond/*","BASE_PATH","namedesc")
    local addondirSnds = file.Find("sound/zetaplayer/custom_vo/"..addon.."conrespond/*","GAME","namedesc")
    self.ConRespondSoundCount = (!self.CONRESPONDVOICEPACKEXISTS and (!dirSnds) and 0 or !self.CONRESPONDVOICEPACKEXISTS and #dirSnds) or (self.CONRESPONDVOICEPACKEXISTS and (!addondirSnds) and 0 or self.CONRESPONDVOICEPACKEXISTS and #addondirSnds)

    --print("Found ",self.ConRespondSoundCount," conRespond sound Files")
    table_Empty(dirSnds)

    if self.VoicePack != "none" then
        addon = self.VoicePack.."/"
        local exists = file.Exists( "sourceengine/sound/zetaplayer/custom_vo/"..addon.."mediawatch", "BASE_PATH" ) or file.Exists( "sound/zetaplayer/custom_vo/"..addon.."mediawatch", "GAME" )
        if !exists then
            addon = ""
        else
            self.MEDIAWATCHVOICEPACKEXISTS = true
        end
    end

    dirSnds = file.Find("sourceengine/sound/zetaplayer/custom_vo/"..addon.."mediawatch/*","BASE_PATH","namedesc")
    local addondirSnds = file.Find("sound/zetaplayer/custom_vo/"..addon.."mediawatch/*","GAME","namedesc")
    self.MediaWatchSoundCount = (!self.MEDIAWATCHVOICEPACKEXISTS and (!dirSnds) and 0 or !self.MEDIAWATCHVOICEPACKEXISTS and #dirSnds) or (self.MEDIAWATCHVOICEPACKEXISTS and (!addondirSnds) and 0 or self.MEDIAWATCHVOICEPACKEXISTS and #addondirSnds)

    --print("Found ",self.MediaWatchSoundCount," Media Watch sound Files")
    table_Empty(dirSnds)



    

    
    end

end -- INITIALIZE END





-----------------------------------------------
-- Functions that function
-----------------------------------------------


  // Get VJ SNPC's current relationship with players
  function ENT:GetVJSNPCRelationship(npc)
    if !IsValid(self) or !IsValid(npc) or !npc:IsNPC() or !npc.IsVJBaseSNPC then return end

    if istable(npc.VJ_AddCertainEntityAsEnemy) then
        local tbl = npc.VJ_AddCertainEntityAsEnemy
        for i=1, #tbl do
            if tbl[i] == self then return D_HT end
        end
    end
    
    // Loop through SNPC's class table
    local class = npc.VJ_NPC_Class
    for i=1, #class do
        // if 'CLASS_PLAYER_ALLY' is found, it's friendly
        if class[i] == 'CLASS_PLAYER_ALLY' then return D_LI end
    end

    // If SNPC's variable 'PlayerFriendly' is true, it's friendly
    if npc.PlayerFriendly == true then return D_LI end

    // Otherwise, SNPC is hostile to players
    return D_HT
end

function ENT:Think()
    if self.IsDead then return end



    local wepName = (CLIENT and self:GetNW2String("zeta_weaponname", "NONE") or self.Weapon)
    local wepData = _ZetaWeaponDataTable[wepName]
    if wepData and wepData.onThink and isfunction( wepData.onThink ) then
        local wepEnt = (CLIENT and self:GetNW2Entity("zeta_weaponent", NULL) or self.WeaponENT)
        wepData:onThink(self, wepEnt)
    elseif wepData and wepData.onThink and isstring( wepData.onThink ) then
        local wepEnt = (CLIENT and self:GetNW2Entity("zeta_weaponent", NULL) or self.WeaponENT)
        local func = CompileString( wepData.onThink, "[OnThink] Custom Weapon " .. self.PrettyPrintWeapon )
        func( self, wepEnt )
    end



    if SERVER then

        if !IsValid( self.WeaponENT ) then return end

        if GetConVar("zetaplayer_disabled"):GetBool() then
            self:SetEnemy(NULL)
            self:CancelMove()
        end


--[[         for _,v in pairs(self:GetFriends()) do
            debugoverlay.Line(self:GetPos()+self:OBBCenter(),v:GetPos()+v:OBBCenter(),0,self.PlayermodelColor:ToColor())
        end ]]

        
        if self:IsInNoclip() and !self.IsPhysgunCarried then
            local hover = self.CurNoclipPos or self:GetPos()
            self:SetPos(hover)
            self.loco:SetVelocity(Vector(0,0,0))
        elseif !self:IsInNoclip() then
            self.CurNoclipPos = nil
        end

--[[         if self:IsInNoclip() and self:GetState() != "idle" then
            self:ToggleNoclip(false)
        end ]]


        if self.ThinkFunctionCount > 0 then
            for k, v in pairs(self.ThinkFunctions) do
                local thinkTime = v[1]
                if thinkTime > 0 then
                    v[5] = v[5] or CurTime() + thinkTime
                    if CurTime() < v[5] then continue end
                    v[5] = CurTime() + thinkTime
                end
        
                local runCount = v[2]
                if runCount > 0 then
                    v[4] = v[4] or 0
                    if v[4] >= runCount then
                        self.ThinkFunctions[k] = nil
                        self.ThinkFunctionCount = self.ThinkFunctionCount - 1
                        continue 
                    end
                    v[4] = v[4] + 1
                end
        
                local funcResult = v[3]()                
                if (funcResult == "stop" or funcResult == "abort" or funcResult == "failed") then
                    self.ThinkFunctions[k] = nil
                    self.ThinkFunctionCount = self.ThinkFunctionCount - 1
                    continue 
                end
            end
        end

--[[         if IsValid(self.Enemy) then -- Commented out until we deal with the crashing issues
            if !self:IsChasingSomeone() then
                self:AttackEnemy(self.Enemy,true)
            elseif self.IsSwimming and !self.loco:IsOnGround() and self:CanSee(self.Enemy) then
                local swimVelocity = nil
                local swimDir = (self.Enemy:GetPos() - self:GetPos()):Angle():Forward()
                local minRange = _ZetaWeaponDataTable[self.Weapon].keepDistance or 300
                local dist = self:GetRangeSquaredTo(self.Enemy)
        
                if self.HasMelee or dist > ((minRange*minRange) + (192*192)) then
                    swimVelocity = swimDir * 320
                elseif dist < ((minRange*minRange) - (192*192)) then
                    swimVelocity = swimDir * -320
                end
        
                if swimVelocity then self.loco:SetVelocity(swimVelocity) end
            end
        end ]]


        if GetConVar('zetaplayer_paniconfire'):GetBool() then
            if IsValid(self) then
                if self:IsOnFire() then
                    timer.Simple(math.Rand(0.25, 0.75),function()
                        if !IsValid(self) then return end
                        self:Panic()
                    end)
                end
            end
        end


        local landAnim = self:GetActivityWeapon(!self.IsMoving and "idle" or "move")
        if self:WaterLevel() >= 3 then
            if !self.IsSwimming then
                self.IsSwimming = true

--[[                 self.loco:SetGravity(100)
 ]]

                self.DrowningStartTime = CurTime() + GetConVar("zetaplayer_waterairtime"):GetFloat()
                self:CreateThinkFunction("DrowningSystem", 1, 0, function()
                    if self:WaterLevel() >= 3 then
                        if self.DrowningStartTime and CurTime() >= self.DrowningStartTime and GetConVar("zetaplayer_enabledrowning"):GetBool() then
                            local waterdmg = DamageInfo()
                            waterdmg:SetDamage(10)
                            waterdmg:SetAttacker(self)
                            waterdmg:SetInflictor(self)
                            waterdmg:SetDamageType(DMG_DROWN)
                            self:TakeDamageInfo(waterdmg)
                            self:EmitSound("player/pl_drown"..zetamath.random(3)..".wav", 80)

                            self.DrowningRecoverHealth = self.DrowningRecoverHealth + 10 
                        end
                    elseif self.DrowningRecoverHealth > 0 then
                        self:SetHealth(math.min(self:Health() + math.min(self.DrowningRecoverHealth, 10), self:GetMaxHealth()))
                        self.DrowningRecoverHealth = math.max(0, self.DrowningRecoverHealth - 10)
                    else
                        return "abort"
                    end
                end)
            end

           --[[  if self:IsChasingSomeone() and IsValid(self.Enemy) and (self.Enemy:GetPos().z - self:GetPos().z) > self.loco:GetStepHeight() and self.loco:IsOnGround() then
                self.IsJumping = true 
                self:SetLastActivity(self:GetActivity())
                self.loco:Jump()
            end ]]

--[[             local swimAnim = self:GetSwimAnimation()
            if !self.loco:IsOnGround() then 
                if self:GetActivity() != swimAnim then
                    self:StartActivity(swimAnim)
                    self:SetLastActivity(swimAnim)
                end
            elseif self:GetActivity() == swimAnim  then
                self:StartActivity(landAnim)
                self:SetLastActivity(landAnim)
            end ]]
        elseif self.IsSwimming == true then
            self.IsSwimming = false
            self.DrowningStartTime = nil

--[[             self.loco:SetGravity(GetConVar("sv_gravity"):GetFloat())
            self:StartActivity(landAnim)
            self:SetLastActivity(landAnim) ]]

        end


             
        if CurTime() > self.CheckforNextBots then

            local fleeFromSanicCvar = GetConVar("zetaplayer_fleefromsanics"):GetBool()
            local fleeFromDrGBaseCvar = GetConVar("zetaplayer_fleefromdrgbasenextbots"):GetBool()
            if fleeFromSanicCvar or fleeFromDrGBaseCvar then
                self.CheckforNextBots = CurTime() + 1.0

                local closeNextbot = NULL
                local lastDist = math.huge

                surrounding = self:FindInSight(self.SightDistance*2, function(ent)
                    return (IsValid(ent) and !ent.IsZetaPlayer and ent:IsNextBot() and (fleeFromSanicCvar and isfunction(ent.AttackNearbyTargets) or fleeFromDrGBaseCvar and ent.IsDrGNextbot))
                end)
                for i=1, #surrounding do
                    local dist = self:GetRangeSquaredTo(surrounding[i])
                    if dist < lastDist then
                        closeNextbot = surrounding[i]
                        lastDist = dist
                    end
                end
                
                

                if IsValid(closeNextbot) then 
                    if self:GetState() != 'panic' then
                        self:Panic(closeNextbot, zetamath.random(45, 75),true)
                    elseif IsValid(self.FleeFromTarget) and self.FleeFromTarget != closeNextbot and lastDist < self:GetRangeSquaredTo(self.FleeFromTarget) then
                        self.FleeFromTarget = closeNextbot
                    end
                end
            end
        end
        if CurTime() > self.CheckforNPCS and self:GetState() != 'panic' and !self:IsChasingSomeone() and GetConVar('zetaplayer_alwaystargetnpcs'):GetBool() then
            self.CheckforNPCS = CurTime() + 3

            local closeNPC = NULL
            local lastDist = math.huge

            surrounding = self:FindInSight(self.SightDistance, function(ent)
                return (IsValid(ent) and !ent.IsZetaPlayer and (ent:IsNPC() and (self:GetPlayerRelation(ent) == D_HT or self:GetVJSNPCRelationship(ent)) or ent:IsNextBot() and !ent._ZetaVehicleLeader and !ent._nozetatarget))
            end)
            for i=1, #surrounding do
                local dist = self:GetRangeSquaredTo(surrounding[i])
                if dist < lastDist then
                    closeNPC = surrounding[i]
                    lastDist = dist
                end
            end

            if IsValid(closeNPC) then
                self:AttackEnemy(closeNPC, true)
            end
        end

        if !self.TeamAttackCur then
            self.TeamAttackCur = CurTime() + 0.1
        elseif CurTime() > self.TeamAttackCur and self.zetaTeam and self:GetState() != "panic" and !self:IsChasingSomeone() and (_ZetaIsMinigameActive() or GetConVar("zetaplayer_teamsalwaysattack"):GetBool()) then
            self.TeamAttackCur = CurTime() + 1.5
            local sight = self:FindInSight(self.SightDistance, function(ent) return (self:CanTarget(ent)) end)
            if #sight > 0 then self:AttackEnemy(sight[zetamath.random(#sight)], true) end
        end

        if self.TypingInChat and (self:GetState() == 'panic' or self:IsChasingSomeone()) then
            self.TypingInChat = false
            self:RemoveGesture(ACT_GMOD_IN_CHAT)
        end

        if !self:IsInWorld() and !timer.Exists("zetareturntoworld"..self:EntIndex()) then
            timer.Create("zetareturntoworld"..self:EntIndex(),10,1,function()
                if !IsValid(self) then return end
                self:SetPos(self.SpawnPos)
            end)
        elseif self:IsInWorld() and timer.Exists("zetareturntoworld"..self:EntIndex()) then
            timer.Remove("zetareturntoworld"..self:EntIndex())
        end


        if IsValid(self.PhysgunBeamEnt) then
            physguntracedata.start = self.WeaponENT:GetPos()
            physguntracedata.endpos = self.PhysgunBeamEnt:GetPos()+self.PhysgunBeamEnt:OBBCenter()
            physguntracedata.collisiongroup = COLLISION_GROUP_WORLD
            physguntracedata.filter = function(ent) if ent == self.PhysgunBeamEnt then return true end end
            local line = trace.TraceLine(physguntracedata)

            self:SetNW2Vector("zeta_physgunendbeam",line.HitPos)
        end

        if self.UnstuckSelf then -- Unstuck behavior is now done here since creating a timer to run on tick is not a smart idea when you can use Think 
            local testingpoint = self:GetPos()+VectorRand(self.unstuckmin,self.unstuckmax) -- Test a random point
            --print("min",unstuckmin,"max",unstuckmax)


                local area = navmesh.GetNearestNavArea(testingpoint) -- Get the nav area

            if IsValid(area) then
                local point = area:GetClosestPointOnArea(testingpoint)
                local min,max = self:GetCollisionBounds()
                unstuckdata.start = point+Vector(0,0,5)
                unstuckdata.endpos = point+Vector(0,0,5)
                unstuckdata.mins = min
                unstuckdata.maxs = max
                local hullcheck = trace.TraceHull(unstuckdata) -- Test if it is even safe to set our position here
                debugoverlay.Sphere(point, 30, 1, color_white,true)
                if !hullcheck.Hit then 
                    --print("SetPos")
                    self:SetPos(point)
                    self.UnstuckSelf = false
                    self.loco:ClearStuck()
                    self.unstuckmin = -50
                    self.unstuckmax = 50
                else -- If either fails, just increment the unstuck mins and maxs until we get out
                    --print("Failed Hull check!")
                    self.unstuckmin = self.unstuckmin - 10 
                    self.unstuckmax = self.unstuckmax + 10
                end
            else
                self.unstuckmin = self.unstuckmin - 10 
                self.unstuckmax = self.unstuckmax + 10
            end
        end


        local speed = self.loco:GetVelocity():Length()
        if CurTime() > self.NextFootstepSnd and self.IsMoving and self.CanPlayFootstep and speed > 0 then
            self:EmitStepSound(70, 1)

            local nextSnd = math.Clamp(0.25 * (400 / speed), 0.25, 0.35)
            self.NextFootstepSnd = CurTime() + nextSnd
        end

        if !self.HasProperAttachment then
            local attachment = self:GetAttachmentPoint("hand")
            self.WeaponENT:SetPos(attachment.Pos)
            self.WeaponENT:SetAngles(attachment.Ang+Angle(0,0,180))
        end

        if GetConVar("developer"):GetBool() then
            local debugattach = self:GetAttachmentPoint("eyes")
            debugoverlay.Text(debugattach.Pos, "Eye Attachment",0)
            local debugattach = self:GetAttachmentPoint("hand")
            debugoverlay.Text(debugattach.Pos, "Hand Attachment",0)
        end

        
        if self:Health() <= 0 then
            if !timer.Exists("zetaremovecheck"..self:EntIndex()) then
                timer.Create("zetaremovecheck"..self:EntIndex(), 2, 1, function()
                if !IsValid(self) then return end
                    if self:Health() <= 0 then

                        if !IsValid(self) then return end

                        local dmginfo = DamageInfo()
                        dmginfo:SetAttacker(self)
                        dmginfo:SetInflictor(self)
                        dmginfo:SetDamage(10)
                        self.KillReason = self.zetaname..' Tried to Divide by Zero... '
                        self:OnKilled(dmginfo)
                        
                        timer.Simple(1,function()
                            if IsValid(self) then
                                self:Remove()
                            end
                        end)

                    end
                end)
            end 
        end

--[[         if self:WaterLevel() == 3 and !timer.Exists("zetadrowningtimer"..self:EntIndex()) and GetConVar("zetaplayer_enabledrowning"):GetInt() == 1 then
            timer.Create("zetadrowningtimer"..self:EntIndex(),1,1,function()
                if !self:IsValid() then return end
                if self:WaterLevel() == 3 then
                    local waterdmg = DamageInfo()
                    waterdmg:SetDamage(10)
                    waterdmg:SetAttacker(self)
                    waterdmg:SetInflictor(self)
                    waterdmg:SetDamageType(DMG_DROWN)
                    self:TakeDamageInfo(waterdmg)
                    self:EmitSound("player/pl_drown"..zetamath.random(1,3)..".wav",80)
                end
            end)
        end ]]

        if CurTime() > self.checkfloor and GetConVar("zetaplayer_killontouchnodraworsky"):GetBool() then
            local downtrace = trace.TraceLine({start = self:GetPos()+self:OBBCenter(),endpos = self:GetPos()+Vector(0,0,-1000),filter = self,collisiongroup = COLLISION_GROUP_DEBRIS})
            if downtrace.HitSky or downtrace.HitNoDraw then
                local dmginfo = DamageInfo()
                dmginfo:SetAttacker(self)
                dmginfo:SetInflictor(self)
                dmginfo:SetDamage(1000000)
                self.KillReason = self.zetaname..' touched a no draw or skybox surface and had a heart attack '
                self:TakeDamageInfo(dmginfo)

            end

            self.checkfloor = CurTime()+2
        end


        if self.IsPhysgunCarried then
            self.CurNoclipPos = self:GetPos()
            self.loco:SetVelocity(Vector(0,0,0))
        end

        if self.InAir then -- Outside 'if CurTime() > self.UpdatePhys then' statement
            self.FallVelocity = -self:GetVelocity().z
        end

        
        if CurTime() > self.UpdatePhys then



            self:UpdateFriendlist()

            if !self.IsJumping and !self.InAir and !self.PreventFalldamage and self:GetActivity() == self:GetActivityWeapon('jump') then
                local resetAct = self:GetActivityWeapon((self.IsMoving and 'move' or 'idle'))
                if self:GetState() == 'panic' then activity = (self.IsMoving and ACT_HL2MP_RUN_PANICKED or ACT_HL2MP_IDLE_SCARED) end
                self:StartActivity(resetAct)
            end

            if IsValid(self:GetGroundEntity()) and self:GetGroundEntity():GetClass() == "func_movelinear" then
                local ismoving = self:GetGroundEntity():GetInternalVariable("m_movementType")

                if ismoving == 1 then
                    self:CancelMove()
                end
            end

            if self.JumpDirection and self.IsJumping and self.loco:GetVelocity().z > 0 then
                self.loco:SetVelocity(self.loco:GetVelocity() + self.JumpDirection*32)
            end

            self:SetNW2Float('zeta_health',self:Health())
            self:SetNW2Int("zeta_armor",self.CurrentArmor)
            self.UpdatePhys = CurTime()+0.1

            if self.InAir and !self.PreventFalldamage and !self:IsInNoclip() then
                local calcFallDmg = ((self.FallVelocity - 526.5) * (100.0 / (922.5 - 526.5)))
                if self.FallVelocity >= 2000 or calcFallDmg >= (self:Health() * 0.5) then self:PlayFallingSound() end
            end

            if self.Weapon == "CAMERA" and 100*zetamath.random() < 1 then
                self:UseCamera()
            end



        if !self.IsDriving then
            local ang = self:GetAngles()
            ang[1] = 0
            ang[3] = 0
            self:SetAngles(ang)
        end
        
            
            local phys = self:GetPhysicsObject()
            
            if IsValid(phys) then
                if self:WaterLevel() == 0 then
                  phys:SetPos(self:GetPos())
                  phys:SetAngles(self:GetAngles())
                else
                  phys:UpdateShadow(self:GetPos(), self:GetAngles(), 0)
                end
              end
        end




        if !self.CheckForCovers or CurTime() > self.CheckForCovers then
            self.PossibleCovers = {}
            self.CheckForCovers = CurTime() + math.Rand(1.0, 2.0)
        
            local navAreas = navmesh.Find(self:GetPos(), 2048, 256, 256)
            local ene, eneValid = self:GetEnemy(), IsValid(self:GetEnemy())
            for i = 1, #navAreas do
                local area = navAreas[i]
                if !IsValid(area) or !self.loco:IsAreaTraversable(area) then continue end
                    
                for i = 1, 10 do
                    local navPos = area:GetRandomPoint() + Vector(0, 0, 36)                    
                    if eneValid then
                        if (ene:GetCenteroid() - self:GetCenteroid()):Angle():Forward():Dot((navPos - self:GetCenteroid()):GetNormalized()) < 0.125 and !self:CanSeePosition(navPos, ene:GetCenteroid(), ene) then
                            self.PossibleCovers[#self.PossibleCovers+1] = navPos
                            break
                        end
                        continue
                    end
        
                    if !self:CanSeePosition(navPos) then
                        self.PossibleCovers[#self.PossibleCovers+1] = navPos
                        break
                    end
                end
            end
        end




else -- CLIENT CODE
    
    self.zetaTeam = self:GetNW2String('zeta_team','')
    if GetConVar('zetaplayer_drawflashlight'):GetInt() == 0 then
         if IsValid(self.proj) then
             self.proj:Remove()
             end
              return
             end
    local arealighting = render.GetLightColor(self:GetPos()+self:OBBCenter()):ToColor()

    if arealighting.r < 6 and arealighting.g < 6 and arealighting.b < 6 and (!self.FlashlightCooldown or CurTime() > self.FlashlightCooldown)  then
        
        if !self.FlashlightEnabled then
            self:EmitSound('items/flashlight1.wav',70)
            self.FlashlightEnabled = true
        end
        if !IsValid(self.proj) then
            local attachment = self:GetAttachmentPoint("hand")
            self.proj = ProjectedTexture()
            self.proj:SetTexture( "effects/flashlight001" )
            self.proj:SetFarZ( 500 ) -- How far the light should shine
            self.proj:SetPos(attachment.Pos)
            self.proj:SetAngles(attachment.Ang)
            self.proj:SetColor(Color(0,0,0))
            self.proj:SetEnableShadows( false )
            self.proj:Update()
        end
        self:DrawFlashlight()
    else
        if !self.FlashlightCooldown or CurTime() > self.FlashlightCooldown then
            self.FlashlightCooldown = CurTime()+0.6
        end
        if IsValid(self.proj) then
            self.proj:Remove()
        end
        if self.FlashlightEnabled then
            self:EmitSound('items/flashlight1.wav',70)
            self.FlashlightEnabled = false
        end
    end

end
end

function ENT:DrawFlashlight()
    if SERVER then return end

    if IsValid(self.proj) then
        self.FlashlightEnabled = true
        local attachment = self:GetAttachmentPoint("hand")

            self.proj:SetTexture( "effects/flashlight001" )
            self.proj:SetPos(attachment.Pos)
            self.proj:SetAngles(attachment.Ang)
            self.proj:SetColor(Color(255,255,255))
            self.proj:Update()

    end


    
end

function ENT:HandleCollision(data)
    local collider = data.HitEntity
    if !IsValid(collider) then return end
    local class = collider:GetClass()

    if class == 'prop_combine_ball' then
        if self:IsFlagSet(FL_DISSOLVING) then return end

        local dmg = DamageInfo()
        local owner = collider:GetPhysicsAttacker( 1 ) 
        dmg:SetAttacker(IsValid(owner) and owner or collider)
        dmg:SetInflictor(collider)
        dmg:SetDamage(1000)
        dmg:SetDamageType(DMG_DISSOLVE)
        dmg:SetDamageForce(collider:GetVelocity())
        self:TakeDamageInfo(dmg)  
        collider:EmitSound("NPC_CombineBall.KillImpact")


    elseif isfunction(collider.CustomOnDoDamage_Direct) then
        local owner = collider:GetOwner()
        local dmgPos = (data != nil and data.HitPos) or collider:GetPos()
    
        collider:CustomOnDoDamage_Direct(data, phys, self)
        local damagecode = DamageInfo()
        damagecode:SetDamage(collider.DirectDamage)
        damagecode:SetDamageType(collider.DirectDamageType)
        damagecode:SetDamagePosition(dmgPos)
        damagecode:SetAttacker((IsValid(owner) and owner or collider))
        damagecode:SetInflictor((IsValid(owner) and owner or collider))
        self:TakeDamageInfo(damagecode, collider)

    elseif !collider:IsPlayerHolding() and collider != self.PhysgunnedENT then
        local mass = data.HitObject:GetMass() or 500
        local impactdmg = (data.TheirOldVelocity:Length()*mass)/1000

        if impactdmg > 10 then
            local info = DamageInfo()
            info:SetAttacker(collider)
            if IsValid(collider:GetPhysicsAttacker()) then
                info:SetAttacker(collider:GetPhysicsAttacker())
            elseif collider:IsVehicle() and IsValid(collider:GetDriver()) then
                info:SetAttacker(collider:GetDriver())
                info:SetDamageType(DMG_VEHICLE)     
            end
            info:SetInflictor(collider)
            info:SetDamage(impactdmg)
            info:SetDamageType(DMG_CRUSH)
            info:SetDamageForce(data.TheirOldVelocity)
            self.loco:SetVelocity(self.loco:GetVelocity()+data.TheirOldVelocity)
            self:TakeDamageInfo(info)


        end


    end

end


function ENT:LaughAt(victim) -- Laugh at that thing that was dumb enough to die
    if self.IsSpeaking == true then return end
    if self:GetState() == 'driving' then return end
    if GetConVar('zetaplayer_allowlaughing'):GetInt() == 0 then return end
    local pos = victim:GetPos()
        DebugText('Laughing at '..tostring(victim))
    if self.IsMoving == true then
        self:CancelMove()
    end

    self:Face(pos)

    self:SetState('laughing')
end


function ENT:Disrespect(pos) -- Welcome to MW2/Halo

    self:CancelMove()
    self.DisEntPos = pos
    self.DisAmount = zetamath.random(3,10)
    self.DisCount = 0
    self:SetState('disrespect')

end




function ENT:Panic(fleeTarget, timeoutTime, forcePanic, playSnd)
    if self:GetState() == 'driving' or !forcePanic and (!self.AllowPanic or GetConVar('zetaplayer_panicthreshold'):GetFloat() <= 0) or self.PlayingPoker then return end
    self:ToggleNoclip(false)
    self:CancelMove()
    self:StopFacing()
    self:SetEnemy(NULL)
    self.FleeFromTarget = fleeTarget
    self:SetState('panic')
    
    DebugText('Panic: Panicked!')

    if playSnd == nil or playSnd then
        timer.Simple(math.Rand(0.1, 0.5),function()
            if !IsValid(self) then return end
            self:PlayPanicSound()
        end)
    end

    self.AllowPanic = false
    timer.Remove("ZetaPanicTimeout"..self:EntIndex())
    timer.Create("ZetaPanicTimeout"..self:EntIndex(), (timeoutTime or zetamath.random(5, 15)), 1, function()
        if !IsValid(self) then return end
        if self:GetState() != "panic" then return end
        self:CancelMove()
        self:SetState('idle')
        self.FleeFromTarget = NULL
        DebugText('Panic: No longer panicking')

        timer.Simple(30, function()
            if !IsValid(self) then return end
            self.AllowPanic = true
            DebugText('Panic: Can panic again')
        end)
    end)
end






-----------------------------------------------








-----------------------------------------------
-- The AI of the Zeta Player aka the fun part
-----------------------------------------------

function ENT:RunBehaviour()

    if SERVER and GetConVar("zetaplayer_debug_displayspawntime"):GetBool() then
        self:SendConsoleLog(self.zetaname.." Initialize time is, "..tostring(self.spawntime - SysTime()))
    end

    -- Make a custom undo entry
    undo.Create( 'Zeta Player' )
        undo.AddEntity(self)
        undo.SetPlayer(self:GetCreator())
        undo.SetCustomUndoText( 'Undone Zeta Player ('..self:GetNW2String('zeta_name','Zeta Player')..')' )
    undo.Finish('Zeta Player ('..self:GetNW2String('zeta_name','Zeta Player')..')')

    if self.ProfilePicture == "none" or self.ProfilePicture == nil then
        self.ProfilePicture = self:GetModel()
    end


    timer.Create('rndspeak'..self:EntIndex(),5,0,function() 
        if !IsValid(self) then timer.Remove('rndspeak'..self:EntIndex()) return end
        if !GetConVar('zetaplayer_allowidlevoice'):GetBool() then return end
        if self.IsTyping then return end
        if self.IsSpeaking then return end
        if self:GetState() == "jailed/held" or self:GetState() == "adminsit" or self:GetState() == "conversation" or self:GetState() == "watching" then return end
        local voic = zetamath.random(1,100)
        if zetamath.random(1,100) < self.TextChance and GetConVar("zetaplayer_allowtextchat"):GetBool() then
            self:TypeMessage("idle")
        elseif voic < self.VoiceChance then
            self:PlayIdleLine()
        end

    end)

    if !self.ZetaSpawnerID and !self.nodisconnect then
        timer.Create("zeta_disconnecttimer"..self:EntIndex(),zetamath.random(1,GetConVar("zetaplayer_maxdisconnecttime"):GetInt()),0,function()
            if !IsValid(self) then timer.Remove("zeta_disconnecttimer"..self:EntIndex()) return end
            if GetConVar("zetaplayer_allowdisconnecting"):GetBool() and !self.PlayingPoker and self:GetState() != "buildingdupe" then
                self:DisconnectfromGame()
                timer.Remove("zeta_disconnecttimer"..self:EntIndex())
            end
        end)
    end

    self:StartUniversalTimer(1.0,15.0) -- This is used to call Universal actions 


    local wpnStr = GetConVar('zetaplayer_spawnweapon'):GetString()
    if self.CustomSpawnWeapon then
        wpnStr = self.CustomSpawnWeapon
    elseif self.NaturalWeapon then
        wpnStr = GetConVar('zetaplayer_naturalspawnweapon'):GetString()
    end
    local wpnChoices = {
        ["RND"] = function() self:ChooseDifferentWeapon() end,
        ["RNDLETHAL"] = function() self:ChooseLethalWeapon() end,
        ["OTHER"] = function() self:ChangeWeapon(wpnStr) end,
        ["NONE"] = function() return end
    }
    local wpnChoice = wpnChoices[wpnStr]
    if !wpnChoice then wpnChoice = wpnChoices["OTHER"] end
    wpnChoice()



    self:StartActivity(self:GetActivityWeapon("idle"))
    self.LastActivity = self:GetActivityWeapon("idle")


    if !self.ZetaSpawnerID and GetConVar("zetaplayer_allowtextchat"):GetBool() and GetConVar("zetaplayer_connectlines"):GetBool() and zetamath.random(1,3) == 1 then
        self:TypeMessage("connect")
    end


    if GetConVar("zetaplayer_findpokertableonspawn"):GetBool() then
        self:FindGPokerTable()
    end



    
    local StateTBL = {
        ['idle'] = function() self:ChooseNextIdleAction() end,
        ['panic'] = function() self:Flee() end,
        ['laughing'] = function() self:BeginLaugh() end,
        ['chasemelee'] = function() self:ChaseMeleeState() end,
        ['disrespect'] = function() self:DisrespectState() end,
        ['dancing'] = function() self:DancingState() end,
        ['chaseranged'] = function() self:RangedAttack() end,
        ['watching'] = function() self:WatchMediaPlayer() end,
        ['driving'] = function() self:ChooseVehicle() end,

        ['actcommands'] = function() self:ActCommandsState() end,
        ['huntingtargets'] = function() self:Huntfortargets() end,
        ['toolgunbuilding'] = function() self:ToolgunBurstState() end,
        ['building'] = function() self:BuildingState() end,

        ['adminsit'] = function() self:ConductAdminSit() end,
        ['jailed/held'] = function() self:WaitinSit() end,
        ['usingcommand'] = function() self:TypingCommand() end,
        ['lookingbutton'] = function() self:LookforButton() end,
        ['findingconverse'] = function() self:FindConversPartner() end,
        ['conversation'] = function() self:Converse() end,
        ['sitting'] = function() self:SittingState() end,
        ["buildingdupe"] = function() self:BuildDupe() end,
        ["buildingonent"] = function() self:PropAddingState() end,
        [ "gotomentioner" ] = function() self:GotoMentioner() end,
        [ "followmentioner" ] = function() self:FollowMentioner() end
        
    }

    --self:PlaceDupe()
    --self:SetState("findingconverse")

    --self:MovetoPosition( Vector( -1253.782227, -231.790970, 319.196838 ) )

    while ( true ) do -- This is where the State system gets used Truuuuuuuust me.. It did not look this organized during earlier stages
        if !self.IsDead then 

            if GetConVar('zetaplayer_disabled'):GetBool() then
                self:CancelMove()
                self:SetState('idle')
                coroutine.wait(2)
            else


                if isfunction(StateTBL[self:GetState()]) then
                    StateTBL[self:GetState()]()
                end


                local time = self.CorStateTimes[self:GetState()]
                if !time then
                    time = 1
                end
                coroutine.wait(time)

            end

        end
    end


end

-----------------------------------------------





-- And we are just adding this to the spawnmenu simple stuff
list.Set( "NPC", "npc_zetaplayer", {
	Name = "Zeta Player",
	Class = "npc_zetaplayer",
	Category = "Zeta Bots"
})