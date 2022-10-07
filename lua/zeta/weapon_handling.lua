-----------------------------------------------
-- Weapon Stuff
--- This is where all of Zeta's weapons and attacks are handled
-----------------------------------------------
AddCSLuaFile()

local trace = {}
trace.TraceLine = util.TraceLine
trace.TraceHull = util.TraceHull
trace.QuickTrace = util.QuickTrace
trace.TraceEntity = util.TraceEntity
local tracetbl = {}

local randInt = math.random
local threatEnts = {
    ["npc_grenade_frag"]=true,
    ["grenade_helicopter"]=true,
    ["obj_vj_grenade"]=true,
    ["ent_mp1_grenade_thrown"]=true,
    ["prop_physics"]=function(ent) return (ent.LargeZetaGrenade) end
}


if (CLIENT) then
    local iconColor = Color(255, 80, 0, 255)

	-- Counter-Strike: Source Weapons
    local cssFontName = "Zeta_CSS_KillIcons"
    surface.CreateFont(cssFontName, {font = "csd", size = ScreenScale(30), weight = 500, antialias = true, additive = true})
    killicon.AddFont("zetaweapon_css_sg552",     cssFontName,  "A",    iconColor)
    killicon.AddFont("zetaweapon_css_usp",       cssFontName,  "a",    iconColor)
    killicon.AddFont("zetaweapon_css_xm1014",    cssFontName,  "B",    iconColor)
    killicon.AddFont("zetaweapon_css_ak47",      cssFontName,  "b",    iconColor)
    killicon.AddFont("zetaweapon_css_glock",     cssFontName,  "c",    iconColor)
    killicon.AddFont("zetaweapon_css_aug",       cssFontName,  "e",    iconColor)
    killicon.AddFont("zetaweapon_css_deagle",    cssFontName,  "f",    iconColor)
    killicon.AddFont("zetaweapon_css_knife",     cssFontName,  "j",    iconColor)
    killicon.AddFont("zetaweapon_css_mac10",     cssFontName,  "l",    iconColor)
    killicon.AddFont("zetaweapon_css_p90",       cssFontName,  "m",    iconColor)
    killicon.AddFont("zetaweapon_css_scout",     cssFontName,  "n",    iconColor)
    killicon.AddFont("zetaweapon_css_ump45",     cssFontName,  "q",    iconColor)
    killicon.AddFont("zetaweapon_css_awp",       cssFontName,  "r",    iconColor)
    killicon.AddFont("zetaweapon_css_famas",     cssFontName,  "t",    iconColor)
    killicon.AddFont("zetaweapon_css_fiveseven", cssFontName,  "u",    iconColor)
    killicon.AddFont("zetaweapon_css_m4a1",      cssFontName,  "w",    iconColor)
    killicon.AddFont("zetaweapon_css_mp5",       cssFontName,  "x",    iconColor)
    killicon.AddFont("zetaweapon_css_m249",      cssFontName,  "z",    iconColor)
    killicon.AddFont("zetaweapon_css_elites",    cssFontName,  "s",    iconColor)
    killicon.AddFont("zetaweapon_css_m3",        cssFontName,  "k",    iconColor)
    killicon.AddFont("zetaweapon_css_tmp",       cssFontName,  "d",    iconColor)
    killicon.AddFont("zetaweapon_css_galil",     cssFontName,  "v",    iconColor)
    killicon.AddFont("zetaweapon_css_flashbang",     cssFontName,  "p",    iconColor)
    killicon.AddFont("zetaweapon_css_smokegrenade",  cssFontName,  "q",    iconColor)

	-- Left 4 Dead 2 Weapons
	killicon.Add("zetaweapon_l4d2_melee_fireaxe",       "vgui/zetaplayers/killicons/l4d2/icon_fireaxe", iconColor)
	killicon.Add("zetaweapon_l4d2_melee_tonfa",         "vgui/zetaplayers/killicons/l4d2/icon_tonfa", iconColor)
	killicon.Add("zetaweapon_l4d2_melee_golfclub",      "vgui/zetaplayers/killicons/l4d2/icon_golfclub", iconColor)
	killicon.Add("zetaweapon_l4d2_melee_guitar",        "vgui/zetaplayers/killicons/l4d2/icon_electric_guitar", iconColor)
    killicon.Add("zetaweapon_l4d2_melee_frying_pan",    "vgui/zetaplayers/killicons/l4d2/icon_frying_pan", iconColor)
    killicon.Add("zetaweapon_l4d2_pistol_m1911",        "vgui/zetaplayers/killicons/l4d2/icon_pistol_m1911", iconColor)
    killicon.Add("zetaweapon_l4d2_pistol_p220",         "vgui/zetaplayers/killicons/l4d2/icon_pistol", iconColor)
    killicon.Add("zetaweapon_l4d2_pistol_glock",        "vgui/zetaplayers/killicons/l4d2/icon_pistol_glock", iconColor)
    killicon.Add("zetaweapon_l4d2_pistol_magnum",       "vgui/zetaplayers/killicons/l4d2/icon_pistol_magnum", iconColor)
    killicon.Add("zetaweapon_l4d2_smg",                 "vgui/zetaplayers/killicons/l4d2/icon_smg", iconColor)
    killicon.Add("zetaweapon_l4d2_smg_silenced",        "vgui/zetaplayers/killicons/l4d2/icon_smg_silenced", iconColor)
    killicon.Add("zetaweapon_l4d2_pumpshotgun",         "vgui/zetaplayers/killicons/l4d2/icon_pumpshotgun", iconColor)
    killicon.Add("zetaweapon_l4d2_shotgun_chrome",      "vgui/zetaplayers/killicons/l4d2/icon_shotgun_chrome", iconColor)
    killicon.Add("zetaweapon_l4d2_rifle",               "vgui/zetaplayers/killicons/l4d2/icon_rifle", iconColor)
    killicon.Add("zetaweapon_l4d2_rifle_desert",        "vgui/zetaplayers/killicons/l4d2/icon_rifle_desert", iconColor)
    killicon.Add("zetaweapon_l4d2_rifle_ak47",          "vgui/zetaplayers/killicons/l4d2/icon_rifle_ak47", iconColor)
    killicon.Add("zetaweapon_l4d2_shotgun_spas",        "vgui/zetaplayers/killicons/l4d2/icon_shotgun_spas", iconColor)
    killicon.Add("zetaweapon_l4d2_autoshotgun",         "vgui/zetaplayers/killicons/l4d2/icon_autoshotgun", iconColor)
    killicon.Add("zetaweapon_l4d2_hunting_rifle",       "vgui/zetaplayers/killicons/l4d2/icon_hunting_rifle", iconColor)
    killicon.Add("zetaweapon_l4d2_sniper_military",     "vgui/zetaplayers/killicons/l4d2/icon_sniper_military", iconColor)
    killicon.Add("zetaweapon_l4d2_rifle_m60",           "vgui/zetaplayers/killicons/l4d2/icon_rifle_m60", iconColor)
	killicon.Add("zetaweapon_l4d2_grenade_launcher",    "vgui/zetaplayers/killicons/l4d2/icon_grenade_launcher", iconColor)
    killicon.Add("zetaweapon_l4d2_melee_chainsaw",      "vgui/zetaplayers/killicons/l4d2/icon_chainsaw", iconColor)


    -- Day of Defeat: Source Weapons
    killicon.Add("zetaweapon_dod_knife",                "vgui/zetaplayers/killicons/dods/icon_amerk", iconColor)
    killicon.Add("zetaweapon_dod_spade",                "vgui/zetaplayers/killicons/dods/icon_spade", iconColor)
    killicon.Add("zetaweapon_dod_colt1911",             "vgui/zetaplayers/killicons/dods/icon_colt", iconColor)
    killicon.Add("zetaweapon_dod_p38",                  "vgui/zetaplayers/killicons/dods/icon_p38", iconColor)
    killicon.Add("zetaweapon_dod_c96",                  "vgui/zetaplayers/killicons/dods/icon_c96", iconColor)
    killicon.Add("zetaweapon_dod_m1carbine",            "vgui/zetaplayers/killicons/dods/icon_m1carbine", iconColor)
    killicon.Add("zetaweapon_dod_thompspn",             "vgui/zetaplayers/killicons/dods/icon_thompson", iconColor)
    killicon.Add("zetaweapon_dod_garand",               "vgui/zetaplayers/killicons/dods/icon_garand", iconColor)
    killicon.Add("zetaweapon_dod_mp40",                 "vgui/zetaplayers/killicons/dods/icon_mp40", iconColor)
    killicon.Add("zetaweapon_dod_mp44",                 "vgui/zetaplayers/killicons/dods/icon_mp44", iconColor)
    killicon.Add("zetaweapon_dod_kar98",                "vgui/zetaplayers/killicons/dods/icon_k98", iconColor)
    killicon.Add("zetaweapon_dod_kar98s",               "vgui/zetaplayers/killicons/dods/icon_k98s", iconColor)
    killicon.Add("zetaweapon_dod_springfield",          "vgui/zetaplayers/killicons/dods/icon_spring", iconColor)
    killicon.Add("zetaweapon_dod_bar",                  "vgui/zetaplayers/killicons/dods/icon_bar", iconColor)
    killicon.Add("zetaweapon_dod_30cal",                "vgui/zetaplayers/killicons/dods/icon_30cal", iconColor)
    killicon.Add("zetaweapon_dod_mg42",                 "vgui/zetaplayers/killicons/dods/icon_mg42bu", iconColor)
    killicon.Add("zetaweapon_dod_bazooka",              "vgui/zetaplayers/killicons/dods/icon_bazooka", iconColor)
    killicon.Add("zetaweapon_dod_panzerschreck",        "vgui/zetaplayers/killicons/dods/icon_pschreck", iconColor)

    -- Half Life 1 Weapons
    killicon.Add("zetaweapon_hl1_glock",                "vgui/zetaplayers/killicons/hl1/icon_pistol_hl1_glock", iconColor)
    killicon.Add("zetaweapon_hl1_revolver",             "vgui/zetaplayers/killicons/hl1/icon_pistol_hl1_revolver", iconColor)
    killicon.Add("zetaweapon_hl1_smg",                  "vgui/zetaplayers/killicons/hl1/icon_smg_hl1_mp5", iconColor)
    killicon.Add("zetaweapon_hl1_shotgun",              "vgui/zetaplayers/killicons/hl1/icon_smg_hl1_shotgun", iconColor)

    -- Team Fortress 2 Weapons
    killicon.Add("zetaweapon_tf2_bat",                  "vgui/zetaplayers/killicons/tf2/icon_bat", iconColor)
    killicon.Add("zetaweapon_tf2_wrench",               "vgui/zetaplayers/killicons/tf2/icon_wrench", iconColor)
    killicon.Add("zetaweapon_tf2_pistol",               "vgui/zetaplayers/killicons/tf2/icon_pistol", iconColor)
    killicon.Add("zetaweapon_tf2_shotgun",              "vgui/zetaplayers/killicons/tf2/icon_shotgun", iconColor)
    killicon.Add("zetaweapon_tf2_smg",                  "vgui/zetaplayers/killicons/tf2/icon_smg", iconColor)
    killicon.Add("zetaweapon_tf2_sniperrifle",          "vgui/zetaplayers/killicons/tf2/icon_srifle", iconColor)
    killicon.Add("zetaweapon_tf2_scattergun",           "vgui/zetaplayers/killicons/tf2/icon_scattergun", iconColor)
    killicon.Add("zetaweapon_tf2_forceofnature",        "vgui/zetaplayers/killicons/tf2/icon_forceofnature", iconColor)
    killicon.Add("zetaweapon_tf2_grenadelauncher",      "vgui/zetaplayers/killicons/tf2/icon_glauncher", iconColor)
    killicon.Add("zetaweapon_tf2_minigun",              "vgui/zetaplayers/killicons/tf2/icon_minigun", iconColor)
    killicon.Add("zetaweapon_tf2_flamethrower",         "vgui/zetaplayers/killicons/tf2/icon_flamethrower", iconColor)

    -- Custon Weapons
    killicon.Add("zetaweapon_alyxgun",                  "vgui/zetaplayers/killicons/misc/icon_alyxgun", iconColor)
    killicon.Add("zetaweapon_annabelle",                "vgui/zetaplayers/killicons/misc/icon_annabelle", iconColor)
    killicon.Add("zetaweapon_fists",                    "vgui/zetaplayers/killicons/misc/icon_fists", iconColor)
    killicon.Add("zetaweapon_hackmonitor",              "vgui/zetaplayers/killicons/misc/icon_hackmonitor", iconColor)
    killicon.Add("zetaweapon_volver",                   "vgui/zetaplayers/killicons/misc/icon_volver", iconColor)
    killicon.Add("zetaweapon_shovel",                   "vgui/zetaplayers/killicons/misc/icon_shovel", iconColor)
    killicon.Add("zetaweapon_junklauncher",             "vgui/zetaplayers/killicons/misc/icon_junklauncher", iconColor)
	killicon.Add("zetaweapon_katana",                   "vgui/zetaplayers/killicons/misc/icon_katana", iconColor)
	killicon.Add("zetaweapon_meathook",                 "vgui/zetaplayers/killicons/misc/icon_meathook", iconColor)
    killicon.Add("zetaweapon_zombieclaws",              "vgui/zetaplayers/killicons/misc/icon_zclaws", iconColor)
    killicon.Add("zetaweapon_cardoor",                  "vgui/zetaplayers/killicons/misc/icon_cardoor", iconColor)
    killicon.Add("zetaweapon_largesign",                "vgui/zetaplayers/killicons/misc/icon_largesign", iconColor)
    killicon.Add("default","hud/killicons/default",iconColor)
    killicon.Add("zetaweapon_kleiner",              "vgui/zetaplayers/killicons/misc/icon_kleiner", iconColor)
    killicon.AddAlias("", "default")
    killicon.AddAlias(" ", "default")
end





  ENT.CurrentAmmo = 0
  ENT.MaxAmmo = 0
  ENT.Enemy = nil
  ENT.HasLethalWeapon = false
  ENT.HasMelee = false
  ENT.IsReloading = false
  ENT.HasRangedWeapon = false
  ENT.WrenchCooldown = CurTime()
  ENT.AttackCooldown = CurTime()

  if ( SERVER ) then
    local TF2Mounted = IsMounted('tf')
    local HL1Mounted = IsMounted('hl1')
    local mountableWpns = {
        ["HL1SMG"] = HL1Mounted,
        ["HL1GLOCK"] = HL1Mounted,
        ["HL1SPAS"] = HL1Mounted,
        ["HL1357"] = HL1Mounted
    }

    ENT.WeaponConVars = {}
    ENT.ExplosiveWeapons = {}
    
    for k, v in pairs(_ZetaWeaponDataTable) do
        if mountableWpns[k] == nil or mountableWpns[k] == true then
            local cvarName = "zetaplayer_allow"..string.lower(tostring(k))
            if k == "GRENADE" then cvarName = cvarName.."s" end
            local cvar = GetConVar(cvarName)
            if cvar then 
                local isLethal = (k == "CAMERA" and GetConVar("zetaplayer_allowcameraaslethalweapon") or v.lethal)
                ENT.WeaponConVars[k] = {cvar, isLethal} 
            end

            if v.isExplosive then ENT.ExplosiveWeapons[#ENT.ExplosiveWeapons+1] = tostring(k) end
        end
    end
end

  local entmeta = FindMetaTable("Entity")

  local FireBullets = entmeta.FireBullets

  entmeta = FindMetaTable("NextBot")

  local GetRangeSquaredTo = entmeta.GetRangeSquaredTo


  local oldisvalid = IsValid

    local function IsValid( ent )
        if oldisvalid( ent ) and ent.IsZetaPlayer then
            
            return !ent.IsDead 
        else
            return oldisvalid( ent )
        end
    end

  function ENT:GetWeapon()
    return self.Weapon
  end


  function ENT:ChangeWeapon(weapon)
    if !IsValid(self.WeaponENT) then return end
    if self.Weapon == weapon then return end
    if self.IsMingebag then self.WeaponENT:RemoveEffects(EF_BONEMERGE) end
    local wepData = _ZetaWeaponDataTable[weapon]

    if wepData != nil then

        self.Weapon = weapon
        self:SetNW2String("zeta_weaponname", self.Weapon)
        self:EmitSound('items/ammo_pickup.wav',65)

        if self.IsMoving then
            self:StartActivity(self:GetActivityWeapon("move"))
        else
            self:StartActivity(self:GetActivityWeapon("idle"))
        end

        if wepData.weaponscale then
            self.WeaponENT:SetModelScale( wepData.weaponscale, 0 )
        else
            self.WeaponENT:SetModelScale( 1, 0 )
        end

        if !wepData.hidewep then self.WeaponENT:SetMaterial("") else self.WeaponENT:SetMaterial( "null" ) end
        self.WeaponENT:SetModel(wepData.mdl)
        if weapon == "STUNSTICK" then self:EmitSound('weapons/stunstick/spark'..math.random(1,3)..'.wav',75) end
        local attachment = self:GetAttachmentPoint("hand")
        if weapon == "PHYSGUN" then
            self.WeaponENT:SetSkin(1)
            for k, v in ipairs(self.WeaponENT:GetMaterials()) do
                if string.EndsWith(v, 'w_physics_sheet') then
                    self.WeaponENT:SetSubMaterial(k, 'models/weapons/zetaphysgun/w_physics_sheet2')
                end
            end
        else
            self.WeaponENT:SetSkin(0)
            for k, v in ipairs(self.WeaponENT:GetMaterials()) do
                self.WeaponENT:SetSubMaterial(k, 'nil')
            end
        end
        self.WeaponENT:SetAngles(attachment.Ang)
        self.WeaponENT:SetPos(attachment.Pos)
        
        if self.HasProperAttachment then
            self.WeaponENT:SetLocalPos(wepData.offPos)
            self.WeaponENT:SetLocalAngles(wepData.offAng)
        end

        local bonemergeable = self.WeaponENT:LookupBone('ValveBiped.Bip01_R_Hand')
        if isnumber(bonemergeable) and !wepData.nobonemerge and !self.IsMingebag then -- No bone merge is to force it to not bonemerge cause for some reason the TF2 weapons still have the effect of it. Checks if it's nil or false. Mingebags shouldnt bone merge either so the weapon goes where it is supposed to
            self.WeaponENT:AddEffects(EF_BONEMERGE)
        else
            self.WeaponENT:RemoveEffects(EF_BONEMERGE)
        end

        self.HasLethalWeapon = wepData.lethal
        self.HasRangedWeapon = wepData.range
        self.HasMelee = wepData.melee
        self.PrettyPrintWeapon = wepData.prettyPrint
        self.MaxAmmo = wepData.clip
        self.CurrentAmmo = wepData.clip
        if isfunction(wepData.changeCallback) then
            wepData:changeCallback(self, self.WeaponENT)
        elseif isstring( wepData.changeCallback ) then
            local func = CompileString( wepData.changeCallback, "[OnChange] Custom Weapon " .. self.PrettyPrintWeapon)
            func( self, self.WeaponENT )
        end

        local zetastats = file.Read("zetaplayerdata/zetastats.json")

        if zetastats then
            zetastats = util.JSONToTable(zetastats)
            zetastats["popularweapons"] = zetastats["popularweapons"] or {}

            local popularweps = zetastats["popularweapons"]

            popularweps[self.PrettyPrintWeapon] = popularweps[self.PrettyPrintWeapon] and popularweps[self.PrettyPrintWeapon]+1 or 1

            ZetaFileWrite("zetaplayerdata/zetastats.json",util.TableToJSON(zetastats,true))
        end

        return
    end
end


-- This exists so we aren't recreating the same table over and over.
-- This typically gets really heavy when high fire rate weapons such as the MAC10 are constantly firing.
-- Like Mee said, this stuff does build up.
local FireBulletsTABLE = {

}

function ENT:ShootAtPos(pos,time)
    local time = CurTime()+time
    local fakeent = ents.Create("base_point")
    fakeent:SetPos(pos)
    fakeent:Spawn()

    self:DeleteOnRemove(fakeent)

    self:CreateThinkFunction("shootatposition",0,0,function()
        if CurTime() > time then fakeent:Remove() return "failed" end
        self:FireWeapon(fakeent)
        self.loco:FaceTowards(fakeent:GetPos())
    end)
end

function ENT:ShootWeapon(target, fireData,ismelee)
    if self.IsDead then return end
    if self.TypingInChat then return end
    if !self:IsValid() or !self.WeaponENT:IsValid() then  return end
    if !ismelee and self.CurrentAmmo <= 0 then self:Reload() return end
    if self.AttackCooldown > CurTime() then return end
    if self.IsCharging then return end


    
    local blockData = {cooldown = false, anim = false, muzzle = false, shell = false, snd = false, bullet = false, clipRemove = false}
    if (isfunction(fireData.preCallback)) then
        blockData = fireData:preCallback(self, self.WeaponENT, target, blockData)
    elseif isstring( fireData.preCallback ) then
        local func = CompileString( fireData.preCallback, "[PreCallBack] Custom Weapon " .. self.PrettyPrintWeapon)
        blockData = func( self, self.WeaponENT, target, blockData )
        
        if blockData == nil then blockData = {cooldown = false, anim = false, muzzle = false, shell = false, snd = false, bullet = false, clipRemove = false} end

        if ismelee then
            return
        end

    end

    if istable(blockData) then
        if blockData.cooldown == false then
            local fireDelay = (math.random(1, 2) == 1 and fireData.rateMin or math.random(fireData.rateMin,fireData.rateMax))
            self.AttackCooldown = CurTime()+fireDelay
        end

        if blockData.anim == false then
            local anim = fireData.anim
            if self:IsPlayingGesture(anim) then
                self:RemoveGesture(anim)
            end
            self:AddGesture(anim,true)
        end

        if blockData.muzzle == false then self:CreateMuzzleFlash(fireData.muzzleFlash) end
        if blockData.shell == false then self:CreateShellEject() end
        if blockData.snd == false then
            local fireSnd = (istable(fireData.snd) and #fireData.snd > 0) and fireData.snd[math.random(#fireData.snd)] or fireData.snd
            self.WeaponENT:EmitSound(fireSnd, 80, math.random(98, 102), 1, CHAN_WEAPON)
        end

        if blockData.bullet == false then
            local pos = target:GetPos()+target:OBBCenter()

            -- Re-using the table without needing to make a new table. Should improve performance a bit
            FireBulletsTABLE.Attacker = self
            FireBulletsTABLE.Damage = math.random(fireData.dmgMin,fireData.dmgMax)/GetConVar("zetaplayer_damagedivider"):GetFloat()
            FireBulletsTABLE.Force = fireData.force+GetConVar("zetaplayer_forceadd"):GetInt()
            FireBulletsTABLE.HullSize = 5
            FireBulletsTABLE.Spread = Vector(fireData.spread+self.Accuracy,fireData.spread+self.Accuracy,0)
            FireBulletsTABLE.AmmoType = fireData.ammo
            FireBulletsTABLE.Num = fireData.num
            FireBulletsTABLE.TracerName = fireData.tracer
            FireBulletsTABLE.Dir = (pos-self.WeaponENT:GetPos()):GetNormalized()
            FireBulletsTABLE.Src = self.WeaponENT:GetPos()
            FireBulletsTABLE.IgnoreEntity = self
            

            self.WeaponENT:FireBullets(FireBulletsTABLE)
        end

        if blockData.clipRemove == false then self.CurrentAmmo = self.CurrentAmmo - 1 end
    end

    if (isfunction(fireData.postCallback)) then
        fireData:postCallback(self, self.WeaponENT, target)
    end
end

function ENT:FireWeapon(target)
    if self.IsReloading then return end

    local wepData = _ZetaWeaponDataTable[self.Weapon]
    if wepData != nil and wepData.range then
        self:ShootWeapon(target, wepData.fireData, wepData.melee or false )
        return
    end
end


        function ENT:CreateShellEject()
            if !IsValid(self.WeaponENT) then return end
            local wepData = _ZetaWeaponDataTable[self.Weapon]
            if wepData != nil and wepData.shellData != nil then
                local effect = EffectData()
                local offPos = wepData.shellData.offPos
                effect:SetOrigin(self.WeaponENT:GetPos() + self.WeaponENT:GetForward()*offPos.forward + self.WeaponENT:GetRight()*offPos.right + self.WeaponENT:GetUp()*offPos.up)
                effect:SetAngles(self.WeaponENT:GetAngles()+wepData.shellData.offAng)
                effect:SetEntity(self.WeaponENT)
                util.Effect( wepData.shellData.name, effect )
                return 
            end
        end


        function ENT:FireAR2Orb(target)
            if !self:IsValid() then return end
            if !self.WeaponENT:IsValid() then return end
            self.WeaponENT:EmitSound('weapons/cguard/charging.wav',80)
            self.IsCharging = true
            local pos = target:GetPos()+target:OBBCenter()
            timer.Simple(1,function()
                if !self:IsValid() then return end
                self.IsCharging = false
                self:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,true)
                self.WeaponENT:EmitSound('weapons/physcannon/energy_sing_flyby'..math.random(1,2)..'.wav',80)
    
    
                local combineorblauncher = ents.Create("point_combine_ball_launcher")
                combineorblauncher:SetPos(self.WeaponENT:GetPos()+self.WeaponENT:GetForward()*-17)
                combineorblauncher:SetAngles((pos-self.WeaponENT:GetPos()):Angle())
    
                combineorblauncher:Spawn()
                combineorblauncher:Activate()
                
                combineorblauncher:SetKeyValue("speed",tostring(1000))
                combineorblauncher:SetKeyValue("minspeed",tostring(1000))
                combineorblauncher:SetKeyValue("maxspeed",tostring(1000))
                combineorblauncher:SetKeyValue("maxballbounces","5")
                combineorblauncher:SetKeyValue("ltime","5")
                combineorblauncher:SetKeyValue("ballcount","0")
    
    
                combineorblauncher:Fire( "LaunchBall", "", 0 )
                timer.Simple(0.5,function() combineorblauncher:Remove() end)
    
            end)
    
        end




        local newBehaviorCvar = GetConVar("zetaplayer_experimentalcombat")

        local GetBackawayPos = function(zeta, dist, ent)
            ent = ent or zeta:GetEnemy()
            dist = dist or 400
        
            local rayTrace
            local testPos = zeta:GetCenteroid()
            local testNormal = -(ent:GetCenteroid() - testPos):GetNormalized()
            tracetbl.filter = {zeta, zeta.WeaponENT, ent}
            for i = 1, 10 do
                tracetbl.start = testPos
                tracetbl.endpos = testPos + testNormal*dist
                rayTrace = trace.TraceLine(tracetbl)
        
                if i != 1 and !rayTrace.Hit then break end
                testPos = rayTrace.HitPos
                testNormal = 2.0 * rayTrace.HitNormal * -rayTrace.HitNormal:Dot(testNormal) + testNormal
            end
        
            tracetbl.start = testPos
            tracetbl.endpos = testPos - zeta:GetUp()*zeta.loco:GetDeathDropHeight()
            rayTrace = trace.TraceLine(tracetbl)
        
            if !rayTrace.Hit or zeta:GetRangeSquaredTo(testPos) <= (96*96) then 
                testPos = (zeta:GetCenteroid() + (ent:GetCenteroid() - testPos):GetNormalized()*dist) 
                if !util.IsInWorld(testPos) then testPos = ent:GetPos() end
            end
            return testPos
        end
        
        local GetCoverFromEnemy = function(zeta)
            local ene = zeta:GetEnemy()
            local movePos = false
            local forceCover = false
        
            local threats = zeta:FindInSight(384, function(ent) 
                local listData = threatEnts[ent:GetClass()]
                return (isfunction(listData) and listData(ent) == true or listData == true) 
            end)
            if #threats > 0 then 
                forceCover = true
                ene = threats[randInt(#threats)]
            end
            if !IsValid(ene) then return movePos end
        
            local myPos = zeta:GetCenteroid()
            local enePos = ene:GetCenteroid()
            local covers = zeta.PossibleCovers
            if forceCover or (zeta.IsReloading or zeta.CurrentAmmo <= (zeta.MaxAmmo / 3)) and #covers > 0 and (!ene.IsZetaPlayer or (!ene.HasFlag and ene:GetState() == "chaseranged")) and zeta:GetRangeSquaredTo(ene) <= (2048*2048) then
                local lastDist = math.huge
                for i = 1, #covers do
                    local area = covers[i]
                    local curDist = zeta:GetRangeSquaredTo(area)
                    if curDist < lastDist then
                        movePos = area
                        lastDist = curDist
                    end
                end
            end
        
            if forceCover and !movePos then
                movePos = GetBackawayPos(zeta, 384, ene)
            end
            return movePos, forceCover
        end
        
        function ENT:MoveOnCondition(distance, strafe)
            if !IsValid(self:GetEnemy()) then return end
        
            local moveAct = self:GetActivityWeapon("move")
            self:StartActivity(moveAct)
            self:SetLastActivity(moveAct)
        
            if newBehaviorCvar:GetBool() then
                local coverPos, forceCover = GetCoverFromEnemy(self)
                if coverPos then
                    if forceCover or self:CanSee(self:GetEnemy()) then
                        self:ZETA_MoveTo(coverPos, {customfunc=function(path)
                            local newCover = GetCoverFromEnemy(self)
                            if !newCover then return "abort" end
                            if !forceCover then
                                if !IsValid(self:GetEnemy()) then return "abort" end
                                local rndDist = randInt(0, 256) 
                                if self:GetRangeSquaredTo(coverPos) <= (rndDist*rndDist) and !self:CanSee(self:GetEnemy()) then return "abort" end
                            elseif path:GetAge() > 0.5 then
                                path:Compute(self, newCover, self:PathGenerator())
                            end
                        end})
                    elseif self.CurrentAmmo < self.MaxAmmo then
                        self:Reload()
                    end
                else
                    if strafe then
                        self:CreateThinkFunction("StrafeMovement", 0, 0, function()
                            if !self:IsChasingSomeone() or !IsValid(self:GetEnemy()) then return "abort" end
                            if self:GetEnemy().IsZetaPlayer and self:GetEnemy():GetState() != "chaseranged" or !self:CanSee(self:GetEnemy()) then return end
                            
                            local strafeNormal = ((self:GetEnemy():GetPos() - self:GetPos()):Angle():Right()*(randInt(75, 100) * (randInt(2) == 1 and -1 or 1)))
                            if !self.loco:IsOnGround() then strafeNormal = strafeNormal / 3 end
        
                            tracetbl.start = self:GetCenteroid() + strafeNormal
                            tracetbl.endpos = tracetbl.start - self:GetUp()*self.loco:GetDeathDropHeight()
                            tracetbl.filter = {self, self:GetEnemy()}
                            
                            local strafeCheck = trace.TraceLine(tracetbl)
                            if !strafeCheck.Hit then return end 
        
                            self.loco:SetVelocity(self.loco:GetVelocity() + strafeNormal)
                        end)
                    else
                        self:RemoveThinkFunction("StrafeMovement")
                    end
        
                    local captureEnt = NULL
                    if !self:GetEnemy().HasFlag then
                        if self.HasFlag then 
                            local zones = self:GetCaptureZones()
                            local zone = zones[randInt(#zones)]
                            if IsValid(zone) then captureEnt = zone end
                        elseif randInt(2) == 1 then
                            local flags = self:GetCTFFlags()
                            local flag = flags[randInt(#flags)]
                            if IsValid(flag) then captureEnt = flag end
                        end
                    end
        
                    if captureEnt != NULL then
                        self:ZETA_MoveTo(captureEnt, {customfunc=function()
                            if !IsValid(captureEnt) or captureEnt.Holder and IsValid(captureEnt.Holder) or GetCoverFromEnemy(self) then return "abort" end
                        end})
                    else
                        if !self:CanSee(self:GetEnemy()) then
                            self:ZETA_MoveTo(self:GetEnemy(), {update=true, customfunc=function()
                                if self:CanSee(self:GetEnemy()) then return "abort" end
                            end})
                         else
                            if self:GetRangeSquaredTo(self:GetEnemy()) > (distance*distance) then
                                self:ZETA_MoveTo(self:GetEnemy(), {update=true, customfunc=function()
                                    if !IsValid(self:GetEnemy()) or self:GetRangeSquaredTo(self:GetEnemy()) < (distance*distance) or GetCoverFromEnemy(self) then return "abort" end
                                end})
                            elseif self:GetRangeSquaredTo(self:GetEnemy()) < (distance*distance) then
                                self:ZETA_MoveTo(GetBackawayPos(self), {customfunc=function(path)
                                    if !IsValid(self:GetEnemy()) or self:GetRangeSquaredTo(self:GetEnemy()) > (distance*distance) or GetCoverFromEnemy(self) then return "abort" end
                                    if path:GetAge() > 0.25 then path:Compute(self, GetBackawayPos(self), self:PathGenerator()) end
                                end})
                            end 
                        end
                    end
                end
        
                self:StartActivity(self:GetActivityWeapon("idle"))
            else
                if self.HasFlag then 
                    local zones = self:GetCaptureZones()
                    if #zones > 0 then
                        local zone = zones[randInt(#zones)]
                        self:MoveToPos(zone:GetPos() + Vector(randInt(-50, 50), randInt(-50, 50)))
                        self:StartActivity(self:GetActivityWeapon("idle")) 
                    end
                elseif randInt(2) == 1 then
                    local flags = self:GetCTFFlags()
                    if #flags > 0 then 
                        local flag = flags[randInt(#flags)]
                        self:MoveToPos(flag:GetPos() + Vector(randInt(-50, 50), randInt(-50, 50)))
                        self:StartActivity(self:GetActivityWeapon("idle")) 
                    end
                end
        
                local strafeFunc = function()
                    if self.TypingInChat or !self:IsChasingSomeone() or !self:CanSee(self:GetEnemy()) then return "failed" end
                    self.loco:SetVelocity(self.loco:GetVelocity() + self:GetRight()*(50*randInt(-1, 1)))
                end
        
                local overridePos = nil
                local options = nil
                if !self:CanSee(self:GetEnemy()) then
                    options = {update=true, customfunc=function()
                        if self:CanSee(self:GetEnemy()) then return "abort" end
                    end}
                elseif self:GetRangeSquaredTo(self:GetEnemy()) > (distance*distance) then
                    options = {update=true, tolerance=distance, customfunc=function(path)
                        path:SetGoalTolerance(path:GetLength() <= distance and 500 or 20)
                        if strafe and self:CanSee(self:GetEnemy()) and randInt(5) == 1 then
                            self:CreateThinkFunction("StrafeMovement", 0, randInt(500), strafeFunc)
                        end
                    end}
                elseif self:GetRangeSquaredTo(self:GetEnemy()) < (distance*distance) then
                    local pos = self:GetPos() - self:GetNormalTo(self:GetPos(), self:GetEnemy():GetPos())*-300
                    tracetbl.start = pos
                    tracetbl.endpos = pos - Vector(0,0,200)
                    local downtrace = trace.TraceLine(tracetbl)
                    if !downtrace.Hit or !util.IsInWorld(pos) then pos = self:GetPos() + self:GetNormalTo(self:GetPos(), self:GetEnemy():GetPos())*-300 end
                    
                    overridePos = pos
                    options = {climbladders=false, customfunc=function(path)
                        if !IsValid(self:GetEnemy()) then return "abort" end
                        if self:GetRangeSquaredTo(self:GetEnemy()) > (distance*distance) then return "abort" end
                        self.loco:FaceTowards(self:GetEnemy():GetPos())
                        if path:GetAge() > 0.2 then
                            pos = self:GetPos() - self:GetNormalTo(self:GetPos(), self:GetEnemy():GetPos())*-300
                            downtrace = trace.TraceLine({start = pos, endpos = pos - Vector(0,0,200)})
                            if !downtrace.Hit then pos = self:GetPos() + self:GetNormalTo(self:GetPos(), self:GetEnemy():GetPos())*-300 end
                            path:Compute(self, pos)
                        end
                    end}
                end
        
                if options then
                    self:ZETA_MoveTo(overridePos or self:GetEnemy(), options)
                end
        
                if strafe then
                    self:CreateThinkFunction("StrafeMovement", 0, randInt(500), strafeFunc)
                else
                    self:StartActivity(self:GetActivityWeapon('idle'))
                end
            end
        end



function ENT:ChaseEnemyRanged(enemy,keepdistance,allowstrafe)
    
    if !enemy:IsValid() then return end
    if !keepdistance then keepdistance = 300 end
    if self:GetRangeSquaredTo(enemy:GetPos()) < (keepdistance*keepdistance) then return end
    local path = Path('Follow')
    path:SetMinLookAheadDistance( 20 )
	path:SetGoalTolerance( keepdistance )
	path:Compute( self, enemy:GetPos(),self:PathGenerator() )

    
	if ( !path:IsValid() ) then  return   "failed" end

    self.IsMoving = true -- We are moving


	while ( path:IsValid() and enemy:IsValid() ) do
        
        if self.AbortMove == true then self.AbortMove = false self.IsMoving = false return 'aborted' end 

            if path:GetAge() > 0.1 and !startstrafe then
                path:Compute( self, enemy:GetPos(),self:PathGenerator() )
            end


            if allowstrafe and self:CanSee(enemy) and math.random(1,5) == 1 and !timer.Exists("zetastrafe"..self:EntIndex()) then
                timer.Create("zetastrafe"..self:EntIndex(),0,math.random(1,500),function()
                    if !IsValid(self) then return end
                    if self.TypingInChat then return end
                    if !self:CanSee(enemy) then return end
                    self.loco:SetVelocity(self.loco:GetVelocity()+self:GetRight()*(50*math.random(-1,1)))
                end)
            end





                if GetConVar('zetaplayer_debug'):GetInt() == 1 then
                path:Draw()
                end

            
            if ( self.loco:IsStuck() ) then

                self:HandleStuck()
                self.IsMoving = false

                return "stuck"

            end

            self:CheckForLadders(path, enemy:GetPos())

            self:Avoid()
            self:Adapt()

            path:Update( self )


            coroutine.yield()



	end
    
    self.IsMoving = false

    
	return "ok"

end



function ENT:ChaseEnemyMelee(enemy,keepdistance,allowstrafe)
    
    if !enemy:IsValid() then return end
    if self:GetRangeSquaredTo(enemy:GetPos()) < (keepdistance*keepdistance) then return end
    local path = Path('Follow')
    path:SetMinLookAheadDistance( 20 )
	path:SetGoalTolerance( keepdistance )
	path:Compute( self, enemy:GetPos(),self:PathGenerator() )

    
	if ( !path:IsValid() ) then  return   "failed" end

    self.IsMoving = true -- We are moving


	while ( path:IsValid() and enemy:IsValid() ) do
        
        if self.AbortMove == true then self.AbortMove = false self.IsMoving = false return 'aborted' end 

            if path:GetAge() > 0.1 and !startstrafe then
                path:Compute( self, enemy:GetPos(),self:PathGenerator() )
            end

            

            if self:GetRangeSquaredTo(enemy) <= (150*150) then
                timer.Remove("zetastrafe"..self:EntIndex())
            end

            local wepData = _ZetaWeaponDataTable[ self.Weapon ]
            
            local range = ((wepData != nil and wepData.fireData != nil) and wepData.fireData.range or 48)
            if self:GetRangeSquaredTo(enemy) <= ( range * range ) then
                self:UseMelee(enemy)
            end


            if allowstrafe and self:CanSee(enemy) and math.random(1,5) == 1 and !timer.Exists("zetastrafe"..self:EntIndex()) then
                timer.Create("zetastrafe"..self:EntIndex(),0,math.random(1,500),function()
                    if !IsValid(self) then return end
                    if self.TypingInChat then return end
                    if self.State != 'chasemelee' then return end
                    if !self:CanSee(enemy) then return end
                    self.loco:SetVelocity(self.loco:GetVelocity()+self:GetRight()*(50*math.random(-1,1)))
                end)
            end



                if GetConVar('zetaplayer_debug'):GetInt() == 1 then
                path:Draw()
                end

                
            
            if ( self.loco:IsStuck() ) then

                self:HandleStuck()
                self.IsMoving = false
                return "stuck"

            end

            self:CheckForLadders(path, enemy:GetPos())



            self:Avoid()
            self:Adapt()

            path:Update( self )


            coroutine.yield()



	end
    
    self.IsMoving = false
    
	return "ok"

end



function ENT:ChaseEnemyUntilSeen(enemy)
    if !enemy:IsValid() then return end
    
    local path = Path('Follow')
    path:SetMinLookAheadDistance( 20 )
	path:SetGoalTolerance( 20 )
	path:Compute( self, enemy:GetPos(),self:PathGenerator() )

    timer.Remove("zetastrafe"..self:EntIndex())

    
	if ( !path:IsValid() ) then  return   "failed" end

    self.IsMoving = true -- We are moving

    -- Footstep sounds. There's probably a better way to do this but oh well

	while ( path:IsValid() and enemy:IsValid() ) do
        
        if self.AbortMove == true then self.AbortMove = false self.IsMoving = false timer.Remove('Footstep_snd'..self:EntIndex()) return 'aborted' end 
        if self:CanSee(enemy) then
            return
        end

            if path:GetAge() > 0.1 then
                path:Compute( self, enemy:GetPos(),self:PathGenerator() )
            end
                if GetConVar('zetaplayer_debug'):GetInt() == 1 then
                path:Draw()
                end



            
            if ( self.loco:IsStuck() ) then

                self:HandleStuck()
                self.IsMoving = false
                timer.Remove('Footstep_snd'..self:EntIndex())
                return "stuck"

            end

            self:CheckForLadders(path, enemy:GetPos())



            self:Avoid()
            self:Adapt()

            path:Update( self )


            coroutine.yield()



	end
    
    self.IsMoving = false
    timer.Remove('Footstep_snd'..self:EntIndex())
    
	return "ok"

end



function ENT:BackAwayFromEnemy(enemy,keepdistance,allowstrafe)
    if !enemy:IsValid() then return end
    local path = Path('Follow')
    local pos = self:GetPos()-self:GetNormalTo(self:GetPos(),enemy:GetPos())*-300
    tracetbl.start = pos
    tracetbl.endpos = pos - Vector(0,0,200)
    local downtrace = trace.TraceLine(tracetbl)
    if !downtrace.Hit then
        pos = self:GetPos()+self:GetNormalTo(self:GetPos(),enemy:GetPos())*-300
    end
    path:SetMinLookAheadDistance( 20 )
	path:SetGoalTolerance( 20 )
	path:Compute( self, pos )

    
	if ( !path:IsValid() ) then  return   "failed" end

    self.IsMoving = true -- We are moving


	while ( path:IsValid() and enemy:IsValid() ) do
        if self.AbortMove == true then self.AbortMove = false self.IsMoving = false timer.Remove('Footstep_snd'..self:EntIndex()) return 'aborted' end 

        local pos = self.Enemy:GetPos()
        
        local towards = (pos-self:GetPos()):Angle()[2]
    
    
        local approach = math.ApproachAngle(self:GetAngles()[2],towards,10)
        self:SetAngles(Angle(0,approach,0))

        if self:GetRangeSquaredTo(enemy) > (keepdistance*keepdistance) then return end

            if path:GetAge() > 0.2 then
                
                pos = self:GetPos()-self:GetNormalTo(self:GetPos(),enemy:GetPos())*-300
                local downtrace = trace.TraceLine({
                    start = pos,
                    endpos = pos - Vector(0,0,200)
                    })
                    if !downtrace.Hit then
                        pos = self:GetPos()+self:GetNormalTo(self:GetPos(),enemy:GetPos())*-300
                    end
                path:Compute( self, pos )
            end
                if GetConVar('zetaplayer_debug'):GetInt() == 1 then
                    path:Draw()
                end

                if allowstrafe and self:CanSee(enemy) and math.random(1,5) == 1 and !timer.Exists("zetastrafe"..self:EntIndex()) then
                    timer.Create("zetastrafe"..self:EntIndex(),0,math.random(1,500),function()
                        if !IsValid(self) then return end
                        if self.TypingInChat then return end
                        self.loco:SetVelocity(self.loco:GetVelocity()+self:GetRight()*(50*math.random(-1,1)))
                    end)
                end

            
            if ( self.loco:IsStuck() ) then

                self:HandleStuck()
                self.IsMoving = false
                timer.Remove('Footstep_snd'..self:EntIndex())
                return "stuck"

            end





            self:Avoid()
            self:Adapt()

            path:Update( self )


            coroutine.yield()



	end
    
    self.IsMoving = false
    timer.Remove('Footstep_snd'..self:EntIndex())
    
	return "ok"

end



function ENT:AttackEnemy(ent, delayattack)
    if self.PlayingPoker or !IsValid(ent) then return end

    if self.Weapon != "PHYSGUN" or !self.Grabbing then
        if !self.HasLethalWeapon then self:ChooseLethalWeapon() end
        if !self.HasLethalWeapon then return end
    end

    if math.random(100) <= self.VoiceChance then self:PlayTauntSound() end
    self.Delayattack = delayattack or false
    self:CancelMove()
    self.Enemy = ent
    self:SetState("chase"..(self.HasMelee and "melee" or "ranged"))
    self:SetNW2Bool("zeta_aggressor", true)
end




function ENT:FindEnemy()
    if self.PlayingPoker or !GetConVar("zetaplayer_allowattacking"):GetBool() then return end
    if !self.HasLethalWeapon and (self.Weapon != "PHYSGUN" or !self.Grabbing) then return end

    DebugText("Attempt to attack something")

    local posTargets = self:FindInSight(self.SightDistance, function(ent) return (self:CanTarget(ent)) end)
    if #posTargets > 0 then
        local rndTarget = posTargets[math.random(#posTargets)]
        if IsValid(rndTarget) then
            if self.Weapon == "PHYSGUN" then DebugText("Going to prop kill "..tostring(v)) end
            self:AttackEnemy(rndTarget)
        end
    end
end


function ENT:CanTarget(ent)
    if ent:IsPlayer() and GetConVar('ai_ignoreplayers'):GetInt() == 1 then DebugText('Findenemy: Ignore players is on! Ignoring '..tostring(ent)) return false end
    if ent:GetClass() == 'npc_zetaplayer' and GetConVar('zetaplayer_ignorezetas'):GetInt() == 1 then DebugText('Findenemy: Ignore Zetas is on! Ignoring '..tostring(ent)) return false end
    if ent:GetClass() == 'zeta_vehicle_path' then return false end
    if ent._nozetatarget then return false end
    if self:IsFriendswith(ent) then return false end
    if ent.IsZetaPlayer and self:IsInTeam(ent) then return false end
    if ent:IsPlayer() and self:IsInTeam(ent) then return false end
    if ent.IsZetaPlayer and self.IsAdmin and ent.IsAdmin then return false end
    if self.IsAdmin and GetConVar("zetaplayer_adminrule_rdm"):GetInt() == 1 then return false end
    if ent:IsNPC() or ent:IsNextBot() or ent:IsPlayer() then return true end
end



function ENT:CreateMuzzleFlash(type)
    if !self:IsValid() then return end
    if self.WeaponENT:IsValid() then
    local effect = EffectData()
    effect:SetFlags(type)
    effect:SetAttachment(self.WeaponENT:LookupAttachment('muzzle'))
    effect:SetEntity(self.WeaponENT)
    util.Effect( "MuzzleFlash", effect )
    end
end



function ENT:UseMelee(target)
    local wepData = _ZetaWeaponDataTable[self.Weapon]

    if wepData != nil and wepData.melee then
        self:ShootWeapon(target, wepData.fireData, true)
        return
    end
end


function ENT:Reload()
    if self.IsReloading then return end
    if !IsValid(self.WeaponENT) then return end
    local wepData = _ZetaWeaponDataTable[self.Weapon]
    if wepData != nil then
        local reloadData = wepData.reloadData
        if reloadData != nil then
            self.IsReloading = true
            if reloadData.anim then
                self:AddGesture(reloadData.anim, true)
            end
            
            if reloadData.snds != nil then
                for i = 1, #reloadData.snds do
                    timer.Simple(reloadData.snds[i][1], function() if !IsValid(self.WeaponENT) then return end self.WeaponENT:EmitSound(reloadData.snds[i][2], 80) end)
                end
            end

            local reloadTime = (isfunction(reloadData.time) and reloadData.time(self, self.WeaponENT) or reloadData.time)

            if isstring( reloadData.time ) then
                local func = CompileString( reloadData.time, "[ReloadFunction] Custom Weapon " .. self.PrettyPrintWeapon )
                reloadTime = func( self, self.WeaponENT )
            end


            timer.Create("ZetaFinishReloading"..self:EntIndex(), reloadTime, 1, function()
                if !self:IsValid() then return end
                self.CurrentAmmo = wepData.clip
                self.IsReloading = false
            end)
        end
        return
    end
end



function ENT:ThrowSmokeGrenade(target, playAnim)
    local mainFunc = function()
        local spawnPos = (self:GetPos() + self:GetUp()*60 + self:GetForward()*40 - self:GetRight()*10)
        local grenade = ents.Create("prop_physics")
        grenade:SetModel("models/Weapons/w_eq_smokegrenade_thrown.mdl")
        grenade:SetPos(spawnPos)
        grenade:SetOwner(self)
        grenade:Spawn()

        grenade:SetFriction(0.2)
        grenade:SetGravity(0.4)
        grenade:SetElasticity(0.45)
        grenade.SmokeTbl = {}
        grenade.DidTheSmokeEffect = false
        grenade.DetonatePosition = grenade:GetPos()

        local phys = grenade:GetPhysicsObject()
        if IsValid(phys) then
            local normal = (IsValid(target) and self:GetNormalTo((target:GetPos() + self:GetPos()) / 2, spawnPos) or self:GetForward())
            phys:SetVelocity(normal * 750)
            phys:AddAngleVelocity(Vector(600, math.random(-1200, 1200), 0))
        end

        local entIndex = grenade:GetCreationID()
        hook.Add("EntityEmitSound", "ZetaSmokeGrenade_CollideSounds_"..entIndex, function(sound)
            if !IsValid(grenade) then hook.Remove("EntityEmitSound", "ZetaSmokeGrenade_CollideSounds_"..entIndex) return end
            if sound.Entity != Entity(0) or sound.Pos and sound.Pos:DistToSqr(grenade:GetPos()) > (128*128) or !string.StartWith(sound.SoundName, "physics/plastic/plastic_box_impact_") then return end
            if grenade.DidTheSmokeEffect then return false end

            sound.SoundName = "weapons/smokegrenade/grenade_hit1.wav"
            sound.SoundLevel = 75
            sound.Pitch = 100
            sound.Volume = 1.0
            sound.Channel = CHAN_VOICE
            return true
        end)

        local curStage = 1
        local nextThink = CurTime() + 1.5
        hook.Add("Think", "ZetaSmokeGrenade_Think_"..entIndex, function()
            if !IsValid(grenade) then hook.Remove("Think", "ZetaSmokeGrenade_Think_"..entIndex) return end
            if CurTime() <= nextThink then return end
            
            if curStage == 1 then
                if grenade:GetVelocity():Length() > 0.1 then
                    nextThink = CurTime() + 0.2
                    return
                end

                for i = 1, 5 do
                    local smokeEnt = ents.Create("env_particlesmokegrenade")
                    smokeEnt:SetPos(grenade:GetPos())
                    smokeEnt:SetSaveValue("m_CurrentStage", 1)
                    smokeEnt:Spawn()
                    smokeEnt:Activate()
                    grenade.SmokeTbl[#grenade.SmokeTbl+1] = smokeEnt
                end

                grenade.DidTheSmokeEffect = true
                grenade:SetRenderMode(RENDERMODE_TRANSCOLOR)
                sound.Play("BaseSmokeEffect.Sound", grenade:GetPos())

                _ZETASMOKEGRENADES[entIndex] = grenade:GetPos()
                grenade:CallOnRemove("ZetaSmokeGrenade_RemoveFromList_"..entIndex, function()
                    if !_ZETASMOKEGRENADES[entIndex] then return end
                    _ZETASMOKEGRENADES[entIndex] = nil
                end)

                curStage = 2
                nextThink = CurTime() + 5.0
            elseif curStage == 2 then
                nextThink = CurTime() + 0.05
                local curColor = grenade:GetColor()
                grenade:SetColor(Color(curColor.r, curColor.g, curColor.b, curColor.a - 1))
                if curColor.a <= 0 then
                    grenade:SetRenderMode(RENDERMODE_NONE)
                    grenade:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
                    _ZETASMOKEGRENADES[entIndex] = nil
                    curStage = 3
                    nextThink = CurTime() + 20.0
                end
            elseif curStage == 3 then
                for _, v in ipairs(grenade.SmokeTbl) do
                    if IsValid(v) then v:Remove() end
                end
                grenade:Remove()
                hook.Remove("Think", "ZetaSmokeGrenade_Think_"..entIndex)
            end
        end)
    end

    if playAnim then
        local seq = self:LookupSequence("gesture_item_throw")
        if seq != -1 then self:AddGestureSequence(seq, true) end
        timer.Simple(0.8, function()
            if !IsValid(self) then return end
            mainFunc()
        end)
    else
        mainFunc()
    end
end

function ENT:ThrowFlashbang(target, playAnim)
    local mainFunc = function()
        local spawnPos = (self:GetPos() + self:GetUp()*60 + self:GetForward()*40 - self:GetRight()*10)
        local grenade = ents.Create("prop_physics")
        grenade:SetModel("models/Weapons/w_eq_flashbang_thrown.mdl")
        grenade:SetPos(spawnPos)
        grenade:SetOwner(self)
        grenade:Spawn()
        
        grenade:SetFriction(0.2)
        grenade:SetGravity(0.4)
        grenade:SetElasticity(0.45)
        
        local phys = grenade:GetPhysicsObject()
        if IsValid(phys) then
            local normal = (IsValid(target) and self:GetNormalTo((target:GetPos() + self:GetPos()) / 2, spawnPos) or self:GetForward())
            phys:SetVelocity(normal * 750)
            phys:AddAngleVelocity(Vector(600, math.random(-1200, 1200), 0))
        end

        local entIndex = grenade:EntIndex()
        hook.Add("EntityEmitSound", "ZetaFlashbang_CollideSounds_"..entIndex, function(sound)
            if !IsValid(grenade) then hook.Remove("EntityEmitSound", "ZetaFlashbang_CollideSounds_"..entIndex) return end
            if sound.Entity != Entity(0) or sound.Pos and sound.Pos:DistToSqr(grenade:GetPos()) > (128*128) or !string.StartWith(sound.SoundName, "physics/plastic/plastic_box_impact_") then return end
            sound.SoundName = "weapons/flashbang/grenade_hit1.wav"
            sound.SoundLevel = 75
            sound.Pitch = 100
            sound.Volume = 1.0
            sound.Channel = CHAN_VOICE
            return true
        end)

        timer.Simple(1.5, function()
            if !IsValid(grenade) then return end

            for _, v in ipairs(ents.FindInSphere(grenade:GetPos(), 1500)) do
                if IsValid(v) and (v:IsPlayer() and !GetConVar("ai_ignoreplayers"):GetBool() or v.IsZetaPlayer) and v:Visible(grenade) then
                    if IsValid(self) and !self.IsDead then
                        if v == self and GetConVar("zetaplayer_flashbang_ignorethrower"):GetBool() then continue end
                        if (self:IsFriendswith(v) or self:IsInTeam(v)) and GetConVar("zetaplayer_flashbang_ignoreteammates"):GetBool() then continue end
                    end

                    local eyePos = (v:IsPlayer() and v:EyePos() or v:GetAttachmentPoint("eyes").Pos)                            
                    local adjustedDamage = (4 - (eyePos:Distance(grenade:GetPos()) * (4 / 1500)));
                    if adjustedDamage > 0 then
                        local lookDir = (v:IsPlayer() and v:EyeAngles():Forward() or v:GetForward())
                        local LoS = (grenade:GetPos() - eyePos)
                        local dot = lookDir:Dot(LoS:GetNormalized())         
                            
                        local fadeTime = adjustedDamage * 1.0
                        if dot >= 0.5 then
                            fadeTime = adjustedDamage * 2.5
                            fadeHold = adjustedDamage * 1.25
                        elseif dot >= -0.5 then
                            fadeTime = adjustedDamage * 1.75
                            fadeHold = adjustedDamage * 0.8
                        end
                        fadeTime = fadeTime * 0.4

                        if v:IsPlayer() then
                            local fadeHold = adjustedDamage * 0.25
                            local startingAlpha = 255
                            if dot >= 0.5 then
                                fadeHold = adjustedDamage * 1.25
                            elseif dot >= -0.5 then
                                fadeHold = adjustedDamage * 0.66
                            else
                                startingAlpha = 200
                            end
                            fadeHold = fadeHold * 0.4

                            v:ScreenFade(SCREENFADE.IN, Color(255, 255, 255, startingAlpha), fadeTime, fadeHold)

                            local dist = LoS:Length()
                            local strength = (dist < 600 and 35 or (dist < 800 and 36 or (dist < 1000 and 37 or nil)))
                            if strength != nil then v:SetDSP(strength, false) end
                        else
                            fadeTime = fadeTime * 1.75
                            if fadeTime >= 1.0 then
                                local lastEne = v:GetEnemy()
                                if !v.BlindedByFlashbangT then
                                    v.BlindedByFlashbangT = fadeTime
                                    v:Panic((IsValid(lastEne) and lastEne or grenade:GetOwner()), v.BlindedByFlashbangT, true)
                                    v:AddGesture(ACT_HL2MP_FIST_BLOCK, false)
                                    timer.Create("ZetaFlashbang_FlashExpired_"..v:EntIndex(), fadeTime, 1, function()
                                        if !IsValid(v) then return end
                                        v.BlindedByFlashbangT = nil
                                        v:RemoveGesture(ACT_HL2MP_FIST_BLOCK)

                                        if !IsValid(lastEne) or lastEne:IsPlayer() and !lastEne:Alive() then return end
                                        v:AttackEnemy(lastEne, false)
                                    end)
                                else
                                    v.BlindedByFlashbangT = v.BlindedByFlashbangT + fadeTime
                                    timer.Adjust("ZetaPanicTimeout"..v:EntIndex(), v.BlindedByFlashbangT, nil, nil)
                                    timer.Adjust("ZetaFlashbang_FlashExpired_"..v:EntIndex(), v.BlindedByFlashbangT, nil, nil)
                                end
                            end
                        end
                    end
                end
            end
            
            net.Start("zeta_flashbang_emitflash", true)
                net.WriteInt(entIndex, 32)
                net.WriteVector(grenade:GetPos())
            net.Broadcast()

            grenade:EmitSound("Flashbang.Explode")
            grenade:Remove()
        end)
    end

    if playAnim then
        local seq = self:LookupSequence("gesture_item_throw")
        if seq != -1 then self:AddGestureSequence(seq, true) end
        timer.Simple(0.8, function()
            if !IsValid(self) then return end
            mainFunc()
        end)
    else
        mainFunc()
    end
end

function ENT:ThrowGrenade(target)
    local gesture = "gesture_item_throw"
    local throwforce = 1000
    if IsValid(target) and self:GetRangeSquaredTo(target) < (400*400) then
        throwforce = 400
        gesture = "gesture_item_drop"
    end

    local seq = self:LookupSequence(gesture)
    if seq != -1 then self:AddGestureSequence(seq, true) end
    
    timer.Simple(0.8, function()
        if !IsValid(self) then return end

        local grenade = ents.Create("npc_grenade_frag")
        grenade:SetPos(self:GetPos() + self:GetUp()*60 + self:GetForward()*40 - self:GetRight()*10)
        grenade:Fire("SetTimer",3,0)
        grenade:SetOwner(self)
        grenade:SetHealth(99999)
        grenade:Spawn()

        local phys = grenade:GetPhysicsObject()
        if !IsValid(phys) then return end
        local normal = (IsValid(target) and self:GetNormalTo(target:GetPos(), self:GetPos()) or self:GetForward())
        phys:ApplyForceCenter(normal * throwforce)
        phys:AddAngleVelocity(Vector(500, 600, 0))
    end)
end




function ENT:SourceCut()
    local pos = self:GetPos()

    local beams = {}
    local dist = GetConVar("zetaplayer_sourcecutdistance"):GetInt()

    self:EmitSound("zetaplayer/weapon/katana/sourcecut.wav",160)

    for i=1, 20 do
        beams[i] = ents.Create("base_anim")
        beams[i]:SetModel("models/hunter/plates/plate.mdl")
        beams[i]:SetNoDraw(true)
        beams[i]:SetPos(pos+VectorRand(-dist,dist))
        beams[i]:Spawn()
        util.SpriteTrail( beams[i], 0, color_white, true, 10, 0, 15, 1 / ( 10 + 0 ) * 0.5, "trails/laser" )
    end

    timer.Create("SourceCut",0.1,40,function()
        util.ScreenShake(pos,5,140,2,3000)
        for i=1, 20 do
            beams[i]:SetPos(pos+VectorRand(-dist,dist))
        end
    end)

    

    timer.Simple(3.3,function()
        util.ScreenShake(pos,13,340,4,3000)

        local caughtents = ents.FindInSphere(pos,dist+300)

        for k,v in ipairs(caughtents) do
            if IsValid(v) and v != self then
                v:TakeDamage(4000,self,self)
            end
        end

        for i=1,30 do
            local shard = ents.Create("prop_physics")
            shard:SetModel("models/gibs/glass_shard0"..math.random(1,6)..".mdl")
            shard:SetPos(pos+VectorRand(-dist,dist))
            shard:SetAngles(AngleRand(-180,180))
            shard:Spawn()
            shard:EmitSound("physics/glass/glass_largesheet_break"..math.random(1,3)..".wav")
            local phys = shard:GetPhysicsObject()
            if IsValid(phys) then
                phys:ApplyForceCenter(VectorRand(-400,400))
                phys:SetAngleVelocity(VectorRand(-380,380))
            end
            timer.Simple(10,function()
                if IsValid(shard) then
                    shard:Remove()
                end
            end)
        end
    end)

    timer.Simple(16,function()
        for k,v in ipairs(beams) do
            if IsValid(v) then
                v:Remove()
            end
        end
    end)


end



function ENT:JudgementCut(pos)
    if !IsValid(self.WeaponENT) then return end
    local beams = {}
    local dist = 200

    sound.Play("zetaplayer/weapon/katana/judgementcut.mp3",pos,80,100,1)
    self.WeaponENT:EmitSound("zetaplayer/weapon/katana/judhol.mp3",70)
    for i=1, 5 do
        beams[i] = ents.Create("base_anim")
        beams[i]:SetModel("models/hunter/plates/plate.mdl")
        beams[i]:SetNoDraw(true)
        beams[i]:SetPos(pos+VectorRand(-dist,dist))
        beams[i]:Spawn()
        util.SpriteTrail( beams[i], 0, color_white, true, 10, 0, 10, 1 / ( 10 + 0 ) * 0.5, "trails/laser" )
    end

    timer.Create("judgementcut"..self:EntIndex(),0,40,function()
        util.ScreenShake(pos,2,140,2,300)
        for i=1, 5 do
            beams[i]:SetPos(pos+VectorRand(-dist,dist))
        end
    end)


    for k,v in ipairs(ents.FindInSphere(pos,200)) do
        local dmg = DamageInfo()
        dmg:SetDamageType(DMG_SLASH)
        dmg:SetDamage(math.random(5,40))
        dmg:SetAttacker(self)
        dmg:SetInflictor(self.WeaponENT)
        v:TakeDamageInfo(dmg)
    end

    


    timer.Simple(11,function()
        for k,v in ipairs(beams) do
            if IsValid(v) then
                v:Remove()
            end
        end
    end)


end