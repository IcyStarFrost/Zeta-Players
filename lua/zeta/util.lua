-----------------------------------------------
-- Util Stuff
--- Some misc stuff
-----------------------------------------------

AddCSLuaFile()

local trace = {}
local zetamath = {}

zetamath.random = math.random
zetamath.Rand = math.Rand
zetamath.ApproachAngle = math.ApproachAngle
zetamath.Approach = math.Approach
trace.TraceLine = util.TraceLine

local ents = ents
local util = util
local math = math
local table = table
local ipairs = ipairs
local pairs = pairs
local RandomPairs = RandomPairs



local oldisvalid = IsValid

local function IsValid( ent )
    if oldisvalid( ent ) and ent.IsZetaPlayer then
        
        return !ent.IsDead 
    else
        return oldisvalid( ent )
    end
end

local level = 75
local volume = 1

sound.Add({
  name = "ZetaPlayer.AntlionFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "physics/flesh/flesh_impact_hard1.wav",
    "physics/flesh/flesh_impact_hard2.wav",
    "physics/flesh/flesh_impact_hard3.wav",
    "physics/flesh/flesh_impact_hard4.wav",
    "physics/flesh/flesh_impact_hard5.wav",
    "physics/flesh/flesh_impact_hard6.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.BloodyFleshFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "physics/flesh/flesh_squishy_impact_hard1.wav",
    "physics/flesh/flesh_squishy_impact_hard2.wav",
    "physics/flesh/flesh_squishy_impact_hard3.wav",
    "physics/flesh/flesh_squishy_impact_hard4.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.ConcreteFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "player/footsteps/concrete1.wav",
    "player/footsteps/concrete2.wav",
    "player/footsteps/concrete3.wav",
    "player/footsteps/concrete4.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.DirtFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "player/footsteps/dirt1.wav",
    "player/footsteps/dirt2.wav",
    "player/footsteps/dirt3.wav",
    "player/footsteps/dirt4.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.EggShellFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "physics/flesh/flesh_impact_hard1.wav",
    "physics/flesh/flesh_impact_hard2.wav",
    "physics/flesh/flesh_impact_hard3.wav",
    "physics/flesh/flesh_impact_hard4.wav",
    "physics/flesh/flesh_impact_hard5.wav",
    "physics/flesh/flesh_impact_hard6.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.FleshFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "physics/flesh/flesh_impact_hard1.wav",
    "physics/flesh/flesh_impact_hard2.wav",
    "physics/flesh/flesh_impact_hard3.wav",
    "physics/flesh/flesh_impact_hard4.wav",
    "physics/flesh/flesh_impact_hard5.wav",
    "physics/flesh/flesh_impact_hard6.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.GrateFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "player/footsteps/chainlink1.wav",
    "player/footsteps/chainlink2.wav",
    "player/footsteps/chainlink3.wav",
    "player/footsteps/chainlink4.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.AlienFleshFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "physics/flesh/flesh_impact_hard1.wav",
    "physics/flesh/flesh_impact_hard2.wav",
    "physics/flesh/flesh_impact_hard3.wav",
    "physics/flesh/flesh_impact_hard4.wav",
    "physics/flesh/flesh_impact_hard5.wav",
    "physics/flesh/flesh_impact_hard6.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.SnowFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "zetaplayer/footsteps/snow1.wav",
    "zetaplayer/footsteps/snow2.wav",
    "zetaplayer/footsteps/snow3.wav",
    "zetaplayer/footsteps/snow4.wav",
    "zetaplayer/footsteps/snow5.wav",
    "zetaplayer/footsteps/snow6.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.PlasticFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "physics/plastic/plastic_box_impact_soft1.wav",
    "physics/plastic/plastic_box_impact_soft2.wav",
    "physics/plastic/plastic_box_impact_soft3.wav",
    "physics/plastic/plastic_box_impact_soft4.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.MetalFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "player/footsteps/metal1.wav",
    "player/footsteps/metal2.wav",
    "player/footsteps/metal3.wav",
    "player/footsteps/metal4.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.SandFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "player/footsteps/sand1.wav",
    "player/footsteps/sand2.wav",
    "player/footsteps/sand3.wav",
    "player/footsteps/sand4.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.FoliageFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "player/footsteps/grass1.wav",
    "player/footsteps/grass2.wav",
    "player/footsteps/grass3.wav",
    "player/footsteps/grass4.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.ComputerFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "player/footsteps/metal1.wav",
    "player/footsteps/metal2.wav",
    "player/footsteps/metal3.wav",
    "player/footsteps/metal4.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.SloshFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "player/footsteps/slosh1.wav",
    "player/footsteps/slosh2.wav",
    "player/footsteps/slosh3.wav",
    "player/footsteps/slosh4.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.TileFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "player/footsteps/tile1.wav",
    "player/footsteps/tile2.wav",
    "player/footsteps/tile3.wav",
    "player/footsteps/tile4.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.GrassFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "player/footsteps/grass1.wav",
    "player/footsteps/grass2.wav",
    "player/footsteps/grass3.wav",
    "player/footsteps/grass4.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.VentFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "player/footsteps/duct1.wav",
    "player/footsteps/duct2.wav",
    "player/footsteps/duct3.wav",
    "player/footsteps/duct4.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.WoodFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "player/footsteps/wood1.wav",
    "player/footsteps/wood2.wav",
    "player/footsteps/wood3.wav",
    "player/footsteps/wood4.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.DefaultFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "player/footsteps/concrete1.wav",
    "player/footsteps/concrete2.wav",
    "player/footsteps/concrete3.wav",
    "player/footsteps/concrete4.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.GlassFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "physics/glass/glass_sheet_step1.wav",
    "physics/glass/glass_sheet_step2.wav",
    "physics/glass/glass_sheet_step3.wav",
    "physics/glass/glass_sheet_step4.wav"
  }
})

sound.Add({
  name = "ZetaPlayer.WarpShieldFootstep",
  channel = CHAN_BODY, 
  level = level, 
  volume = volume,
  sound = {
    "physics/glass/glass_sheet_step1.wav",
    "physics/glass/glass_sheet_step2.wav",
    "physics/glass/glass_sheet_step3.wav",
    "physics/glass/glass_sheet_step4.wav"
  }
})



ENT.Footsteps = {
  [MAT_ANTLION] = "ZetaPlayer.AntlionFootstep",
  [MAT_BLOODYFLESH] = "ZetaPlayer.BloodyFleshFootstep",
  [MAT_CONCRETE] = "ZetaPlayer.ConcreteFootstep",
  [MAT_DIRT] = "ZetaPlayer.DirtFootstep",
  [MAT_EGGSHELL] = "ZetaPlayer.EggShellFootstep",
  [MAT_FLESH] = "ZetaPlayer.FleshFootstep",
  [MAT_GRATE] = "ZetaPlayer.GrateFootstep",
  [MAT_ALIENFLESH] = "ZetaPlayer.AlienFleshFootstep",
  [MAT_SNOW] = "ZetaPlayer.SnowFootstep",
  [MAT_PLASTIC] = "ZetaPlayer.PlasticFootstep",
  [MAT_METAL] = "ZetaPlayer.MetalFootstep",
  [MAT_SAND] = "ZetaPlayer.SandFootstep",
  [MAT_FOLIAGE] = "ZetaPlayer.FoliageFootstep",
  [MAT_COMPUTER] = "ZetaPlayer.ComputerFootstep",
  [MAT_SLOSH] = "ZetaPlayer.SloshFootstep",
  [MAT_TILE] = "ZetaPlayer.TileFootstep",
  [MAT_GRASS] = "ZetaPlayer.GrassFootstep",
  [MAT_VENT] = "ZetaPlayer.VentFootstep",
  [MAT_WOOD] = "ZetaPlayer.WoodFootstep",
  [MAT_DEFAULT] = "ZetaPlayer.DefaultFootstep",
  [MAT_GLASS] = "ZetaPlayer.GlassFootstep",
  [MAT_WARPSHIELD] = "ZetaPlayer.WarpShieldFootstep"
}

ENT.WitnessSNDS = {
  'vo/npc/male01/goodgod.wav',
  'vo/npc/male01/gordead_ans04.wav',
  'vo/npc/male01/gordead_ans05.wav',
  'vo/npc/male01/gordead_ans06.wav',
  'vo/npc/male01/gordead_ans07.wav',
  'vo/npc/male01/gordead_ans08.wav',
  'vo/npc/male01/gordead_ans09.wav',
  'vo/npc/male01/gordead_ans10.wav',
  'vo/npc/male01/gordead_ans12.wav',
  'vo/npc/male01/gordead_ans16.wav',
  'vo/npc/male01/gordead_ans17.wav',
  'vo/npc/male01/gordead_ans18.wav',
  'vo/npc/male01/gordead_ans19.wav',
  'vo/npc/male01/gordead_ans20.wav',
  'vo/npc/male01/gordead_ques01.wav',
  'vo/npc/male01/gordead_ques02.wav',
  'vo/npc/male01/gordead_ques03a.wav',
  'vo/npc/male01/gordead_ques03b.wav',
  'vo/npc/male01/gordead_ques04.wav',
  'vo/npc/male01/gordead_ques05.wav',
  'vo/npc/male01/gordead_ques06.wav',
  'vo/npc/male01/gordead_ques07.wav',
  'vo/npc/male01/gordead_ques08.wav',
  'vo/npc/male01/gordead_ques11.wav',
  'vo/npc/male01/gordead_ques17.wav',
  'vo/npc/male01/gordead_ques15.wav',
  'vo/npc/male01/ohno.wav',
  'vo/npc/male01/watchwhat.wav',
  'vo/npc/male01/wetrustedyou01.wav',
  'vo/npc/male01/wetrustedyou02.wav',
  
  }

  ENT.Relations = {
    
    ['npc_combine_s'] = D_HT,
    ['npc_metropolice'] = D_HT,
    ['npc_zombie'] = D_HT,
    ['npc_fastzombie'] = D_HT,
    ['npc_fastzombie_torso'] = D_HT,
    ['npc_headcrab_fast'] = D_HT,
    ['npc_zombie_torso'] = D_HT,
    ['npc_poisonzombie'] = D_HT,
    ['npc_headcrab_black'] = D_HT,
    ['npc_headcrab'] = D_HT,
    ['npc_zombine'] = D_HT,
    ['npc_antlion'] = D_HT,
    ['npc_antlionguard'] = D_HT,
    ['npc_antlionguardian'] = D_HT,
    ['npc_antlion_worker'] = D_HT,
    ['npc_manhack'] = D_HT,
    ['npc_rollermine'] = D_HT,
    ['npc_turret_floor'] = D_HT,
    ['npc_turret_ceiling'] = D_HT,
    ['npc_combine_camera'] = D_HT,
    ['npc_combinegunship'] = D_HT,
    ['npc_helicopter'] = D_HT,
    ['npc_cscanner'] = D_HT,
    ['npc_clawscanner'] = D_HT,
    ['npc_hunter'] = D_HT,
    ['npc_strider'] = D_HT,


  }

  ENT.PanicSNDS = {
    'vo/npc/male01/help01.wav',
    'vo/npc/male01/heretheycome01.wav',
    'vo/npc/male01/incoming02.wav',
    'vo/npc/male01/no01.wav',
    'vo/npc/male01/no02.wav',
    'vo/npc/male01/startle01.wav',
    'vo/npc/male01/startle02.wav',
    'vo/npc/male01/strider_run.wav',
    'vo/npc/male01/uhoh.wav',
    'vo/npc/male01/watchout.wav',
    'vo/npc/male01/wetrustedyou02.wav',
    'vo/k_lab/kl_hedyno03.wav',
    'vo/citadel/br_ohshit.wav'
    }


    ENT.CorStateTimes = {
      ['idle'] = 0.5,
      ['chasemelee'] = 0.4,
      ['panic'] = 0,
      ['disrespect'] = 0.3,
      ['laughing'] = 1,
      ['sitting'] = 1,
      ['dancing'] = 0.1,
      ['chaseranged'] = 0,
      ['watching'] = 1,
      ['followingfriend'] = 0.3,
      ['driving'] = 0.5
    }

    ENT.RopeMats ={
      'cable/rope',
      'cable/cable2',
      'cable/cable',
      'cable/blue_elec',
      'cable/physbeam',
      'cable/xbeam',
      'cable/redlaser',
      'cable/hydra',


    }

    ENT.TrailMats = {
      'trails/love',
      'trails/physbeam',
      'trails/plasma',
      'trails/lol',
      'effects/beam_generic01',
      'trails/smoke',
      'effects/arrowtrail_red',
      'trails/tube',
      'effects/beam001_red',
      'effects/arrowtrail_blu',
      'trails/electric',
      'effects/beam001_blu',
      'trails/laser',
      'effects/repair_claw_trail_red'
   
      }


      ENT.Decals = {
        "BeerSplash",
        "BirdPoop",
        "Blood",
        "BulletProof",
        "Cross",
        "Dark",
        "ExplosiveGunshot",
        "Eye",
        "FadingScorch",
        "GlassBreak",
        "Impact.Antlion",
        "Impact.BloodyFlesh",
        "Impact.Concrete",
        "Impact.Glass",
        "Impact.Metal",
        "Impact.Sand",
        "Impact.Wood",
        "Light",
        "ManhackCut",
        "Nought",
        "Noughtsncrosses",
        "PaintSplatBlue",
        "PaintSplatGreen",
        "PaintSplatPink",
        "Scorch",
        "SmallScorch",
        "Smile",
        "Splash.Large",
        "YellowBlood",
      }

      ENT.RPGTargets = {
        ["npc_strider"] = true,
        ["npc_rollermine"] = true,
        ["npc_helicopter"] = true,
        ["npc_combinegunship"] = true
      }



 



---
-- NOTE TO SELF: When trying to get a table, remember to change ENT to self. Don't fall into the trap of why it returned a NIL Value
---







-----------------------------------------------
-- Util Stuff vui vui
-----------------------------------------------

function ENT:IsChasingSomeone()
  return (self.State == 'chaseranged' or self.State == 'chasemelee')
end

function ENT:IsSanicNextBot(ent)
  return (ent:GetClass() == 'npc_sanic' or (ent:IsNextBot() and isfunction(ent.AttackNearbyTargets)))
end

function ENT:GetStepSound(matType)
  return self.Footsteps[matType]
end

function ENT:SetEnemy(ent)
	self.Enemy = ent
end

function ENT:GetEnemy()
	return self.Enemy
end

function ENT:SetLastState(state)
    self.LastState = state 
end

function ENT:GetFrags()
  return self.Kills
end

function ENT:GetDeaths()
  return self.Deaths or 0
end

function ENT:ResetState()
  self:SetEnemy(NULL)
  self:SetState("idle")
  self:CancelMove()

end

function ENT:Name()
  return self.zetaname
end

function ENT:Ping()
  return 0
end

function ENT:GetLastState()
    if !self.LastState then
        return 'idle'
    else
        return self.LastState
    end
end

function ENT:SetLastActivity(Activity)
    self.LastActivity = Activity
end

function ENT:GetLastActivity()
    if !self.LastActivity then
        return ACT_HL2MP_IDLE
    else
        return self.LastActivity
    end
end

function ENT:SendConsoleLog(text,color)
  color = color or color_white

  net.Start("zeta_sendonscreenlog")
    net.WriteString(text)
    net.WriteColor(color)
  net.Broadcast()
end

ENT.LastStateTraces = {}

function ENT:PrintStateDebug()
  PrintTable(self.LastStateTraces)
end

ENT.LastStateCall = CurTime()
local color_red = Color(165,18,18)

function ENT:SetState(state)
  local rapid = CurTime() < self.LastStateCall
  if GetConVar("zetaplayer_debug_warnrapidstatechange"):GetBool() and rapid then self:SendConsoleLog(self.zetaname.." had a rapid state change! If this happened below 4 times, disregard.",color_red) Entity(1):EmitSound("common/warning.wav") end

  self.LastStateCall = CurTime()+0.5
    hook.Run("ZetaOnStateChanged", self, self:GetState(), state)

    local newindex = #self.LastStateTraces+1
    if newindex > 3 then table.remove(self.LastStateTraces,1) end

    local add = rapid and "This change is deemed to have been rapid. CurTime() being,  "..tostring(CurTime()).."\n" or ""

    self.LastStateTraces[newindex] = add..self.zetaname.." Changed their state from "..self:GetState().." to "..state.." Stack Trace is.. \n\n"..debug.traceback().."\n\n"
    if self.stacktrace then
      print(self.zetaname," Changed their state to "..state," Stack Trace is.. ",debug.traceback())
    end

    self:SetLastState(self:GetState())
    self.State = state
end


function ENT:GetState()
    return self.State
end

function ENT:CancelMove()
  if self.IsMoving == true then
    self.AbortMove = true
  end
end


function ENT:GetActivityWeapon(animtype)
  if self.IsMingebag then return 0 end
	local wepData = _ZetaWeaponDataTable[self.Weapon]
	if wepData != nil then return wepData.anims[animtype] end
end

local swimAnimTranslations = {  -- In case if I forgot to put more animations, add them here
  [ACT_HL2MP_IDLE]          = ACT_HL2MP_SWIM_IDLE,
  [ACT_HL2MP_IDLE_PHYSGUN]     = ACT_HL2MP_SWIM_IDLE_PHYSGUN,
  [ACT_HL2MP_IDLE_FIST]     = ACT_HL2MP_SWIM_IDLE_FIST,
  [ACT_HL2MP_IDLE_KNIFE]    = ACT_HL2MP_SWIM_IDLE_KNIFE,
  [ACT_HL2MP_IDLE_MELEE]    = ACT_HL2MP_SWIM_IDLE_MELEE,
  [ACT_HL2MP_IDLE_MELEE2]   = ACT_HL2MP_SWIM_IDLE_MELEE2,
  [ACT_HL2MP_IDLE_PISTOL]   = ACT_HL2MP_SWIM_IDLE_PISTOL,
  [ACT_HL2MP_IDLE_REVOLVER] = ACT_HL2MP_SWIM_IDLE_REVOLVER,
  [ACT_HL2MP_IDLE_DUEL]   = ACT_HL2MP_SWIM_IDLE_DUEL,
  [ACT_HL2MP_IDLE_SMG1]     = ACT_HL2MP_SWIM_IDLE_SMG1,
  [ACT_HL2MP_IDLE_AR2]      = ACT_HL2MP_SWIM_IDLE_AR2,
  [ACT_HL2MP_IDLE_SHOTGUN]  = ACT_HL2MP_SWIM_IDLE_SHOTGUN,
  [ACT_HL2MP_IDLE_CROSSBOW] = ACT_HL2MP_SWIM_IDLE_CROSSBOW,
  [ACT_HL2MP_IDLE_RPG]      = ACT_HL2MP_SWIM_IDLE_RPG,
  [ACT_HL2MP_IDLE_GRENADE]  = ACT_HL2MP_SWIM_IDLE_GRENADE,
  [ACT_HL2MP_IDLE_SLAM]     = ACT_HL2MP_SWIM_IDLE_SLAM,
  [ACT_HL2MP_IDLE_CAMERA]   = ACT_HL2MP_SWIM_IDLE_CAMERA,
  [ACT_HL2MP_IDLE_MAGIC]    = ACT_HL2MP_SWIM_IDLE_MAGIC,
  [ACT_HL2MP_IDLE_ZOMBIE]    = ACT_HL2MP_RUN_ZOMBIE_FAST,

  [ACT_HL2MP_RUN]           = ACT_HL2MP_SWIM,
  [ACT_HL2MP_RUN_PHYSGUN]      = ACT_HL2MP_SWIM_PHYSGUN,
  [ACT_HL2MP_RUN_FIST]      = ACT_HL2MP_SWIM_FIST,
  [ACT_HL2MP_RUN_KNIFE]     = ACT_HL2MP_SWIM_KNIFE,
  [ACT_HL2MP_RUN_MELEE]     = ACT_HL2MP_SWIM_MELEE,
  [ACT_HL2MP_RUN_MELEE2]    = ACT_HL2MP_SWIM_MELEE2,
  [ACT_HL2MP_RUN_PISTOL]    = ACT_HL2MP_SWIM_PISTOL,
  [ACT_HL2MP_RUN_DUEL]    = ACT_HL2MP_SWIM_DUEL,
  [ACT_HL2MP_RUN_REVOLVER]  = ACT_HL2MP_SWIM_REVOLVER,
  [ACT_HL2MP_RUN_SMG1]      = ACT_HL2MP_SWIM_SMG1,
  [ACT_HL2MP_RUN_AR2]       = ACT_HL2MP_SWIM_AR2,
  [ACT_HL2MP_RUN_SHOTGUN]   = ACT_HL2MP_SWIM_SHOTGUN,
  [ACT_HL2MP_RUN_CROSSBOW]  = ACT_HL2MP_SWIM_CROSSBOW,
  [ACT_HL2MP_RUN_RPG]       = ACT_HL2MP_SWIM_RPG,
  [ACT_HL2MP_RUN_GRENADE]   = ACT_HL2MP_SWIM_GRENADE,
  [ACT_HL2MP_RUN_SLAM]      = ACT_HL2MP_SWIM_SLAM,
  [ACT_HL2MP_RUN_CAMERA]    = ACT_HL2MP_SWIM_CAMERA,
  [ACT_HL2MP_RUN_MAGIC]     = ACT_HL2MP_SWIM_MAGIC,
  [ACT_HL2MP_RUN_ZOMBIE]     = ACT_HL2MP_RUN_ZOMBIE_FAST,
}

local walkAnimTranslations = {  
  [ACT_HL2MP_RUN]           = ACT_HL2MP_WALK,
  [ACT_HL2MP_RUN_PHYSGUN]      = ACT_HL2MP_WALK_PHYSGUN,
  [ACT_HL2MP_RUN_FIST]      = ACT_HL2MP_WALK_FIST,
  [ACT_HL2MP_RUN_KNIFE]     = ACT_HL2MP_WALK_KNIFE,
  [ACT_HL2MP_RUN_MELEE]     = ACT_HL2MP_WALK_MELEE,
  [ACT_HL2MP_RUN_MELEE2]    = ACT_HL2MP_WALK_MELEE2,
  [ACT_HL2MP_RUN_PISTOL]    = ACT_HL2MP_WALK_PISTOL,
  [ACT_HL2MP_RUN_DUEL]    =   ACT_HL2MP_WALK_DUEL,
  [ACT_HL2MP_RUN_REVOLVER]  = ACT_HL2MP_WALK_REVOLVER,
  [ACT_HL2MP_RUN_SMG1]      = ACT_HL2MP_WALK_SMG1,
  [ACT_HL2MP_RUN_AR2]       = ACT_HL2MP_WALK_AR2,
  [ACT_HL2MP_RUN_SHOTGUN]   = ACT_HL2MP_WALK_SHOTGUN,
  [ACT_HL2MP_RUN_CROSSBOW]  = ACT_HL2MP_WALK_CROSSBOW,
  [ACT_HL2MP_RUN_RPG]       = ACT_HL2MP_WALK_RPG,
  [ACT_HL2MP_RUN_GRENADE]   = ACT_HL2MP_WALK_GRENADE,
  [ACT_HL2MP_RUN_SLAM]      = ACT_HL2MP_WALK_SLAM,
  [ACT_HL2MP_RUN_CAMERA]    = ACT_HL2MP_WALK_CAMERA,
  [ACT_HL2MP_RUN_MAGIC]     = ACT_HL2MP_WALK_MAGIC,
  [ACT_HL2MP_RUN_ZOMBIE]     = ACT_HL2MP_WALK_ZOMBIE,
}

function ENT:GetSwimAnimation(anim)
  local landAnim = anim or self:GetActivityWeapon(!self.IsMoving and "idle" or "move")
  return (swimAnimTranslations[landAnim] or 0)
end

function ENT:StartActivityWEP(animtype)
  self:StartActivity(self:GetActivityWeapon("move"))  
end


function ENT:Face(ent_pos)
  timer.Create('zetafacetoward'..self:EntIndex(),0,0,function()

    if !self and !self:IsValid() or !self.loco then timer.Remove('zetafacetoward'..self:EntIndex()) return end

    if type(ent_pos) == 'Entity' or type(ent_pos) == 'Player' or type(ent_pos) == 'NPC' then

    if !ent_pos:IsValid() then  timer.Remove('zetafacetoward'..self:EntIndex()) return end
    self.loco:FaceTowards(ent_pos:GetPos())
    elseif type(ent_pos) == 'Vector' then
      self.loco:FaceTowards(ent_pos)
    end
  end)
end

function ENT:FacePos(pos)
  timer.Create('zetafacetoward'..self:EntIndex(),0,0,function()
    if !IsValid(self) then timer.Remove('zetafacetoward'..self:EntIndex()) return end
    self.loco:FaceTowards(pos)
  end)
end

function ENT:StopFacing()
  timer.Remove('zetafacetoward'..self:EntIndex())
  self:RemoveThinkFunction("zetalookatboth2")
end

function DebugText(string)
  if GetConVar('zetaplayer_debug'):GetInt() == 1 then
    PrintMessage(HUD_PRINTTALK,string)
  end
end


function ENT:FindInSight(radius,filter)
  local picked = {}
  local sphere = ents.FindInSphere(self:GetPos(),radius)
  for k,v in ipairs(sphere) do
  
     if filter == nil or filter(v) == true then
      local lostest = trace.TraceLine({start = self:GetPos()+self:OBBCenter(),endpos = v:GetPos()+v:OBBCenter(),filter = self})
      if lostest.Entity == v and IsValid(v) or lostest.Entity:IsVehicle() and isfunction(lostest.Entity.GetDriver) and lostest.Entity:GetDriver() == v then
       table.insert(picked,v)
      end
     end
  end

  return picked
end

function ENT:GetShootPos()
  return self.WeaponENT and self.WeaponENT:GetPos() or self:WorldSpaceCenter()
end

function ENT:FindInSphere(radius,filter)
  local picked = {}
  local sphere = ents.FindInSphere(self:GetPos(),radius)
  for k,v in ipairs(sphere) do
  
     if filter(v) == true then
       table.insert(picked,v)
     end
  end

  return picked
end

function FindInSphereFilt(pos,radius,filter)
  local picked = {}
  local sphere = ents.FindInSphere(pos,radius)
  for k,v in ipairs(sphere) do
  
     if filter(v) == true then
       table.insert(picked,v)
     end
  end

  return picked
end


function ENT:FindInSightPermission(radius)
  local allowtoolgunnonworld = GetConVar('zetaplayer_allowtoolgunnonworld'):GetInt()
  local allowtoolgunworld = GetConVar('zetaplayer_allowtoolgunworld'):GetInt()
  local allowphysgunnonworld = GetConVar('zetaplayer_allowphysgunnonworld'):GetInt()
  local allowphysgungunworld = GetConVar('zetaplayer_allowphysgunworld'):GetInt()
  local allowphysgunzeta = GetConVar('zetaplayer_allowphysgunzetas'):GetInt()
  local picked = {}

  local sphere = ents.FindInSphere(self:GetPos(),radius)



  for k,v in ipairs(sphere) do
    local testlos = trace.TraceLine({start = self:GetPos()+self:OBBCenter(),endpos = v:GetPos()+v:OBBCenter(),filter = self})
    local testworld = v:CreatedByMap()
    
    if testlos.Entity == v and IsValid(v) then
      if !v:GetPhysicsObject():IsValid() then continue end
      if v:GetClass() == 'base_anim' then continue end
      if self.Weapon == 'TOOLGUN' then
      if !v:IsPlayer() and v:GetClass() != 'npc_zetaplayer' then
        if v.IsZetaProp then table.insert(picked,v) end

        if allowtoolgunnonworld == 1 and !testworld then table.insert(picked,v) end -- These permission tests were a pain to even get working. Took me about 3 hours for this
        if allowtoolgunworld == 1  and testworld then table.insert(picked,v) end
      end
      elseif self.Weapon == 'PHYSGUN' then
        if !v:IsPlayer() then 
          if v.IsZetaProp then table.insert(picked,v) end
          if allowphysgunzeta == 1 and v:GetClass() == 'npc_zetaplayer' then
            table.insert(picked,v)
          end
        end

        

        if GetConVar('zetaplayer_allowphysgunplayers'):GetInt() == 1 and v:IsPlayer() then
          table.insert(picked,v)
        end




        if !v:IsPlayer() and v:GetClass() != 'npc_zetaplayer' then
          if allowphysgunnonworld == 1 and !testworld then table.insert(picked,v) end
          if allowphysgungunworld == 1 and testworld then table.insert(picked,v) end
        end

      end
    end

  end
  return picked
end

function ENT:Face2(uniquename,runtimes,pos,rate)

  local isent = false
  local ent
  if isentity(pos) then
    ent = pos
    isent = true
  end
  self:RemoveThinkFunction(uniquename)
  self:CreateThinkFunction(uniquename, 0, runtimes, function()
    if isent and !IsValid(ent) or isent and !IsValid(pos) then return "failed" end

    if IsValid(ent) then
      pos = ent:GetPos()
      
    end

    local towards = (pos-self:GetPos()):Angle()[2]
    local add = 0
    if self.IsMoving then 
      add = 10
    else
      add = 0
    end

    local approach = math.ApproachAngle(self:GetAngles()[2],towards,(rate+add))
    self:SetAngles(Angle(0,approach,0))
  end)
end

function ENT:LookAt2(uniquename,runtimes,pos)
  local isent = false
  local target
  if isentity(pos) then
    target = pos
    isent = true
  end
  self:RemoveThinkFunction(uniquename)
  self:CreateThinkFunction(uniquename, 0, runtimes, function()
    if isent and !IsValid(target) or isent and !IsValid(pos) then return "failed" end
    timer.Create('zetalooktimeput'..self:EntIndex(),3,1,function()
      if !self:IsValid() then return end
      self:StopLooking()
      self:PrepareResetPose()
    end)

    if IsValid(target) then
      pos = !target:IsPlayer() and target:GetPos() + target:OBBCenter() or target:IsPlayer() and target:EyePos()
    end
    local aimangle = ( pos - self:GetAttachmentPoint("eyes").Pos ):Angle()

    local loca = self:WorldToLocalAngles(aimangle)
    local approachy = zetamath.ApproachAngle(self:GetPoseParameter('head_yaw') or 0,loca[2],6)
    local approachp = zetamath.ApproachAngle(self:GetPoseParameter('head_pitch') or 0,loca[1],6)

    local approachaimy = zetamath.ApproachAngle(self:GetPoseParameter('aim_yaw') or 0,loca[2],6)
    local approachaimp = zetamath.ApproachAngle(self:GetPoseParameter('aim_pitch') or 0,loca[1],6)




    self:SetPoseParameter('head_yaw',approachy)
    self:SetPoseParameter('head_pitch',approachp)

    self:SetPoseParameter('aim_yaw',approachaimy)
    self:SetPoseParameter('aim_pitch',approachaimp)
 
  
  end)
end


function ENT:LookAt(ent_pos,posetype,time)
timer.Remove('zetaresetpose'..self:EntIndex())
timer.Remove('zetalooktimeput'..self:EntIndex())
if time then
  timer.Create('zetalooktimeput'..self:EntIndex(),time,1,function()
    if !self:IsValid() then return end
    self:StopLooking()
    self:PrepareResetPose()
  end)
end
if type(ent_pos) == 'Entity' or type(ent_pos) == 'Player' or type(ent_pos) == 'NPC' then
  local aimangle

  timer.Create('zetalookat'..self:EntIndex(),0,0,function()
  if !self:IsValid() or !ent_pos:IsValid()  then timer.Remove('zetalookat'..self:EntIndex()) return end




    if type(ent_pos) == 'Player' then
      if !self:IsValid() or !ent_pos:IsValid()  then timer.Remove('zetalookat'..self:EntIndex()) return end
      aimangle = ( ent_pos:EyePos() - self:GetAttachmentPoint("eyes").Pos ):Angle()
    else
      if !self:IsValid() or !ent_pos:IsValid()  then timer.Remove('zetalookat'..self:EntIndex()) return end
      aimangle = ( ent_pos:GetPos()+ent_pos:OBBCenter() - self:GetAttachmentPoint("eyes").Pos ):Angle()
    end


    local loca = self:WorldToLocalAngles(aimangle)
    local approachy = zetamath.ApproachAngle(self:GetPoseParameter('head_yaw') or 0,loca[2],6)
    local approachp = zetamath.ApproachAngle(self:GetPoseParameter('head_pitch') or 0,loca[1],6)

    local approachaimy = zetamath.ApproachAngle(self:GetPoseParameter('aim_yaw') or 0,loca[2],6)
    local approachaimp = zetamath.ApproachAngle(self:GetPoseParameter('aim_pitch') or 0,loca[1],6)



    if posetype == 'both' or posetype == 'head' then
      self:SetPoseParameter('head_yaw',approachy)
      self:SetPoseParameter('head_pitch',approachp)
    end

    if posetype == 'both' or posetype == 'body' then
      self:SetPoseParameter('aim_yaw',approachaimy)
      self:SetPoseParameter('aim_pitch',approachaimp)
    end
  end)

elseif type(ent_pos) == 'Vector' then
  timer.Create('zetalookat'..self:EntIndex(),0,0,function()
  if !self:IsValid() then timer.Remove('zetalookat'..self:EntIndex()) return end


  aimangle = ( ent_pos - self:GetAttachmentPoint("eyes").Pos ):Angle()


  local loca = self:WorldToLocalAngles(aimangle)


  local approachy = zetamath.ApproachAngle(self:GetPoseParameter('head_yaw') or 0,loca[2],4)
  local approachp = zetamath.ApproachAngle(self:GetPoseParameter('head_pitch') or 0,loca[1],4)

  local approachaimy = zetamath.ApproachAngle(self:GetPoseParameter('aim_yaw') or 0,loca[2],4)
  local approachaimp = zetamath.ApproachAngle(self:GetPoseParameter('aim_pitch') or 0,loca[1],4)


  if posetype == 'both' then
    self:SetPoseParameter('head_yaw',approachy)
    self:SetPoseParameter('head_pitch',approachp)
    self:SetPoseParameter('aim_yaw',approachaimy)
    self:SetPoseParameter('aim_pitch',approachaimp)
  end

  if posetype == 'head' then
    self:SetPoseParameter('head_yaw',approachy)
    self:SetPoseParameter('head_pitch',approachp)    
  end

  if posetype == 'body' then
    self:SetPoseParameter('aim_yaw',approachaimy)
    self:SetPoseParameter('aim_pitch',approachaimp)    
  end





  end)
end
end

function ENT:StopLooking()
  timer.Remove('zetalookat'..self:EntIndex())
  timer.Remove('zetalooktimeput'..self:EntIndex())
  self:PrepareResetPose()
end

function ENT:ResetPose()
  self.IsResettingPose = true
  timer.Create('zetaresetpose'..self:EntIndex(),0,0,function()
    if !self:IsValid() then timer.Remove('zetaresetpose'..self:EntIndex()) return end

    local headposeyaw = self:GetPoseParameter('head_yaw')
    local headposepitch = self:GetPoseParameter('head_pitch')
    local aimposeyaw = self:GetPoseParameter('aim_yaw')
    local aimposepitch = self:GetPoseParameter('aim_pitch')


    local approachy = zetamath.ApproachAngle(self:GetPoseParameter('head_yaw') or 0,0,3)
    local approachp = zetamath.ApproachAngle(self:GetPoseParameter('head_pitch') or 0,0,3)
    local aimapproachy = zetamath.ApproachAngle(self:GetPoseParameter('aim_yaw') or 0,0,3)
    local aimapproachp = zetamath.ApproachAngle(self:GetPoseParameter('aim_pitch') or 0,0,3)
    self:SetPoseParameter('head_yaw',approachy)
    self:SetPoseParameter('head_pitch',approachp)
    self:SetPoseParameter('aim_yaw',aimapproachy)
    self:SetPoseParameter('aim_pitch',aimapproachp)

      if headposeyaw == 0 and headposepitch == 0 and aimposeyaw == 0 and aimposepitch == 0 then
        timer.Remove('zetaresetpose'..self:EntIndex())
        self.IsResettingPose = false
      end
  end)
end


function ENT:LookAtRandomEnt(radius,time)
  
  local Find = ents.FindInSphere(self:GetPos(),radius)
  local ent = Find[zetamath.random(#Find)]

    if ent and ent:IsValid() then
      self:LookAt(ent,'head',time)
    end
  
end


function ENT:FaceTick(target,serverticks)
  local pos
  timer.Remove('zetafacemeleetarget'..self:EntIndex())
  timer.Create('zetafacemeleetarget'..self:EntIndex(),0,serverticks,function() 
    if type(target) != 'Vector' and !target:IsValid() then return end
    if !self:IsValid() then timer.Remove('zetafacemeleetarget'..self:EntIndex()) return end

    if type(target) != 'Vector' then
      pos = target:GetPos()
    else
      pos = target
    end

     self.loco:FaceTowards(pos) 
  end)
end

function ENT:StartUniversalTimer(min,max)
  timer.Create('zetaloopedrandom'..self:EntIndex(),zetamath.random(min,max),1,function()
    if !IsValid(self) then return end
    if GetConVar('zetaplayer_disabled'):GetInt() == 0 then 
      self:ChooseNextUniversalAction()
    end
    self:StartUniversalTimer(min,max)
  end)
end


function timer_StartRandom(name,min,max,func)

  timer.Create(name,zetamath.random(min,max),1,function()
    timer_StartRandom(name,min,max,func)
    func()
  end)

end



function ENT:Distance(ent)
  if ent:IsValid() then 
  return self:GetPos():Distance(ent:GetPos())
end
end


function ENT:LookAtTick(ent_pos,posetype,tick)
  local times = 0
  
  end



  function ENT:PrepareResetPose()
   
    if timer.Exists('zetaresetposetimer'..self:EntIndex()) then 
      timer.Remove('zetaresetposetimer'..self:EntIndex())
    end
    timer.Create('zetaresetposetimer'..self:EntIndex(),5,1,function()
      if !self:IsValid() then return end
      self:ResetPose()
  end)
  end

  function ENT:ApproachPhysgunDist(targetdist)
    timer.Create('zetaapproachnewdist'..self:EntIndex(),0,0,function()
      if !self:IsValid() then timer.Remove('zetaapproachnewdist'..self:EntIndex()) return end
      local approach = zetamath.Approach( self.PhysgunBeamDistance, targetdist, 10 )
      self.PhysgunBeamDistance = approach
      if self.PhysgunBeamDistance == targetdist then
        timer.Remove('zetaapproachnewdist'..self:EntIndex())
      end
    end)
  end



  
function ENT:LookAtTick(any,posetype,tick,pitchonly)
  local Enttype = type(any)
  local pos
  local approachy
  local approachp
  local aimangle
  timer.Remove('zetalookat'..self:EntIndex())
  timer.Create('zetalookat'..self:EntIndex(),0,tick,function()
    if Enttype != 'Vector' and !IsValid(any) then timer.Remove('zetalookat'..self:EntIndex()) return end
    if !self:IsValid() then timer.Remove('zetalookat'..self:EntIndex()) return end
    if Enttype != 'Vector' then
      pos = any:GetPos()+any:OBBCenter()
    else
      pos = any
    end

    if Enttype != Vector then

      if IsValid(any) and any:GetClass() == 'npc_zetaplayer' then
        local lookup = any:LookupAttachment('anim_attachment_RH')
        if lookup != 0 then
          local attachment = any:GetAttachment(lookup)
          pos = attachment.Pos
        end
      end
    end
  

       aimangle = ( pos - self:GetAttachmentPoint("eyes").Pos ):Angle()

    local loca = self:WorldToLocalAngles(aimangle)
    if !self:IsValid() then timer.Remove('zetalookat'..self:EntIndex()) return end
    if !pitchonly then
      approachy = zetamath.ApproachAngle(self:GetPoseParameter('head_yaw'),loca[2],6)
    else
      approachy = zetamath.ApproachAngle(self:GetPoseParameter('head_yaw'),0,4)
    end
     approachp = zetamath.ApproachAngle(self:GetPoseParameter('head_pitch'),loca[1],6)
  
  
    if posetype == 'both' then
      if !self:IsValid() then timer.Remove('zetalookat'..self:EntIndex()) return end
        
        self:SetPoseParameter('head_yaw',approachy)
        self:SetPoseParameter('aim_yaw',approachy)

      self:SetPoseParameter('head_pitch',approachp)
      self:SetPoseParameter('aim_pitch',approachp)
    end
  
    if posetype == 'head' then

        self:SetPoseParameter('head_yaw',approachy)

      self:SetPoseParameter('head_pitch',approachp)
    end
  
    if posetype == 'body' then

        self:SetPoseParameter('aim_yaw',approachy)

      self:SetPoseParameter('aim_pitch',approachp)
    end
    self:PrepareResetPose()
  end)
end

--[[zetaplayer_allowpistol
zetaplayer_allowar2
zetaplayer_allowshotgun
zetaplayer_allowsmg
zetaplayer_allowrpg
zetaplayer_allowcrowbar
zetaplayer_allowstunstick
zetaplayer_allowrevolver
zetaplayer_allowtoolgun
zetaplayer_allowphysgun ]]



function ENT:CanUseWeapon(weapon)
  return _ZetaWeaponConVars and weapon and _ZetaWeaponConVars[weapon][1] and _ZetaWeaponConVars[weapon][1]:GetBool() or false
end

function ENT:Disposition( ent )
  return D_NU
end

function ENT:AddEntityRelationship()
end

function ENT:GetUseableWeapon()
  local useableWeapons = {'NONE'}
  for k, v in pairs(_ZetaWeaponConVars) do
      if v[1]:GetBool() == true then useableWeapons[#useableWeapons+1] = k end
  end
  if self.FavouriteWeapon and self:CanUseWeapon(self.FavouriteWeapon) then
      for i = 1, #useableWeapons do useableWeapons[#useableWeapons+1] = self.FavouriteWeapon end
  end
  if self.IsAdmin and GetConVar('zetaplayer_allowphysgun'):GetBool() then
      for i = 1, #useableWeapons do useableWeapons[#useableWeapons+1] = "PHYSGUN" end
  end
  return useableWeapons
end

function ENT:GetUseableLethalWeapon()
  local useableWeapons = {}
  for k, v in pairs(_ZetaWeaponConVars) do
      if v[1]:GetBool() == true and (!isbool(v[2]) and v[2]:GetBool() or v[2] == true) then useableWeapons[#useableWeapons+1] = k end
  end
  if self.FavouriteWeapon and self:CanUseWeapon(self.FavouriteWeapon) and _ZetaWeaponConVars[self.FavouriteWeapon][2] then
    for i = 1, #useableWeapons do useableWeapons[#useableWeapons+1] = self.FavouriteWeapon end
  end
  if !useableWeapons or #useableWeapons <= 0 then useableWeapons = {"NONE"} end

  return useableWeapons
end

function ENT:SetModelColor(color)
  net.Start('zeta_setplayercolor',true)
  net.WriteEntity(self)
  net.WriteColor(color)
  net.Broadcast()
end

local canSeeTraceTbl = {}
function ENT:CanSee(ent, startPos, ignoreEnt)
    if !IsValid(ent) then return end
    local startPos = startPos or self:GetCenteroid()
    local entPos = ent:GetCenteroid()
    if self:GetRangeSquaredTo(entPos) > (64*64) and self:IsLineBlockedBySmoke(self:GetCenteroid(), entPos) then return false end

    local filter = {self}
    if IsValid(ignoreEnt) then filter[#filter+1] = ignoreEnt end

    canSeeTraceTbl.start = startPos
    canSeeTraceTbl.endpos = entPos
    canSeeTraceTbl.filter = filter

    local lostest = trace.TraceLine(canSeeTraceTbl)
    return (lostest.Entity == ent)
end

function ENT:CanSeePosition(pos, startPos, ignoreEnt)
  local startPos = startPos or self:GetCenteroid()
  if startPos:DistToSqr(pos) > (64*64) and self:IsLineBlockedBySmoke(startPos, pos) then return false end

  local filter = {self}
  if IsValid(ignoreEnt) then filter[#filter+1] = ignoreEnt end
  
  canSeeTraceTbl.start = startPos
  canSeeTraceTbl.endpos = pos
  canSeeTraceTbl.filter = filter
      
  local lostest = trace.TraceLine(canSeeTraceTbl)
  return (lostest.Fraction >= 1.0)
end

local SmokeGrenadeRadius = 155
function ENT:IsLineBlockedBySmoke(from, to)
  local totalSmokedLength = 0.0
  local smokeRadiusSq = (SmokeGrenadeRadius * SmokeGrenadeRadius)

  for _, v in pairs(_ZETASMOKEGRENADES) do
      local flLengthAdd = self:CheckTotalSmokedLength(smokeRadiusSq, v, from, to)
      if flLengthAdd == -1 then return true end
      totalSmokedLength = totalSmokedLength + flLengthAdd
  end

  local maxSmokedLength = 0.7 * SmokeGrenadeRadius
  return (totalSmokedLength > maxSmokedLength)
end



function ENT:CheckTotalSmokedLength(smokeRadiusSq, vecGrenadePos, from, to)
  local sightDir = (to - from)
  local sightLength = sightDir:Length()
  sightDir:Normalize()

  local smokeOrigin = vecGrenadePos + Vector(0, 0, 60)
  if from:DistToSqr(smokeOrigin) < smokeRadiusSq or to:DistToSqr(smokeOrigin) < smokeRadiusSq then return -1 end

  local toGrenade = (smokeOrigin - from)
  local alongDist = toGrenade:Dot(sightDir)

  local close = (alongDist < 0 and from or (alongDist >= sightLength and to or (from + sightDir * alongDist)))
  local lengthSq = smokeOrigin:DistToSqr(close)
  if lengthSq < smokeRadiusSq then
      local smokedLength = 2.0 * math.sqrt(smokeRadiusSq - lengthSq)
      return smokedLength
  end
  return 0
end

function ENT:GetBonePosAngs(index)
  local pos,angle = self:GetBonePosition(index)
  if pos and pos == self:GetPos() then
    local matrix = self:GetBoneMatrix(index)
    if ismatrix(matrix) and matrix != nil then
      pos = matrix:GetTranslation()
    else
      return {Pos = (self:GetPos()+self:OBBCenter()),Ang = self:GetForward():Angle()}
    end
  elseif !pos then
    pos = self:GetPos()+self:OBBCenter()
  end
  return {Pos = pos,Ang = angle}
end

function ENT:GetAttachmentPoint(pointtype)

  if pointtype == "hand" then
    if self.IsMingebag then

      return {Pos = (self:GetPos()+Vector(0,0,30))-self:GetForward()*7,Ang = self:GetForward():Angle()+Angle(0,0,180)}
    end

    local lookup = self:LookupAttachment('anim_attachment_RH')

    if lookup == 0 then
        local bone = self:LookupBone("ValveBiped.Bip01_R_Hand")
      
        if !bone then
          return {Pos = (self:GetPos()+self:OBBCenter()),Ang = self:GetForward():Angle()}
        else
          if isnumber(bone) then
            return self:GetBonePosAngs(bone)
          else
            return {Pos = (self:GetPos()+self:OBBCenter()),Ang = self:GetForward():Angle()}
          end
        end
        
    else

      return self:GetAttachment(lookup)
    end

  elseif pointtype == "eyes" then
    
    local lookup = self:LookupAttachment('eyes')

    if lookup == 0 then
        return {Pos = self:GetPos()+self:OBBCenter()+Vector(0,0,5),Ang = self:GetForward():Angle()+Angle(20,0,0)}
    else
      return self:GetAttachment(lookup)
    end

  end

end

function ENT:LookAtTickRPG(any,posetype,tick,pitchonly)
  local Enttype = type(any)
  local pos
  local approachy
  local approachp
  timer.Remove('zetalookat'..self:EntIndex())
  timer.Create('zetalookat'..self:EntIndex(),0,tick,function()
    if Enttype != 'Vector' and !any:IsValid() then timer.Remove('zetalookat'..self:EntIndex()) return end
    if !self:IsValid() then timer.Remove('zetalookat'..self:EntIndex()) return end
    if Enttype != 'Vector' then
      pos = any:GetPos()
    else
      pos = any
    end
  

    local aimangle = ( pos - self:GetAttachmentPoint("eyes").Pos ):Angle()
    local loca = self:WorldToLocalAngles(aimangle)
    if !self:IsValid() then timer.Remove('zetalookat'..self:EntIndex()) return end
    if !pitchonly then
      approachy = zetamath.ApproachAngle(self:GetPoseParameter('head_yaw'),loca[2],6)
    else
      approachy = zetamath.ApproachAngle(self:GetPoseParameter('head_yaw'),0,4)
    end
     approachp = zetamath.ApproachAngle(self:GetPoseParameter('head_pitch'),loca[1],6)
  
  
    if posetype == 'both' then
      if !self:IsValid() then timer.Remove('zetalookat'..self:EntIndex()) return end
        
        self:SetPoseParameter('head_yaw',approachy)
        self:SetPoseParameter('aim_yaw',approachy)

      self:SetPoseParameter('head_pitch',approachp)
      self:SetPoseParameter('aim_pitch',approachp)
    end
  
    if posetype == 'head' then

        self:SetPoseParameter('head_yaw',approachy)

      self:SetPoseParameter('head_pitch',approachp)
    end
  
    if posetype == 'body' then

        self:SetPoseParameter('aim_yaw',approachy)

      self:SetPoseParameter('aim_pitch',approachp)
    end
    self:PrepareResetPose()
  end)
end



function ENT:GetRealTeamIndex()
  return (_ZETATEAMS[self.zetaTeam] or 0)
end

function ENT:DeathFunction(dmginfo)
  local attacker = dmginfo:GetAttacker()
  
  if !self.SilenceDeath then
    if zetamath.random(1,100) < self.TextChance and (attacker:IsPlayer() or attacker.IsZetaPlayer) and GetConVar("zetaplayer_allowtextchat"):GetBool() then
        self.text_keyent = (attacker.IsZetaPlayer and attacker.zetaname or attacker:GetName())
        self:TypeMessage("death")
    elseif GetConVar('zetaplayer_allowdeathvoice'):GetBool() then
        self:PlayDeathSound()
    end
  end

  if IsValid(attacker) then       
      if SERVER then
          local killIcon = nil
          local inflictor = dmginfo:GetInflictor()    
          local data = {
              attacker = "#"..attacker:GetClass(),
              attackerteam = -1,
              inflictor = IsValid(inflictor) and inflictor:GetClass() or " ",
              victim = self.zetaname,
              victimteam = self:GetRealTeamIndex()
          }
          
          if attacker == self then
              data.attacker = self.suicidereason or " "
              data.inflictor = " "
          elseif attacker:IsPlayer() or attacker:IsNPC() then
              data.attacker = (attacker:IsPlayer() and attacker:Name() or "#"..attacker:GetClass())
              data.attackerteam = (attacker:IsPlayer() and attacker:Team() or -1)
              data.inflictor = ((inflictor == attacker and IsValid(attacker:GetActiveWeapon())) and attacker:GetActiveWeapon():GetClass() or (IsValid(inflictor) and inflictor:GetClass() or " "))
          elseif attacker.IsZetaC4 or IsValid(inflictor) and inflictor.IsZetaC4 then
              local attackteamname = ((IsValid(attacker) and attacker.IsZetaPlayer and attacker.zetaTeam) and " {"..attacker.zetaTeam.."}" or " ")
              data.attacker = (attacker.IsZetaPlayer and attacker.zetaname..attackteamname or (attacker.IsZetaC4 and "C4"))
              data.attackerteam = (IsValid(attacker) and attacker.IsZetaPlayer and attacker:GetRealTeamIndex() or 0)
              data.inflictor = " "
              data.prettyprint = ((IsValid(attacker) and attacker.IsZetaPlayer) and "C4" or nil) 
          elseif attacker.IsZetaPlayer then
              killIcon = _ZetaWeaponKillIcons[attacker.Weapon]
              data.attacker = attacker.zetaname
              data.attackerteam = attacker:GetRealTeamIndex()
              data.inflictor = killIcon or " "
              data.prettyprint = ((IsValid(inflictor) and inflictor:GetClass() == "prop_physics") and "Physics Prop" or attacker.PrettyPrintWeapon)
          end

          net.Start('zeta_addkillfeed', true)
              net.WriteString(util.TableToJSON(data))
              net.WriteBool(killIcon != nil)
          net.Broadcast()  
      end

      if GetConVar('zetaplayer_consolelog'):GetBool() then
          local logText = (self.KillReason or self.zetaname..' was killed by '..(attacker.IsZetaPlayer and attacker:GetNW2String('zeta_name','Zeta Player') or tostring(attacker)))
          MsgAll('ZETA: '..logText)
          if GetConVar("zetaplayer_showzetalogonscreen"):GetBool() then
              net.Start("zeta_sendonscreenlog", true)
                  net.WriteString(logText)
                  net.WriteColor(Color(255, 38, 38), false)
              net.Broadcast()
          end
      end
  end

  local wepEnt = self.WeaponENT
  if IsValid(wepEnt) then 
      wepEnt:SetParent()
      wepEnt:SetMaterial('null')
      timer.Simple(0.5, function()
          if !IsValid(wepEnt) then return end
          wepEnt:Remove()
      end)
  end
end

function ENT:FindNavAreas(pos,distance)
  local navs = navmesh.GetAllNavAreas()
  local validnavs = {}
  distance = distance or 1500
  for k,v in ipairs(navs) do
      local point = v:GetClosestPointOnArea(pos)
      if IsValid(v) and point:DistToSqr(pos) < (distance*distance) then
          table.insert(validnavs,v)
      end
  end
  return validnavs
end


function ENT:FindRandomPosition(dist)
  local areas = self:FindNavAreas(self:GetPos(),dist)
  for k,v in RandomPairs(areas) do
  if v and v:IsValid() and !v:IsUnderwater() then
    if GetConVar("zetaplayer_ignoresmallnavareas"):GetInt() == 1 then
    if v:GetSizeX() > 75 or v:GetSizeY() > 75 then
      return v:GetRandomPoint()
    end
    else
    return v:GetRandomPoint()
    end
  end
end
return self:GetPos()+VectorRand(-dist,dist)
end


function ENT:FindRandomPositionNear(pos,dist)
  local areas = self:FindNavAreas(pos,dist)
  for k,v in RandomPairs(areas) do
  if v and v:IsValid() and !v:IsUnderwater() then
    if GetConVar("zetaplayer_ignoresmallnavareas"):GetInt() == 1 then
    if v:GetSizeX() > 75 or v:GetSizeY() > 75 then
      return v:GetRandomPoint()
    end
    else
    return v:GetRandomPoint()
    end
  end
end
local vec = self:FindRandomPosition(GetConVar('zetaplayer_wanderdistance'):GetInt())
return vec
end



function ENT:GetTeamMembers(ZetaTeam)
  local members = {}
  local entities = ents.FindByClass('npc_zetaplayer')
  local spawners = ents.FindByClass('zeta_zetaplayerspawner')
  local players = player.GetAll()

  for k,ply in ipairs(players) do
    if GetConVar('zetaplayer_playerteam'):GetString() != '' and GetConVar('zetaplayer_playerteam'):GetString() == ZetaTeam then
      table.insert(members,ply)
    end
  end

  for k,zeta in ipairs(entities) do
    if zeta != self and zeta.zetaTeam == ZetaTeam and !zeta.ZetaSpawnerID then
      table.insert(members,zeta)
    end
  end

  for k,spawner in ipairs(spawners) do
    if spawner != self.Spawner and spawner.zetaTeam == ZetaTeam then
      table.insert(members,spawner)
    end
  end

  return members
end

function ENT:InteraWait()


  while true do
    if !IsValid(self.SitAdmin) then self:StopFacing() self:SetState("idle") return end
    
    if self.AllowResponse then break end
    
    coroutine.yield()
  end

end

function ENT:ConverseWait()


  while true do
    if !IsValid(self.ConversePartner) then self:SetState("idle") return end
    
    if self.AllowResponse and !self.IsSpeaking then self.AllowResponse = false break end
    
    coroutine.yield()
  end

end

function ENT:Name()
  return self.zetaname
end


function ENT:IsInTeam(ent)
    if !self.zetaTeam then return false end
    

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



function ENT:GetPlayerRelation(npc)
  if !isfunction(npc.Disposition) then return end
  local players = player.GetAll()
  local ply = players[zetamath.random(#players)]
  if !IsValid(ply) then return D_HT end
  local disp = npc:Disposition(ply)
  return disp
end

function ENT:Wait(seconds)
  --print(debug.traceback())
	local endtime = CurTime() + seconds
	while ( true ) do

		if ( endtime < CurTime() ) then break  end

		coroutine.yield()

	end
	  
end


function ENT:GetNormalTo(pos1,pos2)
  local point = (pos1-pos2):Angle()
  return point:Forward()
end

function ENT:DisconnectfromGame()
  self:CancelMove()
  self:SetState("Leaving")

  local addtime = 0

  if GetConVar("zetaplayer_allowtextchat"):GetBool() and GetConVar("zetaplayer_disconnectlines"):GetBool() and  math.random(1,2) == 1 then 
    addtime = self:TypeMessage("disconnect")
  end

  timer.Simple( (zetamath.Rand(1.0,3.0)+addtime) ,function()
    if !IsValid(self) then return end
    if self.PlayingPoker then self:SetState("sitting") return end
    local r,g,b = self:GetColorByRank()
    net.Start("zeta_disconnectmessage",true)
    net.WriteString(self.zetaname)
    net.WriteColor(Color(r,g,b),false)
    net.Broadcast()
    self:Remove()
  end)
end

function ENT:AwardAchievement(award)
  self:EmitSound("zetaplayer/misc/achievement_earned.wav")

  local name = self.zetaname
  net.Start("zeta_achievement",true)
      net.WriteString(name)
      net.WriteString(award)
      net.WriteColor(Color(self:GetColorByRank()))
  net.Broadcast()
end

function ENT:SetupAchievements()
  self.achievement_RemoveMax = math.random(1,500)
  self.achievement_Remove = 0

  self.achievement_CreatorMax = math.random(1,500)
  self.achievement_Creator = 0

  self.achievement_ProCreatorMax = math.random(1,100)
  self.achievement_ProCreator = 0

  self.achievement_PlayerKillerMax = math.random(1,500)
  self.achievement_PlayerKiller = 0

  self.achievement_BerserkerMax = math.random(1,500)
  self.achievement_Berserker = 0

  self.achievement_BallEaterMax = math.random(1,200)
  self.achievement_BallEater = 0

  self.achievement_earnedbloxwich = false

  timer.Simple(math.random(30,18000),function()
    if !IsValid(self) then return end
    self:AwardAchievement("One Day")
  end)

  timer.Simple(math.random(30,86400),function()
    if !IsValid(self) then return end
    self:AwardAchievement("One Week")
  end)

  timer.Simple(math.random(30,57600),function()
    if !IsValid(self) then return end
    self:AwardAchievement("Bad Coder")
  end)
  
  timer.Simple(math.random(30,172800),function()
    if !IsValid(self) then return end
    self:AwardAchievement("One Month")
  end)

  timer.Simple(math.random(30,720000),function()
    if !IsValid(self) then return end
    self:AwardAchievement("Addict")
  end)

  timer.Simple(math.random(30,14400),function()
    if !IsValid(self) then return end
    self:AwardAchievement("Half Marathon")
  end)
  timer.Simple(math.random(30,28800),function()
    if !IsValid(self) then return end
    self:AwardAchievement("Marathon")
  end)

  if math.random(1,500) == 1 then
    self:AwardAchievement("Play Multiplayer")
  end

  if math.random(1,1000) == 1 then
    self:AwardAchievement("Startup Millenium")
  end

  if math.random(1,500) == 1 then
    self:AwardAchievement("Map Loader")
  end
end

function ENT:GetCurrentVoiceSNDLEVEL()
  if GetConVar("zetaplayer_globalvoicechat"):GetInt() == 1 then
    return 0
  else
    return 75
  end
end

--[[ function ENT:CanUseDSPEffect()
  if GetConVar("zetaplayer_limitdsp"):GetInt() == 1 then
    local count = 0
    local zetas = ents.FindByClass("npc_zetaplayer")
    for k,v in ipairs(zetas) do
      if v.VoiceDSP != 0 then
        count = count + 1
      end
    end
    if count >= GetConVar("zetaplayer_dsplimit"):GetInt() then
      return false
    elseif count < GetConVar("zetaplayer_dsplimit"):GetInt() then
      --print("Limit DSP: true ",count)
      return true
    end
  else
    return true
  end
end ]]


-- Community Contribute v v v v
function ENT:FindVoiceChatAvatar()
  local UseSERVERCACHE = GetConVar("zetaplayer_useservercacheddata"):GetBool()
  local avatars = {}
  local filescustom, dirscustom
  if UseSERVERCACHE then
    filescustom, dirscustom = _SERVERPFPS,_SERVERPFPDIRS
  else
    filescustom, dirscustom = file.Find("zetaplayerdata/custom_avatars/*","DATA","nameasc")
  end
  if game.SinglePlayer() then
      for k,v in ipairs(filescustom) do
          if string.Right(v,4) == '.png' or string.Right(v,4) == '.jpg' then
              local pfpPath = "../data/zetaplayerdata/custom_avatars/"..v
              if GetConVar('zetaplayer_norepeatingpfps'):GetInt() == 1 then
                  local canUsePfp = true
                  for _,j in ipairs(ents.FindByClass('npc_zetaplayer')) do
                      if j.ProfilePicture and j.ProfilePicture == pfpPath then canUsePfp = false break end
                  end
                  if !canUsePfp then continue end
              end
      
              table.insert(avatars,pfpPath)
          end
      end
  end
  return avatars
end
--[[ 
function ENT:FindVoiceChatAvatar()  -- My old code
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
end ]]

function ENT:UseGestures()

  local gestures = {"gesture_becon","gesture_bow","gesture_disagree","gesture_item_drop","gesture_item_give","gesture_item_place","gesture_item_throw","gesture_salute","gesture_signal_forward","gesture_signal_group","gesture_signal_halt","gesture_wave"}
  local selected = gestures[zetamath.random(#gestures)]
  local seq,dur = self:LookupSequence(selected)
  if seq != -1 then
    self:AddGestureSequence(seq,true)
  end

end

function ENT:GetActiveWeapon()
  return NULL
end

function ENT:IsSprinting()
  return (self.loco:GetVelocity():Length() >= 225)
end

function ENT:Crouching()
  return (self.IsCrouching)
end




function ENT:ZetaRequestMedia(title, duration, url)


	local function CreateMedia( title, duration, url, startTime )
		local media = MediaPlayer.GetMediaForUrl( url )
		media._metadata = {
			title = title,
			duration = duration
		}
		media._OwnerName = self.zetaname
		media._OwnerSteamID = Entity(1):SteamID()
		media:StartTime( startTime or RealTime() )
		return media
	end

    local media = CreateMedia(title, duration, url)

    local mp = self.MediaPlayer:GetMediaPlayer()

    mp:SetPlayerState( MP_STATE_PLAYING )

--[[     if !mp:IsPlaying() then
		mp:SetMedia( media )
        mp:SendMedia( media )
    else

    end ]]



        mp:SetMedia( media )
        mp:SendMedia( media )
		mp:QueueUpdated()

		mp:BroadcastUpdate()

end


function ENT:CreateThinkFunction(name, thinkTime, runCount, funcRun)
	if self.ThinkFunctions[name] != nil then return end
	self.ThinkFunctions[name] = {thinkTime, runCount, funcRun}
	self.ThinkFunctionCount = self.ThinkFunctionCount + 1
end

function ENT:ThinkFunctionExists(name)
	return self.ThinkFunctions[name] != nil
end

function ENT:RemoveThinkFunction(name)
	if !self.ThinkFunctions[name] then return end
	self.ThinkFunctions[name] = nil
	self.ThinkFunctionCount = self.ThinkFunctionCount - 1
end

function ENT:DanceNearEnt(ent)

      self.MusicEnt = ent

      self:CancelMove()
      self:SetState('dancing')
      self:FaceTick(ent:GetPos(),200)
      self.SoundPos = ent:GetPos()
      self.DanceWaittime = zetamath.Rand(0.5,1.5)
      self.CanDance = false 
      timer.Simple(30,function()
          if IsValid(self) then
              self.CanDance = true
          end
      end)
end

function ENT:InitializeHooks()

    local entIndex = self:EntIndex()


    hook.Add("OnPhysgunPickup", 'ZetaPickupByPlayer'..entIndex, function(ply,ent)        
      if !IsValid(self) then hook.Remove("OnPhysgunPickup",'ZetaPickupByPlayer'..entIndex) return end
      if ent == self then
          self.IsPhysgunCarried = true
      end
  end)

  hook.Add("PhysgunDrop", 'ZetaDroppedByPlayer'..entIndex, function(ply,ent)        
      if !IsValid(self) then hook.Remove("PhysgunDrop",'ZetaDroppedByPlayer'..entIndex) return end
      if ent == self then
          self.IsPhysgunCarried = false
          self.FallHeight = Vector(0,0,self:GetPos().z)
      end
  end)

  local armorCvar = 'zetaplayer_zetaarmor'
  if self.IsNatural then armorCvar = 'zetaplayer_naturalzetaarmor' end

  local armorNum = GetConVar(armorCvar):GetInt()
  self.CurrentArmor = armorNum
  self.MaxArmor = math.max(100, armorNum)

  hook.Add("EntityTakeDamage",'ZetaDamageHook'..entIndex,function(ent,dmginfo)
      if !IsValid(self) then hook.Remove("EntityTakeDamage",'ZetaDamageHook'..entIndex) return end
      
      local attacker = dmginfo:GetAttacker()

      if ent == self and attacker != self then
        if !GetConVar("zetaplayer_enablefriendlyfire"):GetBool() and self:IsInTeam(attacker) then
          return true
        end

        if GetConVar("zetaplayer_nohurtfriends"):GetBool() and self:IsFriendswith(attacker) then
          return true
        end
      end

      
      if attacker == self and ent:IsPlayer() and self:IsFriendswith(ent) and GetConVar("zetaplayer_nohurtfriends"):GetBool() then
        return true
      end

      if ent == self then
          local wepData = _ZetaWeaponDataTable[self.Weapon]
          if IsValid(self.WeaponENT) and istable(wepData) and isfunction(wepData.onDamageCallback) then
              wepData:onDamageCallback(self, self.WeaponENT, dmginfo)
          elseif IsValid(self.WeaponENT) and istable(wepData) and isstring(wepData.onDamageCallback) then
            local func = CompileString( wepData.onDamageCallback, "[OnDamaged] Custom Weapon " .. self.PrettyPrintWeapon )
            func( self, self.WeaponENT, dmginfo )
          end

          if dmginfo:IsDamageType(DMG_POISON) then
              local lastHpPoison = self:Health()+5
              local timerName = "zeta_poisondmg_restorehp_"..entIndex
              if !timer.Exists(timerName) then
                  timer.Create(timerName, 2, math.ceil(lastHpPoison/10), function() 
                      if !IsValid(self) then timer.Remove(timerName) return end
                      self:SetHealth(math.min(self:Health() + 10, lastHpPoison))
                      if (self:Health() + 10) >= lastHpPoison then timer.Remove(timerName) end 
                  end)
              else
                  timer.Adjust(timerName, 2, timer.RepsLeft(timerName)+(lastHpPoison/10), nil)
              end
          end

          if IsValid(attacker) and attacker:GetClass() == 'npc_antlionguard' then
              attacker.Zeta_NextExtraDamageT = attacker.Zeta_NextExtraDamageT or CurTime()
              if CurTime() >= attacker.Zeta_NextExtraDamageT then
                  dmginfo:SetDamage(GetConVar("sk_antlionguard_dmg_charge"):GetFloat())
                  attacker.Zeta_NextExtraDamageT = CurTime() + 0.1
              else
                  dmginfo:SetDamage(0)
              end
          end

          if self.CurrentArmor <= 0 then return end
          if dmginfo:IsDamageType(bit.bor(DMG_DROWN,DMG_POISON,DMG_FALL,DMG_RADIATION)) then return end                   

          local flDmg = dmginfo:GetDamage()
          local flRatio = ((100-GetConVar('zetaplayer_armorabsorbpercent'):GetInt())/100)
          local flNew = flDmg * flRatio
          local flBonus = (dmginfo:IsExplosionDamage() and 2.0 or 1.0)
          local flArmor = (flDmg - flNew) * flBonus 
          if flArmor < 1.0 then flArmor = 1.0 end

          if flArmor > self.CurrentArmor then
              flArmor = self.CurrentArmor
              flArmor = flArmor * (flBonus / 1.0)
              flNew = flDmg - flArmor
              self.CurrentArmor = 0
          else
              self.CurrentArmor = self.CurrentArmor - flArmor
              if flArmor == flDmg then return true end
          end

          flDmg = flNew
          dmginfo:SetDamage(flDmg)
      end
          
      if !IsValid(attacker) then return end
      if ent == self and attacker == self then return end
      if !ent:IsNPC() and !ent:IsNextBot() and !ent:IsPlayer() then return end
      if !attacker:IsNPC() and !attacker:IsNextBot() and !attacker:IsPlayer() then return end
      if attacker == self then return end
      if GetConVar('zetaplayer_ignorezetas'):GetBool() and attacker:GetClass() == "npc_zetaplayer" then return end
      if attacker:IsPlayer() and GetConVar('ai_ignoreplayers'):GetBool() then return end
      if self:IsInTeam(attacker) then return end
      if self:GetState() == "chaseranged" or self:GetState() == "chasemelee" or self:GetState() == 'panic' then return end
      if self.PlayingPoker then return end
      local friendattacker = self:GetFriendByID(attacker:GetCreationID())

      if IsValid(friendattacker) and attacker == friendattacker and !self:IsFriendswith(ent) then
          if !self:CanSee(ent) then DebugText("Was going to assist my friend but I can't see the target") return end
          DebugText("Going to assist my friend")
          if !self.HasLethalWeapon then
              self:ChooseLethalWeapon()
          end
          if !self.HasLethalWeapon or self.Weapon == 'NONE' then return end
          self.Delayattack = false
          self:CancelMove()
          self:SetEnemy(ent)
          self:SetState('chase'..(!self.HasMelee and 'ranged' or 'melee'))
      end

      if self:IsInTeam(ent) or self:GetFriendByID(ent:GetCreationID()) and attacker != ent and !self:IsFriendswith(attacker) then
          if !self:CanSee(ent)  then return end
          if !GetConVar('zetaplayer_allowdefendothers'):GetBool() then return end
          DebugText("Going to defend my friend")
          if !self.HasLethalWeapon then
              self:ChooseLethalWeapon()
          end
          if !self.HasLethalWeapon or self.Weapon == 'NONE' then return end
          if self.Weapon == 'NONE' then return end
          self.Delayattack = false
          self:CancelMove()
          self:SetEnemy(attacker)
          self:SetState('chase'..(!self.HasMelee and 'ranged' or 'melee'))
      end

      if attacker:GetNW2Bool('zeta_aggressor',false) or !ent:GetNW2Bool('zeta_aggressor',false) and self:GetPos():Distance(attacker:GetPos()) <= self.SightDistance and !self:IsFriendswith(attacker) and !ent:IsNPC()  then                
          if zetamath.random(1,30) == 1 then
              if !self:CanSee(dmginfo:GetAttacker()) then return end
              DebugText('Going to defend some random guy')
              if !self.HasLethalWeapon then
                  self:ChooseLethalWeapon()
              end
              if !self.HasLethalWeapon then return end
              if dmginfo:GetAttacker() == self then return end 
              if !GetConVar('zetaplayer_allowdefendothers'):GetBool() then return end
              if self.Weapon == 'NONE' then return end
              if !self.HasMelee and (self:GetState() != 'panic' or self.Weapon == 'PHYSGUN' and self.Grabbing) then return end
              self.Delayattack = false
              self:CancelMove()
              self:SetEnemy(dmginfo:GetAttacker())
              self:SetState('chase'..(!self.HasMelee and 'ranged' or 'melee'))
          end
      end
  end) 

  local function ExecuteVJBaseTweaks(npc)
      local npcID = npc:EntIndex()
      if npc.IsVJBaseSNPC_Human == true and npc.HasMeleeAttack == true then
          hook.Add('Think', npcID..'_DontMeleeAttackZetas', function()
              if !IsValid(npc) then hook.Remove('Think', npcID..'_DontMeleeAttackZetas') return end
              if CurTime() > npc.NextProcessT then 
                  if IsValid(npc:GetEnemy()) and npc:GetEnemy():GetClass() == 'npc_zetaplayer' then
                      npc.HasMeleeAttack = false
                  else
                      npc.HasMeleeAttack = true
                  end
              end
          end)
      end
      
      if npc.BecomeEnemyToPlayer == true then
          hook.Add('EntityTakeDamage', npcID..'_TurnAgainstAgroZetas', function(ent, dmginfo)
              if !IsValid(npc) then hook.Remove('EntityTakeDamage', npcID..'_TurnAgainstAgroZetas') return end
              if npc != ent or npc.VJ_IsBeingControlled or !dmginfo:GetAttacker().IsZetaPlayer then return end
              
              local attacker = dmginfo:GetAttacker()
              local disp = attacker:GetVJSNPCRelationship(npc)
              
              if disp != D_LI then return end
      
              npc.AngerLevelTowardsPlayer = npc.AngerLevelTowardsPlayer + 1
              if npc.AngerLevelTowardsPlayer > npc.BecomeEnemyToPlayerLevel then
                  if disp != D_HT then
                      npc:CustomWhenBecomingEnemyTowardsPlayer(dmginfo, 0)
                      npc.VJ_AddCertainEntityAsEnemy[#npc.VJ_AddCertainEntityAsEnemy+1] = attacker
                      npc.CurrentPossibleEnemies[#npc.CurrentPossibleEnemies+1] = attacker
                      npc:AddEntityRelationship(attacker,D_HT,99)
                      npc.TakingCoverT = CurTime() + 2
                      if !IsValid(npc:GetEnemy()) then
                          npc:StopMoving()
                          npc:SetTarget(attacker)
                          npc:VJ_TASK_FACE_X("TASK_FACE_TARGET")
                      end
                      npc:PlaySoundSystem("BecomeEnemyToPlayer")
                  end
                  npc.Alerted = true
              end
          end)
      end
  end

  hook.Add('OnEntityCreated', 'zetasetrelationship'..entIndex, function(ent) -- Relationship stuff
      if !IsValid(self) then hook.Remove('OnEntityCreated', 'zetasetrelationship'..entIndex) return end
      if !IsValid(ent) or !ent:IsNPC() then return end

      local disp = self:GetPlayerRelation(ent)
      if disp == D_HT and isfunction(ent.AddEntityRelationship) then
          ent:AddEntityRelationship(self,D_HT)
      end

      if ent.IsVJBaseSNPC then
          timer.Simple(ent.NextProcessTime, function()
              if !IsValid(self) or !IsValid(ent) then return end
              if self:GetVJSNPCRelationship(ent) == D_HT then
                  if ent.VJ_AddCertainEntityAsEnemy then
                    table.insert(ent.VJ_AddCertainEntityAsEnemy, self)
                  end
                  if ent.CurrentPossibleEnemies then
                    table.insert(ent.CurrentPossibleEnemies, self)
                  end
                  ent:AddEntityRelationship(self,D_HT)
              end

              ent.IsHookedByZetaPlayer = ent.IsHookedByZetaPlayer or false
              if !ent.IsHookedByZetaPlayer then
                  ent.IsHookedByZetaPlayer = true
                  ExecuteVJBaseTweaks(ent)
              end
          end)
      end
  end)

  for _, npc in ipairs(ents.FindByClass('npc_*')) do -- Relationship stuff
      local disp = self:GetPlayerRelation(npc)
      if disp == D_HT and isfunction(npc.AddEntityRelationship) then
          npc:AddEntityRelationship(self,D_HT)
      end

      if npc.IsVJBaseSNPC then 
          if self:GetVJSNPCRelationship(npc) == D_HT then
              table.ForceInsert(npc.VJ_AddCertainEntityAsEnemy, self)
              table.ForceInsert(npc.CurrentPossibleEnemies, self)
              npc:AddEntityRelationship(self,D_HT)
          end

          npc.IsHookedByZetaPlayer = npc.IsHookedByZetaPlayer or false
          if !npc.IsHookedByZetaPlayer  then
              npc.IsHookedByZetaPlayer = true
              ExecuteVJBaseTweaks(npc)
          end
      end
  end

  hook.Add('OnZetaPlayerQuestion','zetaquestionhook'..entIndex,function(Zeta) -- Called when a Zeta finishes their question
      if !IsValid(self) then hook.Remove('OnZetaPlayerQuestion','zetaquestionhook'..entIndex) return end
      if !IsValid(Zeta) then return end
      if self.IsAttacking == true then return end
      if Zeta != self and Zeta:GetPos():Distance(self:GetPos()) <= 600 and zetamath.random(1,2) == 1 then
          timer.Simple(zetamath.Rand(0.0,1.0),function()
              if !self:IsValid() then return end
              self:Respond()
          end)
      end 
  end)


  hook.Add('EntityEmitSound', 'zetalistenformusic'..entIndex, function(snddata) -- This is how Zetas hear music
      if !IsValid(self) then hook.Remove('EntityEmitSound', 'zetalistenformusic'..entIndex) return end
      if self.PlayingPoker then return end
      if self:GetState() == 'driving' then return end
      local sndfile = snddata.SoundName
      local sndlvl = snddata.SoundLevel

      local explode = string.Explode('/',sndfile)
      local emitpos
      if snddata.Pos then
          emitpos = snddata.Pos
      else
          emitpos = snddata.Entity:GetPos()
      end
      if emitpos:Distance(self:GetPos()) > self.SightDistance then return end
      if explode[1] == 'music' or explode[2] == 'musicbox' or explode[2] == 'custom_music' and self:GetState() != 'chasemelee' and self:GetState() != 'panic' and self.CanDance == true and zetamath.random(1,100) < GetConVar("zetaplayer_dancechance"):GetInt() then
          DebugText('Dist = '..tostring(emitpos:Distance(self:GetPos())))
          if snddata.Entity then
              self.MusicEnt = snddata.Entity
          end
          self:CancelMove()
          self:SetState('dancing')
          self:FaceTick(emitpos,200)
          self.SoundPos = emitpos
          self.DanceWaittime = zetamath.Rand(0.5,1.5)
          self.CanDance = false 
          timer.Simple(30,function()
              if self and self:IsValid() then
                  self.CanDance = true
              end
          end)
      end
  end)

  hook.Add("EntityRemoved", 'zetacheckremoved'..entIndex, function(ent) -- stop dancing if the entity playing the music just gets deleted
      if !IsValid(self) then hook.Remove("EntityRemoved", 'zetacheckremoved'..entIndex) return end
      if !self.MusicEnt or ent != self.MusicEnt then hook.Remove("EntityRemoved", 'zetacheckremoved'..entIndex) return end
      self:SetState('idle')
      self.MusicEnt = nil
  end)

  local keys = {"w","a","s","d","q","r","t","f","g","v","1","2","3","4","5","6","7","8","9","z","x","c","b","h","`"," ","j","y","u","i"}

  local function stringRandom( length )

    local strin = ""

    for i=1, length do
      local character = math.random(1,2) == 1 and string.upper(keys[math.random(#keys)]) or keys[math.random(#keys)]
      strin = strin..character
    end
  
      return strin
  
  end

  hook.Add("ZetaOnStateChanged", "zetastatechangedhook"..entIndex, function(zeta, old, new)
    if !IsValid(self) then hook.Remove("ZetaOnStateChanged", "zetastatechangedhook"..entIndex) return end
      if !GetConVar("zetaplayer_allowinterrupting"):GetBool() then return end
      if zeta == self and (new == "chaseranged" or new == "chasemelee" or new == "panic") and self.TypingChatText != nil then
          local tbl = self.TypingChatText
          local col = tbl[4]
          local phraseLen = tbl[1]:len()
          local wordsTyped = math.Round(phraseLen * (CurTime()-tbl[2]) / tbl[3])
          if wordsTyped < phraseLen then
              self.TypingChatText = ""
              for i = 1, wordsTyped+1 do
                  if i != wordsTyped+1 then
                      self.TypingChatText = self.TypingChatText..tbl[1][i]
                  elseif self.TypingChatText[self.TypingChatText:len()] != "-" then 
                    local addend = "-"
                    if math.random(1,2) == 1 then
                      addend = stringRandom( math.random(1,20) )
                    end
                      self.TypingChatText = self.TypingChatText..addend
                  end
              end

              timer.Remove("zetaTypeChatMessage"..self:EntIndex())
              self:SendTextMessage(self.TypingChatText,col)
          end
      end
  end)

  local respondCooldown = CurTime()
  hook.Add("ZetaPlayerSay","zetaplayersayhook"..entIndex,function(zeta,text,name)
      if !IsValid(self) then hook.Remove("ZetaPlayerSay","zetaplayersayhook"..entIndex) return end
      if !GetConVar("zetaplayer_allowtextchat"):GetBool() then return end
      if self:IsChasingSomeone() then return end
      if self:GetState() == "conversation" or self:GetState() == "adminsit" or self:GetState() == "jailed/held" then return end

      local isMentioned = string.find(string.lower(text), string.lower(self.zetaname))
      if isMentioned != nil and zetamath.random(30) < self.TextChance or (zeta != self and zetamath.random(200) < self.TextChance and CurTime() > respondCooldown) then
          self.text_keyent = name
          self.text_response = text
          self:TypeMessage("response")
          respondCooldown = CurTime()+5
      end
  end)

  hook.Add("ZetaRealPlayerEndVoice","zetarealplayerspoke"..entIndex,function(ply)
    if !IsValid(self) then hook.Remove("ZetaRealPlayerEndVoice","zetarealplayerspoke"..entIndex) return end 
    if self:IsChasingSomeone() then return end
    

    local inConv = (self:GetState() == "conversation" and 1 or ((self:GetState() == "adminsit" and ply == self.HeldOffender) and 2 or 0))
    if inConv != 0 then
        if inConv == 2 or ply == self.ConversePartner then
            self.AllowResponse = true
            timer.Remove((inConv == 2 and "zetadminplayerinterro_timeout"..entIndex or "zetaconverse_playertimeout"..entIndex))
        end
    end

    if self:GetState() == "conversation" or self:GetState() == "adminsit" or self:GetState() == "jailed/held" then return end

    if GetConVar("zetaplayer_allowtextchat"):GetBool() and zetamath.random(1,2) == 1 then
      if (ply:GetEyeTrace().Entity == self and self:GetRangeSquaredTo(ply) < (100*100)) or (200 * zetamath.random() < self.TextChance and CurTime() > respondCooldown and self:GetRangeSquaredTo(ply) < (100*100)) then
          self.text_keyent = IsValid(ply) and ply:GetName()
          self.text_response = text
          self:TypeMessage("response")
          respondCooldown = CurTime()+5
          return
      end
    else
      if (ply:GetEyeTrace().Entity == self and self:GetRangeSquaredTo(ply) < (100*100)) or (100 * zetamath.random() < self.VoiceChance and self:GetRangeSquaredTo(ply) < (100*100)) then
        if zetamath.random(1,2) == 1 then
          self:PlayRespondLine()
        else
          self:PlayIdleLine()
        end
        return
    end
  end

  end)


  local comeherestatements = {
    "come here",
    "come",
    "come over here",
    "make your way",
    "get over here",
    "come over",
  }


  hook.Add("PlayerSay","zetarealplayersay"..entIndex,function( ply, text )
      if !IsValid(self) then hook.Remove("PlayerSay","zetarealplayersay"..entIndex) return end
      if self:IsChasingSomeone() then return end

      local inConv = (self:GetState() == "conversation" and 1 or ((self:GetState() == "adminsit" and ply == self.HeldOffender) and 2 or 0))
      if inConv != 0 then
          if inConv == 2 or ply == self.ConversePartner then
              self.AllowResponse = true
              timer.Remove((inConv == 2 and "zetadminplayerinterro_timeout"..entIndex or "zetaconverse_playertimeout"..entIndex))
          end
          return
      end

      local isMentioned = string.find( string.lower( text ), string.lower( self.zetaname ) )
      local friends = string.find( string.lower( text ), "friends" )
      local follow = string.find( string.lower( text ), "follow" )
      local stopfollow = string.find( string.lower( text ), "stop" )
      local convo = string.find( string.lower( text ), "conversation" )
      local comehere

      for i=1, #comeherestatements do

        comehere = string.find( string.lower( text ), comeherestatements[ i ] )

        if comehere then break end
      end

      if isMentioned and ( stopfollow or follow) and self.TextChatMentioner == ply and self:GetState() == "followmentioner" then
        self:CancelMove()
        self:SetState( "idle" )
      end

    if ( isMentioned or friends and self:IsFriendswith( ply ) ) and follow and ( zetamath.random( 1, 100 ) < self.FriendlyChance or self:IsFriendswith( ply ) ) then

        if zetamath.random( 1, 100 ) < self.TextChance and GetConVar("zetaplayer_allowtextchat"):GetBool() then
          self.text_keyent = ply:GetName()
          self:TypeMessage( "acknowledge" )
        end

        self:CancelMove()

        self.followtimeout = CurTime() + 60

        self.TextChatMentioner = ply
        self:SetState( "followmentioner" )

      return
      elseif isMentioned and convo and ( zetamath.random( 1, 100 ) < self.FriendlyChance or self:IsFriendswith( ply ) ) and self:GetRangeSquaredTo( ply ) <= ( 500 * 500 ) then

        self:CancelMove()

        
        self.ConversePartner = ply
        self.ConverseTimesMax = math.random(4,15)
        self.ConverseTimes = 0
        self.AllowResponse = true
        self.StartedConverse = true
        self.Question = true
        self.Respond = false
        self.ConverseBegan = false

        self:SetState("conversation")

      return
      elseif ( isMentioned or friends and self:IsFriendswith( ply ) ) and comehere and ( zetamath.random( 1, 100 ) < self.FriendlyChance or self:IsFriendswith( ply ) ) then

        if zetamath.random( 1, 100 ) < self.TextChance and GetConVar("zetaplayer_allowtextchat"):GetBool() then
          self.text_keyent = ply:GetName()
          self:TypeMessage( "acknowledge" )
        end

        self:CancelMove()

        self.TextChatMentioner = ply
        self:SetState( "gotomentioner" )



        return
      end


      if !GetConVar("zetaplayer_allowtextchat"):GetBool() then return end
      
      if isMentioned != nil and zetamath.random(30) < self.TextChance or (ply:GetEyeTrace().Entity == self and self:GetRangeSquaredTo(ply) < (100*100)) or (200 * zetamath.random() < self.TextChance and CurTime() > respondCooldown) then
          self.text_keyent = IsValid(ply) and ply:GetName()
          self.text_response = text
          self:TypeMessage("response")
          respondCooldown = CurTime()+5
      end
  end)

  -- Admin only stuff 
  if self.IsAdmin then
    hook.Add("ZetaAdminRuleViolate","zetaAdminrulelistener"..entIndex,function(victim,attacker,inflictor,ruletype)
        if !IsValid(self) then hook.Remove("ZetaAdminRuleViolate","zetaAdminrulelistener"..entIndex) return end
        if IsValid(attacker) and attacker:IsPlayer() and GetConVar("zetaplayer_admintreatowner"):GetBool() then  return end
        if !attacker:IsPlayer() and attacker.IsAdmin then return end
        if self:IsFriendswith(attacker) then return end
        if attacker == self then return end
        if self:GetState() == "adminsit" then return end
        
        if self:CanSee(attacker) and !attacker.AdminHandled and attacker:IsPlayer() or attacker.IsZetaPlayer and self:GetRangeSquaredTo(attacker) <= (self.SightDistance*self.SightDistance) then
            self.CurrentRuleData = {
                victim = victim,
                offender = attacker,
                inflictor = inflictor,
                ruletype = ruletype
            }

            self:CancelMove()
            self:SetEnemy(NULL)
            self:SetState("adminsit")
        end
    end)
  end -- Admin end

  local itemPickups = {
    ['sent_ball'] = 5,
    ['item_healthvial'] = 10,
    ['item_battery'] = 15,
    ['item_healthkit'] = 25
}
    timer.Create('zeta_itempickup_check_'..entIndex, 0.1, 0,  function() -- This isn't a hook but still gonna put this here
        if !IsValid(self) then timer.Remove('zeta_itempickup_check_'..entIndex) return end
        for _, v in ipairs(ents.FindInSphere(self:GetPos(), 50)) do
            local healHP = itemPickups[v:GetClass()]
            if !healHP then continue end
            if healHP == 15 and self.CurrentArmor >= self.MaxArmor then continue end
            if (healHP == 10 or healHP == 25) and self:Health() >= self:GetMaxHealth() then continue end

            local pickupSnd = 'items/smallmedkit1.wav'
            if healHP == 15 then
                self.CurrentArmor = math.min(self.CurrentArmor + healHP, self.MaxArmor)
                pickupSnd = 'items/battery_pickup.wav'
            else
                if healHP == 5 then
                    self:SetHealth(self:Health() + healHP)
                    pickupSnd = 'garrysmod/balloon_pop_cute.wav'

                    self.achievement_BallEater = self.achievement_BallEater + 1
                    if self.achievement_BallEater == self.achievement_BallEaterMax then
                        self:AwardAchievement("Ball Eater")
                    end
                else
                    self:SetHealth(math.min(self:Health() + healHP, self:GetMaxHealth()))
                end
            end
            
            v:EmitSound(pickupSnd, 70)
            v:Remove()

            if zetamath.random(100) < self.VoiceChance and v.ZetaSpawnTimer and v.ZetaSpawnTimer > CurTime() and CurTime() > self.HealThanksCooldown and v:GetOwner() != self then
                self.HealThanksCooldown = CurTime() + 20
                self:PlayAssistSound()
            end

            local creator = v:GetCreator()
            
            if zetamath.random(20) == 1 and GetConVar("zetaplayer_enablefriend"):GetBool() and IsValid(creator) and (creator:IsPlayer() or creator.IsZetaPlayer) then
              self:AddFriend(v:GetCreator())
            end
        end
    end)


    hook.Add("OnZetaVoteDispatched","zetaonvotedispatched"..entIndex,function(ply,title,options)
      if !IsValid(self) then hook.Remove("OnZetaVoteDispatched","zetaonvotedispatched"..entIndex) return end

      if math.random(1,3) == 1 then
        timer.Simple(math.Rand(1,8),function()
          if !IsValid(self) or _ZetaCurrentVote == "NIL" then return end
          local votedoption = options[math.random(#options)]

          ZetaPlayer_DispatchVote(self,votedoption)

        end)
      end
    end)



end

function ENT:DispatchRandomVote()
  local votingdata = file.Read("zetaplayerdata/votingdata.json")
  if !votingdata then return end

  local tbl = util.JSONToTable(votingdata)

  local rnddata = tbl[math.random(#tbl)]

  ZetaPlayer_CreateVote(self,rnddata[1],rnddata[2])
end

function ENT:Killbind()
  self.SilenceDeath = true
  self.KillReason = self.zetaname.." bid Farewell, Cruel World!"
  local dmginfo = DamageInfo()
  dmginfo:SetDamage(10)
  dmginfo:SetDamageForce(self.IsMoving and self:GetForward()*4000 or self:GetForward()*10)
  dmginfo:SetAttacker(self)
  dmginfo:SetInflictor(self)
  self:OnKilled(dmginfo)
end

function ENT:ConnectMessage()
  local r,g,b = self:GetColorByRank()
  net.Start("zeta_joinmessage",true)
    net.WriteString(self.zetaname)
    net.WriteColor(Color(r,g,b),false)
  net.Broadcast()
end


function ENT:GetColorByRank()
  if SERVER then

    local r,g,b = GetConVar('zetaplayer_displaynameRed'):GetInt(),GetConVar('zetaplayer_displaynameGreen'):GetInt(),GetConVar('zetaplayer_displaynameBlue'):GetInt()

    if GetConVar("zetaplayer_playercolordisplaycolor"):GetBool() then
      if !self.PlayermodelColorCACHE then
        self.PlayermodelColorCACHE = self.PlayermodelColor:ToColor()
      end
      r,g,b = self.PlayermodelColorCACHE.r,self.PlayermodelColorCACHE.g,self.PlayermodelColorCACHE.b
    end

    if IsValid(self:GetFriendByID(Entity(1):GetCreationID())) and GetConVar("zetaplayer_usefriendcolor"):GetBool() then
      r,g,b = GetConVar('zetaplayer_friendnamecolorR'):GetInt(),GetConVar('zetaplayer_friendnamecolorG'):GetInt(),GetConVar('zetaplayer_friendnamecolorB'):GetInt()
    end

    if self.IsAdmin then
        r,g,b = GetConVar('zetaplayer_admindisplaynameRed'):GetInt(),GetConVar('zetaplayer_admindisplaynameGreen'):GetInt(),GetConVar('zetaplayer_admindisplaynameBlue'):GetInt()
    end

    if self:IsInTeam(Entity(1)) then
      if !self.TeamColor then self.TeamColor = self.PlayermodelColor:ToColor() self:SetNW2Vector("zeta_teamcolor",self.PlayermodelColor) end
      r,g,b = self.TeamColor.r,self.TeamColor.g,self.TeamColor.b
    end

    return r,g,b
  else

    local r,g,b = GetConVar('zetaplayer_displaynameRed'):GetInt(),GetConVar('zetaplayer_displaynameGreen'):GetInt(),GetConVar('zetaplayer_displaynameBlue'):GetInt()

    if GetConVar("zetaplayer_playercolordisplaycolor"):GetBool() then
      if !self.PlayermodelColorCACHE then
        self.PlayermodelColorCACHE = self:GetNW2Vector('zeta_modelcolor', Vector(1,1,1)):ToColor()
      end
      r,g,b = self.PlayermodelColorCACHE.r,self.PlayermodelColorCACHE.g,self.PlayermodelColorCACHE.b
    end

    if self:GetNW2Bool("zeta_showfriendstat",false) and GetConVar("zetaplayer_usefriendcolor"):GetBool() then
      r,g,b = GetConVar('zetaplayer_friendnamecolorR'):GetInt(),GetConVar('zetaplayer_friendnamecolorG'):GetInt(),GetConVar('zetaplayer_friendnamecolorB'):GetInt()
    end

    if self:GetNW2Bool("zeta_isadmin", false) then
        r,g,b = GetConVar('zetaplayer_admindisplaynameRed'):GetInt(),GetConVar('zetaplayer_admindisplaynameGreen'):GetInt(),GetConVar('zetaplayer_admindisplaynameBlue'):GetInt()
    end

    if self.zetaTeam != "" then
      if !self.TEAMCOLORCACHE then
        self.TEAMCOLORCACHE = self:GetNW2Vector("zeta_teamcolor",Vector(1,1,1)):ToColor()
      end
      r,g,b = self.TEAMCOLORCACHE.r,self.TEAMCOLORCACHE.g,self.TEAMCOLORCACHE.b
    end

    if GetConVar('zetaplayer_displaynamerainbow'):GetInt() == 1 then
      local rainbow = HSVToColor( (CurTime()*50)%360,1,1 )  
      r,g,b = rainbow.r,rainbow.g,rainbow.b
    end

    return r,g,b
  end
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

function ENT:GetCTFFlags()
  local flags = ents.FindByClass("zeta_flag")
  local validflags = {}

  for k,v in ipairs(flags) do
    if v.teamowner == self.zetaTeam and !v.IsAtHome then
      validflags[#validflags+1] = v
    elseif v.teamowner != self.zetaTeam and v.CanBePickedUp then
      validflags[#validflags+1] = v
    end

    if v.teamowner == self.zetaTeam and math.random(1,5) == 1 and v.CanBePickedUp then
      validflags[#validflags+1] = v
    end
    

  end

  return validflags
end

function ENT:GetCaptureZones()
  local flags = ents.FindByClass("zeta_flag")
  local zones = {}

  for k,v in ipairs(flags) do
    if v.teamowner == self.zetaTeam then
      zones[#zones+1] = v.CaptureZone
    end
  end

  return zones
end


function ENT:GetBackPos()
  local bone = self:LookupBone("ValveBiped.Bip01_Spine2")

  if bone then
    return self:GetBonePosAngs(bone)
  else
    local maxs = self:OBBMaxs()
    maxs[1] = 0
    maxs[2] = 0
    return self:GetPos()+maxs
  end

end


function ENT:GetTeamSpawnTeams()

  local teamspawnTEAMS = {}
  local teams = file.Read('zetaplayerdata/teams.json','DATA')
  local decoded = util.JSONToTable(teams)
  local spawns = ents.FindByClass("zeta_teamspawnpoint")

  if #spawns == 0 then
    
    return decoded
  end

  for k,teamtbl in ipairs(decoded) do

    for i,l in ipairs(spawns) do

      if teamtbl[1] == l.teamspawn then
        teamspawnTEAMS[#teamspawnTEAMS+1] = teamtbl
        break 
      end

    end

  end
  return teamspawnTEAMS
end

-- New friend system stuff

function ENT:AddFriend(ent,forceadd) -- This will call canbefriendswith(). Use Forceadd if you want to bypass that
  if !IsValid(ent) then return end
  if !self:CanBeFriendsWith(ent) and !forceadd then return end
  if !GetConVar("zetaplayer_allowfriendswithzetas"):GetBool() and ent.IsZetaPlayer and !forceadd then return end
  if !GetConVar("zetaplayer_allowfriendswithplayers"):GetBool() and ent:IsPlayer() and !forceadd then return end
  if self.Friends[ent:GetCreationID()] then return end
  if ent == self then return end

  if ent:IsPlayer() then
    self:SetNW2Bool("zeta_showfriendstat",true)
  end

  if !istable(ent.Friends) then

    ent.Friends = {}

  elseif istable(ent.Friends) then
    
    for _,v in pairs(ent.Friends) do
      if !IsValid( v ) then continue end
      if !self:CanBeFriendsWith(v) or !v:CanBeFriendsWith(self) then continue end

      if !v.Friends then
        v.Friends = {}
      end

      if v:IsPlayer() then
        self:SetNW2Bool("zeta_showfriendstat",true)
      end

      v.Friends[self:GetCreationID()] = self
      self.Friends[v:GetCreationID()] = v

    end

  end

  ent.Friends[self:GetCreationID()] = self
  self.Friends[ent:GetCreationID()] = ent
  
end

function ENT:GetRandomFriend()
  for _,v in RandomPairs(self:GetFriends()) do
    if IsValid(v) then
      return v
    end
  end
end

function ENT:IsFriendswith(ent)
  return (IsValid( self.Friends[ent:GetCreationID()] ))
end

function ENT:GetFriendByID(id)
  return self.Friends[id]
end

function ENT:CanBeFriendsWith(ent)
  local count = 0
  local maxfriendcount = GetConVar("zetaplayer_friendamount"):GetInt()

  if istable(ent.Friends) then
    for _,v in pairs(ent.Friends) do
      if IsValid(v) then
        count = count + 1
      end
    end
  end

  for _,v in pairs( self.Friends ) do
    
    if IsValid(v) then

      count = count + 1

    end

  end 

  return count < maxfriendcount
end

function ENT:GetFriends()
  return self.Friends
end

function ENT:RemoveFriend(ent)
  self.Friends[ent:GetCreationID()] = nil

  if ent:IsPlayer() then
    self:SetNW2Bool("zeta_showfriendstat",false)
  end

  if istable(ent.Friends) then
    ent.Friends[self:GetCreationID()] = nil
  end

  if IsValid( self.Spawner ) then
    self.Spawner.Friends[ent:GetCreationID()] = nil
end

end

function ENT:GetPlayerFriend()
  for _,v in pairs(self:GetFriends()) do
    if IsValid(v) and v:IsPlayer() then
      return v
    end
  end
  return NULL
end

function ENT:HasPlayerFriend()
  for _,v in pairs(self:GetFriends()) do
    if IsValid(v) and v:IsPlayer() then
      return true
    end
  end
  return false
end


function ENT:UpdateFriendlist()
  if !GetConVar("zetaplayer_showhwosfriendwithwho"):GetBool() then return end
  local friends = self:GetFriends()
  local friendCount = table.Count(friends)
  if friendCount <= 0 then
      self:SetNW2String("zeta_friendlist", "none")
      return 
  end

  local strin = "Friends with: "
  local count = 0
  for _, v in pairs(friends) do
      local name = v:IsPlayer() and v:GetName() or v.zetaname or "Zeta Player"
      count = count + 1
      strin = strin..name..(count < friendCount and ", " or " ")
      if count > 3 then
          strin = strin.."and "..(table.Count(friends)-3).." others"
          break
      end
  end

  self:SetNW2String("zeta_friendlist",strin)
end

function ENT:GetBotName()
  return (self:GetNW2String('zeta_name', "Zeta Player"))
end

function ENT:GetVehicle()
  if self.GetVehicle_UseDriverSeat then return self.Vehicle:GetDriverSeat() end
  return (self.Vehicle)
end

function ENT:IsVehicleEnterable(veh)
  if veh.IsSimfphyscar and (veh:OnFire()) then return false end
  if math.abs(veh:GetAngles().r) >= 100 and !self:IsNormalSeat( veh ) then return false end
  return (veh:IsVehicle() and isfunction(veh.GetDriver) and !IsValid(veh:GetDriver()) and (veh.IsSimfphyscar and !veh:GetActive() and !veh.Zetadriven or isfunction(veh.IsEngineStarted) and !veh:IsEngineStarted()) and !veh.Zetadriven)
end

function ENT:SetEyeAngles(ang)
  local locAng = self:WorldToLocalAngles(ang)

  self:SetPoseParameter('head_yaw', locAng[2])
  self:SetPoseParameter('head_pitch', locAng[1])
  self:SetPoseParameter('aim_yaw', locAng[2])
  self:SetPoseParameter('aim_pitch', locAng[1])
end

function ENT:Alive()
  return true
end

function ENT:RecreatePokerTable(tbl)
  if !IsValid(tbl) then return end

  local tblphys = tbl:GetPhysicsObject()
  local isfrozen = true
  if IsValid(tblphys) then
    isfrozen = tblphys:IsMotionEnabled()
  end

  tbl:Remove()
  local poker = ents.Create("ent_poker_game")
  poker:SetPos(tbl:GetPos())
  poker:SetAngles(tbl:GetAngles())
  poker.botsInfo = tbl.botsInfo
  poker:Spawn()
  poker:Activate()

  local phys = poker:GetPhysicsObject()
  if IsValid(phys) then
    phys:EnableMotion(isfrozen)
  end

  poker:SetGameType(tbl:GetGameType())
  poker:SetMaxPlayers(tbl:GetMaxPlayers())

  poker:SetBetType(tbl:GetBetType())
  poker:SetEntryBet(tbl:GetEntryBet())
  poker:SetStartValue(tbl:GetStartValue())

  poker:SetBotsPlaceholder(tbl:GetBotsPlaceholder())
  poker:SetBots(tbl:GetBots())

  return poker
end

function ENT:GetPokerPlayers(Tbl)
  local players = Tbl.players
  local convertedplayers = {}
  for _,plydata in ipairs(players) do
    convertedplayers[#convertedplayers+1] = Entity(plydata.ind) 
  end

  return convertedplayers
end

function ENT:JoinPokerGame(pokerTbl)
  if !IsValid(pokerTbl) then return end

    if !pokerTbl.GPoker_ZetaOccupied then
      pokerTbl.GPoker_ZetaOccupied = true
      local changedstate = false
      self:ToggleNoclip(false)
      self.Enemy = NULL
      if !IsValid(pokerTbl.ZetaPlayerHost) then
        pokerTbl.ZetaPlayerHost = self
      end
      
      pokerTbl.removePlayerFromMatch = function(self, ply)
          if ply.IsZetaPlayer then
            hook.Remove("EntityRemoved", "ZetaGPoker_OnTableRemoved_"..ply:EntIndex())
            ply.PlayingPoker = false
            ply.zetaIngodmode = false
          end
          if !ply:IsPlayer() and !ply.IsZetaPlayer then pokerTbl:removeBot(ply) return end
      
          local key = pokerTbl:getPlayerKey(ply)
      
          if key == nil then return end
      
          local chair = ply:GetVehicle()
          ply:ExitVehicle()
          if IsValid(chair) then chair:Remove() end
      
          for k,v in pairs(pokerTbl.decks[key]) do
              if IsValid(Entity(v.ind)) then Entity(v.ind):Remove() end
          end
      
          table.remove(pokerTbl.players, key)
          table.remove(pokerTbl.decks, key)
      
          pokerTbl:updateSeatsPositioning()
          pokerTbl:updateDecksPositioning()
          pokerTbl:updatePlayersTable()
      
          if pokerTbl:GetTurn() == key and #pokerTbl.players > 0 then
              pokerTbl:nextTurn()
          end
      
          if pokerTbl:GetDealer() == key and #pokerTbl.players > 0 then
              pokerTbl:nextDealer()
          else
              pokerTbl:SetDealer(pokerTbl:GetDealer())
          end
      
          if pokerTbl:getPlayersAmount() < 1 or #pokerTbl.players <= 1 then 
              //Give last player the smackaroos if there is any
              if #pokerTbl.players > 0 then
                  local lastPlayer = nil
                  for k,v in pairs(pokerTbl.players) do
                      if !v.bot then lastPlayer = k break end
                  end
                  if lastPlayer != nil then gPoker.betType[pokerTbl:GetBetType()].add(Entity(pokerTbl.players[lastPlayer].ind), pokerTbl:GetPot(), pokerTbl) end
              end
              pokerTbl:prepareForRestart() 
          end
      end

      pokerTbl:NetworkVar("Int", 6, "Turn")
      pokerTbl:NetworkVarNotify("Turn", function(ent, name, old, new)
        if pokerTbl:GetGameState() > 0 and new != 0 then
          local ply = Entity(pokerTbl.players[new].ind)
          
    
          if gPoker.gameType[pokerTbl:GetGameType()].states[pokerTbl:GetGameState()].drawing then
            if ply.IsZetaPlayer then
              timer.Simple(math.random(2, 8), function()
                if !IsValid(pokerTbl) or !IsValid(ply) then return end
    
                local plyKey = pokerTbl:getPlayerKey(ply)
        
                local cards = {}
                for k, _ in pairs(pokerTbl.decks[plyKey]) do
                  cards[k] = (math.random(1, 3) == 1)
                end
    
                local selectCards = {}
                for k, v in ipairs(cards) do
                  if v then selectCards[#selectCards + 1] = k end 
                end
            
                if !table.IsEmpty(selectCards) then
                  local oldCards = {}
                  for _, v in pairs(selectCards) do
                    oldCards[pokerTbl.decks[plyKey][v].suit] = pokerTbl.decks[plyKey][v].rank
                    pokerTbl:dealSingularCard(plyKey, v)
                 end
                  for k, v in pairs(oldCards) do
                  pokerTbl.deck[k][v] = true
                  end
    
                DebugText("(GPoker) "..ply.zetaname..": Exchanging cards...")
                  sound.Play("gpoker/cardthrow.wav", pokerTbl:GetPos())
                end
            
                pokerTbl.players[plyKey].ready = true
                pokerTbl:updatePlayersTable()
                pokerTbl:proceed()
              end)
            
              return
          elseif pokerTbl.players[new].bot then
              pokerTbl:simulateBotExchange(new) 
              return 
            end
        
            net.Start("gpoker_derma_exchange")
              net.WriteEntity(pokerTbl)
            net.Send(ply)
          else
            if ply.IsZetaPlayer then
              timer.Simple(math.max(1, (math.random(1, 8) * ((math.random(4) == 1) and 0.1 or 1.0))), function()
                if !IsValid(pokerTbl) or !IsValid(ply) then return end
            
                local plyKey = pokerTbl:getPlayerKey(ply)
              local betTypeText = (pokerTbl:GetBetType() == 1 and " HP" or "$")
              local maxBet = (gPoker.betType[pokerTbl:GetBetType()].get(ply) / math.random(2, 4))
    
                if pokerTbl:GetCheck() then
                  if math.random(2) == 1 and gPoker.betType[pokerTbl:GetBetType()].get(ply) > pokerTbl:GetBet() then
                    local rndBet = math.floor(math.random(pokerTbl:GetBet(), maxBet))
                    gPoker.betType[pokerTbl:GetBetType()].add(ply, -rndBet, pokerTbl)
    
                    pokerTbl:SetCheck(false)
                    pokerTbl:SetBet(rndBet)
                    pokerTbl.players[plyKey].paidBet = rndBet
                    
                    for _, v in pairs(pokerTbl.players) do
                      if v.fold then continue end
                    v.ready = false
                    end
                    
                    DebugText("(GPoker) "..ply.zetaname..": Betting "..rndBet..betTypeText.."...")
                    sound.Play("mvm/mvm_money_pickup.wav", pokerTbl:GetPos())
                  else
                    DebugText("(GPoker) "..ply.zetaname..": Checking...")
                    sound.Play("gpoker/check.wav", pokerTbl:GetPos())
                  end
                else
                  local choice = math.random(4)
                  if choice == 1 then
                    local callPrice = (pokerTbl:GetBet() - pokerTbl.players[plyKey].paidBet)
                      gPoker.betType[pokerTbl:GetBetType()].add(p, -callPrice, pokerTbl)
    
                      pokerTbl.players[plyKey].paidBet = pokerTbl:GetBet()
                    
                    DebugText("(GPoker) "..ply.zetaname..": Calling "..callPrice..betTypeText.."...")
                    sound.Play("mvm/mvm_money_pickup.wav", pokerTbl:GetPos())
                  elseif choice == 2 and gPoker.betType[pokerTbl:GetBetType()].get(ply) > pokerTbl:GetBet()+1 then
                    local rndRaise = math.floor(math.random(pokerTbl:GetBet()+1, maxBet))
                    gPoker.betType[pokerTbl:GetBetType()].add(ply, -rndRaise, pokerTbl)
    
                    pokerTbl:SetCheck(false)
                    pokerTbl:SetBet(rndRaise)
                    pokerTbl.players[plyKey].paidBet = rndRaise
                    
                    for _, v in pairs(pokerTbl.players) do
                      if v.fold then continue end
                    v.ready = false
                    end
                    
                    DebugText("(GPoker) "..ply.zetaname..": Raising "..rndRaise..betTypeText.."...")
                    sound.Play("mvm/mvm_money_pickup.wav", pokerTbl:GetPos())
                  else						  	
                    pokerTbl.players[plyKey].fold = true
                    DebugText("(GPoker) "..ply.zetaname..": Folding...")
                    if IsValid(ply) and isfunction(ply.PlayScoldSound) and ply.PlayingPoker then
                      ply:PlayScoldSound()
                    end
                  end
                end
    
                pokerTbl.players[plyKey].ready = true
                pokerTbl:updatePlayersTable()
                timer.Simple(0.2, function()
                  if !IsValid(pokerTbl) then return end
                  pokerTbl:proceed() 
                end)
              end)
        
              return
            elseif pokerTbl.players[new].bot then 
              pokerTbl:simulateBotAction(new) 
              return 
            end
        
          net.Start("gpoker_derma_bettingActions", false)
            net.WriteEntity(pokerTbl)
            net.WriteBool(pokerTbl:GetCheck())
          net.Send(ply)
          end
        end
    end)
  end
  local entIndex = self:EntIndex()
  pokerTbl:NetworkVarNotify("GameState",function(ent,name,old,new)

      changedstate = true


      if changedstate and new == 7 then
         --[[  timer.Simple(8,function()
              if !IsValid(self) then return end
              hook.Remove("EntityRemoved", "ZetaGPoker_OnTableRemoved_"..entIndex)
              self.PlayingPoker = false
              self.zetaIngodmode = false

                  if pokerTbl.ZetaPlayerHost == self and IsValid(pokerTbl) then
                  local oldplayers = self:GetPokerPlayers(pokerTbl)
                    local newpokertable = self:RecreatePokerTable(pokerTbl)

                    undo.Create("GPoker Table")
                      undo.SetPlayer(Entity(1))
                      undo.AddEntity(newpokertable)
                    undo.Finish("GPoker Table")

                    if IsValid(newpokertable) then
                      for _,ply in ipairs(oldplayers) do
                        if IsValid(ply) and ply.IsZetaPlayer and zetamath.random(1,2) == 1 then
                          timer.Simple(math.Rand(0,1),function()
                            if !IsValid(ply) or !IsValid(newpokertable) then return end
                            ply:JoinPokerGame(newpokertable)
                          end)
                        end
                      end
                    end
                end

          end) ]]
      end

      if new == 7 and IsValid(self) and self.PlayingPoker then

          local winner = self:GetPokerWinner(pokerTbl)
          if winner == self then
              self:PlayKillSound()
          else
            if gPoker.betType[pokerTbl:GetBetType()].get(self) < pokerTbl:GetEntryBet() then
              self.GPoker_QuitAction = math.random(1, 3)
            end
              timer.Simple(math.Rand(0,1.5),function()
                  if !IsValid(self) then return end
                  self:PlayDeathSound()
              end)
          end

          return
      end



  end)

  pokerTbl:NetworkVarNotify("Winner",function(ent,name,old,new)
  end)



  self.GPoker_Table = pokerTbl


  hook.Add("EntityRemoved", "ZetaGPoker_OnTableRemoved_"..entIndex, function(ent)
      if !IsValid(self.GPoker_Table) then hook.Remove("EntityRemoved", "ZetaGPoker_OnTableRemoved_"..entIndex) return end
      if ent == self then
          for k, v in ipairs(self.GPoker_Table.players) do
              if table.IsEmpty(v) or !IsValid(Entity(v.ind)) or self == Entity(v.ind) or Entity(v.ind).GPoker_IsPlayer != self.GPoker_Table then continue end
              Entity(v.ind).GPoker_Table = NULL
          end

          self.GPoker_Table:Remove()
          hook.Remove("EntityRemoved", "ZetaGPoker_OnTableRemoved_"..entIndex)
      elseif ent == self.GPoker_Table then
          self.PlayingPoker = false
          self.zetaIngodmode = false
      end
  end)
  self.Enemy = NULL
  pokerTbl:Use(self)
  self.Enemy = NULL
  self:ChangeWeapon("NONE")
  self:ToggleNoclip(false)
  self.PlayingPoker = true
  self.zetaIngodmode = true

  timer.Simple(0.1,function() -- A delay since self isn't in the table. 
  local ingame = false
  local players = self:GetPokerPlayers(pokerTbl)

  for k,v in ipairs(players) do
    if v == self then
      ingame = true
      break
    end
  end  

  if !ingame then
    hook.Remove("EntityRemoved", "ZetaGPoker_OnTableRemoved_"..entIndex)
    self.PlayingPoker = false
    self.zetaIngodmode = false
  end
end)

end

function ENT:IsPokerGameActive()
  if !IsValid(self.GPoker_Table) then return false end
  local state = self.GPoker_Table:GetGameState()
  if state then
    return true
  end
  return false
end

function ENT:GetPokerWinner(pokerTbl)
  local players = pokerTbl.players
  local higheststrength
  local highestvalue
  local winningplayer

  if !players then return self end

  for k,playertbl in ipairs(players) do

    if playertbl.fold then continue end

    if !higheststrength and !highestvalue then
       winningplayer = Entity(playertbl.ind) 
       higheststrength = playertbl.strength
       highestvalue = playertbl.value
        continue 
      end

    if playertbl.strength > higheststrength then
      winningplayer = Entity(playertbl.ind) 
      higheststrength = playertbl.strength
      highestvalue = playertbl.value
    elseif playertbl.strength == higheststrength then
      if playertbl.value > highestvalue then
        winningplayer = Entity(playertbl.ind) 
        higheststrength = playertbl.strength
        highestvalue = playertbl.value
      end
    end


  end

  return winningplayer
end

------

function ENT:IsInNoclip()
  return self.InNoclip
end

function ENT:GetTravelDistance(goalPos)
  if self:IsInNoclip() then return (self:GetRangeTo(goalPos)) end
  local path = Path("Follow")
  path:Compute(self, goalPos, self:PathGenerator())
  return (!path:IsValid() and -1.0 or path:GetLength())
end


function ENT:Get100Percchances()
  local hundreds = 0
  for k,chances in ipairs(self.PERSCHANCES) do
      if chances.chance == 100 then
          hundreds = hundreds + 1
      end
  end
  return hundreds
end

function ENT:ComputeChances()
  
  local hundreds = self:Get100Percchances()
  
  for k,chances in ipairs(self.PERSCHANCES) do
      if math.random(1,100) < chances.chance then
          if (chances.chance == 100 and hundreds > 1 and math.random(1,2) == 1) then hundreds = hundreds - 1 continue end
          
          --print(chances[1]," succeeded its chance ["..chances.chance.."]")
          hundreds = hundreds - 1
          
          chances.func()
          return
      else
          if chances.chance == 100 and hundreds > 1 then
              hundreds = hundreds - 1
          end
          --print(chances[1]," Failed its chance ["..chances.chance.."]")
      end
  end
  --print("All Chances failed!")
end

function ENT:Kill()
  local dmginfo = DamageInfo()
  dmginfo:SetDamage(10)
  dmginfo:SetDamageForce(self.IsMoving and self:GetForward()*4000 or self:GetForward()*10)
  dmginfo:SetAttacker(self)
  dmginfo:SetInflictor(self)
  self:OnKilled(dmginfo)
end

function ENT:GetMovementData(pos)
  local movespeed = pos == "run" and GetConVar("zetaplayer_runspeed"):GetInt() or pos == "walk" and GetConVar("zetaplayer_walkspeed"):GetInt() or self:GetTravelDistance(pos) >= 1000 and GetConVar("zetaplayer_runspeed"):GetInt() or GetConVar("zetaplayer_walkspeed"):GetInt()
  local animation = self:GetActivityWeapon('move')
  if movespeed < 200 then
    animation = walkAnimTranslations[self:GetActivityWeapon('move')]
  end

  if _ZetaWeaponDataTable[self.Weapon].moveSpeed then -- Add weapon speed to the current speed we are at if the weapon has a move speed modifier 
    movespeed = movespeed + _ZetaWeaponDataTable[self.Weapon].moveSpeed
  end
  
  return movespeed,animation
end

function ENT:EyePos()
  return self:GetAttachmentPoint("eyes").Pos
end

function ENT:EyeAngles()
  return self:GetAttachmentPoint("eyes").Ang
end


-----------------------------------------------
