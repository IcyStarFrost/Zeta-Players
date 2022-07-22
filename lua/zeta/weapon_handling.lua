-----------------------------------------------
-- Weapon Stuff
--- This is where all of Zeta's weapons and attacks are handled
-----------------------------------------------
AddCSLuaFile()
include('zeta/weapon_tables.lua')

local trace = {}
trace.TraceLine = util.TraceLine
trace.TraceHull = util.TraceHull
trace.QuickTrace = util.QuickTrace
trace.TraceEntity = util.TraceEntity
local tracetbl = {}



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

ENT.WeaponKillIcons = {
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
}


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
        ["WRENCH"] = TF2Mounted,
        ["SCATTERGUN"] = TF2Mounted,
        ["TF2PISTOL"] = TF2Mounted,
        ["TF2SNIPER"] = TF2Mounted,
        ["TF2SHOTGUN"] = TF2Mounted,
        ["BAT"] = TF2Mounted,
        ["SNIPERSMG"] = TF2Mounted,
        ["FORCEOFNATURE"] = TF2Mounted,
        ["GRENADELAUNCHER"] = TF2Mounted,
        ["FLAMETHROWER"] = TF2Mounted,

        ["HL1SMG"] = HL1Mounted,
        ["HL1GLOCK"] = HL1Mounted,
        ["HL1SPAS"] = HL1Mounted,
        ["HL1357"] = HL1Mounted
    }

    ENT.WeaponConVars = {}
    ENT.ExplosiveWeapons = {}
    
    for k, v in pairs(ENT.WeaponDataTable) do
        if mountableWpns[k] == nil or mountableWpns[k] == true then
            local cvarName = "zetaplayer_allow"..string.lower(tostring(k))
            if string.EndsWith(cvarName, "grenade") then cvarName = cvarName.."s" end
            local cvar = GetConVar(cvarName)
            if cvar then 
                local isLethal = (wpnName == "CAMERA" and GetConVar("zetaplayer_allowcameraaslethalweapon") or v.lethal)
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

  local IsValid = IsValid

  function ENT:GetWeapon()
    return self.Weapon
  end


  function ENT:ChangeWeapon(weapon)
    if self.IsMingebag then self.WeaponENT:RemoveEffects(EF_BONEMERGE) end
    local wepData = self.WeaponDataTable[weapon]
    if wepData != nil then
        self.Weapon = weapon
        self:SetNW2String("zeta_weaponname", self.Weapon)
        self:EmitSound('items/ammo_pickup.wav',65)

        if self.IsMoving then
            self:StartActivity(self:GetActivityWeapon("move"))
        else
            self:StartActivity(self:GetActivityWeapon("idle"))
        end

        if !wepData.hidewep then self.WeaponENT:SetMaterial("") else self.WeaponENT:SetMaterial("null") end
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
        end
        return
    end
end


-- This exists so we aren't recreating the same table over and over.
-- This typically gets really heavy when high fire rate weapons such as the MAC10 are constantly firing.
-- Like Mee said, this stuff does build up.
local FireBulletsTABLE = {

}

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
            FireBulletsTABLE.Spread = Vector(fireData.spread+GetConVar("zetaplayer_combatinaccuracy"):GetFloat(),fireData.spread+GetConVar("zetaplayer_combatinaccuracy"):GetFloat(),0)
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

    local wepData = self.WeaponDataTable[self.Weapon]
    if wepData != nil and wepData.range then
        self:ShootWeapon(target, wepData.fireData)
        return
    end
end


        function ENT:CreateShellEject()
            local wepData = self.WeaponDataTable[self.Weapon]
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


function ENT:ChaseEnemy(enemy,run)
    if !enemy:IsValid() then return end
    local path = Path('Follow')
    path:SetMinLookAheadDistance( 500 )
	path:SetGoalTolerance( 60 )
	path:Compute( self, enemy:GetPos(),self:PathGenerator() )
    local time = 0.4
    
	if ( !path:IsValid() ) then  return   "failed" end

    self.IsMoving = true -- We are moving


	while ( path:IsValid() and enemy:IsValid() ) do
        if self.AbortMove == true then self.AbortMove = false self.IsMoving = false return 'aborted' end 







        if path:GetAge() > 0.1 then
            path:Compute( self, enemy:GetPos(),self:PathGenerator() )
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

        path:Update( self )



        self:Avoid()
        self:Adapt()

		coroutine.yield()

	end
    
    self.IsMoving = false

    
	return "ok"

end



function ENT:MoveOnCondition(distance, strafe)
    if !IsValid(self) or !IsValid(self:GetEnemy()) then return end
    
    self:StartActivity(self:GetActivityWeapon('move'))
    self:SetLastActivity(self:GetActivityWeapon('move')) 

    if self.HasFlag and math.random(1,2) == 1 then -- Choose whether to run for dear life to a capture zone
        local zones = self:GetCaptureZones()
        local zone = zones[math.random(#zones)]
        if zone then 
            local rand = VectorRand(-50,50)
            rand[3] = 0
            moveToPos = zone:GetPos()+rand
            self:MoveToPos(moveToPos)
            self:StartActivity(self:GetActivityWeapon('idle')) 

        end
    end

    local strafeFunc = function()
        if self.TypingInChat or !self:IsChasingSomeone() or !self:CanSee(self:GetEnemy()) then return "failed" end
        self.loco:SetVelocity(self.loco:GetVelocity() + self:GetRight()*(50*math.random(-1, 1)))
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
            if strafe and self:CanSee(self:GetEnemy()) and math.random(5) == 1 then
                self:CreateThinkFunction("StrafeMovement", 0, math.random(500), strafeFunc)
            end
        end}
    elseif self:GetRangeSquaredTo(self:GetEnemy()) < (distance*distance) then
        local pos = self:GetPos() - self:GetNormalTo(self:GetPos(), self:GetEnemy():GetPos())*-300
        tracetbl.start = pos
        tracetbl.endpos = pos - Vector(0,0,200)
        local downtrace = trace.TraceLine(tracetbl)
        if !downtrace.Hit then pos = self:GetPos() + self:GetNormalTo(self:GetPos(), self:GetEnemy():GetPos())*-300 end
        
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
        self:CreateThinkFunction("StrafeMovement", 0, math.random(500), strafeFunc)
    else
        self:StartActivity(self:GetActivityWeapon('idle'))
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

            local wepData = self.WeaponDataTable[self.Weapon]
            local range = ((wepData != nil and wepData.fireData != nil) and wepData.fireData.range or 48)
            if self:GetRangeSquaredTo(enemy) <= (range*range) then
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



function ENT:AttackEnemy(ent,delayattack)
    if !IsValid(ent) then return end
    if self.PlayingPoker then return end

    if self.HasLethalWeapon == false then
        self:ChooseLethalWeapon()
    end

    if self.HasMelee then
        if 100 * math.random() < self.VoiceChance then
            self:PlayTauntSound()
        end
        self.Delayattack = delayattack or false
        self:CancelMove()
        self.Enemy = ent
        self:SetState('chase'..(self.HasMelee and 'melee' or 'ranged'))
        self:SetNW2Bool( 'zeta_aggressor', true )
        if 100 * math.random() < self.VoiceChance then
            self:PlayTauntSound()
        end
    else
        self.Delayattack = delayattack or false
        self:CancelMove()
        self.Enemy = ent
        self:SetState('chase'..(self.HasMelee and 'melee' or 'ranged'))
        self:SetNW2Bool( 'zeta_aggressor', true )
        if 100 * math.random() < self.VoiceChance then
            self:PlayTauntSound()
        end
    end
end




function ENT:FindEnemy()
    if !self:IsValid() then return end
    if GetConVar('zetaplayer_allowattacking'):GetInt() == 0 then return end
    if self.PlayingPoker then return end
    DebugText('Attempt to attack something')

    

    if self.Weapon == 'PHYSGUN' and self.Grabbing == true then
        
        local sphere = self:FindInSight(self.SightDistance,function(ent)
            return self:CanTarget(ent)
        end)

        for k,v in RandomPairs(sphere) do
            if IsValid(v) then
                DebugText('Going to prop kill '..tostring(v))

                self.Delayattack = false
                self:CancelMove()
                self:SetEnemy(v)
                self:SetState('chaseranged')
                self:SetNW2Bool( 'zeta_aggressor', true )
                if 100 * math.random() < self.VoiceChance then
                    self:PlayTauntSound()
                end

                break
            end
        end


        
        return 
    end
    if self.HasLethalWeapon == false then return end
    
    
    local sphere = self:FindInSight(self.SightDistance,function(ent)
        return self:CanTarget(ent)
    end)

    for k,v in RandomPairs(sphere) do

        if IsValid(v) then


            
        if self.HasMelee then
            if math.random(1,3) == 1 then
                self:PlayTauntSound()
            end
            self.Delayattack = false
            self:CancelMove()
            self:SetEnemy(v)
            self:SetState('chasemelee')
            self:SetNW2Bool( 'zeta_aggressor', true )
        else
            self.Delayattack = false
            self:CancelMove()
            self:SetEnemy(v)
            self:SetState('chaseranged')
            self:SetNW2Bool( 'zeta_aggressor', true )
            if 100 * math.random() < self.VoiceChance then
                self:PlayTauntSound()
            end
        end
        break
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
    local wepData = self.WeaponDataTable[self.Weapon]

    if wepData != nil and wepData.melee then
        self:ShootWeapon(target, wepData.fireData, true)
        return
    end
end


function ENT:Reload()
    if self.IsReloading then return end
    local wepData = self.WeaponDataTable[self.Weapon]
    if wepData != nil then
        local reloadData = wepData.reloadData
        if reloadData != nil then
            self.IsReloading = true
            if reloadData.anim then
                self:AddGesture(reloadData.anim, true)
            end

            if self.Weapon == "TF2SNIPER" then
                timer.Simple(0.4,function()
                    if !IsValid(self) then return end
                    self:CreateShellEject()
                end)
            end
            
            if reloadData.snds != nil then
                for i = 1, #reloadData.snds do
                    timer.Simple(reloadData.snds[i][1], function() if self:IsValid() then if self.Weapon == "SCATTERGUN" then self:CreateShellEject() end self.WeaponENT:EmitSound(reloadData.snds[i][2], 80) end end)
                end
            end

            local reloadTime = (isfunction(reloadData.time) and reloadData.time(self, self.WeaponENT) or reloadData.time)
            timer.Simple(reloadTime, function()
                if !self:IsValid() then return end
                self.CurrentAmmo = wepData.clip
                self.IsReloading = false
            end)
        end
        return
    end
end



function ENT:ThrowGrenade(target)

    local gesture = "gesture_item_throw"
    

    local throwforce = 1000

    if IsValid(target) and self:GetRangeSquaredTo(target) < (400*400) then
        throwforce = 400
        gesture = "gesture_item_drop"
    end

    local seq,dur = self:LookupSequence(gesture)

    if seq != -1 then
        self:AddGestureSequence(seq,true)
      end
    
    timer.Simple(0.9,function()
        if !IsValid(self) then return end
        local normal = self:GetForward()
        if target and IsValid(target) then
            normal = self:GetNormalTo(target:GetPos(),self:GetPos())
        end
        local grenade = ents.Create("npc_grenade_frag")
        grenade:SetPos(self:GetPos()+Vector(0,0,60)+self:GetForward()*40+self:GetRight()*-10)
        grenade:Fire("SetTimer",3,0)
        grenade:SetOwner(self)
        grenade:SetHealth(99999)
        grenade:Spawn()
        local phys = grenade:GetPhysicsObject()
        if IsValid(phys) then
            phys:ApplyForceCenter( normal*throwforce )
            phys:AddAngleVelocity(Vector(500,600,0))
        end
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

    timer.Create("SourceCut",0,40,function()
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