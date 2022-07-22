

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

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true
ENT.IsZetaPlayer = true
ENT.IsNatural = false
ENT.Permafriend = false
ENT.NaturalWeapon = nil 
ENT.IsDead = false
ENT.IsMingebag = false

ENT.PrintName         = "Zeta Player"
if CLIENT then
    language.Add('npc_zetaplayer', ENT.PrintName)
end


local IsValid = IsValid

local trace = {}
trace.TraceLine = util.TraceLine
trace.TraceHull = util.TraceHull
trace.QuickTrace = util.QuickTrace
trace.TraceEntity = util.TraceEntity

local zetamath = {}

zetamath.random = math.random



function ENT:Initialize()
    local spawnmdl = "models/player/kleiner.mdl"
    if ( SERVER ) then 

        local UseSERVERCACHE = GetConVar("zetaplayer_useservercacheddata"):GetBool()
        
        self.IsAdmin = GetConVar("zetaplayer_forcespawnadmins"):GetBool()

        if self.ShouldSpawnAdmin != nil then 
            self.IsAdmin = self.ShouldSpawnAdmin
        else
            local count = GetConVar("zetaplayer_admincount"):GetInt()
            if game.SinglePlayer() and count > 0 and GetConVar("zetaplayer_spawnasadmin"):GetBool() then
                local admins = #self:GetAdmins()
                for _, v in ipairs(ents.FindByClass('zeta_zetaplayerspawner')) do
                    if v.IsAdmin and !IsValid(v.SpawnedZeta) then admins = admins + 1 end
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

        local overrideMdl = GetConVar('zetaplayer_'..(self.IsAdmin and 'admin' or '')..'overridemodel'):GetString()
        if overrideMdl != '' then
            local cvarMdls = string.Explode(',', overrideMdl)
            for k, v in ipairs(cvarMdls) do
                if util.IsValidModel(v) then continue end
                table.remove(cvarMdls, k)
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

                        local copyvalidplayermodels = table.Copy(validplayermodels)
                        copyvalidplayermodels = table.ClearKeys( copyvalidplayermodels )
                        if #blockedmdls > 0 then
                            for k,v in ipairs(blockedmdls) do
                                if !util.IsValidModel(v) then continue end

                                local key = table.KeyFromValue( copyvalidplayermodels, v )
                                
                                table.remove(copyvalidplayermodels,key)
                            end
                        end


                        spawnmdl = table.Random(copyvalidplayermodels)
                    else
                        spawnmdl = table.Random(player_manager.AllValidModels())
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
                            for k,v in ipairs(blockedmdls) do
                                if !util.IsValidModel(v) then continue end

                                local key = table.KeyFromValue( mdls, v )
                                
                                table.remove(mdls,key)
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

    self.SightDistance = 1500
    self.State = 'idle' -- The State System
    self.LastState = 'idle'
    self.Weapon = 'NONE' -- The active Weapon the Zeta Uses
    self:SetNW2String("zeta_weaponname", self.Weapon)
    self.ThinkFunctions = {}
    self.ThinkFunctionCount = 0
    self.PrettyPrintWeapon = "Holster"
    self.PhysgunColor = Vector(zetamath.random(255)/255, zetamath.random(255)/255, zetamath.random(255)/255)
    self.PlayermodelColor = Vector(zetamath.random(255)/255, zetamath.random(255)/255, zetamath.random(255)/255)
    self.PhysgunGlowMat = Material('sprites/physg_glow1')
    self.PhysgunGlowMat2 = Material('sprites/physg_glow2')
    self.PhysgunBeam = Material("sprites/physbeama")
    self.FlashlightSprite = Material( "sprites/light_glow02_add")
    self.PhysgunnedENT = nil
    self.PhysgunBeamEnt = NULL
    self.PhysgunBeamDistance = 100
    self.VoicePitch = (GetConVar('zetaplayer_differentvoicepitch'):GetBool() and zetamath.random(GetConVar("zetaplayer_voicepitchmin"):GetInt(), GetConVar("zetaplayer_voicepitchmax"):GetInt()) or 100)
    self.Friends = {}
    self.Vehicle = NULL 
    self.Enemy = NULL
    self.SpawnPos = self:GetPos()
    self.zetaTeam = nil
    self.VoicePack = "none"
    self.zetaname = "Zeta Player"
    self.JumpDirection = nil
    self.FallVelocity = 0
    self.BurstCount = 0
    self.Kills = 0
    self.NextRepathCheckT = CurTime() + 1
    self.MaxBurst = 0
    local selfpos = self:GetPos()
    selfpos.x = 0
    selfpos.y = 0
    self.FallHeight = selfpos

    self.VoiceDSP = 0
    if self:CanUseDSPEffect() then
        local dsps = {
            ['normal'] = 0,
            ['smallmic'] = 58,
            ['vsmallmic'] = 56,
            ['tinymic'] = 59,
            ['echoroom'] = zetamath.random(8,10),
            ['echoroom2'] = zetamath.random(23,25),
            ['concroom'] = zetamath.random(17,19),
            ['bright'] = zetamath.random(11,13),
            ['tunnel'] = zetamath.random(4,6),
            ['big'] = zetamath.random(20,22)
        }
        local dspCvar = GetConVar("zetaplayer_voicedsp"):GetString()
        self.VoiceDSP = (dspCvar == 'random' and table.Random(dsps) or dsps[dspCvar])
    end

    self.Abortmove = false -- Used in the ENT:CancelMove() function

    ---- These fixed some weird state issues and is generally is easier to work with
    self.CheckforNPCS = CurTime()+math.Rand(0, 3)
    self.CheckforNextBots = CurTime()+math.Rand(0, 1)
    self.IsSpeaking = false 
    self.IsJumping = false
    self.InAir = false
    self.IsMoving = false
    self.IsCrouching = false
    self.IsBuilding = false
    self.IsResettingPose = false
    
    self.InNoclip = false
    self.CurNoclipPos = self:GetPos()
    self.Grabbing = false
    self.InVehicle = false
    self.ThrottleOn = false
    self.GoingtoVehicle = false
    self.IsAttacking = false
    self.IsCharging = false
    self.FlashlightEnabled = false
    self.IsDrowning = false
    self.Delayattack = false
    self.CanStrafe = false
    self.FirstSpawned = true
    self.PreventFalldamage = false
    self.CanJump = true
    self.HasProperAttachment = false
    self.CanPlayFootstep = true
    self.StartedConverse = false
    self.UpdatePhys = CurTime()+0.1
    self.NextFallingSoundT = CurTime()
    self.checkfloor = CurTime()+2
    self.NextFootstepSnd = CurTime()
    self.HealThanksCooldown = CurTime()
    self.FleeFromTarget = NULL

    self.IsSwimming = false
    self.DrowningStartTime = nil
    self.DrowningRecoverHealth = 0

    ---- 
    self.AllowVoice = true -- Used to prevent the bot from speaking
    self.AllowPanic = true -- Used to allow a cooldown on panic
    self.CanDance = true -- Used to cooldown dancing

    self.MusicEnt = nil



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

        
        decoded = UseSERVERCACHE and _SERVERNAMES or util.JSONToTable(file.Read('zetaplayerdata/names.json','DATA'))

        local nameList = {}
        for _, v in ipairs(decoded) do
            nameList[v] = true
        end
        
        local names = nameList
        for _, v in pairs(_bannedzetas) do
            if names[v] then names[v] = nil end
        end
        for _, v in ipairs(ents.FindByClass('npc_zetaplayer')) do
            if v != self and names[v.zetaname] then names[v.zetaname] = nil end
        end
        for _, v in ipairs(ents.FindByClass('zeta_zetaplayerspawner')) do
            if names[v.zetaname] then names[v.zetaname] = nil end
        end
        if table.Count(names) <= 0 then -- If that ever happens
            names = {}
            for _, v in ipairs(decoded) do
                names[v] = true
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
    
            table.Merge(folders,addonfolders)
            
            for _,v in RandomPairs(folders) do
                local IsVP = string.find(v,"vp_")
                if isnumber(IsVP) then
                    self.VoicePack = v
                    break
                end
            end

        end


        if GetConVar('zetaplayer_enablefriend'):GetBool() then
            local permaFriendName = GetConVar("zetaplayer_permamentfriend"):GetString()
            if game.SinglePlayer() and IsValid(Entity(1)) and !IsValid(Entity(1):GetNW2Entity('zeta_friend',NULL)) and GetConVar("zetaplayer_permamentfriendalwaysspawn"):GetBool() and permaFriendName != "" then
                local exists = false
                for _, v in ipairs(ents.FindByClass("npc_zetaplayer")) do
                    if v.zetaname != permaFriendName then continue end
                    exists = true
                    break
                end
                if !exists then
                    for _, v in ipairs(ents.FindByClass("zeta_zetaplayerspawner")) do
                        if !v.permfriend or self.ZetaSpawnerID == v:GetCreationID() then continue end
                        exists = true
                        break
                    end
                end
                if !exists then
                    self.zetaname = permaFriendName
                    self:SetNW2String('zeta_name', permaFriendName)
                    
                    self.Permafriend = true
                    self:AddFriend(Entity(1))
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

    
            if self.zetaname == permaFriendName and !self.Permafriend then
                for k, v in RandomPairs(player.GetAll()) do
                    self.Permafriend = true
                    self:AddFriend(v,true)
                    break
                 end
            end
        end

        if GetConVar("zetaplayer_usecustomavatars"):GetBool() then
            local avatars = self:FindVoiceChatAvatar()
            if avatars and #avatars > 0 then
                self.ProfilePicture = avatars[zetamath.random(#avatars)]
            end
            if !self.UsingSERVERCACHE then
                table.Empty(avatars)
            end
        end
        if self.ProfilePicture == nil then
            self.ProfilePicture = "none"
        end
        self:SetNW2String('zeta_profilepicture', self.ProfilePicture)

        if GetConVar('zetaplayer_useteamsystem'):GetBool() then
            local teams = file.Read('zetaplayerdata/teams.json','DATA')
            decoded = util.JSONToTable(teams)
            
            local ZetaTeam
            local teamdata
            for _, v in RandomPairs(decoded) do
                local members = self:GetTeamMembers(v[1])
                if #members < GetConVar('zetaplayer_eachteammemberlimit'):GetInt() then
                    ZetaTeam = v[1]
                    teamdata = v
                    break
                else
                    DebugText(v[1]..' team is full! Moving on')
                end
            end

            local overrideTeam = GetConVar('zetaplayer_overrideteam'):GetString()
            if overrideTeam != '' then
                ZetaTeam = overrideTeam
            end

            if teamdata and teamdata.teammodel then
                spawnmdl = teamdata.teammodel
            end

            if teamdata and teamdata[2] then
                self.PlayermodelColor = teamdata[2]
                self.TeamColor = teamdata[2]:ToColor()
                self:SetNW2Vector('zeta_modelcolor', teamdata[2])   
                self:SetNW2Vector('zeta_teamcolor', teamdata[2])   
            end
            
            self.zetaTeam = ZetaTeam
            self:SetNW2String('zeta_team',self.zetaTeam or "")

            local spawns = self:GetTeamSpawns()
            if #spawns > 0 then
                local spawn = spawns[math.random(#spawns)]
                if IsValid(spawn) then
                    self:SetPos(spawn:GetPos())
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
            
            self.PhysgunColor = self:GetNW2Vector('zeta_coloroverride', Vector(zetamath.random(255)/255, zetamath.random(255)/255, zetamath.random(255)/255))
            self.PlayermodelColor = self:GetNW2Vector('zeta_playercoloroverride', Vector(zetamath.random(255)/255, zetamath.random(255)/255, zetamath.random(255)/255))

            self.zetaname = self.SpawnOVERRIDE.name or self.zetaname
            self:SetNW2String('zeta_name', self.zetaname)
            
            self.zetaTeam = self.SpawnOVERRIDE.zetateam or self.zetaTeam
            self.TeamColor = self.overrideTeamColor or self.TeamColor

            if self.TeamColor then
                self:SetNW2Vector('zeta_teamcolor', self.TeamColor:ToVector())
            end
            self:SetNW2String('zeta_team', self.zetaTeam or "")

            self.ProfilePicture = self.SpawnOVERRIDE.pfp or self.ProfilePicture
            self.VoicePack = self.SpawnOVERRIDE.vp or self.VoicePack 
            self:SetNW2Vector('zeta_physcolor', self.PhysgunColor)
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

        if GetConVar('zetaplayer_useprofilesystem'):GetBool() and !self.ZetaSpawnerID and !self.Permafriend then
            local json = file.Read('zetaplayerdata/profiles.json','DATA')
            local decoded = util.JSONToTable(json)
        
            for k, _ in pairs(decoded) do
                if table.HasValue(_bannedzetas,k) then decoded[k] = nil end
            end
        
            for _, v in ipairs(ents.FindByClass('npc_zetaplayer')) do
                if v != self and v.zetaname and decoded[v.zetaname] then decoded[v.zetaname] = nil end
            end
            for _, v in ipairs(ents.FindByClass('zeta_zetaplayerspawner')) do
                if v.zetaname and decoded[v.zetaname] then decoded[v.zetaname] = nil end
            end
        
            local searchProfile = nil
            local spawnerData = self:GetNW2String('zeta_spawneroverride','none')
            if spawnerData != 'none' then
                searchProfile = string.Explode(',',spawnerData)[10]
            end
        
            local name, profileData
            if !searchProfile then
                if GetConVar("zetaplayer_profilesystemonly"):GetBool() and !table.IsEmpty(decoded) then
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
            
                if profileData["admindata"] then
                    self.IsAdmin = profileData["admindata"]["isadmin"] or self.IsAdmin
                    self.Strictness = profileData["admindata"]["strictness"] or self.Strictness
                end
                
                self.IsMingebag = profileData["mingebag"] 

                self.VoicePack = profileData["voicepack"] or self.VoicePack
                self.VoicePitch = profileData["voicepitch"] or self.VoicePitch
                self.CustomSpawnWeapon = profileData["weapon"] or nil 

                self.PhysgunColor = profileData["physguncolor"] or self.PhysgunColor
                self.PlayermodelColor = profileData["playermodelcolor"] or self.PlayermodelColor

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

        if IsValid(self.Spawner) and self.Spawner.permfriend or !IsValid(self.Spawner) and self.Permafriend and SERVER then
            local friendPersona = GetConVar('zetaplayer_friendpersonalitytype'):GetString()
            if friendPersona == 'random' then
                self.BuildChance = zetamath.random(60)
                self.CombatChance = zetamath.random(10)
                self.ToolChance = zetamath.random(60)
                self.PhysgunChance = zetamath.random(60)
                self.DisrespectChance = zetamath.random(60)
                self.WatchMediaPlayerChance = zetamath.random(60)
                self.FriendlyChance = zetamath.random(60)
                self.VoiceChance = zetamath.random(60)
                self.VehicleChance = zetamath.random(20)
                self.TextChance = zetamath.random(60)

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
            elseif friendPersona == 'random++' then
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
            elseif friendPersona == 'builder' then
                self.BuildChance = 70
                self.CombatChance = 1
                self.ToolChance = 70
                self.PhysgunChance = 40
                self.DisrespectChance = 10
                self.WatchMediaPlayerChance = 10
                self.FriendlyChance = 10
                self.VoiceChance = 30
                self.VehicleChance = 30
                self.TextChance = 30
                
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
            elseif friendPersona == 'berserk' then
                self.BuildChance = 5
                self.CombatChance = 80
                self.ToolChance = 5
                self.PhysgunChance = 70
                self.DisrespectChance = 70
                self.WatchMediaPlayerChance = 3  
                self.FriendlyChance = 1
                self.VoiceChance = 30
                self.VehicleChance = 1
                self.TextChance = 30

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
            elseif friendPersona == 'custom' then 
                self.BuildChance = GetConVar('zetaplayer_friendbuildchance'):GetInt()
                self.CombatChance = GetConVar('zetaplayer_friendcombatchance'):GetInt()
                self.ToolChance = GetConVar('zetaplayer_friendtoolchance'):GetInt()
                self.PhysgunChance = GetConVar('zetaplayer_friendphysgunchance'):GetInt()
                self.DisrespectChance = GetConVar('zetaplayer_frienddisrespectchance'):GetInt()
                self.WatchMediaPlayerChance = GetConVar('zetaplayer_friendwatchmediaplayerchance'):GetInt()
                self.FriendlyChance = GetConVar('zetaplayer_friendfriendlychance'):GetInt()
                self.VoiceChance = GetConVar('zetaplayer_friendvoicechance'):GetInt()
                self.VehicleChance = GetConVar('zetaplayer_friendvehiclechance'):GetInt()
                self.TextChance = GetConVar('zetaplayer_friendtextchance'):GetInt()

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

            if GetConVar("zetaplayer_friendprofilepicture"):GetString() != "" then
                self.ProfilePicture = '../data/zetaplayerdata/custom_avatars/'..GetConVar("zetaplayer_friendprofilepicture"):GetString()
                self:SetNW2String('zeta_profilepicture',self.ProfilePicture)
            end

            self:SetMaxHealth(GetConVar("zetaplayer_friendhealth"):GetInt())
            self:SetHealth(self:GetMaxHealth())

            self.VoicePack = GetConVar("zetaplayer_friendvoicepack"):GetString()

            local overrideMdl = GetConVar('zetaplayer_friendoverridemodel'):GetString()
            if overrideMdl != '' then
                local cvarMdls = string.Explode(' ',overrideMdl)
                for k, v in ipairs(cvarMdls) do
                    if util.IsValidModel(v) then continue end
                    table.remove(cvarMdls, k)
                end

                if #cvarMdls > 0 then 
                    spawnmdl = cvarMdls[zetamath.random(#cvarMdls)] 
                else    
                    spawnmdl = 'models/player/kleiner.mdl' 
                end
            end
    
            if GetConVar("zetaplayer_friendusecustomcolors"):GetBool() then
                self.PlayermodelColor = Color(GetConVar("zetaplayer_friendplayermodelcolorR"):GetInt(),GetConVar("zetaplayer_friendplayermodelcolorG"):GetInt(),GetConVar("zetaplayer_friendplayermodelcolorB"):GetInt()):ToVector()
                self:SetNW2Vector('zeta_modelcolor',self.PlayermodelColor)
            end

            if GetConVar("zetaplayer_friendusephysguncolor"):GetBool() then
                self.PhysgunColor = Color(GetConVar("zetaplayer_friendphysguncolorR"):GetInt(),GetConVar("zetaplayer_friendphysguncolorG"):GetInt(),GetConVar("zetaplayer_friendphysguncolorB"):GetInt()):ToVector()
                self:SetNW2Vector('zeta_physcolor',self.PhysgunColor)
            end

            if GetConVar("zetaplayer_friendisadmin"):GetBool() and game.SinglePlayer() then
                self.IsAdmin = true
            else
                self.IsAdmin = false
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



        --[[print('Build = ',self.BuildChance)
        print('Combat = ',self.CombatChance)
        print('Tool = ',self.ToolChance)
        print('Physgun = ',self.PhysgunChance)
        print('Disrespect = ',self.DisrespectChance)
        print('Watch Media = ',self.WatchMediaPlayerChance)]]

        if GetConVar("zetaplayer_usenewchancesystem"):GetBool() then
            table.sort(self.PERSCHANCES,function(a,b) return a.chance > b.chance end)
        end


        self:SetModel(spawnmdl)
        self.CurrentNavArea = navmesh.GetNavArea(self:GetPos(),10000) 
        self:AddFlags(FL_OBJECT+FL_NPC)
        self:SetCollisionBounds(Vector(-10,-10,0),Vector(10,10,72))
        self:PhysicsInitShadow()
        self:SetCollisionGroup(COLLISION_GROUP_NPC)
        self:AddCallback('PhysicsCollide',function(self,data)
            self:HandleCollision(data)
        end) 
        self.loco:SetJumpHeight(70)
        self.loco:SetGravity(GetConVar("sv_gravity"):GetFloat())
        self.loco:SetAcceleration(800)
        self:SetupAchievements()
        self:CheckCurrentDate()
        self.VJ_AddEntityToSNPCAttackList = true

        if !self.SpawnOVERRIDE then
            self:ConnectMessage()
        end

        if self.ProfilePicture == "none" then
            self.ProfilePicture = "spawnicons/"..string.StripExtension(self:GetModel())..".png"
            self:SetNW2String('zeta_profilepicture',self.ProfilePicture)
        end

        if GetConVar('zetaplayer_randomplayermodelcolor'):GetBool() then
            self:SetNW2Vector("zeta_playermodelcolor", self.PlayermodelColor)
        end

        if !self.IsMingebag then
            if self.BodygroupData != nil then        
                for i = 1, #self.BodygroupData do
                    self:SetBodygroup(self.BodygroupData[i][1], self.BodygroupData[i][2])
                end
            elseif GetConVar("zetaplayer_randombodygroups"):GetBool() then
                local groups = self:GetBodyGroups()
                for _,tbl in ipairs(groups) do
                    local count = tbl.num
                    local bodygroup = tbl.id
            
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
    
        self.WeaponENT = ents.Create('base_anim') -- Create the Fake weapon
        self.WeaponENT:DeleteOnRemove(self)
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
        self:SetNW2Entity( 'zeta_grabbedent', self )
        self:SetNW2Bool( 'zeta_aggressor', false )

        
        self:InitializeHooks() -- All hooks are in util.lua. Organizing purposes

        if (!ZetaNavMesh_HidingSpots or navmesh.GetNavAreaCount() != ZetaNavMesh_LastHidingSpotCheckAreaCount) and navmesh.IsLoaded() then
            ZetaNavMesh_HidingSpots = {}
            ZetaNavMesh_LastHidingSpotCheckAreaCount = navmesh.GetNavAreaCount()
            for _, v in ipairs(navmesh.GetAllNavAreas()) do
                if v and v:IsValid() and !v:IsUnderwater() then
                    local hSpots = v:GetHidingSpots()
                    if #hSpots > 0 then
                        table.insert(ZetaNavMesh_HidingSpots, {v, hSpots})
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

        if GetConVar('zetaplayer_randomplayermodelcolor'):GetBool() then
            local color = self:GetNW2Vector("zeta_playermodelcolor",Vector(zetamath.random(0.0,1.0),zetamath.random(0.0,1.0),zetamath.random(0.0,1.0)))
            self.GetPlayerColor = function() return color end
        end

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
                zetarender.SetMaterial( self.FlashlightSprite )
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
            zetarender.SetMaterial( self.PhysgunGlowMat )
            zetarender.DrawSprite( (weapon:GetPos()+Vector(0,0,2))+weapon:GetForward()*25, size, size, color )
            zetarender.SetMaterial( self.PhysgunGlowMat2 )
            zetarender.DrawSprite( (weapon:GetPos()+Vector(0,0,2))+weapon:GetForward()*30, size, size, color )

            local shoulddraw = self:GetNW2Bool('zeta_drawphysgunbeam',false)
            if shoulddraw and IsValid(self) and IsValid(weapon) and weapon:GetModel() == 'models/weapons/w_physics.mdl' then
                local startpos = weapon:GetAttachment(1).Pos
                local ang = weapon:GetAttachment(1).Ang
                local ends = self:GetNW2Vector("zeta_physgunendbeam",Vector(0,0,0))
                zetarender.SetMaterial( self.PhysgunBeam )
                
                zetarender.StartBeam(11)
                zetarender.AddBeam( startpos, zetamath.random(2,5), zetamath.random(20,50), color)
                    zetarender.AddBeam( LerpVector(0.02,startpos+ang:Forward()*20,ends), zetamath.random(2,5), zetamath.random(20,50), color)
                    for i = 1, 8 do
                        zetarender.AddBeam( LerpVector(i/20,startpos+ang:Forward()*(30+i*10),ends), zetamath.random(2,5), zetamath.random(20,50), color)
                    end
                    zetarender.AddBeam( ends, zetamath.random(2,5), zetamath.random(20,50), color)
                zetarender.EndBeam()
                
                zetarender.SetMaterial( self.PhysgunGlowMat )
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
    table.Empty(dirSnds)

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
    table.Empty(dirSnds)

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
    table.Empty(dirSnds)

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
    table.Empty(dirSnds)

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
    table.Empty(dirSnds)

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
    table.Empty(dirSnds)

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
    table.Empty(dirSnds)

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
    table.Empty(dirSnds)

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
    table.Empty(dirSnds)

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
    table.Empty(dirSnds)

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
    table.Empty(dirSnds)

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
    table.Empty(dirSnds)

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
    table.Empty(dirSnds)

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
    local addondirSnds = file.Find("sound/zetaplayer/custom_vo/"..addon.."conrespond/*","GAME","namedesc")
    self.MediaWatchSoundCount = (!self.MEDIAWATCHVOICEPACKEXISTS and (!dirSnds) and 0 or !self.MEDIAWATCHVOICEPACKEXISTS and #dirSnds) or (self.MEDIAWATCHVOICEPACKEXISTS and (!addondirSnds) and 0 or self.MEDIAWATCHVOICEPACKEXISTS and #addondirSnds)

    --print("Found ",self.MediaWatchSoundCount," Media Watch sound Files")
    table.Empty(dirSnds)



    
    end



end -- INITIALIZE END





-----------------------------------------------
-- Functions that function
-----------------------------------------------


  // Get VJ SNPC's current relationship with players
  function ENT:GetVJSNPCRelationship(npc)
    if !IsValid(self) or !IsValid(npc) or !npc:IsNPC() or !npc.IsVJBaseSNPC then return end

    if istable(npc.VJ_AddCertainEntityAsEnemy) then
        for _, v in ipairs(npc.VJ_AddCertainEntityAsEnemy) do
            if v == self then return D_HT end
        end
    end
    
    // Loop through SNPC's class table
    for _, v in ipairs(npc.VJ_NPC_Class) do
        // if 'CLASS_PLAYER_ALLY' is found, it's friendly
        if v == 'CLASS_PLAYER_ALLY' then return D_LI end
    end

    // If SNPC's variable 'PlayerFriendly' is true, it's friendly
    if npc.PlayerFriendly == true then return D_LI end

    // Otherwise, SNPC is hostile to players
    return D_HT
end

local unstuckmin = -50
local unstuckmax = 50

local unstuckdata = {
    ignoreworld = true,
}

local physguntracedata = {
    filter = self,
    ignoreworld = true,
    collisiongroup = COLLISION_GROUP_DEBRIS
}
local surrounding = {}
function ENT:Think()


    local wepName = (CLIENT and self:GetNW2String("zeta_weaponname", "NONE") or self.Weapon)
    local wepData = self.WeaponDataTable[wepName]
    if wepData and wepData.onThink then
        local wepEnt = (CLIENT and self:GetNW2Entity("zeta_weaponent", NULL) or self.WeaponENT)
        wepData:onThink(self, wepEnt)
    end



    if SERVER then

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

        if IsValid(self.Enemy) then
            if !self:IsChasingSomeone() then
                self:AttackEnemy(self.Enemy,true)
            elseif self.IsSwimming and !self.loco:IsOnGround() and self:CanSee(self.Enemy) then
                local swimVelocity = nil
                local swimDir = (self.Enemy:GetPos() - self:GetPos()):Angle():Forward()
                local minRange = self.WeaponDataTable[self.Weapon].keepDistance or 300
                local dist = self:GetRangeSquaredTo(self.Enemy)
        
                if self.HasMelee or dist > ((minRange*minRange) + (192*192)) then
                    swimVelocity = swimDir * 320
                elseif dist < ((minRange*minRange) - (192*192)) then
                    swimVelocity = swimDir * -320
                end
        
                if swimVelocity then self.loco:SetVelocity(swimVelocity) end
            end
        end





        local landAnim = self:GetActivityWeapon(!self.IsMoving and "idle" or "move")
        if self:WaterLevel() >= 3 then
            if self.IsSwimming == false then
                self.IsSwimming = true
                self.loco:SetGravity(100)

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

            if self:IsChasingSomeone() and IsValid(self.Enemy) and (self.Enemy:GetPos().z - self:GetPos().z) > self.loco:GetStepHeight() and self.loco:IsOnGround() then
                self.IsJumping = true 
                self:SetLastActivity(self:GetActivity())
                self.loco:Jump()
            end

            local swimAnim = self:GetSwimAnimation()
            if !self.loco:IsOnGround() then 
                if self:GetActivity() != swimAnim then
                    self:StartActivity(swimAnim)
                    self:SetLastActivity(swimAnim)
                end
            elseif self:GetActivity() == swimAnim then
                self:StartActivity(landAnim)
                self:SetLastActivity(landAnim)
            end
        elseif self.IsSwimming == true then
            self.IsSwimming = false
            self.loco:SetGravity(GetConVar("sv_gravity"):GetFloat())
            self.DrowningStartTime = nil
            self:StartActivity(landAnim)
            self:SetLastActivity(landAnim)
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
                for _, v in ipairs(surrounding) do
                    local dist = self:GetRangeSquaredTo(v)
                    if dist < lastDist then
                        closeNextbot = v
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
            for _, v in ipairs(surrounding) do
                local dist = self:GetRangeSquaredTo(v)
                if dist < lastDist then
                    closeNPC = v
                    lastDist = dist
                end
            end

            if IsValid(closeNPC) then
                self:AttackEnemy(closeNPC, true)
            end
        end

        if GetConVar("zetaplayer_teamsalwaysattack"):GetBool() and self.zetaTeam and (!self.TeamAttackCur or CurTime() > self.TeamAttackCur) and !self:IsChasingSomeone() and self:GetState() != "panic" then
            self.TeamAttackCur = CurTime()+1.5

            local sight = self:FindInSight(self.SightDistance, function(ent)
                return self:CanTarget(ent)
            end)
            for k,v in RandomPairs(sight) do
                if IsValid(v) then
                    self:AttackEnemy(v, true)
                end
            end
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
            local line = trace.TraceLine(physguntracedata)

            self:SetNW2Vector("zeta_physgunendbeam",line.HitPos)
        end

        if self.UnstuckSelf then -- Unstuck behavior is now done here since creating a timer to run on tick is not a smart idea when you can use Think 
            local testingpoint = self:GetPos()+VectorRand(unstuckmin,unstuckmax) -- Test a random point
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
                    unstuckmin = -50
                    unstuckmax = 50
                else -- If either fails, just increment the unstuck mins and maxs until we get out
                    --print("Failed Hull check!")
                    unstuckmin = unstuckmin - 10 
                    unstuckmax = unstuckmax + 10
                end
            else
                unstuckmin = unstuckmin - 10 
                unstuckmax = unstuckmax + 10
            end
        end


        local speed = self.loco:GetVelocity():Length()
        if CurTime() > self.NextFootstepSnd and self.IsMoving == true and self.CanPlayFootstep == true and speed > 0 then
            self:EmitStepSound(70, 1)

            local nextSnd = math.Clamp(0.25 * (400 / speed), 0.25, 0.35)
            self.NextFootstepSnd = CurTime() + nextSnd
        end

        if !self.HasProperAttachment then
            local attachment = self:GetAttachmentPoint("hand")
            self.WeaponENT:SetPos(attachment.Pos)
            self.WeaponENT:SetAngles(attachment.Ang+Angle(0,0,180))
        end

        if GetConVar("developer"):GetInt() == 1 then
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
                        self:Remove()

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

        if CurTime() > self.checkfloor and GetConVar("zetaplayer_killontouchnodraworsky"):GetInt() == 1 then
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

            if self.InAir and !self.PreventFalldamage then
                local calcFallDmg = ((self.FallVelocity - 526.5) * (100.0 / (922.5 - 526.5)))
                if self.FallVelocity >= 2000 or calcFallDmg >= (self:Health() * 0.5) then self:PlayFallingSound() end
            end

            if self.Weapon == "CAMERA" and 100*zetamath.random() < 1 then
                self:UseCamera()
            end



        if !self.IsDriving then
            local ang = self:GetAngles()
            self:SetAngles(Angle(0,ang.y,0))
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




function ENT:Panic(fleeTarget, timeoutTime, forcePanic) 
    if self:GetState() == 'driving' or !forcePanic and (!self.AllowPanic or GetConVar('zetaplayer_panicthreshold'):GetFloat() <= 0) or self.PlayingPoker then return end
    self:ToggleNoclip(false)
    self:CancelMove()
    self:StopFacing()
    self.AllowVoice = false
    self:SetEnemy(NULL)
    self.FleeFromTarget = fleeTarget
    self:SetState('panic')
    
    DebugText('Panic: Panicked!')

    timer.Simple(math.Rand(0.1, 0.5),function()
        if !IsValid(self) then return end
        self:PlayPanicSound()
    end)

    self.AllowPanic = false
    timer.Remove("ZetaPanicTimeout"..self:EntIndex())
    timer.Create("ZetaPanicTimeout"..self:EntIndex(), (timeoutTime or zetamath.random(5, 15)), 1, function()
        if !IsValid(self) then return end
        self:CancelMove()
        self:SetState('idle')
        self.AllowVoice = true
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
        if GetConVar('zetaplayer_allowidlevoice'):GetInt() == 0 then return end
        if self.AllowVoice == false then return end
        if self.IsTyping then return end
        if self.IsSpeaking then return end
        if self:GetState() == "jailed/held" or self:GetState() == "adminsit" or self:GetState() == "conversation" or self:GetState() == "watching" then return end

        if 100 * zetamath.random() < self.TextChance and GetConVar("zetaplayer_allowtextchat"):GetInt() == 1 then
            self:TypeMessage("idle")
        else
            
            if 100 * zetamath.random() < self.VoiceChance then
                self:PlayIdleLine()
            end

        end

    end)

    if !self.ZetaSpawnerID and !self.nodisconnect then
        timer.Create("zeta_disconnecttimer"..self:EntIndex(),zetamath.random(1,GetConVar("zetaplayer_maxdisconnecttime"):GetInt()),0,function()
            if !IsValid(self) then timer.Remove("zeta_disconnecttimer"..self:EntIndex()) return end
            if GetConVar("zetaplayer_allowdisconnecting"):GetInt() == 1 and !self.PlayingPoker then
                self:DisconnectfromGame()
                timer.Remove("zeta_disconnecttimer"..self:EntIndex())
            end
        end)
    end

    self:StartUniversalTimer(1.0,15.0) -- This is used to call Universal actions 


        local wpnStr = GetConVar('zetaplayer_spawnweapon'):GetString()
    if self.CustomSpawnWeapon then
        wpnStr = self.CustomSpawnWeapon
    elseif self.Permafriend then
        wpnStr = GetConVar('zetaplayer_friendspawnweapon'):GetString()
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

   --self:SetState("findingconverse")

    
    --self:MovetoPosition(Vector(-1583.564819, -12707.463867, 128.031250))

    --self:SetState("usingcommand")

    --self:TypeMessage("idle")

    --self:FindVehicle()

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
        
    }



    
    while ( true ) do -- This is where the State system gets used Truuuuuuuust me.. It did not look this organized during earlier stages
        if GetConVar('zetaplayer_disabled'):GetInt() == 1 then
            self:CancelMove()
            self:SetState('idle')
            coroutine.wait(2)
        else

--[[             if self.RunThreadFunction then
                self.RunThreadFunction(self)
                self.RunThreadFunction = nil
            end ]]

            if isfunction(StateTBL[self:GetState()]) then
                StateTBL[self:GetState()]()
            end


            local time = self.CorStateTimes[self:GetState()]
            if time == nil then
                time = 1
            end
            coroutine.wait(time)

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