AddCSLuaFile()

if ( CLIENT ) then

    
local function AddZetaOptions()
    
    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_mapwideoption', 'Map Wide Spawning Options', "", "", function(panel) 
            
            panel:CheckBox('Enable Map Wide Spawning','zetaplayer_mapwidespawning')
            panel:ControlHelp('If Zetas should begin to naturally spawn any where within the map')
            panel:NumSlider( 'Max Natural Zetas', 'zetaplayer_mapwidespawningzetaamount', 1, 300,0 )
            panel:NumSlider( 'Natural Spawn Rate', 'zetaplayer_naturalspawnrate', 0.1, 120,1 )
            panel:ControlHelp('The rate in seconds for natural Zetas to spawn')
         
            panel:CheckBox('Random Spawn Rate','zetaplayer_mapwidespawningrandom')
            panel:ControlHelp('If Natural Spawn Rate should act as the max value for a random spawn rate')

            panel:CheckBox("Time Based MWS","zetaplayer_timebasedmws")
            panel:ControlHelp('If Map Wide Spawning should dynamically change natural zeta spawn rate and amount depending on your time. This is best used with Respawning Natural Zetas\n\nMax Natural Zetas option will act as the limit of zetas MWS can possibly spawn')

            panel:CheckBox('Spawn at Player Spawn Points','zetaplayer_mapwidespawninguseplayerstart')
            panel:ControlHelp('If natural Zetas should spawn a Player Spawn Points. Also known as info_player_start entities')

            panel:CheckBox('Respawning Natural Zetas','zetaplayer_mwsspawnrespawningzetas')
            panel:ControlHelp('If Natural Zetas should be Respawning Zetas. Enable disconnecting in General Zeta Settings for the best experience')

            panel:CheckBox('Enable Mingebag Variant','zetaplayer_mapwidemingebag')
            panel:ControlHelp('If Natural Zetas can become a mingebag if their chance succeeds')

            panel:NumSlider("Mingebag Chance", "zetaplayer_mapwidemingebagspawnchance", 1,100,0)
            panel:ControlHelp('The chance a natural Zeta will be a Mingebag')

            panel:NumSlider("Spawning Armor","zetaplayer_naturalzetaarmor",0,10000,0)
            panel:ControlHelp('The amount of armor Natural Zetas will spawn with')

            

            

            local gmodWeps = {}
            local cssWeps = {}
            local tf2Weps = {}
            local hl1Weps = {}
            local dodWeps = {}
            local customweps = {}
            local customAddonweps = {}
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
                elseif k == "CUSTOM" then
                    customweps = v
                elseif k == "ADDON" then
                    customAddonweps = v
                elseif k == "MP1" then
                    mp1Weps = v
                else
                    gmodWeps = v
                end
            end

            local box = panel:ComboBox('Spawn weapon','zetaplayer_naturalspawnweapon')
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

            if #customAddonweps > 0 then
                for i = 1, #customAddonweps do
                    box:AddChoice('[Addon] '..customAddonweps[i][1], customAddonweps[i][2])
                end
            end
            
            box:AddSpacer()

            if #customweps > 0 then
                for i = 1, #customweps do
                    box:AddChoice('[Custom] '..customweps[i][1], customweps[i][2])
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

            if #mp1Weps > 0 then
                for i = 1, #mp1Weps do
                    box:AddChoice(mp1Weps[i][1], mp1Weps[i][2])
                end
            
                box:AddSpacer()
            end

            panel:ControlHelp('The Weapon Natural Zetas should spawn with')

            panel:NumSlider("Spawning Health","zetaplayer_naturalzetahealth",1,10000,0)
            panel:ControlHelp('The amount of health Natural Zetas will spawn with')


            panel:Help('------- Natural Zeta Personalities -------')
    
            local box = panel:ComboBox('Personality Type','zetaplayer_naturalpersonalitytype')
            box:AddChoice('Random', 'random')
            box:AddChoice('Builder', 'builder')
            box:AddChoice('Aggressor', 'berserk')
            box:AddChoice('Custom', 'custom')
            box:AddChoice('Random +', 'random++')

            panel:Help('Builder Type is more focused on building than fighting but is generally friendly.\n Aggressor is more focused on attacking.\n Custom enables the custom sliders below.\n Random is a limited random generated personality.\n Random + is purely random generated personality')

            
            panel:Help('You MUST have the personality type set to Custom for these sliders to apply! 0 will never be picked. 100 will have the highest chance of being picked')
            panel:NumSlider('Build Chance','zetaplayer_naturalbuildchance',0,100,0)
            panel:NumSlider('Tool Chance','zetaplayer_naturaltoolchance',0,100,0)
            panel:NumSlider('Physgun Chance','zetaplayer_naturalphysgunchance',0,100,0)
            panel:NumSlider('Combat Chance','zetaplayer_naturalcombatchance',0,100,0)
            panel:NumSlider('Disrespect Chance','zetaplayer_naturaldisrespectchance',0,100,0)
            panel:NumSlider('Watch Media Player Chance','zetaplayer_naturalwatchmediaplayerchance',0,100,0)
            panel:NumSlider('Friendly Chance','zetaplayer_naturalfriendlychance',0,100,0)
            panel:NumSlider('Voice Chance','zetaplayer_naturalvoicechance',0,100,0)
            panel:NumSlider('Text Chance','zetaplayer_naturaltextchance',0,100,0)
            panel:NumSlider('Vehicle Chance','zetaplayer_naturalvehiclechance',0,100,0)
            panel:ControlHelp('Friendly Chance is the decision type where a Zeta can do a friendly action such as healing other Zetas/Players. Voice Chance is the chance they will speak after every 5 seconds. Vehicle Chance is the chance where a zeta will find a vehicle or spawn a vehicle and drive it. Typically you want this at a low chance such as under 10.')
                
                
            
            
            
    end)

    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_teams', 'Team System', "", "", function(panel) 
        panel:Help('This is where you can configure anything relating to the Team System')

            panel:CheckBox('Enable Team System','zetaplayer_useteamsystem')
            panel:ControlHelp('If Zetas should join a team if able')

            panel:NumSlider( 'Each Team Limit', 'zetaplayer_eachteammemberlimit', 2, 100,0 )
            panel:ControlHelp('How many members a team can hold. You count as a member')

            panel:CheckBox('Draw Team Halo','zetaplayer_drawteamhalo')
            panel:ControlHelp('If your team should have halos around them')

            panel:CheckBox('Draw Halo Through world','zetaplayer_drawteamhalothroughworld')
            panel:ControlHelp("If the Halo should draw through the world allowing you to see your teams's position. NOTE: Due to PVS (Potential Visibility Set) unloading, the Halo position may not be accurate when a team mate runs out of your PVS ")
            
            panel:CheckBox('Draw Team Name','zetaplayer_drawteamname')
            panel:ControlHelp('If your team should draw your team name')

            panel:CheckBox('Teams Always Attack','zetaplayer_teamsalwaysattack')
            panel:ControlHelp('If Teams should always attack each other on sight')

            panel:CheckBox('Player Spawn at Team Points','zetaplayer_spawnatteamspawns')
            panel:ControlHelp("If You should spawn at your team's spawn points")

            panel:CheckBox('Enable Friendly Fire','zetaplayer_enablefriendlyfire')
            panel:ControlHelp("If teams can deal damage to their teammates")

            panel:CheckBox('Stick near Team','zetaplayer_teamsstickneareachother')
            panel:ControlHelp("If teams should stick near each other")

            panel:NumSlider("Stick Near Distance", "zetaplayer_teamsstickneardistance", 100, 15000, 0)
            panel:ControlHelp("How close a team should be together")

            

            panel:Help('\n\n\n\n---- King of the Hill / Domination Settings ----')

            panel:CheckBox('Show KOTH Points on HUD','zetaplayer_showkothpointsonhud')
            panel:ControlHelp("If KOTH Markers should show on your HUD")
            
            panel:NumSlider("KOTH Capture Rate","zetaplayer_kothcapturerate",0.01,5,2)
            panel:ControlHelp("The capturing rate of KOTH points")
            
            panel:NumSlider("KOTH Time Limit","zetaplayer_kothmodetime",10,3600,0)
            panel:ControlHelp("The time limit in seconds before a game ends")

            panel:TextEntry("10 Seconds","zetaplayer_10secondcountdownsound")
            panel:ControlHelp("The sound that will play when the timer reaches 10 seconds")

            panel:TextEntry("30 Seconds","zetaplayer_koth30secondssound")
            panel:ControlHelp("The sound that will play when the timer reaches 30 seconds")

            panel:TextEntry("Loss Sound","zetaplayer_kothgameover")
            panel:ControlHelp("The sound that will play when your team loses")

            panel:TextEntry("Victory Sound","zetaplayer_kothvictory")
            panel:ControlHelp("The sound that will play when your team wins")
            

            panel:TextEntry("Game Start Sound","zetaplayer_kothgamestart")
            panel:ControlHelp("The sound that will play when the game is started")
            

            panel:Button("Start KOTH game","zetaplayer_beginkothgame")
            panel:Button("End KOTH game","zetaplayer_endkothgame")
            
            panel:Help('-----------------------------------------\n\n\n\n')

            panel:Help('\n\n\n\n---- Capture The Flag Settings ----')

            panel:TextEntry("Enemy Flag Stolen","zetaplayer_ctfenemyflagstolensound")
            panel:ControlHelp("The sound that will play when a enemy flag is stolen")

            panel:TextEntry("Enemy Flag Captured","zetaplayer_ctfenemyflagcapturesound")
            panel:ControlHelp("The sound that will play when a enemy flag is captured")

            panel:TextEntry("Flag Returned","zetaplayer_ctfflagreturn")
            panel:ControlHelp("The sound that will play when a flag returns to its zone")
            
            panel:TextEntry("Flag dropped","zetaplayer_ctfflagdropped")
            panel:ControlHelp("The sound that will play when a flag is dropped")     
            
            panel:TextEntry("Your Flag Captured","zetaplayer_ctfourflagcapturesound")
            panel:ControlHelp("The sound that will play when your team's flag is captured")                 

            panel:TextEntry("Your Flag Stolen","zetaplayer_ctfourflagstolensound")
            panel:ControlHelp("The sound that will play when your team's flag is stolen")  

            panel:TextEntry("30 Seconds","zetaplayer_ctf30secondssound")
            panel:ControlHelp("The sound that will play when the timer reaches 30 seconds")  

            panel:TextEntry("10 Seconds","zetaplayer_ctf10secondssound")
            panel:ControlHelp("The sound that will play when the timer reaches 10 seconds")
            
            panel:TextEntry("Game Start Sound","zetaplayer_ctfgamestartsound")
            panel:ControlHelp("The sound that will play when the game starts")
            
            panel:TextEntry("Victory Sound","zetaplayer_ctfvictorysound")
            panel:ControlHelp("The sound that will play when your team wins")
            
            panel:TextEntry("Loss Sound","zetaplayer_ctflosssound")
            panel:ControlHelp("The sound that will play when your team loses")




            panel:Help("\n\n")



            panel:NumSlider("Capture Limit","zetaplayer_ctfcapturelimit",1,100,0)
            panel:ControlHelp("The amount of captures needed to win the game")

            panel:NumSlider("Time Limit","zetaplayer_ctfmodetime",10,3600,0)
            panel:ControlHelp("The time before the game ends")

            panel:NumSlider("Return Time","zetaplayer_ctfreturntime",0,120,0)
            panel:ControlHelp("The time before a dropped flag returns back to its capture zone")
            
            
            panel:Button('Start CTF Game', 'zetaplayer_beginctfgame')
            panel:Button('End CTF Game', 'zetaplayer_endctfgame')
            
            
            
            panel:Help('-----------------------------------------\n\n\n\n')


            panel:Help('\n\n\n\n---- Team Deathmatch Settings ----')


            panel:NumSlider( 'Time Limit', 'zetaplayer_tdmmodetime', 10, 6600,0 )
            panel:ControlHelp('The time before the game ends')

            panel:NumSlider( 'Kill Limit', 'zetaplayer_tdmkilllimit', 10, 200,0 )
            panel:ControlHelp('How many kills a team needs in order to win')

            panel:TextEntry("10 Kills Left Sound","zetaplayer_tdm10killsremain")
            panel:ControlHelp("The sound that will play when a team needs 10 more kills")

            panel:TextEntry("30 Seconds","zetaplayer_tdm30secondssound")
            panel:ControlHelp("The sound that will play when the timer reaches 30 seconds")  

            panel:TextEntry("10 Seconds","zetaplayer_tdm10secondssound")
            panel:ControlHelp("The sound that will play when the timer reaches 10 seconds")
            
            panel:TextEntry("Game Start Sound","zetaplayer_tdmgamestartsound")
            panel:ControlHelp("The sound that will play when the game starts")
            
            panel:TextEntry("Victory Sound","zetaplayer_tdmvictorysound")
            panel:ControlHelp("The sound that will play when your team wins")
            
            panel:TextEntry("Loss Sound","zetaplayer_tdmlosssound")
            panel:ControlHelp("The sound that will play when your team loses")


            panel:Button("Start TDM game","zetaplayer_begintdmgame")
            panel:Button("End TDM game","zetaplayer_endtdmgame")

            panel:Help('-----------------------------------------\n\n\n\n')
            
            local teamfile = file.Read("zetaplayerdata/teams.json")

            if teamfile then
                teamfile = util.JSONToTable(teamfile)
                local box = panel:ComboBox("Team Override","zetaplayer_overrideteam")
        
                for k,v in ipairs(teamfile) do
                    box:AddChoice(v[1],v[1])
                end
        
                box:AddChoice("None","")
        
                local refresh = vgui.Create("DButton")
                panel:AddItem(refresh)
                refresh:SetText("Refresh Team List")
        
                function refresh:DoClick()
                    box:Clear()
        
                    local teamfile = util.JSONToTable(file.Read("zetaplayerdata/teams.json"))
        
                    for k,v in ipairs(teamfile) do
                        box:AddChoice(v[1],v[1])
                    end
                    
                    box:AddChoice("Neutral","")
                end

                panel:ControlHelp("The team newly spawned zetas should be forced into")
        
        
        
            end
            

--[[             panel:Help('The Color your fellow team members will display')
            local colorpanel = vgui.Create('DColorMixer')
            panel:AddItem(colorpanel)
            colorpanel:SetParent(panel)
            colorpanel:SetConVarR('zetaplayer_teamcolorRed')
            colorpanel:SetConVarG('zetaplayer_teamcolorGreen')
            colorpanel:SetConVarB('zetaplayer_teamcolorBlue') ]]
            panel:Help('Select your team or add or remove teams in this panel')
            panel:Button('Open Team Panel', 'zetaplayer_openteampanel')
            
            panel:Button('Open Team Ent Data Panel', 'zetaplayer_openteamentsavepanel')
            panel:ControlHelp("Save Flags, Team Spawns, and KOTH/Domination points with this panel")
            
    end)
    
    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_modeloptions', 'PlayerModel Options', "", "", function(panel) 
        panel:Help('This is where you can configure the Zeta Playermodels')

            panel:CheckBox('Random Playermodels','zetaplayer_randomplayermodels')
            panel:ControlHelp('If zetas are allowed to spawn with random playermodels you have installed and have by default. NOTE: This will create a lag spike when a un-cached model gets chosen! Some models will NOT have correct animations and/or will not work!')
    
            panel:CheckBox('Default Playermodels Only','zetaplayer_randomdefaultplayermodels')
            panel:ControlHelp('If the random playermodel should only be from the base game')

            panel:TextEntry("Override Model","zetaplayer_overridemodel")
            panel:ControlHelp("Override the model of Zetas.\n\nPut a model path here. You can add multiple model paths by adding a , between them.\nEXAMPLE: models/player/combine_soldier.mdl,models/player/breen.mdl")
            
            panel:CheckBox('Enable Random Playermodel Colors','zetaplayer_randomplayermodelcolor')
            panel:ControlHelp('If Zeta models should have a random color applied to it if the model supports it')
            
            panel:CheckBox('Random Body Groups','zetaplayer_randombodygroups')
            panel:ControlHelp('If Zetas should have random bodygroups')

            panel:CheckBox('Random Skins','zetaplayer_randomskingroups')
            panel:ControlHelp('If Zetas should have random Skins')

            panel:CheckBox('Enable Mingebag Variant','zetaplayer_mingebag')
            panel:ControlHelp('If Zetas should become mingebags')

            panel:CheckBox('Enable Block Models','zetaplayer_enableblockmodels')
            panel:ControlHelp('If models specified by the Playermodel Block Panel should not be used\n\nRemember to update SERVER CACHE if you have it enabled so any changes done to playermodel blocking can be updated')

            

            panel:Button("Cache All PlayerModels","zetaplayer_cacheallmodels")
            panel:ControlHelp('MAKE SURE TO READ EVERYTHING BELOW!\n\n Pre Cache all Player Models so your game will not lag when they spawn.\n\nWARNING! THIS WILL LAG YOUR GAME FOR A MOMENT OR LONGER DEPENDING HOW MUCH PLAYERMODELS YOU HAVE!\n\n YOUR GAME MAY CRASH IF TOO MANY MODELS ARE PRECACHED!')
            
            
            
    end)

    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_registerpanels', 'Register Panels', "", "", function(panel) 
        panel:Help('This is where you can register and see props, names, and ect through panels')
            
        panel:Button('Open Name Panel','zetaplayer_opennamepanel')
        panel:ControlHelp("Opens a panel that allows you to add names to the Zetas")

        panel:Button('Open Prop Panel','zetaplayer_openproppanel')
        panel:ControlHelp("Opens a panel that allows you to add more props to the Zetas")

        panel:Button('Open NPC Panel','zetaplayer_opennpcpanel')
        panel:ControlHelp("Opens a panel that allows you to add more npcs to the Zetas")

        panel:Button('Open Entity Panel','zetaplayer_openentpanel')
        panel:ControlHelp("Opens a panel that allows you to add more entities to the Zetas")

        panel:Button('Open Profile Panel','zetaplayer_openprofilepanel')
        panel:ControlHelp("Opens a panel that allows you to create profiles about specific Zetas and give them specific details such as playermodels, personalities, admin or not, and ect.")
        
        panel:Button('Open Text Panel','zetaplayer_opentextdatapanel')
        panel:ControlHelp("Opens a panel that allows you to add text lines for the Zetas to use")

        panel:Button('Open Media Panel','zetaplayer_openmediapanel')
        panel:ControlHelp("Opens a panel that allows you to add videos that the Zetas can request on Media Players")

        panel:Button('Open Playermodel Block Panel','zetaplayer_openblockedmodelpanel')
        panel:ControlHelp("Opens a panel that allows you to prevent certain playermodels from being used")
        
        panel:Button('Open Voting Data Panel','zetaplayer_openvotingpanel')
        panel:ControlHelp("Opens a panel that allows you to add preset votes the Zetas can start")

        panel:Button('Open Team Panel', 'zetaplayer_openteampanel')
        panel:ControlHelp("Opens a panel that allows you to create teams and join/leave a team")

        panel:Button('Open Team Ent Data Panel', 'zetaplayer_openteamentsavepanel')
        panel:ControlHelp("Opens a panel that allows you to save team system entities such as KOTH Points, Team Spawn Points, and Flags")

        
        panel:TextEntry("Panel BGM", "zetaplayer_panelbgm")
        panel:ControlHelp("Sound path to a file that will play in the background while in a panel\n\nTypically you want to put music here. This option is useless and pointless but here it is lol.\n\nAdding a /* at the end of a file path will pick a random file in the folder. EXAMPLE, menu/*")
        
    end)

    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_screenshot', 'Zeta View Shots', "", "", function(panel) 
        panel:Help("Zeta View Shots are essentially screenshots of what a Zeta is currently seeing. This is off by default due to it having the ability to create files that can take up space and by the process that it takes when trying to take a screenshot.")
            
            panel:CheckBox('Allow View Shots','zetaplayer_allowzetascreenshots')
            panel:ControlHelp('If Zetas are allowed to take screenshots of their view and create a image file inside your gmod folder. See below to learn how to find the screenshots')

            local box = panel:ComboBox('View Shot File Type','zetaplayer_zetascreenshotfiletype')
            box:AddChoice('.JPG', 'jpg')
            box:AddChoice('.PNG', 'png')

            panel:NumSlider( 'View Shots FOV', 'zetaplayer_zetascreenshotfov', 10, 180,0 )
            panel:NumSlider( 'View Shot Chance', 'zetaplayer_zetascreenshotchance', 1, 100,0 )
            panel:ControlHelp('The chance a View Shot will render when a Zeta requests a View Shot')

            panel:Button( "View Zeta View Shots", "zetaplayer_openviewshotviewer" )

            panel:Help("NOTE: When a Zeta requests to take a View Shot, your view will be brought to what the Zeta sees until it makes a view shot. Your game will also spike when the View Shot renders in order to create the file. However on the event of a view shot, this happens relatively fast and is generally not too noticeable.")

            panel:Help('To get the best results out of the View Shots, turn off motion blur in your game settings')

            panel:Help("To find the View Shots requested and made by Zetas, go to your gmod folder through steam by using Manage and Browse Local Files then just go here garrysmod/data/zetaplayerdata/zeta_viewshots   Zeta View Shots will show up there")

            panel:Help('File names will have this order, {Zeta name}_{Current Map Name}_{Random Tagged Number}')

            panel:Help('You can delete all the image files in the view shot folder by using the console command, zetaplayer_cleanviewshotfolder')
            
    end)

    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_txtoption', 'Text Chat Options', "", "", function(panel) 
        panel:Help("Text Chat Related options are located here")

        panel:CheckBox('Allow Text Chat','zetaplayer_allowtextchat')
        panel:ControlHelp("If the Zetas are allowed to type in chat")

        panel:CheckBox('Enable Moonbase Alpha TTS support','zetaplayer_enablemoonbasettssupport')
        panel:ControlHelp("If messages sent by Zetas should trigger tts sounds.\n\nYou must have this addon for this! Moonbase Alpha TTS by Marshall_Vak\nhttps://steamcommunity.com/sharedfiles/filedetails/?id=2728999898")


        panel:CheckBox('Override Text Chat Chance','zetaplayer_overridetextchance')
        panel:ControlHelp("If the Override slider below should be applied to all Zetas")

        panel:NumSlider("Text Chance Override", "zetaplayer_textchanceoverride",0,100,0)

        panel:NumSlider("Chat Cooldown", "zetaplayer_textchatslowtime",0,10,1)
        panel:ControlHelp("The time in seconds before a zeta can send a message in chat. Think of this as Discord Slowmode")

        panel:NumSlider("Receive Distance", "zetaplayer_textchatreceivedistance",0,10000,0)
        panel:ControlHelp("The distance you can receive messages from Zetas. This is proximity Text Chat basically. Set to 0 for global")

        panel:CheckBox('Connect Lines','zetaplayer_connectlines')
        panel:ControlHelp("If Zetas should type a line when they join your server")

        panel:CheckBox('Disconnect Lines','zetaplayer_disconnectlines')
        panel:ControlHelp("If Zetas should type lines before they disconnect from your server")

        panel:CheckBox('Allow Interrupting','zetaplayer_allowinterrupting')
        panel:ControlHelp("If Zetas should send a uncompleted message when they are interrupted. Example would be, guys wheres-  and   guys wheresASF763rhUDF")

        panel:CheckBox('Allow Sentence Mixing','zetaplayer_textmixing')
        panel:ControlHelp("If all text sent by Zetas should be modified through sentence mixing of many other lines in the same type/situation. This can yield pretty interesting things in chat")
        
        panel:CheckBox('Allow Creating Votes','zetaplayer_allowcreatingvotes')
        panel:ControlHelp("If Zetas are allowed to start votes randomly")

        

        panel:TextEntry("Text Send Sound","zetaplayer_customtextsendsound")
        panel:ControlHelp("Custom sound that will play when a Zeta sends a text message in text chat")
            
    end)
    
    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_options', 'Other', "", "", function(panel) 
        panel:Help('Presets effect ALL settings relating to the Zetas!')

            panel:Button( "Open Preset Panel", "zetaplayer_openpresetpanel" )
            panel:ControlHelp( "Opens a panel that allows you to make presets of all the settings relating to the Zetas.\n\nThis does not effect file data such as names, textdata, ect" )

            panel:Help("NOTE: 5.3 Update has moved many options to different categories")

            panel:TextEntry("Spawn Sound","zetaplayer_customspawnsound")
            panel:ControlHelp("Custom spawn sound a zeta will use when they spawn by MWS or respawn")

            panel:TextEntry("Connect Sound","zetaplayer_customjoinsound")
            panel:ControlHelp("Custom connect sound a zeta will use when they join the server\n\nIf you do not want to hear the sound, use 'zetaplayer/misc/zeta_nocon_sound.wav'")

            panel:TextEntry("Disconnect Sound","zetaplayer_customleavesound")
            panel:ControlHelp("Custom disconnect sound a zeta will use when they leave the server\n\nIf you do not want to hear the sound, use 'zetaplayer/misc/zeta_nocon_sound.wav'")

            panel:CheckBox('Show Connect Messages','zetaplayer_showconnectmessages')

            panel:CheckBox("Prevent Eye Tapper's view tilting", 'zetaplayer_eyetap_preventtilting')
            panel:ControlHelp("If the view from Zeta Eye Tapper shouldn't be tilted left and right")
    
            panel:CheckBox("Eye Tapper Follow Zeta's Corpse", 'zetaplayer_eyetap_followcorpse')
            panel:ControlHelp("If the view from Zeta Eye Tapper should switch to zeta's corpse after death")

            panel:CheckBox("Use Panic Animation", 'zetaplayer_usepanicanimation')
            panel:ControlHelp("If panicking Zetas should use the panic animation")

            panel:CheckBox('Find Poker Table on Spawn', 'zetaplayer_findpokertableonspawn')
            panel:ControlHelp("If Zetas should look for poker tables when they spawn. You must have the Gpoker addon for this!")

            panel:Button('Teleport to a random Zeta','zetaplayer_tptorandomzeta',LocalPlayer())
            


            


            
    end)

    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'Tool_Permission', 'ToolGun Options', "", "", function(panel) 

        panel:Help('NOTE: Limits effect per Zeta! Meaning each Zeta has their own limit!')



        panel:CheckBox('Allow ToolGun On World Ents','zetaplayer_allowtoolgunworld')
        panel:ControlHelp('If the Zeta is allowed to toolgun world entities')

        panel:CheckBox('Allow ToolGun On Non World Ents','zetaplayer_allowtoolgunnonworld')
        panel:ControlHelp('If the Zeta is allowed to toolgun non world entities such as player spawned props and ect')

        panel:CheckBox('Allow Color Tool','zetaplayer_allowcolortool')
        panel:ControlHelp('If the Zeta is allowed to use the Color Tool')

        panel:CheckBox('Allow Material Tool','zetaplayer_allowmaterialtool')
        panel:ControlHelp('If the Zeta is allowed to use the Material Tool')

        panel:CheckBox('Allow Trails Tool','zetaplayer_allowtrailstool')
        panel:ControlHelp('If the Zeta is allowed to use the Trails Tool')

        panel:CheckBox('Allow Rope Tool','zetaplayer_allowropetool')
        panel:ControlHelp('If the Zeta is allowed to use the Rope Tool')
        

        panel:CheckBox('Allow Light Tool','zetaplayer_allowlighttool')
        panel:ControlHelp('If the Zeta is allowed to use the Light Tool')
        

        panel:CheckBox('Allow Remover Tool','zetaplayer_allowremovertool')
        panel:ControlHelp('If the Zeta is allowed to use the Remover Tool. This is off by default due to this being a powerful tool to give to a bot')

        panel:CheckBox('Allow Balloon Tool','zetaplayer_allowballoontool')
        panel:ControlHelp('If the Zeta is allowed to use the Balloon Tool')
        
        
        panel:CheckBox('Allow Music Box Tool','zetaplayer_allowmusicboxtool')
        panel:ControlHelp('If the Zeta is allowed to use the Music Box Tool')
        

        panel:CheckBox('Allow Igniter Tool','zetaplayer_allowignitertool')
        panel:ControlHelp('If the Zeta is allowed to use the Igniter Tool')

        panel:CheckBox('Allow Face Poser Tool','zetaplayer_allowfaceposertool')
        panel:ControlHelp('If the Zeta is allowed to use the Face Poser Tool')
        
        panel:CheckBox('Allow Emitter Tool','zetaplayer_allowemittertool')
        panel:ControlHelp('If the Zeta is allowed to use the Emitter Tool. Note, Emitters may cause a drop of fps.')

        panel:CheckBox('Allow Bone Manipulator Tool','zetaplayer_bonemanipulatortool')
        panel:ControlHelp('If the Zeta is allowed to use the Bone Manipulator Tool')

        panel:CheckBox('Allow Dynamite Tool','zetaplayer_allowdynamitetool')
        panel:ControlHelp('If the Zeta is allowed to use the Dynamite Tool')

        panel:CheckBox('Allow Paint Tool','zetaplayer_allowpainttool')
        panel:ControlHelp('If the Zeta is allowed to use the Paint Tool')

        panel:CheckBox('Allow Lamp Tool','zetaplayer_allowlamptool')
        panel:ControlHelp('If the Zeta is allowed to use the Lamp Tool')

        panel:CheckBox('Allow Thruster Tool','zetaplayer_allowthrustertool')
        panel:ControlHelp('If the Zeta is allowed to use the Thruster Tool')

        panel:CheckBox('Allow Wire Gate Tool','zetaplayer_allowwiregatetool')
        panel:ControlHelp('If the Zeta is allowed to use the Wire Gate Tool')

        panel:CheckBox('Allow Wire Button Tool','zetaplayer_allowwirebuttontool')
        panel:ControlHelp('If the Zeta is allowed to use the Wire Button Tool')

        


        

        panel:CheckBox('Thruster Unfreezes Parent','zetaplayer_thrusterunfreeze')
        panel:ControlHelp('If the Thruster is allowed to unfreeze whatever it is welded to')
        
        
        
        panel:NumSlider( 'Wire Button Limit', 'zetaplayer_wirebuttonlimit', 1, 100,0 )     
        panel:NumSlider( 'Wire Gate Limit', 'zetaplayer_wiregatelimit', 1, 100,0 )     
        panel:NumSlider( 'Thruster Limit', 'zetaplayer_thrusterlimit', 1, 30,0 )     
        panel:NumSlider( 'Lamp Limit', 'zetaplayer_lamplimit', 1, 30,0 )
        panel:NumSlider( 'Rope Limit', 'zetaplayer_ropelimit', 1, 100,0 )
        panel:NumSlider( 'Light Limit', 'zetaplayer_lightlimit', 1, 30,0 )
        panel:NumSlider( 'Balloon Limit', 'zetaplayer_balloonlimit', 1, 100,0 )
        panel:NumSlider( 'Music Box Limit', 'zetaplayer_musicboxlimit', 1, 30,0 )
        panel:NumSlider( 'Emitter Limit', 'zetaplayer_emitterlimit', 1, 100,0 )
        panel:NumSlider( 'Dynamite Limit', 'zetaplayer_dynamitelimit', 1, 100,0 )
        

    end)
--[[
zetaplayer_allowpistol
zetaplayer_allowar2
zetaplayer_allowshotgun
zetaplayer_allowsmg
zetaplayer_allowrpg
zetaplayer_allowcrowbar
zetaplayer_allowstunstick
zetaplayer_allowrevolver
zetaplayer_allowtoolgun
zetaplayer_allowphysgun ]]

    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_equipment', 'Equipment Options', "", "", function(panel) 
        panel:Help('Create Custom Weapons using the panel below')

        panel:Button( "Open Weapon Creator", "zetaplayer_openweaponcreatorpanel" )

        local gmodWeps = {}
        local cssWeps = {}
        local tf2Weps = {}
        local hl1Weps = {}
        local dodWeps = {}
        local customweps = {}
        local customAddonweps = {}
        local mp1Weps = {}
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
            elseif k == "CUSTOM" then
                customweps = v
            elseif k == "ADDON" then
                customAddonweps = v
            elseif k == "MP1" then
                mp1Weps = v
            else
                gmodWeps = v
            end
        end
        panel:Help('\n\nChange what weapons the Zetas are allowed to equip. ')

            local box = panel:ComboBox('Spawn weapon','zetaplayer_spawnweapon')
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

            
            if #customAddonweps > 0 then
                for i = 1, #customAddonweps do
                    box:AddChoice('[Addon] '..customAddonweps[i][1], customAddonweps[i][2])
                end
            end
            
            box:AddSpacer()

            if #customweps > 0 then
                for i = 1, #customweps do
                    box:AddChoice('[Custom] '..customweps[i][1], customweps[i][2])
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

            if #mp1Weps > 0 then
                for i = 1, #mp1Weps do
                    box:AddChoice(mp1Weps[i][1], mp1Weps[i][2])
                end
            
                box:AddSpacer()
            end

        panel:CheckBox('Allow Pistol','zetaplayer_allowpistol')
        panel:ControlHelp('Allows the Zeta to equip the Pistol')

        panel:CheckBox('Allow AR2','zetaplayer_allowar2')
        panel:ControlHelp('Allows the Zeta to equip the AR2')

        panel:CheckBox('Allow AR2 Alt Fire','zetaplayer_allowar2altfire')
        panel:ControlHelp('Allows the Zeta to use the AR2 Alt Fire')

        panel:CheckBox('Allow Shotgun','zetaplayer_allowshotgun')
        panel:ControlHelp('Allows the Zeta to equip the Shotgun')

        panel:CheckBox('Allow SMG','zetaplayer_allowsmg')
        panel:ControlHelp('Allows the Zeta to equip the SMG')

        panel:CheckBox('Allow RPG','zetaplayer_allowrpg')
        panel:ControlHelp('Allows the Zeta to equip the RPG')

        panel:CheckBox('Allow Crowbar','zetaplayer_allowcrowbar')
        panel:ControlHelp('Allows the Zeta to equip the Crowbar')

        panel:CheckBox('Allow Stunstick','zetaplayer_allowstunstick')
        panel:ControlHelp('Allows the Zeta to equip the Stunstick')

        panel:CheckBox('Allow Revolver','zetaplayer_allowrevolver')
        panel:ControlHelp('Allows the Zeta to equip the Revolver')

        panel:CheckBox('Allow ToolGun','zetaplayer_allowtoolgun')
        panel:ControlHelp('Allows the Zeta to equip the ToolGun')

        panel:CheckBox('Allow Physgun','zetaplayer_allowphysgun')
        panel:ControlHelp('Allows the Zeta to equip the Physgun')

        panel:CheckBox('Allow Fists','zetaplayer_allowfist')
        panel:ControlHelp('Allows the Zeta to use their fists')

        panel:CheckBox('Allow Crossbow','zetaplayer_allowcrossbow')
        panel:ControlHelp('Allows the Zeta to use the Crossbow')

        panel:CheckBox('Allow Camera','zetaplayer_allowcamera')
        panel:ControlHelp('Allows the Zeta to use the Camera')

        panel:CheckBox('Allow Camera Flashing','zetaplayer_drawcameraflashing')
        panel:ControlHelp('If Cameras should emit a flash when they are used')

        panel:CheckBox('Allow Camera As a Lethal Weapon','zetaplayer_allowcameraaslethalweapon')
        panel:ControlHelp('If Zetas are allowed to pick the camera when they need a lethal weapon. For example defending themselves')

        panel:CheckBox('Allow Sniper Crit','zetaplayer_allowmlgshots')
        panel:ControlHelp('Allows the Zeta to hit critical shots with the AWP and TF2 Sniper, making room for those MLG gamer moments')

        panel:CheckBox('Allow Use Of Grenades','zetaplayer_allowgrenades')
        panel:ControlHelp('Allows the Zeta to use Grenades')

        panel:CheckBox('Allow JPG','zetaplayer_allowjpg')
        panel:ControlHelp('Allows the Zeta to use the Junk Launcher | Community Contribute')

        panel:NumSlider("JPG Prop Amount","zetaplayer_jpgpropamount",1,15,0)
        panel:ControlHelp('The amount of props the JPG will fire')
        
        if #gmodWeps > 0 then
            for i = 1, #gmodWeps do
                panel:CheckBox('Allow '..gmodWeps[i][1], gmodWeps[i][3])
                panel:ControlHelp('Allows the Zeta to equip the '..gmodWeps[i][1])
            end
        end
        
        panel:NumSlider("Bugbait Limit","zetaplayer_bugbait_limit",1,30,0)
        panel:ControlHelp('The amount of antlions a Zeta is allowed to summon')

        panel:NumSlider("Antlion lifetime","zetaplayer_bugbait_lifetime",0,120,2)
        panel:ControlHelp('The amount of time antlions are allowed to live')

        panel:NumSlider("Antlion Health","zetaplayer_bugbait_spawnhp",1,500,0)
        panel:ControlHelp('The amount of health antlions will spawn with')

        panel:NumSlider("Antlion Damage Scale","zetaplayer_bugbait_dmgscale",1,100,2)
        panel:ControlHelp('The amount of damage done by summoned antlions should be multiplied by')
        
        panel:CheckBox('C4 Debris','zetaplayer_c4debris')
        panel:ControlHelp('If C4 should create debris when it blows up')

        panel:CheckBox('C4 MW2 Card','zetaplayer_c4card')
        panel:ControlHelp('If a Zeta who armed a C4 should show up on a MW2 Card. You must have the MW2 Cards installed for this!')

        panel:CheckBox('Allow Source Cut','zetaplayer_allowsourcecut')
        panel:ControlHelp('If Zetas with Katanas are allowed to use Source Cut\n\nSource Cut is large AOE multi cut that takes a few seconds before it fully kills everyone caught inside leaving room for escape. This ability is inspired by DMC5 Judgement Cut End')

        panel:NumSlider('Source Cut Distance','zetaplayer_sourcecutdistance',100,10000,0)
        panel:ControlHelp('The Distance Source Cut can cut at')

        panel:CheckBox('Motivated Katana users','zetaplayer_motivatedkatana')
        panel:ControlHelp('Bury the Light Deep within')

        panel:CheckBox('Allow Judgement Cut','zetaplayer_allowjudgementcut')
        panel:ControlHelp('If Katana users are allowed to use Judgement Cut in combat')

        panel:CheckBox("TF2 Sentry Buster Mechanics for PAIG", "zetaplayer_paig_sentrybustermode")
        panel:ControlHelp("If PAIG should use sounds and mechanics from TF2's Sentry Buster")


        panel:Help('--------------- Custom Addon Weapons ---------------')
        
        if #customAddonweps > 0 then
            for i = 1, #customAddonweps do
                panel:CheckBox('Allow '..customAddonweps[i][1], customAddonweps[i][3])
                panel:ControlHelp('Allows the Zeta to equip the '..customAddonweps[i][1])
            end
        end
        
        
        panel:Help('--------------- Custom Weapons ---------------')
        
        if #customweps > 0 then
            for i = 1, #customweps do
                panel:CheckBox('Allow '..customweps[i][1], customweps[i][3])
                panel:ControlHelp('Allows the Zeta to equip the '..customweps[i][1])
            end
        end

        
        
        panel:Help('--------------- CSS Weapons ---------------')

        panel:CheckBox('Allow Knife','zetaplayer_allowknife')
        panel:ControlHelp('Allows the Zeta to equip a knife')

        panel:CheckBox('Allow BackStabbing','zetaplayer_allowbackstabbing')
        panel:ControlHelp("Allows the Zeta to do more damage when stabbing in a victim's back")

        panel:CheckBox('Allow M4A1','zetaplayer_allowm4a1')
        panel:ControlHelp('Allows the Zeta to equip the M4A1')

        panel:CheckBox('Allow AWP','zetaplayer_allowawp')
        panel:ControlHelp('Allows the Zeta to equip the AWP')

        panel:CheckBox('Allow AK47','zetaplayer_allowak47')
        panel:ControlHelp('Allows the Zeta to equip the AK47')

        panel:CheckBox('Allow M249','zetaplayer_allowmachinegun')
        panel:ControlHelp('Allows the Zeta to equip the M249 Machine Gun')

        panel:CheckBox('Allow Desert Eagle','zetaplayer_allowdeagle')
        panel:ControlHelp('Allows the Zeta to equip the Desert Eagle')

        panel:CheckBox('Allow MP5','zetaplayer_allowmp5')
        panel:ControlHelp('Allows the Zeta to equip the MP5')

        if #cssWeps > 0 then
            for i = 1, #cssWeps do
                panel:CheckBox('Allow '..cssWeps[i][1], cssWeps[i][3])
                panel:ControlHelp('Allows the Zeta to equip the '..cssWeps[i][1])
            end
        end

        panel:CheckBox('Flashbangs Ignore Thrower','zetaplayer_flashbang_ignorethrower')
        panel:ControlHelp("If the thrown flashbang shouldn't affect the thrower")

        panel:CheckBox("Flashbangs Ignore Thrower's Friends and Teammates",'zetaplayer_flashbang_ignoreteammates')
        panel:ControlHelp("If the thrown flashbang shouldn't affect the thrower's friends and teammates")

        panel:CheckBox("Change Weapon when Thrown",'zetaplayer_cssnades_changeweapons')
        panel:ControlHelp("If the Zetas should change their weapon once when they threw flashbang or smokegrenade")

    
        
        panel:Help('--------------- TF2 Weapons ---------------')

        panel:CheckBox('Allow Wrench','zetaplayer_allowwrench')
        panel:ControlHelp('Allows the Zeta to equip the Wrench')

        panel:CheckBox('Allow Scatter Gun','zetaplayer_allowscattergun')
        panel:ControlHelp('Allows the Zeta to equip the Scatter Gun')

        panel:CheckBox('Allow TF2 Pistol','zetaplayer_allowtf2pistol')
        panel:ControlHelp('Allows the Zeta to equip the TF2 Pistol')

        panel:CheckBox('Allow TF2 Sniper','zetaplayer_allowtf2sniper')
        panel:ControlHelp('Allows the Zeta to equip the TF2 Sniper')

        panel:CheckBox('Allow TF2 Shotgun','zetaplayer_allowtf2shotgun')
        panel:ControlHelp('Allows the Zeta to equip the TF2 Shotgun')

        if #tf2Weps > 0 then
            for i = 1, #tf2Weps do
                panel:CheckBox('Allow '..tf2Weps[i][1], tf2Weps[i][3])
                panel:ControlHelp('Allows the Zeta to equip the '..tf2Weps[i][1])
            end
        end

        panel:Help('--------------- Half Life 1 Weapons ---------------')
        
        if #hl1Weps > 0 then
            for i = 1, #hl1Weps do
                panel:CheckBox('Allow '..hl1Weps[i][1], hl1Weps[i][3])
                panel:ControlHelp('Allows the Zeta to equip the '..hl1Weps[i][1])
            end
        end

        panel:Help('--------------- Day of Defeat Weapons ---------------')
        
        if #dodWeps > 0 then
            for i = 1, #dodWeps do
                panel:CheckBox('Allow '..dodWeps[i][1], dodWeps[i][3])
                panel:ControlHelp('Allows the Zeta to equip the '..dodWeps[i][1])
            end
        end

        panel:Help('--------------- Left 4 Dead Weapons ---------------')
        
        if #l4dWeps > 0 then
            for i = 1, #l4dWeps do
                panel:CheckBox('Allow '..l4dWeps[i][1], l4dWeps[i][3])
                panel:ControlHelp('Allows the Zeta to equip the '..l4dWeps[i][1])
            end
        end

        if #mp1Weps > 0 then
            panel:Help('--------------- Max Payne 1 Weapons ---------------')
            
            for i = 1, #mp1Weps do
                panel:CheckBox('Allow '..mp1Weps[i][1], mp1Weps[i][3])
                local noBrackets = string.Replace(mp1Weps[i][1], "[MP1] ", "")
                panel:ControlHelp('Allows the Zeta to equip the '..noBrackets)
            end
        end
        
    end)

    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_friend', 'Friend System', "", "", function(panel) 
        panel:Help('Change the Friend System Settings.')
    
            panel:CheckBox('Enable Friend System','zetaplayer_enablefriend')
            panel:ControlHelp('If Zetas should be able to consider a player as a friend')

            panel:NumSlider("Max Friend Count","zetaplayer_friendamount",1,50,0)
            panel:ControlHelp('The max amount of friends a zeta or player can have')

            panel:CheckBox('Allow Zetas Friends with Zetas','zetaplayer_allowfriendswithzetas')
            panel:ControlHelp('If Zetas are allowed to be friends with each other')

            panel:CheckBox('Allow Zetas Friends with Player','zetaplayer_allowfriendswithplayers')
            panel:ControlHelp('If Zetas are allowed to be friends with the player aka you')

            panel:CheckBox("No hurt","zetaplayer_nohurtfriends")
            panel:ControlHelp('If friends should not be able to hurt each other')
            
            panel:CheckBox("Permanent Friends Always In game","zetaplayer_permamentfriendalwaysspawn")
            panel:ControlHelp('If your permanent friends marked in the profile panel should always be ingame if possible')

            panel:CheckBox("Friend List",'zetaplayer_showhwosfriendwithwho')
            panel:ControlHelp('If Name Displays should show who a zeta is friends with')

            panel:NumSlider("Friend Chance","zetaplayer_spawnasfriendchance",1,100,0)

            panel:CheckBox('Enable Friend Display','zetaplayer_showfriends')
            panel:ControlHelp('If Zetas should display a Friend tag if a Zeta considers you as a friend')

            panel:CheckBox('Draw Friend Halo','zetaplayer_drawfriendhalo')
            panel:ControlHelp('If Friend Zetas should have a halo drawn over them. Halos will only draw if they are within the Friend Display Distance')

            panel:CheckBox('Draw Halo Through world','zetaplayer_drawfriendhalothroughworld')
            panel:ControlHelp("If the Halo should draw through the world allowing you to see your friend's position. NOTE: Due to PVS (Potential Visibility Set) unloading, the Halo position may not be accurate when the Zeta runs out of your PVS ")
            
            panel:NumSlider('Friend Display Distance','zetaplayer_frienddisplaydistance',500,10000,0)
            panel:ControlHelp('The rendering distance of the Friend Tag')

            
            panel:CheckBox('Stay Near Friends','zetaplayer_friendsticknear')
            panel:ControlHelp('If Zetas should stick near their friends if they are able to reach them')

            panel:CheckBox('Stick near Player','zetaplayer_stickwithplayer')
            panel:ControlHelp('This is a addon to the Stay Near Friend Option above.\n\nIf Zetas who are friends with the player should stick near the player always')

            panel:CheckBox('Ignore Nav mesh','zetaplayer_sticknearnonav')
            panel:ControlHelp('If Zetas should not use the nav mesh for a random location near friend. This gives more control.')

            panel:NumSlider('Near Distance','zetaplayer_friendstickneardistance',0,15000,0)
            panel:ControlHelp('The distance Zetas can wander away from their friends')

            

            
            
            panel:Help("Friend Display Color")

            panel:CheckBox('Use Friend Color','zetaplayer_usefriendcolor')
            panel:ControlHelp('If Friend Zetas should use this color')

            local colorpanel = vgui.Create('DColorMixer')
            panel:AddItem(colorpanel)
            colorpanel:SetParent(panel)
            colorpanel:SetConVarR('zetaplayer_friendnamecolorR')
            colorpanel:SetConVarG('zetaplayer_friendnamecolorG')
            colorpanel:SetConVarB('zetaplayer_friendnamecolorB')
            
            
    
        end)



    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_voice', 'Voice Options', "", "", function(panel) 
        panel:Help('Zeta Voice Options')


            panel:CheckBox('Use Alternate Death Sounds','zetaplayer_usealternatedeathsounds')
            panel:ControlHelp('If killed Zetas should use their alternate death sounds. Off by default')

            panel:CheckBox('Use Alternate Idle Sounds','zetaplayer_alternateidlesounds')
            panel:ControlHelp('If Zetas should use their alternate idle sounds. Turn this off for the classic hl2 sounds')
              
            panel:NumSlider( 'Voice Volume', 'zetaplayer_voicevolume', 0, 10,1 )
            panel:ControlHelp('You can go above one to increase the volume of Zetas if you are using Voice Chat/Popups V.2')

            panel:CheckBox('Draw Voice Icon','zetaplayer_drawvoiceicon')
            panel:ControlHelp("Draw the Voice icon above a Zeta when it speaks")

            panel:CheckBox('Allow Voice Chat Popup','zetaplayer_allowvoicepopup')
            panel:ControlHelp("If speaking Zetas should appear in a Voice Chat Popup")

            panel:CheckBox('Random Voice Pitch','zetaplayer_differentvoicepitch')
            panel:ControlHelp("If Zetas should have a random pitch to their voice")

            panel:NumSlider("Voice Pitch Min","zetaplayer_voicepitchmin",10,100,0)
            panel:NumSlider("Voice Pitch Max","zetaplayer_voicepitchmax",100,255,0)
            panel:ControlHelp("A Zeta's pitch will be random between the min and the max")
        
            
            panel:CheckBox('Allow Conversations','zetaplayer_allowconversations')
            panel:ControlHelp("If Zetas can have conversations with each other or with a player")

            panel:NumSlider("Convo Chance","zetaplayer_startconversationchance",1,100,0)
            panel:ControlHelp("The chance a zeta will look for someone to talk to when they attempt")

            panel:NumSlider("Voice Pack Chance","zetaplayer_voicepackchance",0,100,0)
            panel:ControlHelp("The chance a Zeta will spawn with a voice pack")
            

            panel:CheckBox('Use Voice Chat V.2','zetaplayer_usenewvoicechatsystem')
            panel:ControlHelp("If Zetas should use the Voice Chat V.2 System\n\nThis system changes the popups in a way so they light up green whenever a zeta speaks much like real voice chat.\nNote that this system is seperate from source which means it will have its own issues. Make sure any custom files you have is mono and not stereo or they won't work")

            panel:NumSlider('Voice Pop up Distance','zetaplayer_voicepopupdrawdistance',0,15000,0)
            panel:ControlHelp("If a speaking zeta speaks within this distance their voice pop up will show up when Global Voices is off if farther, then their pop up won't show up.\nSet this to 0 for the popups to always show up regardless of distance")

            panel:CheckBox("Voice Popup Use Team Color", "zetaplayer_voicepopup_useteamcolor")
            panel:ControlHelp("If speaking Zeta's voicechat popup should use its team color when currently in team")

            panel:NumSlider("Voice Popup X","zetaplayer_voicepopup_x",1.17,100,2)
            panel:NumSlider("Voice Popup Y","zetaplayer_voicepopup_y",1.15,100,2)
            panel:ControlHelp("X Y positions of the Voice Popups. Change these if they go off screen.\nX default is 1.17\nY default is 1.15")

            panel:CheckBox('Global Voices','zetaplayer_globalvoicechat')
            panel:ControlHelp("If speaking Zeta voices should be heard globally much like real players")

            panel:NumSlider("Voice Chat Limit","zetaplayer_maxspeakingzetas",0,100,0)
            panel:ControlHelp("The max amount of Zetas that can speak at once in voice chat. Leave at 0 for no limit")

            
            panel:CheckBox('Enable Laughing','zetaplayer_allowlaughing')
            panel:ControlHelp("Enable the ability to laugh at dead people")
            --panel:NumSlider( 'Laughing Chance', 'zetaplayer_laughingchance', 0, 100,1 )
            --panel:ControlHelp("The chance a Zeta will laugh at someone dying")

            panel:CheckBox('Allow Panic Voice','zetaplayer_allowpanicvoice')
            panel:ControlHelp("If Zetas should make panic sounds when they panic")

            panel:CheckBox('Allow Idle Voice','zetaplayer_allowidlevoice')
            panel:ControlHelp("If Zetas should make idle sounds")

            panel:CheckBox('Allow Death Voice','zetaplayer_allowdeathvoice')
            panel:ControlHelp("If Zetas should make death sounds")

            panel:CheckBox('Allow Witness Voice','zetaplayer_allowwitnesssounds')
            panel:ControlHelp("If Zetas should make witness sounds")
            
            panel:CheckBox('Allow Kill Voice','zetaplayer_allowkillvoice')
            panel:ControlHelp("If Zetas should say a line when killing someone")

            panel:CheckBox('Allow Taunt Voice','zetaplayer_allowtauntvoice')
            panel:ControlHelp("If Zetas should taunt before attacking someone or defending themselves")

            panel:CheckBox('Allow Assist Voice','zetaplayer_allowassistsound')
            panel:ControlHelp("If Zetas should speak when someone assists their kill")

            panel:CheckBox('Allow Scold Voice','zetaplayer_allowscoldvoice')
            panel:ControlHelp("If Admin Zetas should speak a line at their offender")

            panel:CheckBox('Allow Falling Voice','zetaplayer_allowfallingvoice')
            panel:ControlHelp("If Zetas should speak lines when they fall")

            panel:CheckBox('Allow Media Watch Voice','zetaplayer_allowmediawatchvoice')
            panel:ControlHelp("If Zetas should speak lines while watching a media player")
            
            

            panel:CheckBox('Custom Idle Lines only','zetaplayer_customidlelinesonly')
            panel:ControlHelp("If your Custom Idle Lines should only be used")

            panel:CheckBox('Custom Death Lines only','zetaplayer_customdeathlinesonly')
            panel:ControlHelp("If your Custom Death Lines should only be used")

            panel:CheckBox('Custom Kill Lines only','zetaplayer_customkilllinesonly')
            panel:ControlHelp("If your Custom Kill Lines should only be used")

            panel:CheckBox('Custom Taunt Lines only','zetaplayer_customtauntlinesonly')
            panel:ControlHelp("If your Custom Taunt Lines should only be used")

            panel:CheckBox('Custom Assist Lines only','zetaplayer_customassistlinesonly')
            panel:ControlHelp("If your Custom Assist Lines should only be used")
            
            
            panel:CheckBox('Custom Witness Lines only','zetaplayer_customwitnesslinesonly')
            panel:ControlHelp("If your Custom Witness Lines should only be used")

            panel:CheckBox('Custom Panic Lines only','zetaplayer_custompaniclinesonly')
            panel:ControlHelp("If your Custom Panic Lines should only be used")

            panel:CheckBox('Custom Laughing Lines only','zetaplayer_customlaughlinesonly')
            panel:ControlHelp("If your Custom Laughing Lines should only be used")

            panel:CheckBox('Custom Admin Scolding Lines only','zetaplayer_customadminscoldlinesonly')
            panel:ControlHelp("If your Custom Admin Scold Lines should only be used")

            panel:CheckBox('Custom Sit Response Lines only','zetaplayer_customsitrespondlinesonly')
            panel:ControlHelp("If your Custom Sit Response Lines should only be used")

            panel:CheckBox('Custom Falling Lines only','zetaplayer_customfallinglinesonly')
            panel:ControlHelp("If your Custom Falling Lines should only be used")

            panel:CheckBox('Custom Convo Question Lines only','zetaplayer_customquestionlinesonly')
            panel:ControlHelp("If your Custom Convo Question Lines should only be used. These are used for when two Zetas talk to each other")

            panel:CheckBox('Custom Convo Respond Lines only','zetaplayer_customrespondlinesonly')
            panel:ControlHelp("If your Custom Convo Respond Lines should only be used. These are used for when two Zetas talk to each other")

            panel:CheckBox('Custom Media Watch Lines only','zetaplayer_custommediawatchlinesonly')
            panel:ControlHelp("If your Custom Media Watch Lines should only be used")
            
            
            

            
            
        end)


    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_personality', 'Personality Options', "", "", function(panel) 
        panel:Help('These options can control what type of decision the Zetas will favor in picking. Note, you have to respawn the Zetas for this to take effect!\n\nAnother note! These settings do not effect natural Zetas! Look in Map Wide Spawning for Personality Settings for natural zetas')

            panel:CheckBox("Use New Chance System","zetaplayer_usenewchancesystem")
            panel:ControlHelp("If the new Chance system should be used\n\nThe new Chance system will sort chances from highest to lowest and will test each chance from highest to lowest\n\nThe old system uses a priority type thing where it only tests the chances in a predefined order.\n\nThis will change how the Zetas behave drastically")
    
            local box = panel:ComboBox('Personality Type','zetaplayer_personalitytype')
            box:AddChoice('Random', 'random')
            box:AddChoice('Builder', 'builder')
            box:AddChoice('Aggressor', 'berserk')
            box:AddChoice('Custom', 'custom')
            box:AddChoice('Random +', 'random++')

            panel:Help('Builder Type is more focused on building than fighting but is generally friendly.\n Aggressor is more focused on attacking.\n Custom enables the custom sliders below.\n Random is a limited random generated personality.\n Random + is purely random generated personality')

            
            panel:Help('You MUST have the personality type set to Custom for these sliders to apply! 0 will never be picked. 100 will have the highest chance of being picked')
            panel:NumSlider('Build Chance','zetaplayer_buildchance',0,100,0)
            panel:NumSlider('Tool Chance','zetaplayer_toolchance',0,100,0)
            panel:NumSlider('Physgun Chance','zetaplayer_physgunchance',0,100,0)
            panel:NumSlider('Combat Chance','zetaplayer_combatchance',0,100,0)
            panel:NumSlider('Disrespect Chance','zetaplayer_disrespectchance',0,100,0)
            panel:NumSlider('Watch Media Player Chance','zetaplayer_watchmediaplayerchance',0,100,0)
            panel:NumSlider('Friendly Chance','zetaplayer_friendlychance',0,100,0)
            panel:NumSlider('Voice Chance','zetaplayer_voicechance',0,100,0)
            panel:NumSlider('Text Chance','zetaplayer_textchance',0,100,0)
            panel:NumSlider('Vehicle Chance','zetaplayer_vehiclechance',0,100,0)
            panel:ControlHelp('Friendly Chance is the decision type where a Zeta can do a friendly action such as healing other Zetas/Players. Voice Chance is the chance they will speak after every 5 seconds. Vehicle Chance is the chance where a zeta will find a vehicle or spawn a vehicle and drive it. Typically you want this at a low chance such as under 10.')
                
        end)


        spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_statusinfo', 'Zeta Stats', "", "", function(panel) 
            panel:Help("Note: Use Refresh Button at the bottom to refresh the stats\n\n")
            

            
            local killcountlabel = panel:Help("Zetas Killed in Total: 0\n")

            local connectcountlabel = panel:Help("Total Zeta Connects (Spawned): 0\n")

            local propcountlabel = panel:Help("Total Props Spawned: 0\n")

            local timeplayedlabel = panel:Help("Time Played with Zetas: Not Available")

            
            

            panel:Help("\n\n")

            local leadingzeta = panel:Help("Top Leading Zeta: Currently Not Available\n")
            leadingzeta:SetColor( Color(0,255,0) )

            local secondleadingzeta = panel:Help("Second Leading Zeta: Currently Not Available\n")
            secondleadingzeta:SetColor( Color(14,127,172) )

            local thirdleadingzeta = panel:Help("Third Leading Zeta: Currently Not Available\n")
            thirdleadingzeta:SetColor( Color(139,96,38) )

            panel:Help("\n\n")

            local absoluteworstzeta = panel:Help("Top Most Killed Zeta: Currently Not Available\n")
            absoluteworstzeta:SetColor( Color(255,0,0) )

            local secondworstzeta = panel:Help("Second Most Killed Zeta: Currently Not Available\n")
            secondworstzeta:SetColor( Color(194,182,11) )

            local thirdworstzeta = panel:Help("Third Most Killed Zeta: Currently Not Available\n")
            thirdworstzeta:SetColor( Color(124,27,116) )
        

            panel:Help("-----------------------------------------------\n\n")

            local firstweapon = panel:Help("Most Popular Weapon: Currently Not Available\n")
            firstweapon:SetColor( Color(0,255,0) )

            local secondweapon = panel:Help("Second Popular Weapon: Currently Not Available\n")
            secondweapon:SetColor( Color(14,127,172) )

            local thirdweapon = panel:Help("Third Popular Weapon: Currently Not Available\n")
            thirdweapon:SetColor( Color(139,96,38) )



            local function BuildStats()
                if !file.Exists("zetaplayerdata/zetastats.json","DATA") then
                    ZetaFileWrite("zetaplayerdata/zetastats.json","[]")
                end

                local zetastats = file.Read("zetaplayerdata/zetastats.json")
                local scroll

                if zetastats then
                    zetastats = util.JSONToTable(zetastats)

                    local killcount = zetastats["kills"] or 0

                    killcount = string.Comma( killcount )

                    killcountlabel:SetText("Zetas Killed in Total: "..killcount)

                    local propcount = zetastats["spawnedpropscount"] or 0

                    propcount = string.Comma( propcount )

                    propcountlabel:SetText("Total Props Spawned: "..propcount)

                    local connectcount = zetastats["connectcount"] or 0
                    
                    connectcount = string.Comma( connectcount )

                    connectcountlabel:SetText("Total Zeta Connects (Spawned): "..connectcount)

                    local function Plural(num,str)
                        return (num > 1 and str.."s" or str)
                    end

                    if zetastats["timeplayed"] then
                        local timetbl = string.FormattedTime( zetastats["timeplayed"] )
                        local timestring = ""..timetbl.h..Plural(timetbl.h," hour").." : "..timetbl.m..Plural(timetbl.m," minute").." : "..timetbl.s..Plural(timetbl.s," second")
                        timeplayedlabel:SetText("Time Played with Zetas: "..timestring)
                    end

                    if zetastats["topzetas"] then
                        local topzetas = zetastats["topzetas"]
                        local index = 1

                        for k,v in SortedPairsByValue( topzetas, true ) do
                            local plural = (v > 1 and "kills" or "kill")
                            if index == 1 then
                                leadingzeta:SetText("Top Leading Zeta: "..k.." with "..v.." "..plural.."\n")
                            end

                            if index == 2 then
                                secondleadingzeta:SetText("Second Leading Zeta: "..k.." with "..v.." "..plural.."\n")
                            end

                            if index == 3 then
                                thirdleadingzeta:SetText("Third Leading Zeta: "..k.." with "..v.." "..plural.."\n")
                                break
                            end
                            index = index + 1
                        end

                    end

                    if zetastats["mostdeaths"] then
                        local worstzetas = zetastats["mostdeaths"]
                        local index = 1

                        for k,v in SortedPairsByValue( worstzetas, true ) do
                            local plural = (v > 1 and "deaths" or "death")
                            if index == 1 then
                                absoluteworstzeta:SetText("Top Most Killed Zeta: "..k.." with "..v.." "..plural.."\n")
                            end

                            if index == 2 then
                                secondworstzeta:SetText("Second Most Killed Zeta: "..k.." with "..v.." "..plural.."\n")
                            end

                            if index == 3 then
                                thirdworstzeta:SetText("Third Most Killed Zeta: "..k.." with "..v.." "..plural.."\n")
                                break
                            end
                            index = index + 1
                        end
                    end


                    
                    
                    


                    if zetastats["popularweapons"] then
                        local popularweapons = zetastats["popularweapons"]
                        local index = 1

                        
                        local ignoredweapons = {
                            ["Toolgun"] = true,
                            ["Physics Gun"] =  true,
                            ["Grenade"] = true,
                            ["Smoke Grenade"] = true,
                            ["Flashbang Grenade"] = true,
                            ["Holster"] = true                          
                        }

                        for k,v in SortedPairsByValue( popularweapons, true ) do
                            if ignoredweapons[k] then continue end -- Certain weapons need to be ignored
                            if index == 1 then
                                firstweapon:SetText("Most Popular Weapon: "..k.."\n")
                            end

                            if index == 2 then
                                secondweapon:SetText("Second Popular Weapon: "..k.."\n")
                            end

                            if index == 3 then
                                thirdweapon:SetText("Third Popular Weapon: "..k.."\n")
                                break
                            end
                            index = index + 1
                        end

                        scroll = vgui.Create("DScrollPanel")
                        scroll:SetSize(400,400)
                        panel:AddItem(scroll)

                        local lab = vgui.Create("DLabel",scroll)
                        lab:SetText("-- Weapon Use Counts --")
                        lab:Dock( TOP )
                        lab:DockMargin( 0, 0, 0, 5 )
                        scroll:AddItem(lab)

                        for k,v in SortedPairsByValue(popularweapons,true) do
                            local lab = vgui.Create("DLabel",scroll)
                            lab:SetText("   "..k..": "..v)
                            lab:Dock( TOP )
                            lab:DockMargin( 0, 0, 0, 5 )
                            scroll:AddItem(lab)
                        end

                        local lab = vgui.Create("DLabel",scroll)
                        lab:SetText("-- ---------- --")
                        lab:Dock( TOP )
                        lab:DockMargin( 0, 0, 0, 5 )
                        scroll:AddItem(lab)

                    end


                end

                local newline = panel:Help("\n\n")
                
                local refresh = vgui.Create("DButton")
                panel:AddItem(refresh)
                refresh:SetText("Refresh")
    
                function refresh:DoClick()

                    if IsValid(scroll) then
                        scroll:Remove()
                    end

                    newline:Remove()
                    refresh:Remove()
                    BuildStats()
                end
            end

            BuildStats()




        end)

    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_combatpermissions', 'Combat Options', "", "", function(panel) 
        panel:Help('Ignore Players (ai_ignoreplayers) will make Zetas not attack players.')

            panel:CheckBox('Allow Random attacking','zetaplayer_allowattacking')
            panel:ControlHelp('If the Zeta is allowed to randomly attack people')
            
            panel:CheckBox('Allow Self Defense','zetaplayer_allowselfdefense')
            panel:ControlHelp('If the Zeta should be able to defend itself if it currently has a lethal weapon')

            panel:CheckBox('Allow Defending Others','zetaplayer_allowdefendothers')
            panel:ControlHelp('If Zetas should Help other Zetas or Players from something that is attacking them')

            panel:CheckBox("Enable Experimental Combat Behaviour", "zetaplayer_experimentalcombat")
            panel:ControlHelp("Enables the experimental combat behavior for zetas. This makes them take cover if they're low on ammo, strafe more aggresive and etc.")
            panel:ControlHelp("The reason why this is a toggleable feature is because it might cause some performance issues")
            panel:ControlHelp("More features might come with updates such as avoiding grenades and optimizations")
            

            panel:NumSlider( 'Panic Threshold', 'zetaplayer_panicthreshold', 0, 1,2 )
            panel:ControlHelp('If health is below this percentage of health, the Zeta will have a chance to panic. Setting this to 0 disables panic\n\n(0.5 is the same as 50% 1 is the same as 100%)')

            panel:CheckBox('Allow Panic Bhop','zetaplayer_allowpanicbhop')
            panel:ControlHelp('If Zetas panicking should bhop while running')

            panel:CheckBox('Flee from Sanic Type Nextbots','zetaplayer_fleefromsanics')
            panel:ControlHelp("If Zetas should run away from sanic type nextbots")

            panel:CheckBox('Flee from DRG Nextbots','zetaplayer_fleefromdrgbasenextbots')
            panel:ControlHelp("If Zetas should run away from DRG nextbots")
            

            panel:CheckBox('Ignore other Zetas','zetaplayer_ignorezetas')
            panel:ControlHelp('If Zetas should ignore each other')

            panel:CheckBox('Ignore Friendly Fire by other Zetas', 'zetaplayer_ignorefriendlyfirebyzeta')
            panel:ControlHelp('If Zetas should ignore friendly fire caused by other zeta')

            panel:CheckBox('Allow Strafing','zetaplayer_allowstrafing')
            panel:ControlHelp('If Zetas should strafe when attacking something')

--[[             panel:CheckBox('Allow Directing Missiles','zetaplayer_allowdirectingmissiles')
            panel:ControlHelp('If Zetas are able to direct their missiles')

            panel:NumSlider('Missile Inaccuracy','zetaplayer_missileinaccuracy',0,5000,0)
            panel:ControlHelp('The inaccuracy of directed missiles') ]]

            panel:CheckBox('Real Player-like Damage Scaling', 'zetaplayer_userealplayerdmgscale')
            panel:ControlHelp("If damage dealt to Zetas should scale like the real players one do.")     

            panel:NumSlider('Accuracy Level','zetaplayer_combataccuracylevel',0,4,0)
            panel:ControlHelp('How accurate can a Zeta be. 1 is least accurate and 4 is the most accurate. Set to 0 for random accuracy between Zetas')
            
            panel:NumSlider('Damage divider ','zetaplayer_damagedivider',1,10,0)
            panel:ControlHelp('The amount damage should be divided by')

            panel:NumSlider('Armor Absorption Percent','zetaplayer_armorabsorbpercent', 1, 100, 0)
            panel:ControlHelp("How much percent of the damage should zeta's armor absorb")

            panel:NumSlider("Damage Force Add","zetaplayer_forceadd",0,10000,0)
            panel:ControlHelp('The amount to add on to Damage Force. Essentially makes dead bodies fly further when shot by bullets')


            panel:CheckBox('Always Hunt','zetaplayer_alwayshuntfortargets')
            panel:ControlHelp('If Zetas should always hunt for a target to attack when they try to find something to attack')

            panel:CheckBox('Always Target NPCs','zetaplayer_alwaystargetnpcs')
            panel:ControlHelp('If Zetas should always attack npcs regardless of combat chance')

            panel:NumSlider('Grenade Throw Chance', 'zetaplayer_grenade_throwchance', 1, 100, 0)
            panel:ControlHelp('The chance of Zetas to throw a grenade while in-combat or panicking')

            panel:CheckBox('Switch to Throw Grenade', 'zetaplayer_grenade_switchtoweapon')
            panel:ControlHelp('If the Zetas should switch to the grenade weapon in order to throw it instead of using the quicknade method')
            
            
    end)

    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_spawnmenupermissions', 'Building/Spawning Options', "", "", function(panel) 

            panel:CheckBox('Allow Spawning of Props','zetaplayer_allowprops')
            panel:ControlHelp('If Zetas are allowed to spawn props' )

            panel:CheckBox('Allow Medkits','zetaplayer_allowmedkits')
            panel:ControlHelp('If Zetas are allowed to spawn medkits to heal themselves or others' )

            panel:CheckBox('Allow Armor Batteries','zetaplayer_allowarmorbatteries')
            panel:ControlHelp('If Zetas are allowed to spawn armor batteries to charge themselves or others' )
            

            panel:CheckBox('Allow Spawning of Entities','zetaplayer_allowentities')
            panel:ControlHelp('If the Zeta is allowed to spawn Entities. This is off by default' )

            panel:CheckBox('Allow Spawning of NPCS','zetaplayer_allownpcs')
            panel:ControlHelp('If the Zeta is allowed to spawn NPCs. This is off by default' )

            panel:CheckBox('Allow Vehicles','zetaplayer_allowvehicles')
            panel:ControlHelp('If Zetas are allowed to drive or sit in vehicles')

            panel:NumSlider( 'Prop Limit', 'zetaplayer_proplimit', 1, 5000,0 )
            panel:NumSlider( 'SENT Limit', 'zetaplayer_sentlimit', 1, 200,0 )
            panel:NumSlider( 'NPC Limit', 'zetaplayer_npclimit', 1, 100,0 )

            panel:Help("------ Building System ------")

            panel:CheckBox("Allow Duplications", "zetaplayer_building_allowduplications")
            panel:ControlHelp("If Zetas are allowed to spawn/build duplications.\n\nNote that dupes will be effected by the prop limit!\n\nThis requires the Toolgun and Physics Gun to be allowed!")

            panel:CheckBox("Use Your Dupes", "zetaplayer_building_useplayerdupes")
            panel:ControlHelp("If Zetas are allowed to use any and all dupes you have. Turn this off if you wish for them to only use dupes from the zetaplayerdata/duplications folder")

            panel:CheckBox("Place Dupes In Open Areas","zetaplayer_building_placedupesinopenareas")
            panel:ControlHelp("If Zetas should try to place dupes in more open areas")

            panel:CheckBox("No Collide Entities", "zetaplayer_building_nocollideprops")
            panel:ControlHelp("If Zetas manually building a dupe should no collide their props or entities before placing them into position")

            panel:CheckBox("Allow Adding Onto Props","zetaplayer_building_allowaddingontoprops")
            panel:ControlHelp("If Zetas are allowed to place props on other props and weld them")


            
            panel:NumSlider("Dupe Build Mode","zetaplayer_building_dupebuildmode",0,2,0)
            panel:ControlHelp("How should the zetas build dupes\n\n0 is for random between manual building and toolgun spawned dupes\n1 is for manual building only\n2 is for toolgun spawned dupes only")

            panel:NumSlider("Dupe Cooldown","zetaplayer_building_dupecooldown",0,1000,0)
            panel:ControlHelp("The time in seconds before a zeta can place another dupe")

            panel:Help("\n\n")

            panel:TextEntry("Build Constraint Sound","zetaplayer_building_buildconstraintsound")
            panel:ControlHelp("The Sound that will play when a Constraint is created in a dupe")

            panel:TextEntry("Build Entity Sound","zetaplayer_building_buildentitysound")
            panel:ControlHelp("The Sound that will play when a Entity is created in a dupe")

            panel:TextEntry("Dupe Finish Sound","zetaplayer_building_finishdupesound")
            panel:ControlHelp("The Sound that will play when a dupe is completed")
            



            panel:Help("------ ---------- ------")

            panel:CheckBox('Allow Use+ on Props','zetaplayer_allowuse+onprops')
            panel:ControlHelp('If Zetas are allowed to use a simulated use+ pickup on props' )


            panel:CheckBox('Allow Sprays','zetaplayer_allowsprays')
            panel:ControlHelp("If Zetas are allowed to use Sprays. To add sprays, go into this path, Garrysmod/garrysmod/data/zetaplayerdata/custom_sprays\nInside that folder is where you can put .PNG and .JPG images in. You do not have to have specific names | Community Contribute")
            
            panel:CheckBox('Player Sized Sprays','zetaplayer_playersizedsprays')
            panel:ControlHelp("If Sprays should have the same size as a real player's spray. Turn this off for the old method ")
            
            panel:CheckBox('Server Junk','zetaplayer_serverjunk')
            panel:ControlHelp("If Props should spawn on the map when you first load into a map. Only works in singleplayer and requires a Navigation Mesh!")

            panel:CheckBox('Freeze server Junk','zetaplayer_freezeserverjunk')
            panel:ControlHelp("If server junk should spawn frozen")
            
            panel:NumSlider("Prop count","zetaplayer_serverjunkcount",1,400,0)
            panel:ControlHelp("How many props should be spawned by Server junk")
            
            panel:Button("Create Server Junk","zetaplayer_createserverjunk")
            panel:ControlHelp("Spawn junk around the map. The amount is determined by Prop Count")

            
            panel:CheckBox('Allow Physgun On Non World','zetaplayer_allowphysgunnonworld')
            panel:ControlHelp('If the Zeta is allowed to physgun non world ents such as player spawned props and ect')

            panel:CheckBox('Allow Physgun On World','zetaplayer_allowphysgunworld')
            panel:ControlHelp('If the Zeta is allowed to physgun world ents. Off by default due to allowing them this can be destructive. Turn this back on if you want some fun though')

            panel:CheckBox('Allow Physgun On Players','zetaplayer_allowphysgunplayers')
            panel:ControlHelp('If the Zeta is allowed to physgun players. Off by default due to allowing them this is a powerful ability. Turn this back on if you want some fun though')

            panel:CheckBox('Allow Physgun On other Zetas','zetaplayer_allowphysgunzetas')
            panel:ControlHelp('If the Zeta is allowed to physgun other Zetas')
            

            panel:CheckBox('Props Spawn Unfrozen','zetaplayer_propspawnunfrozen')
            panel:ControlHelp('If large props spawned by Zetas should spawn unfrozen. This will cause more lag! NOTE: Freeze Large Props will still freeze large props! Turn it off if you want ALL props to spawn unfrozen')

            panel:CheckBox('Allow Large Props','zetaplayer_allowlargeprops')
            panel:ControlHelp('If the Zeta is allowed to spawn large props')
            
            panel:CheckBox('Freeze Large Props','zetaplayer_freezelargeprops')
            panel:ControlHelp('If large props spawned by Zetas should spawn frozen. This is to help with lag')

            panel:CheckBox('Remove Props/Ents On Death','zetaplayer_removepropsondeath')
            panel:ControlHelp("If a Zeta's props and entities should be removed upon removal or death. NOTE: Only newly created props/ents from Zetas will be effected by this changed. You probably shouldn't touch this unless you want their props to be saved. Unchecking this may cause a build up in lag")


            
            panel:Button('Cleanup Zeta Entities','zetaplayer_cleanupents',LocalPlayer())
            panel:ControlHelp("Cleanup Entities spawned by Zetas")

            panel:Button('Cleanup Zeta Players','zetaplayer_cleanupzetaplayers',LocalPlayer())
            panel:ControlHelp("Remove all currently spawned Zeta Players")
    end)


--[[         local names = file.Read("zetaplayerdata/names.json")
        local news = file.Read("zetaplayerdata/rgsn.json")
        local rndzeta
        if news then
            newstbl = util.JSONToTable(news)
            if rndevent then
                rndevent = newstbl[math.random(#newstbl)]
            end
        end
        if names then
            nametbl = util.JSONToTable(names)
            if nametbl then
                rndzeta = nametbl[math.random(#nametbl)]
            end
        end ]]


    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_aboutpage', 'About and Credits', "", "", function(panel) 
        panel:Help('---- Zeta Players ----\n-- Created by StarFrost --')

        panel:Help("Current Release Version: 5.3.5")

        panel:Help("Current Development Stage: Completed\n\nMarch 5th, 2022 the day when Zeta Players were released to the public and now it has been several months from that day with the last on schedule update. Since then, the Zeta's have received a total of 197 updates including this update. I have kept my promise that I would complete the Zetas by reaching the Building System update. Thank you for being with me on this journey\n\nThis does not mean there will no longer be updates. Updates will only come if I feel like adding new stuff to the Zetas.")

        local Portal_EndingThing_Thankyou = panel:Help("\n\nThis was a triumph\nI'm making a note here, Huge Success.\nIt's hard to overstate my satisfaction.\nZeta Players.\nWe screw around because we can.\nFor the satisfaction of playing sandbox, except the ones who play other modes.\nBut there's no sense crying over every troll.\nYou just keep on playing 'til you run out of energy.\nAnd the builds gets done, and you make a neat gun.\nFor the people who are having fun\n\n")
        Portal_EndingThing_Thankyou:SetColor(Color(255,238,0))

        panel:Help("StarFrost's Youtube Page: https://www.youtube.com/channel/UCu_7jXrDackiI85ABzd0CKA")

        panel:Help("Join the Zeta's Domain Discord Server for receiving notifications on Zeta Updates and more!\nhttps://discord.gg/PHU86wcb2v")

        panel:Help("Special Thanks to,\n:\n:* Everyone who has provided error reports, suggestions and support for the Zetas and me!\n:\n:* Erma202 for many talented contributes to the Zetas!\n:\n:*Pyri for contributing to the Zetas with many weapons!\n:\n:*You for playing Sandbox with the Zetas\n:\n:* Based Kleiner for being the best Zeta\n:\n:* PaperClip's MingeBag E2 for sparking the inspiration back in 2016")

        local epicpeople = panel:Help("\n\nEven more Special Thanks to,\n\n:- cots\n\n:- Knocky\n\n:- Fewxay\n\n:- SlimyPinkSlime\n\n:- Alteff\n\n For being kind enough to donate some of their money towards me. Thank You!")
        epicpeople:SetColor(Color(0,255,242))
--[[ 
            if rndzeta and newstbl then
                panel:Help("\n\n------ Random Game Session News ------")
                panel:Help(tostring(rndzeta).." "..rndevent)


                rndevent = newstbl[math.random(#newstbl)]
                rndzeta = nametbl[math.random(#nametbl)]

                panel:Help(tostring(rndzeta).." "..rndevent)

                rndevent = newstbl[math.random(#newstbl)]
                rndzeta = nametbl[math.random(#nametbl)]

                panel:Help(tostring(rndzeta).." "..rndevent)
            end
 ]]
        
    end)

    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_debugtools', 'DEBUG TOOLS', "", "", function(panel) 
        panel:Help('--- DEBUG TOOLS ---')

        panel:CheckBox('Enable Debug','zetaplayer_debug')
        panel:ControlHelp('Enables Debug text')

        panel:CheckBox('Enable Developer','developer')
        panel:ControlHelp("Enables Source's Developer mode.\n\nUsed to see Debug Overlays from the Zetas")

        panel:CheckBox('Enable Rapid State Change Warnings','zetaplayer_debug_warnrapidstatechange')
        panel:ControlHelp('If zetas that rapidly change states should have a warning. Rapid state changes from a single zeta should be disregarded if the amount is below 4.\n\nReport constant rapid state changes with debug info of the zeta using the Debug Tool')

        panel:CheckBox('Display Initialize Time','zetaplayer_debug_displayspawntime')
        panel:ControlHelp('Displays the amount of time it took for a zeta to start their AI')
        

        panel:CheckBox('Display Pathfinding Paths','zetaplayer_debug_displaypathfindingpaths')
        panel:ControlHelp('If Pathfinding paths Zetas use for navigating should be drawn')
        
    end)

    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_gensets', 'General Zeta Settings', "", "", function(panel) 

        panel:Help("---- Spawner Settings ----\n")

            panel:CheckBox('Spawners Save Identity','zetaplayer_zetaspawnersaveidentity')
            panel:ControlHelp("If Zeta Spawners should save their Zeta's identity. Turning this off will have random Zetas spawn again")

            panel:CheckBox( "Respawn at Player Spawns", "zetaplayer_zetaspawnerspawnatplayerspawns" )
            panel:ControlHelp("If Spawners should respawn their Zetas at player spawn points. (info_player_starts)")

            panel:NumSlider('Spawner Spawn Time','zetaplayer_zetaspawnerrespawntime',0,120,2)
            panel:ControlHelp("The time Respawning Zetas should respawn after death")

            

        panel:Help("---- ---------- ----\n")

        panel:NumSlider("Spawning Health", "zetaplayer_zetahealth", 1, 10000, 0)
        panel:ControlHelp("The amount of health Zetas should spawn with")

        panel:NumSlider("Spawning Armor", "zetaplayer_zetaarmor", 0, 10000, 0)
        panel:ControlHelp("The amount of armor Zetas should spawn with")

        panel:CheckBox('Draw Flashlights','zetaplayer_drawflashlight')
        panel:ControlHelp('If Zeta Flashlights should draw')

        panel:CheckBox('Use Custom Profile Pictures','zetaplayer_usecustomavatars')
        panel:ControlHelp("If Zetas are able to use images from custom_avatars as their profile pictures")

        panel:CheckBox('No Repeating Profile Pictures','zetaplayer_norepeatingpfps')
        panel:ControlHelp("If Profile Pictures should not be re-used | Community Contribute")

        panel:CheckBox('Show Profile Pictures in Tab Menu','zetaplayer_showprofilepicturesintab')
        panel:ControlHelp("If the Tab display should show Zeta Profile Pictures")

        panel:CheckBox('Show Profile Pictures in display info','zetaplayer_showpfpoverhealth')
        panel:ControlHelp("If Zetas should show their profile picture when you hover over them")

        panel:CheckBox('Call OnNPCKilled Hook on death','zetaplayer_callonnpckilledhook')
        panel:ControlHelp("If killed Zetas should call the OnNPCKilled hook. This is used to work with custom killfeeds and other addons. However, Zeta names will not show up properly with this")

        panel:CheckBox('Drop Weapon','zetaplayer_dropweapons')
        panel:ControlHelp("If Zetas should drop their weapon. Note, the dropped weapon is a prop_physics")

        panel:CheckBox('Enable Drowning','zetaplayer_enabledrowning')
        panel:ControlHelp("If Zetas should drown in water")

        panel:NumSlider('Water Air Time', 'zetaplayer_waterairtime', 1, 60, 0)
        panel:ControlHelp("The amount of time zeta can swim in water before starting to drown")

        panel:CheckBox('Enable Fall Damage','zetaplayer_allowfalldamage')
        panel:ControlHelp('If Zeta should take fall damage')
        
        panel:CheckBox('Enable Realistic Fall Damage','zetaplayer_allowrealisticfalldamge')
        panel:ControlHelp('If Zetas should take realistic fall damage. Note, Fall damage must be on for this to apply')

        panel:CheckBox('Trigger Combine Mines','zetaplayer_triggermines')
        panel:ControlHelp("Makes Zetas trigger nearby Combine Mines to explode | Community Contribute")

        panel:NumSlider('Mine Hop Time','zetaplayer_triggermines_hoptime',0,5,2)
        panel:ControlHelp("Time required for the mine to jump at its target after being triggered")


        panel:CheckBox('Use Profile System','zetaplayer_useprofilesystem')
        panel:ControlHelp("If a Zeta should use their profile from profiles.json if they have one")

        panel:CheckBox('Profiles only','zetaplayer_profilesystemonly')
        panel:ControlHelp("If the Zetas should only spawn using the profiles if possible")

        panel:NumSlider( "Profile Use Chance", "zetaplayer_profileusechance", 0, 100, 0)
        panel:ControlHelp("The chance a Zeta will spawn using a profile. Use this if you want profile zetas to show up more without Profiles Only option")



        panel:CheckBox('Allow Media Request','zetaplayer_allowrequestmedia')
        panel:ControlHelp("If Zetas are allowed to request videos on a Media Player")
     
        panel:CheckBox('Allow Kill Binds', 'zetaplayer_allowkillbind')
        panel:ControlHelp("If Zetas are allowed to use their kill binds to kill themselves")

        panel:CheckBox('Casual Looking', 'zetaplayer_casuallooking')
        panel:ControlHelp("If Zetas should look around more like a player. Example being a Zeta facing somewhere or at something while moving.")
    


        


        panel:CheckBox("Allow Panic On Fire", 'zetaplayer_paniconfire')
        panel:ControlHelp("If Zetas are on fire, they will panic")

            panel:CheckBox('Allow Disconnecting','zetaplayer_allowdisconnecting')
            panel:ControlHelp('If Zetas are able to disconnect from your game')

            panel:NumSlider("Max Disconnect Time","zetaplayer_maxdisconnecttime",0,3600,0)
            panel:ControlHelp('The max of random time in seconds it will take before a Zeta decides to disconnect.\n\n600 is 10 minutes\n1800 is 30 minutes\n3600 is 1 hour')
            
            panel:CheckBox('Enable Name Display','zetaplayer_displayzetanames')
            panel:ControlHelp('If Zetas should display their name when you look at them')
            
            panel:CheckBox('Display Armor','zetaplayer_displayarmor')
            panel:ControlHelp("If Zetas should display their armor when you hover over them")
            
            panel:CheckBox('Player Color Based Display Color','zetaplayer_playercolordisplaycolor')
            panel:ControlHelp("If display name colors should be based on the Zeta's Playermodel Color")
            
            panel:CheckBox('Rainbow Name Display','zetaplayer_displaynamerainbow')
            panel:ControlHelp("If the Zeta's name should change color linearly")
            
            panel:Help('You can change the color of their name display below')
            local colorpanel = vgui.Create('DColorMixer')
            panel:AddItem(colorpanel)
            colorpanel:SetParent(panel)
            colorpanel:SetConVarR('zetaplayer_displaynameRed')
            colorpanel:SetConVarG('zetaplayer_displaynameGreen')
            colorpanel:SetConVarB('zetaplayer_displaynameBlue')
        
    end)

    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_util', 'Utilities', "", "", function(panel) 

        panel:CheckBox('Disable Thinking','zetaplayer_disabled')
        panel:ControlHelp('Disable Zeta from thinking')

        panel:CheckBox('Enable Console Logging','zetaplayer_consolelog')
        panel:ControlHelp('If Zeta Events should be logged in console. Mimics the logging you see when real players spawn things or dies')

        panel:CheckBox('Show Logging on Screen','zetaplayer_showzetalogonscreen')
        panel:ControlHelp('If Zeta Events should show up on screen. Console Logging must be on for this to function!')

        panel:CheckBox('Enable Corpse Cleanup','zetaplayer_cleanupcorpse')
        panel:CheckBox('Enable Corpse Cleanup Effect','zetaplayer_cleanupcorpseeffect')
        panel:NumSlider( 'Clean Up Time', 'zetaplayer_cleanupcorpsetime', 1, 190,0 )
        panel:ControlHelp('Enable the Corpse cleanup. Clean Up effect is the effect when a corpse is about to be removed this is purely optional. Clean Up time is the time before a corpse gets cleaned')

        panel:CheckBox('Explosive Corpse Cleanup','zetaplayer_explosivecorpsecleanup')
        panel:ControlHelp('If Corpses should blow up when they are cleaned')

        panel:CheckBox('Kill on Touch Nodraw or Sky','zetaplayer_killontouchnodraworsky')
        panel:ControlHelp("If Zetas should die when they are touching a nodraw surface or sky surface")

        panel:CheckBox("Disable Player Collisions", 'zetaplayer_noplycollisions')
        panel:ControlHelp("If Zetas are allowed to pass through Players.")  

        panel:Help("-- SERVER CACHE --")

        panel:Help("What is the SERVER CACHE?\n\nThe Server cache is a cache of data the Zetas use and create when they spawn. The purpose of the SERVER Cache is to prevent Zetas from creating the data over and over when they spawn. In theory, this is supposed to help with performance as all the Zetas would only use the SERVER CACHE if the option is enabled\n\nHowever, you must update the cache after you add new things to the listed data below.")


        panel:CheckBox("Use Server Cache Data", "zetaplayer_useservercacheddata")
        panel:ControlHelp('If Zetas should use the following data from the Server:\nNames\nProps\nEntities\nNPCs\nText Data\nMedia Data\nMaterials\nProfile Pictures\nPlayermodels with or without Playermodel Blocking')

        panel:Button("Update SERVER Cache","zetaplayer_updateservercache")
        panel:ControlHelp('Update the Cache to add any new additions')

        panel:Help("-- -- -- -- --")

        panel:Button('Auto Tweak Navigation Mesh','zetaplayer_autotweaknavmesh',LocalPlayer())
        panel:ControlHelp("This will edit the entire nav mesh to remove useless 2 way connections that confuse the Zetas sometimes. Save the nav mesh after using this.")
        panel:Button('Save Navigation Mesh','zetaplayer_savenavmesh',LocalPlayer())
    end)


    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_movement', 'Movement Options', "", "", function(panel) 

        panel:NumSlider( 'Wander Distance', 'zetaplayer_wanderdistance', 500, 15000,0 )
        panel:ControlHelp("The Distance that Zetas are allowed to wander within\n\nWarning! Setting this too high may crash your game if your pc isn't strong enough! Value of 1500 or lower is recommended. If you are crashing, try lowering the value")

        panel:CheckBox('Allow Noclip', 'zetaplayer_allownoclip')
        panel:ControlHelp("If Zetas are allowed to no clip")

        panel:NumSlider("Walk Speed","zetaplayer_walkspeed",100,1500,0)
        panel:ControlHelp('Walk movement speed Zetas should walk at')

        panel:NumSlider("Run Speed","zetaplayer_runspeed",100,1500,0)
        panel:ControlHelp('Run movement speed Zetas should walk at')

        panel:CheckBox('Ignore Small Nav Areas','zetaplayer_ignoresmallnavareas')
        panel:ControlHelp("Zetas will not favor going to smaller nav areas when this is enabled. Turn this on if you don't want Zetas constantly staying near a certain spot")

        panel:CheckBox('Dynamic Pathfinding','zetaplayer_usedynamicpathfinding')
        panel:ControlHelp("READ THIS BEFORE ENABLING!\n\nDynamic Pathfinding will cost more on performance due to the traces it conducts in order to figure out paths! This is is best used with low Zeta counts such as 4!\n\nIf Zetas should try to dynamically pathfind around objects and find alternate routes if blocked.\nThis system is not perfect and is as good as it will get!")

        panel:CheckBox('Clear Path','zetaplayer_clearpath')
        panel:ControlHelp("If Zetas with lethal weapons should attack a breakable object that blocks their way. Zetas with toolguns can use the remover tool to also remove a object in their way")

        panel:CheckBox('Disable Unstuck','zetaplayer_disableunstuck')
        panel:ControlHelp("If Zetas should not try to get themselves unstuck. Normally you shouldn't touch this")

        panel:CheckBox('Disable Jumping','zetaplayer_disablejumping')
        panel:ControlHelp("If Zetas shouldn't jump over objects")

        panel:CheckBox('Allow DSteps Support', 'zetaplayer_allowdstepssupport')
        panel:ControlHelp("If Zetas should use DSteps' footstep sounds if its installed")     
        
    end)


    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_admin', 'Admin Enforcement', "", "", function(panel) 
        panel:Help('All settings and authority relating to the Admins are located here. This is singleplayer only!')

        panel:TextEntry("Override Model","zetaplayer_adminoverridemodel")
        panel:ControlHelp("Override the model of Admins.\n\nPut a model path here. You can add multiple model paths by adding a , between them.\nEXAMPLE: models/player/combine_soldier.mdl,models/player/breen.mdl")


        panel:CheckBox("Treat you as Owner","zetaplayer_admintreatowner")
        panel:ControlHelp("If Admins should treat you as the Owner and ignore any rule breaking you do")

        panel:CheckBox("Commands echo in chat","zetaplayer_adminprintecho")
        panel:ControlHelp("If Admins using commands should show up in chat")

        panel:CheckBox("Allow Noclip","zetaplayer_allowadminnoclip")
        panel:ControlHelp("If Admins are allowed to noclip even if the option is disabled in Movement Options")

        

        panel:CheckBox("Stick together","zetaplayer_adminshouldsticktogether")
        panel:ControlHelp("If Admins should stick together")

        panel:CheckBox("Force Spawn","zetaplayer_forcespawnadmins")
        panel:ControlHelp("If Zetas you spawn should be admins regardless if allow admins is on")

        panel:CheckBox("Allow Admins","zetaplayer_spawnasadmin")
        panel:ControlHelp("If Admins are able to spawn. The amount is controlled by Admin Count")
        


        panel:NumSlider("Admin Count","zetaplayer_admincount",1,100,0)
        

        

        panel:NumSlider("Strictness Min","zetaplayer_adminsctrictnessmin",0,100,0)
        panel:NumSlider("Strictness Max","zetaplayer_adminsctrictnessmax",0,100,0)
        panel:ControlHelp("How strict and harsh should admins treat a offender. Values are picked randomly between Min and Max\n\nValues closer to 100 is more harsh and values closer to 0 is more chill")

        panel:Help('Admin Name Display')
        local colorpanel = vgui.Create('DColorMixer')
        panel:AddItem(colorpanel)
        colorpanel:SetParent(panel)
        colorpanel:SetConVarR('zetaplayer_admindisplaynameRed')
        colorpanel:SetConVarG('zetaplayer_admindisplaynameGreen')
        colorpanel:SetConVarB('zetaplayer_admindisplaynameBlue')

        panel:Help('---- ADMIN COMMANDS ----')

        panel:CheckBox("Allow God Mode","zetaplayer_adminallowgodmode")
        panel:ControlHelp("If Admins are allowed to enter God Mode")

        panel:CheckBox("Allow Set Health","zetaplayer_adminallowsethealth")
        panel:ControlHelp("If Admins are allowed to set their health")

        panel:CheckBox("Allow Set Armor","zetaplayer_adminallowsetarmor")
        panel:ControlHelp("If Admins are allowed to set their armor")

        panel:CheckBox("Allow Goto","zetaplayer_adminallowgoto")
        panel:ControlHelp("If Admins are allowed to teleport to anyone")

        panel:CheckBox("Allow Set Pos","zetaplayer_adminallowsetpos")
        panel:ControlHelp("If Admins are allowed to teleport to somewhere random")

            
        
        panel:Help('---- ENFORCED RULES ----')

        panel:CheckBox("No Prop Killing","zetaplayer_adminrule_nopropkill")
        panel:ControlHelp("If Admins should deal with a offender who prop killed")

        panel:CheckBox("No RDM","zetaplayer_adminrule_rdm")
        panel:ControlHelp("If Admins should deal with a offender who randomly killed someone or is randomly attacking")

        panel:CheckBox("No Griefing","zetaplayer_adminrule_griefing")
        panel:ControlHelp("If Admins should deal with a offender who altered someone else's prop or entity")
        

    end)


    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_force', 'Force Options', "", "", function(panel) 
        panel:Help('Pressing any of these buttons will force a Zeta to do any action.\n\n NOTE: Some options may have a cooldown.')

            panel:NumSlider("Force Radius Range","zetaplayer_forceradius",150,10000,0)
            panel:ControlHelp('If the Zeta is in range, they will be affected. 700 is the default value.')
            
            panel:Help('---------------------------------------------------------------')
            panel:ControlHelp('Panic Force Options')
            
            panel:Button('Make all nearby Zetas panic around you','zetaplayer_force_panicaroundplayer',LocalPlayer())
            panel:ControlHelp('Zetas will panic if you are around them, even through the level geometry.')

            panel:Button('Make all Zetas panic in view','zetaplayer_force_panicinviewofplayer',LocalPlayer())
            panel:ControlHelp('Zetas will panic if they see you.')

            panel:Help('---------------------------------------------------------------')
            panel:ControlHelp('Combat Force Options')

            panel:Button('Make all nearby Zetas attack you','zetaplayer_force_targetplayer',LocalPlayer())
            panel:ControlHelp('All Zetas will attack you.')

            panel:Button('Make all nearby Zetas attack other Zetas','zetaplayer_force_targetzeta',LocalPlayer())
            panel:ControlHelp('All Zetas will attack other zetas.')


            panel:Help('---------------------------------------------------------------')
            panel:ControlHelp('Miscellaneous Force Options')

            panel:Button('Make all nearby Zetas laugh at you','zetaplayer_force_laughatplayer',LocalPlayer())
            panel:ControlHelp('All Zetas will bully you by laugh at you.')

            panel:Button('Kill all nearby Zetas around you','zetaplayer_force_killall',LocalPlayer())
            panel:ControlHelp('Kill all sons of bi- oh.. Kill all nearby Zetas.')

            panel:Help('---------------------------------------------------------------')
            panel:ControlHelp('Friend Force Options')

            panel:Button('Make all nearby Zetas befriend you','zetaplayer_force_befriendplayer',LocalPlayer())
            panel:ControlHelp('All Zetas nearby will be your friend. \n\n Note: This will not work if zetaplayer_allowfriendswithplayers is disabled.')
    end)
    

    spawnmenu.AddToolMenuOption( 'Zeta Player', 'Zeta Player', 'zeta_musicbox', 'Music Box Options', "", "", function(panel) 
        panel:Help('Changing these will update live for music boxes')

        panel:CheckBox('Custom Music Only','zetaplayer_custommusiconly')
        panel:ControlHelp('If Zeta Music Boxes should only play Custom Music from the custom_music folder')

        panel:CheckBox('Music Play Once','zetaplayer_musicplayonce')
        panel:ControlHelp('If Zeta Music Boxes should only play Music once and delete themselves after')

        

        panel:CheckBox('Music Shuffle','zetaplayer_musicshuffle')
        panel:ControlHelp('If Zeta Music Boxes should play random music')
        
        panel:NumSlider('Music Volume','zetaplayer_musicvolume',0,10,2)
        panel:ControlHelp('The Volume the music should play at')

        panel:NumSlider('Dance Chance','zetaplayer_dancechance',1,100,0)
        panel:ControlHelp('The Chance Zetas will dance to music')
        

        panel:CheckBox('Enable Visualizer','zetaplayer_enablemusicvisualizer')
        panel:ControlHelp('If Music Boxes should show a visualizer above them. This may decrease frames when there are multiple music boxes')

        panel:NumSlider('Visualizer Draw Distance','zetaplayer_visualizerrenderdistance',200,10000,0)
        panel:ControlHelp('The distance the Visualizer is allowed to render')

        
        panel:CheckBox('Visualizer Player Only','zetaplayer_visualizerplayeronly')
        panel:ControlHelp('If the Visualizers should only show on player spawned music boxes')
        

        panel:CheckBox('Draw Light Visualizer','zetaplayer_enabledynamiclightvisualizer')
        panel:ControlHelp('If Music Boxes should emit light based on the music. WARNING! THE LIGHT WILL FLASH A LOT! DO NOT USE THIS IF YOU ARE EPILEPTIC!')
        

        panel:NumSlider('Visualizer Resolution','zetaplayer_visualizerresolution',20,200,0)
        panel:ControlHelp('The resolution of the visualizer. Lower the value for more FPS')
        
        panel:NumSlider('FFT Sample Level','zetaplayer_musicvisualizersamples',0,7,0)
        panel:ControlHelp('The level of samples the visualizer will process while playing music. Each value will change how the visualizer will look. Values 4,5, and 6 are great choices')

        panel:CheckBox('Surpress Minor Warnings','zetaplayer_surpressminormusicwarnings')
        panel:ControlHelp("If minor warnings from the music boxes should be surpressed.\n\n Example being, Music Box Minor Warning: zetaplayer/custom_music/musicfile.mp3 Has a stereo channel. This means the sound won't be 3d. The sound file will continue to play")

    end)
        





end

local function CreateZetaSettings()
    spawnmenu.AddToolTab( "Zeta Player", "#Zeta Player", "icon/physgun.png" )
    spawnmenu.AddToolCategory( "Zeta Player", "Zeta Player", "Zeta's Options" )

end

hook.Add( "AddToolMenuTabs", "AddZetaTabs", CreateZetaSettings)
hook.Add("PopulateToolMenu","AddZetaOptionPanels",AddZetaOptions)

end