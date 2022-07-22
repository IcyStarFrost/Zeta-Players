
AddCSLuaFile()

if CLIENT then
language.Add("tool.zetaplayercreatortool", "Zeta Creator Tool")

language.Add("tool.zetacreator.name", "Zeta Creator Tool")
language.Add("tool.zetacreator.desc", "Creates a Zeta with specified data")
language.Add("tool.zetacreator.0", "Fire onto a surface to create a Zeta")
end

TOOL.Category = "Zeta Players"
TOOL.Name = "#tool.zetaplayercreatortool"
TOOL.ClientConVar = {
	["zetaname"] = "Based Kleiner",
	["zetamodel"] = "models/player/kleiner.mdl",
	["pfp"] = "",
	["vp"] = "",
	["zetateam"] = "",

	["personalitytype"] = "custom",
	["build"] = "30",
	["combat"] = "30",
	["tool"] = "30",
	["phys"] = "30",
	["disre"] = "30",
	["media"] = "30",
	["friendly"] = "30",
	["voice"] = "30",
	["vehicle"] = "30",
	["text"] = "30",
	["voicepitch"] = "100",
	["strictness"] = "30",

	["physr"] = "77",
	["physg"] = "255",
	["physb"] = "255",

	["mdlr"] = "61",
	["mdlg"] = "87",
	["mdlb"] = "105",
	["spawnweapon"] = "NONE",

	["health"] = "100",
	["armor"] = "0",

	["isadmin"] = "0",
	["isfriend"] = "0",

	["useplaymodelcolor"] = "1",
	["usephysguncolor"] = "1",

	["customidlelinesonly"] = "0",
	["customdeathlinesonly"] = "0",
	["customkilllinesonly"] = "0",
	["customtauntlinesonly"] = "0",
	["customwitnesslinesonly"] = "0",
	["custompaniclinesonly"] = "0",
	["customassistlinesonly"] = "0",
	["customlaughlinesonly"] = "0",
	["customadminscoldlinesonly"] = "0",
	["customsitrespondlinesonly"] = "0",
	["customfallinglinesonly"] = "0",
	["customquestionlinesonly"] = "0",
	["customrespondlinesonly"] = "0",
	["custommediawatchlinesonly"] = "0"

}

local defaultvars = {

	["zetacreator_zetaname"] = "Based Kleiner",
	["zetacreator_zetamodel"] = "models/player/kleiner.mdl",
	["zetacreator_pfp"] = "",
	["zetacreator_vp"] = "",
	["zetacreator_zetateam"] = "",

	["zetacreator_personalitytype"] = "custom",
	["zetacreator_build"] = "30",
	["zetacreator_combat"] = "30",
	["zetacreator_tool"] = "30",
	["zetacreator_phys"] = "30",
	["zetacreator_disre"] = "30",
	["zetacreator_media"] = "30",
	["zetacreator_friendly"] = "30",
	["zetacreator_voice"] = "30",
	["zetacreator_vehicle"] = "30",
	["zetacreator_text"] = "30",
	["zetacreator_voicepitch"] = "100",
	["zetacreator_strictness"] = "30",

	["zetacreator_physr"] = "77",
	["zetacreator_physg"] = "255",
	["zetacreator_physb"] = "255",

	["zetacreator_mdlr"] = "61",
	["zetacreator_mdlg"] = "87",
	["zetacreator_mdlb"] = "105",
	["zetacreator_spawnweapon"] = "NONE",

	["zetacreator_health"] = "100",
	["zetacreator_armor"] = "0",

	["zetacreator_isadmin"] = "0",

	["zetacreator_useplaymodelcolor"] = "1",
	["zetacreator_usephysguncolor"] = "1",

	["zetacreator_customidlelinesonly"] = "0",
	["zetacreator_customdeathlinesonly"] = "0",
	["zetacreator_customkilllinesonly"] = "0",
	["zetacreator_customtauntlinesonly"] = "0",
	["zetacreator_customwitnesslinesonly"] = "0",
	["zetacreator_custompaniclinesonly"] = "0",
	["zetacreator_customassistlinesonly"] = "0",
	["zetacreator_customlaughlinesonly"] = "0",
	["zetacreator_customadminscoldlinesonly"] = "0",
	["zetacreator_customsitrespondlinesonly"] = "0",
	["zetacreator_customfallinglinesonly"] = "0",
	["zetacreator_customquestionlinesonly"] = "0",
	["zetacreator_customrespondlinesonly"] = "0",
	["zetacreator_custommediawatchlinesonly"] = "0"

}


function TOOL:CreatePersonality()
	local personality
	local perstype = "none"
	if self:GetClientInfo("personalitytype") == "custom" then
	personality = {
		build = self:GetClientNumber( "build" ),
		tool = self:GetClientNumber( "tool" ),
		phys = self:GetClientNumber( "phys" ),
		combat = self:GetClientNumber( "combat" ),
		disre = self:GetClientNumber( "disre" ),
		media = self:GetClientNumber( "media" ),
		friendly = self:GetClientNumber( "friendly" ),
		voice = self:GetClientNumber( "voice" ),
		vehicle = self:GetClientNumber( "vehicle" ),
		text = self:GetClientNumber( "text" ),
		voicepitch = self:GetClientNumber( "voicepitch" ),
		strictness = self:GetClientNumber( "strictness" ),
		perstype = "Custom"
	}
	elseif self:GetClientInfo("personalitytype") == 'random' then
		personality = {
			build = math.random(60),
			tool = math.random(60),
			phys = math.random(60),
			combat = math.random(10),
			disre = math.random(60),
			media = math.random(60),
			friendly = math.random(60),
			voice = math.random(60),
			vehicle = math.random(60),
			text = math.random(20),
		}
		perstype = "Random"
	elseif self:GetClientInfo("personalitytype") == 'random++' then
		personality = {
			build = math.random(100),
			tool = math.random(100),
			phys = math.random(100),
			combat = math.random(100),
			disre = math.random(100),
			media = math.random(100),
			friendly = math.random(100),
			voice = math.random(100),
			vehicle = math.random(100),
			text = math.random(100),
		}
		perstype = "Random++"
	elseif self:GetClientInfo("personalitytype") == 'builder' then
		personality = {
			build = 70,
			tool = 70,
			phys = 40,
			combat = 1,
			disre = 10,
			media = 10,
			friendly = 10,
			voice = 30,
			vehicle = 50,
			text = math.random(30),
		}
		perstype = "Builder"
	elseif self:GetClientInfo("personalitytype") == 'berserk' then
		personality = {
			build = 5,
			tool = 5,
			phys = 70,
			combat = 80,
			disre = 70,
			media = 3,
			friendly = 1,
			voice = 30,
			vehicle = 1,
			text = math.random(30),
		}
		perstype = "Aggressor"
	end

	return personality,perstype
end


function TOOL:LeftClick( tr )
    
	local zeta = ents.Create("npc_zetaplayer")
	zeta:SetPos(tr.HitPos)

	


	local pfp = self:GetClientInfo( "pfp" ) != "" and "../data/zetaplayerdata/custom_avatars/"..self:GetClientInfo( "pfp" ) or nil
	local vp = self:GetClientInfo( "vp" ) != "" and self:GetClientInfo( "vp" ) or nil
	local model = self:GetClientInfo( "zetamodel" ) != "" and self:GetClientInfo( "zetamodel" ) or nil
	local name = self:GetClientInfo( "zetaname" ) != "" and self:GetClientInfo( "zetaname" ) or nil
	local team_ = self:GetClientInfo( "zetateam" ) != "" and self:GetClientInfo( "zetateam" ) or nil
	local personality,pertype = self:CreatePersonality()

	ZetaPlayer_ApplySpawnOverridedata(zeta,name,model,personality,pfp,vp,team_)
    
	zeta.IsAdmin = tobool(self:GetClientNumber( "isadmin" ))
    zeta.ShouldSpawnAdmin = tobool(self:GetClientNumber( "isadmin" ))
	zeta.CustomSpawnWeapon = self:GetClientInfo( "spawnweapon" )
	zeta.Personality = pertype



	














	zeta.UseCustomIdle = tobool(self:GetClientNumber( "customidlelinesonly" ))
	zeta.UseCustomDeath = tobool(self:GetClientNumber( "customdeathlinesonly" ))
	zeta.UseCustomKill = tobool(self:GetClientNumber( "customkilllinesonly" ))
	zeta.UseCustomTaunt = tobool(self:GetClientNumber( "customtauntlinesonly" ))
	zeta.UseCustomPanic = tobool(self:GetClientNumber( "custompaniclinesonly" ))
	zeta.UseCustomAssist = tobool(self:GetClientNumber( "customassistlinesonly" ))
	zeta.UseCustomLaugh = tobool(self:GetClientNumber( "customlaughlinesonly" ))
	zeta.UseCustomWitness = tobool(self:GetClientNumber( "customwitnesslinesonly" ))
	zeta.UseCustomAdminScold = tobool(self:GetClientNumber( "customadminscoldlinesonly" ))
	zeta.UseCustomFalling = tobool(self:GetClientNumber( "customfallinglinesonly" ))
	zeta.UseCustomSitRespond = tobool(self:GetClientNumber( "customsitrespondlinesonly" ))
	zeta.UseCustomQuestion = tobool(self:GetClientNumber( "customquestionlinesonly" ))
	zeta.UseCustomConRespond = tobool(self:GetClientNumber( "customrespondlinesonly" ))
	zeta.UseCustomMediaWatch = tobool(self:GetClientNumber( "custommediawatchlinesonly" ))


	if tobool(self:GetClientNumber( "usephysguncolor" )) then
    	zeta:SetNW2Vector('zeta_coloroverride', Vector(self:GetClientNumber( "physr" )/255,self:GetClientNumber( "physg" )/255,self:GetClientNumber( "physb" )/255))
	end
	if tobool(self:GetClientNumber( "useplaymodelcolor" )) then
    	zeta:SetNW2Vector('zeta_playercoloroverride',Vector(self:GetClientNumber( "mdlr" )/255,self:GetClientNumber( "mdlg" )/255,self:GetClientNumber( "mdlb" )/255))
	end
	zeta:Spawn()

	undo.Create( 'Zeta Player' )
		undo.AddEntity(zeta)
		undo.SetPlayer(self:GetOwner())
		undo.SetCustomUndoText( 'Undone Zeta Player ('..self:GetClientInfo( "zetaname" )..')' )
	undo.Finish('Zeta Player ('..self:GetClientInfo( "zetaname" )..')')

	timer.Simple(0,function()
		zeta:SetHealth(self:GetClientNumber( "health",100 ))
		zeta:SetMaxHealth(self:GetClientNumber( "health" ))

		zeta.MaxArmor = math.max(100,self:GetClientNumber( "armor" ))
        zeta.CurrentArmor = self:GetClientNumber( "armor" )

		if tobool(self:GetClientNumber( "isfriend" )) then
			zeta:AddFriend(self:GetOwner(),true)
		end
	end)

    return true
end



function TOOL.BuildCPanel(panel)

	panel:Help('The settings the Zeta should use when created by this tool')

	panel:Help('-- Preset Box --')


	local convars = {}

    for k, v in pairs(defaultvars) do
        convars[#convars + 1] = k
    end

	panel:AddControl("ComboBox", {
		Options = {
			["Based Kleiner"] = defaultvars
		},
		CVars = convars,
		Label = "",
		MenuButton = "1",
		Folder = "zetacreatordata"
	})
	panel:Help('--  --')

            panel:TextEntry( 'Zeta Name', 'zetacreator_zetaname' )
            panel:ControlHelp('The Name the created Zeta should spawn with. Leave blank for random')


            local gmodWeps = {}
        local cssWeps = {}
        local tf2Weps = {}
        local hl1Weps = {}
        local dodWeps = {}
        for k, v in pairs(zetaWeaponConfigTable) do            
            if k == 'CSS' then
                cssWeps = v
            elseif k == 'TF2' then
                tf2Weps = v
            elseif k == "HL1" then
                hl1Weps = v
            elseif k == "DOD" then
                dodWeps = v
            elseif k == "L4D" then
                l4dWeps = v
            else
                gmodWeps = v
            end
        end

            local voicepack = panel:ComboBox('Voice Pack','zetacreator_vp')
            panel:ControlHelp("The Voice Pack the created Zeta should spawn with.")

            local _,folders = file.Find("sourceengine/sound/zetaplayer/custom_vo/*","BASE_PATH","namedesc")
            local _,addonfolders = file.Find("sound/zetaplayer/custom_vo/*","GAME","namedesc")
    
            table.Merge(folders,addonfolders)
            
            voicepack:AddChoice("None","none",true)

            
            for _,v in ipairs(folders) do
                local IsVP = string.find(v,"vp_")
                if isnumber(IsVP) then
                    local name = string.Replace(v,"vp_","")
                    voicepack:AddChoice(name,v)
                end
            end

            

            local box = panel:ComboBox('Spawn weapon','zetacreator_spawnweapon')
            box:SetSortItems(false)
            
            box:AddChoice('None/Holster', 'NONE')
            box:AddChoice("Random Weapon","RND")
            box:AddChoice("Random Lethal Weapon","RNDLETHAL")
            
            box:AddSpacer()
            
            box:AddChoice('[HL2] Crowbar', 'CROWBAR')
            box:AddChoice('[HL2] Stunstick', 'STUNSTICK')
            box:AddChoice('[HL2] Pistol', 'PISTOL')
            box:AddChoice('[HL2] 357. Revolver', 'REVOLVER')
            box:AddChoice('[HL2] SMG1', 'SMG')
            box:AddChoice('[HL2] AR2', 'AR2')
            box:AddChoice('[HL2] Shotgun', 'SHOTGUN')
            box:AddChoice('[HL2] Crossbow','CROSSBOW')
            box:AddChoice('[HL2] RPG', 'RPG')
            box:AddChoice("[HL2] Grenade","GRENADE")
            
            box:AddSpacer()
            
            box:AddChoice('[Misc] Fists','FIST')
            box:AddChoice('[Misc] Physics Gun', 'PHYSGUN')
            box:AddChoice('[Misc] Toolgun', 'TOOLGUN')
            box:AddChoice('[Misc] Camera','CAMERA')
            box:AddChoice("[Misc] Junk Launcher","JPG")
            if #gmodWeps > 0 then
                for i = 1, #gmodWeps do
                    box:AddChoice('[Misc] '..gmodWeps[i][1], gmodWeps[i][2])
                end
            end
            
            box:AddSpacer()
            
            box:AddChoice('[CS:S] Knife','KNIFE')
            box:AddChoice("[CS:S] Desert Eagle","DEAGLE")
            box:AddChoice("[CS:S] MP5","MP5")
            box:AddChoice('[CS:S] M4A1','M4A1')
            box:AddChoice("[CS:S] AK47","AK47")
            box:AddChoice('[CS:S] AWP','AWP')
            box:AddChoice("[CS:S] M249 Machine Gun","MACHINEGUN")
            if #cssWeps > 0 then
                for i = 1, #cssWeps do
                    box:AddChoice('[CS:S] '..cssWeps[i][1], cssWeps[i][2])
                end
            end
            
            box:AddSpacer()
            
            box:AddChoice('[TF2] Wrench','WRENCH')
            box:AddChoice("[TF2] Pistol","TF2PISTOL")
            box:AddChoice("[TF2] Shotgun","TF2SHOTGUN")
            box:AddChoice('[TF2] Scatter Gun','SCATTERGUN')
            box:AddChoice("[TF2] Sniper Rifle","TF2SNIPER")
            if #tf2Weps > 0 then
                for i = 1, #tf2Weps do
                    local wepStr = string.Replace(tf2Weps[i][1], 'TF2 ', '')
                    box:AddChoice('[TF2] '..wepStr, tf2Weps[i][2])
                end
            end
            
            box:AddSpacer()
            
            if #hl1Weps > 0 then
                for i = 1, #hl1Weps do
                    local wepStr = string.Replace(hl1Weps[i][1], 'HL1 ', '')
                    box:AddChoice('[HL1] '..wepStr, hl1Weps[i][2])
                end
            
                box:AddSpacer()
            end
            
            if #dodWeps > 0 then
                for i = 1, #dodWeps do
                    box:AddChoice('[DOD:S] '..dodWeps[i][1], dodWeps[i][2])
                end
            
                box:AddSpacer()
            end
            
            if #l4dWeps > 0 then
                for i = 1, #l4dWeps do
                    box:AddChoice(l4dWeps[i][1], l4dWeps[i][2])
                end
            
                box:AddSpacer()
            end

            panel:TextEntry("Model","zetacreator_zetamodel")
            panel:ControlHelp("The model the created zeta should use")



            panel:NumSlider("Spawning Health", "zetacreator_health", 1, 10000, 0)
            panel:ControlHelp("The amount of health the zeta should spawn with")

            panel:NumSlider("Spawning Armor", "zetacreator_armor", 0, 10000, 0)
            panel:ControlHelp("The amount of armor the zeta should spawn with")

            

			panel:CheckBox('Spawn as Friend','zetacreator_isfriend')
            panel:ControlHelp("If the zeta should spawn as your friend. Bypasses max friend count")

            panel:CheckBox('Is Admin','zetacreator_isadmin')
            panel:ControlHelp("If the zeta should be a admin")

            panel:TextEntry("Profile Picture","zetacreator_pfp")
            panel:ControlHelp("The profile picture the zeta should have. Provide the custom profile picture file name and you must include the file extension Example: johnfreeman.png\nLeave blank for random")

            panel:CheckBox('Custom Idle Lines only','zetacreator_customidlelinesonly')
            panel:ControlHelp("If the zeta should only use your custom Idle lines")

            panel:CheckBox('Custom Death Lines only','zetacreator_customdeathlinesonly')
            panel:ControlHelp("If the zeta should only use your custom Death lines")

            panel:CheckBox('Custom Kill Lines only','zetacreator_customkilllinesonly')
            panel:ControlHelp("If the zeta should only use your custom Kill lines")

            panel:CheckBox('Custom Taunt Lines only','zetacreator_customtauntlinesonly')
            panel:ControlHelp("If the zeta should only use your custom Taunt lines")

            panel:CheckBox('Custom Witness Lines only','zetacreator_customwitnesslinesonly')
            panel:ControlHelp("If the zeta should only use your custom Witness lines")

            panel:CheckBox('Custom Panic Lines only','zetacreator_custompaniclinesonly')
            panel:ControlHelp("If the zeta should only use your custom Panic lines")

            panel:CheckBox('Custom Assist Lines only','zetacreator_customassistlinesonly')
            panel:ControlHelp("If the zeta should only use your custom Assist lines")

            panel:CheckBox('Custom Laughing Lines only','zetacreator_customlaughlinesonly')
            panel:ControlHelp("If the zeta should only use your custom Laughing lines")

            panel:CheckBox('Custom Admin Scolding Lines only','zetacreator_customadminscoldlinesonly')
            panel:ControlHelp("If the zeta should only use your custom Admin Scolding lines")
            
            panel:CheckBox('Custom Sit Response Lines only','zetacreator_customsitrespondlinesonly')
            panel:ControlHelp("If the zeta should only use your custom Sit Response lines")

            panel:CheckBox('Custom Falling Lines only','zetacreator_customfallinglinesonly')
            panel:ControlHelp("If the zeta should only use your custom Falling lines")

            panel:CheckBox('Custom Convo Question Lines only','zetacreator_customquestionlinesonly')
            panel:ControlHelp("If your Custom Convo Question Lines should only be used. These are used for when two Zetas talk to each other")

            panel:CheckBox('Custom Convo Respond Lines only','zetacreator_customrespondlinesonly')
            panel:ControlHelp("If your Custom Convo Respond Lines should only be used. These are used for when two Zetas talk to each other")

            panel:CheckBox('Custom Media Watch Lines only','zetacreator_custommediawatchlinesonly')
            panel:ControlHelp("If the zeta should only use your custom media watch lines")
            



            
            
            
            
            


            panel:Help("Zeta Playermodel Color")
            panel:CheckBox('Use Custom Playermodel Color','zetacreator_useplaymodelcolor')
            panel:ControlHelp("If the zeta should use the color you provide here")
            local colorpanel = vgui.Create('DColorMixer')
            panel:AddItem(colorpanel)
            colorpanel:SetParent(panel)
            colorpanel:SetConVarR('zetacreator_mdlr')
            colorpanel:SetConVarG('zetacreator_mdlg')
            colorpanel:SetConVarB('zetacreator_mdlb')
			
            panel:Help("Zeta Physgun Color")
            panel:CheckBox('Use Custom Physics Gun Color','zetacreator_usephysguncolor')
            panel:ControlHelp("If the zeta should use the color you provide here")
            local colorpanel = vgui.Create('DColorMixer')
            panel:AddItem(colorpanel)
            colorpanel:SetParent(panel)
            colorpanel:SetConVarR('zetacreator_physr')
            colorpanel:SetConVarG('zetacreator_physg')
            colorpanel:SetConVarB('zetacreator_physb')
            

            panel:Help('--- Zeta Personality ---')
                
            local box = panel:ComboBox('Personality Type','zetacreator_personalitytype')
            box:AddChoice('Random', 'random')
            box:AddChoice('Builder', 'builder')
            box:AddChoice('Aggressor', 'berserk')
            box:AddChoice('Custom', 'custom')
            box:AddChoice('Random +', 'random++')

            panel:Help('Builder Type is more focused on building than fighting but is generally friendly.\n Aggressor is more focused on attacking.\n Custom enables the custom sliders below.\n Random is a limited random generated personality.\n Random + is purely random generated personality')

            panel:Help('You MUST have the personality type set to Custom for these sliders to apply! 0 will never be picked. 100 will have the highest chance of being picked')
            panel:NumSlider('Build Chance','zetacreator_build',0,100,0)
            panel:NumSlider('Tool Chance','zetacreator_tool',0,100,0)
            panel:NumSlider('Physgun Chance','zetacreator_phys',0,100,0)
            panel:NumSlider('Combat Chance','zetacreator_combat',0,100,0)
            panel:NumSlider('Disrespect Chance','zetacreator_disre',0,100,0)
            panel:NumSlider('Watch Media Player Chance','zetacreator_media',0,100,0)
            panel:NumSlider('Friendly Chance','zetacreator_friendly',0,100,0)
            panel:NumSlider('Voice Chance','zetacreator_voice',0,100,0)
            panel:NumSlider('Text Chance','zetacreator_text',0,100,0)
            panel:NumSlider('Vehicle Chance','zetacreator_vehicle',0,100,0)
            panel:ControlHelp('Friendly Chance is the decision type where a Zeta can do a friendly action such as healing other Zetas/Players. Voice Chance is the chance they will speak after every 5 seconds. Vehicle Chance is the chance where a zeta will find a vehicle or spawn a vehicle and drive it. Typically you want this at a low chance such as under 10.')
                
end