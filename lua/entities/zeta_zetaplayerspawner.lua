AddCSLuaFile()

ENT.Base = 'base_point'
ENT.Spawnable = true
ENT.SpawnedZeta = nil
ENT.zetaTeam = nil

local zetamath = {}

zetamath.random = math.random

function ENT:Initialize()
  if ( CLIENT ) then return end
    self:SetMaterial('null')
    local BuildChance
    local CombatChance
    local ToolChance
    local PhysgunChance
    local DisrespectChance
    local WatchMediaPlayerChance
    local FriendlyChance
    local MovementChance
    local Strictness
    local TextChance

    self.ProfilePicture = nil
    self.VoicePack = "none"

    self.RespawnTime = CurTime()

    self.Kills = 0
    self.Deaths = 0
    

    

    self.PhysgunColor = Color(zetamath.random(0,255),zetamath.random(0,255),zetamath.random(0,255)) -- Random physgun color. How do you even change only the glow color of the model?
    self.PlayermodelColor = Vector( zetamath.random(1,255) / 255, zetamath.random(1,255) / 255, zetamath.random(1,255) / 255 )

    local VoicePitch = (GetConVar('zetaplayer_differentvoicepitch'):GetInt() == 1) and zetamath.random(GetConVar("zetaplayer_voicepitchmin"):GetInt(), GetConVar("zetaplayer_voicepitchmax"):GetInt()) or 100

    
    self.mdl = 'models/player/kleiner.mdl'

    self.IsAdmin = (GetConVar("zetaplayer_forcespawnadmins"):GetInt() == 1)

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

    self.ShouldSpawnAdmin = self.IsAdmin
    
    local overrideMdl = GetConVar('zetaplayer_overridemodel'):GetString()
    if self.IsAdmin == true then overrideMdl = GetConVar('zetaplayer_adminoverridemodel'):GetString() end
    if overrideMdl != '' then
      -- Explode the string to table by ',' separator
      local cvarMdls = string.Explode(',',overrideMdl)
      for k, v in ipairs(cvarMdls) do
        -- If model is invalid, then remove it from table
        if !util.IsValidModel(v) then
          table.remove(cvarMdls, k)
        end
      end
    
      -- Set model to random model from table if there's any
      if #cvarMdls > 0 then 
        self.mdl = cvarMdls[zetamath.random(#cvarMdls)] 
      end
    elseif GetConVar('zetaplayer_randomplayermodels'):GetInt() == 1 then
      if GetConVar('zetaplayer_randomdefaultplayermodels'):GetInt() == 0 then
        self.mdl = table.Random(player_manager.AllValidModels())
      else
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
    
        self.mdl = mdls[zetamath.random(#mdls)]
      end
    end
    local naturalPrefix = (self.IsNatural and "natural" or "")
    local personalityCvar = GetConVar('zetaplayer_'..naturalPrefix..'personalitytype'):GetString()
    if personalityCvar == 'random' then
        BuildChance = zetamath.random(60)
        CombatChance = zetamath.random(10)
        ToolChance = zetamath.random(60)
        PhysgunChance = zetamath.random(60)
        DisrespectChance = zetamath.random(60)
        WatchMediaPlayerChance = zetamath.random(60)
        FriendlyChance = zetamath.random(60)
        VoiceChance = zetamath.random(60)
        VehicleChance = zetamath.random(60)
        TextChance = zetamath.random(20)
        self.Personality = "Random"

      elseif personalityCvar == 'random++' then
          BuildChance = zetamath.random(1,100) 
          CombatChance = zetamath.random(1,100) 
          ToolChance = zetamath.random(1,100) 
          PhysgunChance = zetamath.random(1,100) 
          DisrespectChance = zetamath.random(1,100) 
          WatchMediaPlayerChance = zetamath.random(1,100) 
          FriendlyChance = zetamath.random(1,100) 
          VoiceChance = zetamath.random(1,100) 
          VehicleChance = zetamath.random(1,100) 
          TextChance = zetamath.random(1,100)
          self.Personality = "Random++"
        elseif personalityCvar == 'builder' then
            BuildChance = 70
            CombatChance = 2
            ToolChance = 70
            PhysgunChance = 20
            DisrespectChance = 10
            WatchMediaPlayerChance = 10
            FriendlyChance = 10
            VoiceChance = 30
            VehicleChance = 50
            TextChance = 30
            self.Personality = "Builder"
        elseif personalityCvar == 'berserk' then
            BuildChance = 5
            CombatChance = 80
            ToolChance = 5
            PhysgunChance = 30
            DisrespectChance = 70
            WatchMediaPlayerChance = 3
            FriendlyChance = 1
            VoiceChance = 30
            VehicleChance = 30
            TextChance = 30
            self.Personality = "Berserk"
        elseif personalityCvar == 'custom' then 
            BuildChance = GetConVar('zetaplayer_buildchance'):GetInt()
            CombatChance = GetConVar('zetaplayer_combatchance'):GetInt()
            ToolChance = GetConVar('zetaplayer_toolchance'):GetInt()
            PhysgunChance = GetConVar('zetaplayer_physgunchance'):GetInt()
            DisrespectChance = GetConVar('zetaplayer_disrespectchance'):GetInt()
            WatchMediaPlayerChance = GetConVar('zetaplayer_watchmediaplayerchance'):GetInt()
            FriendlyChance = GetConVar('zetaplayer_friendlychance'):GetInt()
            VoiceChance = GetConVar('zetaplayer_voicechance'):GetInt()
            VehicleChance = GetConVar('zetaplayer_vehiclechance'):GetInt()
            TextChance = GetConVar('zetaplayer_textchance'):GetInt()
            self.Personality = "Custom"
        end

        local names = file.Read('zetaplayerdata/names.json','DATA')
        local decoded = util.JSONToTable(names)
        local nameList = {}
        for _, v in ipairs(decoded) do
            nameList[v] = true
        end
        
        local availableNames = nameList
        for _, v in ipairs(ents.FindByClass('npc_zetaplayer')) do
            if availableNames[v.zetaname] then availableNames[v.zetaname] = nil end
        end
        for _, v in ipairs(ents.FindByClass('zeta_zetaplayerspawner')) do
            if v != self and availableNames[v.zetaname] then availableNames[v.zetaname] = nil end
        end
        if table.Count(availableNames) <= 0 then
            availableNames = {}
            for _, v in ipairs(decoded) do
                availableNames[v] = true
            end
        end
        for k, _ in RandomPairs(availableNames) do
            self.zetaname = k
            break
        end
        self.permfriend = false

        if GetConVar("zetaplayer_permamentfriendalwaysspawn"):GetInt() == 1 and GetConVar("zetaplayer_permamentfriend"):GetString() != "" and game.SinglePlayer() and IsValid(Entity(1)) and GetConVar('zetaplayer_enablefriend'):GetInt() == 1 then
          local exists = false
          for k,v in ipairs(ents.FindByClass("npc_zetaplayer")) do
              if v.zetaname == GetConVar("zetaplayer_permamentfriend"):GetString() then
                  exists = true
                  break
              end
          end

          for k,v in ipairs(ents.FindByClass("zeta_zetaplayerspawner")) do
            if v.permfriend then
                exists = true
                break
            end
        end

          if !exists then
            self.zetaname = GetConVar("zetaplayer_permamentfriend"):GetString()
            self.permfriend = true
          end
      end
        
        self.zetaTeam = nil
        local zetateamdata 
        if GetConVar('zetaplayer_useteamsystem'):GetInt() == 1 then
            local teams = file.Read('zetaplayerdata/teams.json','DATA')
            local decoded = util.JSONToTable(teams)
            
            
            for k,v in RandomPairs(decoded) do
                local members = self:GetTeamMembers(v[1])

                if #members <= GetConVar('zetaplayer_eachteammemberlimit'):GetInt() then
                  self.zetaTeam = v[1]
                  zetateamdata = v
                    break
                elseif #members > GetConVar('zetaplayer_eachteammemberlimit'):GetInt() then
                    DebugText(v[1]..' team is full! Moving on')
                end
            end

            if GetConVar('zetaplayer_overrideteam'):GetString() != '' then
              self.zetaTeam = GetConVar('zetaplayer_overrideteam'):GetString()
            end

            if zetateamdata and zetateamdata.teammodel then
              self.mdl = zetateamdata.teammodel
            end
          if zetateamdata and zetateamdata[2] then
            
              self.PlayermodelColor = zetateamdata[2]
              self.TeamColorVEC = zetateamdata[2]
              self.TeamColor = zetateamdata[2]:ToColor()
          end
            
        end

        self.ProfilePicture = "none"

        if ( SERVER ) then
          
          if GetConVar("zetaplayer_usecustomavatars"):GetInt() == 1 then
            local avatars = self:FindVoiceChatAvatar()
            
            if avatars and #avatars > 0 then
              self.ProfilePicture = avatars[zetamath.random(#avatars)]
            end
            table.Empty(avatars)
          end
        end
        

      if !self.ProfilePicture then self.ProfilePicture = "none" end

      self.IsMingebag = false
      Strictness = zetamath.random(GetConVar("zetaplayer_adminsctrictnessmin"):GetFloat(),GetConVar("zetaplayer_adminsctrictnessmax"):GetFloat())

      if GetConVar("zetaplayer_mingebag"):GetInt() == 1 then
        self.IsMingebag = true 
      end



      if zetamath.random(1,100) < GetConVar("zetaplayer_voicepackchance"):GetInt() then
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


      self.CustomSpawnWeapon = self.permfriend and GetConVar("zetaplayer_friendspawnweapon"):GetString() or !self.IsNatural and GetConVar("zetaplayer_spawnweapon"):GetString() or self.IsNatural and self.NaturalWeapon

      
      if GetConVar('zetaplayer_useprofilesystem'):GetBool() and !self.permfriend then
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
    
        if name != nil then
            self.zetaname = name
        
            local model = profileData['playermodel']
            if model != nil and util.IsValidModel(model) then
              self.mdl = model
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
                end
            end
        
            local personality = profileData['personality']
            if personality != nil then
                BuildChance = tonumber(personality['build']) or BuildChance
                CombatChance = tonumber(personality['combat']) or CombatChance
                ToolChance = tonumber(personality['tool']) or ToolChance
                PhysgunChance = tonumber(personality['physgun']) or PhysgunChance
                DisrespectChance = tonumber(personality['disrespect']) or DisrespectChance
                WatchMediaPlayerChance = tonumber(personality['watchmedia']) or WatchMediaPlayerChance
                FriendlyChance = tonumber(personality['friendly']) or FriendlyChance
                VoiceChance = tonumber(personality['voice']) or VoiceChance
                VehicleChance = tonumber(personality['vehicle']) or VehicleChance
                TextChance = tonumber(personality['text']) or TextChance
                Personality = "PROFILE"
            end
        
            if profileData["admindata"] then
                self.ShouldSpawnAdmin = profileData["admindata"]["isadmin"] or self.IsAdmin
                Strictness = profileData["admindata"]["strictness"] or Strictness
            end
            
            self.IsMingebag = profileData["mingebag"]
            self.VoicePack = profileData["voicepack"] or self.VoicePack
            VoicePitch = profileData["voicepitch"] or VoicePitch
            self.CustomSpawnWeapon = profileData["weapon"] or nil

            self.nodisconnect = profileData["nodisconnect"]
            
            self.PhysgunColor = profileData["physguncolor"] or self.PhysgunColor
            self.PlayermodelColor = profileData["playermodelcolor"] or self.PlayermodelColor

            if profileData["playermodelcolor"] and self.PlayermodelColor and !isvector(self.PlayermodelColor) then
              self.PlayermodelColor = Color(profileData["playermodelcolor"].r,profileData["playermodelcolor"].g,profileData["playermodelcolor"].b):ToVector()
            end

          if profileData["physguncolor"] and self.PhysgunColor and !isvector(self.PhysgunColor) then
              self.PhysgunColor = Color(profileData["physguncolor"].r,profileData["physguncolor"].g,profileData["physguncolor"].b):ToVector()
          end

          self:SetNW2Vector('zeta_physcolor',self.PhysgunColor)
          self:SetNW2Vector('zeta_modelcolor',self.PlayermodelColor)


            if profileData["health"] then
              self.Overridehealth = profileData["health"]
            end

            if profileData["armor"] then
                timer.Simple(0,function()
                  self.OverrideArmor = profileData["armor"]
                  self.MaxArmor = math.max(100,profileData["armor"])
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




    local spawns = self:GetTeamSpawns()
    if #spawns > 0 then
        local spawn = spawns[math.random(#spawns)]
        if IsValid(spawn) then
            self:SetPos(spawn:GetPos())
        end
    end



    self.Personalitysettings = {
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
      voicepitch = VoicePitch,
      strictness = Strictness,
    }
    local zeta = ents.Create('npc_zetaplayer')
    self:DeleteOnRemove(zeta)
    if GetConVar("zetaplayer_zetaspawnersaveidentity"):GetInt() == 1 or self.IsNatural then 
      if !isvector(self.PhysgunColor) then
        self.PhysgunColor:ToVector()
      end
      ZetaPlayer_ApplySpawnOverridedata(zeta,self.zetaname,self.mdl,self.Personalitysettings,self.ProfilePicture,self.VoicePack,self.zetaTeam)
      zeta:SetNW2Vector('zeta_coloroverride', self.PhysgunColor)
      zeta:SetNW2Vector('zeta_playercoloroverride',self.PlayermodelColor)
      zeta.IsMingebag = self.IsMingebag
      zeta.IsAdmin = self.IsAdmin
      zeta.Permafriend = self.permfriend
      zeta.ShouldSpawnAdmin = self.ShouldSpawnAdmin
      zeta.ZetaSpawnerID = self:GetCreationID()
      zeta.Spawner = self
      zeta.CustomSpawnWeapon = self.CustomSpawnWeapon or nil
      zeta.UseCustomIdle = self.UseCustomIdle 
      zeta.overrideTeamColor = self.TeamColor
      zeta:SetNW2Vector('zeta_teamcolor', self.TeamColorVEC)
      zeta.UseCustomDeath = self.UseCustomDeath
      zeta.UseCustomKill = self.UseCustomKill
      zeta.UseCustomTaunt = self.UseCustomTaunt
      zeta.Personality = self.Personality
      zeta.FavouriteWeapon = self.FavouriteWeapon
      zeta.UseCustomPanic = self.UseCustomPanic
      zeta.UseCustomAssist = self.UseCustomAssist
      zeta.UseCustomLaugh = self.UseCustomLaugh
      zeta.UseCustomWitness = self.UseCustomWitness
      zeta.UseCustomAdminScold = self.UseCustomAdminScold
      zeta.UseCustomFalling = self.UseCustomFalling
      zeta.UseCustomSitRespond = self.UseCustomSitRespond
      zeta.UseCustomQuestion = self.UseCustomQuestion
      zeta.UseCustomConRespond = self.UseCustomConRespond
      zeta.UseCustomMediaWatch = self.UseCustomMediaWatch
    end
    zeta.NaturalWeapon = self.NaturalWeapon
    zeta.IsNatural = self.IsNatural
    zeta:SetPos(self:GetPos())
    zeta:SetAngles(Angle(0,zetamath.random(0,360,0),0))
    self.SpawnedZeta = zeta
    zeta:Spawn()

    timer.Simple(0,function()
      zeta.Deaths = self.Deaths
      zeta:SetNW2Int("zeta_deaths",self.Deaths)
      zeta.Kills = self.Kills
      zeta:SetNW2Int("zeta_kills",self.Kills)
      if self.Overridehealth then
        zeta:SetMaxHealth(self.Overridehealth)
        zeta:SetHealth(self.Overridehealth)
      end
      if self.OverrideArmor then
        zeta.MaxArmor = self.MaxArmor
        zeta.CurrentArmor = self.OverrideArmor
      end
    end)


    self.BodygroupData = {}
    self.SkinData = zeta:GetSkin()

    local bodygroups = zeta:GetBodyGroups()
    for i = 1, #bodygroups do
        if #bodygroups[i].submodels <= 0 then continue end
        table.insert(self.BodygroupData, {i-1, zeta:GetBodygroup(i-1)})
    end

    local nearArea = navmesh.GetNearestNavArea(self:GetPos(), true, 10000, false, true, 0)
  if IsValid(nearArea) then
      local tpPos = nearArea:GetClosestPointOnArea(self:GetPos())
      local min, max = zeta:GetCollisionBounds()
      local collisionTrace = util.TraceHull({start = tpPos,endpos = zeta:GetPos(),mins = min,maxs = max,filter = {self, zeta}})
      zeta:SetPos(collisionTrace.HitPos)
  end



  hook.Add("PostEntityTakeDamage","ZetaSpawner_Addkills"..self:EntIndex(),function(victim,dmginfo)
    if victim:GetClass() == "npc_zetaplayer" or victim:IsPlayer() or victim:IsNPC() then
      local IsvictimDead = victim:Health() <= 0 
      local attacker = dmginfo:GetAttacker()
        if IsvictimDead and attacker == self.SpawnedZeta and GetConVar("zetaplayer_zetaspawnersaveidentity"):GetInt() == 1 then
          self.Kills = self.Kills + 1
        elseif IsvictimDead and victim == self.SpawnedZeta and GetConVar("zetaplayer_zetaspawnersaveidentity"):GetInt() == 1 then
          self.Deaths = self.Deaths + 1
        end
    end
  end)







  if GetConVar("zetaplayer_zetaspawnersaveidentity"):GetInt() == 1 then 
    self.SpawnedZeta:ConnectMessage()

    local index = self:EntIndex()

    if !self.nodisconnect then
      timer.Create("zeta_disconnecttimer"..index,zetamath.random(1,GetConVar("zetaplayer_maxdisconnecttime"):GetInt()),0,function()
        if !IsValid(self) or !IsValid(self.SpawnedZeta) then timer.Remove("zeta_disconnecttimer"..index) return end
        if GetConVar("zetaplayer_allowdisconnecting"):GetInt() == 1 and !self.PlayingPoker then
          self.SpawnedZeta:DisconnectfromGame()
          self.Disconnecting = true
          timer.Remove("zeta_disconnecttimer"..index)
        end
      end)
    end
  end

  if GetConVar("zetaplayer_allowtextchat"):GetBool() and GetConVar("zetaplayer_connectlines"):GetBool() and math.random(1,3) == 1 then
    self.SpawnedZeta:TypeMessage("connect")
  end

end


function ENT:OnRemove()
  hook.Remove("PostEntityTakeDamage","ZetaSpawner_Addkills"..self:EntIndex())
end

function ENT:Think()

  if self.Disconnecting and !IsValid(self.SpawnedZeta) then
    self:Remove()
    return
  end

  
  if IsValid(self.SpawnedZeta) then 
		self.RespawnTime = CurTime()

    self.VoiceIconEnt = self.SpawnedZeta
    self.VoiceIconID = self.SpawnedZeta:EntIndex()

    local ragdoll = self.SpawnedZeta.DeathRagdoll
    if IsValid(ragdoll) then
      self.VoiceIconEnt = ragdoll
      self.VoiceIconID = ragdoll:EntIndex()
    end

	elseif (CurTime() - self.RespawnTime) >= GetConVar('zetaplayer_zetaspawnerrespawntime'):GetFloat() then
		local zeta = ents.Create('npc_zetaplayer')
		self:DeleteOnRemove(zeta)
		zeta:SetPos(self:GetPos())
		zeta:SetAngles(Angle(0,zetamath.random(0,360,0),0))
		if GetConVar("zetaplayer_zetaspawnersaveidentity"):GetInt() == 1 or self.IsNatural then 
      if !isvector(self.PhysgunColor) then
        self.PhysgunColor:ToVector()
      end
		  ZetaPlayer_ApplySpawnOverridedata(zeta,self.zetaname,self.mdl,self.Personalitysettings,self.ProfilePicture,self.VoicePack,self.zetaTeam)
		  zeta:SetNW2Vector('zeta_coloroverride', self.PhysgunColor)
		  zeta:SetNW2Vector('zeta_playercoloroverride',self.PlayermodelColor)
		  zeta.SkinData = self.SkinData
		  zeta.BodygroupData = self.BodygroupData
      zeta.IsMingebag = self.IsMingebag
      zeta.IsAdmin = self.IsAdmin
      zeta.Permafriend = self.permfriend
      zeta.ShouldSpawnAdmin = self.ShouldSpawnAdmin
      zeta.ZetaSpawnerID = self:GetCreationID()
      zeta.Spawner = self
      zeta.CustomSpawnWeapon = self.CustomSpawnWeapon or nil
      zeta.UseCustomIdle = self.UseCustomIdle 
      zeta.UseCustomDeath = self.UseCustomDeath
      zeta.UseCustomKill = self.UseCustomKill
      zeta.overrideTeamColor = self.TeamColor
      zeta:SetNW2Vector('zeta_teamcolor', self.TeamColorVEC)
      zeta.UseCustomTaunt = self.UseCustomTaunt
      zeta.Personality = self.Personality
      zeta.UseCustomPanic = self.UseCustomPanic
      zeta.FavouriteWeapon = self.FavouriteWeapon
      zeta.UseCustomAssist = self.UseCustomAssist
      zeta.UseCustomLaugh = self.UseCustomLaugh
      zeta.UseCustomWitness = self.UseCustomWitness
      zeta.UseCustomAdminScold = self.UseCustomAdminScold
      zeta.UseCustomFalling = self.UseCustomFalling
      zeta.UseCustomSitRespond = self.UseCustomSitRespond
      zeta.UseCustomQuestion = self.UseCustomQuestion
      zeta.UseCustomConRespond = self.UseCustomConRespond
      zeta.UseCustomMediaWatch = self.UseCustomMediaWatch
      net.Start('zeta_changevoicespeaker', true)
        net.WriteEntity(self.VoiceIconEnt)
        net.WriteInt(self.VoiceIconID or 0, 32)
        net.WriteEntity(zeta)
      net.Broadcast()

		end
    zeta.IsNatural = self.IsNatural

    self.SpawnedZeta = zeta

		zeta:Spawn()
    timer.Simple(0,function()
      zeta.Deaths = self.Deaths
      zeta:SetNW2Int("zeta_deaths",self.Deaths)
      zeta.Kills = self.Kills
      zeta:SetNW2Int("zeta_kills",self.Kills)
      if self.Overridehealth then
        zeta:SetMaxHealth(self.Overridehealth)
        zeta:SetHealth(self.Overridehealth)
      end
      if self.OverrideArmor then
        zeta.MaxArmor = self.MaxArmor
        zeta.CurrentArmor = self.OverrideArmor
      end
    end)
		local nearArea = navmesh.GetNearestNavArea(self:GetPos(), true, 10000, false, true, 0)
		if IsValid(nearArea) then
			local tpPos = nearArea:GetClosestPointOnArea(self:GetPos())
			local min, max = zeta:GetCollisionBounds()
			local collisionTrace = util.TraceHull({start = tpPos,endpos = zeta:GetPos(),mins = min,maxs = max,filter = {self, zeta}})
			zeta:SetPos(collisionTrace.HitPos)
		end
		zeta:EmitSound(GetConVar("zetaplayer_customspawnsound"):GetString() != "" and GetConVar("zetaplayer_customspawnsound"):GetString() or 'zetaplayer/misc/spawn_zeta.wav',60)

	end

	self:NextThink(CurTime() + 0.1)
	return true
end


function ENT:GetTeamSpawns()
  local teamspawns = ents.FindByClass("zeta_teamspawnpoint")
  local spawns = {}

  for k,v in ipairs(teamspawns) do
    if v:GetTeamSpawn() == self.zetaTeam then
      spawns[#spawns+1] = v
    end
  end

  return spawns
end


function ENT:FindVoiceChatAvatar()
  local avatars = {}
  local filescustom,dirscustom = file.Find("zetaplayerdata/custom_avatars/*","DATA","nameasc")
  if game.SinglePlayer() then
      for k,v in ipairs(filescustom) do
          if string.Right(v,4) == '.png' or string.Right(v,4) == '.jpg' then
              table.insert(avatars,"../data/zetaplayerdata/custom_avatars/"..v)
          end
      end
  end
  return avatars
end

  function ENT:GetTeamMembers(ZetaTeam)
    local members = {}
    local entities = ents.FindByClass('npc_zetaplayer')
    local spawners = ents.FindByClass('zeta_zetaplayerspawner')
    local players = player.GetAll()
    for k,ply in ipairs(players) do
      if GetConVar('zetaplayer_playerteam'):GetString() != 'SELF' and GetConVar('zetaplayer_playerteam'):GetString() == ZetaTeam then
        table.insert(members,ply)
      end
    end
  
    for k,zeta in ipairs(entities) do
      if zeta != self and zeta.zetaTeam == ZetaTeam and !zeta.ZetaSpawnerID then
        table.insert(members,zeta)
      end
    end
  
    for k,spawner in ipairs(spawners) do
      if spawner != self and spawner.zetaTeam == ZetaTeam then
        table.insert(members,spawner)
      end
    end
  
    return members
  end
  
  
  function ENT:GetAdmins()
    local admins = {}

    for k,v in ipairs(ents.FindByClass("npc_zetaplayer")) do
        if v.IsAdmin then
            table.insert(admins,v)
        end
    end

    return admins
end
  
  function ENT:IsInTeam(ent)
    if self.zetaTeam == 'SELF' then return false end
    if !ent:IsNextBot() or !ent:IsPlayer() then return "OBSOLETE" end
  
    if ent:IsNextBot() and ent.IsZetaPlayer then
      if ent.zetaTeam == self.zetaTeam then
        return true
      else
        return false
      end
    elseif ent:IsPlayer() then
      if GetConVar('zetaplayer_playerteam'):GetString() == self.zetaTeam then
        return true 
      else
        return false
      end
    else
      return false
    end
  
  
  end



list.Set( "NPC", "zeta_zetaplayerspawner", {
	Name = "Respawning Zeta Player",
	Class = "zeta_zetaplayerspawner",
	Category = "Zeta Bots"
})