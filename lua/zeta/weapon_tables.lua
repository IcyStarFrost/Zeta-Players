
AddCSLuaFile()


local math = math
local util = util
local ents = ents
local math = math

local oldisvalid = IsValid

local function IsValid( ent )
    if oldisvalid( ent ) and ent.IsZetaPlayer then
        
        return !ent.IsDead 
    else
        return oldisvalid( ent )
    end
end

-- This exists so we aren't recreating the same table over and over.
-- This typically gets really heavy when high fire rate weapons such as the MAC10 are constantly firing.
-- Like Mee said, this stuff does build up.
local FireBulletsTABLE = {

}

local theklienersnds = {
    "vo/k_lab/kl_comeout.wav",
    "vo/k_lab/kl_dearme.wav",
    "vo/k_lab/kl_cantwade.wav",
    "vo/k_lab/kl_almostforgot.wav",
    "vo/k_lab/kl_bonvoyage.wav",
    "vo/k_lab/kl_blast.wav",
    "vo/k_lab/kl_excellent.wav",
    "vo/k_lab/kl_fiddlesticks.wav",
    "vo/k_lab/kl_waitmyword.wav",
    "vo/k_lab/kl_besokind.wav",
    "vo/k_lab/kl_coaxherout.wav",
    "vo/k_lab/kl_comeout.wav",
    "vo/k_lab/kl_credit.wav",
    "vo/k_lab/kl_debeaked.wav",
    "vo/k_lab/kl_delaydanger.wav",
    "vo/k_lab/kl_diditwork.wav",
    "vo/k_lab/kl_ensconced.wav",
    "vo/k_lab/kl_fewmoments01.wav",
    "vo/k_lab/kl_fewmoments02.wav",
    "vo/k_lab/kl_gordongo.wav",
    "vo/k_lab/kl_gordonthrow.wav",
    "vo/k_lab/kl_mygoodness01.wav",
    "vo/k_lab/kl_opportunetime01.wav",
    "vo/k_lab/kl_wishiknew.wav",
    "vo/k_lab/kl_whatisit.wav",
    "vo/k_lab/kl_thenwhere.wav",
    "vo/k_lab/kl_relieved.wav",
    "vo/k_lab/kl_interference.wav",
    "vo/k_lab2/kl_howandwhen02.wav",

}


function _ZetaRefreshWeaponTable()
_ZetaWeaponDataTable = {

    MP5 = {
        mdl = 'models/weapons/w_smg_mp5.mdl',
        
        hidewep = false,
        offPos = Vector(4,-1,-5),
        offAng = Angle(-10,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 30,
        prettyPrint = 'MP5',

        anims = {
            idle = ACT_HL2MP_IDLE_AR2,
            move = ACT_HL2MP_RUN_AR2,
            jump = ACT_HL2MP_JUMP_AR2,
            crouch = ACT_HL2MP_WALK_CROUCH_AR2,
        },

        fireData = {
            rateMin = 0.09,
            rateMax = 0.09,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/mp5/mp5-1.wav",

            dmgMin = 4,
            dmgMax = 8,
            force = 12,
            num = 1,
            ammo = '9mm',
            spread = 0.11,
            tracer = 'Tracer'
        },

        shellData = {
            name = 'ShellEject',
            offPos = {
                forward = -10,
                right = 0,
                up = 3
            },
            offAng = Angle(0,90,0)
        },

        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
            time = 1.5,
            snds = {
                {0, 'zetaplayer/weapon/mp5/mp5_clipout.wav'},
                {0.7, 'zetaplayer/weapon/mp5/mp5_clipin.wav'},
                {1.4, 'zetaplayer/weapon/mp5/mp5_slideback.wav'}
            }
        }
    }, -- MP5 end

    PISTOL = {
        mdl = 'models/weapons/w_pistol.mdl',
        
        hidewep = false,
        offPos = Vector(3,0,3.5),   
        offAng = Angle(0,180,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 18,
        prettyPrint = 'Pistol',

        anims = {
            idle = ACT_HL2MP_IDLE_PISTOL,
            move = ACT_HL2MP_RUN_PISTOL,
            jump = ACT_HL2MP_JUMP_PISTOL,
            crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
        },

        fireData = {
            rateMin = 0.2,
            rateMax = 0.5,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
            muzzleFlash = 1,
            snd = "weapons/pistol/pistol_fire2.wav",

            dmgMin = 5,
            dmgMax = 10,
            force = 10,
            num = 1,
            ammo = '9mm',
            spread = 0.16,
            tracer = 'Tracer'
        },

        shellData = {
            name = 'ShellEject',
            offPos = {
                forward = 0,
                right = 0,
                up = 3
            },
            offAng = Angle(0,90,0)
        },

        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
            time = 1.5,
            snds = {
                {0, 'weapons/pistol/pistol_reload1.wav'},
            }
        }
    }, -- Pistol end

    CROWBAR = {
        mdl = 'models/weapons/w_crowbar.mdl',
        
        hidewep = false,
        offPos = Vector(0,0,0),   
        offAng = Angle(90,0,-90),
        lethal = true,
        range = false,
        melee = true,
        clip = 1,
        prettyPrint = 'Crowbar',
    
        anims = {
            idle = ACT_HL2MP_IDLE_MELEE,
            move = ACT_HL2MP_RUN_MELEE,
            jump = ACT_HL2MP_JUMP_MELEE,
            crouch = ACT_HL2MP_WALK_CROUCH_MELEE
        },
    
        fireData = {
            range = 48,
            preCallback = function(callback, zeta, wep, target, blockData)
                if CurTime() <= zeta.AttackCooldown then return end
                zeta.AttackCooldown = CurTime() + 0.4
    
                if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE) then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)
                end
                zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE, true)
                zeta:FaceTick(target, 100)
                wep:EmitSound('weapons/iceaxe/iceaxe_swing1.wav',80)
                
                local dmg = DamageInfo()
                dmg:SetDamage(10/GetConVar("zetaplayer_damagedivider"):GetInt())
                dmg:SetAttacker(zeta)
                dmg:SetInflictor(wep)
                dmg:SetDamageType(DMG_CLUB)
                target:TakeDamageInfo(dmg)
                
                target:EmitSound('physics/flesh/flesh_impact_bullet'..math.random(1,5)..'.wav',80)
            end
        },
    },

    STUNSTICK = {
        mdl = 'models/weapons/w_stunbaton.mdl',
        
        hidewep = false,
        offPos = Vector(0,0,7),   
        offAng = Angle(90,0,-90),
        lethal = true,
        range = false,
        melee = true,
        clip = 0,
        prettyPrint = 'Stunstick',
    
        anims = {
            idle = ACT_HL2MP_IDLE_MELEE,
            move = ACT_HL2MP_RUN_MELEE,
            jump = ACT_HL2MP_JUMP_MELEE,
            crouch = ACT_HL2MP_WALK_CROUCH_MELEE
        },
    
        changeCallback = function(callback, zeta, wep)
            if GetConVar('zetaplayer_spawnweapon'):GetString() == 'STUNSTICK' and !wep.CanPlayDeploySnd then 
                wep.CanPlayDeploySnd = true
                return 
            end
            wep:EmitSound('weapons/stunstick/spark'..math.random(3)..'.wav', 75)
        end,
    
        fireData = {
            range = 48,
            preCallback = function(callback, zeta, wep, target, blockData)
                if CurTime() <= zeta.AttackCooldown then return end
                zeta.AttackCooldown = CurTime() + 0.8
    
                if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE) then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)
                end
                zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE, true)
                zeta:FaceTick(target, 100)
                wep:EmitSound('weapons/stunstick/stunstick_swing'..math.random(2)..'.wav', 80)
    
                local dmg = DamageInfo()
                dmg:SetDamage(10/GetConVar("zetaplayer_damagedivider"):GetInt())
                dmg:SetAttacker(zeta)
                dmg:SetInflictor(wep)
                dmg:SetDamageType(bit.bor(DMG_CLUB, DMG_SLASH))
                target:TakeDamageInfo(dmg)
    
                local effect = EffectData()
                effect:SetOrigin(target:GetPos()+target:OBBCenter())
                effect:SetMagnitude(1)
                effect:SetScale(2)
                effect:SetRadius(4)
                util.Effect('Sparks', effect, true, true)
    
                target:EmitSound('weapons/stunstick/stunstick_fleshhit'..math.random(2)..'.wav', 80)
            end
        },
    },

    WRENCH = {
        mdl = "models/zetatf2/weapons/w_wrench.mdl",
        hidewep = false,
        offPos = Vector(0,0,0),   
        offAng = Angle(0,90,0),
        lethal = true,
        range = false,
        melee = true,
        clip = 0,
        prettyPrint = "[TF2] Wrench",
    
        anims = {
            idle = ACT_HL2MP_IDLE_MELEE,
            move = ACT_HL2MP_RUN_MELEE,
            jump = ACT_HL2MP_JUMP_MELEE,
            crouch = ACT_HL2MP_WALK_CROUCH_MELEE
        },
    
        fireData = {
            range = 48,
            preCallback = function(callback, zeta, wep, target, blockData)
                if CurTime() <= zeta.AttackCooldown then return end
                zeta.AttackCooldown = CurTime() + 0.8
    
                if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE) then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)
                end
                zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE, true)
                zeta:FaceTick(target, 100)
                wep:EmitSound("zetaplayer/weapon/tf2/cbar_miss1.wav", 80)
    
                timer.Simple(0.2, function()
                    if !IsValid(zeta) or zeta.IsDead or !IsValid(target) or zeta:GetRangeSquaredTo(target) > (48*48) then return end
    
                    local dmg = DamageInfo()
                    dmg:SetDamage(math.random(35,40) / GetConVar("zetaplayer_damagedivider"):GetInt())
                    dmg:SetAttacker(zeta)
                    dmg:SetInflictor(wep)
                    dmg:SetDamageType(bit.bor(DMG_CLUB, DMG_SLASH))
                    target:TakeDamageInfo(dmg)
    
                    target:EmitSound("zetaplayer/weapon/tf2/cbar_hitbod"..math.random(3)..".wav", 80)
                end)
            end
        },
    }, 

    GRENADE = {
        mdl = 'models/weapons/w_grenade.mdl',
        
        hidewep = false,
        offPos = Vector(0,0,0),   
        offAng = Angle(0,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 1,
        prettyPrint = 'Grenade',

        anims = {
            idle = ACT_HL2MP_IDLE_GRENADE,
            move = ACT_HL2MP_RUN_GRENADE,
            jump = ACT_HL2MP_JUMP_GRENADE,
            crouch = ACT_HL2MP_WALK_CROUCH_GRENADE
        },

        fireData = {
            rateMin = 1.5,
            rateMax = 1.5,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
            muzzleFlash = 1,
            preCallback = function(callback, zeta, wep, target, blockData)
                local blockData = {cooldown = false, anim = false, muzzle = true, shell = true, snd = true, bullet = true, clipRemove = true}
               
                local throwforce = 1000

                if IsValid(target) and zeta:GetRangeSquaredTo(target) < (400*400) then
                    throwforce = 400
                end

                    local normal = zeta:GetForward()
                    if target and IsValid(target) then
                        normal = zeta:GetNormalTo(target:GetPos(),zeta:GetPos())
                    end
                    local grenade = ents.Create("npc_grenade_frag")
                    grenade:SetPos(zeta:GetPos()+Vector(0,0,60)+zeta:GetForward()*40+zeta:GetRight()*-10)
                    grenade:Fire("SetTimer",3,0)
                    grenade:SetSaveValue("m_hThrower",zeta)
                    grenade:SetOwner(zeta)
                    grenade:SetHealth(99999)
                    grenade:Spawn()
                    local phys = grenade:GetPhysicsObject()
                    if IsValid(phys) then
                        phys:ApplyForceCenter( normal*throwforce )
                        phys:AddAngleVelocity(Vector(500,600,0))
                    end



                return blockData
            end,
            postCallback = nil
    
    
        },

    }, 

    NONE = {
        mdl = 'models/hunter/plates/plate.mdl',
        
        hidewep = true,
        offPos = Vector(0,0,0),   
        offAng = Angle(0,0,0),
        lethal = false,
        range = false,
        melee = false,
        clip = 0,
        prettyPrint = 'Holster',

        anims = {
            idle = ACT_HL2MP_IDLE,
            move = ACT_HL2MP_RUN,
            jump = ACT_HL2MP_JUMP_FIST,
            crouch = ACT_HL2MP_WALK_CROUCH
        },

    }, 

    FIST = {
        mdl = 'models/hunter/plates/plate.mdl',
        
        hidewep = true,
        offPos = Vector(0,0,0),   
        offAng = Angle(0,0,0),
        lethal = true,
        range = false,
        melee = true,
        clip = 0,
        prettyPrint = 'Fist',
    
        anims = {
            idle = ACT_HL2MP_IDLE_FIST,
            move = ACT_HL2MP_RUN_FIST,
            jump = ACT_HL2MP_JUMP_FIST,
            crouch = ACT_HL2MP_WALK_CROUCH_FIST
        },
    
        fireData = {
            range = 48,
            preCallback = function(callback, zeta, wep, target, blockData)
                wep.FistCombo = wep.FistCombo or 0
                wep.FistComboResetT = wep.FistComboResetT or CurTime() + 1.0
    
                if CurTime() <= zeta.AttackCooldown then return
                elseif CurTime() > zeta.AttackCooldown + 0.1 then wep.FistCombo = 0 end
    
                zeta.AttackCooldown = CurTime() + 0.9
    
                if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST) then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST)
                end
                zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)
                zeta:FaceTick(target, 100)
                wep:EmitSound('weapons/slam/throw.wav', 80)
    
                timer.Simple(0.2, function()
                    if !IsValid(zeta) or zeta.IsDead or !IsValid(target) or zeta:GetRangeSquaredTo(target) > (48*48) or !IsValid(wep) then return end
                    
                    local dmg = math.random(8, 12)
                    if wep.FistCombo >= 2 then
                        dmg = math.random(12, 24)
                        wep.FistCombo = 0
                    end
    
                    local dmginfo = DamageInfo()
                    dmginfo:SetDamage(dmg/GetConVar("zetaplayer_damagedivider"):GetInt())
                    dmginfo:SetAttacker(zeta)
                    dmginfo:SetInflictor(wep)
                    target:TakeDamageInfo(dmginfo)
    
                    target:EmitSound('physics/body/body_medium_impact_hard'..math.random(6)..'.wav')
                    wep.FistCombo = wep.FistCombo + 1
                end)
            end
        }
    }, 

    KNIFE = {
        mdl = 'models/weapons/w_knife_t.mdl',
        
        hidewep = false,
        offPos = Vector(0,-0.2,-2.5),   
        offAng = Angle(0,0,0),
        lethal = true,
        range = false,
        melee = true,
        clip = 0,
        prettyPrint = 'Knife',
    
        anims = {
            idle = ACT_HL2MP_IDLE_KNIFE,
            move = ACT_HL2MP_RUN_KNIFE,
            jump = ACT_HL2MP_JUMP_KNIFE,
            crouch = ACT_HL2MP_WALK_CROUCH_KNIFE
        },
    
        changeCallback = function(callback, zeta, wep)
            if GetConVar('zetaplayer_spawnweapon'):GetString() == 'KNIFE' and !wep.CanPlayDeploySnd then 
                wep.CanPlayDeploySnd = true
                return 
            end
            wep:EmitSound('weapons/knife/knife_deploy1.wav', 70)
        end,
    
        fireData = {
            range = 48,
            preCallback = function(callback, zeta, wep, target, blockData)
                local firstSwing = false
                if CurTime() <= zeta.AttackCooldown then return
                elseif CurTime() > zeta.AttackCooldown + 0.4 then firstSwing = true end
    
                if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE) then zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE) end
                zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE, true)
    
                zeta:FaceTick(target, 100)
                wep:EmitSound('weapons/knife/knife_slash'..math.random(2)..'.wav', 80)
    
                local isBackstab = false
                local dmg = (firstSwing and 20 or 15)
                if GetConVar('zetaplayer_allowbackstabbing'):GetBool() then
                    local backstabcheck = zeta:WorldToLocalAngles(target:GetAngles() + Angle(0,-90,0))
                    if backstabcheck.y < -30 and backstabcheck.y > -140 then
                        isBackstab = true
                        dmg = target:Health() * 6
                        target:EmitSound('zetaplayer/misc/backstabbed'..math.random(3)..'.wav', 80)
                    end
                end
    
                local dmginfo = DamageInfo()
                dmginfo:SetDamage(dmg/GetConVar("zetaplayer_damagedivider"):GetInt())
                dmginfo:SetAttacker(zeta)
                dmginfo:SetInflictor(wep)
                dmginfo:SetDamageType(DMG_SLASH)
                target:TakeDamageInfo(dmginfo)
    
                zeta.AttackCooldown = CurTime() + (isBackstab and 1.0 or 0.5)
                target:EmitSound('weapons/knife/knife_hit'..math.random(4)..'.wav', 80)
            end
        }
    }, 

    PHYSGUN = {
        mdl = 'models/weapons/w_physics.mdl',
        hidewep = false,
        offPos = Vector(0,-1,3),   
        offAng = Angle(0,-10,20),
        lethal = false,
        range = false,
        melee = false,
        clip = 0,
        prettyPrint = 'Physics Gun',

        anims = {
            idle = ACT_HL2MP_IDLE_PHYSGUN,
            move = ACT_HL2MP_RUN_PHYSGUN,
            jump = ACT_HL2MP_JUMP_PHYSGUN,
            crouch = ACT_HL2MP_WALK_CROUCH_PHYSGUN
        },

    }, 

    TOOLGUN = {
        mdl = 'models/weapons/w_toolgun.mdl',
        
        hidewep = false,
        offPos = Vector(-1.5,0,2.5),   
        offAng = Angle(0,0,0),
        lethal = false,
        range = false,
        melee = false,
        clip = 0,
        prettyPrint = 'Toolgun',

        anims = {
            idle = ACT_HL2MP_IDLE_REVOLVER,
            move = ACT_HL2MP_RUN_REVOLVER,
            jump = ACT_HL2MP_JUMP_REVOLVER,
            crouch = ACT_HL2MP_WALK_CROUCH_REVOLVER
        },

    }, 

    CAMERA = {
        mdl = 'models/maxofs2d/camera.mdl',
        
        hidewep = false,
        offPos = Vector(1.3,3,-1),   
        offAng = Angle(10,0,10),
        lethal = true,
        range = true,
        melee = false,
        clip = 1,
        
        prettyPrint = 'Camera',


        fireData = {
            rateMin = 0.1,
            rateMax = 2,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
            muzzleFlash = 1,
            snd = "weapons/pistol_shoot.wav",
    
            dmgMin = 3,
            dmgMax = 9,
            force = 10,
            num = 1,
            ammo = '9mm',
            spread = 0.16,
            tracer = 'Tracer',
            preCallback  = function(callback, zeta, wep, target, blockData)
                local blockData = {cooldown = false, anim = true, muzzle = true, shell = true, snd = true, bullet = true, clipRemove = true}

                    if 500 * math.random() < 5 then zeta:UseCamera() end

                return blockdata
            end
            
    
    
        },
        

        anims = {
            idle = ACT_HL2MP_IDLE_CAMERA,
            move = ACT_HL2MP_RUN_CAMERA,
            jump = ACT_HL2MP_JUMP_CAMERA,
            crouch = ACT_HL2MP_WALK_CROUCH_CAMERA
        },

    }, 



    DEAGLE = {
        mdl = 'models/weapons/w_pist_deagle.mdl',
        
        hidewep = false,
        offPos = Vector(0,0,-2.2),   
        offAng = Angle(0,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 7,
        prettyPrint = 'Desert Eagle',

        anims = {
            idle = ACT_HL2MP_IDLE_PISTOL,
            move = ACT_HL2MP_RUN_PISTOL,
            jump = ACT_HL2MP_JUMP_PISTOL,
            crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
        },

        fireData = {
            rateMin = 0.5,
            rateMax = 0.5,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/deagle/deagle-1.wav",
            num = 1,
            dmgMin = 16,
            dmgMax = 16,
            force = 10,
            ammo = '357',
            spread = 0.16,
            tracer = 'Tracer'
        },

        shellData = {
            name = 'ShellEject',
            offPos = {
                forward = 0,
                right = 0,
                up = 2
            },
            offAng = Angle(0,90,0)
        },

        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
            time = 1.5,
            snds = {
                {0, 'zetaplayer/weapon/deagle/de_clipout.wav'},
                {0.7, 'zetaplayer/weapon/deagle/de_clipin.wav'},
                {1.4, 'zetaplayer/weapon/deagle/de_slideback.wav'},
            }
        }
    }, 

    TF2PISTOL = {
        mdl = "models/zetatf2/weapons/w_pistol.mdl",
        hidewep = false,
        offPos = Vector(0, 0, 0),   
        offAng = Angle(-5, 0, 0),
        lethal = true,
        range = true,
        melee = false,
        clip = 13,
        prettyPrint = "[TF2] Pistol",
    
        anims = {
            idle = ACT_HL2MP_IDLE_PISTOL,
            move = ACT_HL2MP_RUN_PISTOL,
            jump = ACT_HL2MP_JUMP_PISTOL,
            crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
        },
    
        fireData = {
            rateMin = 0.15,
            rateMax = 0.15,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/tf2/pistol_shoot.wav",
            num = 1,
            dmgMin = 8,
            dmgMax = 9,
            force = 10,
            ammo = "9mm",
            spread = 0.16,
            tracer = "Tracer"
        },
    
        shellData = {
            name = "ShellEject",
            offPos = {
                forward = 2,
                right = 0,
                up = 3
            },
            offAng = Angle(0,-90,0)
        },
    
        reloadData = {
            time = function(zeta, wep)
                local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_PISTOL, true)
                zeta:SetLayerPlaybackRate(layerID, 1.5)
                return 1.02
            end,
            snds = {{0, "zetaplayer/weapon/tf2/pistol_worldreload.wav"}}
        }
    }, 

    RPG = {
        mdl = 'models/weapons/w_rocket_launcher.mdl',
        
        hidewep = false,
        offPos = Vector(13,-1,2),   
        offAng = Angle(10,180,0),
        lethal = true,
        range = true,
        isExplosive = true,
        melee = false,
        keepDistance = 1000,
        clip = 1,
        prettyPrint = 'RPG',

        anims = {
            idle = ACT_HL2MP_IDLE_RPG,
            move = ACT_HL2MP_RUN_RPG,
            jump = ACT_HL2MP_JUMP_RPG,
            crouch = ACT_HL2MP_WALK_CROUCH_RPG
        },

        fireData = {
            rateMin = 3,
            rateMax = 3,    

            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG,
            muzzleFlash = 7,
            snd = 'weapons/rpg/rocketfire1.wav',

            preCallback = function(callback, zeta, wep, target, blockData)
                local behindtrace = util.TraceLine({
                    start = wep:GetPos()+wep:OBBCenter(),
                    endpos = target:GetPos()+target:OBBCenter(),
                    filter = target
                })
                if behindtrace.Hit then blockData = nil return end

                local missilepos = wep:GetAttachment(2).Pos+wep:GetAttachment(2).Ang:Forward()*100+Vector(0,0,15)
                if !util.IsInWorld(missilepos) then blockData = nil return end


                blockData.bullet = true
                blockData.shell = true

                local pos = target:GetPos()+target:OBBCenter()
                if target:GetClass() == "npc_zetaplayer" then pos = target:GetPos() end

                local missile = ents.Create('rpg_missile')
                missile:SetPos(missilepos)
                missile:SetAngles((pos-wep:GetPos()):Angle())
                missile:SetOwner(zeta)
                missile:Spawn()
                
               --[[  if GetConVar("zetaplayer_allowdirectingmissiles"):GetInt() == 1 then
                    timer.Create("zetadirectrocket"..missile:EntIndex(),0,0,function()
                        if !IsValid(missile) then timer.Remove("zetadirectrocket"..missile:EntIndex()) return end
                        if !IsValid(zeta) then timer.Remove("zetadirectrocket"..missile:EntIndex()) return end
                        if !IsValid(target) then timer.Remove("zetadirectrocket"..missile:EntIndex()) return end
                        local pos = target:GetPos()+target:OBBCenter()+VectorRand(-GetConVar("zetaplayer_missileinaccuracy"):GetInt(),GetConVar("zetaplayer_missileinaccuracy"):GetInt())
                        if target:GetClass() == "npc_zetaplayer" then
                            pos = target:GetPos()+VectorRand(-GetConVar("zetaplayer_missileinaccuracy"):GetInt(),GetConVar("zetaplayer_missileinaccuracy"):GetInt())
                        end
                        local targetangle = (pos-missile:GetPos()):Angle()
                        local p = math.ApproachAngle(missile:GetAngles().p, targetangle.p, 1)
                        local y = math.ApproachAngle(missile:GetAngles().y, targetangle.y, 1)
                        local r = math.ApproachAngle(missile:GetAngles().r, targetangle.r, 1)
                        local ang = Angle(p,y,r)
                        missile:SetAngles(ang)
                        missile:SetLocalVelocity(ang:Forward()*1500)
                    end)
                end ]]

                missile:CallOnRemove('missileexplode'..missile:EntIndex(),function()
                    missile:StopSound('weapons/rpg/rocket1.wav')
                    util.BlastDamage(missile,(zeta:IsValid()) and zeta or missile,missile:GetPos(),260,210/GetConVar("zetaplayer_damagedivider"):GetFloat())
                end)

                return blockData
            end
        },

        shellData = {
            name = 'ShellEject',
            offPos = {
                forward = 0,
                right = 0,
                up = 3
            },
            offAng = Angle(0,90,0)
        },

        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
            time = 1.5,
        }
    }, 


    REVOLVER = {
        mdl = 'models/weapons/w_357.mdl',
        
        hidewep = false,
        offPos = Vector(-1,-0.2,2),   
        offAng = Angle(0,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 6,
        prettyPrint = '357 Revolver',

        anims = {
            idle = ACT_HL2MP_IDLE_REVOLVER,
            move = ACT_HL2MP_RUN_REVOLVER,
            jump = ACT_HL2MP_JUMP_REVOLVER,
            crouch = ACT_HL2MP_WALK_CROUCH_REVOLVER
        },

        fireData = {
            rateMin = 0.8,
            rateMax = 0.8,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
            muzzleFlash = 1,
            snd = "weapons/357/357_fire2.wav",
            num = 1,
            dmgMin = 40,
            dmgMax = 40,
            force = 10,
            ammo = '357',
            spread = 0.08,
            tracer = 'Tracer'
        },

        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_REVOLVER,
            time = 2.2,
        }
    }, 

    SMG = {
        mdl = 'models/weapons/w_smg1.mdl',
        
        hidewep = false,
        offPos = Vector(7,-2,5),   
        offAng = Angle(-10,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 45,
        prettyPrint = 'SMG',
    
        anims = {
            idle = ACT_HL2MP_IDLE_SMG1,
            move = ACT_HL2MP_RUN_SMG1,
            jump = ACT_HL2MP_JUMP_SMG1,
            crouch = ACT_HL2MP_WALK_CROUCH_SMG1
        },
    
        fireData = {
            preCallback = function(callback, zeta, wep, target, blockData)
                if math.random(75) == 1 and zeta:GetRangeSquaredTo(target) <= (500*500) then
                    blockData = nil
    
                    zeta.AttackCooldown = CurTime() + math.random(0.55, 0.75)
                    zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG)
                    wep:EmitSound("weapons/ar2/ar2_altfire.wav")
    
                    local vecThrow = ((target:GetPos()+target:OBBCenter())-wep:GetPos()):Angle()
    
                    local grenade = ents.Create('grenade_ar2')
                    grenade:SetPos((zeta:GetPos()+zeta:OBBCenter())+vecThrow:Forward()*32+vecThrow:Up()*32)
                    grenade:SetAngles(vecThrow)
                    grenade:SetOwner(zeta)
                    grenade:Spawn()
                    grenade:SetVelocity(vecThrow:Forward()*1000)
                    grenade:SetLocalAngularVelocity(AngleRand(-400, 400))
                end
    
                return blockData
            end,
    
            rateMin = 0.075,
            rateMax = 0.1,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
            muzzleFlash = 1,
            snd = "weapons/smg1/smg1_fire1.wav",
            num = 1,
            dmgMin = 4,
            dmgMax = 4,
            force = 10,
            ammo = '9mm',
            spread = 0.15,
            tracer = 'Tracer'
        },
    
        shellData = {
            name = 'ShellEject',
            offPos = {
                forward = 0,
                right = 0,
                up = 0
            },
            offAng = Angle(0,90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
            time = 1.5,
            snds = {
                {0, 'weapons/smg1/smg1_reload.wav'},
            }
        }
    }, 


    SHOTGUN = {
        mdl = 'models/weapons/w_shotgun.mdl',
        
        hidewep = false,
        offPos = Vector(14,-1.5,3),   
        offAng = Angle(10,180,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 6,
        prettyPrint = 'Shotgun',
    
        anims = {
            idle = ACT_HL2MP_IDLE_SHOTGUN,
            move = ACT_HL2MP_RUN_SHOTGUN,
            jump = ACT_HL2MP_JUMP_SHOTGUN,
            crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN
        },
    
        fireData = {
            preCallback = function(callback, zeta, wep, target, blockData)
                blockData.shell = true
    
                local pumpSnd = 0.3
                if math.random(4) == 1 and zeta.CurrentAmmo >= 2 and zeta:GetRangeSquaredTo(target) <= (400*400) then
                    pumpSnd = 0.5
                    zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN, true)
    
                    blockData.cooldown = true
                    zeta.AttackCooldown = CurTime() + math.random(1.2, 1.5)
    
                    blockData.snd = true
                    wep:EmitSound("Weapon_Shotgun.Double")
    
                    blockData.bullet = true
                    FireBulletsTABLE.Attacker = zeta
                    FireBulletsTABLE.Damage = (8 / GetConVar("zetaplayer_damagedivider"):GetFloat())
                    FireBulletsTABLE.Force = (2 + GetConVar("zetaplayer_forceadd"):GetInt())
                    FireBulletsTABLE.HullSize = 5
                    FireBulletsTABLE.Spread = Vector(0.15 + zeta.Accuracy, 0.15 + zeta.Accuracy, 0)
                    FireBulletsTABLE.AmmoType = "9mm"
                    FireBulletsTABLE.Num = 12
                    FireBulletsTABLE.TracerName = "Tracer"
                    FireBulletsTABLE.Dir = (target:GetCenteroid() - wep:GetPos()):GetNormalized()
                    FireBulletsTABLE.Src = wep:GetPos()
                    FireBulletsTABLE.IgnoreEntity = zeta
                    wep:FireBullets(FireBulletsTABLE)
    
                    blockData.clipRemove = true 
                    zeta.CurrentAmmo = zeta.CurrentAmmo - 2
                end
    
                timer.Simple(pumpSnd, function()
                    if !IsValid(zeta) or !IsValid(wep) then return end
                    wep:EmitSound("Weapon_Shotgun.Special1")
                    zeta:CreateShellEject()
                end)
    
                return blockData
            end,
    
            rateMin = 1.0,
            rateMax = 1.25,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
            muzzleFlash = 1,
            snd = "Weapon_Shotgun.Single",
            num = 7,
            dmgMin = 8,
            dmgMax = 8,
            force = 2,
            ammo = "Buckshot",
            spread = 0.1,
            tracer = "Tracer"
        },
    
        shellData = {
            name = "ShotgunShellEject",
            offPos = {
                forward = 7,
                right = 0,
                up = 2
            },
            offAng = Angle(0, 90, 0)
        },
    
        onDamageCallback = function(callback, zeta, wep, dmginfo)
            if !zeta.IsReloading or zeta:GetState() != "chaseranged" or !IsValid(dmginfo:GetAttacker()) or !zeta:CanTarget(dmginfo:GetAttacker()) then return end
            zeta.InterruptReloading = true
        end,
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
            time = function(zeta, wep)
                local shellAmount = (6 - zeta.CurrentAmmo)
                local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                timer.Create("zeta_shotgunreload"..wep:EntIndex(), 0.5, shellAmount, function()
                    if !IsValid(zeta) or !IsValid(wep) then return end
                    if zeta.Weapon != "SHOTGUN" then
                        zeta:RemoveGesture(ACT_HL2MP_GESTURE_RELOAD_AR2)
                        timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                        return 
                    end
    
                    local repsLeft = timer.RepsLeft("zeta_shotgunreload"..wep:EntIndex())
                    if zeta.InterruptReloading and (-repsLeft + shellAmount) <= 4 then
                        zeta:SetLayerCycle(layerID, 0.75)
                        zeta.InterruptReloading = false
                        zeta.CurrentAmmo = (-repsLeft + shellAmount)
                        zeta.IsReloading = false
                        timer.Remove("ZetaFinishReloading"..zeta:EntIndex())
                        timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                        return
                    end
    
                    zeta:SetLayerCycle(layerID, 0.2)
                    zeta:SetLayerPlaybackRate(layerID, 1.6)
                    
                    wep:EmitSound("Weapon_Shotgun.Reload")
                    if repsLeft == 0 then
                        timer.Simple(0.4, function()
                            if !IsValid(zeta) or !IsValid(wep) or !zeta:IsValidLayer(layerID) then return end
                            zeta:SetLayerCycle(layerID, 0.75)
                        end)
                    elseif repsLeft == (shellAmount - 1) then
                        timer.Adjust("zeta_shotgunreload"..wep:EntIndex(), 0.4, nil, nil)
                    end
                end)
                
                return (0.93 + 0.4 * shellAmount)
            end
        }
    },


    SCATTERGUN = {
        mdl = "models/zetatf2/weapons/w_scattergun.mdl",
        hidewep = false,
        offPos =  Vector(0, -1.5, 0),   
        offAng = Angle(-10, 0, 0),
        lethal = true,
        range = true,
        melee = false,
        clip = 6,
        prettyPrint = "[TF2] Scatter Gun",
    
        anims = {
            idle = ACT_HL2MP_IDLE_SHOTGUN,
            move = ACT_HL2MP_RUN_SHOTGUN,
            jump = ACT_HL2MP_JUMP_SHOTGUN,
            crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN
        },
    
        fireData = {
            preCallback = function(callback, zeta, wep, target, blockData)
                blockData.anim = true
                blockData.shell = true
    
                if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW) then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW)
                end
                local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW, true)
                zeta:SetLayerCycle(layerID, 0.075)
                timer.Simple(0.2, function()
                    if !IsValid(zeta) or !zeta:IsValidLayer(layerID) then return end
                    zeta:SetLayerBlendOut(layerID, 0.75)
                end)
    
                wep.TargetLastHealth = target:Health()
                return blockData
            end,
    
            rateMin = 0.625,
            rateMax = 0.625,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/tf2/scatter_gun_shoot.wav",
            num = 10,
            dmgMin = 4,
            dmgMax = 6,
            force = 3,
            ammo = "Buckshot",
            spread = 0.2,
            tracer = "Tracer"
        },
    
        shellData = {
            name = "ShotgunShellEject",
            offPos = {
                forward = 7,
                right = 0,
                up = 2
            },
            offAng = Angle(0, -90, 0)
        },
    
        reloadData = {
            time = function(zeta, wep)
                local shellAmount = (6 - zeta.CurrentAmmo)
                local layerID = zeta:AddGestureSequence(zeta:LookupSequence("reload_smg1_alt"), true)
                
                timer.Create("zeta_shotgunreload"..wep:EntIndex(), 0.7, shellAmount, function()
                    if !IsValid(zeta) or !IsValid(wep) then return end
                    if zeta.Weapon != "SCATTERGUN" then
                        zeta:RemoveGesture(ACT_HL2MP_GESTURE_RELOAD_SMG1)
                        timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                        return 
                    end
    
                    local repsLeft = timer.RepsLeft("zeta_shotgunreload"..wep:EntIndex())
                    if (-repsLeft + shellAmount - 1) >= 1 and math.random(2) == 1 and IsValid(zeta:GetEnemy()) and zeta:CanSee(zeta:GetEnemy()) then
                        zeta:RemoveGesture(ACT_HL2MP_GESTURE_RELOAD_SMG1)
                        zeta.CurrentAmmo = (-repsLeft + shellAmount - 1)
                        zeta.IsReloading = false
                        timer.Remove("ZetaFinishReloading"..zeta:EntIndex())
                        timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                        return
                    end
    
                    zeta:SetLayerCycle(layerID, 0.72)
                    zeta:SetLayerPlaybackRate(layerID, 0.8)
    
                    wep:EmitSound("zetaplayer/weapon/tf2/scatter_gun_reload.wav")
                    zeta:CreateShellEject()
    
                    if repsLeft == 0 then
                        timer.Simple(0.4, function()
                            if !IsValid(zeta) or !IsValid(wep) or !zeta:IsValidLayer(layerID) then return end
                            zeta:SetLayerCycle(layerID, 0.81)
                            zeta:SetLayerPlaybackRate(layerID, 1.0)
                        end)
                    elseif repsLeft == (shellAmount - 1) then
                        timer.Adjust("zeta_shotgunreload"..wep:EntIndex(), 0.5, nil, nil)
                    end
                end)
    
                return (0.2 + 0.5 * shellAmount)
            end
        }
    }, 

    CROSSBOW = {
        mdl = "models/weapons/w_crossbow.mdl",
        
        hidewep = false,
        offPos =  Vector(-2,-3,0),   
        offAng = Angle(0,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 1,
        prettyPrint = "Crossbow",
    
        anims = {
            idle = ACT_HL2MP_IDLE_CROSSBOW,
            move = ACT_HL2MP_RUN_CROSSBOW,
            jump = ACT_HL2MP_JUMP_CROSSBOW,
            crouch = ACT_HL2MP_WALK_CROUCH_CROSSBOW
        },
    
        fireData = {
            rateMin = 3,
            rateMax = 3,
    
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW,
            snd = "Weapon_Crossbow.Single",
    
            preCallback = function(callback, zeta, wep, target, blockData)
                blockData.bullet = true
                blockData.muzzle = true
                blockData.shell = true
    
                local dir = (target:GetCenteroid() - wep:GetPos()):Angle()
    
                local bolt = ents.Create("crossbow_bolt")
                bolt:SetPos(zeta:GetCenteroid() + dir:Forward()*64)
                bolt:SetAngles(dir)
                bolt:Spawn()
                bolt:Activate()
                bolt:SetVelocity(dir:Forward()*(zeta:WaterLevel() == 3 and 1500 or 2500))
    
                local flySnd = CreateSound(bolt, "Weapon_Crossbow.BoltFly")
                if flySnd then flySnd:Play() end
                bolt:CallOnRemove("zetabolt_hit"..bolt:EntIndex(), function()                    
                    if flySnd then flySnd:Stop() end
    
                    local find = FindInSphereFilt(bolt:GetPos(), 2, function(ent)
                        return (ent:IsNPC() or ent:IsNextBot() or ent:IsPlayer())
                    end)
                    if !IsValid(find[1]) then return end
                    
                    local dmg = DamageInfo()
                    dmg:SetDamage(100 / GetConVar("zetaplayer_damagedivider"):GetFloat())
                    dmg:SetDamageType(bit.bor(DMG_BULLET, DMG_NEVERGIB))
                    dmg:SetAttacker(zeta or bolt)
                    dmg:SetInflictor(bolt)
                    find[1]:TakeDamageInfo(dmg)
                end)
    
                return blockData
            end
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
            time = 1.8,
            snds = {{1.0, "weapons/crossbow/bolt_load1.wav"}}
        }
    }, 



    AR2 = {
        mdl = 'models/weapons/w_irifle.mdl',
        
        hidewep = false,
        offPos = Vector(12,-1,3),   
        offAng = Angle(10,180,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 30,
        prettyPrint = 'AR2',
    
        anims = {
            idle = ACT_HL2MP_IDLE_AR2,
            move = ACT_HL2MP_RUN_AR2,
            jump = ACT_HL2MP_JUMP_AR2,
            crouch = ACT_HL2MP_WALK_CROUCH_AR2
        },
    
        fireData = {
            rateMin = 0.13,
            rateMax = 0.13,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
            muzzleFlash = 5,
            snd = "weapons/ar2/fire1.wav",
            num = 1,
            dmgMin = 2,
            dmgMax = 6,
            force = 16,
            ammo = 'Pulse ammo',
            spread = 0.1,
            tracer = 'AR2Tracer',

            -- Called before playing fire animation
            preCallback = function(callback, zeta, wep, target, blockData)
                if GetConVar('zetaplayer_allowar2altfire'):GetInt() == 1 and math.random(1,100) == 1 then 
                    zeta:FireAR2Orb(target)
                    blockData = nil
                end
                return blockData
            end,
    
            -- Called after firing a bullet and removing bullet from clip
            postCallback = nil

        },

    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
            time = 1.5,
            snds = {
                {0, 'weapons/ar2/ar2_reload.wav'},
            }
        }
    }, 

    TF2SHOTGUN = {
        mdl = "models/zetatf2/weapons/w_shotgun.mdl",
        hidewep = false,
        offPos = Vector(0, 0, 0),   
        offAng = Angle(-10, 0, 0),
        lethal = true,
        range = true,
        melee = false,
        clip = 6,
        prettyPrint = "[TF2] Shotgun",
    
        anims = {
            idle = ACT_HL2MP_IDLE_SHOTGUN,
            move = ACT_HL2MP_RUN_SHOTGUN,
            jump = ACT_HL2MP_JUMP_SHOTGUN,
            crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN
        },
    
        fireData = {
            preCallback = function(callback, zeta, wep, target, blockData)
                blockData.shell = true
                timer.Simple(0.4, function()
                    if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "TF2SHOTGUN" then return end
                    wep:EmitSound("zetaplayer/weapon/tf2/shotgun_cock_back.wav")
                    zeta:CreateShellEject()
                end)
                timer.Simple(0.55, function()
                    if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "TF2SHOTGUN" then return end
                    wep:EmitSound("zetaplayer/weapon/tf2/shotgun_cock_forward.wav")
                end)
    
                return blockData
            end,
    
            rateMin = 0.625,
            rateMax = 0.625,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/tf2/shotgun_shoot.wav",
    
            dmgMin = 4,
            dmgMax = 5,
            force = 4,
            num = 10,
            ammo = "Buckshot",
            spread = 0.2,
            tracer = "Tracer"
        },
    
        shellData = {
            name = "ShotgunShellEject",
            offPos = {
                forward = 1,
                right = 2,
                up = 1
            },
            offAng = Angle(0, 90, 0)
        },
    
        reloadData = {
            time = function(zeta, wep)
                local shellAmount = (6 - zeta.CurrentAmmo)
                local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                
                timer.Create("zeta_shotgunreload"..wep:EntIndex(), 0.44, shellAmount, function()
                    if !IsValid(zeta) or !IsValid(wep) then return end
                    if zeta.Weapon != "TF2SHOTGUN" then
                        zeta:RemoveGesture(ACT_HL2MP_GESTURE_RELOAD_AR2)
                        timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                        return 
                    end
    
                    local repsLeft = timer.RepsLeft("zeta_shotgunreload"..wep:EntIndex())
                    if (-repsLeft + shellAmount - 1) >= 1 and math.random(2) == 1 and IsValid(zeta:GetEnemy()) and zeta:CanSee(zeta:GetEnemy()) then
                        zeta:RemoveGesture(ACT_HL2MP_GESTURE_RELOAD_AR2)
                        zeta.CurrentAmmo = (-repsLeft + shellAmount - 1)
                        zeta.IsReloading = false
                        timer.Remove("ZetaFinishReloading"..zeta:EntIndex())
                        timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                        return
                    end
    
                    zeta:SetLayerCycle(layerID, 0.2)
                    zeta:SetLayerPlaybackRate(layerID, 1.6)
                    
                    wep:EmitSound("zetaplayer/weapon/tf2/shotgun_reload.wav")
    
                    if repsLeft == 0 then
                        timer.Simple(0.4, function()
                            if !IsValid(zeta) or !IsValid(wep) or !zeta:IsValidLayer(layerID) then return end
                            zeta:SetLayerCycle(layerID, 0.75)
                        end)
                    elseif repsLeft == (shellAmount - 1) then
                        timer.Adjust("zeta_shotgunreload"..wep:EntIndex(), 0.51, nil, nil)
                    end
                end)
    
                return (0.44 + 0.51 * shellAmount)
            end
        }
    }, 


    TF2SHOTGUN = {
        mdl = 'models/zetatf2/weapons/w_shotgun.mdl',
        nobonemerge = true,
        hidewep = false,
        offPos = Vector(0,0,0),   
        offAng = Angle(-10,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 6,
        prettyPrint = 'TF2 Shotgun',
    
        anims = {
            idle = ACT_HL2MP_IDLE_SHOTGUN,
            move = ACT_HL2MP_RUN_SHOTGUN,
            jump = ACT_HL2MP_JUMP_SHOTGUN,
            crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN
        },
    
        fireData = {
            rateMin = 0.625,
            rateMax = 0.625,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/tf2/shotgun_shoot.wav",
            
            dmgMin = 5,
            dmgMax = 5,
            force = 6,
            num = 10,
            ammo = 'buckshot',
            spread = 0.2,
            tracer = 'Tracer'
        },
    
        shellData = {
            name = 'ShotgunShellEject',
            offPos = {
                forward = 0,
                right = 0,
                up = 1
            },
            offAng = Angle(0,90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
            time = 2.3,
            snds = {
                {2, 'zetaplayer/weapon/tf2/shotgun_cock_back.wav'},
                {2.2, 'zetaplayer/weapon/tf2/shotgun_cock_forward.wav'},
            }
        }
    }, 

    AWP = {
        mdl = 'models/weapons/w_snip_awp.mdl',
        
        hidewep = false,
        offPos = Vector(11,-1,-3),   
        offAng = Angle(-10,0,0),
        lethal = true,
        range = true,
        keepDistance = 1000,
        melee = false,
        clip = 10,
        prettyPrint = 'AWP',
    
        anims = {
            idle = ACT_HL2MP_IDLE_AR2,
            move = ACT_HL2MP_RUN_AR2,
            jump = ACT_HL2MP_JUMP_AR2,
            crouch = ACT_HL2MP_WALK_CROUCH_AR2
        },

        fireData = {
            rateMin = 1,
            rateMax = 1,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/awp/awp1.wav",

            dmgMin = 90,
            dmgMax = 90,
            force = 70,
            num = 1,
            ammo = 'awp',
            spread = 0.1,
            tracer = 'Tracer',

            -- Called before playing fire animation
            preCallback = function(callback, zeta, wep, target, blockData)
                blockData.shell = true
                timer.Simple(0.2,function()
                    if !zeta:IsValid() or !IsValid(wep) then return end
                    wep:EmitSound('zetaplayer/weapon/awp/awp_bolt.wav',80)
                    zeta:CreateShellEject()
                end)
                timer.Simple(0.5,function()
                    if !zeta:IsValid() or !IsValid(wep) then return end
                    wep:EmitSound('zetaplayer/weapon/awp/awp_bolt.wav',80)
                end)

                if GetConVar("zetaplayer_allowmlgshots"):GetInt() == 1 and math.random(1,20) == 1 then
                    wep:EmitSound('zetaplayer/weapon/awp/awp_crit.wav',80)

                    blockData.bullet = true
                    local pos = target:GetPos()+target:OBBCenter()

                    FireBulletsTABLE.Attacker = zeta
                    FireBulletsTABLE.Damage = 200/GetConVar("zetaplayer_damagedivider"):GetFloat()
                    FireBulletsTABLE.Force = 70+GetConVar("zetaplayer_forceadd"):GetInt()
                    FireBulletsTABLE.HullSize = 5
                    FireBulletsTABLE.AmmoType = 'awp'
                    FireBulletsTABLE.TracerName = 'Tracer'
                    FireBulletsTABLE.Dir = (pos-wep:GetPos()):GetNormalized()
                    FireBulletsTABLE.Src = wep:GetPos()
                    FireBulletsTABLE.Spread = Vector(0,0,0)
                    FireBulletsTABLE.IgnoreEntity = zeta

                    wep:FireBullets(FireBulletsTABLE)
                end

                return blockData
            end
        },
    
    
        shellData = {
            name = 'RifleShellEject',
            offPos = {
                forward = 10,
                right = 0,
                up = 3
            },
            offAng = Angle(0,-90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
            time = 1.5,
            snds = {
                {0, 'zetaplayer/weapon/awp/awp_clipout.wav'},
                {0.7, 'zetaplayer/weapon/awp/awp_clipin.wav'},
                {1.4, 'zetaplayer/weapon/awp/awp_bolt.wav'},
            }
        }
    }, 


    M4A1 = {
        mdl = 'models/weapons/w_rif_m4a1.mdl',
        
        hidewep = false,
        offPos = Vector(10,-1,-2),   
        offAng = Angle(-10,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 30,
        prettyPrint = 'M4A1',
    
        anims = {
            idle = ACT_HL2MP_IDLE_AR2,
            move = ACT_HL2MP_RUN_AR2,
            jump = ACT_HL2MP_JUMP_AR2,
            crouch = ACT_HL2MP_WALK_CROUCH_AR2
        },
    
        changeCallback = function(callback, zeta, wep)
            wep:EmitSound("zetaplayer/weapon/m4a1/m4a1_deploy.wav", 70, math.random(98, 102), 1, CHAN_WEAPON)
            timer.Simple(0.6, function()
                if !IsValid(wep) then return end
                wep:EmitSound("zetaplayer/weapon/m4a1/m4a1_boltpull.wav", 70, math.random(98, 102), 1, CHAN_WEAPON)
            end)
    
            if !wep.M4A1_HasSilencer then
                wep.M4A1_HasSilencer = (wep.M4A1_HasSilencer or math.random(2) == 1)
                if wep.M4A1_HasSilencer == true then
                    _ZetaWeaponDataTable["M4A1"].mdl = "models/weapons/w_rif_m4a1_silencer.mdl"
                    _ZetaWeaponDataTable["M4A1"].fireData.muzzleFlash = 0
                    _ZetaWeaponDataTable["M4A1"].fireData.dmgMin = 3
                    _ZetaWeaponDataTable["M4A1"].fireData.dmgMax = 7
                    _ZetaWeaponDataTable["M4A1"].fireData.spread = 0.10
                    wep:SetModel("models/weapons/w_rif_m4a1_silencer.mdl")
                end
            end
        end,
    
        fireData = {
            rateMin = 0.11,
            rateMax = 0.11,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/m4a1/m4a1_unsil-1.wav",
    
            dmgMin = 4,
            dmgMax = 10,
            force = 15,
            ammo = 'Pulse ammo',
            spread = 0.15,
            tracer = 'Tracer',
    
            preCallback = function(callback, zeta, wep, target, blockData)
                if wep.M4A1_HasSilencer == true then
                    blockData.snd = true
                    wep:EmitSound("zetaplayer/weapon/m4a1/m4a1-1.wav", 70, math.random(98, 102), 1, CHAN_WEAPON)
                end
                return blockData
            end
        },
    
        shellData = {
            name = 'RifleShellEject',
            offPos = {
                forward = 10,
                right = 0,
                up = 3
            },
            offAng = Angle(0,-90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
            time = 1.5,
            snds = {
                {0, 'zetaplayer/weapon/m4a1/m4a1_clipout.wav'},
                {0.7, 'zetaplayer/weapon/m4a1/m4a1_clipin.wav'},
                {1.4, 'zetaplayer/weapon/m4a1/m4a1_boltpull.wav'},
            }
        }
    }, 

    MACHINEGUN = {
        mdl = 'models/weapons/w_mach_m249para.mdl',
        
        hidewep = false,
        offPos = Vector(10,-1,-3),   
        offAng = Angle(-10,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 200,
        prettyPrint = 'M249 Para',
    
        anims = {
            idle = ACT_HL2MP_IDLE_AR2,
            move = ACT_HL2MP_RUN_AR2,
            jump = ACT_HL2MP_JUMP_AR2,
            crouch = ACT_HL2MP_WALK_CROUCH_AR2
        },
    
        fireData = {
            rateMin = 0.075,
            rateMax = 0.075,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/m249/m249-1.wav",
    
            dmgMin = 3,
            dmgMax = 6,
            force = 16,
            ammo = 'Pulse ammo',
            spread = 0.25,
            tracer = 'Tracer'
        },
    
        shellData = {
            name = 'RifleShellEject',
            offPos = {
                forward = 10,
                right = 0,
                up = 3
            },
            offAng = Angle(0,-90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
            time = 1.5,
            snds = {
                {0, 'zetaplayer/weapon/m249/m249_boxout.wav'},
                {0.7, 'zetaplayer/weapon/m249/m249_boxin.wav'},
                {1.4, 'zetaplayer/weapon/m249/m249_coverdown.wav'},
            }
        }
    }, 

    AK47 = {
        mdl = 'models/weapons/w_rif_ak47.mdl',
        
        hidewep = false,
        offPos = Vector(10,-1,-2),   
        offAng = Angle(-10,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 30,
        prettyPrint = 'AK47',
    
        anims = {
            idle = ACT_HL2MP_IDLE_AR2,
            move = ACT_HL2MP_RUN_AR2,
            jump = ACT_HL2MP_JUMP_AR2,
            crouch = ACT_HL2MP_WALK_CROUCH_AR2
        },
    
        fireData = {
            rateMin = 0.13,
            rateMax = 0.13,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/ak47/ak47-1.wav",
    
            dmgMin = 8,
            dmgMax = 13,
            force = 20,
            ammo = 'Pulse ammo',
            spread = 0.13,
            tracer = 'Tracer'
        },
    
        shellData = {
            name = 'RifleShellEject',
            offPos = {
                forward = 10,
                right = 0,
                up = 3
            },
            offAng = Angle(0,-90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
            time = 1.5,
            snds = {
                {0, 'zetaplayer/weapon/ak47/ak47_clipout.wav'},
                {0.7, 'zetaplayer/weapon/ak47/ak47_clipin.wav'},
                {1.4, 'zetaplayer/weapon/ak47/ak47_boltpull.wav'},
            }
        }
    }, 

    JPG = {
        mdl = 'models/zetaplayers/weapons/w_junk_launcher.mdl',
        
        hidewep = false,
        offPos = Vector(13,-1,2),   
        offAng = Angle(10,180,0),
        projectile = true,
        lethal = true,
        range = true,
        melee = false,
        clip = 1,
        prettyPrint = 'Junk Launcher',

        anims = {
            idle = ACT_HL2MP_IDLE_RPG,
            move = ACT_HL2MP_RUN_RPG,
            jump = ACT_HL2MP_JUMP_RPG,
            crouch = ACT_HL2MP_WALK_CROUCH_RPG
        },

        fireData = {
            rateMin = 3,
            rateMax = 3,    

            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG,
            snd = 'weapons/grenade_launcher1.wav',

            preCallback = function(callback, zeta, wep, target, blockData)
                local behindtrace = util.TraceLine({
                    start = wep:GetPos()+wep:OBBCenter(),
                    endpos = target:GetPos()+target:OBBCenter(),
                    filter = target
                })
                if behindtrace.Hit then blockData = nil return end

                local spawnPos = wep:GetAttachment(2).Pos+wep:GetAttachment(2).Ang:Forward()*100+Vector(0,0,15)
                if !util.IsInWorld(spawnPos) then blockData = nil return end

                blockData.bullet = true
                blockData.shell = true
                blockData.muzzle = true

                local pos = target:GetPos()+target:OBBCenter()
                local function ThrowJunk()
                    local mdls = {
                        "models/props_junk/garbage_milkcarton001a.mdl",
                        "models/props_junk/garbage_milkcarton002a.mdl",
                        "models/props_junk/garbage_metalcan002a.mdl",
                        "models/props_junk/garbage_metalcan001a.mdl",
                        "models/props_junk/garbage_glassbottle002a.mdl",
                        "models/props_junk/garbage_plasticbottle002a.mdl",
                        "models/props_junk/garbage_plasticbottle003a.mdl",
                        "models/props_junk/garbage_newspaper001a.mdl",
                        "models/props_junk/garbage_bag001a.mdl",
                        "models/props_junk/glassjug01.mdl",
                        "models/props_junk/GlassBottle01a.mdl",
                        "models/props_junk/garbage_takeoutcarton001a.mdl",
                        "models/props_junk/plasticbucket001a.mdl",
                        "models/props_junk/PopCan01a.mdl",
                        "models/props_interiors/pot02a.mdl"
                    }
                    local shootAng = (pos - spawnPos):Angle()

                    local ent = ents.Create("prop_physics")
                    ent:SetModel(mdls[math.random(#mdls)])
                    ent:SetPos(spawnPos)
                    ent:SetAngles(shootAng)
                    ent.IsZetaProp = true
                    ent:Spawn()

                    local velocity = shootAng:Forward()

                    velocity = velocity * 100000
                    velocity = velocity + (VectorRand() * 5000)
                    ent:GetPhysicsObject():ApplyForceCenter(velocity)

                    if GetConVar("zetaplayer_removepropsondeath"):GetInt() == 1 then
                        zeta:DeleteOnRemove(ent)
                    end
                    local propCallback = ent:AddCallback('PhysicsCollide', function(ent, data)
                        local dmg = data.HitSpeed:Length()
                        if IsValid(ent) and IsValid(data.HitEntity) and data.HitEntity != zeta and dmg >= 750 then
                            local propDmg = DamageInfo()
                            propDmg:SetDamage(dmg)
                            propDmg:SetInflictor(ent)
                            propDmg:SetAttacker(zeta)
                            propDmg:SetDamageType(DMG_CRUSH)
                            propDmg:SetDamageForce(data.OurOldVelocity*20)
                            data.HitEntity:TakeDamageInfo(propDmg)
                        end
                    end)
                    timer.Simple(5, function() if IsValid(ent) then ent:RemoveCallback('PhysicsCollide', propCallback) end end)

                    timer.Simple(45, function() if IsValid(ent) then ent:Remove() end end)
                end

                for i = 1, GetConVar("zetaplayer_jpgpropamount"):GetInt() do
                    ThrowJunk()
                end

                return blockData
            end
        },

        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
            time = 1.5,
        }
    },

    SCOUT = {
        mdl = 'models/weapons/w_snip_scout.mdl',
        hidewep = false,
        offPos = Vector(11,-1,-3),   
        offAng = Angle(-10,0,0),
        lethal = true,
        range = true,
        keepDistance = 1000,
        melee = false,
        clip = 10,
        prettyPrint = 'Steyr Scout',
    
        anims = {
            idle = ACT_HL2MP_IDLE_AR2,
            move = ACT_HL2MP_RUN_AR2,
            jump = ACT_HL2MP_JUMP_AR2,
            crouch = ACT_HL2MP_WALK_CROUCH_AR2
        },
    
        fireData = {
            rateMin = 1,
            rateMax = 1,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/scout/scout_fire-1.wav",

            dmgMin = 55,
            dmgMax = 55,
            force = 30,
            num = 1,
            ammo = 'scout',
            spread = 0.066,
            tracer = 'Tracer',

            -- Called before playing fire animation
            preCallback = function(callback, zeta, wep, target, blockData)
                blockData.shell = true
                timer.Simple(0.2,function()
                    if !zeta:IsValid() or !IsValid(wep) then return end
                    wep:EmitSound('zetaplayer/weapon/scout/scout_bolt.wav',80)
                    zeta:CreateShellEject()
                end)

                if GetConVar("zetaplayer_allowmlgshots"):GetInt() == 1 and math.random(1,15) == 1 then
                    wep:EmitSound('zetaplayer/weapon/awp/awp_crit.wav',80)

                    blockData.bullet = true
                    local pos = target:GetPos()+target:OBBCenter()

                    FireBulletsTABLE.Attacker = zeta
                    FireBulletsTABLE.Damage = 115/GetConVar("zetaplayer_damagedivider"):GetFloat()
                    FireBulletsTABLE.Force = 30+GetConVar("zetaplayer_forceadd"):GetInt()
                    FireBulletsTABLE.HullSize = 5
                    FireBulletsTABLE.AmmoType = 'scout'
                    FireBulletsTABLE.TracerName = 'Tracer'
                    FireBulletsTABLE.Dir = (pos-wep:GetPos()):GetNormalized()
                    FireBulletsTABLE.Src = wep:GetPos()
                    FireBulletsTABLE.Spread = Vector(0,0,0)
                    FireBulletsTABLE.IgnoreEntity = zeta


                    wep:FireBullets(FireBulletsTABLE)
                end

                return blockData
            end
        },

        shellData = {
            name = 'RifleShellEject',
            offPos = {
                forward = -6,
                right = -1,
                up = 6
            },
            offAng = Angle(0,-90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
            time = 1.5,
            snds = {
                {0, 'zetaplayer/weapon/scout/scout_clipout.wav'},
                {0.7, 'zetaplayer/weapon/scout/scout_clipin.wav'},
                {1.4, 'zetaplayer/weapon/scout/scout_bolt.wav'},
            }
        }
    }, 
	
    P90 = {
        mdl = 'models/weapons/w_smg_p90.mdl',
        hidewep = false,
        offPos = Vector(4,-1,-3),   
        offAng = Angle(-10,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 50,
        prettyPrint = 'P90',
    
        anims = {
            idle = ACT_HL2MP_IDLE_SMG1,
            move = ACT_HL2MP_RUN_SMG1,
            jump = ACT_HL2MP_JUMP_SMG1,
            crouch = ACT_HL2MP_WALK_CROUCH_SMG1
        },
    
        fireData = {
            rateMin = 0.08,
            rateMax = 0.08,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/p90/p90-1.wav",

            dmgMin = 2,
            dmgMax = 5,
            force = 7,
            num = 1,
            ammo = 'SMG1',
            spread = 0.175,
            tracer = 'Tracer',
        },

        shellData = {
            name = 'ShellEject',
            offPos = {
                forward = -0,
                right = 0,
                up = 7
            },
            offAng = Angle(0,-90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
            time = 1.5,
            snds = {
                {0, 'zetaplayer/weapon/p90/p90_cliprelease.wav'},
                {0.3, 'zetaplayer/weapon/p90/p90_clipout.wav'},
                {0.7, 'zetaplayer/weapon/p90/p90_clipin.wav'},
                {1.3, 'zetaplayer/weapon/p90/p90_boltpull.wav'},
            }
        }
    },

    XM1014 = {
        mdl = "models/weapons/w_shot_xm1014.mdl",
        hidewep = false,
        offPos = Vector(11, -1.5, -2),   
        offAng = Angle(-5, 0, 0),
        lethal = true,
        range = true,
        melee = false,
        clip = 7,
        prettyPrint = "XM1014",
    
        anims = {
            idle = ACT_HL2MP_IDLE_SHOTGUN,
            move = ACT_HL2MP_RUN_SHOTGUN,
            jump = ACT_HL2MP_JUMP_SHOTGUN,
            crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN
        },
    
        fireData = {
            rateMin = 0.4,
            rateMax = 0.4,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/xm1014/xm1014-1.wav",
            num = 6,
            dmgMin = 7,
            dmgMax = 9,
            force = 3,
            ammo = "Buckshot",
            spread = 0.225,
            tracer = "Tracer"
        },
    
        shellData = {
            name = "ShotgunShellEject",
            offPos = {
                forward = -3,
                right = 1,
                up = 6
            },
            offAng = Angle(0, -90, 0)
        },
    
        onDamageCallback = function(callback, zeta, wep, dmginfo)
            if !zeta.IsReloading or zeta:GetState() != "chaseranged" or !IsValid(dmginfo:GetAttacker()) or !zeta:CanTarget(dmginfo:GetAttacker()) then return end
            zeta.InterruptReloading = true
        end,
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
            time = function(zeta, wep)
                local shellAmount = (7 - zeta.CurrentAmmo)
                local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                timer.Create("zeta_shotgunreload"..wep:EntIndex(), 0.5, shellAmount, function()
                    if !IsValid(zeta) or !IsValid(wep) then return end
                    if zeta.Weapon != "XM1014" then
                        zeta:RemoveGesture(ACT_HL2MP_GESTURE_RELOAD_AR2)
                        timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                        return 
                    end
    
                    local repsLeft = timer.RepsLeft("zeta_shotgunreload"..wep:EntIndex())
                    if zeta.InterruptReloading and (-repsLeft + shellAmount) <= 5 then
                        zeta:SetLayerCycle(layerID, 0.75)
                        zeta.InterruptReloading = false
                        zeta.CurrentAmmo = (-repsLeft + shellAmount)
                        zeta.IsReloading = false
                        timer.Remove("ZetaFinishReloading"..zeta:EntIndex())
                        timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                        return
                    end
    
                    zeta:SetLayerCycle(layerID, 0.2)
                    zeta:SetLayerPlaybackRate(layerID, 1.6)
    
                    wep:EmitSound("zetaplayer/weapon/xm1014/xm1014_insertshell.wav", nil, nil, nil, CHAN_ITEM)
                    if repsLeft == 0 then
                        timer.Simple(0.5, function()
                            if !IsValid(zeta) or !IsValid(wep) or !zeta:IsValidLayer(layerID) then return end
                            zeta:SetLayerCycle(layerID, 0.75)
                        end)
                    end
                end)
                
                return (1.0 + 0.5 * shellAmount)
            end
        }
    },

    HACKSMONITORS = {
        mdl = 'models/hunter/plates/plate.mdl',
        hidewep = true,
        offPos = Vector(0,0,0),   
        offAng = Angle(0,0,0),
        projectile = true,
        lethal = true,
        range = true,
        melee = false,
        clip = 1,
        prettyPrint = 'Anti Hacks Monitors',
    
        anims = {
            idle = ACT_HL2MP_IDLE_MAGIC,
            move = ACT_HL2MP_RUN_MAGIC,
            jump = ACT_HL2MP_JUMP_MAGIC,
            crouch = ACT_HL2MP_WALK_CROUCH_MAGIC
        },
    
        fireData = {
            rateMin = 2,
            rateMax = 2,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
            muzzleFlash = 1,
            snd = "vo/npc/male01/hacks01.wav",
    
            dmgMin = 3,
            dmgMax = 9,
            force = 10,
            num = 1,
            ammo = '9mm',
            spread = 0.16,
            tracer = 'Tracer',
            preCallback  = function(callback, zeta, wep, target, blockData) 

                blockData.muzzle = true
                blockData.shell = true
                blockData.bullet = true
                blockData.clipRemove = true

                local monitor = ents.Create("prop_physics")
                monitor:SetModel("models/props_lab/monitor01a.mdl")
                monitor:SetPos(wep:GetPos()+zeta:GetForward()*40)
                monitor:SetAngles(zeta:GetForward():Angle())
                monitor:SetOwner(zeta)
                monitor.IsZetaProp = true
                monitor:Spawn()

                local normal = (target:GetPos()-monitor:GetPos()):GetNormalized()

                local phys = monitor:GetPhysicsObject()

                if IsValid(phys) then
                    phys:ApplyForceCenter(normal*700000)
                end

                if GetConVar("zetaplayer_removepropsondeath"):GetInt() == 1 then
                    zeta:DeleteOnRemove(monitor)
                end

                local propCallback = monitor:AddCallback('PhysicsCollide', function(ent, data)
                    local dmg = data.HitSpeed:Length()
                    if data.HitEntity != zeta and dmg >= 750 then
                        local propDmg = DamageInfo()
                        propDmg:SetDamage(dmg)
                        propDmg:SetInflictor(ent)
                        propDmg:SetAttacker(zeta or self)
                        propDmg:SetDamageType(DMG_CRUSH)
                        propDmg:SetDamageForce(data.OurOldVelocity*20)
                        data.HitEntity:TakeDamageInfo(propDmg)
                        ent:EmitSound('physics/metal/metal_box_break'..math.random(2)..'.wav', 70, math.random(90, 110))
                    end
                end)
                timer.Simple(5, function() if IsValid(monitor) then monitor:RemoveCallback('PhysicsCollide', propCallback) end end)

                timer.Simple(20, function() if IsValid(monitor) then monitor:Remove() end end)
            
            
                return blockData
            end,
                postCallback  = nil
    
    
        },
    
        shellData = {
            name = 'ShellEject',
            offPos = {
                forward = 0,
                right = 0,
                up = 3
            },
            offAng = Angle(0,90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
            time = 1.5,
            snds = {
                {0, 'weapons/pistol_worldreload.wav'},
            }
        }
    }, 



    IMPACTGRENADE = {
        mdl = "models/weapons/w_grenade.mdl",
        hidewep = false,
        offPos = Vector(0,0,0),   
        offAng = Angle(0,0,0),
        lethal = true,
        range = false,
        melee = true,
        clip = 1,
        prettyPrint = "Punch Activated Impact Grenade",
    
        anims = {
            idle = ACT_HL2MP_IDLE_GRENADE,
            move = ACT_HL2MP_RUN_GRENADE,
            jump = ACT_HL2MP_JUMP_GRENADE,
            crouch = ACT_HL2MP_WALK_CROUCH_GRENADE
        },
    
        changeCallback = function(callback, zeta, wep)
            wep.PAIG_SentryBuster = GetConVar("zetaplayer_paig_sentrybustermode"):GetBool()
            if wep.PAIG_SentryBuster then
                wep:EmitSound("zetaplayer/weapon/paig/sb_intro.wav")
    
                wep.PAIG_LoopSound = CreateSound(wep, "zetaplayer/weapon/paig/sb_loop.wav")
                if wep.PAIG_LoopSound then wep.PAIG_LoopSound:Play() end
                wep:CallOnRemove("zeta_paig_sb_stopsound"..wep:EntIndex(), function()
                    if wep.PAIG_LoopSound then wep.PAIG_LoopSound:Stop() wep.PAIG_LoopSound = nil end
                end)
    
                timer.Create("zeta_sentrybuster_intro_loop"..wep:EntIndex(), 5, 0, function()
                    if !IsValid(wep) then return end
                    wep.PAIG_LoopIntroSound = CreateSound(wep, "zetaplayer/weapon/paig/sb_intro.wav")
                    if wep.PAIG_LoopIntroSound then wep.PAIG_LoopIntroSound:Play() end
                    wep:CallOnRemove("zeta_paig_sb_intro_stopsound"..wep:EntIndex(), function()
                        if wep.PAIG_LoopIntroSound then wep.PAIG_LoopIntroSound:Stop() wep.PAIG_LoopIntroSound = nil end
                    end)
                end)
    
                zeta:CreateThinkFunction("PAIG_HolsterSoundHack", 0, 0, function()
                    if zeta.Weapon == "IMPACTGRENADE" or !wep.PAIG_LoopSound and !wep.PAIG_LoopIntroSound then return end
                    if wep.PAIG_LoopSound then
                        wep.PAIG_LoopSound:Stop() 
                    end
                    if wep.PAIG_LoopIntroSound then
                        wep.PAIG_LoopIntroSound:Stop() 
                    end
                    wep.PAIG_LoopSound = nil
                    wep.PAIG_LoopIntroSound = nil
                    return "stop"
                end)
            end
        end,
    
        fireData = {
            rateMin = 4,
            rateMax = 4,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
            
            preCallback  = function(callback, zeta, wep, target, blockData) 
                blockData.muzzle = true 
                blockData.shell = true 
                blockData.bullet = true 
                blockData.clipRemove = true
                blockData.snd = true
    
                local fuseTime = 0.3
                local fuseSnd = "BaseExplosionEffect.Sound"
                local voice_rnd_attacker = math.random(1,2)
                if wep.PAIG_SentryBuster then
                    blockData.anim = true
                    wep:EmitSound("zetaplayer/weapon/paig/sb_spin.wav", 75)
                    if wep.PAIG_LoopSound then wep.PAIG_LoopSound:Stop() wep.PAIG_LoopSound = nil end
    
                    fuseSnd = "zetaplayer/weapon/paig/sb_explode.wav"
                    fuseTime = SoundDuration("zetaplayer/weapon/paig/sb_spin.wav")
    
                    if voice_rnd_attacker == 1 then
                        zeta:PlayTauntSound()
                    elseif voice_rnd_attacker == 2 then
                        zeta:PlayDeathSound()
                    end
                end
    
                for _, v in ipairs(ents.FindByClass("npc_zetaplayer")) do
                    if v != zeta and v:GetRangeSquaredTo(zeta) <= (400*400) and v:CanSee(zeta) then
                        timer.Simple(math.Rand(0.1, 0.5), function()
                            if !IsValid(v) or v.IsDead then return end
                            v:Panic(zeta, 5, true, false)
                            v:PlayFallingSound()
                        end)
                    end
                end
    
                timer.Simple(fuseTime, function()
                    if !IsValid(zeta) or !IsValid(wep) then return end
    
                    zeta.SilenceDeath = true
    
                    local effectdata = EffectData()
                    effectdata:SetOrigin(wep:GetPos())
                    util.Effect("Explosion", effectdata, true, true)
                    wep:EmitSound(fuseSnd, 90)
    
                    util.BlastDamage(zeta, zeta, wep:GetPos(), 400, 1000)
                    if wep.PAIG_SentryBuster then
                        util.ScreenShake(wep:GetPos(),25,5,3,1000)
                        
                        ParticleEffect("fluidSmokeExpl_ring_mvm", wep:GetPos() + Vector(50,50,25), wep:GetAngles())
                        ParticleEffect("fluidSmokeExpl_ring_mvm", wep:GetPos() + Vector(-50,-50,25), wep:GetAngles())
                        ParticleEffect("fluidSmokeExpl_ring_mvm", wep:GetPos() + Vector(-50,50,25), wep:GetAngles())
                        ParticleEffect("fluidSmokeExpl_ring_mvm", wep:GetPos() + Vector(50,-50,25), wep:GetAngles())
                        
                        ParticleEffect("fluidSmokeExpl_ring_mvm", wep:GetPos() + Vector(-50,-50,25), wep:GetAngles())
                        ParticleEffect("fluidSmokeExpl_ring_mvm", wep:GetPos() + Vector(50,-50,25), wep:GetAngles())
        
    
                        for _, v in ipairs(ents.FindInSphere(wep:GetPos(), 1000)) do
                            if IsValid(v) and v:IsPlayer() then
                                local fadeTime = 1.0
                                local fadeHold = 0.1
                                local screenfade_rand = math.random(1,2)
                                if screenfade_rand == 1 then
                                    v:ScreenFade(SCREENFADE.IN, Color(255, 255, 255, 255), fadeTime, fadeHold)
                                elseif screenfade_rand == 2 then
                                    v:ScreenFade(SCREENFADE.IN, Color(255, 255, 255, 120), fadeTime, fadeHold)
                                end
                            end
                        end
                    end
                end)
    
                return blockData
            end
        },
    },

    SHOVEL = {
        mdl = 'models/zetaplayers/weapons/w_shovel.mdl', 
        hidewep = false,
        offPos = Vector(0.5,-0.5,43),   
        offAng = Angle(0,-90,180),
        lethal = true,
        range = false,
        melee = true,
        clip = 1,
        prettyPrint = 'Shovel',
    
        anims = {
            idle = ACT_HL2MP_IDLE_MELEE2,
            move = ACT_HL2MP_RUN_MELEE2,
            jump = ACT_HL2MP_JUMP_MELEE2,
            crouch = ACT_HL2MP_WALK_CROUCH_MELEE2
        },
    
        fireData = {
            preCallback = function(callback, zeta, wep, target, blockData)
                if CurTime() <= zeta.AttackCooldown then return end
                zeta.AttackCooldown = CurTime() + math.Rand(0.8, 0.95)
    
                if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2) then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2)
                end
                zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2,true)
                wep:EmitSound('npc/zombie/claw_miss1.wav', 65, 80)
                zeta:FaceTick(target,100)
    
                timer.Simple(0.3, function()
                    if !IsValid(zeta) or zeta.IsDead or !IsValid(target) or zeta:GetRangeSquaredTo(target) > (70*70) then return end
    
                    local dmg = DamageInfo()
                    dmg:SetDamage(math.random(25,30)/GetConVar("zetaplayer_damagedivider"):GetInt())
                    dmg:SetAttacker(zeta)
                    dmg:SetInflictor(wep)
                    dmg:SetDamageType(DMG_CLUB)
                    target:TakeDamageInfo(dmg)
    
                    target:EmitSound('physics/metal/metal_sheet_impact_hard8.wav', 70, 135)
                    target:EmitSound('Flesh.ImpactHard', 70, 110)
                end)
            end
        }
    
    },


    TF2SNIPER = {
        mdl = "models/zetatf2/weapons/w_sniperrifle.mdl",
        hidewep = false,
        offPos = Vector(16, 0, 5),   
        offAng = Angle(-10, 0, 0),
        lethal = true,
        range = true,
        keepDistance = 1000,
        melee = false,
        clip = 1,
        prettyPrint = "[TF2] Sniper Rifle",
    
        anims = {
            idle = ACT_HL2MP_IDLE_RPG,
            move = ACT_HL2MP_RUN_RPG,
            jump = ACT_HL2MP_JUMP_RPG,
            crouch = ACT_HL2MP_WALK_CROUCH_RPG
        },
    
        fireData = {
            rateMin = 0,
            rateMax = 0,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/tf2/sniper_shoot.wav",
    
            dmgMin = 90,
            dmgMax = 90,
            force = 70,
            num = 1,
            ammo = "awp",
            spread = 0.1,
            tracer = "Tracer",
    
            preCallback = function(callback, zeta, wep, target, blockData)
                blockData.shell = true
    
                if math.random(20) == 1 and GetConVar("zetaplayer_allowmlgshots"):GetBool() then
                    blockData.snd = true
                    wep:EmitSound("zetaplayer/weapon/tf2/sniper_shoot_crit.wav", 80, math.random(98, 102), 1, CHAN_WEAPON)
    
                    FireBulletsTABLE.Attacker = zeta
                    FireBulletsTABLE.Damage = (200 / GetConVar("zetaplayer_damagedivider"):GetFloat())
                    FireBulletsTABLE.Force = (70 + GetConVar("zetaplayer_forceadd"):GetInt())
                    FireBulletsTABLE.HullSize = 5
                    FireBulletsTABLE.AmmoType = "AWP"
                    FireBulletsTABLE.TracerName = "Tracer"
                    FireBulletsTABLE.Dir = (target:GetCenteroid() - wep:GetPos()):GetNormalized()
                    FireBulletsTABLE.Src = wep:GetPos()
                    FireBulletsTABLE.Spread = Vector(0, 0, 0)
                    FireBulletsTABLE.IgnoreEntity = zeta
                    FireBulletsTABLE.Callback = function(attacker, tr, dmginfo)
                        local hitEnt = tr.Entity
                        if IsValid(hitEnt) and (hitEnt:IsPlayer() or hitEnt:IsNPC() or hitEnt:IsNextBot()) then
                            timer.Simple(0, function()
                                if !IsValid(hitEnt) or IsValid(hitEnt) and hitEnt:Health() > 0 or !IsValid( target ) then return end
                                target:EmitSound("zetaplayer/misc/backstabbed"..math.random(3)..".wav", 80)
                            end)
                        end
                    end
    
                    blockData.bullet = true
                    wep:FireBullets(FireBulletsTABLE)
                end
    
                return blockData
            end
        },
    
        shellData = {
            name = "RifleShellEject",
            offPos = {
                forward = -11,
                right = 0,
                up = 1
            },
            offAng = Angle(0, -90, 0)
        },
    
        reloadData = {
            time = function(zeta, wep)
                timer.Simple(0.3, function()
                    if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "TF2SNIPER" then return end
                    local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                    zeta:SetLayerCycle(layerID, 0.5)
                end)
                timer.Simple(0.6, function()
                    if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "TF2SNIPER" then return end
                    zeta:CreateShellEject()
                end)
                return 1.5
            end,
            snds = {
                {0.6, "zetaplayer/weapon/tf2/sniper_bolt_forward.wav"},
                {0.9, "zetaplayer/weapon/tf2/sniper_bolt_back.wav"},
            }
        }
    }, 


    BUGBAIT = {
        mdl = "models/weapons/w_bugbait.mdl",
    
        hidewep = false,
        offPos = Vector(0,0,0),
        offAng = Angle(0,0,0),
        lethal = true,
        range = true,
        keepDistance = 550,
        melee = false,
        clip = 1,
        prettyPrint = "Bugbait",
    
        anims = {
            idle = ACT_HL2MP_IDLE_GRENADE,
            move = ACT_HL2MP_RUN_GRENADE,
            jump = ACT_HL2MP_JUMP_GRENADE,
            crouch = ACT_HL2MP_WALK_CROUCH_GRENADE
        },
    
        fireData = {
            rateMin = 3.0,
            rateMax = 4.5,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
    
            preCallback = function(callback, zeta, wep, target, blockData)
                zeta.AntlionSquad = zeta.AntlionSquad or {}
                
                local limit = GetConVar('zetaplayer_bugbait_limit'):GetInt()
                if #zeta.AntlionSquad >= limit then blockData = nil return end
    
                local throwPos = (zeta:GetPos()+zeta:GetUp()*60+zeta:GetForward()*40-zeta:GetRight()*10)
    
                local behindtrace = util.TraceLine({
                    start = throwPos,
                    endpos = target:GetPos()+target:OBBCenter(),
                    filter = target
                })
                if behindtrace.Entity == zeta then blockData = nil return end
    
                blockData = {cooldown = false, anim = false, muzzle = true, shell = true, snd = true, bullet = true, clipRemove = true}

                local baitThrowPos = (target:GetPos()+target:OBBCenter()) -- The nav area code was removed due to it not being valid

                local throwAng = (baitThrowPos-throwPos):Angle()
    
                local bait = ents.Create('npc_grenade_bugbait')
                bait:SetPos(throwPos)
                bait:SetSaveValue("m_hThrower", zeta)
                bait:SetOwner(zeta)
                bait:Spawn()
                bait:SetVelocity(throwAng:Forward()*1000)
                bait:SetLocalAngularVelocity(Angle(600,math.random(-1200,1200),0))
    
                bait:CallOnRemove('zetabugbait_summonant'..bait:EntIndex(), function()
                    if !zeta:IsValid() then return end
    
                    local spawnPos = bait:GetPos()
                    local area = navmesh.GetNearestNavArea(bait:GetPos(), true, 10000, true, true)
                    if IsValid(area) then spawnPos = area:GetClosestPointOnArea(bait:GetPos()) end
    
                    local ant = ents.Create('npc_antlion')
                    ant:SetPos(spawnPos)
                    ant:SetAngles(Angle(0, throwAng.y, 0))
                    ant:Spawn()
                    ant:SetHealth(GetConVar('zetaplayer_bugbait_spawnhp'):GetInt())
                    ant:SetMaxHealth(GetConVar('zetaplayer_bugbait_spawnhp'):GetInt())
                    ant:SetColor(zeta.PlayermodelColor:ToColor())
                    ant:AddEntityRelationship(zeta, D_LI, 99)
    
                    local index = ant:EntIndex()


                    constraint.NoCollide(ant, zeta, 0, 0)
    

    
                    local effectdata = EffectData()
                    effectdata:SetOrigin( ant:GetPos() )
                    ant:EmitSound("npc/antlion/digup1.wav",70,110)
                    util.Effect( "Explosion", effectdata, true, true )
    
                    ant.ZetaOwner = ant.ZetaOwner or zeta
                    ant.ZetaNextThink = ant.ZetaNextThink or CurTime() + 0.33
                    ant.ZetaSpawnTime = ant.ZetaSpawnTime or CurTime()
                    ant.ZetaLastEnemy = ant.ZetaLastEnemy or NULL

                    hook.Add('EntityTakeDamage', 'zetaantlion_damagecode'..index, function(ent,dmginfo)
                        if dmginfo:GetAttacker() != ant then return end
                        if ent == ant and (dmginfo:GetAttacker() == ant.ZetaOwner or dmginfo:GetInflictor() == ant.ZetaOwner) then
                            dmginfo:ScaleDamage(0)
                            return
                        end
                        dmginfo:ScaleDamage(GetConVar('zetaplayer_bugbait_dmgscale'):GetFloat())
                    end)
                    
                    hook.Add('Think', 'zetaantlion_think'..index, function()
                        
                        if !IsValid(ant) or !IsValid(ant.ZetaOwner) or GetConVar('zetaplayer_bugbait_lifetime'):GetFloat() > 0 and (CurTime() - ant.ZetaSpawnTime) > GetConVar('zetaplayer_bugbait_lifetime'):GetFloat() then 
                            hook.Remove('Think', 'zetaantlion_think'..index) 
                            hook.Remove('EntityTakeDamage', 'zetaantlion_damagecode'..index)
                            if IsValid(ant) then 
                                ant:EmitSound('npc/antlion/land1.wav',70,130)
                                ant:TakeDamage(math.huge, ant, ant) 
                            end
                            return 
                        end
    
                        if CurTime() <= ant.ZetaNextThink then return end
                        ant.ZetaNextThink = CurTime() + 0.1
    
                        local owner = ant.ZetaOwner
                        local enemy = owner:GetEnemy()
                        local myEnemy = ant:GetEnemy()
                        if owner:GetState() == 'chasemelee' or owner:GetState() == 'chaseranged' or IsValid(enemy) and enemy.IsZetaPlayer and enemy:GetEnemy() == owner then
                            if IsValid(enemy) then
                                if enemy == ant or enemy.ZetaOwner and enemy.ZetaOwner == owner then
                                    owner:SetState("idle")
                                    owner:SetEnemy(NULL)
                                elseif enemy.ZetaOwner and enemy.ZetaOwner != owner and enemy != enemy.ZetaOwner then
                                    owner:SetEnemy(enemy.ZetaOwner)
                                else
                                    if enemy.AntlionSquad and #enemy.AntlionSquad > 0 then
                                        local antEnemy = enemy
                                        local antDist = ant:GetPos():Distance(enemy:GetPos())
                                        for _, v in ipairs(enemy.AntlionSquad) do
                                            if ant:GetPos():Distance(v:GetPos()) < antDist then
                                                antEnemy = v
                                                antDist = ant:GetPos():Distance(v:GetPos())
                                            end
                                        end
                                        enemy = antEnemy
                                    elseif enemy.IsZetaPlayer and enemy:GetEnemy() == owner then
                                        local hisEnemy = owner
                                        local eneDist = enemy:GetRangeSquaredTo(hisEnemy)
                                        for _, v in ipairs(owner.AntlionSquad) do
                                            if enemy:GetRangeSquaredTo(v) < eneDist then
                                                hisEnemy = v
                                                eneDist = enemy:GetRangeSquaredTo(v)
                                            end
                                        end
                                        enemy:SetEnemy(hisEnemy)
                                    end
    
                                    if enemy != myEnemy then
                                        ant:AddEntityRelationship(enemy, D_HT, 99)
                                        ant:SetEnemy(enemy)
                                        ant:UpdateEnemyMemory(enemy, owner:GetEnemy():GetPos())
                                        ant.ZetaLastEnemy = enemy
                                    end
    
                                    if !ant:Visible(enemy) and !ant:IsUnreachable(enemy) then
                                        if !ant:IsCurrentSchedule(SCHED_FORCED_GO_RUN) then
                                            ant:SetLastPosition(enemy:GetPos())
                                            ant:SetSchedule(SCHED_FORCED_GO_RUN)
                                        end
                                    elseif ant:IsCurrentSchedule(SCHED_FORCED_GO_RUN) then
                                        ant:ClearSchedule()
                                        ant:StopMoving()
                                    end
                                end
                            end
                        else
                            if IsValid(enemy) and IsValid(ant.ZetaLastEnemy) and ant.ZetaLastEnemy == enemy then
                                ant:ClearEnemyMemory(enemy)
                                ant:AddEntityRelationship(enemy, D_LI, 99)
                                ant.ZetaLastEnemy = NULL
                            end
                            if !IsValid(ant:GetEnemy()) then
                                if owner:GetRangeSquaredTo(ant) > (175*175) then 
                                    if !ant:IsCurrentSchedule(SCHED_FORCED_GO_RUN) then
                                        ant:SetLastPosition(owner:GetPos())
                                        ant:SetSchedule(SCHED_FORCED_GO_RUN)
                                    end
                                elseif ant:IsCurrentSchedule(SCHED_FORCED_GO_RUN) then
                                    ant:ClearSchedule()
                                    ant:StopMoving()
                                end
                            else
                                if owner:IsFriendswith(myEnemy) or myEnemy.IsZetaPlayer and myEnemy:GetEnemy() != ant and (owner.zetaTeam != 'SELF' and myEnemy.zetaTeam != 'SELF' and myEnemy.zetaTeam == owner.zetaTeam or myEnemy:GetEnemy() != owner) or myEnemy:IsNPC() and myEnemy:Disposition(owner) != D_HT or myEnemy:IsPlayer() and myEnemy != enemy then
                                    ant:ClearEnemyMemory(ant:GetEnemy())
                                    ant:AddEntityRelationship(ant:GetEnemy(), D_LI, 99)
                                end
                            end
                        end
    
                        for _, v in ipairs(owner.AntlionSquad) do
                            if v != ant then
                                constraint.NoCollide(ant, v, 0, 0)
                            end
                        end
                    end)
    
                    ant:CallOnRemove('zetaantlion_removesquad'..ant:EntIndex(), function()
                        local owner = ant.ZetaOwner
                        if !IsValid(owner) then return end

                        local enemy = owner:GetEnemy()
                        if IsValid(enemy) and enemy.IsZetaPlayer and ant.ZetaLastEnemy == enemy then
                            enemy:SetEnemy(owner)
                            enemy:SetState((enemy.HasMelee and 'chasemelee' or 'chaseranged'))
                        end

                        if IsValid(enemy) and enemy.IsZetaPlayer and ant.ZetaLastEnemy == enemy and string.StartWith(enemy.LastState, 'chase') then
                            enemy:SetEnemy(owner)
                            enemy:SetState(enemy.LastState)
                        end

                        for k, v in ipairs(owner.AntlionSquad) do
                            if v == ant then table.remove(owner.AntlionSquad, k) break end
                        end 
                    end)
    
                    table.insert(zeta.AntlionSquad, ant)
                end)
    
                return blockData
            end
        }
    }, -- Bugbait end


    BAT = {
        mdl = "models/zetatf2/weapons/w_bat.mdl",
        hidewep = false,
        offPos = Vector(0, 0, 0),   
        offAng = Angle(0, 0, 0),
        lethal = true,
        range = false,
        melee = true,
        clip = 1,
        prettyPrint = "[TF2] Bat",
    
        anims = {
            idle = ACT_HL2MP_IDLE_MELEE,
            move = ACT_HL2MP_RUN_MELEE,
            jump = ACT_HL2MP_JUMP_MELEE,
            crouch = ACT_HL2MP_WALK_CROUCH_MELEE
        },
    
        fireData = {
            preCallback = function(callback, zeta, wep, target, blockData)
                if CurTime() <= zeta.AttackCooldown then return end
                zeta.AttackCooldown = CurTime() + 0.5
    
                if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE) then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)
                end
                zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE, true)
    
                zeta:FaceTick(target, 100)
                wep:EmitSound("zetaplayer/weapon/tf2/cbar_miss1.wav", 70)
    
                timer.Simple(0.2, function()
                    if !IsValid(zeta) or zeta.IsDead or !IsValid(target) or zeta:GetRangeSquaredTo(target) > (70*70) then return end
    
                    local dmg = DamageInfo()
                    dmg:SetDamage(math.random(20, 22) / GetConVar("zetaplayer_damagedivider"):GetInt())
                    dmg:SetAttacker(zeta)
                    dmg:SetInflictor(wep)
                    dmg:SetDamageType(DMG_CLUB)
                    target:TakeDamageInfo(dmg)
    
                    target:EmitSound("zetaplayer/weapon/tf2/bat_hit.wav", 80)
                    target:EmitSound("zetaplayer/weapon/tf2/cbar_hitbod"..math.random(3)..".wav", 70)
                end)
            end    
        },
    }, 

    SNIPERSMG = {
        mdl = "models/zetatf2/weapons/w_smg.mdl",
        hidewep = false,
        offPos = Vector(0, 0, 0),   
        offAng = Angle(-10, 0, 0),
        lethal = true,
        range = true,
        melee = false,
        clip = 25,
        prettyPrint = "[TF2] SMG",
    
        anims = {
            idle = ACT_HL2MP_IDLE_RPG,
            move = ACT_HL2MP_RUN_RPG,
            jump = ACT_HL2MP_JUMP_RPG,
            crouch = ACT_HL2MP_WALK_CROUCH_RPG
        },
    
        fireData = {
            rateMin = 0.105,
            rateMax = 0.105,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/tf2/smg_shoot.wav",
    
            dmgMin = 4,
            dmgMax = 7,
            force = 10,
            num = 1,
            ammo = "SMGRounds",
            spread = 0.175,
            tracer = "Tracer",
    
        },
    
        shellData = {
            name = "ShellEject",
            offPos = {
                forward = 5,
                right = 0,
                up = 2
            },
            offAng = Angle(0, -90, 0)
        },
    
        reloadData = {
            time = function(zeta, wep)
                local layerID = zeta:AddGestureSequence(zeta:LookupSequence("reload_smg1_alt"), true)
                zeta:SetLayerPlaybackRate(layerID, 1.75)
                return 1.1
            end,
            snds = {
                {0, "zetaplayer/weapon/tf2/smg_clip_out.wav"},
                {0.6, "zetaplayer/weapon/tf2/smg_clip_in.wav"},
            }
        }
    },

    FORCEOFNATURE = {
        mdl = "models/zetatf2/weapons/c_double_barrel.mdl",
        hidewep = false,
        offPos = Vector(1, 0, -1),   
        offAng = Angle(-10, 0, 0),
        lethal = true,
        range = true,
        melee = false,
        clip = 2,
        keepDistance = 200,
        prettyPrint = "[TF2] Force-A-Nature",
    
        anims = {
            idle = ACT_HL2MP_IDLE_SHOTGUN,
            move = ACT_HL2MP_RUN_SHOTGUN,
            jump = ACT_HL2MP_JUMP_SHOTGUN,
            crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN
        },
    
        fireData = {
            preCallback = function(callback, zeta, wep, target, blockData)
                blockData.anim = true
                blockData.shell = true
    
                if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW) then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW)
                end
                local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW, true)
                zeta:SetLayerCycle(layerID, 0.075)
                timer.Simple(0.2, function()
                    if !IsValid(zeta) or !zeta:IsValidLayer(layerID) then return end
                    zeta:SetLayerBlendOut(layerID, 0.75)
                end)
    
                FireBulletsTABLE.Attacker = zeta
                FireBulletsTABLE.Damage = math.random(5, 6)
                FireBulletsTABLE.Force = 3
                FireBulletsTABLE.Spread = Vector(0.4 + zeta.Accuracy, 0.4 + zeta.Accuracy, 0)
                FireBulletsTABLE.AmmoType = "Buckshot"
                FireBulletsTABLE.Num = 12
                FireBulletsTABLE.TracerName = "Tracer"
                FireBulletsTABLE.Dir = (target:GetCenteroid() - wep:GetPos()):GetNormalized()
                FireBulletsTABLE.Src = wep:GetPos()
                FireBulletsTABLE.HullSize = 5
                FireBulletsTABLE.IgnoreEntity = zeta
                FireBulletsTABLE.Callback = function(attacker, tr, dmginfo)
                    local hitEnt = tr.Entity
                    if IsValid(hitEnt) and IsValid( zeta ) and zeta:GetRangeSquaredTo(hitEnt) <= (400*400) then
                        local dir = (hitEnt:GetPos() - wep:GetPos()):Angle()
                        if hitEnt.IsZetaPlayer then
                            hitEnt.IsJumping = true 
                            hitEnt:SetLastActivity(hitEnt:GetActivity())
                            hitEnt.loco:Jump()
                            hitEnt.loco:SetVelocity(hitEnt.loco:GetVelocity() + dir:Forward()*15 + dir:Up()*15)
                        elseif hitEnt:IsPlayer() then
                            hitEnt:SetVelocity(dir:Forward()*150 + dir:Up()*200)
                        end
                    end
                end
    
                blockData.bullet = true
                wep:FireBullets(FireBulletsTABLE)
    
                return blockData
            end,
    
            rateMin = 0.3125,
            rateMax = 0.3125,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/tf2/scatter_gun_double_shoot.wav"
        },
    
        shellData = {
            name = "ShotgunShellEject",
            offPos = {
                forward = 0,
                right = 1,
                up = 3
            },
            offAng = Angle(0, 180, 0)
        },
    
        reloadData = {
            time = function(zeta, wep)
                local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                zeta:SetLayerPlaybackRate(layerID, 1.66)
                
                timer.Simple(0.35, function()
                    if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "FORCEOFNATURE" then return end
                    zeta:CreateShellEject()
                    zeta:CreateShellEject()
                end)
    
                return 1.4
            end,
            snds = {
                {0.3, "zetaplayer/weapon/tf2/scatter_gun_double_tube_open.wav"},
                {1, "zetaplayer/weapon/tf2/scatter_gun_double_tube_close.wav"},
            }
        }
    }, 

    FIVESEVEN = {
        mdl = 'models/weapons/w_pist_fiveseven.mdl',
        hidewep = false,
        offPos = Vector(0,0,0),   
        offAng = Angle(0,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 20,
        prettyPrint = 'Five-Seven',
    
        anims = {
            idle = ACT_HL2MP_IDLE_PISTOL,
            move = ACT_HL2MP_RUN_PISTOL,
            jump = ACT_HL2MP_JUMP_PISTOL,
            crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
        },
    
        fireData = {
            rateMin = 0.15,
            rateMax = 0.6,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/fiveseven/fiveseven-1.wav",
    
            dmgMin = 3,
            dmgMax = 10,
            force = 10,
            num = 1,
            ammo = '9mm',
            spread = 0.16,
            tracer = 'Tracer', 
    
        },
    
        shellData = {
            name = 'ShellEject',
            offPos = {
                forward = 0,
                right = 0,
                up = 3
            },
            offAng = Angle(0,90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
            time = 1.5,
            snds = {
                {0, 'zetaplayer/weapon/fiveseven/fiveseven_slideback.wav'},
                {0.4, 'zetaplayer/weapon/fiveseven/fiveseven_clipout.wav'},
                {0.7, 'zetaplayer/weapon/fiveseven/fiveseven_clipin.wav'},
                {1.3, 'zetaplayer/weapon/fiveseven/fiveseven_sliderelease.wav'},
            }
        }
    }, 

    C4 = {
        mdl = 'models/weapons/w_c4.mdl',
        hidewep = false,
        offPos = Vector(0,0,0),   
        offAng = Angle(0,0,0),
        projectile = true,
        lethal = true,
        range = true,
        melee = false,
        clip = 1,
        prettyPrint = 'C4 Plastic Explosive',
    
        anims = {
            idle = ACT_HL2MP_IDLE_SLAM,
            move = ACT_HL2MP_RUN_SLAM,
            jump = ACT_HL2MP_JUMP_SLAM,
            crouch = ACT_HL2MP_WALK_CROUCH_SLAM
        },
    
        fireData = {
            rateMin = 0.15,
            rateMax = 0.15,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM,
            muzzleFlash = 1,
            snd = "weapons/pistol_shoot.wav",
    
            dmgMin = 3,
            dmgMax = 9,
            force = 10,
            num = 1,
            ammo = '9mm',
            spread = 0.16,
            tracer = 'Tracer',
            preCallback  = function(callback, zeta, wep, target, blockData) --local blockData = {cooldown = false, anim = false, muzzle = false, shell = false, snd = false, bullet = false, clipRemove = false}
                blockData.muzzle = true 
                blockData.shell = true 
                blockData.snd = true 
                blockData.bullet = true 
                blockData.clipRemove = true 

                local c4 = ents.Create("prop_physics")
                c4:SetModel("models/weapons/w_c4.mdl")
                c4:SetPos(wep:GetPos())
                c4:SetAngles(wep:GetAngles())
                c4.IsZetaC4 = true
                c4:Spawn()
                c4:SetColor(zeta.PlayermodelColor:ToColor())

                local id = c4:GetCreationID()
                local currentcur = 2
                local Cur = CurTime()+currentcur
                c4:EmitSound("zetaplayer/weapon/c4/c4_plant_quiet.wav",65)

                hook.Add("Think","zeta_c4think"..id,function()
                    if !IsValid(c4) then hook.Remove("Think","zeta_c4think"..id) return end
                    if currentcur <= 0 then
                        hook.Remove("Think","zeta_c4think"..id)
                        c4:EmitSound("zetaplayer/weapon/c4/nvg_on.wav",110)

                        timer.Simple(math.Rand(0,1),function()
                            if !IsValid(c4) then return end
                            for k,v in ipairs(ents.FindInSphere(c4:GetPos(), 2500)) do
                                local cansee = util.TraceLine({
                                    start = c4:GetPos()+c4:OBBCenter(),
                                    endpos = v:GetPos()+v:OBBCenter(),
                                    filter = c4
                                })
                                if v.IsZetaPlayer and cansee.Entity == v then
                                    v:Panic(c4)
                                end
                            end
                        end)
                        
                        timer.Simple(1,function()
                            if !IsValid(c4) then return end
                            c4:EmitSound("zetaplayer/weapon/c4/arm_bomb.wav",110)
                        end)

                        timer.Simple(2,function()
                            if !IsValid(c4) then return end
                            ParticleEffect( "explosion_huge", c4:GetPos(),Angle(0,0,0) )
                            util.BlastDamage(c4,IsValid(zeta) and zeta or c4,c4:GetPos()+Vector(0,0,10),2500,1000)
                            util.ScreenShake(c4:GetPos(),50,100,4,5400)
                            sound.Play("zetaplayer/weapon/c4/explode_6.wav",c4:GetPos(),100,100,1)
                            sound.Play("ambient/explosions/explode_2.wav",c4:GetPos(),100,100,1)

                            local downtrace = util.TraceLine({
                                start = c4:GetPos(),
                                endpos = c4:GetPos()-Vector(0,0,100),
                                collisiongroup = COLLISION_GROUP_DEBRIS
                            })
                            net.Start("zeta_createc4decal",true)
                                net.WriteTable(downtrace)
                            net.Broadcast()

                            if GetConVar("zetaplayer_c4debris"):GetInt() == 1 then
                                local debris = {
                                    "models/props_debris/concrete_chunk01a.mdl",
                                    "models/props_debris/concrete_chunk01b.mdl",
                                    "models/props_debris/concrete_chunk01c.mdl",
                                    "models/props_debris/concrete_chunk02a.mdl",
                                    "models/props_debris/concrete_chunk02b.mdl",
                                    "models/props_debris/concrete_chunk06c.mdl",
                                    "models/props_debris/concrete_chunk06d.mdl",
                                    "models/props_debris/concrete_chunk08a.mdl",
                                    "models/props_debris/walldestroyed08a.mdl",
                                    "models/props_debris/concrete_floorpile01a.mdl",
                                    "models/props_debris/concrete_section128wall001c.mdl",
                                    "models/props_debris/concrete_wall01a.mdl",
                                    "models/props_debris/plaster_ceilingpile001b.mdl",
                                    "models/props_debris/plaster_ceilingpile001a.mdl",
                                    "models/props_debris/plaster_ceilingpile001c.mdl"
                                }


                                for i=1, math.random(3,16) do
                                    local concrete = ents.Create("prop_physics")
                                    concrete:SetModel(debris[math.random(#debris)])
                                    concrete:SetPos(c4:GetPos()+Vector(math.random(-100,100),math.random(-100,100),100))
                                    concrete:SetAngles(AngleRand(-180,180))
                                    concrete.IsZetaProp = true
                                    concrete:Spawn()

                                    concrete:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
                                    concrete:Ignite(math.random(5,30))
                                    concrete:SetLocalAngularVelocity(AngleRand(-500,500))
                                    local phys = concrete:GetPhysicsObject()

                                    if IsValid(phys) then
                                        phys:SetMass(60)
                                        phys:ApplyForceCenter(VectorRand(-800000,800000))
                                    end

                                    timer.Simple(45,function()
                                        if IsValid(concrete) then
                                            concrete:Remove()
                                        end
                                    end)

                                end
                            end



                            c4:Remove()
                        end)
                    else
                        if CurTime() > Cur then

                            c4:EmitSound("zetaplayer/weapon/c4/c4_click.wav",70)
                            
                            currentcur = currentcur - 0.1
                            Cur = CurTime()+currentcur
                        end
                    end
                end)


                zeta:SetState("idle")
                zeta:ChooseLethalWeapon()

                if ConVarExists( "mw2cards_enabled" ) and GetConVar("mw2cards_enabled"):GetInt() == 1 and GetConVar("zetaplayer_c4card"):GetInt() == 1 then
                    local title = zeta.mw2cardtitle
                    if !title then
                        title = "materials/mw2cards/titles/FNG_title_MW2.png"
                    end
                    
                    if GetConVar("zetaplayer_usecustomavatars"):GetInt() == 1 then
                        icon = zeta.ProfilePicture
                    else
                        icon = "none"
                    end

                    net.Start("mw2_callcard_send",true)
                    net.WriteEntity(zeta)
                    net.WriteString("ARMED A C4!")
                    net.WriteString(title)
                    net.WriteString(icon)
                    net.Broadcast() 

                end

                return blockData
            end
    
    
        },

    }, 

    PAN = {
        mdl = 'models/zetaplayers/weapons/w_pan.mdl',
        hidewep = false,
        offPos = Vector(0,0,0),   
        offAng = Angle(0,0,0),
        lethal = true,
        range = false,
        melee = true,
        clip = 1,
        prettyPrint = 'Frying Pan',
    
        anims = {
            idle = ACT_HL2MP_IDLE_MELEE,
            move = ACT_HL2MP_RUN_MELEE,
            jump = ACT_HL2MP_JUMP_MELEE,
            crouch = ACT_HL2MP_WALK_CROUCH_MELEE
        },
    
        fireData = {
            preCallback = function(callback, zeta, wep, target, blockData)
                if CurTime() <= zeta.AttackCooldown then return end
                zeta.AttackCooldown = CurTime() + 0.5
    
                if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE) then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)
                end
                zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE,true)
    
                zeta:FaceTick(target,100)
    
                target:EmitSound('zetaplayer/weapon/pan/pan_miss.wav', 65)
    
                timer.Simple(0.25, function()
                    if !IsValid(zeta) or zeta.IsDead or !IsValid(target) or zeta:GetRangeSquaredTo(target) > (75*75) then return end
    
                    local dmg = DamageInfo()
                    dmg:SetDamage(15/GetConVar("zetaplayer_damagedivider"):GetInt())
                    dmg:SetAttacker(zeta)
                    dmg:SetInflictor(wep)
                    dmg:SetDamageType(DMG_CLUB)
                    target:TakeDamageInfo(dmg)
    
                    target:EmitSound('zetaplayer/weapon/pan/melee_frying_pan_0'..math.random(4)..'.wav', 80)
                end)
            end
        },
    }, 

    MEATHOOK = {
        mdl = 'models/zetaplayers/weapons/w_meathook.mdl',
        hidewep = false,
        offPos = Vector(3,1,8),   
        offAng = Angle(0,-65,180),
        lethal = true,
        range = false,
        melee = true,
        clip = 1,
        prettyPrint = 'Meat Hook',
    
        anims = {
            idle = ACT_HL2MP_IDLE_MELEE2,
            move = ACT_HL2MP_RUN_MELEE2,
            jump = ACT_HL2MP_JUMP_MELEE2,
            crouch = ACT_HL2MP_WALK_CROUCH_MELEE2
        },
    
        fireData = {
            preCallback = function(callback, zeta, wep, target, blockData)
                if CurTime() <= zeta.AttackCooldown then return end
                zeta.AttackCooldown = CurTime() + math.Rand(1.0,1.2)
    
                if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2) then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2)
                end
                zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2,true)
    
                zeta:FaceTick(target,100)
    
                wep:EmitSound('npc/zombie/claw_miss1.wav', 65, 70)
    
                timer.Simple(0.3, function()
                    if !IsValid(zeta) or zeta.IsDead or !IsValid(target) or zeta:GetRangeSquaredTo(target) > (75*75) then return end
    
                    local dmg = DamageInfo()
                    dmg:SetDamage(math.random(40,50)/GetConVar("zetaplayer_damagedivider"):GetInt())
                    dmg:SetAttacker(zeta)
                    dmg:SetInflictor(wep)
                    dmg:SetDamageType(DMG_SLASH)
                    target:TakeDamageInfo(dmg)
    
                    target:EmitSound('zetaplayer/weapon/meathook/hook-'..math.random(3)..'.wav', 70)
                end)
            end
        },
    },  


    GRENADELAUNCHER = {
        mdl = 'models/zetatf2/weapons/w_grenadelauncher.mdl',
        nobonemerge = true,
        hidewep = false,
        offPos = Vector(0,0,2),   
        offAng = Angle(-10,0,0),
        projectile = true,
        lethal = true,
        range = true,
        melee = false,
        clip = 6,
        prettyPrint = 'Grenade Launcher',
    
        anims = {
            idle = ACT_HL2MP_IDLE_AR2,
            move = ACT_HL2MP_RUN_AR2,
            jump = ACT_HL2MP_JUMP_AR2,
            crouch = ACT_HL2MP_WALK_CROUCH_AR2
        },
    
        fireData = {
            rateMin = 0.5,
            rateMax = 0.5,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/tf2/grenade_launcher_shoot.wav",
    
            dmgMin = 3,
            dmgMax = 9,
            force = 10,
            num = 1,
            ammo = '9mm',
            spread = 0.16,
            tracer = 'Tracer',
            preCallback  = function(callback, zeta, wep, target, blockData) --local blockData = {cooldown = false, anim = false, muzzle = false, shell = false, snd = false, bullet = false, clipRemove = false}
                blockData.shell = true
                blockData.bullet = true

                wep:EmitSound("zetaplayer/weapon/tf2/grenade_launcher_shoot.wav",70)

                local pill = ents.Create("prop_physics")
                if !IsValid(pill) then return blockData end
                pill:SetModel("models/zetatf2/weapons/w_grenade_grenadelauncher.mdl")
                pill:SetPos(wep:GetPos())
                pill:SetAngles(wep:GetAngles())
                pill:SetOwner(zeta)
                pill:Spawn()
                pill:SetColor(zeta.PlayermodelColor:ToColor())
                local id = pill:GetCreationID()
                util.SpriteTrail( pill, 0, zeta.PlayermodelColor:ToColor(), true, 6, 0, 1, 1 / ( 6 + 0 ) * 0.5, "trails/laser" )

                local phys = pill:GetPhysicsObject()

                if IsValid(phys) then
                    phys:SetMass(1)
                    local norm = ((target:GetPos()+target:OBBCenter())-zeta.WeaponENT:GetPos()):GetNormalized()
                    phys:ApplyForceCenter((norm*6000)+VectorRand(-600,600))
                end
                pill:SetLocalAngularVelocity(Angle(math.random(-180,180),math.random(-10,10),math.random(-10,10)))

                if IsValid(pill) then
                    pill:AddCallback("PhysicsCollide",function(ent,coldata)
                        if coldata.HitEntity != NULL and IsValid(coldata.HitEntity) then
                            util.BlastDamage( ent, IsValid(zeta) and zeta or pill, ent:GetPos(), 100, 100/GetConVar("zetaplayer_damagedivider"):GetFloat() )

                            local effectdata = EffectData()
                            effectdata:SetOrigin( ent:GetPos() )
                            ent:EmitSound("BaseExplosionEffect.Sound")
                            util.Effect( "Explosion", effectdata, true, true )
                            
                            ent:Remove()
                        end
                    end)
                end


                timer.Create("zetagrenadepill"..id,4,1,function()
                    if !IsValid(pill) then return end
                    util.BlastDamage( pill, IsValid(zeta) and zeta or pill, pill:GetPos(), 100, 100/GetConVar("zetaplayer_damagedivider"):GetFloat() )

                    local effectdata = EffectData()
                    effectdata:SetOrigin( pill:GetPos() )
                    pill:EmitSound("BaseExplosionEffect.Sound")
                    util.Effect( "Explosion", effectdata, true, true )

                    pill:Remove()
                end)

                
                return blockData
            end
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
            time = 2,
            snds = {
                {0.2, 'zetaplayer/weapon/tf2/grenade_launcher_drum_open.wav'},
                {0.4, 'zetaplayer/weapon/tf2/grenade_launcher_worldreload.wav'},
                {0.8, 'zetaplayer/weapon/tf2/grenade_launcher_worldreload.wav'},
                {1.2, 'zetaplayer/weapon/tf2/grenade_launcher_worldreload.wav'},
                {1.6, 'zetaplayer/weapon/tf2/grenade_launcher_drum_close.wav'},
            }
        }
    }, 

    LARGEGRENADE = {
        mdl = 'models/props_c17/oildrum001_explosive.mdl',
        nobonemerge = true,
        hidewep = false,
        offPos = Vector(0,0,0),   
        offAng = Angle(0,0,0),
        projectile = true,
        lethal = true,
        range = true,
        melee = false,
        clip = 1,
        prettyPrint = 'Comically Large Grenade',
    
        anims = {
            idle = ACT_HL2MP_IDLE_GRENADE,
            move = ACT_HL2MP_RUN_GRENADE,
            jump = ACT_HL2MP_JUMP_GRENADE,
            crouch = ACT_HL2MP_WALK_CROUCH_GRENADE
        },

        dropCallback = function(zeta,wepent,droppedweapon)
            if IsValid(droppedweapon) then
                timer.Simple(0,function()
                    droppedweapon:Ignite(60)
                end)
            end
        end,
    
        fireData = {
            rateMin = 2,
            rateMax = 2,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
            muzzleFlash = 1,
            snd = "weapons/pistol_shoot.wav",
    
            dmgMin = 3,
            dmgMax = 9,
            force = 10,
            num = 1,
            ammo = '9mm',
            spread = 0.16,
            tracer = 'Tracer',


            
            preCallback  = function(callback, zeta, wep, target, blockData)  
                blockData.cooldown = false
                blockData.anim = false
                blockData.muzzle = true
                blockData.shell = true
                blockData.snd = true
                blockData.bullet = true
                blockData.clipRemove = true

                local normal = zeta:GetForward()
                if target and IsValid(target) then
                    normal = zeta:GetNormalTo(target:GetPos(),zeta:GetPos())
                end

                local throwforce = 50000

                if IsValid(target) and zeta:GetRangeSquaredTo(target) < (400*400) then
                    throwforce = 20000
                end

                local barrel = ents.Create("prop_physics")
                barrel:SetModel("models/props_c17/oildrum001_explosive.mdl")
                barrel:SetPos((zeta:GetPos()+zeta:OBBCenter())+zeta:GetForward()*60)
                barrel:SetOwner(zeta)
                barrel.LargeZetaGrenade = true
                barrel:Spawn()
                barrel:Ignite(60)
                


                local phys = barrel:GetPhysicsObject()

                if IsValid(phys) then
                    phys:ApplyForceCenter( normal*throwforce )
                    phys:SetAngleVelocity(VectorRand(-1000,1000))
                end
            
                return blockData
            end,
    
    
    
        },

    }, 

    USPSILENCED = {
        mdl = "models/weapons/w_pist_usp.mdl",
        hidewep = false,
        offPos = Vector(0,0,0),   
        offAng = Angle(0,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 12,
        prettyPrint = 'USP-45',
    
        anims = {
            idle = ACT_HL2MP_IDLE_PISTOL,
            move = ACT_HL2MP_RUN_PISTOL,
            jump = ACT_HL2MP_JUMP_PISTOL,
            crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
        },
    
        changeCallback = function(callback, zeta, wep)
            timer.Simple(0.6, function()
                if !IsValid(wep) then return end
                wep:EmitSound("zetaplayer/weapon/usp/usp_slideback.wav", 70, math.random(98, 102), 1, CHAN_WEAPON)
            end)
    
            if !wep.USP_HasSilencer then
                wep.USP_HasSilencer = (wep.USP_HasSilencer or math.random(2) == 1)
                if wep.USP_HasSilencer == true then
                    _ZetaWeaponDataTable["USPSILENCED"].mdl = "models/weapons/w_pist_usp_silencer.mdl"
                    _ZetaWeaponDataTable["USPSILENCED"].fireData.muzzleFlash = 0
                    _ZetaWeaponDataTable["USPSILENCED"].fireData.dmgMin = 4
                    _ZetaWeaponDataTable["USPSILENCED"].fireData.dmgMax = 14
                    _ZetaWeaponDataTable["USPSILENCED"].fireData.spread = 0.11
                    wep:SetModel("models/weapons/w_pist_usp_silencer.mdl")
                end
            end
        end,
    
        fireData = {
            rateMin = 0.16,
            rateMax = 0.23,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/usp/usp_unsil-1.wav",
    
            dmgMin = 6,
            dmgMax = 17,
            force = 10,
            num = 1,
            ammo = '9mm',
            spread = 0.145,
            tracer = 'Tracer',
    
            preCallback = function(callback, zeta, wep, target, blockData)
                if wep.USP_HasSilencer == true then
                    blockData.snd = true
                    wep:EmitSound("zetaplayer/weapon/usp/usp1.wav", 70, math.random(98, 102), 1, CHAN_WEAPON)
                end
                return blockData
            end
        },
    
        shellData = {
            name = 'ShellEject',
            offPos = {
                forward = 0,
                right = 0,
                up = 3
            },
            offAng = Angle(0,-90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
            time = 1.5,
            snds = {
                {0.3, 'zetaplayer/weapon/usp/usp_clipout.wav'},
                {0.7, 'zetaplayer/weapon/usp/usp_clipin.wav'},
                {1.3, 'zetaplayer/weapon/usp/usp_sliderelease.wav'},
            }
        }
    },

    HL1SMG = {
        mdl = 'models/w_9mmar.mdl',
        nobonemerge = true,
        hidewep = false,
        noweapondrop = true,
        offPos = Vector(8,0,5),   
        offAng = Angle(90,90,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 50,
        prettyPrint = 'HL1 MP5',
    
        anims = {
            idle = ACT_HL2MP_IDLE_AR2,
            move = ACT_HL2MP_RUN_AR2,
            jump = ACT_HL2MP_JUMP_AR2,
            crouch = ACT_HL2MP_WALK_CROUCH_AR2
        },
    
        fireData = {
            rateMin = 0.1,
            rateMax = 0.1,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
            muzzleFlash = 1,
            snd = "weapons/hks1.wav",
    
            dmgMin = 4,
            dmgMax = 8,
            force = 10,
            num = 1,
            ammo = '9mm',
            spread = 0.16,
            tracer = 'Tracer',
    
    
        },
    
        shellData = {
            name = 'ShellEject',
            offPos = {
                forward = 0,
                right = 0,
                up = 3
            },
            offAng = Angle(0,0,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
            time = 1.5,
            snds = {
                {0.5, 'items/cliprelease1.wav'},
                {1, 'items/clipinsert1.wav'},
            }
        }
    }, 

    HL1GLOCK = {
        mdl = 'models/w_9mmhandgun.mdl',
        nobonemerge = true,
        hidewep = false,
        noweapondrop = true,
        offPos = Vector(5,0,2),   
        offAng = Angle(180,0,90),
        lethal = true,
        range = true,
        melee = false,
        clip = 17,
        prettyPrint = 'HL1 Glock',
    
        anims = {
            idle = ACT_HL2MP_IDLE_PISTOL,
            move = ACT_HL2MP_RUN_PISTOL,
            jump = ACT_HL2MP_JUMP_PISTOL,
            crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
        },
    
        fireData = {
            rateMin = 0.25,
            rateMax = 0.4,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
            muzzleFlash = 1,
            snd = "weapons/pl_gun3.wav",
    
            dmgMin = 3,
            dmgMax = 8,
            force = 10,
            num = 1,
            ammo = '9mm',
            spread = 0.1,
            tracer = 'Tracer',
    
    
        },
    
        shellData = {
            name = 'ShellEject',
            offPos = {
                forward = 0,
                right = 0,
                up = 3
            },
            offAng = Angle(0,90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
            time = 1.5,
            snds = {
                {0.3, 'items/9mmclip2.wav'},
                {1, 'items/9mmclip1.wav'},
            }
        }
    }, 

    HL1SPAS = {
        mdl = 'models/scigun.mdl',
        nobonemerge = true,
        hidewep = false,
        noweapondrop = true,
        offPos = Vector(0,0,4),   
        offAng = Angle(0,180,-90),
        lethal = true,
        range = true,
        melee = false,
        clip = 8,
        prettyPrint = 'HL1 Spas',
    
    
        anims = {
            idle = ACT_HL2MP_IDLE_SHOTGUN,
            move = ACT_HL2MP_RUN_SHOTGUN,
            jump = ACT_HL2MP_JUMP_SHOTGUN,
            crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN
        },
    
        fireData = {
            rateMin = 1,
            rateMax = 1,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
            muzzleFlash = 1,
            snd = "weapons/sbarrel1.wav",
    
            dmgMin = 4,
            dmgMax = 10,
            force = 10,
            num = 4,
            ammo = 'buckshot',
            spread = 0.15,
            tracer = 'Tracer',
    
            postCallback  = function(callback, zeta, wep, target)
                
                timer.Simple(0.5,function()
                    if IsValid(wep) then
                        wep:EmitSound("weapons/scock1.wav",65)
                    end
                end)
            end
    
    
        },
    
        shellData = {
            name = 'ShotgunShellEject',
            offPos = {
                forward = 0,
                right = 0,
                up = 3
            },
            offAng = Angle(0,90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
            time = 2.5,
            snds = {
                {2, 'weapons/scock1.wav'},
            }
        }
    }, 

    HL1357 = {
        mdl = 'models/w_357.mdl',
        nobonemerge = true,
        hidewep = false,
        noweapondrop = true,
        offPos = Vector(7,2,4),   
        offAng = Angle(0,180,-90),
        lethal = true,
        range = true,
        melee = false,
        clip = 6,
        prettyPrint = 'HL1 357',
    
        anims = {
            idle = ACT_HL2MP_IDLE_REVOLVER,
            move = ACT_HL2MP_RUN_REVOLVER,
            jump = ACT_HL2MP_JUMP_REVOLVER,
            crouch = ACT_HL2MP_WALK_CROUCH_REVOLVER
        },
    
        fireData = {
            rateMin = 1,
            rateMax = 1,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
            muzzleFlash = 1,
            snd = "weapons/357_shot1.wav",
    
            dmgMin = 10,
            dmgMax = 40,
            force = 20,
            num = 1,
            ammo = '357',
            spread = 0.16,
            tracer = 'Tracer',
    
    
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_REVOLVER,
            time = 3,
            snds = {
                {0, 'weapons/357_reload1.wav'},
            }
        }
    }, 

    MAC10 = {
        mdl = 'models/weapons/w_smg_mac10.mdl',
        hidewep = false,
        noweapondrop = false,
        offPos = Vector(0,0,0),   
        offAng = Angle(0,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 30,
        prettyPrint = 'Mac10',
    
        anims = {
            idle = ACT_HL2MP_IDLE_PISTOL,
            move = ACT_HL2MP_RUN_PISTOL,
            jump = ACT_HL2MP_JUMP_PISTOL,
            crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
        },
    
        fireData = {
            rateMin = 0.05,
            rateMax = 0.05,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/mac/mac10-1.wav",
    
            dmgMin = 3,
            dmgMax = 10,
            force = 10,
            num = 1,
            ammo = '9mm',
            spread = 0.2,
            tracer = 'Tracer',
    
    
        },
    
        shellData = {
            name = 'ShellEject',
            offPos = {
                forward = 0,
                right = 0,
                up = 3
            },
            offAng = Angle(0,90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
            time = 2,
            snds = {
                {0, 'zetaplayer/weapon/mac/mac10_clipout.wav'},
                {0.5, 'zetaplayer/weapon/mac/mac10_clipin.wav'},
                {1, 'zetaplayer/weapon/mac/mac10_boltpull.wav'},
            }
        }
    }, 

    SG552 = {
        mdl = 'models/weapons/w_rif_sg552.mdl',
        hidewep = false,
        noweapondrop = false,
        offPos = Vector(0,0,0),   
        offAng = Angle(0,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 30,
        prettyPrint = 'SG552',
    
        anims = {
            idle = ACT_HL2MP_IDLE_AR2,
            move = ACT_HL2MP_RUN_AR2,
            jump = ACT_HL2MP_JUMP_AR2,
            crouch = ACT_HL2MP_WALK_CROUCH_AR2
        },
    
        fireData = {
            rateMin = 0.2,
            rateMax = 0.2,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/sg552/sg552-1.wav",
    
            dmgMin = 5,
            dmgMax = 20,
            force = 15,
            num = 1,
            ammo = '9mm',
            spread = 0.1,
            tracer = 'Tracer',
    
    
        },
    
        shellData = {
            name = 'RifleShellEject',
            offPos = {
                forward = 0,
                right = 0,
                up = 3
            },
            offAng = Angle(0,90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
            time = 1.5,
            snds = {
                {0, 'zetaplayer/weapon/sg552/sg552_clipout.wav'},
                {0.5, 'zetaplayer/weapon/sg552/sg552_clipin.wav'},
                {1, 'zetaplayer/weapon/sg552/sg552_boltpull.wav'},
            }
        }
    }, 

    AUG = {
        mdl = 'models/weapons/w_rif_aug.mdl',
        hidewep = false,
        noweapondrop = false,
        offPos = Vector(0,0,0),   
        offAng = Angle(0,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 30,
        prettyPrint = 'AUG',
    
        anims = {
            idle = ACT_HL2MP_IDLE_AR2,
            move = ACT_HL2MP_RUN_AR2,
            jump = ACT_HL2MP_JUMP_AR2,
            crouch = ACT_HL2MP_WALK_CROUCH_AR2
        },
    
        fireData = {
            rateMin = 0.08,
            rateMax = 0.08,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/aug/aug-1.wav",
    
            dmgMin = 3,
            dmgMax = 5,
            force = 10,
            num = 1,
            ammo = 'rifle',
            spread = 0.13,
            tracer = 'Tracer',
    
    
        },
    
        shellData = {
            name = 'RifleShellEject',
            offPos = {
                forward = 0,
                right = 0,
                up = 3
            },
            offAng = Angle(0,90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
            time = 1.5,
            snds = {
                {0, 'zetaplayer/weapon/aug/aug_clipout.wav'},
                {0.7, 'zetaplayer/weapon/aug/aug_clipin.wav'},
                {1.2, 'aug_boltpull'},
            }
        }
    }, 

    FAMAS = {
        mdl = 'models/weapons/w_rif_famas.mdl',
        hidewep = false,
        noweapondrop = false,
        offPos = Vector(0,0,0),   
        offAng = Angle(0,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 25,
        prettyPrint = 'Famas',
    
        anims = {
            idle = ACT_HL2MP_IDLE_AR2,
            move = ACT_HL2MP_RUN_AR2,
            jump = ACT_HL2MP_JUMP_AR2,
            crouch = ACT_HL2MP_WALK_CROUCH_AR2
        },
    
        fireData = {
            rateMin = 0.1,
            rateMax = 0.1,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/famas/famas-1.wav",
    
            dmgMin = 3,
            dmgMax = 16,
            force = 10,
            num = 1,
            ammo = 'rifle',
            spread = 0.11,
            tracer = 'Tracer',

    
    
        },
    
        shellData = {
            name = 'RifleShellEject',
            offPos = {
                forward = 0,
                right = 0,
                up = 3
            },
            offAng = Angle(0,90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
            time = 1.5,
            snds = {
                {0.1, 'zetaplayer/weapon/famas/famas_clipout.wav'},
                {0.5, 'zetaplayer/weapon/famas/famas_clipin.wav'},
            }
        }
    }, 

    UMP45 = {
        mdl = 'models/weapons/w_smg_ump45.mdl',
        hidewep = false,
        noweapondrop = false,
        offPos = Vector(0,0,0),   
        offAng = Angle(0,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 25,
        prettyPrint = 'Ump45',
    
        anims = {
            idle = ACT_HL2MP_IDLE_SMG1,
            move = ACT_HL2MP_RUN_SMG1,
            jump = ACT_HL2MP_JUMP_SMG1,
            crouch = ACT_HL2MP_WALK_CROUCH_SMG1
        },
    
        fireData = {
            rateMin = 0.1,
            rateMax = 0.1,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/ump45/ump45-1.wav",
    
            dmgMin = 3,
            dmgMax = 9,
            force = 10,
            num = 1,
            ammo = '9mm',
            spread = 0.08,
            tracer = 'Tracer',
    
    
        },
    
        shellData = {
            name = 'ShellEject',
            offPos = {
                forward = 0,
                right = 0,
                up = 3
            },
            offAng = Angle(0,90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
            time = 1.5,
            snds = {
                {0, 'zetaplayer/weapon/ump45/ump45_clipout.wav'},
                {0.5, 'zetaplayer/weapon/ump45/ump45_clipin.wav'},
                {1, 'zetaplayer/weapon/ump45/ump45_boltslap.wav'},
            }
        }
    }, 

    VOLVER = {
        mdl = 'models/weapons/w_357.mdl',
        hidewep = false,
        noweapondrop = false,
        offPos = Vector(0,0,0),   
        offAng = Angle(0,0,0),
        lethal = true,
        range = true,
        melee = false,
        clip = 1,
        prettyPrint = 'Volver',
    
        anims = {
            idle = ACT_HL2MP_IDLE_REVOLVER,
            move = ACT_HL2MP_RUN_REVOLVER,
            jump = ACT_HL2MP_JUMP_REVOLVER,
            crouch = ACT_HL2MP_WALK_CROUCH_REVOLVER
        },
    
        fireData = {
            rateMin = 20,
            rateMax = 20,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
            muzzleFlash = 7,
            snd = "weapons/357/357_fire2.wav",
    
            dmgMin = 1000,
            dmgMax = 1000,
            force = 1000,
            num = 1,
            ammo = 'dedrounds',
            spread = 0.05,
            tracer = 'Tracer',
            
            preCallback  = function(callback, zeta, wep, target, blockData)  
                blockData.cooldown = false
                blockData.anim = false
                blockData.muzzle = true
                blockData.shell = true
                blockData.snd = true
                blockData.bullet = true
                blockData.clipRemove = true

                wep:EmitSound("weapons/pistol/pistol_empty.wav",70)

                timer.Simple(1,function()
                    if !IsValid(zeta) or !IsValid(target) or !IsValid(wep) then return end
                    wep:EmitSound("weapons/357/357_fire2.wav",90)
                    wep:EmitSound("ambient/explosions/explode_4.wav",70)
                    zeta:EmitSound("physics/body/body_medium_break"..math.random(2,4)..".wav",90)
                    zeta:CreateMuzzleFlash(7)

                    local pos = target:GetPos()+target:OBBCenter()

                    FireBulletsTABLE.Attacker = zeta
                    FireBulletsTABLE.Damage = 1000/GetConVar("zetaplayer_damagedivider"):GetFloat()
                    FireBulletsTABLE.Force = math.Clamp(1000*GetConVar("zetaplayer_forceadd"):GetInt(),1,500000)
                    FireBulletsTABLE.HullSize = 5
                    FireBulletsTABLE.Spread = Vector(0.05+zeta.Accuracy,0.05+zeta.Accuracy,0)
                    FireBulletsTABLE.AmmoType = "dedrounds"
                    FireBulletsTABLE.Num = 1
                    FireBulletsTABLE.TracerName = "AR2Tracer"
                    FireBulletsTABLE.Dir = (pos-wep:GetPos()):GetNormalized()
                    FireBulletsTABLE.Src = wep:GetPos()
                    FireBulletsTABLE.IgnoreEntity = zeta
                    
                    wep:FireBullets(FireBulletsTABLE)

                                    
                util.ScreenShake(zeta:GetPos(), 10, 170, 3, 1500)

                    local dmg = DamageInfo()
                    dmg:SetDamage(zeta:Health()*100000)
                    dmg:SetDamageType(DMG_BLAST)
                    dmg:SetAttacker(zeta)
                    dmg:SetInflictor(zeta)
                    dmg:SetDamageForce(zeta:GetForward()*-80000000)
                    zeta.suicidereason = "Volver Recoil"
                    zeta:TakeDamageInfo(dmg)
                end)
            
                return blockData
            end,

    
    
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_REVOLVER,
            time = 1.5,
        }
    }, 

    FLAMETHROWER = {
        mdl = "models/zetatf2/weapons/c_flamethrower.mdl",
        offPos = Vector(0, 0, 0),   
        offAng = Angle(0, 0, 0),
        lethal = true,
        range = true,
        melee = false,
        clip = 1,
        prettyPrint = "[TF2] Flamethrower",
        keepDistance = 150,
    
        anims = {
            idle = ACT_HL2MP_IDLE_SHOTGUN,
            move = ACT_HL2MP_RUN_SHOTGUN,
            jump = ACT_HL2MP_JUMP_SHOTGUN,
            crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN
        },
    
        fireData = {
            rateMin = 3.9473922252655,
            rateMax = 3.9473922252655,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
            muzzleFlash = 1,
            snd = "zetaplayer/weapon/tf2/flame_thrower_bb_start.wav",
    
            dmgMin = 3,
            dmgMax = 9,
            force = 10,
            num = 1,
            ammo = "9mm",
            spread = 0.16,
            tracer = "Tracer",
            
            preCallback  = function(callback, zeta, wep, target, blockData)  
                blockData.anim = true
                blockData.muzzle = true
                blockData.shell = true
                blockData.bullet = true
                blockData.clipRemove = true
    
                local index = zeta:GetCreationID()
                ParticleEffectAttach("flamethrower", PATTACH_POINT_FOLLOW, wep, 0)
    
                timer.Create("zetaflamethrower"..index, 0.1, 0,function()
                    if !IsValid(zeta) or !IsValid(wep) or !IsValid(target) then 
                        if IsValid(wep) then 
                            wep:StopSound("zetaplayer/weapon/tf2/flame_thrower_bb_start.wav") 
                            wep:StopParticles() 
                        end 
                        timer.Remove("zetaflamethrower"..index) 
                        return 
                    end
    
                    for _, v in ipairs(ents.FindInCone(wep:GetPos(), wep:GetForward(), 250, math.cos(math.rad(30)))) do
                        if v != zeta and v != wep and IsValid(v) and isfunction(v.Ignite) and !zeta:IsInTeam(v) and (!zeta:IsFriendswith(v) or !GetConVar("zetaplayer_nohurtfriends"):GetBool()) then
                            local los = util.TraceLine({
                                start = wep:GetPos(),
                                endpos = v:GetCenteroid(),
                                filter = {zeta, wep}
                            })
    
                            if los.Entity == v then
                                if !v:IsOnFire() and v:Health() > 0 then
                                    v:Ignite(10,0)
                                end
    
                                local dmg = DamageInfo()
                                dmg:SetAttacker(zeta)
                                dmg:SetInflictor(wep)
                                dmg:SetDamage(5)
                                dmg:SetDamageType(DMG_GENERIC)
                                v:TakeDamageInfo(dmg)
                            end
                        end
                    end
                end)
    
                timer.Simple(3.9473922252655, function()
                    if !IsValid(zeta) or !IsValid(target) or !IsValid(wep) then return end
                    timer.Remove("zetaflamethrower"..index)
                    wep:StopParticles()
                    wep:StopSound("zetaplayer/weapon/tf2/flame_thrower_bb_start.wav")
                end)
            
                return blockData
            end
        }
    },
    
    KATANA = {
        mdl = 'models/zetaplayers/weapons/w_katana.mdl',
        hidewep = false,
        offPos = Vector(-1,-7.5,0),   
        offAng = Angle(0,90,180),
        lethal = true,
        range = false,
        melee = true,
        clip = 1,
        prettyPrint = 'Katana',
        moveSpeed = 50, -- Move speed has been changed as of update 5.2.4 to add to movement speed.
    
        anims = {
            idle = ACT_HL2MP_IDLE_MELEE2,
            move = ACT_HL2MP_RUN_MELEE2,
            jump = ACT_HL2MP_JUMP_MELEE2,
            crouch = ACT_HL2MP_WALK_CROUCH_MELEE2
        },
    
        changeCallback = function(callback, zeta, wep)
            if GetConVar('zetaplayer_spawnweapon'):GetString() == 'KATANA' and !wep.CanPlayDeploySnd then 
                wep.CanPlayDeploySnd = true
                return 
            end
            if GetConVar("zetaplayer_motivatedkatana"):GetBool() then
                wep:EmitSound('zetaplayer/weapon/katana/motivated/motivated'..math.random(1,20)..'.mp3', 110)
            end
            wep:EmitSound('zetaplayer/weapon/katana/katana_deploy.wav', 70)
        end,

        onThink = function(callback, zeta, wep)
            local ene = zeta:GetEnemy()
            if GetConVar("zetaplayer_allowjudgementcut"):GetBool() and zeta:GetState() == 'chasemelee' and IsValid(ene) and math.random(1,300) == 1 then
                zeta:JudgementCut(ene:GetPos())
                zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,true)
            end
        end,
    
        fireData = {
            preCallback = function(callback, zeta, wep, target, blockData)
                if CurTime() <= zeta.AttackCooldown then return end
                local cooldown = math.Rand(0.4,1.0)
                zeta.AttackCooldown = CurTime() + cooldown

                if GetConVar("zetaplayer_allowsourcecut"):GetBool() and math.random(1,20) == 1 then
                    zeta:PlayTauntSound()
                    zeta:SourceCut()
                    zeta.AttackCooldown = CurTime() + 6
                end
    
                if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2) then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2)
                end
                zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2,true)
                zeta:FaceTick(target,100)
                wep:EmitSound('zetaplayer/weapon/katana/katana_swing_miss'..math.random(4)..'.wav', 65)
    
                timer.Simple(0.075, function()
                    if !IsValid(zeta) or zeta.IsDead or !IsValid(target) or zeta:GetRangeSquaredTo(target) > (70*70) then return end
                    local dmg = DamageInfo()
                    dmg:SetDamage((35*(cooldown/0.8))/GetConVar("zetaplayer_damagedivider"):GetInt())
                    dmg:SetAttacker(zeta)
                    dmg:SetInflictor(wep)
                    dmg:SetDamageType(DMG_SLASH)
                    target:TakeDamageInfo(dmg)
                    target:EmitSound('zetaplayer/weapon/katana/melee_katana_0'..math.random(3)..'.wav', 70)
                end)
            end
        },
    
        onDamageCallback = function(callback, zeta, wep, dmginfo)
            wep.NextMeleeBlockT = wep.NextMeleeBlockT or CurTime()
            wep.NextBulletBlockT = wep.NextBulletBlockT or CurTime()
    
            local attacker = dmginfo:GetAttacker()
            if (zeta:GetForward():Dot((attacker:GetPos() - zeta:GetPos()):GetNormalized()) <= math.cos(math.rad(80))) then return end
    
            local dmgType = (dmginfo:IsBulletDamage() and 1 or (dmginfo:GetDamageType() == DMG_GENERIC or dmginfo:GetDamageType() == DMG_CLUB or dmginfo:GetDamageType() == DMG_SLASH) and 2 or 0)
            if dmgType == 0 then return end 
    
            local forceBlock = (math.random(5) == 1)
            if !forceBlock and (dmgType == 2 and CurTime() < wep.NextMeleeBlockT) or (dmgType == 1 and CurTime() < wep.NextBulletBlockT) then return end
    
            if zeta:IsPlayingGesture(ACT_HL2MP_FIST_BLOCK) then
                zeta:RemoveGesture(ACT_HL2MP_FIST_BLOCK)
            end
            zeta:AddGesture(ACT_HL2MP_FIST_BLOCK,false)
            timer.Simple(0.1, function ()
                if !IsValid(zeta) or !zeta:IsPlayingGesture(ACT_HL2MP_FIST_BLOCK) then return end
                zeta:RemoveGesture(ACT_HL2MP_FIST_BLOCK)
            end)
    
            local effectdata = EffectData()
            local sparkPos = dmginfo:GetDamagePosition()
            if zeta:GetRangeSquaredTo(sparkPos) > (150*150) then sparkPos = wep:GetPos() end
            local sparkForward = ((attacker:GetPos()+attacker:OBBCenter()) - sparkPos):Angle():Forward()
            effectdata:SetOrigin( sparkPos + sparkForward*10 )
            effectdata:SetNormal( sparkForward )
            util.Effect( "stunstickimpact", effectdata, true, true )
    
            dmginfo:ScaleDamage(math.Rand(math.random(0.1,0.2),0.3))
            
            if dmgType == 1 then
                wep:EmitSound('zetaplayer/weapon/katana/katana_deflect_bullet'..math.random(4)..'.wav', 70, math.random(95,110))
                wep.NextBulletBlockT = CurTime() + math.Rand(0, 0.3)
            else
                wep:EmitSound('zetaplayer/weapon/katana/katana_deflect_melee'..math.random(2)..'.wav', 70, math.random(95,110))
                wep.NextMeleeBlockT = CurTime() + math.Rand(0, 0.6)
            end
    
            if !zeta.InAir then
                local force = (dmginfo:GetDamageForce()/30)
                force.x = (force.x >= 0 and math.min(force.x, 1000) or math.max(force.x, -1000))
                force.y = (force.y >= 0 and math.min(force.y, 1000) or math.max(force.y, -1000))
                force.z = (force.z >= 0 and math.min(force.z, 1000) or math.max(force.z, -1000))
                zeta.loco:SetVelocity(zeta.loco:GetVelocity()+force)
            end
        end,
    }, 


GLOCK_AUTO = {
    mdl = 'models/weapons/w_pist_glock18.mdl',
    hidewep = false,
    offPos = Vector(0,0,0),   
    offAng = Angle(0,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 20,
    prettyPrint = 'Glock 18 Auto',

    anims = {
        idle = ACT_HL2MP_IDLE_PISTOL,
        move = ACT_HL2MP_RUN_PISTOL,
        jump = ACT_HL2MP_JUMP_PISTOL,
        crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
    },

    fireData = {
        rateMin = 0.08,
        rateMax = 0.28,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/glock/glock18-1.wav",

        dmgMin = 4,
        dmgMax = 8,
        force = 10,
        num = 1,
        ammo = '9mm',
        spread = 0.15,
        tracer = 'Tracer',

    },

    shellData = {
        name = 'ShellEject',
        offPos = {
            forward = 0,
            right = 0,
            up = 3
        },
        offAng = Angle(0,-90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        time = 1.5,
        snds = {
            {0.3, 'zetaplayer/weapon/glock/glock_clipout.wav'},
            {0.7, 'zetaplayer/weapon/glock/glock_clipin.wav'},
            {1.3, 'zetaplayer/weapon/glock/glock_sliderelease.wav'},
        }
    }
}, 

GLOCK_SEMI = {
    mdl = 'models/weapons/w_pist_glock18.mdl',
    hidewep = false,
    offPos = Vector(0,0,0),   
    offAng = Angle(0,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 20,
    prettyPrint = 'Glock 18 Semi-Auto',

    anims = {
        idle = ACT_HL2MP_IDLE_PISTOL,
        move = ACT_HL2MP_RUN_PISTOL,
        jump = ACT_HL2MP_JUMP_PISTOL,
        crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
    },

    fireData = {
        rateMin = 0.15,
        rateMax = 0.35,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/glock/glock18-1.wav",

        dmgMin = 6,
        dmgMax = 12,
        force = 12,
        num = 1,
        ammo = '9mm',
        spread = 0.10,
        tracer = 'Tracer',

    },

    shellData = {
        name = 'ShellEject',
        offPos = {
            forward = 0,
            right = 0,
            up = 3
        },
        offAng = Angle(0,-90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        time = 1.5,
        snds = {
            {0.3, 'zetaplayer/weapon/glock/glock_clipout.wav'},
            {0.7, 'zetaplayer/weapon/glock/glock_clipin.wav'},
            {1.3, 'zetaplayer/weapon/glock/glock_sliderelease.wav'},
        }
    }
}, 


DODS_US_AMERIKNIFE = {
    mdl = 'models/weapons/zetadods/w_amerk.mdl',
    hidewep = false,
    offPos = Vector(-2.5,-2,0),   
    offAng = Angle(0,0,0),
    lethal = true,
    range = false,
    melee = true,
    clip = 1,
    prettyPrint = 'M1 Trench Knife',

    anims = {
        idle = ACT_HL2MP_IDLE_KNIFE,
        move = ACT_HL2MP_RUN_KNIFE,
        jump = ACT_HL2MP_JUMP_KNIFE,
        crouch = ACT_HL2MP_WALK_CROUCH_KNIFE
    },

    fireData = {
        range = 48,
        preCallback = function(callback, zeta, wep, target, blockData)
            local firstSwing = false
            if CurTime() <= zeta.AttackCooldown then return
            elseif CurTime() > zeta.AttackCooldown + 0.3 then firstSwing = true end

            if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE) then zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE) end
            zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE, true)

            zeta:FaceTick(target, 100)

            local isBackstab = false
            local dmg = (firstSwing and 15 or 10)
            if GetConVar('zetaplayer_allowbackstabbing'):GetBool() then
                local backstabcheck = zeta:WorldToLocalAngles(target:GetAngles() + Angle(0,-90,0))
                if backstabcheck.y < -70 and backstabcheck.y > -100 then
                    isBackstab = true
                    dmg = target:Health() * 6
                    target:EmitSound('zetaplayer/misc/backstabbed'..math.random(3)..'.wav', 80)
                end
            end

            local dmginfo = DamageInfo()
            dmginfo:SetDamage(dmg/GetConVar("zetaplayer_damagedivider"):GetInt())
            dmginfo:SetAttacker(zeta)
            dmginfo:SetInflictor(wep)
            dmginfo:SetDamageType(DMG_SLASH)
            target:TakeDamageInfo(dmginfo)

            zeta.AttackCooldown = CurTime() + (isBackstab and 1.0 or 0.4)
            target:EmitSound('zetaplayer/weapon/dods_weapons/blade_hit'..math.random(4)..'.wav', 80)
        end
    }
}, 

DODS_US_COLT45 = {
    mdl = 'models/weapons/zetadods/w_colt.mdl',
    hidewep = false,
    offPos = Vector(-2.5,-1.25,0),   
    offAng = Angle(0,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 7,
    prettyPrint = 'Colt .45',

    anims = {
        idle = ACT_HL2MP_IDLE_PISTOL,
        move = ACT_HL2MP_RUN_PISTOL,
        jump = ACT_HL2MP_JUMP_PISTOL,
        crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
    },

    fireData = {
        rateMin = 0.25,
        rateMax = 0.6,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/dods_weapons/colt_shoot.wav",

        dmgMin = 4,
        dmgMax = 10,
        force = 10,
        num = 1,
        ammo = '45.ACP',
        spread = 0.1,
        tracer = 'Tracer',

    },

    shellData = {
        name = 'ShellEject',
        offPos = {
            forward = 0,
            right = 0,
            up = 3
        },
        offAng = Angle(0,-90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        time = 1.5,
        snds = {
            {0.3, 'zetaplayer/weapon/dods_weapons/colt_clipout.wav'},
            {0.7, 'zetaplayer/weapon/dods_weapons/colt_clipin.wav'},
            {1.1, 'zetaplayer/weapon/dods_weapons/colt_boltback.wav'},
            {1.3, 'zetaplayer/weapon/dods_weapons/colt_boltforward.wav'},
        }
    }
}, 

DODS_US_THOMPSON = {
    mdl = 'models/weapons/zetadods/w_thompson.mdl',
    
    hidewep = false,
    offPos = Vector(-1.8,-2,-1.25),   
    offAng = Angle(-12,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 30,
    prettyPrint = 'M1 Thompson',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    fireData = {
        rateMin = 0.085,
        rateMax = 0.51,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/dods_weapons/thompson_shoot.wav",

        dmgMin = 3,
        dmgMax = 9,
        force = 10,
        ammo = '45. ACP',
        spread = 0.135,
        tracer = 'Tracer',
    },

    shellData = {
        name = 'ShellEject',
        offPos = {
            forward = 0,
            right = 0,
            up = 3
        },
        offAng = Angle(0,-90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        time = 1.5,
        snds = {
            {0.3, 'zetaplayer/weapon/dods_weapons/thompson_clipout.wav'},
            {0.7, 'zetaplayer/weapon/dods_weapons/thompson_clipin.wav'},
            {1.0, 'zetaplayer/weapon/dods_weapons/thompson_boltback.wav'},
            {1.3, 'zetaplayer/weapon/dods_weapons/thompson_boltforward.wav'},
        }
    }
}, 

DODS_US_GARAND = {
    mdl = 'models/weapons/zetadods/w_garand.mdl',
    
    hidewep = false,
    offPos = Vector(-2.5,-2.25,-1),   
    offAng = Angle(-12,0,0),
    lethal = true,
    range = true,
    melee = false,
    keepDistance = 550,
    clip = 8,
    prettyPrint = 'M1 Garand',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    fireData = {
        rateMin = 0.37,
        rateMax = 1.0,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/dods_weapons/garand_shoot.wav",

        dmgMin = 6,
        dmgMax = 16,
        force = 20,
        ammo = '30.06 Springfield',
        spread = 0.14,
        tracer = 'Tracer'
    },

    shellData = {
        name = 'RifleShellEject',
        offPos = {
            forward = 10,
            right = 0,
            up = 3
        },
        offAng = Angle(0,-90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        time = 1.8,
        snds = {
            {0.0, 'zetaplayer/weapon/dods_weapons/garand_clipding.wav'},
            {0.7, 'zetaplayer/weapon/dods_weapons/garand_clipin1.wav'},
            {1.25, 'zetaplayer/weapon/dods_weapons/garand_clipin2.wav'},
            {1.6, 'zetaplayer/weapon/dods_weapons/garand_boltforward.wav'},
        }
    }
}, 

DODS_US_M1CARBINE = {
    mdl = 'models/weapons/zetadods/w_m1carb.mdl',
    
    hidewep = false,
    offPos = Vector(-2.25,-2.25,-1.5),   
    offAng = Angle(-12,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 15,
    prettyPrint = 'M1 Carbine',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    fireData = {
        rateMin = 0.25,
        rateMax = 0.9,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/dods_weapons/m1carbine_shoot.wav",

        dmgMin = 4,
        dmgMax = 12,
        force = 18,
        ammo = '.30 Carbine',
        spread = 0.125,
        tracer = 'Tracer'
    },

    shellData = {
        name = 'RifleShellEject',
        offPos = {
            forward = 10,
            right = 0,
            up = 3
        },
        offAng = Angle(0,-90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        time = 1.7,
        snds = {
            {0.3, 'zetaplayer/weapon/dods_weapons/m1carbine_clipout.wav'},
            {0.7, 'zetaplayer/weapon/dods_weapons/m1carbine_clipin1.wav'},
            {1.0, 'zetaplayer/weapon/dods_weapons/m1carbine_clipin2.wav'},
            {1.3, 'zetaplayer/weapon/dods_weapons/m1carbine_boltback.wav'},
            {1.5, 'zetaplayer/weapon/dods_weapons/m1carbine_boltforward.wav'},
        }
    }
}, 

DODS_US_BAR = {
    mdl = 'models/weapons/zetadods/w_bar.mdl',
    
    hidewep = false,
    offPos = Vector(-2.5,-2.25,-1),   
    offAng = Angle(-12,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 20,
    prettyPrint = 'M1918 Browning Auto Rifle',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    fireData = {
        rateMin = 0.12,
        rateMax = 0.33,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/dods_weapons/bar_shoot.wav",

        dmgMin = 6,
        dmgMax = 12,
        force = 18,
        ammo = '30.06 Springfield',
        spread = 0.175,
        tracer = 'Tracer'
    },

    shellData = {
        name = 'RifleShellEject',
        offPos = {
            forward = 10,
            right = 0,
            up = 3
        },
        offAng = Angle(0,-90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        time = 1.7,
        snds = {
            {0.3, 'zetaplayer/weapon/dods_weapons/bar_clipout.wav'},
            {0.7, 'zetaplayer/weapon/dods_weapons/bar_clipin1.wav'},
            {1.0, 'zetaplayer/weapon/dods_weapons/bar_clipin2.wav'},
            {1.3, 'zetaplayer/weapon/dods_weapons/bar_boltback.wav'},
            {1.5, 'zetaplayer/weapon/dods_weapons/bar_boltforward.wav'},
        }
    }
}, 

DODS_US_SPRINGFIELD = {
    mdl = 'models/weapons/zetadods/w_spring.mdl',
    
    hidewep = false,
    offPos = Vector(-2.25,-2.25,-1.7),   
    offAng = Angle(-10.9,0,0),
    lethal = true,
    keepDistance = 1000,
    range = true,
    melee = false,
    clip = 5,
    prettyPrint = 'Springfield',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    fireData = {
        rateMin = 1.0,
        rateMax = 1.75,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/dods_weapons/spring_shoot.wav",

        dmgMin = 16,
        dmgMax = 40,
        force = 15,
        num = 1,
        ammo = '30.06 Springfield',
        spread = 0.06,
        tracer = 'Tracer',

        -- Called before playing fire animation
        preCallback = function(callback, zeta, wep, target, blockData)
            blockData.shell = true
            timer.Simple(0.2,function()
                if !zeta:IsValid() or !IsValid(wep) then return end
                wep:EmitSound('zetaplayer/weapon/dods_weapons/k98_boltpull.wav',80)
                zeta:CreateShellEject()
            end)

            if GetConVar("zetaplayer_allowmlgshots"):GetInt() == 1 and math.random(1,15) == 1 then
                wep:EmitSound('zetaplayer/weapon/awp/awp_crit.wav',80)

                blockData.bullet = true
                local pos = target:GetPos()+target:OBBCenter()

                FireBulletsTABLE.Attacker = zeta
                FireBulletsTABLE.Damage = 115/GetConVar("zetaplayer_damagedivider"):GetFloat()
                FireBulletsTABLE.Force = 30+GetConVar("zetaplayer_forceadd"):GetInt()
                FireBulletsTABLE.HullSize = 5
                FireBulletsTABLE.AmmoType = '30.06 Springfield'
                FireBulletsTABLE.TracerName = 'Tracer'
                FireBulletsTABLE.Dir = (pos-wep:GetPos()):GetNormalized()
                FireBulletsTABLE.Src = wep:GetPos()
                FireBulletsTABLE.Spread = Vector(0,0,0)
                FireBulletsTABLE.IgnoreEntity = zeta

                wep:FireBullets(FireBulletsTABLE)
            end

            return blockData
        end
    },

    shellData = {
        name = 'RifleShellEject',
        offPos = {
            forward = -6,
            right = -1,
            up = 6
        },
        offAng = Angle(0,-90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        time = 1.7,
        snds = {
            {0.0, 'zetaplayer/weapon/dods_weapons/k98_clipout.wav'},
            {0.6, 'zetaplayer/weapon/dods_weapons/k98_clipin.wav'},
            {1.2, 'zetaplayer/weapon/dods_weapons/k98_clipin2.wav'},
            {1.6, 'zetaplayer/weapon/dods_weapons/k98_boltpull'},
        }
    }
}, 

DODS_US_30CAL = {
		mdl = 'models/weapons/zetadods/w_30cal.mdl',
        
        hidewep = false,
        offPos = Vector(-2.2,-2.2,0.75),
        offAng = Angle(-5,0,5),
        lethal = true,
        range = true,
        melee = false,
        clip = 150,
        prettyPrint = 'M1919 Browning Machine Gun',
    
        anims = {
            idle = ACT_HL2MP_IDLE_CROSSBOW,
            move = ACT_HL2MP_RUN_CROSSBOW,
            jump = ACT_HL2MP_JUMP_CROSSBOW,
            crouch = ACT_HL2MP_WALK_CROUCH_CROSSBOW
        },
    
        fireData = {
            rateMin = 0.1,
            rateMax = 0.25,
            anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
            muzzleFlash = 1,
			snd = "zetaplayer/weapon/dods_weapons/30cal_shoot.wav",
    
            dmgMin = 8,
            dmgMax = 13,
            force = 16,
            ammo = '30.06 Springfield',
            spread = 0.18,
            tracer = 'Tracer'
        },
    
        shellData = {
            name = 'RifleShellEject',
            offPos = {
                forward = 10,
                right = 0,
                up = 3
            },
            offAng = Angle(0,-90,0)
        },
    
        reloadData = {
            anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
            time = 2.0,
            snds = {
				{0, 'zetaplayer/weapon/dods_weapons/30cal_coverup.wav'},
				{0.7, 'zetaplayer/weapon/dods_weapons/30cal_bulletchain1.wav'},
                {1.25, 'zetaplayer/weapon/dods_weapons/30cal_bulletchain2.wav'},
				{1.4, 'zetaplayer/weapon/dods_weapons/30cal_coverdown.wav'},
				{1.6, 'zetaplayer/weapon/dods_weapons/30cal_boltback.wav'},
                {1.75, 'zetaplayer/weapon/dods_weapons/30cal_boltforward.wav'},
            }
        }
    }, 

DODS_US_BAZOOKA = {
    mdl = 'models/weapons/zetadods/w_bazooka.mdl',
    
    hidewep = false,
    offPos = Vector(13,-1,2),   
    offAng = Angle(10,180,0),
    lethal = true,
    range = true,
    keepDistance = 1000,
    isExplosive = true,
    melee = false,
    clip = 1,
    prettyPrint = 'M1 Bazooka',

    anims = {
        idle = ACT_HL2MP_IDLE_RPG,
        move = ACT_HL2MP_RUN_RPG,
        jump = ACT_HL2MP_JUMP_RPG,
        crouch = ACT_HL2MP_WALK_CROUCH_RPG
    },

    fireData = {
        rateMin = 3,
        rateMax = 6,    

        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG,
        muzzleFlash = 7,
        snd = 'zetaplayer/weapon/dods_weapons/rocket1.wav',

        preCallback = function(callback, zeta, wep, target, blockData)
            local behindtrace = util.TraceLine({
                start = wep:GetPos()+wep:OBBCenter(),
                endpos = target:GetPos()+target:OBBCenter(),
                filter = target
            })
            if behindtrace.Hit then blockData = nil return end

            local missilepos = wep:GetAttachment(1).Pos+wep:GetAttachment(1).Ang:Forward()*100+Vector(0,0,15)
            if !util.IsInWorld(missilepos) then blockData = nil return end


            blockData.bullet = true
            blockData.shell = true

            local pos = target:GetPos()+target:OBBCenter()
            if target:GetClass() == "npc_zetaplayer" then pos = target:GetPos() end

            local missile = ents.Create('rpg_missile')
            missile:SetPos(missilepos)
            missile:SetAngles((pos-wep:GetPos()):Angle())
            missile:SetOwner(zeta)
            missile:Spawn()

            missile:CallOnRemove('missileexplode'..missile:EntIndex(),function()
                missile:StopSound('weapons/rpg/rocket1.wav')
                util.BlastDamage(missile,(zeta:IsValid()) and zeta or missile,missile:GetPos(),260,210/GetConVar("zetaplayer_damagedivider"):GetFloat())
            end)

            return blockData
        end
    },

    shellData = {
        name = 'ShellEject',
        offPos = {
            forward = 0,
            right = 0,
            up = 3
        },
        offAng = Angle(0,90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        time = 1.5,
        snds = {
            {0, 'zetaplayer/weapon/dods_weapons/rocket_reload.wav'},
        }
    }
}, 



DODS_AXIS_SPADE = {
    mdl = 'models/weapons/zetadods/w_spade.mdl',
    hidewep = false,
    offPos = Vector(-2.5,-2,0),   
    offAng = Angle(0,0,0),
    lethal = true,
    range = false,
    melee = true,
    clip = 1,
    prettyPrint = 'German Entrenching Spade Shovel',

    anims = {
        idle = ACT_HL2MP_IDLE_MELEE,
        move = ACT_HL2MP_RUN_MELEE,
        jump = ACT_HL2MP_JUMP_MELEE,
        crouch = ACT_HL2MP_WALK_CROUCH_MELEE
    },

    changeCallback = function(callback, zeta, wep)
        if GetConVar('zetaplayer_spawnweapon'):GetString() == 'DOD_AXIS_SPADE' and !wep.CanPlayDeploySnd then 
            wep.CanPlayDeploySnd = true
            return 
        end
        wep:EmitSound('zetaplayer/weapon/dods_weapons/shovel_tool_deploy_1.wav', 70)
    end,

    fireData = {
        preCallback = function(callback, zeta, wep, target, blockData)
            if CurTime() <= zeta.AttackCooldown then return end
            zeta.AttackCooldown = CurTime() + 0.5

            if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE) then
                zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)
            end
            zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE,true)

            zeta:FaceTick(target,100)

            target:EmitSound('zetaplayer/weapon/dods_weapons/shovel_tool_swing_miss'..math.random(2)..'.wav', 65)

            timer.Simple(0.25, function()
                if !IsValid(zeta) or zeta.IsDead or !IsValid(target) or zeta:GetRangeSquaredTo(target) > (75*75) then return end

                local dmg = DamageInfo()
                dmg:SetDamage(math.random(12,30)/GetConVar("zetaplayer_damagedivider"):GetInt())
                dmg:SetAttacker(zeta)
                dmg:SetInflictor(wep)
                dmg:SetDamageType(DMG_CLUB)
                target:TakeDamageInfo(dmg)

                target:EmitSound('zetaplayer/weapon/dods_weapons/shovel_tool_hit_0'..math.random(3)..'.wav', 80)
            end)
        end
    },
}, 

DODS_AXIS_P38 = {
    mdl = 'models/weapons/zetadods/w_p38.mdl',
    hidewep = false,
    offPos = Vector(-2.5,-1.25,-0.3),   
    offAng = Angle(-5,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 8,
    prettyPrint = 'Walther P38',

    anims = {
        idle = ACT_HL2MP_IDLE_PISTOL,
        move = ACT_HL2MP_RUN_PISTOL,
        jump = ACT_HL2MP_JUMP_PISTOL,
        crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
    },

    fireData = {
        rateMin = 0.25,
        rateMax = 0.6,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/dods_weapons/p38_shoot.wav",

        dmgMin = 4,
        dmgMax = 10,
        force = 10,
        num = 1,
        ammo = '9mm Parabellum',
        spread = 0.12,
        tracer = 'Tracer',

    },

    shellData = {
        name = 'ShellEject',
        offPos = {
            forward = 0,
            right = 0,
            up = 3
        },
        offAng = Angle(0,-90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        time = 1.5,
        snds = {
            {0.3, 'zetaplayer/weapon/dods_weapons/p38_clipout.wav'},
            {0.7, 'zetaplayer/weapon/dods_weapons/p38_clipin.wav'},
            {1.1, 'zetaplayer/weapon/dods_weapons/p38_boltback.wav'},
            {1.3, 'zetaplayer/weapon/dods_weapons/p38_boltforward.wav'},
        }
    }
}, 

DODS_AXIS_C96 = {
    mdl = 'models/weapons/zetadods/w_c96.mdl',
    hidewep = false,
    offPos = Vector(-2,-1.25,-0.3),   
    offAng = Angle(-5,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 20,
    prettyPrint = 'Mauser C96',

    anims = {
        idle = ACT_HL2MP_IDLE_PISTOL,
        move = ACT_HL2MP_RUN_PISTOL,
        jump = ACT_HL2MP_JUMP_PISTOL,
        crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
    },

    fireData = {
        rateMin = 0.065,
        rateMax = 0.2,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/dods_weapons/c96_shoot.wav",

        dmgMin = 4,
        dmgMax = 8,
        force = 10,
        num = 1,
        ammo = '9mm Parabellum',
        spread = 0.13,
        tracer = 'Tracer',

    },

    shellData = {
        name = 'ShellEject',
        offPos = {
            forward = 0,
            right = 0,
            up = 3
        },
        offAng = Angle(0,-90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        time = 1.7,
        snds = {
            {0.3, 'zetaplayer/weapon/dods_weapons/c96_clipout.wav'},
            {0.7, 'zetaplayer/weapon/dods_weapons/c96_clipin1.wav'},
            {1.0, 'zetaplayer/weapon/dods_weapons/c96_clipin2.wav'},
            {1.3, 'zetaplayer/weapon/dods_weapons/c96_boltback.wav'},
            {1.5, 'zetaplayer/weapon/dods_weapons/c96_boltforward.wav'},
        }
    }
}, 

DODS_AXIS_MP40 = {
    mdl = 'models/weapons/zetadods/w_mp40.mdl',
    
    hidewep = false,
    offPos = Vector(-2.4,-1.65,-0.5),   
    offAng = Angle(-12,3,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 32,
    prettyPrint = 'Maschinenpistole 40',

    anims = {
        idle = ACT_HL2MP_IDLE_SMG1,
        move = ACT_HL2MP_RUN_SMG1,
        jump = ACT_HL2MP_JUMP_SMG1,
        crouch = ACT_HL2MP_WALK_CROUCH_SMG1
    },

    fireData = {
        rateMin = 0.12,
        rateMax = 0.575,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/dods_weapons/mp40_shoot.wav",

        dmgMin = 4,
        dmgMax = 9,
        force = 10,
        ammo = '9mm Parabellum',
        spread = 0.14,
        tracer = 'Tracer',
    },

    shellData = {
        name = 'ShellEject',
        offPos = {
            forward = 0,
            right = 0,
            up = 3
        },
        offAng = Angle(0,-90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        time = 1.5,
        snds = {
            {0.3, 'zetaplayer/weapon/dods_weapons/mp40_clipout.wav'},
            {0.7, 'zetaplayer/weapon/dods_weapons/mp40_clipin.wav'},
            {1.0, 'zetaplayer/weapon/dods_weapons/mp40_boltback.wav'},
            {1.3, 'zetaplayer/weapon/dods_weapons/mp40_boltforward.wav'},
        }
    }
}, 

DODS_AXIS_KAR98k = {
    mdl = 'models/weapons/zetadods/w_k98.mdl',
    
    hidewep = false,
    offPos = Vector(-2.5,-2.25,-1.65),   
    offAng = Angle(-10.9,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 5,
    keepDistance = 550,
    prettyPrint = 'Karabiner 98k',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    fireData = {
        rateMin = 1,
        rateMax = 1.75,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/dods_weapons/k98_shoot.wav",

        dmgMin = 6,
        dmgMax = 18,
        force = 15,
        num = 1,
        ammo = '7.92 Mauser',
        spread = 0.125,
        tracer = 'Tracer',

        -- Called before playing fire animation
        preCallback = function(callback, zeta, wep, target, blockData)
            blockData.shell = true
            timer.Simple(0.2,function()
                if !zeta:IsValid() or !IsValid(wep) then return end
                wep:EmitSound('zetaplayer/weapon/dods_weapons/k98_boltpull.wav',80)
                zeta:CreateShellEject()
            end)

            return blockData
        end
    },

    shellData = {
        name = 'RifleShellEject',
        offPos = {
            forward = -6,
            right = -1,
            up = 6
        },
        offAng = Angle(0,-90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        time = 1.7,
        snds = {
            {0.0, 'zetaplayer/weapon/dods_weapons/k98_clipout.wav'},
            {0.6, 'zetaplayer/weapon/dods_weapons/k98_clipin.wav'},
            {1.2, 'zetaplayer/weapon/dods_weapons/k98_clipin2.wav'},
            {1.6, 'zetaplayer/weapon/dods_weapons/k98_boltpull'},
        }
    }
}, 

DODS_AXIS_KAR98KSNIPER = {
    mdl = 'models/weapons/zetadods/w_k98s.mdl',
    
    hidewep = false,
    offPos = Vector(-2.5,-2.25,-1.65),   
    offAng = Angle(-10.9,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 5,
    prettyPrint = 'Karabiner 98k (Sniper)',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    fireData = {
        rateMin = 1.25,
        rateMax = 1.75,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/dods_weapons/k98scoped_shoot.wav",

        dmgMin = 15,
        dmgMax = 30,
        force = 15,
        num = 1,
        ammo = '7.92 Mauser',
        spread = 0.075,
        tracer = 'Tracer',

        -- Called before playing fire animation
        preCallback = function(callback, zeta, wep, target, blockData)
            blockData.shell = true
            timer.Simple(0.2,function()
                if !zeta:IsValid() or !IsValid(wep) then return end
                wep:EmitSound('zetaplayer/weapon/dods_weapons/k98_boltpull.wav',80)
                zeta:CreateShellEject()
            end)

            if GetConVar("zetaplayer_allowmlgshots"):GetInt() == 1 and math.random(1,15) == 1 then
                wep:EmitSound('zetaplayer/weapon/awp/awp_crit.wav',80)

                blockData.bullet = true
                local pos = target:GetPos()+target:OBBCenter()

                FireBulletsTABLE.Attacker = zeta
                FireBulletsTABLE.Damage = 115/GetConVar("zetaplayer_damagedivider"):GetFloat()
                FireBulletsTABLE.Force = 30+GetConVar("zetaplayer_forceadd"):GetInt()
                FireBulletsTABLE.HullSize = 5
                FireBulletsTABLE.AmmoType = '7.92 Mauser'
                FireBulletsTABLE.TracerName = 'Tracer'
                FireBulletsTABLE.Dir = (pos-wep:GetPos()):GetNormalized()
                FireBulletsTABLE.Src = wep:GetPos()
                FireBulletsTABLE.Spread = Vector(0,0,0)
                FireBulletsTABLE.IgnoreEntity = zeta

                wep:FireBullets(FireBulletsTABLE)
            end

            return blockData
        end
    },

    shellData = {
        name = 'RifleShellEject',
        offPos = {
            forward = -6,
            right = -1,
            up = 6
        },
        offAng = Angle(0,-90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        time = 1.7,
        snds = {
            {0.0, 'zetaplayer/weapon/dods_weapons/k98_clipout.wav'},
            {0.6, 'zetaplayer/weapon/dods_weapons/k98_clipin.wav'},
            {1.2, 'zetaplayer/weapon/dods_weapons/k98_clipin2.wav'},
            {1.6, 'zetaplayer/weapon/dods_weapons/k98_boltpull'},
        }
    }
}, 


DODS_AXIS_MG42 = {
    mdl = 'models/weapons/zetadods/w_mg42bu.mdl',
    
    hidewep = false,
    offPos = Vector(-2.2,-2,-1.5),   
    offAng = Angle(-5,0,5),
    lethal = true,
    range = true,
    melee = false,
    clip = 250,
    prettyPrint = 'Maschinengewehr 42',

    anims = {
        idle = ACT_HL2MP_IDLE_CROSSBOW,
        move = ACT_HL2MP_RUN_CROSSBOW,
        jump = ACT_HL2MP_JUMP_CROSSBOW,
        crouch = ACT_HL2MP_WALK_CROUCH_CROSSBOW
    },

    fireData = {
        rateMin = 0.065,
        rateMax = 0.25,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/dods_weapons/mg42_shoot.wav",

        dmgMin = 8,
        dmgMax = 13,
        force = 20,
        ammo = '7.92 Mauser',
        spread = 0.2,
        tracer = 'Tracer'
    },

    shellData = {
        name = 'RifleShellEject',
        offPos = {
            forward = 10,
            right = 0,
            up = 3
        },
        offAng = Angle(0,-90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        time = 2.0,
        snds = {
            {0, 'zetaplayer/weapon/dods_weapons/mg42_coverup.wav'},
            {0.7, 'zetaplayer/weapon/dods_weapons/mg42_bulletchain1.wav'},
            {1.25, 'zetaplayer/weapon/dods_weapons/mg42_bulletchain2.wav'},
            {1.4, 'zetaplayer/weapon/dods_weapons/mg42_coverdown.wav'},
            {1.6, 'zetaplayer/weapon/dods_weapons/mg42_boltback.wav'},
            {1.75, 'zetaplayer/weapon/dods_weapons/mg42_boltforward.wav'},
        }
    }
}, 

DODS_AXIS_PANZERSCHRECK = {
    mdl = 'models/weapons/zetadods/w_pschreck.mdl',
    
    hidewep = false,
    offPos = Vector(13,-1,2),   
    offAng = Angle(10,180,0),
    keepDistance = 1000,
    lethal = true,
    range = true,
    isExplosive = true,
    melee = false,
    clip = 1,
    prettyPrint = 'Panzerschreck 54',

    anims = {
        idle = ACT_HL2MP_IDLE_RPG,
        move = ACT_HL2MP_RUN_RPG,
        jump = ACT_HL2MP_JUMP_RPG,
        crouch = ACT_HL2MP_WALK_CROUCH_RPG
    },

    fireData = {
        rateMin = 3,
        rateMax = 6,    

        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG,
        muzzleFlash = 7,
        snd = 'zetaplayer/weapon/dods_weapons/rocket1.wav',

        preCallback = function(callback, zeta, wep, target, blockData)
            local behindtrace = util.TraceLine({
                start = wep:GetPos()+wep:OBBCenter(),
                endpos = target:GetPos()+target:OBBCenter(),
                filter = target
            })
            if behindtrace.Hit then blockData = nil return end

            local missilepos = wep:GetAttachment(1).Pos+wep:GetAttachment(1).Ang:Forward()*100+Vector(0,0,15)
            if !util.IsInWorld(missilepos) then blockData = nil return end


            blockData.bullet = true
            blockData.shell = true

            local pos = target:GetPos()+target:OBBCenter()
            if target:GetClass() == "npc_zetaplayer" then pos = target:GetPos() end

            local missile = ents.Create('rpg_missile')
            missile:SetPos(missilepos)
            missile:SetAngles((pos-wep:GetPos()):Angle())
            missile:SetOwner(zeta)
            missile:Spawn()

            missile:CallOnRemove('missileexplode'..missile:EntIndex(),function()
                if !zeta:IsValid() then return end
                missile:StopSound('weapons/rpg/rocket1.wav')
                util.BlastDamage(missile,(zeta:IsValid()) and zeta or missile,missile:GetPos(),260,210/GetConVar("zetaplayer_damagedivider"):GetFloat())
            end)

            return blockData
        end
    },

    shellData = {
        name = 'ShellEject',
        offPos = {
            forward = 0,
            right = 0,
            up = 3
        },
        offAng = Angle(0,90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        time = 1.5,
        snds = {
            {0, 'zetaplayer/weapon/dods_weapons/rocket_reload.wav'},
        }
    }
}, 

DODS_AXIS_MP44 = {
    mdl = 'models/weapons/zetadods/w_mp44.mdl',
    
    hidewep = false,
    offPos = Vector(-1.8,-2,-1.8),   
    offAng = Angle(-12,3,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 30,
    prettyPrint = 'Sturmgewehr 44',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    fireData = {
        rateMin = 0.12,
        rateMax = 0.36,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/dods_weapons/mp44_shoot.wav",

        dmgMin = 3,
        dmgMax = 12,
        force = 10,
        ammo = '7.92 Kurtz',
        spread = 0.16,
        tracer = 'Tracer',
    },

    shellData = {
        name = 'RifleShellEject',
        offPos = {
            forward = 0,
            right = 0,
            up = 3
        },
        offAng = Angle(0,-90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        time = 1.7,
        snds = {
            {0.3, 'zetaplayer/weapon/dods_weapons/mp44_clipout.wav'},
            {0.7, 'zetaplayer/weapon/dods_weapons/mp44_clipin1.wav'},
            {1.0, 'zetaplayer/weapon/dods_weapons/mp44_clipin2.wav'},
            {1.3, 'zetaplayer/weapon/dods_weapons/mp44_boltback.wav'},
            {1.5, 'zetaplayer/weapon/dods_weapons/mp44_boltforward.wav'},
        }
    }
}, 

L4D_PISTOL_P220 = {
    mdl = "models/zetal4d2_laststand_mdls/w_pistol_a.mdl",
    hidewep = false,
    offPos = Vector(-2, -0.5, 0),   
    offAng = Angle(-6, 0, 2.5),
    lethal = true,
    range = true,
    melee = false,
    clip = 15,
    prettyPrint = "[L4D2] SIG Sauer P220",

    anims = {
        idle = ACT_HL2MP_IDLE_PISTOL,
        move = ACT_HL2MP_RUN_PISTOL,
        jump = ACT_HL2MP_JUMP_PISTOL,
        crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
    },

    changeCallback = function(callback, zeta, wep)
        zeta.AttackCooldown = CurTime() + 0.95
        wep:EmitSound("zetaplayer/weapon/l4d_weapons/pistol_p220/pistol_deploy_1.wav", nil, nil, nil, CHAN_ITEM)
        timer.Simple(0.2, function()
            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "L4D_PISTOL_P220" then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/pistol_p220/pistol_slideback_1.wav", nil, nil, nil, CHAN_ITEM)
        end)
        timer.Simple(0.433, function()
            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "L4D_PISTOL_P220" then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/pistol_p220/pistol_slideforward_1.wav", nil, nil, nil, CHAN_ITEM)
        end)
    end,

    fireData = {
        rateMin = 0.225,
        rateMax = 0.45,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/l4d_weapons/pistol_p220/pistol_fire.wav",

        dmgMin = 11,
        dmgMax = 13,
        force = 12,
        num = 1,
        ammo = "10mm Auto",
        spread = 0.125,
        tracer = "Tracer",
    },

    shellData = {
        name = "ShellEject",
        offPos = {
            forward = 5,
            right = 0,
            up = 3
        },
        offAng = Angle(0, -90, 0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        time = function(zeta, wep)
            local snds = {
                {0.366, "zetaplayer/weapon/l4d_weapons/pistol_p220/pistol_clip_out_1.wav"},
                {1.133, "zetaplayer/weapon/l4d_weapons/pistol_p220/pistol_clip_in_1.wav"},
                {1.233, "zetaplayer/weapon/l4d_weapons/pistol_p220/pistol_clip_locked_1.wav"}
            }
            local finTime = 1.66
            if zeta.CurrentAmmo == 0 then
                finTime = 2.0
                snds[#snds+1] = {1.533, "zetaplayer/weapon/l4d_weapons/pistol_p220/pistol_slideforward_1.wav"}
            end

            for i = 1, #snds do
                timer.Simple(snds[i][1], function() 
                    if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "L4D_PISTOL_P220" then return end
                    wep:EmitSound(snds[i][2], nil, nil, nil, CHAN_ITEM)
                end)
            end

            return finTime
        end
    }
}, 
-- w_pistol_b model needs to be decompiled to fix muzzleflash incorrect orign (muzzleflash points up), muzzle is disabled for now.
L4D_PISTOL_GLOCK26 = {
    mdl = "models/zetal4d2_laststand_mdls/w_pistol_b.mdl",
    hidewep = false,
    offPos = Vector(-2, -0.5, -0.25),   
    offAng = Angle(-6, 0, 2.5),
    lethal = true,
    range = true,
    melee = false,
    clip = 15,
    prettyPrint = "[L4D2] Glock 26",

    anims = {
        idle = ACT_HL2MP_IDLE_PISTOL,
        move = ACT_HL2MP_RUN_PISTOL,
        jump = ACT_HL2MP_JUMP_PISTOL,
        crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
    },

    changeCallback = function(callback, zeta, wep)
        zeta.AttackCooldown = CurTime() + 0.95
        wep:EmitSound("zetaplayer/weapon/l4d_weapons/pistol_p220/pistol_deploy_1.wav", 70)
        timer.Simple(0.2, function()
            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "L4D_PISTOL_GLOCK26" then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/pistol_p220/pistol_slideback_1.wav", nil, nil, nil, CHAN_ITEM)
        end)
        timer.Simple(0.433, function()
            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "L4D_PISTOL_GLOCK26" then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/pistol_p220/pistol_slideforward_1.wav", nil, nil, nil, CHAN_ITEM)
        end)
    end,

    fireData = {
        rateMin = 0.225,
        rateMax = 0.45,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/l4d_weapons/pistol_p220/pistol_dual_fire.wav",

        dmgMin = 11,
        dmgMax = 13,
        force = 12,
        num = 1,
        ammo = "10mm Auto",
        spread = 0.125,
        tracer = "Tracer",
    },

    shellData = {
        name = "ShellEject",
        offPos = {
            forward = 4,
            right = 0,
            up = 4
        },
        offAng = Angle(0, -90, 0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        time = function(zeta, wep)
            local snds = {
                {0.366, "zetaplayer/weapon/l4d_weapons/pistol_p220/pistol_clip_out_1.wav"},
                {1.133, "zetaplayer/weapon/l4d_weapons/pistol_p220/pistol_clip_in_1.wav"},
                {1.233, "zetaplayer/weapon/l4d_weapons/pistol_p220/pistol_clip_locked_1.wav"}
            }
            local finTime = 1.66
            if zeta.CurrentAmmo == 0 then
                finTime = 2.0
                snds[#snds+1] = {1.533, "zetaplayer/weapon/l4d_weapons/pistol_p220/pistol_slideforward_1.wav"}
            end

            for i = 1, #snds do
                timer.Simple(snds[i][1], function() 
                    if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "L4D_PISTOL_GLOCK26" then return end
                    wep:EmitSound(snds[i][2], nil, nil, nil, CHAN_ITEM)
                end)
            end

            return finTime
        end
    }
}, 

L4D_PISTOL_MAGNUM = {
    mdl = "models/zetal4d2_laststand_mdls/w_desert_eagle.mdl",
    hidewep = false,
    offPos = Vector(-0.25, 0, -2),   
    offAng = Angle(-12, 0, 2.5),
    lethal = true,
    range = true,
    melee = false,
    clip = 8,
    prettyPrint = "[L4D2] Magnum",

    anims = {
        idle = ACT_HL2MP_IDLE_REVOLVER,
        move = ACT_HL2MP_RUN_REVOLVER,
        jump = ACT_HL2MP_JUMP_REVOLVER,
        crouch = ACT_HL2MP_WALK_CROUCH_REVOLVER
    },

    changeCallback = function(callback, zeta, wep)
        zeta.AttackCooldown = CurTime() + 0.95
        wep:EmitSound("zetaplayer/weapon/l4d_weapons/magnum/pistol_deploy_1.wav", nil, nil, nil, CHAN_ITEM)
        timer.Simple(0.25, function()
            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "L4D_PISTOL_MAGNUM" then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/magnum/pistol_slideback_1.wav", nil, nil, nil, CHAN_ITEM)
        end)
        timer.Simple(0.45, function()
            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "L4D_PISTOL_MAGNUM" then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/magnum/pistol_slideforward_1.wav", nil, nil, nil, CHAN_ITEM)
        end)
    end,

    fireData = {
        rateMin = 0.35,
        rateMax = 0.85,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/l4d_weapons/magnum/magnum_shoot.wav",

        dmgMin = 32,
        dmgMax = 34,
        force = 14,
        num = 1,
        ammo = ".44 Magnum",
        spread = 0.125,
        tracer = "Tracer",
    },

    shellData = {
        name = "ShellEject",
        offPos = {
            forward = 4,
            right = -1,
            up = 7
        },
        offAng = Angle(0, -90, 0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        time = function(zeta, wep)
            local snds = {
                {0.366, "zetaplayer/weapon/l4d_weapons/magnum/pistol_clip_out_1.wav"},
                {1.0, "zetaplayer/weapon/l4d_weapons/magnum/pistol_clip_in_1.wav"},
                {1.2, "zetaplayer/weapon/l4d_weapons/magnum/pistol_clip_locked_1.wav"}
            }
            local finTime = 1.66
            if zeta.CurrentAmmo == 0 then
                finTime = 2.0
                snds[#snds+1] = {1.533, "zetaplayer/weapon/l4d_weapons/magnum/pistol_slideforward_1.wav"}
            end

            for i = 1, #snds do
                timer.Simple(snds[i][1], function() 
                    if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "L4D_PISTOL_MAGNUM" then return end
                    wep:EmitSound(snds[i][2], nil, nil, nil, CHAN_ITEM)
                end)
            end

            return finTime
        end
    }
}, 

L4D_SMG = {
    mdl = "models/zetal4d2_laststand_mdls/w_smg_uzi.mdl",
    hidewep = false,
    offPos = Vector(-1.1, -0.75, -0.8),
    offAng = Angle(-12, -1.5, 0),
    lethal = true,
    range = true,
    melee = false,
    clip = 50,
    prettyPrint = "[L4D2] Submachine Gun",

    anims = {
        idle = ACT_HL2MP_IDLE_RPG,
        move = ACT_HL2MP_RUN_RPG,
        jump = ACT_HL2MP_JUMP_RPG,
        crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
    },

    changeCallback = function(callback, zeta, wep)
        zeta.AttackCooldown = CurTime() + 0.95
        wep:EmitSound("zetaplayer/weapon/l4d_weapons/smg/smg_deploy_1.wav", nil, nil, nil, CHAN_ITEM)
        timer.Simple(0.33, function()
            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "L4D_SMG" then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/smg/smg_slideback_1.wav", nil, nil, nil, CHAN_ITEM)
        end)
        timer.Simple(0.733, function()
            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "L4D_SMG" then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/smg/smg_slideforward_1.wav", nil, nil, nil, CHAN_ITEM)
        end)
    end,

    fireData = {
        rateMin = 0.0625,
        rateMax = 0.09,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/l4d_weapons/smg/smg_fire_1.wav",

        dmgMin = 5,
        dmgMax = 7,
        force = 10,
        num = 1,
        ammo = "9mm Parabellum",
        spread = 0.14,
        tracer = "Tracer",
    },

    shellData = {
        name = "ShellEject",
        offPos = {
            forward = 3,
            right = 0,
            up = 3
        },
        offAng = Angle(0, -90, 0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        time = 2.233,
        snds = {
            {0.55, "zetaplayer/weapon/l4d_weapons/smg/smg_clip_out_1.wav"},
            {0.88, "zetaplayer/weapon/l4d_weapons/smg/smg_clip_in_1.wav"},
            {1.0, "zetaplayer/weapon/l4d_weapons/smg/smg_clip_locked_1.wav"},
            {1.61, "zetaplayer/weapon/l4d_weapons/smg/smg_slideback_1.wav"},
            {1.76, "zetaplayer/weapon/l4d_weapons/smg/smg_slideforward_1.wav"}
        }
    }
}, 

L4D_SMG_SILENCED = {
    mdl = "models/zetal4d2_laststand_mdls/w_smg_a.mdl",
    hidewep = false,
    offPos = Vector(-0.25, -0.75, 0),
    offAng = Angle(-12, -1.5, 0),
    lethal = true,
    range = true,
    melee = false,
    clip = 50,
    prettyPrint = "[L4D2] Silenced Submachine Gun",

    anims = {
        idle = ACT_HL2MP_IDLE_RPG,
        move = ACT_HL2MP_RUN_RPG,
        jump = ACT_HL2MP_JUMP_RPG,
        crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
    },

    changeCallback = function(callback, zeta, wep)
        zeta.AttackCooldown = CurTime() + 0.95
        wep:EmitSound("zetaplayer/weapon/l4d_weapons/smg/smg_deploy_1.wav", nil, nil, nil, CHAN_ITEM)
        timer.Simple(0.33, function()
            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "L4D_SMG_SILENCED" then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/smg/smg_slideback_1.wav", nil, nil, nil, CHAN_ITEM)
        end)
        timer.Simple(0.733, function()
            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "L4D_SMG_SILENCED" then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/smg/smg_slideforward_1.wav", nil, nil, nil, CHAN_ITEM)
        end)
    end,

    fireData = {
        rateMin = 0.0625,
        rateMax = 0.09,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/l4d_weapons/smg/smg_silence_fire_1.wav",

        dmgMin = 7,
        dmgMax = 9,
        force = 10,
        num = 1,
        ammo = "9mm Parabellum",
        spread = 0.1,
        tracer = "Tracer",
    },

    shellData = {
        name = "ShellEject",
        offPos = {
            forward = 2,
            right = 0,
            up = 2
        },
        offAng = Angle(0, -90, 0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        time = 2.233,
        snds = {
            {0.55, "zetaplayer/weapon/l4d_weapons/smg/smg_clip_out_1.wav"},
            {0.88, "zetaplayer/weapon/l4d_weapons/smg/smg_clip_in_1.wav"},
            {1.0, "zetaplayer/weapon/l4d_weapons/smg/smg_clip_locked_1.wav"},
            {1.61, "zetaplayer/weapon/l4d_weapons/smg/smg_slideback_1.wav"},
            {1.76, "zetaplayer/weapon/l4d_weapons/smg/smg_slideforward_1.wav"}
        }
    }
}, 

L4D_SHOTGUN_PUMP = {
    mdl = "models/zetal4d2_laststand_mdls/w_shotgun.mdl",
    hidewep = false,
    offPos = Vector(-1.5, -0.8, -1.3),
    offAng = Angle(-9, 0, 0),
    lethal = true,
    range = true,
    melee = false,
    clip = 8,
    prettyPrint = "[L4D2] Pump Shotgun",

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_SHOTGUN,
        jump = ACT_HL2MP_JUMP_SHOTGUN,
        crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN
    },

    changeCallback = function(callback, zeta, wep)
        zeta.AttackCooldown = CurTime() + 0.95
        wep:EmitSound("zetaplayer/weapon/l4d_weapons/shotgun/shotgun_deploy_1.wav", nil, nil, math.Rand(0.82, 0.85), CHAN_ITEM)
    end,

    fireData = {
        rateMin = 1,
        rateMax = 1.75,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/l4d_weapons/shotgun/shotgun_fire_1.wav",

        dmgMin = 7,
        dmgMax = 7,
        force = 2,
        num = 10,
        ammo = "Buckshot",
        spread = 0.22,
        tracer = "Tracer",

        preCallback = function(callback, zeta, wep, target, blockData)
            blockData.shell = true
            timer.Simple(0.475, function()
                if !zeta:IsValid() or !IsValid(wep) then return end
                wep:EmitSound("zetaplayer/weapon/l4d_weapons/shotgun/shotgun_pump_1.wav", nil, nil, math.Rand(0.62, 0.78), CHAN_ITEM)
                zeta:CreateShellEject()
            end)

            return blockData
        end
    },

    shellData = {
        name = "ShotgunShellEject",
        offPos = {
            forward = 8,
            right = 1,
            up = 3
        },
        offAng = Angle(0, -90, 0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        time = function(zeta, wep)
            local shellAmount = (8 - zeta.CurrentAmmo)
            local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)

            timer.Create("zeta_shotgunreload"..wep:EntIndex(), 0.5, shellAmount, function()
                if !IsValid(zeta) or !IsValid(wep) then return end
                if zeta.Weapon != "L4D_SHOTGUN_PUMP" then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RELOAD_AR2)
                    timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                    return 
                end

                local repsLeft = timer.RepsLeft("zeta_shotgunreload"..wep:EntIndex())
                if (-repsLeft + shellAmount - 1) >= 1 and math.random(2) == 1 and IsValid(zeta:GetEnemy()) and zeta:CanSee(zeta:GetEnemy()) then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RELOAD_AR2)
                    zeta.CurrentAmmo = (-repsLeft + shellAmount - 1)
                    zeta.IsReloading = false
                    timer.Remove("ZetaFinishReloading"..zeta:EntIndex())
                    timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                    return
                end

                zeta:SetLayerCycle(layerID, 0.2)
                zeta:SetLayerPlaybackRate(layerID, 1.6)

                wep:EmitSound("zetaplayer/weapon/l4d_weapons/shotgun/shotgun_load_shell_"..(math.random(2) == 1 and "2" or "4")..".wav", nil, math.random(90, 105), math.Rand(0.67, 0.80), CHAN_ITEM)
                if repsLeft == 0 then
                    timer.Simple(0.5, function()
                        if !IsValid(zeta) or !IsValid(wep) or !zeta:IsValidLayer(layerID) then return end
                        zeta:SetLayerCycle(layerID, 0.75)
                    end)
                end
            end)

            return (1.1 + 0.5 * shellAmount)
        end
    }
}, 

L4D_SHOTGUN_CHROME = {
    mdl = "models/zetal4d2_laststand_mdls/w_pumpshotgun_a.mdl",
    hidewep = false,
    offPos = Vector(-1.5, -0.75, -1.25),
    offAng = Angle(-12, 0, 0),
    lethal = true,
    range = true,
    melee = false,
    clip = 8,
    prettyPrint = "[L4D2] Chrome Shotgun",

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_SHOTGUN,
        jump = ACT_HL2MP_JUMP_SHOTGUN,
        crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN
    },

    changeCallback = function(callback, zeta, wep)
        zeta.AttackCooldown = CurTime() + 0.95
        wep:EmitSound("zetaplayer/weapon/l4d_weapons/shotgun/shotgun_deploy_1.wav", nil, nil, math.Rand(0.82, 0.85), CHAN_ITEM)
    end,

    fireData = {
        rateMin = 1,
        rateMax = 1.75,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/l4d_weapons/shotgun/shotgun_chrome_fire_1.wav",

        dmgMin = 7,
        dmgMax = 7,
        force = 2,
        num = 8,
        ammo = "Buckshot",
        spread = 0.175,
        tracer = "Tracer",

        preCallback = function(callback, zeta, wep, target, blockData)
            blockData.shell = true
            timer.Simple(0.475, function()
                if !zeta:IsValid() or !IsValid(wep) then return end
                wep:EmitSound("zetaplayer/weapon/l4d_weapons/shotgun/shotgun_pump_1.wav", nil, nil, math.Rand(0.62, 0.78), CHAN_ITEM)
                zeta:CreateShellEject()
            end)

            return blockData
        end
    },

    shellData = {
        name = "ShotgunShellEject",
        offPos = {
            forward = 10,
            right = 1,
            up = 3.66
        },
        offAng = Angle(0, -90, 0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        time = function(zeta, wep)
            local shellAmount = (8 - zeta.CurrentAmmo)
            local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
            
            timer.Create("zeta_shotgunreload"..wep:EntIndex(), 0.5, shellAmount, function()
                if !IsValid(zeta) or !IsValid(wep) then return end
                if zeta.Weapon != "L4D_SHOTGUN_CHROME" then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RELOAD_AR2)
                    timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                    return 
                end

                local repsLeft = timer.RepsLeft("zeta_shotgunreload"..wep:EntIndex())
                if (-repsLeft + shellAmount - 1) >= 1 and math.random(2) == 1 and IsValid(zeta:GetEnemy()) and zeta:CanSee(zeta:GetEnemy()) then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RELOAD_AR2)
                    zeta.CurrentAmmo = (-repsLeft + shellAmount - 1)
                    zeta.IsReloading = false
                    timer.Remove("ZetaFinishReloading"..zeta:EntIndex())
                    timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                    return
                end

                zeta:SetLayerCycle(layerID, 0.2)
                zeta:SetLayerPlaybackRate(layerID, 1.6)

                wep:EmitSound("zetaplayer/weapon/l4d_weapons/shotgun/shotgun_load_shell_"..(math.random(2) == 1 and "2" or "4")..".wav", nil, math.random(90, 105), math.Rand(0.67, 0.80), CHAN_ITEM)
                if repsLeft == 0 then
                    timer.Simple(0.5, function()
                        if !IsValid(zeta) or !IsValid(wep) or !zeta:IsValidLayer(layerID) then return end
                        zeta:SetLayerCycle(layerID, 0.75)
                    end)
                end
            end)

            return (1.1 + 0.5 * shellAmount)
        end
    }
},

L4D_SHOTGUN_AUTOSHOT = {
    mdl = "models/zetal4d2_laststand_mdls/w_autoshot_m4super.mdl",
    hidewep = false,
    offPos = Vector(-1.5, -1, -1.25),
    offAng = Angle(-12, 0, 0),
    lethal = true,
    range = true,
    melee = false,
    clip = 10,
    prettyPrint = "[L4D2] Tactical Shotgun",

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_SHOTGUN,
        jump = ACT_HL2MP_JUMP_SHOTGUN,
        crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN
    },

    changeCallback = function(callback, zeta, wep)
        zeta.AttackCooldown = CurTime() + 0.95
        wep:EmitSound("zetaplayer/weapon/l4d_weapons/shotgun/shotgun_deploy_1.wav", nil, nil, math.Rand(0.82, 0.85), CHAN_ITEM)
    end,

    fireData = {
        preCallback = function(callback, zeta, wep, target, blockData)
            blockData.anim = true
            if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW) then
                zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW)
            end
            local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW, true)
            zeta:SetLayerCycle(layerID, 0.075)
            timer.Simple(0.2, function()
                if !IsValid(zeta) or !zeta:IsValidLayer(layerID) then return end
                zeta:SetLayerBlendOut(layerID, 0.75)
            end)
            
            return blockData
        end,

        rateMin = 0.4,
        rateMax = 0.6,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/l4d_weapons/shotgun/autoshotgun_fire_1.wav",

        dmgMin = 7,
        dmgMax = 7,
        force = 2,
        num = 11,
        ammo = "Buckshot",
        spread = 0.233,
        tracer = "Tracer",
    },

    shellData = {
        name = "ShotgunShellEject",
        offPos = {
            forward = 9,
            right = 1,
            up = 3
        },
        offAng = Angle(0,-90,0)
    },
    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        time = function(zeta, wep)
            local shellAmount = (10 - zeta.CurrentAmmo)
            local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
            
            timer.Create("zeta_shotgunreload"..wep:EntIndex(), 0.36, shellAmount, function()
                if !IsValid(zeta) or !IsValid(wep) then return end
                if zeta.Weapon != "L4D_SHOTGUN_AUTOSHOT" then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RELOAD_AR2)
                    timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                    return 
                end

                local repsLeft = timer.RepsLeft("zeta_shotgunreload"..wep:EntIndex())
                if (-repsLeft + shellAmount - 1) >= 1 and math.random(2) == 1 and IsValid(zeta:GetEnemy()) and zeta:CanSee(zeta:GetEnemy()) then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RELOAD_AR2)
                    zeta.CurrentAmmo = (-repsLeft + shellAmount - 1)
                    zeta.IsReloading = false
                    timer.Remove("ZetaFinishReloading"..zeta:EntIndex())
                    timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                    return
                end

                wep:EmitSound("zetaplayer/weapon/l4d_weapons/shotgun/shotgun_load_shell_"..(math.random(2) == 1 and "2" or "4")..".wav", nil, math.random(90, 105), math.Rand(0.67, 0.80), CHAN_ITEM)
                if repsLeft == 0 then
                    zeta:SetLayerCycle(layerID, 0.4)
                    zeta:SetLayerPlaybackRate(layerID, 2.0)
                    timer.Simple(0.175, function()
                        if !IsValid(zeta) or !IsValid(wep) then return end
                        wep:EmitSound("zetaplayer/weapon/l4d_weapons/shotgun/autoshotgun_boltback.wav", nil, nil, nil, CHAN_ITEM)
                    end)
                    timer.Simple(0.325, function()
                        if !IsValid(zeta) or !IsValid(wep) then return end
                        wep:EmitSound("zetaplayer/weapon/l4d_weapons/shotgun/autoshotgun_boltforward.wav", nil, nil, nil, CHAN_ITEM)   
                    end)
                else
                    if repsLeft == (shellAmount - 1) then
                        timer.Adjust("zeta_shotgunreload"..wep:EntIndex(), 0.76, nil, nil)
                        return
                    elseif repsLeft == (shellAmount - 2) then
                        timer.Adjust("zeta_shotgunreload"..wep:EntIndex(), 0.4, nil, nil)
                    end
                    zeta:SetLayerCycle(layerID, 0.2)
                    zeta:SetLayerPlaybackRate(layerID, 1.6)
                end
            end)

            return (1.1 + 0.4 * shellAmount)
        end
    }
},

L4D_SHOTGUN_SPAS12 = {
    mdl = 'models/zetal4d2_laststand_mdls/w_shotgun_spas.mdl',
    hidewep = false,
    offPos = Vector(-1.5, -1, -0.8),
    offAng = Angle(-12, 0, 0),
    lethal = true,
    range = true,
    melee = false,
    clip = 10,
    prettyPrint = '[L4D2] Combat Shotgun',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    changeCallback = function(callback, zeta, wep)
        if !wep.CanPlayDeploySnd and GetConVar("zetaplayer_spawnweapon"):GetString() == 'L4D_SHOTGUN_SPAS12' then 
            wep.CanPlayDeploySnd = true
            return 
        end
        wep:EmitSound('zetaplayer/weapon/l4d_weapons/shotgun/shotgun_deploy_1.wav', nil, nil, math.Rand(0.82, 0.85), CHAN_ITEM)
        timer.Simple(0.33, function()
            if !IsValid(zeta) or !IsValid(wep) then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/shotgun/autoshotgun_spas_boltback.wav", nil, nil, nil, CHAN_ITEM)
        end)
        timer.Simple(0.66, function()
            if !IsValid(zeta) or !IsValid(wep) then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/shotgun/autoshotgun_spas_boltforward.wav", nil, nil, nil, CHAN_ITEM)
        end)
    end,

    fireData = {
        preCallback = function(callback, zeta, wep, target, blockData)
            blockData.anim = true
            if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW) then
                zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW)
            end
            local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW, true)
            zeta:SetLayerCycle(layerID, 0.075)
            timer.Simple(0.2, function()
                if !IsValid(zeta) or !zeta:IsValidLayer(layerID) then return end
                zeta:SetLayerBlendOut(layerID, 0.75)
            end)
            
            return blockData
        end,

        rateMin = 0.4,
        rateMax = 0.9,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/l4d_weapons/shotgun/autoshotgun_spas_fire_1.wav",

        dmgMin = 6,
        dmgMax = 6,
        force = 2,
        num = 9,
        ammo = "Buckshot",
        spread = 0.18,
        tracer = "Tracer",
    },

    shellData = {
        name = "ShotgunShellEject",
        offPos = {
            forward = 6,
            right = 1,
            up = 3
        },
        offAng = Angle(0, -90, 0)
    },

    onDamageCallback = function(callback, zeta, wep, dmginfo)
        if !zeta.IsReloading or zeta:GetState() != "chaseranged" or !IsValid(dmginfo:GetAttacker()) or !zeta:CanTarget(dmginfo:GetAttacker()) then return end
        zeta.InterruptReloading = true
    end,

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        time = function(zeta, wep)
            local shellAmount = (10 - zeta.CurrentAmmo)
            local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
            
            local count = 0
            timer.Create("zeta_shotgunreload"..wep:EntIndex(), 0.275, shellAmount, function()
                if !IsValid(zeta) or !IsValid(wep) then return end
                if zeta.Weapon != "L4D_SHOTGUN_SPAS12" then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RELOAD_AR2)
                    timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                    return 
                end

                local repsLeft = timer.RepsLeft("zeta_shotgunreload"..wep:EntIndex())
                if zeta.InterruptReloading and (-repsLeft + shellAmount) <= 7 then
                    zeta:SetLayerCycle(layerID, 0.75)
                    zeta.InterruptReloading = false
                    zeta.CurrentAmmo = (-repsLeft + shellAmount)
                    zeta.IsReloading = false
                    timer.Remove("ZetaFinishReloading"..zeta:EntIndex())
                    timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                    return
                end

                wep:EmitSound("zetaplayer/weapon/l4d_weapons/shotgun/shotgun_load_shell_"..(math.random(2) == 1 and "2" or "4")..".wav", nil, math.random(90, 105), math.Rand(0.67, 0.80), CHAN_ITEM)
                if repsLeft == 0 then
                    zeta:SetLayerCycle(layerID, 0.4)
                    zeta:SetLayerPlaybackRate(layerID, 2.0)
                    timer.Simple(0.175, function()
                        if !IsValid(zeta) or !IsValid(wep) then return end
                        wep:EmitSound("zetaplayer/weapon/l4d_weapons/shotgun/autoshotgun_spas_boltback.wav", nil, nil, nil, CHAN_ITEM)
                    end)
                    timer.Simple(0.325, function()
                        if !IsValid(zeta) or !IsValid(wep) then return end
                        wep:EmitSound("zetaplayer/weapon/l4d_weapons/shotgun/autoshotgun_spas_boltforward.wav", nil, nil, nil, CHAN_ITEM)   
                    end)
                else
                    if repsLeft == (shellAmount - 1) then
                        timer.Adjust("zeta_shotgunreload"..wep:EntIndex(), 0.775, nil, nil)
                        return
                    elseif repsLeft == (shellAmount - 2) then
                        timer.Adjust("zeta_shotgunreload"..wep:EntIndex(), 0.35, nil, nil)
                    end
                    zeta:SetLayerCycle(layerID, 0.2)
                    zeta:SetLayerPlaybackRate(layerID, 2.0)
                end
            end)

            return (1.2 + 0.35 * shellAmount)
        end
    }
}, 

L4D_RIFLE_M16 = {
    mdl = 'models/zetal4d2_laststand_mdls/w_rifle_m16a2.mdl',
    hidewep = false,
    offPos = Vector(-1.75, -1, -0.6),
    offAng = Angle(-12, 0, 0),
    lethal = true,
    range = true,
    melee = false,
    clip = 50,
    prettyPrint = '[L4D2] M-16 Assault Rifle',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    changeCallback = function(callback, zeta, wep)
        zeta.AttackCooldown = CurTime() + 0.95
        wep:EmitSound('zetaplayer/weapon/l4d_weapons/rifle/rifle_deploy_1.wav', nil, nil, nil, CHAN_ITEM)
        timer.Simple(0.35, function()
            if !IsValid(zeta) or !IsValid(wep) then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/rifle/rifle_slideback_1.wav", nil, nil, nil, CHAN_ITEM)
        end)
        timer.Simple(0.66, function()
            if !IsValid(zeta) or !IsValid(wep) then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/rifle/rifle_slideforward_1.wav", nil, nil, nil, CHAN_ITEM)
        end)
    end,

    fireData = {
        rateMin = 0.0875,
        rateMax = 0.25,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/l4d_weapons/rifle/rifle_fire_1.wav",

        dmgMin = 9,
        dmgMax = 9,
        force = 8,
        num = 1,
        ammo = '5.56',
        spread = 0.12,
        tracer = "Tracer",
    },

    shellData = {
        name = "RifleShellEject",
        offPos = {
            forward = 8,
            right = 0,
            up = 3
        },
        offAng = Angle(0, -90, 0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        time = 2.2,
        snds = {
            {0.533, 'zetaplayer/weapon/l4d_weapons/rifle/rifle_clip_out_1.wav'},
            {0.866, 'zetaplayer/weapon/l4d_weapons/rifle/rifle_clip_in_1.wav'},
            {1.1, 'zetaplayer/weapon/l4d_weapons/rifle/rifle_clip_locked_1.wav'},
            {1.66, 'zetaplayer/weapon/l4d_weapons/rifle/rifle_fullautobutton_1.wav'}
        }
    }
}, 

L4D_RIFLE_AK47 = {
    mdl = 'models/zetal4d2_laststand_mdls/w_rifle_ak47.mdl',
    hidewep = false,
    offPos = Vector(-1.75, -1, -0.3),
    offAng = Angle(-12, 0, 0),
    lethal = true,
    range = true,
    melee = false,
    clip = 40,
    prettyPrint = '[L4D2] AK47',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    changeCallback = function(callback, zeta, wep)
        zeta.AttackCooldown = CurTime() + 0.95
        wep:EmitSound('zetaplayer/weapon/l4d_weapons/rifle_ak47/rifle_deploy_1.wav', nil, nil, nil, CHAN_ITEM)
        timer.Simple(0.366, function()
            if !IsValid(zeta) or !IsValid(wep) then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/rifle_ak47/rifle_slideback.wav", nil, nil, nil, CHAN_ITEM)
        end)
        timer.Simple(0.7, function()
            if !IsValid(zeta) or !IsValid(wep) then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/rifle_ak47/rifle_slideforward.wav", nil, nil, nil, CHAN_ITEM)
        end)
    end,

    fireData = {
        rateMin = 0.13,
        rateMax = 0.39,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/l4d_weapons/rifle_ak47/rifle_fire_1.wav",

        dmgMin = 14,
        dmgMax = 14,
        force = 8,
        num = 1,
        ammo = '7.62',
        spread = 0.133,
        tracer = "Tracer",
    },

    shellData = {
        name = "RifleShellEject",
        offPos = {
            forward = 9,
            right = 0,
            up = 3
        },
        offAng = Angle(0, -90, 0)
    },

    reloadData = {
        time = function(zeta, wep)
            local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
            zeta:SetLayerPlaybackRate(layerID, 0.8)
            return 2.4
        end,
        snds = {
            {0.5, 'zetaplayer/weapon/l4d_weapons/rifle_ak47/rifle_clip_out_1.wav'},
            {1.0, 'zetaplayer/weapon/l4d_weapons/rifle_ak47/rifle_clip_in_1.wav'},
            {1.2, 'zetaplayer/weapon/l4d_weapons/rifle_ak47/rifle_clip_locked_1.wav'},
            {1.74, 'zetaplayer/weapon/l4d_weapons/rifle_ak47/rifle_slideback.wav'},
            {1.9, 'zetaplayer/weapon/l4d_weapons/rifle_ak47/rifle_slideforward.wav'},
        }
    }
}, 

L4D_RIFLE_SCARL = {
    mdl = 'models/zetal4d2_laststand_mdls/w_desert_rifle.mdl',
    hidewep = false,
    offPos = Vector(-2,-1,-0.75),
    offAng = Angle(-14.5,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 60,
    prettyPrint = '[L4D2] Desert Rifle',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    changeCallback = function(callback, zeta, wep)
        zeta.AttackCooldown = CurTime() + 0.95
        wep:EmitSound('zetaplayer/weapon/l4d_weapons/rifle/rifle_deploy_1.wav', nil, nil, nil, CHAN_ITEM)
        timer.Simple(0.4, function()
            if !IsValid(zeta) or !IsValid(wep) then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/rifle_desert/rifle_slideback_1.wav", nil, nil, nil, CHAN_ITEM)
        end)
        timer.Simple(0.733, function()
            if !IsValid(zeta) or !IsValid(wep) then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/rifle_desert/rifle_slideforward_1.wav", nil, nil, nil, CHAN_ITEM)
        end)
    end,

    fireData = {
        rateMin = 0.45,
        rateMax = 0.7,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/l4d_weapons/rifle_desert/rifle_fire_1.wav",

        dmgMin = 9,
        dmgMax = 11,
        force = 8,
        num = 1,
        ammo = '5.56',
        spread = 0.08,
        tracer = "Tracer",

        postCallback = function(callback, zeta, wep, target)
            local fireData = _ZetaWeaponDataTable['L4D_RIFLE_SCARL'].fireData
        
            FireBulletsTABLE.Attacker = zeta
            FireBulletsTABLE.Force = fireData.force+GetConVar("zetaplayer_forceadd"):GetInt()
            FireBulletsTABLE.HullSize = 5
            local spread = fireData.spread+zeta.Accuracy
            FireBulletsTABLE.Spread = Vector(spread,spread,0)
            FireBulletsTABLE.AmmoType = fireData.ammo
            FireBulletsTABLE.Num = fireData.num
            FireBulletsTABLE.TracerName = fireData.tracer
            FireBulletsTABLE.IgnoreEntity = zeta
        
            local fireFunc = function()
                if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != 'L4D_RIFLE_SCARL' then return end
                if zeta.CurrentAmmo <= 0 then zeta:Reload() return end
        
                local anim = fireData.anim
                if zeta:IsPlayingGesture(anim) then zeta:RemoveGesture(anim) end
                zeta:AddGesture(anim, true)
        
                zeta:CreateMuzzleFlash(fireData.muzzleFlash)
                zeta:CreateShellEject()
                wep:EmitSound(fireData.snd, 80)
        
                FireBulletsTABLE.Damage = math.random(fireData.dmgMin,fireData.dmgMax)/GetConVar("zetaplayer_damagedivider"):GetFloat()
                local firePos = (IsValid(target) and (target:GetPos()+target:OBBCenter()) or (wep:GetPos()+wep:GetForward()*1))
                FireBulletsTABLE.Dir = (firePos-wep:GetPos()):GetNormalized()
                FireBulletsTABLE.Src = wep:GetPos()
                wep:FireBullets(FireBulletsTABLE)
        
                zeta.CurrentAmmo = zeta.CurrentAmmo - 1
            end
            
            timer.Simple(0.07, function()
                fireFunc()
            end)
            timer.Simple(0.14, function()
                fireFunc()
            end)
        end,
    },

    shellData = {
        name = "RifleShellEject",
        offPos = {
            forward = 8,
            right = 0,
            up = 0
        },
        offAng = Angle(0, -90, 0)
    },

    reloadData = {
        time = function(zeta, wep)
            local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
            zeta:SetLayerPlaybackRate(layerID, 0.66)
            return 3.33
        end,
        snds = {
            {0.566, 'zetaplayer/weapon/l4d_weapons/rifle_desert/rifle_slideback_1.wav'},
            {1.233, 'zetaplayer/weapon/l4d_weapons/rifle_desert/rifle_clip_out_1.wav'},
            {1.566, 'zetaplayer/weapon/l4d_weapons/rifle_desert/rifle_clip_in_1.wav'},
            {1.8, 'zetaplayer/weapon/l4d_weapons/rifle_desert/rifle_clip_locked_1.wav'},
            {2.533, 'zetaplayer/weapon/l4d_weapons/rifle_desert/rifle_slideforward_1.wav'},
        }
    }
}, 

L4D_RIFLE_RUGER14 = {
    mdl = 'models/zetal4d2_laststand_mdls/w_sniper_mini14.mdl',
    hidewep = false,
    offPos = Vector(-3,-1,-1.9),
    offAng = Angle(-12,0,0),
    lethal = true,
    range = true,
    keepDistance = 550,
    melee = false,
    clip = 15,
    prettyPrint = '[L4D2] Hunting Rifle',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    changeCallback = function(callback, zeta, wep)
        zeta.AttackCooldown = CurTime() + 1.14
        wep:EmitSound('zetaplayer/weapon/l4d_weapons/rifle/rifle_deploy_1.wav',  nil, nil, nil, CHAN_ITEM)
        timer.Simple(0.56, function()
            if !IsValid(zeta) or !IsValid(wep) then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/hunting_rifle/hunting_rifle_boltback.wav", nil, nil, nil, CHAN_ITEM)
        end)
        timer.Simple(0.8, function()
            if !IsValid(zeta) or !IsValid(wep) then return end
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/hunting_rifle/hunting_rifle_boltforward.wav", nil, nil, nil, CHAN_ITEM)
        end)
    end,

    fireData = {
        rateMin = 0.35,
        rateMax = 0.9,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/l4d_weapons/hunting_rifle/hunting_rifle_fire_1.wav",

        dmgMin = 30,
        dmgMax = 30,
        force = 15,
        num = 1,
        ammo = '5.56',
        spread = 0.1,
        tracer = "Tracer",
    },

    shellData = {
        name = "RifleShellEject",
        offPos = {
            forward = 9,
            right = 0,
            up = 3
        },
        offAng = Angle(0, -90, 0)
    },

    reloadData = {
        time = function(zeta, wep)
            local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
            zeta:SetLayerPlaybackRate(layerID, 0.7)
            return 3.125
        end,
        snds = {
            {0.9375, 'zetaplayer/weapon/l4d_weapons/hunting_rifle/hunting_rifle_clipout.wav'},
            {1.9375, 'zetaplayer/weapon/l4d_weapons/hunting_rifle/hunting_rifle_clipin.wav'},
            {2.5, 'zetaplayer/weapon/l4d_weapons/hunting_rifle/hunting_rifle_cliplocked.wav'}
        }
    }
}, 

L4D_RIFLE_MILITARYS = {
    mdl = 'models/zetal4d2_laststand_mdls/w_sniper_military.mdl',
    hidewep = false,
    offPos = Vector(-1.75,-1,-2),
    offAng = Angle(-12,0,0),
    lethal = true,
    range = true,
    keepDistance = 550,
    melee = false,
    clip = 30,
    prettyPrint = '[L4D2] Military Rifle',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    changeCallback = function(callback, zeta, wep)
        zeta.AttackCooldown = CurTime() + 0.95
        wep:EmitSound('zetaplayer/weapon/l4d_weapons/sniper_military/sniper_military_deploy_1.wav', nil, nil, nil, CHAN_ITEM)
    end,

    fireData = {
        rateMin = 0.3,
        rateMax = 0.65,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/l4d_weapons/sniper_military/sniper_military_fire_1.wav",

        dmgMin = 30,
        dmgMax = 30,
        force = 15,
        num = 1,
        ammo = '7.62 NATO',
        spread = 0.15,
        tracer = "Tracer",
    },

    shellData = {
        name = "RifleShellEject",
        offPos = {
            forward = 10,
            right = 0,
            up = 4
        },
        offAng = Angle(0, -90, 0)
    },

    reloadData = {
        time = function(zeta, wep)
            local layerID = zeta:AddGestureSequence(zeta:LookupSequence("reload_smg1_alt"), true)
            zeta:SetLayerPlaybackRate(layerID, 0.66)
            return 3.33
        end,
        snds = {
            {0.33, 'zetaplayer/weapon/l4d_weapons/sniper_military/sniper_military_slideback_1.wav'},
            {1.233, 'zetaplayer/weapon/l4d_weapons/sniper_military/sniper_military_clip_out_1.wav'},
            {1.8, 'zetaplayer/weapon/l4d_weapons/sniper_military/sniper_military_clip_in_1.wav'},
            {1.833, 'zetaplayer/weapon/l4d_weapons/sniper_military/sniper_military_clip_locked_1.wav'},
            {2.533, 'zetaplayer/weapon/l4d_weapons/sniper_military/sniper_military_slideforward_1.wav'},
        }
    }
},

-- Sparks to simulate strings being broken upon hit/damaged
L4D_MELEE_GUITAR = {
    mdl = 'models/zetal4d2_laststand_mdls/w_electric_guitar.mdl',
    hidewep = false,
    offPos = Vector(0.25,0,0),   
    offAng = Angle(0,0,0),
    lethal = true,
    range = false,
    melee = true,
    clip = 1,
    prettyPrint = '[L4D2] Guitar',
    --moveSpeed = 230,

    anims = {
        idle = ACT_HL2MP_IDLE_MELEE2,
        move = ACT_HL2MP_RUN_MELEE2,
        jump = ACT_HL2MP_JUMP_MELEE2,
        crouch = ACT_HL2MP_WALK_CROUCH_MELEE2
    },

    changeCallback = function(callback, zeta, wep)
        if GetConVar('zetaplayer_spawnweapon'):GetString() == 'L4D_MELEE_GUITAR' and !wep.CanPlayDeploySnd then 
            wep.CanPlayDeploySnd = true
            return 
        end
        wep:EmitSound('zetaplayer/weapon/l4d_weapons/generic_melee_equip.wav', 70)
        
    end,

    fireData = {
        preCallback = function(callback, zeta, wep, target, blockData)
            if CurTime() <= zeta.AttackCooldown then return end
            zeta.AttackCooldown = CurTime() + math.Rand(1.0,1.15)

            if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2) then
                zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2)
            end
            zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2,true)

            zeta:FaceTick(target,100)

            target:EmitSound('zetaplayer/weapon/l4d_weapons/guitar/guitar_swing_miss'..math.random(2)..'.wav', 65)

            timer.Simple(0.25, function()
                if !IsValid(zeta) or zeta.IsDead or !IsValid(target) or zeta:GetRangeSquaredTo(target) > (75*75) then return end

                local dmg = DamageInfo()
                dmg:SetDamage(math.random(25,70)/GetConVar("zetaplayer_damagedivider"):GetInt())
                dmg:SetAttacker(zeta)
                dmg:SetInflictor(wep)
                dmg:SetDamageType(DMG_CLUB)
                target:TakeDamageInfo(dmg)

                target:EmitSound('zetaplayer/weapon/l4d_weapons/guitar/melee_guitar_'..math.random(12)..'.wav', 80)
            end)
        end
    },

    onDamageCallback = function(callback, zeta, wep, dmginfo)
        wep.NextMeleeBlockT = wep.NextMeleeBlockT or CurTime()
        wep.NextBulletBlockT = wep.NextBulletBlockT or CurTime()

        local attacker = dmginfo:GetAttacker()
        if (zeta:GetForward():Dot((attacker:GetPos() - zeta:GetPos()):GetNormalized()) <= math.cos(math.rad(80))) then return end

        local effectdata = EffectData()
        local sparkPos = dmginfo:GetDamagePosition()
        if zeta:GetRangeSquaredTo(sparkPos) > (150*150) then sparkPos = wep:GetPos() end
        local sparkForward = ((attacker:GetPos()+attacker:OBBCenter()) - sparkPos):Angle():Forward()
        effectdata:SetOrigin( sparkPos + sparkForward*10 )
        effectdata:SetNormal( sparkForward )
        util.Effect( "stunstickimpact", effectdata, true, true )
    end,
}, 
-- More minium damage, slower swing cooldown
L4D_MELEE_FIREAXE = {
    mdl = 'models/zetal4d2_laststand_mdls/w_fireaxe.mdl',
    hidewep = false,
    offPos = Vector(0.25,0,0),   
    offAng = Angle(0,0,0),
    lethal = true,
    range = false,
    melee = true,
    clip = 1,
    prettyPrint = '[L4D2] Fireaxe',
    --moveSpeed = 230,

    anims = {
        idle = ACT_HL2MP_IDLE_MELEE2,
        move = ACT_HL2MP_RUN_MELEE2,
        jump = ACT_HL2MP_JUMP_MELEE2,
        crouch = ACT_HL2MP_WALK_CROUCH_MELEE2
    },

    changeCallback = function(callback, zeta, wep)
        if GetConVar('zetaplayer_spawnweapon'):GetString() == 'L4D_MELEE_FIREAXE' and !wep.CanPlayDeploySnd then 
            wep.CanPlayDeploySnd = true
            return 
        end
        wep:EmitSound('zetaplayer/weapon/l4d_weapons/generic_melee_equip.wav', 70)
        
    end,

    fireData = {
        preCallback = function(callback, zeta, wep, target, blockData)
            -- Lets randomize the axe attacks sound set between impact_flesh, to melee_axe
            local rand_attack_soundset = math.random(1,2)

            if CurTime() <= zeta.AttackCooldown then return end
            zeta.AttackCooldown = CurTime() + math.Rand(1.0,1.375)

            if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2) then
                zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2)
            end
            zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2,true)

            zeta:FaceTick(target,100)

            target:EmitSound('zetaplayer/weapon/l4d_weapons/axe/axe_swing_miss'..math.random(2)..'.wav', 65)

            timer.Simple(0.25, function()
                if !IsValid(zeta) or zeta.IsDead or !IsValid(target) or zeta:GetRangeSquaredTo(target) > (75*75) then return end

                local dmg = DamageInfo()
                dmg:SetDamage(math.random(45,70)/GetConVar("zetaplayer_damagedivider"):GetInt())
                dmg:SetAttacker(zeta)
                dmg:SetInflictor(wep)
                dmg:SetDamageType(DMG_SLASH)
                target:TakeDamageInfo(dmg)

                if rand_attack_soundset == 1 then 
                    target:EmitSound('zetaplayer/weapon/l4d_weapons/axe/axe_impact_flesh'..math.random(4)..'.wav', 80)
                elseif rand_attack_soundset == 2 then
                    target:EmitSound('zetaplayer/weapon/l4d_weapons/axe/melee_axe_0'..math.random(3)..'.wav', 80)
                end

            end)
        end
    },
}, 
-- rediculous force that sends targets away
-- remember to yell "FORE!"
L4D_MELEE_GOLFCLUB = {
    mdl = 'models/zetal4d2_laststand_mdls/w_golfclub.mdl',
    hidewep = false,
    offPos = Vector(0.25,0,0),   
    offAng = Angle(0,0,0),
    lethal = true,
    range = false,
    melee = true,
    clip = 1,
    prettyPrint = '[L4D2] Golf Club',
    --moveSpeed = 230,

    anims = {
        idle = ACT_HL2MP_IDLE_MELEE2,
        move = ACT_HL2MP_RUN_MELEE2,
        jump = ACT_HL2MP_JUMP_MELEE2,
        crouch = ACT_HL2MP_WALK_CROUCH_MELEE2
    },

    changeCallback = function(callback, zeta, wep)
        if GetConVar('zetaplayer_spawnweapon'):GetString() == 'L4D_MELEE_GOLFCLUB' and !wep.CanPlayDeploySnd then 
            wep.CanPlayDeploySnd = true
            return 
        end
        wep:EmitSound('zetaplayer/weapon/l4d_weapons/generic_melee_equip.wav', 70)
        
    end,

    fireData = {
        preCallback = function(callback, zeta, wep, target, blockData)
            if CurTime() <= zeta.AttackCooldown then return end
            zeta.AttackCooldown = CurTime() + math.Rand(1.0,1.15)

            if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2) then
                zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2)
            end
            zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2,true)

            zeta:FaceTick(target,100)

            target:EmitSound('zetaplayer/weapon/l4d_weapons/golf_club/wpn_golf_club_swing_miss'..math.random(2)..'.wav', 65)

            timer.Simple(0.25, function()
                if !IsValid(zeta) or zeta.IsDead or !IsValid(target) or zeta:GetRangeSquaredTo(target) > (75*75) then return end

                local dmg = DamageInfo()
                dmg:SetDamage(math.random(25,70)/GetConVar("zetaplayer_damagedivider"):GetInt())
                dmg:SetAttacker(zeta)
                dmg:SetInflictor(wep)
                dmg:SetDamageType(DMG_CLUB)
                target:TakeDamageInfo(dmg)

                target:EmitSound('zetaplayer/weapon/l4d_weapons/golf_club/wpn_golf_club_melee_0'..math.random(2)..'.wav', 80)
                
                blockData.bullet = true

                -- Maybe I could make a better way to send zeta targets flying high in the sky?
                --local vector = Vector(0,0,800)
                --local pos = target:GetPos()+target:OBBCenter()+target:GetUp(vector)
                
                local pos = target:GetPos()+target:OBBCenter()

                FireBulletsTABLE.Attacker = zeta
                FireBulletsTABLE.Force = 65+GetConVar("zetaplayer_forceadd"):GetInt()
                FireBulletsTABLE.HullSize = 5
                FireBulletsTABLE.Dir = (pos-wep:GetPos()):GetNormalized()
                FireBulletsTABLE.Src = wep:GetPos()
                FireBulletsTABLE.IgnoreEntity = zeta

                wep:FireBullets(FireBulletsTABLE)
            end)
        end
    },
},

-- Less damage, faster melee swing
L4D_MELEE_TONFA = {
    mdl = 'models/zetal4d2_laststand_mdls/w_tonfa.mdl',
    hidewep = false,
    offPos = Vector(0.5,-0.25,0),
    offAng = Angle(10,0,0),
    lethal = true,
    range = false,
    melee = true,
    clip = 1,
    prettyPrint = '[L4D2] Nightstick',
    --moveSpeed = 230,

    anims = {
        idle = ACT_HL2MP_IDLE_MELEE_ANGRY,
        move = ACT_HL2MP_RUN_MELEE,
        jump = ACT_HL2MP_JUMP_MELEE,
        crouch = ACT_HL2MP_WALK_CROUCH_MELEE
    },

    changeCallback = function(callback, zeta, wep)
        if GetConVar('zetaplayer_spawnweapon'):GetString() == 'L4D_MELEE_TONFA' and !wep.CanPlayDeploySnd then 
            wep.CanPlayDeploySnd = true
            return 
        end
        wep:EmitSound('zetaplayer/weapon/l4d_weapons/generic_melee_equip.wav', 70)
        
    end,
    

    fireData = {
        preCallback = function(callback, zeta, wep, target, blockData)
            if CurTime() <= zeta.AttackCooldown then return end
            zeta.AttackCooldown = CurTime() + math.Rand(0.5,0.85)

            if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE) then
                zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)
            end
            zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE,true)

            zeta:FaceTick(target,100)

            target:EmitSound('zetaplayer/weapon/l4d_weapons/tonfa/tonfa_swing_miss'..math.random(2)..'.wav', 65)

            timer.Simple(0.25, function()
                if !IsValid(zeta) or zeta.IsDead or !IsValid(target) or zeta:GetRangeSquaredTo(target) > (75*75) then return end

                local dmg = DamageInfo()
                dmg:SetDamage(math.random(10,50)/GetConVar("zetaplayer_damagedivider"):GetInt())
                dmg:SetAttacker(zeta)
                dmg:SetInflictor(wep)
                dmg:SetDamageType(DMG_CLUB)
                target:TakeDamageInfo(dmg)
 
                target:EmitSound('zetaplayer/weapon/l4d_weapons/tonfa/melee_tonfa_0'..math.random(2)..'.wav', 80)

            end)
        end
    },
}, 

-- Impact variant, explodes if the grenade hits anything, Large blast radius.
L4D_SPECIAL_GL_IMPACT = {
    mdl = 'models/zetal4d2_laststand_mdls/w_grenade_launcher.mdl',
    hidewep = false,
    offPos = Vector(-0.6,-0.75,-0.5),
    offAng = Angle(-18,0,0),
    lethal = true,
    range = true,
    isExplosive = true,
    keepDistance = 550,
    melee = false,
    clip = 1,
    prettyPrint = '[L4D2] Grenade Launcher (Impact)',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    changeCallback = function(callback, zeta, wep)
        if GetConVar('zetaplayer_spawnweapon'):GetString() == 'L4D_SPECIAL_GL_IMPACT' and !wep.CanPlayDeploySnd then 
            wep.CanPlayDeploySnd = true
            return 
        end
        wep:EmitSound('zetaplayer/weapon/l4d_weapons/grenade_launcher/grenade_launcher_deploy_1.wav', 70)
    end,

    fireData = {
        rateMin = 1.5,
        rateMax = 3,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/l4d_weapons/grenade_launcher/grenade_launcher_fire_1.wav",

        dmgMin = 4,
        dmgMax = 12,
        force = 6,
        num = 1,
        ammo = '40mm HE Grenade',
        spread = 0.5,
        tracer = 'Tracer',
        preCallback  = function(callback, zeta, wep, target, blockData)
            blockData.shell = true
            blockData.bullet = true

            wep:EmitSound("zetaplayer/weapon/l4d_weapons/grenade_launcher/grenade_launcher_fire_1.wav",70)

            local grenade_launcher_bomb = ents.Create("prop_physics")
            if !IsValid(grenade_launcher_bomb) then return blockData end
            grenade_launcher_bomb:SetModel("models/zetatf2/weapons/w_flaregun_shell.mdl") -- Temp model until I can give the l4d2 grenade mdl physics.
            grenade_launcher_bomb:SetPos(wep:GetPos())
            grenade_launcher_bomb:SetAngles(wep:GetAngles())
            grenade_launcher_bomb:SetOwner(zeta)
            grenade_launcher_bomb:Spawn()
            grenade_launcher_bomb:SetColor(zeta.PlayermodelColor:ToColor())
            local id = grenade_launcher_bomb:GetCreationID()
            util.SpriteTrail( grenade_launcher_bomb, 0, zeta.PlayermodelColor:ToColor(), true, 150, 0, 1, 1 / ( 6 + 0 ) * 0.5, "trails/laser" )

            local phys = grenade_launcher_bomb:GetPhysicsObject()

            if IsValid(phys) then
                phys:SetMass(1)
                local norm = ((target:GetPos()+target:OBBCenter())-zeta.WeaponENT:GetPos()):GetNormalized()
                phys:ApplyForceCenter((norm*7500)+VectorRand(-600,600))
            end
            grenade_launcher_bomb:SetLocalAngularVelocity(Angle(math.random(-200,400),math.random(-10,10),math.random(-10,10)))

            if IsValid(grenade_launcher_bomb) then
                grenade_launcher_bomb:AddCallback("PhysicsCollide",function(ent,coldata)
                    if coldata.HitEntity then
                        util.BlastDamage( ent, IsValid(zeta) and zeta or grenade_launcher_bomb, ent:GetPos(), 420, 75/GetConVar("zetaplayer_damagedivider"):GetFloat() )

                        local effectdata = EffectData()
                        effectdata:SetOrigin( ent:GetPos() )
                        ent:EmitSound('zetaplayer/weapon/l4d_weapons/grenade_launcher/grenade_launcher_explode_'..math.random(2)..'.wav', 75)
                        util.Effect( "Explosion", effectdata, true, true )
                        util.ScreenShake(ent:GetPos(),25,35,2,750)
                        
                        ent:Remove()
                    end
                end)
            end
            
            return blockData
        end
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        time = 2,
        snds = {
            {0.3, 'zetaplayer/weapon/l4d_weapons/grenade_launcher/grenade_launcher_latchopen.wav'},
            {0.75, 'zetaplayer/weapon/l4d_weapons/grenade_launcher/grenade_launcher_shellout.wav'},
            {1.4, 'zetaplayer/weapon/l4d_weapons/grenade_launcher/grenade_launcher_shellin.wav'},
            {1.95, 'zetaplayer/weapon/l4d_weapons/grenade_launcher/grenade_launcher_actionclosed.wav'},
        }
    },
}, 

-- Delayed variant decreases it's initial impact damage and a smaller blast radius 
-- Can roll around and detonate on ground if the nade didn't hit an entity.
L4D_SPECIAL_GL_DELAYED = {
    mdl = 'models/zetal4d2_laststand_mdls/w_grenade_launcher.mdl',
    hidewep = false,
    offPos = Vector(-0.6,-0.75,-0.5),
    offAng = Angle(-18,0,0),
    lethal = true,
    range = true,
    melee = false,
    keepDistance = 550,
    clip = 1,
    prettyPrint = '[L4D2] Grenade Launcher (Non-Impact)',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    changeCallback = function(callback, zeta, wep)
        if GetConVar('zetaplayer_spawnweapon'):GetString() == 'L4D_SPECIAL_GL_DELAYED' and !wep.CanPlayDeploySnd then 
            wep.CanPlayDeploySnd = true
            return 
        end
        wep:EmitSound('zetaplayer/weapon/l4d_weapons/grenade_launcher/grenade_launcher_deploy_1.wav', 70)
    end,

    fireData = {
        rateMin = 1.5,
        rateMax = 3,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/l4d_weapons/grenade_launcher/grenade_launcher_fire_1.wav",

        dmgMin = 4,
        dmgMax = 12,
        force = 6,
        num = 1,
        ammo = '40mm HE Grenade',
        spread = 1.5,
        tracer = 'Tracer',
        preCallback  = function(callback, zeta, wep, target, blockData)
            blockData.shell = true
            blockData.bullet = true

            wep:EmitSound("zetaplayer/weapon/l4d_weapons/grenade_launcher/grenade_launcher_fire_1.wav",70)

            local grenade_launcher_bomb = ents.Create("prop_physics")
            if !IsValid(grenade_launcher_bomb) then return blockData end
            grenade_launcher_bomb:SetModel("models/zetatf2/weapons/w_flaregun_shell.mdl") -- Temp model until I can give the l4d2 grenade mdl physics.
            grenade_launcher_bomb:SetPos(wep:GetPos())
            grenade_launcher_bomb:SetAngles(wep:GetAngles())
            grenade_launcher_bomb:SetOwner(zeta)
            grenade_launcher_bomb:Spawn()
            grenade_launcher_bomb:SetColor(zeta.PlayermodelColor:ToColor())
            local id = grenade_launcher_bomb:GetCreationID()
            util.SpriteTrail( grenade_launcher_bomb, 0, zeta.PlayermodelColor:ToColor(), true, 150, 0, 1, 1 / ( 6 + 0 ) * 0.5, "trails/laser" )

            local phys = grenade_launcher_bomb:GetPhysicsObject()

            if IsValid(phys) then
                phys:SetMass(1)
                local norm = ((target:GetPos()+target:OBBCenter())-zeta.WeaponENT:GetPos()):GetNormalized()
                phys:ApplyForceCenter((norm*7500)+VectorRand(-600,600))
            end
            grenade_launcher_bomb:SetLocalAngularVelocity(Angle(math.random(-200,400),math.random(-10,10),math.random(-10,10)))

            if IsValid(grenade_launcher_bomb) then
                grenade_launcher_bomb:AddCallback("PhysicsCollide",function(ent,coldata)
                    if coldata.HitEntity != NULL and IsValid(coldata.HitEntity) then
                        util.BlastDamage( ent, IsValid(zeta) and zeta or grenade_launcher_bomb, ent:GetPos(), 325, 65/GetConVar("zetaplayer_damagedivider"):GetFloat() )

                        local effectdata = EffectData()
                        effectdata:SetOrigin( ent:GetPos() )
                        ent:EmitSound('zetaplayer/weapon/l4d_weapons/grenade_launcher/grenade_launcher_explode_'..math.random(2)..'.wav', 75)
                        util.Effect( "Explosion", effectdata, true, true )
                        util.ScreenShake(ent:GetPos(),25,35,2,750)
                        
                        ent:Remove()
                    end
                end)
            end

            timer.Create("zetagrenadetimer"..id,5,1,function()
                if !IsValid(grenade_launcher_bomb) then return end
                util.BlastDamage( grenade_launcher_bomb, IsValid(zeta) and zeta or grenade_launcher_bomb, grenade_launcher_bomb:GetPos(), 300, 65/GetConVar("zetaplayer_damagedivider"):GetFloat() )

                local effectdata = EffectData()
                effectdata:SetOrigin( grenade_launcher_bomb:GetPos() )
                grenade_launcher_bomb:EmitSound('zetaplayer/weapon/l4d_weapons/grenade_launcher/grenade_launcher_explode_'..math.random(2)..'.wav', 75)
                util.Effect( "Explosion", effectdata, true, true )
                util.ScreenShake(grenade_launcher_bomb:GetPos(),25,35,2,750)

                grenade_launcher_bomb:Remove()
            end)
            
            return blockData
        end
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        time = 2,
        snds = {
            {0.3, 'zetaplayer/weapon/l4d_weapons/grenade_launcher/grenade_launcher_latchopen.wav'},
            {0.75, 'zetaplayer/weapon/l4d_weapons/grenade_launcher/grenade_launcher_shellout.wav'},
            {1.4, 'zetaplayer/weapon/l4d_weapons/grenade_launcher/grenade_launcher_shellin.wav'},
            {1.95, 'zetaplayer/weapon/l4d_weapons/grenade_launcher/grenade_launcher_actionclosed.wav'},
        }
    },
}, 
-- muzzleflash broken, model needs to be decompiled to fix muzzlebone, disabled for now
L4D_SPECIAL_M60 = {
    mdl = 'models/zetal4d2_laststand_mdls/w_m60.mdl',
    hidewep = false,
    offPos = Vector(0,-1,0.5),
    offAng = Angle(-12,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 150,
    prettyPrint = '[L4D2] M60',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    changeCallback = function(callback, zeta, wep)
        if GetConVar('zetaplayer_spawnweapon'):GetString() == 'L4D_SPECIAL_M60' and !wep.CanPlayDeploySnd then 
            wep.CanPlayDeploySnd = true
            return 
        end
        wep:EmitSound('zetaplayer/weapon/l4d_weapons/rifle/rifle_deploy_1.wav', 70)
    end,

    fireData = {
        rateMin = 0.11,
        rateMax = 0.35,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        muzzleFlash = 0,
        snd = "zetaplayer/weapon/l4d_weapons/machinegun_m60/machinegun_fire_1.wav",

        dmgMin = 8,
        dmgMax = 32,
        force = 10,
        num = 1,
        ammo = '7.62 NATO',
        spread = 0.28,
        tracer = 'Tracer',
    },

    shellData = {
        name = 'RifleShellEject',
        offPos = {
            forward = 0,
            right = 0,
            up = 3
        },
        offAng = Angle(0,-90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        time = 2,
        snds = {
            {0.1, 'zetaplayer/weapon/l4d_weapons/rifle_ak47/rifle_clip_out_1.wav'},
            {0.8, 'zetaplayer/weapon/l4d_weapons/rifle_ak47/rifle_clip_in_1.wav'},
            {0.9, 'zetaplayer/weapon/l4d_weapons/rifle_ak47/rifle_clip_locked_1.wav'},
            {1.3, 'zetaplayer/weapon/l4d_weapons/rifle_ak47/rifle_slideback.wav'},
            {1.5, 'zetaplayer/weapon/l4d_weapons/rifle_ak47/rifle_slideforward.wav'},
        }
    }
}, 

L4D_PISTOL_M1911 = {
    mdl = "models/zetal4d2_laststand_mdls/w_pistol_1911.mdl",
    hidewep = false,
    offPos = Vector(-1.75,0,0),   
    offAng = Angle(-6,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 15,
    prettyPrint = "[L4D1] M1911 Pistol",

    anims = {
        idle = ACT_HL2MP_IDLE_PISTOL,
        move = ACT_HL2MP_RUN_PISTOL,
        jump = ACT_HL2MP_JUMP_PISTOL,
        crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
    },

    changeCallback = function(callback, zeta, wep)
        zeta.AttackCooldown = CurTime() + 0.95
        wep:EmitSound("zetaplayer/weapon/l4d_weapons/pistol_1911/pistol_deploy_1.wav", nil, nil, nil, CHAN_ITEM)
    end,

    fireData = {
        rateMin = 0.2,
        rateMax = 0.45,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/l4d_weapons/pistol_1911/pistol_fire.wav",

        dmgMin = 11,
        dmgMax = 13,
        force = 12,
        num = 1,
        ammo = "45. ACP",
        spread = 0.125,
        tracer = "Tracer",
    },

    shellData = {
        name = "ShellEject",
        offPos = {
            forward = 0,
            right = 0,
            up = 3
        },
        offAng = Angle(0, -90, 0)
    },

    reloadData = {
        time = function(zeta, wep)
            local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_PISTOL, true)
            zeta:SetLayerPlaybackRate(layerID, 0.75)

            local snds = {
                {0.233, "zetaplayer/weapon/l4d_weapons/pistol_1911/pistol_clip_out_1.wav"},
                {1.1, "zetaplayer/weapon/l4d_weapons/pistol_1911/pistol_clip_in_1.wav"},
                {1.5, "zetaplayer/weapon/l4d_weapons/pistol_1911/pistol_clip_locked_1.wav"}
            }
            local finTime = 2.0
            if zeta.CurrentAmmo == 0 then
                finTime = 2.5
                snds[#snds+1] = {2.2, "zetaplayer/weapon/l4d_weapons/pistol_1911/pistol_slideforward_1.wav"}
            end

            for i = 1, #snds do
                timer.Simple(snds[i][1], function() 
                    if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "L4D_PISTOL_M1911" then return end
                    wep:EmitSound(snds[i][2], nil, nil, nil, CHAN_ITEM)
                end)
            end

            return finTime
        end
    }
},

ALYXGUN = {
    mdl = 'models/weapons/w_alyx_gun.mdl',
    
    hidewep = false,
    offPos = Vector(3,0,3.5),   
    offAng = Angle(0,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 30,
    prettyPrint = 'Alyx Gun',

    anims = {
        idle = ACT_HL2MP_IDLE_PISTOL,
        move = ACT_HL2MP_RUN_PISTOL,
        jump = ACT_HL2MP_JUMP_PISTOL,
        crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
    },

    fireData = {
        rateMin = 0.1,
        rateMax = 0.22,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
        muzzleFlash = 1,
        snd = "^weapons/alyx_gun/alyx_gun_fire4.wav",

        dmgMin = 4,
        dmgMax = 7,
        force = 6,
        num = 1,
        ammo = '9mm',
        spread = 0.15,
        tracer = 'Tracer'
    },

    shellData = {
        name = 'ShellEject',
        offPos = {
            forward = 0,
            right = 0,
            up = 3
        },
        offAng = Angle(0,90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
        time = 1.5,
        snds = {
            {0, 'weapons/pistol/pistol_reload1.wav'},
        }
    }
},

ANNABELLE = {
    mdl = 'models/weapons/w_annabelle.mdl',
    
    hidewep = false,
    offPos = Vector(0,0,0),   
    offAng = Angle(0,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 2,
    prettyPrint = 'Annabelle',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    fireData = {
        rateMin = 0.55,
        rateMax = 1.1,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
        muzzleFlash = 1,
        snd = "weapons/shotgun/shotgun_fire6.wav",
        num = 1,
        dmgMin = 12,
        dmgMax = 32,
        force = 4,
        ammo = '!2 Gauge Slug',
        spread = 0.1,
        tracer = 'Tracer'
    },

    shellData = {
        name = 'ShotgunShellEject',
        offPos = {
            forward = 0,
            right = 0,
            up = 1
        },
        offAng = Angle(0,90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
        time = 2.3,
    }
},

WOODENCHAIR = {
    mdl = 'models/props_c17/FurnitureChair001a.mdl',
    
    nobonemerge = true,
    hidewep = false,
    offPos = Vector(9,-9,0),   
    offAng = Angle(180,180,0),
    lethal = true,
    range = false,
    melee = true,
    clip = 1,
    prettyPrint = 'Wooden Chair',

    anims = {
        idle = ACT_HL2MP_IDLE_MELEE2,
        move = ACT_HL2MP_RUN_MELEE2,
        jump = ACT_HL2MP_JUMP_MELEE2,
        crouch = ACT_HL2MP_WALK_CROUCH_MELEE2
    },

    fireData = {
        range = 70,
        preCallback = function(callback, zeta, wep, target, blockData)
            if CurTime() <= zeta.AttackCooldown then return end
            zeta.AttackCooldown = CurTime() + 1

            if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE) then
                zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)
            end
            zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE, true)
            zeta:FaceTick(target, 100)
            wep:EmitSound('weapons/iceaxe/iceaxe_swing1.wav',80)
            
            local dmg = DamageInfo()
            dmg:SetDamage(25/GetConVar("zetaplayer_damagedivider"):GetInt())
            dmg:SetAttacker(zeta)
            dmg:SetInflictor(wep)
            dmg:SetDamageType(DMG_CLUB)
            target:TakeDamageInfo(dmg)
            
            target:EmitSound("physics/flesh/flesh_impact_hard"..math.random(1,3)..".wav",80)
            target:EmitSound("physics/wood/wood_plank_break"..math.random(1,4)..".wav",80)
        end
    },
},

THEKLEINER = {
    mdl = 'models/Kleiner.mdl',
    
    nobonemerge = true,
    hidewep = false,
    offPos = Vector(0,0,-20),   
    offAng = Angle(0,0,0),
    lethal = true,
    range = false,
    melee = true,
    clip = 1,
    prettyPrint = 'Kleiner',

    anims = {
        idle = ACT_HL2MP_IDLE_MELEE2,
        move = ACT_HL2MP_RUN_MELEE2,
        jump = ACT_HL2MP_JUMP_MELEE2,
        crouch = ACT_HL2MP_WALK_CROUCH_MELEE2
    },
    
    changeCallback = function(callback, zeta, wep)

        wep:EmitSound(theklienersnds[math.random(#theklienersnds)], 70)
        local index = wep:EntIndex()
        timer.Create("thekleinersounds"..index,4,0,function()
            if !IsValid(wep) then timer.Remove("thekleinersounds"..index) return end
            if zeta.Weapon != "THEKLEINER" then timer.Remove("thekleinersounds"..index) return end

            if math.random(100) > 20 then
                wep:EmitSound(theklienersnds[math.random(#theklienersnds)], 70)
            end

        end)
    end,

    dropCallback = function(zeta,wepent,droppedweapon)
        if IsValid(droppedweapon) then
            droppedweapon:EmitSound("vo/k_lab2/kl_greatscott.wav")
        end
    end,

    fireData = {
        range = 70,
        preCallback = function(callback, zeta, wep, target, blockData)
            if CurTime() <= zeta.AttackCooldown then return end
            zeta.AttackCooldown = CurTime() + 0.7

            if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE) then
                zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)
            end
            zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE, true)
            zeta:FaceTick(target, 100)

            local swingsounds = {
                "vo/k_lab/kl_getoutrun02.wav",
                "vo/k_lab/kl_getoutrun01.wav",
                "vo/k_lab/kl_ahhhh.wav",
                "vo/k_lab/kl_getoutrun03.wav",
                "vo/k_lab/kl_hedyno01.wav",
                "vo/k_lab/kl_hedyno02.wav",
                "vo/k_lab/kl_hedyno03.wav",
                "vo/k_lab/kl_heremypet02.wav",
                "vo/k_lab/kl_heremypet02.wav",
                "vo/k_lab/kl_nocareful.wav"
            }
            wep:EmitSound(swingsounds[math.random(#swingsounds)],80)
            
            local dmg = DamageInfo()
            dmg:SetDamage(8/GetConVar("zetaplayer_damagedivider"):GetInt())
            dmg:SetAttacker(zeta)
            dmg:SetInflictor(wep)
            dmg:SetDamageType(DMG_CLUB)
            target:TakeDamageInfo(dmg)
            
            target:EmitSound("physics/flesh/flesh_impact_hard"..math.random(1,5)..".wav",80)
        end
    },
},
LARGESIGN = {
    mdl = 'models/props_trainstation/TrackSign03.mdl',
    
    nobonemerge = true,
    hidewep = false,
    offPos = Vector(0,0,30),   
    offAng = Angle(0,0,0),
    lethal = true,
    range = false,
    melee = true,
    clip = 1,
    prettyPrint = 'Large Sign Post',

    anims = {
        idle = ACT_HL2MP_IDLE_MELEE2,
        move = ACT_HL2MP_RUN_MELEE2,
        jump = ACT_HL2MP_JUMP_MELEE2,
        crouch = ACT_HL2MP_WALK_CROUCH_MELEE2
    },

    fireData = {
        range = 100,
        force = 40,
        preCallback = function(callback, zeta, wep, target, blockData)
            if CurTime() <= zeta.AttackCooldown then return end
            zeta.AttackCooldown = CurTime() + math.Rand(1.0,1.5)

            if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2) then
                zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2)
            end
            zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2, true)
            zeta:FaceTick(target, 100)
            wep:EmitSound('weapons/iceaxe/iceaxe_swing1.wav',80)
            
            local dmg = DamageInfo()
            dmg:SetDamage(35/GetConVar("zetaplayer_damagedivider"):GetInt())
            dmg:SetAttacker(zeta)
            dmg:SetInflictor(wep)
            dmg:SetDamageType(DMG_CLUB)
            target:TakeDamageInfo(dmg)
            
            target:EmitSound("physics/flesh/flesh_impact_hard"..math.random(1,3)..".wav",80)
            target:EmitSound("physics/metal/metal_sheet_impact_hard"..math.random(6,8)..".wav",80)
            
        end
    },
},

CARDOOR = {
    mdl = 'models/props_vehicles/carparts_door01a.mdl',
    
    nobonemerge = true,
    hidewep = false,
    offPos = Vector(0,4,0),   
    offAng = Angle(0,110,0),
    lethal = true,
    range = false,
    melee = true,
    clip = 1,
    prettyPrint = 'Car Door',

    anims = {
        idle = ACT_HL2MP_IDLE_DUEL,
        move = ACT_HL2MP_RUN_DUEL,
        jump = ACT_HL2MP_JUMP_DUEL,
        crouch = ACT_HL2MP_IDLE_CROUCH_DUEL
    },

    fireData = {
        range = 70,
        preCallback = function(callback, zeta, wep, target, blockData)
            if CurTime() <= zeta.AttackCooldown then return end
            zeta.AttackCooldown = CurTime() + 1

            if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM) then
                zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM)
            end
            zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM, true)
            zeta:FaceTick(target, 100)

            local dmg = DamageInfo()
            dmg:SetDamage(math.random(30,40) / GetConVar("zetaplayer_damagedivider"):GetInt())
            dmg:SetAttacker(zeta)
            dmg:SetInflictor(wep)
            dmg:SetDamageType(DMG_CLUB)
            target:TakeDamageInfo(dmg)

            if target:IsPlayer() then target:ViewPunch(Angle(-40, math.random(-70, 70), 0)) end
            if target:IsOnGround() then
                local pushVel = (target:GetPos() - zeta:GetPos()):GetNormalized()*500
                if target.IsZetaPlayer then
                    target.loco:SetVelocity(target.loco:GetVelocity() + pushVel)
                else
                    target:SetVelocity(target:GetVelocity() + pushVel)
                end
            end
            
            wep:EmitSound("physics/flesh/flesh_impact_hard"..math.random(3)..".wav", 75)
            wep:EmitSound("physics/metal/metal_sheet_impact_hard6.wav", 80)
        end
    },

    changeCallback = function(callback, zeta, wep)
        wep.DamageSound_Bullet = {
            "physics/metal/metal_box_impact_bullet1.wav",
            "physics/metal/metal_box_impact_bullet2.wav",
            "physics/metal/metal_box_impact_bullet3.wav",
            "physics/metal/metal_sheet_impact_bullet1.wav",
            "physics/metal/metal_sheet_impact_bullet2.wav",
            "physics/metal/metal_solid_impact_bullet1.wav",
            "physics/metal/metal_solid_impact_bullet2.wav",
            "physics/metal/metal_solid_impact_bullet3.wav",
            "physics/metal/metal_solid_impact_bullet4.wav"
        }
        wep.DamageSound_Melee = {
            "physics/metal/metal_sheet_impact_hard6.wav",
            "physics/metal/metal_sheet_impact_hard7.wav",
            "physics/metal/metal_sheet_impact_hard8.wav",
            "physics/metal/metal_sheet_impact_soft2.wav"
        }
    end,

    onDamageCallback = function(callback, zeta, wep, dmginfo)
        local attacker = dmginfo:GetAttacker()
        local dmgPos = ((dmginfo:IsExplosionDamage() or !IsValid(attacker)) and dmginfo:GetDamagePosition() or attacker:GetCenteroid())

        local dot = zeta:GetForward():Dot((dmgPos - zeta:GetPos()):GetNormalized())
        if (dot <= 0.65) then return end

        local dmgType = (dmginfo:IsBulletDamage() and 1 or (dmginfo:IsExplosionDamage() or dmginfo:GetDamageType() == DMG_GENERIC or dmginfo:GetDamageType() == DMG_CLUB or dmginfo:GetDamageType() == DMG_SLASH) and 2 or 0)
        if dmgType == 0 then return end 

        if dmgType == 1  then
            local effectdata = EffectData()
            local sparkPos = dmginfo:GetDamagePosition()
            if zeta:GetRangeSquaredTo(sparkPos) > (100*100) then sparkPos = wep:GetPos() end
            local sparkForward = (attacker:GetCenteroid() - sparkPos):Angle():Forward()
            effectdata:SetOrigin(sparkPos + sparkForward*10)
            effectdata:SetNormal(sparkForward)
            util.Effect("stunstickimpact", effectdata, true, true)
        end

        dmginfo:ScaleDamage(math.Rand(0.15, 0.25))
        wep:EmitSound(dmgType == 1 and wep.DamageSound_Bullet[math.random(9)] or wep.DamageSound_Melee[math.random(4)], 70, math.random(95,110))
    end
},


ZOMBIECLAWS = {
    mdl = 'models/hunter/plates/plate.mdl',
    
    hidewep = true,
    offPos = Vector(0,0,0),   
    offAng = Angle(0,0,0),
    lethal = true,
    range = false,
    melee = true,
    clip = 0,
    prettyPrint = 'Zombie Claws',
    moveSpeed = 100, -- Move speed has been changed as of update 5.2.4 to add to movement speed. By default run speed, this is still 500
    keepDistance = 30,

    anims = {
        idle = ACT_HL2MP_IDLE_ZOMBIE,
        move = ACT_HL2MP_RUN_ZOMBIE,
        jump = ACT_ZOMBIE_LEAPING,
        crouch = ACT_HL2MP_WALK_CROUCH_ZOMBIE
    },

    changeCallback = function(callback, zeta, wep)
        wep.NextLeapAttackTime = CurTime() + 0.5
        wep.NextHPRegenTime = CurTime() + 0.5
    end,

    onThink = function(callback, zeta, wep)
        local maxHP = zeta:GetMaxHealth() * 1.25
        if wep.NextHPRegenTime and CurTime() > wep.NextHPRegenTime and zeta:Health() < maxHP then
            zeta:SetHealth(math.min(zeta:Health() + 1, maxHP))
            wep.NextHPRegenTime = CurTime() + 0.5
        end

        if wep.NextLeapAttackTime and CurTime() > wep.NextLeapAttackTime then
            local ene = zeta:GetEnemy()
            if zeta:GetState() == 'chasemelee' and IsValid(ene) then
                local dist = zeta:GetRangeSquaredTo(ene)
                if dist > (300*300) and dist <= (600*600) and zeta.loco:IsOnGround() and zeta:CanSee(ene) then
                    zeta.IsJumping = true
                    zeta:SetLastActivity(zeta:GetActivity())
                    zeta.loco:Jump()

                    local jumpDir = (ene:GetPos() - zeta:GetPos()):GetNormalized()
                    zeta.loco:SetVelocity(Vector(0, 0, 384) + jumpDir * math.min(math.sqrt(dist) * 0.4, 512))

                    zeta:EmitSound('npc/fast_zombie/fz_scream1.wav', 80, zeta.VoicePitch)
                    wep.NextLeapAttackTime = CurTime() + 5
                end
            end
        end
    end,

    onKillCallback = function(callback, zeta, wep, victim, dmginfo)
        if dmginfo:GetInflictor() != wep then return end
        local maxHP = zeta:GetMaxHealth()
        if zeta:Health() < maxHP * 2.25 then
            zeta:SetHealth(math.min(zeta:Health() + maxHP * math.Rand(0.33, 0.45), maxHP * 2.25))
        end
    end,

    onDamageCallback = function(callback, zeta, wep, dmginfo)
        dmginfo:ScaleDamage(0.75)
    end,

    fireData = {
        range = 64,
        preCallback = function(callback, zeta, wep, target, blockData)
            if CurTime() <= zeta.AttackCooldown then return end
            zeta.AttackCooldown = CurTime() + 1.25

            if zeta:IsPlayingGesture(ACT_GMOD_GESTURE_RANGE_ZOMBIE) then
                zeta:RemoveGesture(ACT_GMOD_GESTURE_RANGE_ZOMBIE)
            end
            zeta:AddGesture(ACT_GMOD_GESTURE_RANGE_ZOMBIE, true)
            zeta:FaceTick(target, 100)

            wep:EmitSound('npc/zombie/zo_attack'..math.random(2)..'.wav', 75, zeta.VoicePitch)
            timer.Simple(0.75, function()
                if !IsValid(zeta) or zeta.IsDead or !IsValid(wep) then return end

                local dmginfo = DamageInfo()
                dmginfo:SetDamageType(DMG_SLASH)
                dmginfo:SetAttacker(zeta)
                dmginfo:SetInflictor(wep)

                local hitOnce = false
                for _, v in ipairs(ents.FindInCone(zeta:GetCenteroid(), zeta:GetForward(), 64, math.cos(math.rad(100)))) do
                    if v != zeta and IsValid(v) and zeta:Visible(v) and v.Health and v:Health() > 0 then
                        dmginfo:SetDamage(math.random(35, 55) / GetConVar("zetaplayer_damagedivider"):GetInt())
                        v:TakeDamageInfo(dmginfo)
                        hitOnce = true
                    end
                end

                if hitOnce then 
                    local maxHP = zeta:GetMaxHealth()
                    if zeta:Health() < maxHP * 2.25 then
                        zeta:SetHealth(math.min(zeta:Health() + maxHP * math.Rand(0.10, 0.25), maxHP * 2.25))
                    end
                end
                wep:EmitSound((hitOnce and 'npc/zombie/claw_strike'..math.random(3)..'.wav' or 'npc/zombie/claw_miss'..math.random(2)..'.wav'))
            end)
        end
    }
}, 


M3 = {
    mdl = "models/weapons/w_shot_m3super90.mdl",
    hidewep = false,
    offPos = Vector(10,-0.5,-2.5),
    offAng = Angle(-5,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 8,
    prettyPrint = "M3",

    anims = {
        idle = ACT_HL2MP_IDLE_SHOTGUN,
        move = ACT_HL2MP_RUN_SHOTGUN,
        jump = ACT_HL2MP_JUMP_SHOTGUN,
        crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN
    },

    changeCallback = function(callback, zeta, wep)
        timer.Simple(0.4, function()
            if !IsValid(wep) then return end
            wep:EmitSound("zetaplayer/weapon/m3/m3_pump.wav", nil, nil, nil, CHAN_ITEM)
        end)
    end,

    fireData = {
        preCallback = function(callback, zeta, wep, target, blockData)
            blockData.shell = true
            timer.Simple(0.55, function()
                if !IsValid(zeta) or !IsValid(wep) then return end
                zeta:CreateShellEject()
            end)
            return blockData
        end,

        rateMin = 0.9,
        rateMax = 1.1,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/m3/m3-1.wav",
        num = 9,
        dmgMin = 8,
        dmgMax = 9,
        force = 2,
        ammo = "Buckshot",
        spread = 0.2,
        tracer = "Tracer"
    },

    shellData = {
        name = "ShotgunShellEject",
        offPos = {
            forward = -3,
            right = 1,
            up = 6
        },
        offAng = Angle(0,-90,0)
    },

    onDamageCallback = function(callback, zeta, wep, dmginfo)
        if !zeta.IsReloading or zeta:GetState() != "chaseranged" or !IsValid(dmginfo:GetAttacker()) or !zeta:CanTarget(dmginfo:GetAttacker()) then return end
        zeta.InterruptReloading = true
    end,

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        time = function(zeta, wep)
            local shellAmount = (8 - zeta.CurrentAmmo)
            local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
            timer.Create("zeta_shotgunreload"..wep:EntIndex(), 0.5, shellAmount, function()
                if !IsValid(zeta) or !IsValid(wep) then return end
                if zeta.Weapon != "M3" then
                    zeta:RemoveGesture(ACT_HL2MP_GESTURE_RELOAD_AR2)
                    timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                    return 
                end

                local repsLeft = timer.RepsLeft("zeta_shotgunreload"..wep:EntIndex())
                if zeta.InterruptReloading and (-repsLeft + shellAmount) <= 6 then
                    zeta:SetLayerCycle(layerID, 0.75)
                    zeta.InterruptReloading = false
                    zeta.CurrentAmmo = (-repsLeft + shellAmount)
                    zeta.IsReloading = false
                    timer.Remove("ZetaFinishReloading"..zeta:EntIndex())
                    timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                    return
                end

                zeta:SetLayerCycle(layerID, 0.2)
                zeta:SetLayerPlaybackRate(layerID, 1.6)

                wep:EmitSound("zetaplayer/weapon/m3/m3_insertshell.wav", nil, nil, nil, CHAN_ITEM)
                if repsLeft == 0 then
                    timer.Simple(0.36, function()
                        if !IsValid(zeta) or !IsValid(wep) then return end
                        wep:EmitSound("zetaplayer/weapon/m3/m3_pump.wav", nil, nil, nil, CHAN_ITEM)
                    end)
                end
            end)
            
            return (1.0 + 0.5 * shellAmount)
        end
    }
},

GALIL = {
    mdl = 'models/weapons/w_rif_galil.mdl',
    
    hidewep = false,
    offPos = Vector(11,-1,-2),   
    offAng = Angle(-10,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 35,
    prettyPrint = 'Galil',

    anims = {
        idle = ACT_HL2MP_IDLE_AR2,
        move = ACT_HL2MP_RUN_AR2,
        jump = ACT_HL2MP_JUMP_AR2,
        crouch = ACT_HL2MP_WALK_CROUCH_AR2
    },

    fireData = {
        rateMin = 0.12,
        rateMax = 0.12,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/galil/galil-1.wav",

        dmgMin = 7,
        dmgMax = 11,
        force = 16,
        ammo = 'Pulse ammo',
        spread = 0.155,
        tracer = 'Tracer'
    },

    shellData = {
        name = 'RifleShellEject',
        offPos = {
            forward = 10,
            right = 0,
            up = 3
        },
        offAng = Angle(0,-90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_AR2,
        time = 1.5,
        snds = {
            {0, 'zetaplayer/weapon/galil/galil_clipout.wav'},
            {0.7, 'zetaplayer/weapon/galil/galil_clipin.wav'},
            {1.4, 'zetaplayer/weapon/galil/galil_boltpull.wav'},
        }
    }
},

TMP = {
    mdl = 'models/weapons/w_smg_tmp.mdl',
    hidewep = false,
    nobonemerge = false,
    offPos = Vector(3,0,-3),   
    offAng = Angle(0,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 30,
    prettyPrint = 'TMP',

    anims = {
        idle = ACT_HL2MP_IDLE_PISTOL,
        move = ACT_HL2MP_RUN_PISTOL,
        jump = ACT_HL2MP_JUMP_PISTOL,
        crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
    },

    fireData = {
        rateMin = 0.07,
        rateMax = 0.07,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/tmp/tmp-1.wav",

        dmgMin = 4,
        dmgMax = 8,
        force = 5,
        num = 1,
        ammo = '9mm',
        spread = 0.19,
        tracer = 'Tracer',
    },

    shellData = {
        name = 'ShellEject',
        offPos = {
            forward = 0,
            right = 0,
            up = 3
        },
        offAng = Angle(0,90,0)
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
        time = 2,
        snds = {
            {0, 'zetaplayer/weapon/tmp/tmp_clipout.wav'},
            {1.0, 'zetaplayer/weapon/tmp/tmp_clipin.wav'}
        }
    }
},

DUALELITES = {
    mdl = 'models/weapons/w_pist_elite.mdl',
    hidewep = false,
    offPos = Vector(0,0,0),   
    offAng = Angle(0,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 30,
    prettyPrint = 'Dual Berettas',

    anims = {
        idle = ACT_HL2MP_IDLE_DUEL,
        move = ACT_HL2MP_RUN_DUEL,
        jump = ACT_HL2MP_JUMP_DUEL,
        crouch = ACT_HL2MP_WALK_CROUCH_DUEL
    },

    changeCallback = function(callback, zeta, wep)
        wep:EmitSound("zetaplayer/weapon/elite/elite_deploy.wav", 70, math.random(98, 102), 1, CHAN_WEAPON)
    end,

    fireData = {
        preCallback = function(callback, zeta, wep, target, blockData)
            wep.Elites_WhichGunWillFire = (!wep.Elites_WhichGunWillFire and 1 or (wep.Elites_WhichGunWillFire == 1 and 2 or 1))
            local subString = (wep.Elites_WhichGunWillFire == 2 and "2" or "")

            blockData.shell = true
            local shellAttach = wep:GetAttachment(wep:LookupAttachment("shell"..subString))
            if shellAttach then
                local shellEject = EffectData()
                shellEject:SetOrigin(shellAttach.Pos)
                shellEject:SetAngles(shellAttach.Ang)
                shellEject:SetEntity(wep)
                util.Effect("ShellEject", shellEject)
            end

            blockData.muzzle = true
            local muzzleAttach = wep:GetAttachment(wep:LookupAttachment("muzzle"..subString))
            if muzzleAttach then
                local muzzleFlash = EffectData()
                muzzleFlash:SetOrigin(muzzleAttach.Pos)
                muzzleFlash:SetAngles(muzzleAttach.Ang)
                muzzleFlash:SetScale(0.5)
                util.Effect("MuzzleEffect", muzzleFlash)
            end

            return blockData
        end,

        rateMin = 0.15,
        rateMax = 0.4,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_DUEL,
        muzzleFlash = 1,
        snd = "zetaplayer/weapon/elite/elite-1.wav",

        dmgMin = 9,
        dmgMax = 15,
        force = 10,
        num = 1,
        ammo = '9mm',
        spread = 0.26,
        tracer = 'Tracer'
    },

    reloadData = {
        anim = ACT_HL2MP_GESTURE_RELOAD_DUEL,
        time = 3.0,
        snds = {
            {0, 'zetaplayer/weapon/elite/elite_reloadstart.wav'},
            {1, 'zetaplayer/weapon/elite/elite_rightclipin.wav'},
            {1.5, 'zetaplayer/weapon/elite/elite_sliderelease.wav'},
            {2.0, 'zetaplayer/weapon/elite/elite_leftclipin.wav'},
            {2.5, 'zetaplayer/weapon/elite/elite_sliderelease.wav'}
        }
    }
},

FLASHGRENADE = {
    mdl = 'models/weapons/w_eq_flashbang.mdl',

    hidewep = false,
    offPos = Vector(0,0,0),   
    offAng = Angle(0,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 1,
    prettyPrint = 'Flashbang Grenade',

    anims = {
        idle = ACT_HL2MP_IDLE_GRENADE,
        move = ACT_HL2MP_RUN_GRENADE,
        jump = ACT_HL2MP_JUMP_GRENADE,
        crouch = ACT_HL2MP_WALK_CROUCH_GRENADE
    },

    fireData = {
        rateMin = 3.0,
        rateMax = 3.0,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
        muzzleFlash = 1,
        preCallback = function(callback, zeta, wep, target, blockData)
            local blockData = {cooldown = false, anim = false, muzzle = true, shell = true, snd = true, bullet = true, clipRemove = true}
            zeta:ThrowFlashbang(target, false)
            timer.Simple(1.0, function()
                if !IsValid(zeta) or zeta.CSSNades_ChangeWeapon or !GetConVar("zetaplayer_cssnades_changeweapons"):GetBool() then return end
                zeta:ChooseLethalWeapon()
                zeta:SetState((zeta.HasMelee and 'chasemelee' or 'chaseranged'))
                zeta.AttackCooldown = CurTime()
            end)
            return blockData
        end
    }
}, 

SMOKEGRENADE = {
    mdl = 'models/weapons/w_eq_smokegrenade.mdl',

    hidewep = false,
    offPos = Vector(0,0,0),   
    offAng = Angle(0,0,0),
    lethal = true,
    range = true,
    melee = false,
    clip = 1,
    prettyPrint = 'Smoke Grenade',

    anims = {
        idle = ACT_HL2MP_IDLE_GRENADE,
        move = ACT_HL2MP_RUN_GRENADE,
        jump = ACT_HL2MP_JUMP_GRENADE,
        crouch = ACT_HL2MP_WALK_CROUCH_GRENADE
    },

    fireData = {
        rateMin = 5.0,
        rateMax = 5.0,
        anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE,
        muzzleFlash = 1,
        preCallback = function(callback, zeta, wep, target, blockData)
            local blockData = {cooldown = false, anim = false, muzzle = true, shell = true, snd = true, bullet = true, clipRemove = true}
            zeta:ThrowSmokeGrenade(target, false)
            timer.Simple(1.0, function()
                if !IsValid(zeta) or zeta.CSSNades_ChangeWeapon or !GetConVar("zetaplayer_cssnades_changeweapons"):GetBool() then return end
                zeta:ChooseLethalWeapon()
                zeta:SetState((zeta.HasMelee and 'chasemelee' or 'chaseranged'))
                zeta.AttackCooldown = CurTime()
            end)
            return blockData
        end
    }
},

L4D_SPECIAL_CHAINSAW = {
    mdl = "models/zetal4d2_laststand_mdls/w_chainsaw.mdl",
    offPos = Vector(7, 3, 0),   
    offAng = Angle(0, 180, 7.5),
    lethal = true,
    melee = true,
    clip = 1,
    prettyPrint = "[L4D2] Chainsaw",

    anims = {
        idle = ACT_HL2MP_IDLE_PHYSGUN,
        move = ACT_HL2MP_RUN_PHYSGUN,
        jump = ACT_HL2MP_JUMP_PHYSGUN,
        crouch = ACT_HL2MP_WALK_CROUCH_PHYSGUN
    },

    changeCallback = function(callback, zeta, wep)
        zeta.AttackCooldown = CurTime() + 2.5
        wep:EmitSound("zetaplayer/weapon/l4d_weapons/chainsaw/chainsaw_start_0"..math.random(2)..".wav")
        local layerID = zeta:AddGestureSequence(zeta:LookupSequence("reload_revolver_base_layer"), true)
        zeta:SetLayerCycle(layerID, 0.25)
        zeta:SetLayerBlendOut(layerID, 0.25)

        wep.IsDeploying = true
        wep.AttackSoundPlayTime = CurTime() + 2.5
        wep.IdleSound = CreateSound(wep, "zetaplayer/weapon/l4d_weapons/chainsaw/chainsaw_idle_lp_01.wav")
        wep.AttackSound = CreateSound(wep, "zetaplayer/weapon/l4d_weapons/chainsaw/chainsaw_high_speed_lp_01.wav")

        local function KillSounds()
            wep:EmitSound("zetaplayer/weapon/l4d_weapons/chainsaw/chainsaw_die_01.wav", 70)
            wep:StopSound("zetaplayer/weapon/l4d_weapons/chainsaw/chainsaw_start_01.wav")
            wep:StopSound("zetaplayer/weapon/l4d_weapons/chainsaw/chainsaw_start_02.wav")
            if wep.IdleSound then wep.IdleSound:Stop(); wep.IdleSound = nil end
            if wep.AttackSound then wep.AttackSound:Stop(); wep.AttackSound = nil end 
        end

        zeta:CreateThinkFunction("Chainsaw_HolsterSoundHack", 0, 0, function()
            if zeta.Weapon == "L4D_SPECIAL_CHAINSAW" then return end
            KillSounds()
            return "stop"
        end)

        if !zeta.Chainsaw_CallOnRemove then
            zeta.Chainsaw_CallOnRemove = true
            zeta:CallOnRemove("zeta_chainsaw_killsounds"..zeta:EntIndex(), function() KillSounds() end)
        end
    end,

    onThink = function(callback, zeta, wep)
        if (CLIENT) then return end

        if !wep.IsDeploying and !zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2) then
            local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2, true)
            zeta:SetLayerPlaybackRate(layerID, 2.0)
            zeta:SetLayerBlendOut(layerID, 2.0)
        end

        if !wep.AttackSoundPlayTime then return end
        if CurTime() > wep.AttackSoundPlayTime then
            if wep.IsDeploying then wep.IsDeploying = false end
            if wep.IdleSound and !wep.IdleSound:IsPlaying() then wep.IdleSound:PlayEx(0.75, 100) end
            if wep.AttackSound and wep.AttackSound:IsPlaying() then wep.AttackSound:Stop() end
        elseif !wep.IsDeploying then
            if wep.IdleSound and wep.IdleSound:IsPlaying() then wep.IdleSound:Stop() end
            if wep.AttackSound and !wep.AttackSound:IsPlaying() then wep.AttackSound:Play() end
        
            local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM, true)
            zeta:SetLayerCycle(layerID, 0.2)
            zeta:SetLayerBlendOut(layerID, 1.25)

            local ene = zeta:GetEnemy()
            local ang = (IsValid(ene) and (ene:GetCenteroid() - wep:GetPos()):Angle() or zeta:GetAngles())

            local tr = util.TraceLine({
                start = wep:GetPos(),
                endpos = wep:GetPos() + ang:Forward() * 50,
                filter = {zeta, wep},
                mask = MASK_SHOT_HULL
            })
            if !IsValid(tr.Entity) then
                tr = util.TraceHull({
                    start = wep:GetPos(),
                    endpos = wep:GetPos() + ang:Forward() * 46,
                    filter = {zeta, wep},
                    mins = Vector(-4, -4, -2),
                    maxs = Vector(4, 4, 2),
                    mask = MASK_SHOT_HULL
                })
            end

            if tr.Hit then
                local hitEnt = tr.Entity
                if IsValid(hitEnt) then
                    local dmg = DamageInfo()
                    dmg:SetDamage(1.5 / GetConVar("zetaplayer_damagedivider"):GetFloat())
                    dmg:SetAttacker(zeta)
                    dmg:SetInflictor(wep)
                    dmg:SetDamageType(DMG_SLASH)
                    dmg:SetDamagePosition(tr.HitPos)
                    dmg:SetDamageForce(ang:Forward()*2000 - ang:Up()*2000)
                    hitEnt:DispatchTraceAttack(dmg, tr, tr.HitNormal)
                end
            end
        end
    end,

    fireData = {
        range = 64,
        preCallback = function(callback, zeta, wep, target, blockData) wep.AttackSoundPlayTime = CurTime() + 0.33 end
    },

},

TF2_MINIGUN = {
    mdl = "models/zetatf2/weapons/w_minigun.mdl",
    offPos = Vector(8, -6, -2),   
    offAng = Angle(0, 0, 0),
    lethal = true,
    range = true,
    clip = 200,
    prettyPrint = "[TF2] Minigun",
    moveSpeed = -75,

    anims = {
        idle = ACT_HL2MP_IDLE_PHYSGUN,
        move = ACT_HL2MP_RUN_PHYSGUN,
        jump = ACT_HL2MP_JUMP_PHYSGUN,
        crouch = ACT_HL2MP_WALK_CROUCH_PHYSGUN
    },

    changeCallback = function(callback, zeta, wep)
        zeta.AttackCooldown = CurTime() + 1.0
        
        wep.WeaponSpinTime = CurTime()
        wep.WeaponFireTime = CurTime()

        wep.AnimState = 1
        wep.NextAnimStateTime = CurTime()
        wep.SpinSound = CreateSound(wep, "zetaplayer/weapon/tf2/minigun_spin.wav")
        if wep.SpinSound then wep.SpinSound:ChangeVolume(0.9) end
        wep.ShootSound = CreateSound(wep, "zetaplayer/weapon/tf2/minigun_shoot.wav")
        if wep.ShootSound then wep.ShootSound:SetSoundLevel(80) end

        local function KillSounds()
            if wep.SpinSound then wep.SpinSound:Stop(); wep.SpinSound = nil end
            if wep.ShootSound then wep.ShootSound:Stop(); wep.ShootSound = nil end 
        end

        zeta:CreateThinkFunction("Minigun_HolsterSoundHack", 0, 0, function()
            if zeta.Weapon == "TF2_MINIGUN" then return end
            if wep.AnimState == 2 then
                wep.AnimState = 1
                wep:EmitSound("zetaplayer/weapon/tf2/minigun_wind_down.wav", nil, nil, 0.9)
            end
            KillSounds()
            return "stop"
        end)

        if !zeta.Minigun_CallOnRemove then
            zeta.Minigun_CallOnRemove = true
            zeta:CallOnRemove("zeta_minigun_killsounds"..zeta:EntIndex(), function() KillSounds() end)
        end
    end,

    onThink = function(callback, zeta, wep)
        if (CLIENT) then return end

        if CurTime() < wep.WeaponSpinTime then 
            if CurTime() > wep.NextAnimStateTime then
                if wep.AnimState == 1 then
                    wep.NextAnimStateTime = CurTime() + SoundDuration("zetaplayer/weapon/tf2/minigun_wind_up.wav")
                    wep:EmitSound("zetaplayer/weapon/tf2/minigun_wind_up.wav", nil, nil, 0.9)
                    wep.AnimState = 2
                elseif wep.AnimState == 2 then
                    if wep.SpinSound and !wep.SpinSound:IsPlaying() then wep.SpinSound:Play() end
                    if wep.ShootSound then
                        if CurTime() < wep.WeaponFireTime then 
                            if !wep.ShootSound:IsPlaying() then wep.ShootSound:Play()end
                        else
                            if wep.ShootSound:IsPlaying() then wep.ShootSound:Stop() end
                        end
                    end
                end
            end
        elseif wep.AnimState == 2 then
            if wep.SpinSound and wep.SpinSound:IsPlaying() then wep.SpinSound:Stop() end
            if wep.SpinSound and wep.ShootSound:IsPlaying() then wep.ShootSound:Stop() end
            wep:EmitSound("zetaplayer/weapon/tf2/minigun_wind_down.wav", nil, nil, 0.9)
            wep.NextAnimStateTime = CurTime() + 1.5
            wep.AnimState = 1
        end
    end,

    fireData = {
        preCallback = function(callback, zeta, wep, target, blockData)
            wep.WeaponSpinTime = CurTime() + math.Rand(2.0, 6.0)
            wep.WeaponFireTime = CurTime() + 0.25
            if wep.AnimState != 2 or CurTime() <= wep.NextAnimStateTime then 
                blockData = nil 
                return blockData 
            end

            if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2) then zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2) end
            local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2, true)
            zeta:SetLayerPlaybackRate(layerID, 1.5)

            local muzzle = EffectData()
            muzzle:SetEntity(wep)
            muzzle:SetScale(2.25)
            muzzle:SetAttachment(wep:LookupAttachment("muzzle"))
            util.Effect("CS_MuzzleFlash_X", muzzle, true, true)

            for i = 1, 3 do
                timer.Simple(0.02625 * i, function()
                    if !IsValid(zeta) or zeta.IsDead or !IsValid(wep) or zeta.Weapon != "TF2_MINIGUN" then return end
                    
                    if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2) then zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2) end
                    layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2, true)
                    zeta:SetLayerPlaybackRate(layerID, 1.5)

                    zeta:CreateShellEject()
                    util.Effect("CS_MuzzleFlash_X", muzzle, true, true)
                end)
            end

            blockData.anim = true
            blockData.muzzle = true
            blockData.snd = true
            blockData.clipRemove = true
            return blockData
        end,

        rateMin = 0.105,
        rateMax = 0.105,

        dmgMin = 4,
        dmgMax = 6,
        force = 5,
        num = 4,
        ammo = "ar2",
        spread = 0.266,
        tracer = "Tracer",
    },

    shellData = {
        name = "RifleShellEject",
        offPos = {
            forward = -17,
            right = -5,
            up = -8
        },
        offAng = Angle(0, -90, 0)
    }
}, 

   
} -- Data Table end

    local addoncustomweapons = file.Find( "materials/zetaplayer/custom_weapons/*.vmt", "GAME" )

    local weapondataDAT = file.Read( "zetaplayerdata/weapondata.dat" )

    if weapondataDAT then
        
        weapondataDAT = util.Decompress( weapondataDAT )

        if weapondataDAT then 

            weapondataDAT = util.JSONToTable( weapondataDAT )

            for k, v in pairs( weapondataDAT ) do
                _ZetaWeaponDataTable[ k ] = v

                RegisterZetaWeapon( "CUSTOM", k, v.prettyPrint, 1 )
            end

        end

    end

    for k, vmt in ipairs( addoncustomweapons ) do
        
        local weapondatafile = file.Read( "materials/zetaplayer/custom_weapons/" .. vmt, "GAME" )

        if weapondatafile then
            
            weapondatafile = util.Decompress( weapondatafile )

            if weapondatafile then 

                weapondatafile = util.JSONToTable( weapondatafile )
    
                for k, v in pairs( weapondatafile ) do
                    if _ZetaWeaponDataTable[ k ] then continue end

                    _ZetaWeaponDataTable[ k ] = v
    
                    RegisterZetaWeapon( "ADDON", k, v.prettyPrint, 1 )
                end
    
            end

        end

    end


local lightSaber = weapons.Get("weapon_lightsaber")
    if istable(lightSaber) and lightSaber.IsLightsaber then
        local saberWpnData = {
            LIGHTSABER = {
                mdl = "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl",

                offPos = Vector(0, 0, 0),   
                offAng = Angle(90, 0, -90),
                lethal = true,
                range = false,
                melee = true,
                clip = 1,
                prettyPrint = 'Lightsaber',

                anims = {
                    idle = ACT_HL2MP_IDLE_MELEE2,
                    move = ACT_HL2MP_RUN_MELEE2,
                    jump = ACT_HL2MP_JUMP_MELEE2,
                    crouch = ACT_HL2MP_WALK_CROUCH_MELEE2
                },

                onDamageCallback = function(callback, zeta, wep, dmginfo)
                    wep.LS_DamageTaken = wep.LS_DamageTaken + dmginfo:GetDamage()
                    wep.LS_NextDamageTakenTime = CurTime()

                    if wep.LS_Force_Type == 2 and wep.LS_Force_Amount > 0 then
                        local damage = dmginfo:GetDamage() / 5
                        if wep.LS_Force_Amount < damage then
                            wep:LS_SetForce(0)
                            dmginfo:SetDamage((damage - wep.LS_Force_Amount) * 5)
                        else
                            wep:LS_SetForce(wep.LS_Force_Amount - damage)
                            dmginfo:SetDamage(0)
                        end
                    end
                end,

                changeCallback = function(callback, zeta, wep)
                    wep.LS_Force_Amount = 100
                    wep.LS_Force_Type = 1
                    wep.LS_Force_WaitingForFullPower = false
                    wep.LS_Force_NextUseTime = CurTime()

                    wep.LS_DamageTaken = 0
                    wep.LS_NextDamageTakenTime = CurTime()

                    if !wep.LS_WorldModel then
                        local _, k = table.Random( list.Get( "LightsaberModels" ) )
                        wep.LS_WorldModel = (k or "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl")
                    end

                    wep:SetModel(wep.LS_WorldModel) 
                    local staffAnim = {
                        idle = ACT_HL2MP_IDLE_KNIFE,
                        move = ACT_HL2MP_RUN_KNIFE,
                        jump = ACT_HL2MP_JUMP_KNIFE,
                        crouch = ACT_HL2MP_WALK_CROUCH_KNIFE
                    }
                    local bladeAnim = {
                        idle = ACT_HL2MP_IDLE_MELEE2,
                        move = ACT_HL2MP_RUN_MELEE2,
                        jump = ACT_HL2MP_JUMP_MELEE2,
                        crouch = ACT_HL2MP_WALK_CROUCH_MELEE2
                    }
                    if wep.LS_WorldModel == "models/weapons/starwars/w_maul_saber_staff_hilt.mdl" or wep:LookupAttachment("blade2") > 0 then 
                        wep.RangeAttackAnimation = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
                        _ZetaWeaponDataTable["LIGHTSABER"].anims = staffAnim
                    else
                        wep.RangeAttackAnimation = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
                        _ZetaWeaponDataTable["LIGHTSABER"].anims = bladeAnim
                    end
                    zeta:StartActivity(zeta:GetActivityWeapon((zeta.IsMoving and "move" or "idle")))

                    wep.LS_LengthAnimation = 0
                    
                    wep.LS_SwitchSound = wep.LS_SwitchSound or "lightsaber/saber_on"..math.random(4)..".wav"
                    wep.LS_HolsterSound = wep.LS_HolsterSound or "lightsaber/saber_off"..math.random(4)..".wav"
                    wep.LS_LoopSound = wep.LS_LoopSound or "lightsaber/saber_loop"..math.random(8)..".wav"
                    wep.LS_SwingSound =  wep.LS_SwingSound or "lightsaber/saber_swing"..math.random(2)..".wav"

                    wep.LS_SoundLoop = CreateSound(zeta, wep.LS_LoopSound)
                    if wep.LS_SoundLoop then 
                        wep.LS_SoundLoop:Play() 
                        wep.LS_SoundLoop:ChangeVolume(0, 0) 
                    end

                    wep.LS_SoundSwing = CreateSound(zeta, wep.LS_SwingSound)
                    if wep.LS_SoundSwing then 
                        wep.LS_SoundSwing:Play() 
                        wep.LS_SoundSwing:ChangeVolume(0, 0) 
                    end

                    wep.LS_SoundHit = CreateSound(zeta, "lightsaber/saber_hit.wav")
                    if wep.LS_SoundHit then 
                        wep.LS_SoundHit:Play() 
                        wep.LS_SoundHit:ChangeVolume(0, 0) 
                    end

                    zeta:CallOnRemove("zeta_ls_stopsounds"..wep:EntIndex(), function()
                        if wep.LS_SoundSwing then wep.LS_SoundSwing:Stop() wep.LS_SoundSwing = nil end
                        if wep.LS_SoundLoop then wep.LS_SoundLoop:Stop() wep.LS_SoundLoop = nil end 
                        if wep.LS_SoundHit then wep.LS_SoundHit:Stop() wep.LS_SoundHit = nil end
                    end)

                    wep.LS_SetForce = wep.LS_SetForce or function(callback, value)
                        if wep.LS_Force_Amount > value then wep.LS_Force_RegenTime = CurTime() + 4 end
                        wep.LS_Force_Amount = math.Clamp(value, 0, 100)
                    end

                    wep.LS_SetNextAttack = wep.LS_SetNextAttack or function(callback, time)
                        if CurTime() > zeta.AttackCooldown then zeta.AttackCooldown = CurTime() + time end
                        wep.LS_Force_NextUseTime = CurTime() + time
                    end

                    wep.LS_DrawHitEffects = wep.LS_DrawHitEffects or function(callback, trace, traceBack)
                        if wep:LS_GetBladeLength() <= 0 then return end

                        if trace.Hit and !trace.StartSolid then
                            rb655_DrawHit(trace)
                        end

                        if traceBack and traceBack.Hit and !traceBack.StartSolid then
                            rb655_DrawHit(traceBack, true)
                        end
                    end

                    wep:EmitSound(wep.LS_SwitchSound, nil, nil, 0.4)

                    zeta:CreateThinkFunction("LS_HolsterSoundHack", 0, 0, function()
                        if zeta.Weapon == "LIGHTSABER" then return end
                        wep:EmitSound(wep.LS_HolsterSound, nil, nil, 0.4)
                        return "stop"
                    end)
                end,

                onThink = function(callback, zeta, wep)
                    if !wep.LS_MaxLength then 
                        wep.LS_MaxLength = math.random(32, 64) 
                        _ZetaWeaponDataTable["LIGHTSABER"].fireData.range = wep.LS_MaxLength + 6
                    end
                    if !wep.LS_MaxWidth then wep.LS_MaxWidth = math.random(2, 4) end
                    if wep.LS_DarkInner == nil then wep.LS_DarkInner = (math.random(8) == 1) end
                    if !wep.LS_LengthAnimation then wep.LS_LengthAnimation = 0 end
                    if !wep.LS_CrystalColor then wep.LS_CrystalColor = zeta:GetNW2Vector('zeta_physcolor', Vector(1, 1, 1)):ToColor() end

                    if !wep.LS_GetBladeLength then
                        wep.LS_GetBladeLength = function()
                            return (wep.LS_LengthAnimation * wep.LS_MaxLength)
                        end
                    end
                    if !wep.LS_GetSaberPosAng then
                        wep.LS_GetSaberPosAng = function(callback, zeta, num, side)
                            num = num or 1

                            if IsValid(zeta) then
                                local bone = zeta:LookupBone("ValveBiped.Bip01_R_Hand")
                                local attachment = wep:LookupAttachment((side and "quillon" or "blade")..num)

                                if attachment and attachment > 0 then
                                    local PosAng = wep:GetAttachment(attachment)
                        
                                    if !bone then
                                        PosAng.Pos = PosAng.Pos + Vector(0, 0, 36)
                                        if IsValid(zeta) and zeta:Crouching() then PosAng.Pos = PosAng.Pos - Vector(0, 0, 18) end
                                        PosAng.Ang.p = 0
                                    end
                        
                                    return PosAng.Pos, PosAng.Ang:Forward()
                                end
                        
                                if bone then
                                    local pos, ang = zeta:GetBonePosition(bone)
                                    if pos == zeta:GetPos() then
                                        local matrix = zeta:GetBoneMatrix(bone)
                                        if (matrix) then
                                            pos = matrix:GetTranslation()
                                            ang = matrix:GetAngles()
                                        end
                                    end
                        
                                    ang:RotateAroundAxis(ang:Forward(), 180)
                                    ang:RotateAroundAxis(ang:Up(), 30)
                                    ang:RotateAroundAxis(ang:Forward(), -5.7)
                                    ang:RotateAroundAxis(ang:Right(), 92)
                        
                                    pos = pos + ang:Up() * -3.3 + ang:Right() * 0.8 + ang:Forward() * 5.6
                                    return pos, ang:Forward()
                                end
                            end
                                            
                            local defAng = wep:GetAngles()
                            defAng.p = 0
                        
                            local defPos = wep:GetPos() + defAng:Right() * 0.6 - defAng:Up() * 0.2 + defAng:Forward() * 0.8
                            defPos = defPos + Vector(0, 0, 36)
                            if IsValid(zeta) then defPos = defPos - Vector(0, 0, 18) end

                            return defPos, -defAng:Forward()
                        end
                    end

                    wep.LS_LengthAnimation = math.Approach(wep.LS_LengthAnimation, 1.0, FrameTime() * 10 )

                    if ( CLIENT ) then
                        if !wep.LS_EffectHookInitialized then
                            wep.LS_EffectHookInitialized = true

                            local entIndex = wep:EntIndex()
                            hook.Add('PreDrawTranslucentRenderables', 'zeta_ls_bladerender'..entIndex, function()
                                if !IsValid(zeta) or zeta.IsDead or !IsValid(wep) or zeta:GetNW2String("zeta_weaponname", "NONE") != "LIGHTSABER" then hook.Remove('PreDrawTranslucentRenderables', 'zeta_ls_bladerender'..entIndex) return end

                                local clr = wep.LS_CrystalColor

                                local bladesFound = false
                                local blades = 0
                                for id, t in pairs( wep:GetAttachments() or {} ) do
                                    if !string.match(t.name, "blade(%d+)") and !string.match(t.name, "quillon(%d+)") then continue end

                                    local bladeNum = string.match( t.name, "blade(%d+)" )
                                    if bladeNum and wep:LookupAttachment("blade"..bladeNum) > 0 then
                                        blades = blades + 1
                                        local pos, dir = wep:LS_GetSaberPosAng(zeta, bladeNum)
                                        rb655_RenderBlade(pos, dir, wep:LS_GetBladeLength(), wep.LS_MaxLength, wep.LS_MaxWidth, clr, wep.LS_DarkInner, entIndex, (zeta:WaterLevel() == 3), false, blades)
                                        bladesFound = true
                                    end

                                    local quillonNum = string.match( t.name, "quillon(%d+)" )
                                    if quillonNum and wep:LookupAttachment("quillon"..quillonNum) > 0 then
                                        blades = blades + 1
                                        local pos, dir =  wep:LS_GetSaberPosAng(zeta, quillonNum, true)
                                        rb655_RenderBlade(pos, dir, wep:LS_GetBladeLength(), wep.LS_MaxLength, wep.LS_MaxWidth, clr, wep.LS_DarkInner, entIndex, (zeta:WaterLevel() == 3), true, blades)
                                    end
                                end

                                if !bladesFound then
                                    local pos, dir = wep:LS_GetSaberPosAng(zeta)
                                    rb655_RenderBlade(pos, dir, wep:LS_GetBladeLength(), wep.LS_MaxLength, wep.LS_MaxWidth, clr, wep.LS_DarkInner, entIndex, (zeta:WaterLevel() == 3))
                                end
                            end)
                        end
                    end

                    if ( SERVER ) then
                        local bladeLength = wep:LS_GetBladeLength()
                        if bladeLength <= 0 then return end
                        local pos, ang = wep:LS_GetSaberPosAng(zeta, 1)
                        local traceFilter = {wep, zeta}

                        local isTrace1Hit = false
                        local trace = util.TraceLine({
                            start = pos,
                            endpos = pos + ang * bladeLength,
                            filter = traceFilter
                        })
                        local traceBack = util.TraceLine({
                            start = pos + ang * bladeLength,
                            endpos = pos,
                            filter = traceFilter
                        })

                        if trace.HitSky or (trace.StartSolid and trace.HitWorld) then trace.Hit = false end
                        if traceBack.HitSky or (traceBack.StartSolid and traceBack.HitWorld) then traceBack.Hit = false end

                        wep:LS_DrawHitEffects(trace, traceBack)
                        isTrace1Hit = (trace.Hit or traceBack.Hit)
                    
                        if trace.Hit then rb655_LS_DoDamage(trace, wep) end
                        if traceBack.Hit and (!IsValid(trace.Entity) or traceBack.Entity != trace.Entity) then
                            rb655_LS_DoDamage(traceBack, wep)
                        end
                    
                        local isTrace2Hit = false
                        if wep:LookupAttachment("blade2") > 0 then
                            local pos2, dir2 = wep:LS_GetSaberPosAng(zeta, 2)
                            local trace2 = util.TraceLine({
                                start = pos2,
                                endpos = pos2 + dir2 * bladeLength,
                                filter = traceFilter,
                            })
                            local traceBack2 = util.TraceLine({
                                start = pos2 + dir2 * bladeLength,
                                endpos = pos2,
                                filter = traceFilter,
                            })
                    
                            if trace2.HitSky or (trace2.StartSolid and trace2.HitWorld) then trace2.Hit = false end
                            if traceBack2.HitSky or (traceBack2.StartSolid and traceBack2.HitWorld) then traceBack2.Hit = false end
                    
                            wep:LS_DrawHitEffects(trace2, traceBack2)
                            isTrace2Hit = trace2.Hit or traceBack2.Hit
                    
                            if traceBack2.Entity == trace2.Entity and IsValid(trace2.Entity) then traceBack2.Hit = false end
                    
                            if trace2.Hit then rb655_LS_DoDamage(trace2, wep) end
                            if traceBack2.Hit then rb655_LS_DoDamage(traceBack2, wep) end
                    
                        end

                        if wep.LS_SoundHit then
                            wep.LS_SoundHit:ChangeVolume(((isTrace1Hit or isTrace2Hit) and 0.1 or 0), 0)
                        end

                        local soundMask = 1
                        if bladeLength < wep.LS_MaxLength then soundMask = 0 end

                        if wep.LS_SoundSwing then
                            if wep.LS_LastAng != ang then
                                wep.LS_LastAng = wep.LS_LastAng or ang
                                wep.LS_SoundSwing:ChangeVolume(math.Clamp(ang:Distance(wep.LS_LastAng) / 2, 0, soundMask), 0)
                            end
                            wep.LS_LastAng = ang
                        end
                    
                        if wep.LS_SoundLoop then
                            pos = pos + ang * bladeLength
                            if wep.LS_LastPos != pos then
                                wep.LS_LastPos = wep.LS_LastPos or pos
                                wep.LS_SoundLoop:ChangeVolume(0.1 + math.Clamp(pos:Distance(wep.LS_LastPos) / 128, 0, soundMask * 0.9), 0)
                            end
                            wep.LS_LastPos = pos
                        end

                        if CurTime() > (wep.LS_Force_RegenTime or 0) then
                            wep:LS_SetForce(math.min(wep.LS_Force_Amount + 0.5, 100))
                        end

                        if (CurTime() - wep.LS_NextDamageTakenTime) > 5.0 then
                            wep.LS_DamageTaken = 0
                        end

                        local ene = zeta:GetEnemy()
                        wep.LS_Force_Type = nil
                        if zeta:Health() < zeta:GetMaxHealth() then
                            wep.LS_Force_Type = 4
                        end

                        if zeta:IsChasingSomeone() and IsValid(ene) and zeta:CanSee(ene) then
                            if (zeta:GetRangeSquaredTo(ene) > (512*512) or math.random(100) == 1) and zeta:GetRangeSquaredTo(ene) <= (1024*1024) and zeta:GetRangeSquaredTo(ene) > (128*128) then
                                wep.LS_Force_Type = 1
                            end
                        end

                        if zeta:GetState() == "panic" or wep.LS_DamageTaken >= (zeta:Health() / 4) and (!zeta:IsChasingSomeone() or IsValid(ene) and zeta:GetRangeSquaredTo(ene) > (wep.LS_MaxLength*wep.LS_MaxLength) and zeta:CanSee(ene)) then
                            wep.LS_Force_Type = 2
                        end

                        if wep.LS_Force_Amount <= 1.0 then
                            wep.LS_Force_WaitingForFullPower = true
                        elseif wep.LS_Force_Amount >= 100 then
                            wep.LS_Force_WaitingForFullPower = false
                        end

                        if !wep.LS_Force_WaitingForFullPower and CurTime() > wep.LS_Force_NextUseTime then
                            local powers = {
                                [1] = function() if wep.LS_Force_Amount >= 10 and zeta.loco:IsOnGround() then
                                    local jumpDir = (ene:GetPos()-zeta:GetPos()):Angle():Forward()
                                    local ceilingCheck = util.TraceHull({
                                        start = zeta:GetPos(),
                                        endpos = zeta:GetPos() + (Vector(0, 0, 128) + jumpDir*256),
                                        filter = {zeta, wep, ene},
                                        mins = zeta:OBBMins(),
                                        maxs = zeta:OBBMaxs()
                                    })
                                    if ceilingCheck.Hit then return end

                                    wep:LS_SetForce(wep.LS_Force_Amount - 10)
                                    wep:LS_SetNextAttack(0.5)
                                    wep:EmitSound("lightsaber/force_leap.wav", nil, nil, 1)

                                    zeta.IsJumping = true 
                                    zeta:SetLastActivity(zeta:GetActivity())
                                    zeta.loco:Jump()
                                    zeta.loco:SetVelocity(Vector(0, 0, 512) + jumpDir*512)
                                end end,
                                [2] = function() if wep.LS_Force_Amount >= 1 then
                                    wep:LS_SetForce(wep.LS_Force_Amount - 0.1)
                                    wep:LS_SetNextAttack(0.3)
                                end end,
                                [4] = function() if wep.LS_Force_Amount >= 1 and zeta:Health() < zeta:GetMaxHealth() then
                                    wep:LS_SetForce(wep.LS_Force_Amount - 1)
                                    wep:LS_SetNextAttack(0.2)

                                    local ed = EffectData()
                                    ed:SetOrigin(zeta:GetPos())
                                    util.Effect("rb655_force_heal", ed, true, true)
                            
                                    zeta:SetHealth(zeta:Health() + 1)
                                    zeta:Extinguish()
                                end end
                            }
                            if !powers[wep.LS_Force_Type] then return end
                            powers[wep.LS_Force_Type]()
                        end
                    end
                end,

                fireData = {
                    range = 48,
                    preCallback = function(callback, zeta, wep, target, blockData)
                        if CurTime() <= zeta.AttackCooldown then return end
                        zeta.AttackCooldown = CurTime() + 0.5
            
                        if zeta:IsPlayingGesture(wep.RangeAttackAnimation) then
                            zeta:RemoveGesture(wep.RangeAttackAnimation)
                        end
                        zeta:AddGesture(wep.RangeAttackAnimation, true)

                        zeta:FaceTick(target, 100)
                    end
                },

                onKillCallback = function(callback, zeta, wep, victim, dmginfo)
                    victim:EmitSound("lightsaber/saber_hit_laser"..math.random(5)..".wav")
                end
            }
        }

        table.Merge(_ZetaWeaponDataTable, saberWpnData)
    end


    local nyanGun = weapons.Get("weapon_nyangun")
    if istable(nyanGun) then
        local nyanGunWpnData = {
            NYANGUN = {
                mdl = 'models/weapons/w_smg1.mdl',
                
                hidewep = false,
                offPos = Vector(7,-2,5),   
                offAng = Angle(-10,0,0),
                lethal = true,
                range = true,
                melee = false,
                clip = 1,
                prettyPrint = 'Nyan Gun',
                keepDistance = 400,

                anims = {
                    idle = ACT_HL2MP_IDLE_SMG1,
                    move = ACT_HL2MP_RUN_SMG1,
                    jump = ACT_HL2MP_JUMP_SMG1,
                    crouch = ACT_HL2MP_WALK_CROUCH_SMG1
                },

                changeCallback = function(callback, zeta, wep)
                    wep.NyanGun_BeatStopPlayingTime = CurTime()
                    wep.NyanGun_BeatSound = CreateSound(zeta, "weapons/nyan/nyan_beat.wav")
                    if wep.NyanGun_BeatSound then wep.NyanGun_BeatSound:Play() end

                    local function KillSounds()
                        if wep.NyanGun_LoopSound then wep.NyanGun_LoopSound:Stop(); wep.NyanGun_LoopSound = nil end
                        if wep.NyanGun_BeatSound then wep.NyanGun_BeatSound:Stop(); wep.NyanGun_BeatSound = nil end 
                    end

                    zeta:CreateThinkFunction("NyanGun_HolsterSoundHack", 0, 0, function()
                        if zeta.Weapon == "NYANGUN" then return end
                        KillSounds()
                        return "stop"
                    end)

                    if !zeta.NyanGun_CallOnRemove then
                        zeta.NyanGun_CallOnRemove = true
                        zeta:CallOnRemove("zeta_nyangun_killsounds"..zeta:EntIndex(), function() KillSounds() end)
                    end
                end,

                onThink = function(callback, zeta, wep)
                    if ( CLIENT ) then return end
                    if !wep.NyanGun_BeatStopPlayingTime or CurTime() < wep.NyanGun_BeatStopPlayingTime then return end
                    if wep.NyanGun_LoopSound then wep.NyanGun_LoopSound:ChangeVolume(0, 0.1) end
                    if wep.NyanGun_BeatSound then wep.NyanGun_BeatSound:ChangeVolume(1, 0.1) end
                end,

                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        local attackChance = math.random(75)
                        if attackChance <= 5 then
                            local ang = (target:GetPos() - zeta:GetPos()):Angle()
                            local bomb = ents.Create("ent_nyan_bomb")
                            if IsValid(bomb) then
                                bomb:SetPos(zeta:GetCenteroid() + ang:Forward()*28 + ang:Right()*24 - ang:Up()*8)
                                bomb:SetAngles(ang)
                                bomb:SetOwner(zeta)
                                bomb:Spawn()
                                bomb:Activate()

                                local phys = bomb:GetPhysicsObject()
                                if IsValid(phys) then
                                    local eneDist = (zeta:GetRangeTo(target) / 4)
                                    phys:Wake() 
                                    phys:AddVelocity(VectorRand(-50, 50) + bomb:GetUp()*eneDist + bomb:GetForward()*1337) 
                                end

                                zeta:CallOnRemove("zeta_nyangun_fixupowner"..bomb:EntIndex(), function()
                                    if !IsValid(bomb) then return end
                                    bomb:SetOwner(Entity(0))
                                end)
                            end

                            wep:EmitSound("weapons/nyan/nya"..math.random(2)..".wav", 100, math.random(60, 80))
                            zeta.AttackCooldown = CurTime() + 1.0

                            blockData.cooldown = true
                            blockData.bullet = true
                        elseif attackChance >= 70 and zeta:GetRangeSquaredTo(target) <= (384*384) then
                            wep:EmitSound("weapons/nyan/nya"..math.random(2)..".wav", 100, math.random(85, 100))
                            zeta.AttackCooldown = CurTime() + 0.5

                            FireBulletsTABLE.Attacker = zeta
                            FireBulletsTABLE.Damage = (4 / GetConVar("zetaplayer_damagedivider"):GetFloat())
                            FireBulletsTABLE.Force = (10 + GetConVar("zetaplayer_forceadd"):GetInt())
                            FireBulletsTABLE.Spread = Vector(0.1 + zeta.Accuracy, 0.1 + zeta.Accuracy,0)
                            FireBulletsTABLE.Num = 6
                            FireBulletsTABLE.TracerName = "rb655_nyan_tracer"
                            FireBulletsTABLE.Dir = (target:GetCenteroid() - wep:GetPos()):GetNormalized()
                            FireBulletsTABLE.Src = wep:GetPos()
                            FireBulletsTABLE.IgnoreEntity = zeta
                            wep:FireBullets(FireBulletsTABLE)

                            blockData.bullet = true
                            blockData.cooldown = true
                        else
                            wep.NyanGun_BeatStopPlayingTime = CurTime() + 0.1

                            if wep.NyanGun_LoopSound then
                                wep.NyanGun_LoopSound:ChangeVolume(1, 0.1)
                            else
                                wep.NyanGun_LoopSound = CreateSound(zeta, "weapons/nyan/nyan_loop.wav")
                                if wep.NyanGun_LoopSound then wep.NyanGun_LoopSound:Play() end
                            end
                            if wep.NyanGun_BeatSound then wep.NyanGun_BeatSound:ChangeVolume(0, 0.1) end
                        end

                        blockData.snd = true
                        blockData.shell = true
                        blockData.clipRemove = true
                        return blockData
                    end,

                    rateMin = 0.1,
                    rateMax = 0.1,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
                    muzzleFlash = 0,
                    snd = "",
                    num = 1,
                    dmgMin = 8,
                    dmgMax = 8,
                    force = 5,
                    ammo = "",
                    spread = 0.01,
                    tracer = "rb655_nyan_tracer"
                },

                reloadData = {
                    anim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
                    time = 1.5,
                    snds = {
                        {0, 'weapons/smg1/smg1_reload.wav'},
                    }
                }
            }
        }

        table.Merge(_ZetaWeaponDataTable, nyanGunWpnData)
    end




    if mp1_lib then

        if (SERVER) then
            util.AddNetworkString("zeta_mp1_getmuzzlename")
            util.AddNetworkString("zeta_mp1_sendmuzzlename")
        else
            net.Receive("zeta_mp1_getmuzzlename", function()
                local wep = net.ReadEntity()
                local valid = (IsValid(wep) and isstring(wep.MuzzleName))
        
                net.Start("zeta_mp1_sendmuzzlename", true)
                    net.WriteBool(valid)
                net.SendToServer()
            end)
        end

        local MP1_FireBulletTable = {
            AmmoType = "mp1_ammo",
            Tracer = 1,
            HullSize = 2
        }
    
        local MP1_MuzzleFlash = function(wep, att)
            net.Start("zeta_mp1_getmuzzlename", true)
                net.WriteEntity(wep)
            net.Broadcast()
            
            net.Receive("zeta_mp1_sendmuzzlename", function()
                local valid = net.ReadBool()
                if !valid or !IsValid(wep) then return end
                local fx = EffectData()
                fx:SetEntity(wep)
                fx:SetAttachment(att or 1)
                util.Effect("mp1_muzzle", fx, true, true)
            end)
        end
    
        local MP1_FireBullet = function(zeta, wep, target, dmg, spread, force, physBulletData, numShots, isShotgun)
            isShotgun = isShotgun or false
            physBulletData = physBulletData or {}
        
            local dmg_mul = cvars.Number("mp1_damage_mul")
            local zetaAccuracy = 30 + (zeta.Accuracy * 50)
            local shotpos = wep:GetPos()
        
            local bulletVel = physBulletData.Velocity or 1968.5
            local targCenteroid = (IsValid(target) and target:GetCenteroid() or wep:GetPos() + zeta:GetForward() * bulletVel)
        
            local aimvec = (targCenteroid - shotpos)
            local targPos = targCenteroid + aimvec:Angle():Up()*math.random(-zetaAccuracy, zetaAccuracy) + aimvec:Angle():Right()*math.random(-zetaAccuracy, zetaAccuracy)
            aimvec = (targPos - shotpos)
        
            if cvars.Bool("mp1_projectiles") then
                if IsValid(target) then
                    local targVel = (target.IsZetaPlayer and target.loco:GetVelocity() or target:GetVelocity())
                    aimvec = (targPos + targVel * ((targPos:Distance(shotpos) / bulletVel) * math.Rand(0.33, 1.0))) - shotpos
                end
        
                for i = 1, numShots or 1 do 
                    local vel = bulletVel
                    local proc = (vel / 100)
                    local mul = physBulletData.SpeedMultiplier or 5
                    local bullet = ents.Create("ent_mp1_bullet")
                    local spread = (spread * 5) / (math.random(100) > 75 and 1 or 3)
        
                    bullet.data = {
                        model = physBulletData.Model or "models/mp1/Projectiles/tracer_9mm.mdl",
                        vel = (vel + proc *math.random(-mul, mul)) * cvars.Number("mp1_prj_vel_mul"),
                        force = force,
                        damage = (dmg * dmg_mul) / GetConVar("zetaplayer_damagedivider"):GetInt(),
                        spread = spread,
                        bullcam = false,
                    }
        
                    local ang = aimvec:Angle()
                    if isShotgun then
                        if i != numShots then 
                            ang:RotateAroundAxis(ang:Forward(), math.Rand(-spread, spread))
                            ang:RotateAroundAxis(ang:Right(), math.Rand(-spread, spread))
                            ang:RotateAroundAxis(ang:Up(), math.Rand(-spread, spread))
                        end
                    else
                        ang:RotateAroundAxis(ang:Forward(), math.Rand(-spread, spread))
                        ang:RotateAroundAxis(ang:Right(), math.Rand(-spread, spread))
                        ang:RotateAroundAxis(ang:Up(), math.Rand(-spread, spread))
                    end
                    
                    bullet:SetOwner(zeta)
                    bullet.swep = wep
                    bullet.entOwner = zeta
        
                    bullet:SetAngles(ang)
                    bullet:SetPos(shotpos)
                    bullet:Spawn()
                    bullet:Activate() 
        
                    local phys = bullet:GetPhysicsObject()
                    if IsValid(phys) then
                        phys:SetVelocity(ang:Forward() * bullet.data.vel)
                    end 
                end
            else
                MP1_FireBulletTable.Attacker = zeta
                MP1_FireBulletTable.Damage = (dmg * dmg_mul) / GetConVar("zetaplayer_damagedivider"):GetInt()
                MP1_FireBulletTable.Force = force or 1
                MP1_FireBulletTable.Dir = aimvec:GetNormalized()
                MP1_FireBulletTable.Src = shotpos
                MP1_FireBulletTable.Callback = function(attacker, trace, damageInfo)
                    local hitEnt = trace.Entity
                    if IsValid(hitEnt) and IsValid(attacker) then 
                        damageInfo:SetInflictor(attacker)
                        if isShotgun and cvars.Bool("ai_serverragdolls") then 
                            damageInfo:SetDamageForce(damageInfo:GetDamageForce() / 6) 
                        end
                        if hitEnt.IsZetaPlayer or hitEnt:IsNPC() or hitEnt:IsPlayer() then 
                            damageInfo:SetDamageForce(damageInfo:GetDamageForce() + Vector(0, 0, force * 575)) 
                        end
                    end
                    local impact_sound = mp1_lib.hit_sound[trace.MatType]
                    if impact_sound then 
                        if SERVER then sound.Play(impact_sound, trace.HitPos) end
                    end
                end
         
                for i = 1, numShots or 1 do 
                    local newSpread = (spread * 0.1) / (math.random(100) > 75 and 1 or 3)
                    MP1_FireBulletTable.Spread = Vector(newSpread, newSpread, 0)
                    wep:FireBullets(MP1_FireBulletTable)
                end
            end
        end
    
        local MP1_MergeTable = {
            MP1_BERETTA = {
                mdl = "models/mp1/Weapons/w_beretta.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 18,
                prettyPrint = "[MP1] Beretta",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_PISTOL,
                    move = ACT_HL2MP_RUN_PISTOL,
                    jump = ACT_HL2MP_JUMP_PISTOL,
                    crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_beretta" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 5, 0.35, 4)
                        
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
    
                        return blockData
                    end, 
    
                    rateMin = 0.25,
                    rateMax = 0.25,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
                    snd = "MP1.BerettaFire"
                },
    
                shellData = {
                    name = "ShellEject",
                    offPos = {
                        forward = 4,
                        right = 7,
                        up = -2
                    },
                    offAng = Angle(-90, 90, 0)
                },
    
                reloadData = {
                    anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
                    time = 1.4,
                    snds = {
                        {0.2, "MP1.BerettaOut"},
                        {0.4, "MP1.BerettaIn"},
                        {1.2, "MP1.BerettaChamber"},
                    }
                }
            },
    
            MP1_DUALBERETTAS = {
                mdl = "models/mp1/Weapons/w_beretta_dual.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 36,
                prettyPrint = "[MP1] Dual Berettas",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_DUEL,
                    move = ACT_HL2MP_RUN_DUEL,
                    jump = ACT_HL2MP_JUMP_DUEL,
                    crouch = ACT_HL2MP_WALK_CROUCH_DUEL
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_beretta" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.snd = true
                        blockData.anim = true
                        blockData.shell = true
                        blockData.bullet = true
                        blockData.muzzle = true
                        blockData.clipRemove = true
                        
                        if wep.ShouldFireLeft == nil then wep.ShouldFireLeft = false end
    
                        local fireBullet = function()
                            local shellAttach = wep:GetAttachment((wep.ShouldFireLeft and 5 or 2))
                            local shellEject = EffectData()
                            shellEject:SetOrigin(shellAttach.Pos)
                            shellEject:SetAngles(shellAttach.Ang)
                            shellEject:SetEntity(wep)
                            util.Effect("ShellEject", shellEject)
    
                            local muzzleAttach = (wep.ShouldFireLeft and 4 or 1)
                            MP1_MuzzleFlash(wep, muzzleAttach)
    
                            MP1_FireBullet(zeta, wep, target, 5, 0.65, 4)
                            zeta.CurrentAmmo = zeta.CurrentAmmo - 1
    
                            EmitSound(Sound("MP1.BerettaFire"), wep:GetPos(), (wep.ShouldFireLeft and zeta:EntIndex() or wep:EntIndex()))
                            wep.ShouldFireLeft = !wep.ShouldFireLeft
                        end
                        
                        fireBullet()
                        timer.Simple(0.08, function()
                            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "MP1_DUALBERETTAS" or zeta.CurrentAmmo <= 0 then return end
                            fireBullet()
                        end)
    
                        return blockData
                    end,
    
                    rateMin = 0.25,
                    rateMax = 0.25
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_DUEL, true)
                        zeta:SetLayerPlaybackRate(layerID, 2.5)
                        return 1.4
                    end,
                    snds = {
                        {0.2, "MP1.BerettaOut"},
                        {0.4, "MP1.BerettaIn"},
                        {1.2, "MP1.BerettaChamber"},
                    }
                }
            },
    
            MP1_DESERTEAGLE = {
                mdl = "models/mp1/Weapons/w_deagle.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 12,
                prettyPrint = "[MP1] Desert Eagle",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_REVOLVER,
                    move = ACT_HL2MP_RUN_REVOLVER,
                    jump = ACT_HL2MP_JUMP_REVOLVER,
                    crouch = ACT_HL2MP_WALK_CROUCH_REVOLVER
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_deagle" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 10, 0.15, 10, {Model="models/mp1/Projectiles/tracer_50cal.mdl"})
                        
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
                        
                        return blockData
                    end, 
    
                    rateMin = 0.333,
                    rateMax = 0.333,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
                    snd = "MP1.DesertEagleFire"
                },
    
                shellData = {
                    name = "ShellEject",
                    offPos = {
                        forward = 4,
                        right = 7,
                        up = -2
                    },
                    offAng = Angle(-90, 90, 0)
                },
    
                reloadData = {
                    anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
                    time = 1.7,
                    snds = {
                        {0.2, "MP1.DeagleOut"},
                        {0.7, "MP1.DeagleIn"},
                        {1.4, "MP1.DeagleChamber"},
                    }
                }
            },
    
            MP1_INGRAM = {
                mdl = "models/mp1/Weapons/w_ingram.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 50,
                prettyPrint = "[MP1] Ingram",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_PISTOL,
                    move = ACT_HL2MP_RUN_PISTOL,
                    jump = ACT_HL2MP_JUMP_PISTOL,
                    crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_ingram" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 5, 1.2, 3)
                        
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
                        
                        return blockData
                    end, 
    
                    rateMin = 0.03125,
                    rateMax = 0.03125,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
                    snd = "MP1.IngramFire"
                },
    
                shellData = {
                    name = "ShellEject",
                    offPos = {
                        forward = 4,
                        right = 4,
                        up = -2
                    },
                    offAng = Angle(-90, 90, 0)
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_SMG1, true)
                        zeta:SetLayerPlaybackRate(layerID, 1.8)
                        return 1.1
                    end,
                    snds = {
                        {0, "MP1.IngramOut"},
                        {0.4, "MP1.IngramIn"},
                        {0.7, "MP1.IngramChamber"},
                    }
                }
            },
    
            MP1_DUALINGRAMS = {
                mdl = "models/mp1/Weapons/w_ingram_dual.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 100,
                prettyPrint = "[MP1] Dual Ingrams",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_DUEL,
                    move = ACT_HL2MP_RUN_DUEL,
                    jump = ACT_HL2MP_JUMP_DUEL,
                    crouch = ACT_HL2MP_WALK_CROUCH_DUEL
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_ingram" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.anim = true
                        
                        if wep.ShouldFireLeft == nil then wep.ShouldFireLeft = false end
    
                        blockData.shell = true
                        local shellAttach = wep:GetAttachment((wep.ShouldFireLeft and 5 or 2))
                        local shellEject = EffectData()
                        shellEject:SetOrigin(shellAttach.Pos)
                        shellEject:SetAngles(shellAttach.Ang)
                        shellEject:SetEntity(wep)
                        util.Effect("ShellEject", shellEject)
    
                        blockData.muzzle = true
                        local muzzleAttach = (wep.ShouldFireLeft and 4 or 1)
                        MP1_MuzzleFlash(wep, muzzleAttach)
    
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 5, 1.5, 3)
    
                        wep.ShouldFireLeft = !wep.ShouldFireLeft
                        return blockData
                    end,
    
                    rateMin = 0.00625,
                    rateMax = 0.00625,
                    snd = "MP1.IngramFire",
                },
    
                shellData = {
                    name = "ShellEject",
                    offPos = {
                        forward = 3,
                        right = 0,
                        up = 3
                    },
                    offAng = Angle(0, 90, 0)
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_DUEL, true)
                        zeta:SetLayerPlaybackRate(layerID, 2.5)
                        return 1.4
                    end,
                    snds = {
                        {0.2, "MP1.IngramOut"},
                        {0.5, "MP1.IngramIn"},
                        {1.0, "MP1.IngramChamber"},
                    }
                }
            },
    
            MP1_MP5 = {
                mdl = "models/mp1/Weapons/w_mp5.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 30,
                prettyPrint = "[MP1] MP5",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_AR2,
                    move = ACT_HL2MP_RUN_AR2,
                    jump = ACT_HL2MP_JUMP_AR2,
                    crouch = ACT_HL2MP_WALK_CROUCH_AR2
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_mp5" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 5, 0.25, 3)
    
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
    
                        return blockData
                    end, 
    
                    rateMin = 0.11,
                    rateMax = 0.11,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
                    snd = "MP1.MP5Fire"
                },
    
                shellData = {
                    name = "ShellEject",
                    offPos = {
                        forward = 5,
                        right = 8.5,
                        up = -2
                    },
                    offAng = Angle(-90, 90, 0)
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_SMG1, true)
                        zeta:SetLayerPlaybackRate(layerID, 1.5)
                        return 1.4
                    end,
                    snds = {
                        {0.2, "MP1.IngramOut"},
                        {0.7, "MP1.IngramIn"},
                        {0.95, "MP1.MP5Chamber"},
                    }
                }
            },
    
            MP1_SAWEDOFFSHOTGUN = {
                mdl = "models/mp1/Weapons/w_sawedshotgun.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 2,
                prettyPrint = "[MP1] Sawed-Off Shotgun",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_PISTOL,
                    move = ACT_HL2MP_RUN_PISTOL,
                    jump = ACT_HL2MP_JUMP_SHOTGUN,
                    crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_sawed" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.shell = true
                        
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 5, 1.5, 20, {Model="models/mp1/Projectiles/tracer_12ga.mdl"}, 13, true)
    
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
    
                        return blockData
                    end,
    
                    rateMin = 0.5,
                    rateMax = 0.5,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
                    snd = "MP1.SawedShotgunFire"
                },
    
                shellData = {
                    name = "ShotgunShellEject",
                    offPos = {
                        forward = 2,
                        right = 5,
                        up = -4
                    },
                    offAng = Angle(0, 0, 0)
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                        zeta:SetLayerPlaybackRate(layerID, 1.75)
                        timer.Simple(0.35, function()
                            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "MP1_SAWEDOFFSHOTGUN" then return end
                            zeta:CreateShellEject()
                            if zeta.CurrentAmmo == 0 then zeta:CreateShellEject() end
                        end)
                        return 1.3
                    end,
                    snds = {
                        {0.2, "MP1.SawnOffOut"},
                        {0.7, "MP1.SawnOffIn"},
                        {1.1, "MP1.SawnOffChamber"},
                    }
                }
            },
    
            MP1_PUMPSHOTGUN = {
                mdl = "models/mp1/Weapons/w_shotgun.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 7,
                prettyPrint = "[MP1] Sawed-Off Shotgun",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_SHOTGUN,
                    move = ACT_HL2MP_RUN_SHOTGUN,
                    jump = ACT_HL2MP_JUMP_SHOTGUN,
                    crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_pump" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.shell = true
                        timer.Simple(0.5, function()
                            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "MP1_PUMPSHOTGUN" then return end
                            zeta:CreateShellEject()
                            wep:EmitSound(Sound("MP1.ShotgunPump"))
                        end)
    
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 5, 0.55, 15, {Model="models/mp1/Projectiles/tracer_12ga.mdl"}, 13, true)
    
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
    
                        return blockData
                    end,
    
                    rateMin = 1,
                    rateMax = 1,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
                    snd = "MP1.PumpShotgunFire"
                },
    
                shellData = {
                    name = "ShotgunShellEject",
                    offPos = {
                        forward = 4,
                        right = 11,
                        up = -1
                    },
                    offAng = Angle(-90, 90, 0)
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        local shellAmount = (7 - zeta.CurrentAmmo)
    
                        local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                        timer.Create("zeta_shotgunreload"..wep:EntIndex(), 0.1, shellAmount, function()
                            if !IsValid(zeta) or !IsValid(wep) then return end
                            if zeta.Weapon != "MP1_PUMPSHOTGUN" then
                                zeta:RemoveGesture(ACT_HL2MP_GESTURE_RELOAD_AR2)
                                timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                                return 
                            end
    
                            local repsLeft = timer.RepsLeft("zeta_shotgunreload"..wep:EntIndex())
                            if (-repsLeft + shellAmount - 1) >= 1 and math.random(2) == 1 and IsValid(zeta:GetEnemy()) and zeta:CanSee(zeta:GetEnemy()) then
                                zeta:RemoveGesture(ACT_HL2MP_GESTURE_RELOAD_AR2)
                                zeta.CurrentAmmo = (-repsLeft + shellAmount - 1)
                                zeta.IsReloading = false
                                timer.Remove("ZetaFinishReloading"..zeta:EntIndex())
                                timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                                return
                            end
    
                            zeta:SetLayerCycle(layerID, 0.2)
                            zeta:SetLayerPlaybackRate(layerID, 1.6)
    
                            wep:EmitSound(Sound("MP1.PumpShotgunReload"))
                            if repsLeft == 0 then
                                timer.Simple(0.4, function()
                                    if !IsValid(zeta) or !IsValid(wep) or !zeta:IsValidLayer(layerID) then return end
                                    zeta:SetLayerCycle(layerID, 0.75)
                                end)
                            elseif repsLeft == (shellAmount - 1) then
                                timer.Adjust("zeta_shotgunreload"..wep:EntIndex(), 0.4, nil, nil)
                            end
                        end)
    
                        return 0.2 + 0.4 * shellAmount
                    end
                }
            },
    
            MP1_COLTCOMMANDO = {
                mdl = "models/mp1/Weapons/w_coltcommando.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 30,
                prettyPrint = "[MP1] Colt Commando",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_AR2,
                    move = ACT_HL2MP_RUN_AR2,
                    jump = ACT_HL2MP_JUMP_AR2,
                    crouch = ACT_HL2MP_WALK_CROUCH_AR2
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_colt" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 10, 0.075, 6, {Model="models/mp1/Projectiles/tracer_50cal.mdl"})
    
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
    
                        return blockData
                    end, 
    
                    rateMin = 0.166,
                    rateMax = 0.166,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
                    snd = "MP1.ColtCommandoFire"
                },
    
                shellData = {
                    name = "RifleShellEject",
                    offPos = {
                        forward = 4,
                        right = 8,
                        up = -1
                    },
                    offAng = Angle(-90, 90, 0)
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                        zeta:SetLayerPlaybackRate(layerID, 1.33)
                        return 1.4
                    end,
                    snds = {
                        {0, "MP1.CommandoOut"},
                        {0.3, "MP1.CommandoIn"},
                        {1.1, "MP1.CommandoChamber"},
                    }
                }
            },
    
            MP1_JACKHAMMER = {
                mdl = "models/mp1/Weapons/w_jackhammer.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 12,
                prettyPrint = "[MP1] Jackhammer",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_AR2,
                    move = ACT_HL2MP_RUN_AR2,
                    jump = ACT_HL2MP_JUMP_AR2,
                    crouch = ACT_HL2MP_WALK_CROUCH_AR2
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_jack" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 5, 1.2, 15, {Model="models/mp1/Projectiles/tracer_12ga.mdl"}, 13, true)
    
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
    
                        return blockData
                    end, 
    
                    rateMin = 0.333,
                    rateMax = 0.333,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
                    snd = "MP1.JackhammerFire"
                },
    
                shellData = {
                    name = "ShotgunShellEject",
                    offPos = {
                        forward = 4,
                        right = 5,
                        up = -3
                    },
                    offAng = Angle(-90, 135, 0)
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                        zeta:SetLayerPlaybackRate(layerID, 1.66)
                        return 1.3
                    end,
                    snds = {
                        {0.25, "MP1.JackhammerOut"},
                        {0.7, "MP1.JackhammerIn"},
                        {1.1, "MP1.JackhammerChamber"},
                    }
                }
            },
    
            MP1_SNIPERRIFLE = {
                mdl = "models/mp1/Weapons/w_sniperrifle.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 5,
                prettyPrint = "[MP1] Sniper Rifle",
                keepDistance = 850,
    
                anims = {
                    idle = ACT_HL2MP_IDLE_RPG,
                    move = ACT_HL2MP_RUN_RPG,
                    jump = ACT_HL2MP_JUMP_RPG,
                    crouch = ACT_HL2MP_WALK_CROUCH_RPG
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_sniper" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.shell = true
                        timer.Simple(0.4, function()
                            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "MP1_SNIPERRIFLE" then return end
                            local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                            zeta:SetLayerCycle(layerID, 0.6)
                            zeta:SetLayerPlaybackRate(layerID, 2)
                            zeta:CreateShellEject()
                            wep:EmitSound(Sound("MP1.SniperBolt"))
                        end)
    
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 70, 0, 14, {Model="models/mp1/Projectiles/bullet_762mm.mdl", Velocity=10000, SpeedMultiplier=0})
    
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
    
                        return blockData
                    end,
    
                    rateMin = 1.8,
                    rateMax = 1.8,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG,
                    snd = "MP1.SniperFire"
                },
    
                shellData = {
                    name = "RifleShellEject",
                    offPos = {
                        forward = 4,
                        right = 7,
                        up = -3
                    },
                    offAng = Angle(-90, 135, 0)
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                        zeta:SetLayerPlaybackRate(layerID, 1.5)
                        return 1.4
                    end,
                    snds = {
                        {0.25, "MP1.CommandoOut"},
                        {0.6, "MP1.SniperIn"},
                        {0.9, "MP1.SniperChamber"},
                    }
                }
            },
    
            MP1_M79 = {
                mdl = "models/mp1/Weapons/w_m79.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 1,
                prettyPrint = "[MP1] M79",
                keepDistance = 400,
    
                anims = {
                    idle = ACT_HL2MP_IDLE_SHOTGUN,
                    move = ACT_HL2MP_RUN_SHOTGUN,
                    jump = ACT_HL2MP_JUMP_SHOTGUN,
                    crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_m79" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.shell = true
    
                        blockData.bullet = true
                        
                        local zetaAccuracy = 10 + (zeta.Accuracy * 55)
                        local ang = (target:GetPos() - wep:GetPos()):Angle()
                        local targPos = target:GetPos() + ang:Up()*(math.random(-zetaAccuracy, zetaAccuracy) + (wep:GetPos():Distance(target:GetPos()) / 20)) + ang:Right()*math.random(-zetaAccuracy, zetaAccuracy)
                        ang = (targPos - wep:GetPos()):Angle()
    
                        local bullet = ents.Create("ent_mp1_grenade_m79")
    
                        bullet:SetOwner(zeta)
                        bullet.swep = wep
                        bullet.entOwner = zeta
                        bullet.damage = 200 / GetConVar("zetaplayer_damagedivider"):GetInt()
                        bullet.radius = 375
    
                        bullet:SetPos(wep:GetPos())
                        bullet:SetAngles(ang)
                        bullet:Spawn()
                        bullet:Activate() 
    
                        local phys = bullet:GetPhysicsObject()
                        if IsValid(phys) then
                            phys:SetVelocity(ang:Forward() * 2250)
                        end
    
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
    
                        return blockData
                    end,
    
                    rateMin = 1,
                    rateMax = 1,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW,
                    snd = "MP1.M79Fire"
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        timer.Simple(1.5, function()
                            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "MP1_M79" then return end
                            local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                            zeta:SetLayerPlaybackRate(layerID, 1.66)
                        end)
                        return 2.8
                    end,
                    snds = {
                        {1.7, "MP1.M79Out"},
                        {2.0, "MP1.M79In"},
                        {2.5, "MP1.M79Chamber"},
                    }
                }
            },
    
            MP1_COCKTAIL = {
                mdl = "models/MP1/Weapons/w_molotov.mdl",
                hidewep = false,
                offPos = Vector(0, 0, 0),   
                offAng = Angle(0, 0, 0),
                lethal = true,
                range = true,
                melee = false,
                clip = 1,
                prettyPrint = "[MP1] Molotov Cocktail",
                keepDistance = 400,
    
                anims = {
                    idle = ACT_HL2MP_IDLE_GRENADE,
                    move = ACT_HL2MP_RUN_GRENADE,
                    jump = ACT_HL2MP_JUMP_GRENADE,
                    crouch = ACT_HL2MP_WALK_CROUCH_GRENADE
                },
    
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.muzzle = true 
                        blockData.shell = true
                        blockData.snd = true
                        blockData.bullet = true
                        blockData.clipRemove = true
                        blockData.anim = true
    
                        timer.Simple(0.5, function()
                            if !IsValid(zeta) or !IsValid(wep) or !IsValid(target) or zeta.Weapon != "MP1_COCKTAIL" then return end
                            wep:EmitSound(Sound("MP1.ThrowableFire"))
    
                            if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE) then zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE) end
                            zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE, true)
    
                            local zetaAccuracy = 10 + (zeta.Accuracy * 55)
                            local ang = (target:GetPos() - wep:GetPos()):Angle()
                            local targPos = target:GetPos() + ang:Up()*(math.random(-zetaAccuracy, zetaAccuracy) + (wep:GetPos():Distance(target:GetPos())) / 4) + ang:Right()*math.random(-zetaAccuracy, zetaAccuracy)
                            ang = (targPos - wep:GetPos()):Angle()
    
                            local prj = ents.Create("ent_mp1_molotov_thrown")
                            prj:SetPos(wep:GetPos())
                            prj:SetAngles(ang)
                            prj:Spawn()
                            prj:Activate() 
    
                            prj:SetOwner(zeta)
                            prj.swep = wep
                            prj.entOwner = zeta
                            prj.Damage = 135 / GetConVar("zetaplayer_damagedivider"):GetInt()
                            prj.Radius = 175
    
                            local phys = prj:GetPhysicsObject()
                            if IsValid(phys) then
                                phys:SetVelocity(ang:Forward() * 950)
                                phys:SetAngleVelocity(ang:Forward() * 950)
                            end
                        end)
                        return blockData
                    end,
                    
                    rateMin = 2.0,
                    rateMax = 4.0
                }
            }, 
    
            MP1_GRENADE = {
                mdl = "models/MP1/Weapons/w_grenade.mdl",
                hidewep = false,
                offPos = Vector(0, 0, 0),   
                offAng = Angle(0, 0, 0),
                lethal = true,
                range = true,
                melee = false,
                clip = 1,
                prettyPrint = "[MP1] GRENADE",
                keepDistance = 500,
    
                anims = {
                    idle = ACT_HL2MP_IDLE_GRENADE,
                    move = ACT_HL2MP_RUN_GRENADE,
                    jump = ACT_HL2MP_JUMP_GRENADE,
                    crouch = ACT_HL2MP_WALK_CROUCH_GRENADE
                },
    
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.muzzle = true 
                        blockData.shell = true
                        blockData.snd = true
                        blockData.bullet = true
                        blockData.clipRemove = true
                        blockData.anim = true
    
                        timer.Simple(0.5, function()
                            if !IsValid(zeta) or !IsValid(wep) or !IsValid(target) or zeta.Weapon != "MP1_GRENADE" then return end
                            wep:EmitSound(Sound("MP1.ThrowableFire"))
    
                            if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE) then zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE) end
                            zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE, true)
    
                            local zetaAccuracy = 10 + (zeta.Accuracy * 55)
                            local ang = (target:GetPos() - wep:GetPos()):Angle()
                            local targPos = target:GetPos() + ang:Up()*(math.random(-zetaAccuracy, zetaAccuracy) + (wep:GetPos():Distance(target:GetPos())) / 5) + ang:Right()*math.random(-zetaAccuracy, zetaAccuracy)
                            ang = (targPos - wep:GetPos()):Angle()
    
                            local prj = ents.Create("ent_mp1_grenade_thrown")
                            prj:SetPos(wep:GetPos())
                            prj:SetAngles(ang)
                            prj:Spawn()
                            prj:Activate() 
    
                            prj:SetOwner(zeta)
                            prj.swep = wep
                            prj.entOwner = zeta
                            prj.Damage = 150 / GetConVar("zetaplayer_damagedivider"):GetInt()
                            prj.Radius = 375
    
                            local phys = prj:GetPhysicsObject()
                            if IsValid(phys) then
                                phys:SetVelocity(ang:Forward() * 1000)
                                phys:SetAngleVelocity(ang:Forward() * 1000)
                            end
                        end)
                        return blockData
                    end,
                    
                    rateMin = 3.0,
                    rateMax = 5.0
                }
            }, 
    
            MP1_LEADPIPE = {
                mdl = "models/MP1/Weapons/w_leadpipe.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = false,
                melee = true,
                clip = 1,
                prettyPrint = "[MP1] Lead Pipe",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_MELEE,
                    move = ACT_HL2MP_RUN_MELEE,
                    jump = ACT_HL2MP_JUMP_MELEE,
                    crouch = ACT_HL2MP_WALK_CROUCH_MELEE
                },
    
                fireData = {
                    range = 64,
                    preCallback = function(callback, zeta, wep, target, blockData)
                        if CurTime() <= zeta.AttackCooldown then return end
                        zeta.AttackCooldown = CurTime() + 0.675
                        if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE) then zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE) end
                        zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE, true)
                        zeta:FaceTick(target, 100)
    
                        local attackFunc = function(dir, right)                
                            local tr = util.TraceLine({
                                start = wep:GetPos(),
                                endpos = wep:GetPos() + dir:Forward() * 64,
                                filter = {zeta, wep},
                                mask = MASK_SHOT_HULL
                            })
                            if !IsValid(tr.Entity) then
                                tr = util.TraceHull({
                                    start = wep:GetPos(),
                                    endpos = wep:GetPos() + dir:Forward() * 64,
                                    filter = {zeta, wep},
                                    mins = Vector(-16, -16, -8),
                                    maxs = Vector(16, 16, 8),
                                    mask = MASK_SHOT_HULL
                                })
                            end
    
                            if tr.Hit then
                                local hitEnt = tr.Entity
                                if IsValid(hitEnt) then
                                    local dmg = DamageInfo()
                                    dmg:SetDamage((5 * cvars.Number("mp1_damage_mul")) / GetConVar("zetaplayer_damagedivider"):GetInt())
                                    dmg:SetAttacker(zeta)
                                    dmg:SetInflictor(wep)
                                    dmg:SetDamageType(DMG_CLUB)
                                    dmg:SetDamagePosition(tr.HitPos)
    
                                    dmg:SetDamageForce(dir:Forward() * 5000 + dir:Right() * (2500 * (right and 1 or -1)))
    
                                    if hitEnt:IsNPC() and hitEnt:GetClass() == "npc_manhack" then dmg:SetDamageType(DMG_BLAST) end
                                    hitEnt:DispatchTraceAttack(dmg, tr, tr.HitNormal)
                                    hitEnt:EmitSound(Sound("MP1.MeleeHit"))
                                end
                            end
    
                            wep:EmitSound(Sound("MP1.LeadPipeFire"))
                        end
    
                        timer.Simple(0.5, function() 
                            if !IsValid(zeta) or !IsValid(wep) or zeta.IsDead or zeta.Weapon != "MP1_LEADPIPE" then return end
                            attackFunc((IsValid(target) and ((target:GetCenteroid() + target:GetUp() * math.random(-32, 32) + target:GetRight() * math.random(-16, 16)) - wep:GetPos()):Angle() or zeta:GetAngles()), false) 
                            
                            timer.Simple(0.3375, function()
                                if !IsValid(zeta) or !IsValid(wep) or zeta.IsDead or zeta.Weapon != "MP1_LEADPIPE" then return end
                                if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE) then zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE) end
                                zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE, true)
                                attackFunc((IsValid(target) and ((target:GetCenteroid() + target:GetUp() * math.random(-32, 32) + target:GetRight() * math.random(-16, 16)) - wep:GetPos()):Angle() or zeta:GetAngles()), false) 
                            end)
                        end)            
                    end
                },
            },
    
            MP1_BASEBALLBAT = {
                mdl = "models/MP1/Weapons/w_baseballbat.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = false,
                melee = true,
                clip = 1,
                prettyPrint = "[MP1] Baseball Bat",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_MELEE2,
                    move = ACT_HL2MP_RUN_MELEE2,
                    jump = ACT_HL2MP_JUMP_MELEE2,
                    crouch = ACT_HL2MP_WALK_CROUCH_MELEE2
                },
    
                fireData = {
                    range = 96,
                    preCallback = function(callback, zeta, wep, target, blockData)
                        if CurTime() <= zeta.AttackCooldown then return end
                        zeta.AttackCooldown = CurTime() + 0.86
                        if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2) then zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2) end
                        zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2, true)
                        zeta:FaceTick(target, 100)
    
                        local attackFunc = function(dir, right)                
                            local tr = util.TraceLine({
                                start = wep:GetPos(),
                                endpos = wep:GetPos() + dir:Forward() * 96,
                                filter = {zeta, wep},
                                mask = MASK_SHOT_HULL
                            })
                            if !IsValid(tr.Entity) then
                                tr = util.TraceHull({
                                    start = wep:GetPos(),
                                    endpos = wep:GetPos() + dir:Forward() * 96,
                                    filter = {zeta, wep},
                                    mins = Vector(-16, -16, -8),
                                    maxs = Vector(16, 16, 8),
                                    mask = MASK_SHOT_HULL
                                })
                            end
    
                            if tr.Hit then
                                local hitEnt = tr.Entity
                                if IsValid(hitEnt) then
                                    local dmg = DamageInfo()
                                    dmg:SetDamage((15 * cvars.Number("mp1_damage_mul")) / GetConVar("zetaplayer_damagedivider"):GetInt())
                                    dmg:SetAttacker(zeta)
                                    dmg:SetInflictor(wep)
                                    dmg:SetDamageType(DMG_CLUB)
                                    dmg:SetDamagePosition(tr.HitPos)
    
                                    dmg:SetDamageForce(dir:Forward() * 8000 + dir:Right() * (4000 * (right and 1 or -1)))
    
                                    if hitEnt:IsNPC() and hitEnt:GetClass() == "npc_manhack" then dmg:SetDamageType(DMG_BLAST) end
                                    hitEnt:DispatchTraceAttack(dmg, tr, tr.HitNormal)
                                    hitEnt:EmitSound(Sound("MP1.MeleeHit"))
                                end
                            end
    
                            wep:EmitSound(Sound("MP1.BaseballBatFire"))
                        end
    
                        timer.Simple(0.645, function() 
                            if !IsValid(zeta) or !IsValid(wep) or zeta.IsDead or zeta.Weapon != "MP1_BASEBALLBAT" then return end
                            attackFunc((IsValid(target) and ((target:GetCenteroid() + target:GetUp() * math.random(-32, 32) + target:GetRight() * math.random(-16, 16)) - wep:GetPos()):Angle() or zeta:GetAngles()), false) 
    
                            timer.Simple(0.43, function()
                                if !IsValid(zeta) or !IsValid(wep) or zeta.IsDead or zeta.Weapon != "MP1_BASEBALLBAT" then return end
                                if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2) then zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2) end
                                zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2, true)
                                attackFunc((IsValid(target) and ((target:GetCenteroid() + target:GetUp() * math.random(-32, 32) + target:GetRight() * math.random(-16, 16)) - wep:GetPos()):Angle() or zeta:GetAngles()), false) 
                            end)
                        end)            
                    end
                }
            }
        }
    
        table.Merge(_ZetaWeaponDataTable, MP1_MergeTable)
    end



end




_ZetaRefreshWeaponTable()

-- Due to the order of how lua files are loaded, we have to add this hook to make sure these weapons get added.
-- Autorun files get ran way before weapons do
hook.Add("InitPostEntity","ZetaAddAddonWeapons",function()
    local lightSaber = weapons.Get("weapon_lightsaber")
    if istable(lightSaber) and lightSaber.IsLightsaber then
        local saberWpnData = {
            LIGHTSABER = {
                mdl = "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl",

                offPos = Vector(0, 0, 0),   
                offAng = Angle(90, 0, -90),
                lethal = true,
                range = false,
                melee = true,
                clip = 1,
                prettyPrint = 'Lightsaber',

                anims = {
                    idle = ACT_HL2MP_IDLE_MELEE2,
                    move = ACT_HL2MP_RUN_MELEE2,
                    jump = ACT_HL2MP_JUMP_MELEE2,
                    crouch = ACT_HL2MP_WALK_CROUCH_MELEE2
                },

                onDamageCallback = function(callback, zeta, wep, dmginfo)
                    wep.LS_DamageTaken = wep.LS_DamageTaken + dmginfo:GetDamage()
                    wep.LS_NextDamageTakenTime = CurTime()

                    if wep.LS_Force_Type == 2 and wep.LS_Force_Amount > 0 then
                        local damage = dmginfo:GetDamage() / 5
                        if wep.LS_Force_Amount < damage then
                            wep:LS_SetForce(0)
                            dmginfo:SetDamage((damage - wep.LS_Force_Amount) * 5)
                        else
                            wep:LS_SetForce(wep.LS_Force_Amount - damage)
                            dmginfo:SetDamage(0)
                        end
                    end
                end,

                changeCallback = function(callback, zeta, wep)
                    wep.LS_Force_Amount = 100
                    wep.LS_Force_Type = 1
                    wep.LS_Force_WaitingForFullPower = false
                    wep.LS_Force_NextUseTime = CurTime()

                    wep.LS_DamageTaken = 0
                    wep.LS_NextDamageTakenTime = CurTime()

                    if !wep.LS_WorldModel then
                        local _, k = table.Random( list.Get( "LightsaberModels" ) )
                        wep.LS_WorldModel = (k or "models/sgg/starwars/weapons/w_anakin_ep2_saber_hilt.mdl")
                    end

                    wep:SetModel(wep.LS_WorldModel) 
                    local staffAnim = {
                        idle = ACT_HL2MP_IDLE_KNIFE,
                        move = ACT_HL2MP_RUN_KNIFE,
                        jump = ACT_HL2MP_JUMP_KNIFE,
                        crouch = ACT_HL2MP_WALK_CROUCH_KNIFE
                    }
                    local bladeAnim = {
                        idle = ACT_HL2MP_IDLE_MELEE2,
                        move = ACT_HL2MP_RUN_MELEE2,
                        jump = ACT_HL2MP_JUMP_MELEE2,
                        crouch = ACT_HL2MP_WALK_CROUCH_MELEE2
                    }
                    if wep.LS_WorldModel == "models/weapons/starwars/w_maul_saber_staff_hilt.mdl" or wep:LookupAttachment("blade2") > 0 then 
                        wep.RangeAttackAnimation = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
                        _ZetaWeaponDataTable["LIGHTSABER"].anims = staffAnim
                    else
                        wep.RangeAttackAnimation = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
                        _ZetaWeaponDataTable["LIGHTSABER"].anims = bladeAnim
                    end
                    zeta:StartActivity(zeta:GetActivityWeapon((zeta.IsMoving and "move" or "idle")))

                    wep.LS_LengthAnimation = 0
                    
                    wep.LS_SwitchSound = wep.LS_SwitchSound or "lightsaber/saber_on"..math.random(4)..".wav"
                    wep.LS_HolsterSound = wep.LS_HolsterSound or "lightsaber/saber_off"..math.random(4)..".wav"
                    wep.LS_LoopSound = wep.LS_LoopSound or "lightsaber/saber_loop"..math.random(8)..".wav"
                    wep.LS_SwingSound =  wep.LS_SwingSound or "lightsaber/saber_swing"..math.random(2)..".wav"

                    wep.LS_SoundLoop = CreateSound(zeta, wep.LS_LoopSound)
                    if wep.LS_SoundLoop then 
                        wep.LS_SoundLoop:Play() 
                        wep.LS_SoundLoop:ChangeVolume(0, 0) 
                    end

                    wep.LS_SoundSwing = CreateSound(zeta, wep.LS_SwingSound)
                    if wep.LS_SoundSwing then 
                        wep.LS_SoundSwing:Play() 
                        wep.LS_SoundSwing:ChangeVolume(0, 0) 
                    end

                    wep.LS_SoundHit = CreateSound(zeta, "lightsaber/saber_hit.wav")
                    if wep.LS_SoundHit then 
                        wep.LS_SoundHit:Play() 
                        wep.LS_SoundHit:ChangeVolume(0, 0) 
                    end

                    zeta:CallOnRemove("zeta_ls_stopsounds"..wep:EntIndex(), function()
                        if wep.LS_SoundSwing then wep.LS_SoundSwing:Stop() wep.LS_SoundSwing = nil end
                        if wep.LS_SoundLoop then wep.LS_SoundLoop:Stop() wep.LS_SoundLoop = nil end 
                        if wep.LS_SoundHit then wep.LS_SoundHit:Stop() wep.LS_SoundHit = nil end
                    end)

                    wep.LS_SetForce = wep.LS_SetForce or function(callback, value)
                        if wep.LS_Force_Amount > value then wep.LS_Force_RegenTime = CurTime() + 4 end
                        wep.LS_Force_Amount = math.Clamp(value, 0, 100)
                    end

                    wep.LS_SetNextAttack = wep.LS_SetNextAttack or function(callback, time)
                        if CurTime() > zeta.AttackCooldown then zeta.AttackCooldown = CurTime() + time end
                        wep.LS_Force_NextUseTime = CurTime() + time
                    end

                    wep.LS_DrawHitEffects = wep.LS_DrawHitEffects or function(callback, trace, traceBack)
                        if wep:LS_GetBladeLength() <= 0 then return end

                        if trace.Hit and !trace.StartSolid then
                            rb655_DrawHit(trace)
                        end

                        if traceBack and traceBack.Hit and !traceBack.StartSolid then
                            rb655_DrawHit(traceBack, true)
                        end
                    end

                    wep:EmitSound(wep.LS_SwitchSound, nil, nil, 0.4)

                    zeta:CreateThinkFunction("LS_HolsterSoundHack", 0, 0, function()
                        if zeta.Weapon == "LIGHTSABER" then return end
                        wep:EmitSound(wep.LS_HolsterSound, nil, nil, 0.4)
                        return "stop"
                    end)
                end,

                onThink = function(callback, zeta, wep)
                    if !wep.LS_MaxLength then 
                        wep.LS_MaxLength = math.random(32, 64) 
                        _ZetaWeaponDataTable["LIGHTSABER"].fireData.range = wep.LS_MaxLength + 6
                    end
                    if !wep.LS_MaxWidth then wep.LS_MaxWidth = math.random(2, 4) end
                    if wep.LS_DarkInner == nil then wep.LS_DarkInner = (math.random(8) == 1) end
                    if !wep.LS_LengthAnimation then wep.LS_LengthAnimation = 0 end
                    if !wep.LS_CrystalColor then wep.LS_CrystalColor = zeta:GetNW2Vector('zeta_physcolor', Vector(1, 1, 1)):ToColor() end

                    if !wep.LS_GetBladeLength then
                        wep.LS_GetBladeLength = function()
                            return (wep.LS_LengthAnimation * wep.LS_MaxLength)
                        end
                    end
                    if !wep.LS_GetSaberPosAng then
                        wep.LS_GetSaberPosAng = function(callback, zeta, num, side)
                            num = num or 1

                            if IsValid(zeta) then
                                local bone = zeta:LookupBone("ValveBiped.Bip01_R_Hand")
                                local attachment = wep:LookupAttachment((side and "quillon" or "blade")..num)

                                if attachment and attachment > 0 then
                                    local PosAng = wep:GetAttachment(attachment)
                        
                                    if !bone then
                                        PosAng.Pos = PosAng.Pos + Vector(0, 0, 36)
                                        if IsValid(zeta) and zeta:Crouching() then PosAng.Pos = PosAng.Pos - Vector(0, 0, 18) end
                                        PosAng.Ang.p = 0
                                    end
                        
                                    return PosAng.Pos, PosAng.Ang:Forward()
                                end
                        
                                if bone then
                                    local pos, ang = zeta:GetBonePosition(bone)
                                    if pos == zeta:GetPos() then
                                        local matrix = zeta:GetBoneMatrix(bone)
                                        if (matrix) then
                                            pos = matrix:GetTranslation()
                                            ang = matrix:GetAngles()
                                        end
                                    end
                        
                                    ang:RotateAroundAxis(ang:Forward(), 180)
                                    ang:RotateAroundAxis(ang:Up(), 30)
                                    ang:RotateAroundAxis(ang:Forward(), -5.7)
                                    ang:RotateAroundAxis(ang:Right(), 92)
                        
                                    pos = pos + ang:Up() * -3.3 + ang:Right() * 0.8 + ang:Forward() * 5.6
                                    return pos, ang:Forward()
                                end
                            end
                                            
                            local defAng = wep:GetAngles()
                            defAng.p = 0
                        
                            local defPos = wep:GetPos() + defAng:Right() * 0.6 - defAng:Up() * 0.2 + defAng:Forward() * 0.8
                            defPos = defPos + Vector(0, 0, 36)
                            if IsValid(zeta) then defPos = defPos - Vector(0, 0, 18) end

                            return defPos, -defAng:Forward()
                        end
                    end

                    wep.LS_LengthAnimation = math.Approach(wep.LS_LengthAnimation, 1.0, FrameTime() * 10 )

                    if ( CLIENT ) then
                        if !wep.LS_EffectHookInitialized then
                            wep.LS_EffectHookInitialized = true

                            local entIndex = wep:EntIndex()
                            hook.Add('PreDrawTranslucentRenderables', 'zeta_ls_bladerender'..entIndex, function()
                                if !IsValid(zeta) or zeta.IsDead or !IsValid(wep) or zeta:GetNW2String("zeta_weaponname", "NONE") != "LIGHTSABER" then hook.Remove('PreDrawTranslucentRenderables', 'zeta_ls_bladerender'..entIndex) return end

                                local clr = wep.LS_CrystalColor

                                local bladesFound = false
                                local blades = 0
                                for id, t in pairs( wep:GetAttachments() or {} ) do
                                    if !string.match(t.name, "blade(%d+)") and !string.match(t.name, "quillon(%d+)") then continue end

                                    local bladeNum = string.match( t.name, "blade(%d+)" )
                                    if bladeNum and wep:LookupAttachment("blade"..bladeNum) > 0 then
                                        blades = blades + 1
                                        local pos, dir = wep:LS_GetSaberPosAng(zeta, bladeNum)
                                        rb655_RenderBlade(pos, dir, wep:LS_GetBladeLength(), wep.LS_MaxLength, wep.LS_MaxWidth, clr, wep.LS_DarkInner, entIndex, (zeta:WaterLevel() == 3), false, blades)
                                        bladesFound = true
                                    end

                                    local quillonNum = string.match( t.name, "quillon(%d+)" )
                                    if quillonNum and wep:LookupAttachment("quillon"..quillonNum) > 0 then
                                        blades = blades + 1
                                        local pos, dir =  wep:LS_GetSaberPosAng(zeta, quillonNum, true)
                                        rb655_RenderBlade(pos, dir, wep:LS_GetBladeLength(), wep.LS_MaxLength, wep.LS_MaxWidth, clr, wep.LS_DarkInner, entIndex, (zeta:WaterLevel() == 3), true, blades)
                                    end
                                end

                                if !bladesFound then
                                    local pos, dir = wep:LS_GetSaberPosAng(zeta)
                                    rb655_RenderBlade(pos, dir, wep:LS_GetBladeLength(), wep.LS_MaxLength, wep.LS_MaxWidth, clr, wep.LS_DarkInner, entIndex, (zeta:WaterLevel() == 3))
                                end
                            end)
                        end
                    end

                    if ( SERVER ) then
                        local bladeLength = wep:LS_GetBladeLength()
                        if bladeLength <= 0 then return end
                        local pos, ang = wep:LS_GetSaberPosAng(zeta, 1)
                        local traceFilter = {wep, zeta}

                        local isTrace1Hit = false
                        local trace = util.TraceLine({
                            start = pos,
                            endpos = pos + ang * bladeLength,
                            filter = traceFilter
                        })
                        local traceBack = util.TraceLine({
                            start = pos + ang * bladeLength,
                            endpos = pos,
                            filter = traceFilter
                        })

                        if trace.HitSky or (trace.StartSolid and trace.HitWorld) then trace.Hit = false end
                        if traceBack.HitSky or (traceBack.StartSolid and traceBack.HitWorld) then traceBack.Hit = false end

                        wep:LS_DrawHitEffects(trace, traceBack)
                        isTrace1Hit = (trace.Hit or traceBack.Hit)
                    
                        if trace.Hit then rb655_LS_DoDamage(trace, wep) end
                        if traceBack.Hit and (!IsValid(trace.Entity) or traceBack.Entity != trace.Entity) then
                            rb655_LS_DoDamage(traceBack, wep)
                        end
                    
                        local isTrace2Hit = false
                        if wep:LookupAttachment("blade2") > 0 then
                            local pos2, dir2 = wep:LS_GetSaberPosAng(zeta, 2)
                            local trace2 = util.TraceLine({
                                start = pos2,
                                endpos = pos2 + dir2 * bladeLength,
                                filter = traceFilter,
                            })
                            local traceBack2 = util.TraceLine({
                                start = pos2 + dir2 * bladeLength,
                                endpos = pos2,
                                filter = traceFilter,
                            })
                    
                            if trace2.HitSky or (trace2.StartSolid and trace2.HitWorld) then trace2.Hit = false end
                            if traceBack2.HitSky or (traceBack2.StartSolid and traceBack2.HitWorld) then traceBack2.Hit = false end
                    
                            wep:LS_DrawHitEffects(trace2, traceBack2)
                            isTrace2Hit = trace2.Hit or traceBack2.Hit
                    
                            if traceBack2.Entity == trace2.Entity and IsValid(trace2.Entity) then traceBack2.Hit = false end
                    
                            if trace2.Hit then rb655_LS_DoDamage(trace2, wep) end
                            if traceBack2.Hit then rb655_LS_DoDamage(traceBack2, wep) end
                    
                        end

                        if wep.LS_SoundHit then
                            wep.LS_SoundHit:ChangeVolume(((isTrace1Hit or isTrace2Hit) and 0.1 or 0), 0)
                        end

                        local soundMask = 1
                        if bladeLength < wep.LS_MaxLength then soundMask = 0 end

                        if wep.LS_SoundSwing then
                            if wep.LS_LastAng != ang then
                                wep.LS_LastAng = wep.LS_LastAng or ang
                                wep.LS_SoundSwing:ChangeVolume(math.Clamp(ang:Distance(wep.LS_LastAng) / 2, 0, soundMask), 0)
                            end
                            wep.LS_LastAng = ang
                        end
                    
                        if wep.LS_SoundLoop then
                            pos = pos + ang * bladeLength
                            if wep.LS_LastPos != pos then
                                wep.LS_LastPos = wep.LS_LastPos or pos
                                wep.LS_SoundLoop:ChangeVolume(0.1 + math.Clamp(pos:Distance(wep.LS_LastPos) / 128, 0, soundMask * 0.9), 0)
                            end
                            wep.LS_LastPos = pos
                        end

                        if CurTime() > (wep.LS_Force_RegenTime or 0) then
                            wep:LS_SetForce(math.min(wep.LS_Force_Amount + 0.5, 100))
                        end

                        if (CurTime() - wep.LS_NextDamageTakenTime) > 5.0 then
                            wep.LS_DamageTaken = 0
                        end

                        local ene = zeta:GetEnemy()
                        wep.LS_Force_Type = nil
                        if zeta:Health() < zeta:GetMaxHealth() then
                            wep.LS_Force_Type = 4
                        end

                        if zeta:IsChasingSomeone() and IsValid(ene) and zeta:CanSee(ene) then
                            if (zeta:GetRangeSquaredTo(ene) > (512*512) or math.random(100) == 1) and zeta:GetRangeSquaredTo(ene) <= (1024*1024) and zeta:GetRangeSquaredTo(ene) > (128*128) then
                                wep.LS_Force_Type = 1
                            end
                        end

                        if zeta:GetState() == "panic" or wep.LS_DamageTaken >= (zeta:Health() / 4) and (!zeta:IsChasingSomeone() or IsValid(ene) and zeta:GetRangeSquaredTo(ene) > (wep.LS_MaxLength*wep.LS_MaxLength) and zeta:CanSee(ene)) then
                            wep.LS_Force_Type = 2
                        end

                        if wep.LS_Force_Amount <= 1.0 then
                            wep.LS_Force_WaitingForFullPower = true
                        elseif wep.LS_Force_Amount >= 100 then
                            wep.LS_Force_WaitingForFullPower = false
                        end

                        if !wep.LS_Force_WaitingForFullPower and CurTime() > wep.LS_Force_NextUseTime then
                            local powers = {
                                [1] = function() if wep.LS_Force_Amount >= 10 and zeta.loco:IsOnGround() then
                                    local jumpDir = (ene:GetPos()-zeta:GetPos()):Angle():Forward()
                                    local ceilingCheck = util.TraceHull({
                                        start = zeta:GetPos(),
                                        endpos = zeta:GetPos() + (Vector(0, 0, 128) + jumpDir*256),
                                        filter = {zeta, wep, ene},
                                        mins = zeta:OBBMins(),
                                        maxs = zeta:OBBMaxs()
                                    })
                                    if ceilingCheck.Hit then return end

                                    wep:LS_SetForce(wep.LS_Force_Amount - 10)
                                    wep:LS_SetNextAttack(0.5)
                                    wep:EmitSound("lightsaber/force_leap.wav", nil, nil, 1)

                                    zeta.IsJumping = true 
                                    zeta:SetLastActivity(zeta:GetActivity())
                                    zeta.loco:Jump()
                                    zeta.loco:SetVelocity(Vector(0, 0, 512) + jumpDir*512)
                                end end,
                                [2] = function() if wep.LS_Force_Amount >= 1 then
                                    wep:LS_SetForce(wep.LS_Force_Amount - 0.1)
                                    wep:LS_SetNextAttack(0.3)
                                end end,
                                [4] = function() if wep.LS_Force_Amount >= 1 and zeta:Health() < zeta:GetMaxHealth() then
                                    wep:LS_SetForce(wep.LS_Force_Amount - 1)
                                    wep:LS_SetNextAttack(0.2)

                                    local ed = EffectData()
                                    ed:SetOrigin(zeta:GetPos())
                                    util.Effect("rb655_force_heal", ed, true, true)
                            
                                    zeta:SetHealth(zeta:Health() + 1)
                                    zeta:Extinguish()
                                end end
                            }
                            if !powers[wep.LS_Force_Type] then return end
                            powers[wep.LS_Force_Type]()
                        end
                    end
                end,

                fireData = {
                    range = 48,
                    preCallback = function(callback, zeta, wep, target, blockData)
                        if CurTime() <= zeta.AttackCooldown then return end
                        zeta.AttackCooldown = CurTime() + 0.5
            
                        if zeta:IsPlayingGesture(wep.RangeAttackAnimation) then
                            zeta:RemoveGesture(wep.RangeAttackAnimation)
                        end
                        zeta:AddGesture(wep.RangeAttackAnimation, true)

                        zeta:FaceTick(target, 100)
                    end
                },

                onKillCallback = function(callback, zeta, wep, victim, dmginfo)
                    victim:EmitSound("lightsaber/saber_hit_laser"..math.random(5)..".wav")
                end
            }
        }

        table.Merge(_ZetaWeaponDataTable, saberWpnData)
    end


    local nyanGun = weapons.Get("weapon_nyangun")
    if istable(nyanGun) then
        local nyanGunWpnData = {
            NYANGUN = {
                mdl = 'models/weapons/w_smg1.mdl',
                
                hidewep = false,
                offPos = Vector(7,-2,5),   
                offAng = Angle(-10,0,0),
                lethal = true,
                range = true,
                melee = false,
                clip = 1,
                prettyPrint = 'Nyan Gun',
                keepDistance = 400,

                anims = {
                    idle = ACT_HL2MP_IDLE_SMG1,
                    move = ACT_HL2MP_RUN_SMG1,
                    jump = ACT_HL2MP_JUMP_SMG1,
                    crouch = ACT_HL2MP_WALK_CROUCH_SMG1
                },

                changeCallback = function(callback, zeta, wep)
                    wep.NyanGun_BeatStopPlayingTime = CurTime()
                    wep.NyanGun_BeatSound = CreateSound(zeta, "weapons/nyan/nyan_beat.wav")
                    if wep.NyanGun_BeatSound then wep.NyanGun_BeatSound:Play() end

                    local function KillSounds()
                        if wep.NyanGun_LoopSound then wep.NyanGun_LoopSound:Stop(); wep.NyanGun_LoopSound = nil end
                        if wep.NyanGun_BeatSound then wep.NyanGun_BeatSound:Stop(); wep.NyanGun_BeatSound = nil end 
                    end

                    zeta:CreateThinkFunction("NyanGun_HolsterSoundHack", 0, 0, function()
                        if zeta.Weapon == "NYANGUN" then return end
                        KillSounds()
                        return "stop"
                    end)

                    if !zeta.NyanGun_CallOnRemove then
                        zeta.NyanGun_CallOnRemove = true
                        zeta:CallOnRemove("zeta_nyangun_killsounds"..zeta:EntIndex(), function() KillSounds() end)
                    end
                end,

                onThink = function(callback, zeta, wep)
                    if ( CLIENT ) then return end
                    if !wep.NyanGun_BeatStopPlayingTime or CurTime() < wep.NyanGun_BeatStopPlayingTime then return end
                    if wep.NyanGun_LoopSound then wep.NyanGun_LoopSound:ChangeVolume(0, 0.1) end
                    if wep.NyanGun_BeatSound then wep.NyanGun_BeatSound:ChangeVolume(1, 0.1) end
                end,

                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        local attackChance = math.random(75)
                        if attackChance <= 5 then
                            local ang = (target:GetPos() - zeta:GetPos()):Angle()
                            local bomb = ents.Create("ent_nyan_bomb")
                            if IsValid(bomb) then
                                bomb:SetPos(zeta:GetCenteroid() + ang:Forward()*28 + ang:Right()*24 - ang:Up()*8)
                                bomb:SetAngles(ang)
                                bomb:SetOwner(zeta)
                                bomb:Spawn()
                                bomb:Activate()

                                local phys = bomb:GetPhysicsObject()
                                if IsValid(phys) then
                                    local eneDist = (zeta:GetRangeTo(target) / 4)
                                    phys:Wake() 
                                    phys:AddVelocity(VectorRand(-50, 50) + bomb:GetUp()*eneDist + bomb:GetForward()*1337) 
                                end

                                zeta:CallOnRemove("zeta_nyangun_fixupowner"..bomb:EntIndex(), function()
                                    if !IsValid(bomb) then return end
                                    bomb:SetOwner(Entity(0))
                                end)
                            end

                            wep:EmitSound("weapons/nyan/nya"..math.random(2)..".wav", 100, math.random(60, 80))
                            zeta.AttackCooldown = CurTime() + 1.0

                            blockData.cooldown = true
                            blockData.bullet = true
                        elseif attackChance >= 70 and zeta:GetRangeSquaredTo(target) <= (384*384) then
                            wep:EmitSound("weapons/nyan/nya"..math.random(2)..".wav", 100, math.random(85, 100))
                            zeta.AttackCooldown = CurTime() + 0.5

                            FireBulletsTABLE.Attacker = zeta
                            FireBulletsTABLE.Damage = (4 / GetConVar("zetaplayer_damagedivider"):GetFloat())
                            FireBulletsTABLE.Force = (10 + GetConVar("zetaplayer_forceadd"):GetInt())
                            FireBulletsTABLE.Spread = Vector(0.1 + zeta.Accuracy, 0.1 + zeta.Accuracy,0)
                            FireBulletsTABLE.Num = 6
                            FireBulletsTABLE.TracerName = "rb655_nyan_tracer"
                            FireBulletsTABLE.Dir = (target:GetCenteroid() - wep:GetPos()):GetNormalized()
                            FireBulletsTABLE.Src = wep:GetPos()
                            FireBulletsTABLE.IgnoreEntity = zeta
                            wep:FireBullets(FireBulletsTABLE)

                            blockData.bullet = true
                            blockData.cooldown = true
                        else
                            wep.NyanGun_BeatStopPlayingTime = CurTime() + 0.1

                            if wep.NyanGun_LoopSound then
                                wep.NyanGun_LoopSound:ChangeVolume(1, 0.1)
                            else
                                wep.NyanGun_LoopSound = CreateSound(zeta, "weapons/nyan/nyan_loop.wav")
                                if wep.NyanGun_LoopSound then wep.NyanGun_LoopSound:Play() end
                            end
                            if wep.NyanGun_BeatSound then wep.NyanGun_BeatSound:ChangeVolume(0, 0.1) end
                        end

                        blockData.snd = true
                        blockData.shell = true
                        blockData.clipRemove = true
                        return blockData
                    end,

                    rateMin = 0.1,
                    rateMax = 0.1,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
                    muzzleFlash = 0,
                    snd = "",
                    num = 1,
                    dmgMin = 8,
                    dmgMax = 8,
                    force = 5,
                    ammo = "",
                    spread = 0.01,
                    tracer = "rb655_nyan_tracer"
                },

                reloadData = {
                    anim = ACT_HL2MP_GESTURE_RELOAD_SMG1,
                    time = 1.5,
                    snds = {
                        {0, 'weapons/smg1/smg1_reload.wav'},
                    }
                }
            }
        }

        table.Merge(_ZetaWeaponDataTable, nyanGunWpnData)
    end








    if mp1_lib then

        if (SERVER) then
            util.AddNetworkString("zeta_mp1_getmuzzlename")
            util.AddNetworkString("zeta_mp1_sendmuzzlename")
        else
            net.Receive("zeta_mp1_getmuzzlename", function()
                local wep = net.ReadEntity()
                local valid = (IsValid(wep) and isstring(wep.MuzzleName))
        
                net.Start("zeta_mp1_sendmuzzlename", true)
                    net.WriteBool(valid)
                net.SendToServer()
            end)
        end

        local MP1_FireBulletTable = {
            AmmoType = "mp1_ammo",
            Tracer = 1,
            HullSize = 2
        }
    
    local MP1_MuzzleFlash = function(wep, att)
        net.Start("zeta_mp1_getmuzzlename", true)
            net.WriteEntity(wep)
        net.Broadcast()
        
        net.Receive("zeta_mp1_sendmuzzlename", function()
            local valid = net.ReadBool()
            if !valid or !IsValid(wep) then return end
            local fx = EffectData()
            fx:SetEntity(wep)
            fx:SetAttachment(att or 1)
            util.Effect("mp1_muzzle", fx, true, true)
        end)
    end
    
    local MP1_FireBullet = function(zeta, wep, target, dmg, spread, force, physBulletData, numShots, isShotgun)
        isShotgun = isShotgun or false
        physBulletData = physBulletData or {}
    
        local dmg_mul = cvars.Number("mp1_damage_mul")
        local zetaAccuracy = 30 + (zeta.Accuracy * 50)
        local shotpos = wep:GetPos()
    
        local bulletVel = physBulletData.Velocity or 1968.5
        local targCenteroid = (IsValid(target) and target:GetCenteroid() or wep:GetPos() + zeta:GetForward() * bulletVel)
    
        local aimvec = (targCenteroid - shotpos)
        local targPos = targCenteroid + aimvec:Angle():Up()*math.random(-zetaAccuracy, zetaAccuracy) + aimvec:Angle():Right()*math.random(-zetaAccuracy, zetaAccuracy)
        aimvec = (targPos - shotpos)
    
        if cvars.Bool("mp1_projectiles") then
            if IsValid(target) then
                local targVel = (target.IsZetaPlayer and target.loco:GetVelocity() or target:GetVelocity())
                aimvec = (targPos + targVel * ((targPos:Distance(shotpos) / bulletVel) * math.Rand(0.33, 1.0))) - shotpos
            end
    
            for i = 1, numShots or 1 do 
                local vel = bulletVel
                local proc = (vel / 100)
                local mul = physBulletData.SpeedMultiplier or 5
                local bullet = ents.Create("ent_mp1_bullet")
                local spread = (spread * 5) / (math.random(100) > 75 and 1 or 3)
    
                bullet.data = {
                    model = physBulletData.Model or "models/mp1/Projectiles/tracer_9mm.mdl",
                    vel = (vel + proc *math.random(-mul, mul)) * cvars.Number("mp1_prj_vel_mul"),
                    force = force,
                    damage = (dmg * dmg_mul) / GetConVar("zetaplayer_damagedivider"):GetInt(),
                    spread = spread,
                    bullcam = false,
                }
    
                local ang = aimvec:Angle()
                if isShotgun then
                    if i != numShots then 
                        ang:RotateAroundAxis(ang:Forward(), math.Rand(-spread, spread))
                        ang:RotateAroundAxis(ang:Right(), math.Rand(-spread, spread))
                        ang:RotateAroundAxis(ang:Up(), math.Rand(-spread, spread))
                    end
                else
                    ang:RotateAroundAxis(ang:Forward(), math.Rand(-spread, spread))
                    ang:RotateAroundAxis(ang:Right(), math.Rand(-spread, spread))
                    ang:RotateAroundAxis(ang:Up(), math.Rand(-spread, spread))
                end
                
                bullet:SetOwner(zeta)
                bullet.swep = wep
                bullet.entOwner = zeta
    
                bullet:SetAngles(ang)
                bullet:SetPos(shotpos)
                bullet:Spawn()
                bullet:Activate() 
    
                local phys = bullet:GetPhysicsObject()
                if IsValid(phys) then
                    phys:SetVelocity(ang:Forward() * bullet.data.vel)
                end 
            end
        else
            MP1_FireBulletTable.Attacker = zeta
            MP1_FireBulletTable.Damage = (dmg * dmg_mul) / GetConVar("zetaplayer_damagedivider"):GetInt()
            MP1_FireBulletTable.Force = force or 1
            MP1_FireBulletTable.Dir = aimvec:GetNormalized()
            MP1_FireBulletTable.Src = shotpos
            MP1_FireBulletTable.Callback = function(attacker, trace, damageInfo)
                local hitEnt = trace.Entity
                if IsValid(hitEnt) and IsValid(attacker) then 
                    damageInfo:SetInflictor(attacker)
                    if isShotgun and cvars.Bool("ai_serverragdolls") then 
                        damageInfo:SetDamageForce(damageInfo:GetDamageForce() / 6) 
                    end
                    if hitEnt.IsZetaPlayer or hitEnt:IsNPC() or hitEnt:IsPlayer() then 
                        damageInfo:SetDamageForce(damageInfo:GetDamageForce() + Vector(0, 0, force * 575)) 
                    end
                end
                local impact_sound = mp1_lib.hit_sound[trace.MatType]
                if impact_sound then 
                    if SERVER then sound.Play(impact_sound, trace.HitPos) end
                end
            end
     
            for i = 1, numShots or 1 do 
                local newSpread = (spread * 0.1) / (math.random(100) > 75 and 1 or 3)
                MP1_FireBulletTable.Spread = Vector(newSpread, newSpread, 0)
                wep:FireBullets(MP1_FireBulletTable)
            end
        end
    end
    
        local MP1_MergeTable = {
            MP1_BERETTA = {
                mdl = "models/mp1/Weapons/w_beretta.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 18,
                prettyPrint = "[MP1] Beretta",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_PISTOL,
                    move = ACT_HL2MP_RUN_PISTOL,
                    jump = ACT_HL2MP_JUMP_PISTOL,
                    crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_beretta" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 5, 0.35, 4)
                        
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
    
                        return blockData
                    end, 
    
                    rateMin = 0.25,
                    rateMax = 0.25,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
                    snd = "MP1.BerettaFire"
                },
    
                shellData = {
                    name = "ShellEject",
                    offPos = {
                        forward = 4,
                        right = 7,
                        up = -2
                    },
                    offAng = Angle(-90, 90, 0)
                },
    
                reloadData = {
                    anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
                    time = 1.4,
                    snds = {
                        {0.2, "MP1.BerettaOut"},
                        {0.4, "MP1.BerettaIn"},
                        {1.2, "MP1.BerettaChamber"},
                    }
                }
            },
    
            MP1_DUALBERETTAS = {
                mdl = "models/mp1/Weapons/w_beretta_dual.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 36,
                prettyPrint = "[MP1] Dual Berettas",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_DUEL,
                    move = ACT_HL2MP_RUN_DUEL,
                    jump = ACT_HL2MP_JUMP_DUEL,
                    crouch = ACT_HL2MP_WALK_CROUCH_DUEL
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_beretta" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.snd = true
                        blockData.anim = true
                        blockData.shell = true
                        blockData.bullet = true
                        blockData.muzzle = true
                        blockData.clipRemove = true
                        
                        if wep.ShouldFireLeft == nil then wep.ShouldFireLeft = false end
    
                        local fireBullet = function()
                            local shellAttach = wep:GetAttachment((wep.ShouldFireLeft and 5 or 2))
                            local shellEject = EffectData()
                            shellEject:SetOrigin(shellAttach.Pos)
                            shellEject:SetAngles(shellAttach.Ang)
                            shellEject:SetEntity(wep)
                            util.Effect("ShellEject", shellEject)
    
                            local muzzleAttach = (wep.ShouldFireLeft and 4 or 1)
                            MP1_MuzzleFlash(wep, muzzleAttach)
    
                            MP1_FireBullet(zeta, wep, target, 5, 0.65, 4)
                            zeta.CurrentAmmo = zeta.CurrentAmmo - 1
    
                            EmitSound(Sound("MP1.BerettaFire"), wep:GetPos(), (wep.ShouldFireLeft and zeta:EntIndex() or wep:EntIndex()))
                            wep.ShouldFireLeft = !wep.ShouldFireLeft
                        end
                        
                        fireBullet()
                        timer.Simple(0.08, function()
                            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "MP1_DUALBERETTAS" or zeta.CurrentAmmo <= 0 then return end
                            fireBullet()
                        end)
    
                        return blockData
                    end,
    
                    rateMin = 0.25,
                    rateMax = 0.25
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_DUEL, true)
                        zeta:SetLayerPlaybackRate(layerID, 2.5)
                        return 1.4
                    end,
                    snds = {
                        {0.2, "MP1.BerettaOut"},
                        {0.4, "MP1.BerettaIn"},
                        {1.2, "MP1.BerettaChamber"},
                    }
                }
            },
    
            MP1_DESERTEAGLE = {
                mdl = "models/mp1/Weapons/w_deagle.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 12,
                prettyPrint = "[MP1] Desert Eagle",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_REVOLVER,
                    move = ACT_HL2MP_RUN_REVOLVER,
                    jump = ACT_HL2MP_JUMP_REVOLVER,
                    crouch = ACT_HL2MP_WALK_CROUCH_REVOLVER
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_deagle" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 10, 0.15, 10, {Model="models/mp1/Projectiles/tracer_50cal.mdl"})
                        
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
                        
                        return blockData
                    end, 
    
                    rateMin = 0.333,
                    rateMax = 0.333,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
                    snd = "MP1.DesertEagleFire"
                },
    
                shellData = {
                    name = "ShellEject",
                    offPos = {
                        forward = 4,
                        right = 7,
                        up = -2
                    },
                    offAng = Angle(-90, 90, 0)
                },
    
                reloadData = {
                    anim = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
                    time = 1.7,
                    snds = {
                        {0.2, "MP1.DeagleOut"},
                        {0.7, "MP1.DeagleIn"},
                        {1.4, "MP1.DeagleChamber"},
                    }
                }
            },
    
            MP1_INGRAM = {
                mdl = "models/mp1/Weapons/w_ingram.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 50,
                prettyPrint = "[MP1] Ingram",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_PISTOL,
                    move = ACT_HL2MP_RUN_PISTOL,
                    jump = ACT_HL2MP_JUMP_PISTOL,
                    crouch = ACT_HL2MP_WALK_CROUCH_PISTOL
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_ingram" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 5, 1.2, 3)
                        
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
                        
                        return blockData
                    end, 
    
                    rateMin = 0.03125,
                    rateMax = 0.03125,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
                    snd = "MP1.IngramFire"
                },
    
                shellData = {
                    name = "ShellEject",
                    offPos = {
                        forward = 4,
                        right = 4,
                        up = -2
                    },
                    offAng = Angle(-90, 90, 0)
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_SMG1, true)
                        zeta:SetLayerPlaybackRate(layerID, 1.8)
                        return 1.1
                    end,
                    snds = {
                        {0, "MP1.IngramOut"},
                        {0.4, "MP1.IngramIn"},
                        {0.7, "MP1.IngramChamber"},
                    }
                }
            },
    
            MP1_DUALINGRAMS = {
                mdl = "models/mp1/Weapons/w_ingram_dual.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 100,
                prettyPrint = "[MP1] Dual Ingrams",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_DUEL,
                    move = ACT_HL2MP_RUN_DUEL,
                    jump = ACT_HL2MP_JUMP_DUEL,
                    crouch = ACT_HL2MP_WALK_CROUCH_DUEL
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_ingram" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.anim = true
                        
                        if wep.ShouldFireLeft == nil then wep.ShouldFireLeft = false end
    
                        blockData.shell = true
                        local shellAttach = wep:GetAttachment((wep.ShouldFireLeft and 5 or 2))
                        local shellEject = EffectData()
                        shellEject:SetOrigin(shellAttach.Pos)
                        shellEject:SetAngles(shellAttach.Ang)
                        shellEject:SetEntity(wep)
                        util.Effect("ShellEject", shellEject)
    
                        blockData.muzzle = true
                        local muzzleAttach = (wep.ShouldFireLeft and 4 or 1)
                        MP1_MuzzleFlash(wep, muzzleAttach)
    
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 5, 1.5, 3)
    
                        wep.ShouldFireLeft = !wep.ShouldFireLeft
                        return blockData
                    end,
    
                    rateMin = 0.00625,
                    rateMax = 0.00625,
                    snd = "MP1.IngramFire",
                },
    
                shellData = {
                    name = "ShellEject",
                    offPos = {
                        forward = 3,
                        right = 0,
                        up = 3
                    },
                    offAng = Angle(0, 90, 0)
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_DUEL, true)
                        zeta:SetLayerPlaybackRate(layerID, 2.5)
                        return 1.4
                    end,
                    snds = {
                        {0.2, "MP1.IngramOut"},
                        {0.5, "MP1.IngramIn"},
                        {1.0, "MP1.IngramChamber"},
                    }
                }
            },
    
            MP1_MP5 = {
                mdl = "models/mp1/Weapons/w_mp5.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 30,
                prettyPrint = "[MP1] MP5",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_AR2,
                    move = ACT_HL2MP_RUN_AR2,
                    jump = ACT_HL2MP_JUMP_AR2,
                    crouch = ACT_HL2MP_WALK_CROUCH_AR2
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_mp5" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 5, 0.25, 3)
    
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
    
                        return blockData
                    end, 
    
                    rateMin = 0.11,
                    rateMax = 0.11,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
                    snd = "MP1.MP5Fire"
                },
    
                shellData = {
                    name = "ShellEject",
                    offPos = {
                        forward = 5,
                        right = 8.5,
                        up = -2
                    },
                    offAng = Angle(-90, 90, 0)
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_SMG1, true)
                        zeta:SetLayerPlaybackRate(layerID, 1.5)
                        return 1.4
                    end,
                    snds = {
                        {0.2, "MP1.IngramOut"},
                        {0.7, "MP1.IngramIn"},
                        {0.95, "MP1.MP5Chamber"},
                    }
                }
            },
    
            MP1_SAWEDOFFSHOTGUN = {
                mdl = "models/mp1/Weapons/w_sawedshotgun.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 2,
                prettyPrint = "[MP1] Sawed-Off Shotgun",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_PISTOL,
                    move = ACT_HL2MP_RUN_PISTOL,
                    jump = ACT_HL2MP_JUMP_SHOTGUN,
                    crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_sawed" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.shell = true
                        
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 5, 1.5, 20, {Model="models/mp1/Projectiles/tracer_12ga.mdl"}, 13, true)
    
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
    
                        return blockData
                    end,
    
                    rateMin = 0.5,
                    rateMax = 0.5,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
                    snd = "MP1.SawedShotgunFire"
                },
    
                shellData = {
                    name = "ShotgunShellEject",
                    offPos = {
                        forward = 2,
                        right = 5,
                        up = -4
                    },
                    offAng = Angle(0, 0, 0)
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                        zeta:SetLayerPlaybackRate(layerID, 1.75)
                        timer.Simple(0.35, function()
                            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "MP1_SAWEDOFFSHOTGUN" then return end
                            zeta:CreateShellEject()
                            if zeta.CurrentAmmo == 0 then zeta:CreateShellEject() end
                        end)
                        return 1.3
                    end,
                    snds = {
                        {0.2, "MP1.SawnOffOut"},
                        {0.7, "MP1.SawnOffIn"},
                        {1.1, "MP1.SawnOffChamber"},
                    }
                }
            },
    
            MP1_PUMPSHOTGUN = {
                mdl = "models/mp1/Weapons/w_shotgun.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 7,
                prettyPrint = "[MP1] Pump-Action Shotgun",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_SHOTGUN,
                    move = ACT_HL2MP_RUN_SHOTGUN,
                    jump = ACT_HL2MP_JUMP_SHOTGUN,
                    crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_pump" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.shell = true
                        timer.Simple(0.5, function()
                            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "MP1_PUMPSHOTGUN" then return end
                            zeta:CreateShellEject()
                            wep:EmitSound(Sound("MP1.ShotgunPump"))
                        end)
    
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 5, 0.55, 15, {Model="models/mp1/Projectiles/tracer_12ga.mdl"}, 13, true)
    
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
    
                        return blockData
                    end,
    
                    rateMin = 1,
                    rateMax = 1,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
                    snd = "MP1.PumpShotgunFire"
                },
    
                shellData = {
                    name = "ShotgunShellEject",
                    offPos = {
                        forward = 4,
                        right = 11,
                        up = -1
                    },
                    offAng = Angle(-90, 90, 0)
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        local shellAmount = (7 - zeta.CurrentAmmo)
    
                        local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                        timer.Create("zeta_shotgunreload"..wep:EntIndex(), 0.1, shellAmount, function()
                            if !IsValid(zeta) or !IsValid(wep) then return end
                            if zeta.Weapon != "MP1_PUMPSHOTGUN" then
                                zeta:RemoveGesture(ACT_HL2MP_GESTURE_RELOAD_AR2)
                                timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                                return 
                            end
    
                            local repsLeft = timer.RepsLeft("zeta_shotgunreload"..wep:EntIndex())
                            if (-repsLeft + shellAmount - 1) >= 1 and math.random(2) == 1 and IsValid(zeta:GetEnemy()) and zeta:CanSee(zeta:GetEnemy()) then
                                zeta:RemoveGesture(ACT_HL2MP_GESTURE_RELOAD_AR2)
                                zeta.CurrentAmmo = (-repsLeft + shellAmount - 1)
                                zeta.IsReloading = false
                                timer.Remove("ZetaFinishReloading"..zeta:EntIndex())
                                timer.Remove("zeta_shotgunreload"..wep:EntIndex())
                                return
                            end
    
                            zeta:SetLayerCycle(layerID, 0.2)
                            zeta:SetLayerPlaybackRate(layerID, 1.6)
    
                            wep:EmitSound(Sound("MP1.PumpShotgunReload"))
                            if repsLeft == 0 then
                                timer.Simple(0.4, function()
                                    if !IsValid(zeta) or !IsValid(wep) or !zeta:IsValidLayer(layerID) then return end
                                    zeta:SetLayerCycle(layerID, 0.75)
                                end)
                            elseif repsLeft == (shellAmount - 1) then
                                timer.Adjust("zeta_shotgunreload"..wep:EntIndex(), 0.4, nil, nil)
                            end
                        end)
    
                        return 0.2 + 0.4 * shellAmount
                    end
                }
            },
    
            MP1_COLTCOMMANDO = {
                mdl = "models/mp1/Weapons/w_coltcommando.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 30,
                prettyPrint = "[MP1] Colt Commando",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_AR2,
                    move = ACT_HL2MP_RUN_AR2,
                    jump = ACT_HL2MP_JUMP_AR2,
                    crouch = ACT_HL2MP_WALK_CROUCH_AR2
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_colt" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 10, 0.075, 6, {Model="models/mp1/Projectiles/tracer_50cal.mdl"})
    
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
    
                        return blockData
                    end, 
    
                    rateMin = 0.166,
                    rateMax = 0.166,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
                    snd = "MP1.ColtCommandoFire"
                },
    
                shellData = {
                    name = "RifleShellEject",
                    offPos = {
                        forward = 4,
                        right = 8,
                        up = -1
                    },
                    offAng = Angle(-90, 90, 0)
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                        zeta:SetLayerPlaybackRate(layerID, 1.33)
                        return 1.4
                    end,
                    snds = {
                        {0, "MP1.CommandoOut"},
                        {0.3, "MP1.CommandoIn"},
                        {1.1, "MP1.CommandoChamber"},
                    }
                }
            },
    
            MP1_JACKHAMMER = {
                mdl = "models/mp1/Weapons/w_jackhammer.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 12,
                prettyPrint = "[MP1] Jackhammer",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_AR2,
                    move = ACT_HL2MP_RUN_AR2,
                    jump = ACT_HL2MP_JUMP_AR2,
                    crouch = ACT_HL2MP_WALK_CROUCH_AR2
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_jack" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 5, 1.2, 15, {Model="models/mp1/Projectiles/tracer_12ga.mdl"}, 13, true)
    
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
    
                        return blockData
                    end, 
    
                    rateMin = 0.333,
                    rateMax = 0.333,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
                    snd = "MP1.JackhammerFire"
                },
    
                shellData = {
                    name = "ShotgunShellEject",
                    offPos = {
                        forward = 4,
                        right = 5,
                        up = -3
                    },
                    offAng = Angle(-90, 135, 0)
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                        zeta:SetLayerPlaybackRate(layerID, 1.66)
                        return 1.3
                    end,
                    snds = {
                        {0.25, "MP1.JackhammerOut"},
                        {0.7, "MP1.JackhammerIn"},
                        {1.1, "MP1.JackhammerChamber"},
                    }
                }
            },
    
            MP1_SNIPERRIFLE = {
                mdl = "models/mp1/Weapons/w_sniperrifle.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 5,
                prettyPrint = "[MP1] Sniper Rifle",
                keepDistance = 850,
    
                anims = {
                    idle = ACT_HL2MP_IDLE_RPG,
                    move = ACT_HL2MP_RUN_RPG,
                    jump = ACT_HL2MP_JUMP_RPG,
                    crouch = ACT_HL2MP_WALK_CROUCH_RPG
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_sniper" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.shell = true
                        timer.Simple(0.4, function()
                            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "MP1_SNIPERRIFLE" then return end
                            local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                            zeta:SetLayerCycle(layerID, 0.6)
                            zeta:SetLayerPlaybackRate(layerID, 2)
                            zeta:CreateShellEject()
                            wep:EmitSound(Sound("MP1.SniperBolt"))
                        end)
    
                        blockData.bullet = true
                        MP1_FireBullet(zeta, wep, target, 70, 0, 14, {Model="models/mp1/Projectiles/bullet_762mm.mdl", Velocity=10000, SpeedMultiplier=0})
    
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
    
                        return blockData
                    end,
    
                    rateMin = 1.8,
                    rateMax = 1.8,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG,
                    snd = "MP1.SniperFire"
                },
    
                shellData = {
                    name = "RifleShellEject",
                    offPos = {
                        forward = 4,
                        right = 7,
                        up = -3
                    },
                    offAng = Angle(-90, 135, 0)
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                        zeta:SetLayerPlaybackRate(layerID, 1.5)
                        return 1.4
                    end,
                    snds = {
                        {0.25, "MP1.CommandoOut"},
                        {0.6, "MP1.SniperIn"},
                        {0.9, "MP1.SniperChamber"},
                    }
                }
            },
    
            MP1_M79 = {
                mdl = "models/mp1/Weapons/w_m79.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = true,
                melee = false,
                clip = 1,
                prettyPrint = "[MP1] M79",
                keepDistance = 400,
    
                anims = {
                    idle = ACT_HL2MP_IDLE_SHOTGUN,
                    move = ACT_HL2MP_RUN_SHOTGUN,
                    jump = ACT_HL2MP_JUMP_SHOTGUN,
                    crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN
                },
    
                onThink = function(callback, zeta, wep) if CLIENT then wep.MuzzleName = "mp1_muzzleflash_m79" end end,
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.shell = true
    
                        blockData.bullet = true
                        
                        local zetaAccuracy = 10 + (zeta.Accuracy * 55)
                        local ang = (target:GetPos() - wep:GetPos()):Angle()
                        local targPos = target:GetPos() + ang:Up()*(math.random(-zetaAccuracy, zetaAccuracy) + (wep:GetPos():Distance(target:GetPos()) / 20)) + ang:Right()*math.random(-zetaAccuracy, zetaAccuracy)
                        ang = (targPos - wep:GetPos()):Angle()
    
                        local bullet = ents.Create("ent_mp1_grenade_m79")
    
                        bullet:SetOwner(zeta)
                        bullet.swep = wep
                        bullet.entOwner = zeta
                        bullet.damage = 200 / GetConVar("zetaplayer_damagedivider"):GetInt()
                        bullet.radius = 375
    
                        bullet:SetPos(wep:GetPos())
                        bullet:SetAngles(ang)
                        bullet:Spawn()
                        bullet:Activate() 
    
                        local phys = bullet:GetPhysicsObject()
                        if IsValid(phys) then
                            phys:SetVelocity(ang:Forward() * 2250)
                        end
    
                        blockData.muzzle = true
                        MP1_MuzzleFlash(wep)
    
                        return blockData
                    end,
    
                    rateMin = 1,
                    rateMax = 1,
                    anim = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW,
                    snd = "MP1.M79Fire"
                },
    
                reloadData = {
                    time = function(zeta, wep)
                        timer.Simple(1.5, function()
                            if !IsValid(zeta) or !IsValid(wep) or zeta.Weapon != "MP1_M79" then return end
                            local layerID = zeta:AddGesture(ACT_HL2MP_GESTURE_RELOAD_AR2, true)
                            zeta:SetLayerPlaybackRate(layerID, 1.66)
                        end)
                        return 2.8
                    end,
                    snds = {
                        {1.7, "MP1.M79Out"},
                        {2.0, "MP1.M79In"},
                        {2.5, "MP1.M79Chamber"},
                    }
                }
            },
    
            MP1_COCKTAIL = {
                mdl = "models/MP1/Weapons/w_molotov.mdl",
                hidewep = false,
                offPos = Vector(0, 0, 0),   
                offAng = Angle(0, 0, 0),
                lethal = true,
                range = true,
                melee = false,
                clip = 1,
                prettyPrint = "[MP1] Molotov Cocktail",
                keepDistance = 400,
    
                anims = {
                    idle = ACT_HL2MP_IDLE_GRENADE,
                    move = ACT_HL2MP_RUN_GRENADE,
                    jump = ACT_HL2MP_JUMP_GRENADE,
                    crouch = ACT_HL2MP_WALK_CROUCH_GRENADE
                },
    
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.muzzle = true 
                        blockData.shell = true
                        blockData.snd = true
                        blockData.bullet = true
                        blockData.clipRemove = true
                        blockData.anim = true
    
                        timer.Simple(0.5, function()
                            if !IsValid(zeta) or !IsValid(wep) or !IsValid(target) or zeta.Weapon != "MP1_COCKTAIL" then return end
                            wep:EmitSound(Sound("MP1.ThrowableFire"))
    
                            if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE) then zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE) end
                            zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE, true)
    
                            local zetaAccuracy = 10 + (zeta.Accuracy * 55)
                            local ang = (target:GetPos() - wep:GetPos()):Angle()
                            local targPos = target:GetPos() + ang:Up()*(math.random(-zetaAccuracy, zetaAccuracy) + (wep:GetPos():Distance(target:GetPos())) / 4) + ang:Right()*math.random(-zetaAccuracy, zetaAccuracy)
                            ang = (targPos - wep:GetPos()):Angle()
    
                            local prj = ents.Create("ent_mp1_molotov_thrown")
                            prj:SetPos(wep:GetPos())
                            prj:SetAngles(ang)
                            prj:Spawn()
                            prj:Activate() 
    
                            prj:SetOwner(zeta)
                            prj.swep = wep
                            prj.entOwner = zeta
                            prj.Damage = 135 / GetConVar("zetaplayer_damagedivider"):GetInt()
                            prj.Radius = 175
    
                            local phys = prj:GetPhysicsObject()
                            if IsValid(phys) then
                                phys:SetVelocity(ang:Forward() * 950)
                                phys:SetAngleVelocity(ang:Forward() * 950)
                            end
                        end)
                        return blockData
                    end,
                    
                    rateMin = 2.0,
                    rateMax = 4.0
                }
            }, 
    
            MP1_GRENADE = {
                mdl = "models/MP1/Weapons/w_grenade.mdl",
                hidewep = false,
                offPos = Vector(0, 0, 0),   
                offAng = Angle(0, 0, 0),
                lethal = true,
                range = true,
                melee = false,
                clip = 1,
                prettyPrint = "[MP1] GRENADE",
                keepDistance = 500,
    
                anims = {
                    idle = ACT_HL2MP_IDLE_GRENADE,
                    move = ACT_HL2MP_RUN_GRENADE,
                    jump = ACT_HL2MP_JUMP_GRENADE,
                    crouch = ACT_HL2MP_WALK_CROUCH_GRENADE
                },
    
                fireData = {
                    preCallback = function(callback, zeta, wep, target, blockData)
                        blockData.muzzle = true 
                        blockData.shell = true
                        blockData.snd = true
                        blockData.bullet = true
                        blockData.clipRemove = true
                        blockData.anim = true
    
                        timer.Simple(0.5, function()
                            if !IsValid(zeta) or !IsValid(wep) or !IsValid(target) or zeta.Weapon != "MP1_GRENADE" then return end
                            wep:EmitSound(Sound("MP1.ThrowableFire"))
    
                            if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE) then zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE) end
                            zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE, true)
    
                            local zetaAccuracy = 10 + (zeta.Accuracy * 55)
                            local ang = (target:GetPos() - wep:GetPos()):Angle()
                            local targPos = target:GetPos() + ang:Up()*(math.random(-zetaAccuracy, zetaAccuracy) + (wep:GetPos():Distance(target:GetPos())) / 5) + ang:Right()*math.random(-zetaAccuracy, zetaAccuracy)
                            ang = (targPos - wep:GetPos()):Angle()
    
                            local prj = ents.Create("ent_mp1_grenade_thrown")
                            prj:SetPos(wep:GetPos())
                            prj:SetAngles(ang)
                            prj:Spawn()
                            prj:Activate() 
    
                            prj:SetOwner(zeta)
                            prj.swep = wep
                            prj.entOwner = zeta
                            prj.Damage = 150 / GetConVar("zetaplayer_damagedivider"):GetInt()
                            prj.Radius = 375
    
                            local phys = prj:GetPhysicsObject()
                            if IsValid(phys) then
                                phys:SetVelocity(ang:Forward() * 1000)
                                phys:SetAngleVelocity(ang:Forward() * 1000)
                            end
                        end)
                        return blockData
                    end,
                    
                    rateMin = 3.0,
                    rateMax = 5.0
                }
            }, 
    
            MP1_LEADPIPE = {
                mdl = "models/MP1/Weapons/w_leadpipe.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = false,
                melee = true,
                clip = 1,
                prettyPrint = "[MP1] Lead Pipe",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_MELEE,
                    move = ACT_HL2MP_RUN_MELEE,
                    jump = ACT_HL2MP_JUMP_MELEE,
                    crouch = ACT_HL2MP_WALK_CROUCH_MELEE
                },
    
                fireData = {
                    range = 64,
                    preCallback = function(callback, zeta, wep, target, blockData)
                        if CurTime() <= zeta.AttackCooldown then return end
                        zeta.AttackCooldown = CurTime() + 0.675
                        if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE) then zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE) end
                        zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE, true)
                        zeta:FaceTick(target, 100)
    
                        local attackFunc = function(dir, right)                
                            local tr = util.TraceLine({
                                start = wep:GetPos(),
                                endpos = wep:GetPos() + dir:Forward() * 64,
                                filter = {zeta, wep},
                                mask = MASK_SHOT_HULL
                            })
                            if !IsValid(tr.Entity) then
                                tr = util.TraceHull({
                                    start = wep:GetPos(),
                                    endpos = wep:GetPos() + dir:Forward() * 64,
                                    filter = {zeta, wep},
                                    mins = Vector(-16, -16, -8),
                                    maxs = Vector(16, 16, 8),
                                    mask = MASK_SHOT_HULL
                                })
                            end
    
                            if tr.Hit then
                                local hitEnt = tr.Entity
                                if IsValid(hitEnt) then
                                    local dmg = DamageInfo()
                                    dmg:SetDamage((5 * cvars.Number("mp1_damage_mul")) / GetConVar("zetaplayer_damagedivider"):GetInt())
                                    dmg:SetAttacker(zeta)
                                    dmg:SetInflictor(wep)
                                    dmg:SetDamageType(DMG_CLUB)
                                    dmg:SetDamagePosition(tr.HitPos)
    
                                    dmg:SetDamageForce(dir:Forward() * 5000 + dir:Right() * (2500 * (right and 1 or -1)))
    
                                    if hitEnt:IsNPC() and hitEnt:GetClass() == "npc_manhack" then dmg:SetDamageType(DMG_BLAST) end
                                    hitEnt:DispatchTraceAttack(dmg, tr, tr.HitNormal)
                                    hitEnt:EmitSound(Sound("MP1.MeleeHit"))
                                end
                            end
    
                            wep:EmitSound(Sound("MP1.LeadPipeFire"))
                        end
    
                        timer.Simple(0.5, function() 
                            if !IsValid(zeta) or !IsValid(wep) or zeta.IsDead or zeta.Weapon != "MP1_LEADPIPE" then return end
                            attackFunc((IsValid(target) and ((target:GetCenteroid() + target:GetUp() * math.random(-32, 32) + target:GetRight() * math.random(-16, 16)) - wep:GetPos()):Angle() or zeta:GetAngles()), false) 
                            
                            timer.Simple(0.3375, function()
                                if !IsValid(zeta) or !IsValid(wep) or zeta.IsDead or zeta.Weapon != "MP1_LEADPIPE" then return end
                                if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE) then zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE) end
                                zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE, true)
                                attackFunc((IsValid(target) and ((target:GetCenteroid() + target:GetUp() * math.random(-32, 32) + target:GetRight() * math.random(-16, 16)) - wep:GetPos()):Angle() or zeta:GetAngles()), false) 
                            end)
                        end)            
                    end
                },
            },
    
            MP1_BASEBALLBAT = {
                mdl = "models/MP1/Weapons/w_baseballbat.mdl",
                hidewep = false,
                offPos = Vector(-3, -2, 0),   
                offAng = Angle(-90, 0, 90),
                lethal = true,
                range = false,
                melee = true,
                clip = 1,
                prettyPrint = "[MP1] Baseball Bat",
    
                anims = {
                    idle = ACT_HL2MP_IDLE_MELEE2,
                    move = ACT_HL2MP_RUN_MELEE2,
                    jump = ACT_HL2MP_JUMP_MELEE2,
                    crouch = ACT_HL2MP_WALK_CROUCH_MELEE2
                },
    
                fireData = {
                    range = 96,
                    preCallback = function(callback, zeta, wep, target, blockData)
                        if CurTime() <= zeta.AttackCooldown then return end
                        zeta.AttackCooldown = CurTime() + 0.86
                        if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2) then zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2) end
                        zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2, true)
                        zeta:FaceTick(target, 100)
    
                        local attackFunc = function(dir, right)                
                            local tr = util.TraceLine({
                                start = wep:GetPos(),
                                endpos = wep:GetPos() + dir:Forward() * 96,
                                filter = {zeta, wep},
                                mask = MASK_SHOT_HULL
                            })
                            if !IsValid(tr.Entity) then
                                tr = util.TraceHull({
                                    start = wep:GetPos(),
                                    endpos = wep:GetPos() + dir:Forward() * 96,
                                    filter = {zeta, wep},
                                    mins = Vector(-16, -16, -8),
                                    maxs = Vector(16, 16, 8),
                                    mask = MASK_SHOT_HULL
                                })
                            end
    
                            if tr.Hit then
                                local hitEnt = tr.Entity
                                if IsValid(hitEnt) then
                                    local dmg = DamageInfo()
                                    dmg:SetDamage((15 * cvars.Number("mp1_damage_mul")) / GetConVar("zetaplayer_damagedivider"):GetInt())
                                    dmg:SetAttacker(zeta)
                                    dmg:SetInflictor(wep)
                                    dmg:SetDamageType(DMG_CLUB)
                                    dmg:SetDamagePosition(tr.HitPos)
    
                                    dmg:SetDamageForce(dir:Forward() * 8000 + dir:Right() * (4000 * (right and 1 or -1)))
    
                                    if hitEnt:IsNPC() and hitEnt:GetClass() == "npc_manhack" then dmg:SetDamageType(DMG_BLAST) end
                                    hitEnt:DispatchTraceAttack(dmg, tr, tr.HitNormal)
                                    hitEnt:EmitSound(Sound("MP1.MeleeHit"))
                                end
                            end
    
                            wep:EmitSound(Sound("MP1.BaseballBatFire"))
                        end
    
                        timer.Simple(0.645, function() 
                            if !IsValid(zeta) or !IsValid(wep) or zeta.IsDead or zeta.Weapon != "MP1_BASEBALLBAT" then return end
                            attackFunc((IsValid(target) and ((target:GetCenteroid() + target:GetUp() * math.random(-32, 32) + target:GetRight() * math.random(-16, 16)) - wep:GetPos()):Angle() or zeta:GetAngles()), false) 
    
                            timer.Simple(0.43, function()
                                if !IsValid(zeta) or !IsValid(wep) or zeta.IsDead or zeta.Weapon != "MP1_BASEBALLBAT" then return end
                                if zeta:IsPlayingGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2) then zeta:RemoveGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2) end
                                zeta:AddGesture(ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2, true)
                                attackFunc((IsValid(target) and ((target:GetCenteroid() + target:GetUp() * math.random(-32, 32) + target:GetRight() * math.random(-16, 16)) - wep:GetPos()):Angle() or zeta:GetAngles()), false) 
                            end)
                        end)            
                    end
                }
            }
        }
    
        table.Merge(_ZetaWeaponDataTable, MP1_MergeTable)
    end



end) -- InitPostEntity End