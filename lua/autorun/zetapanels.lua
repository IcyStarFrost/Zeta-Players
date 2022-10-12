-- Panels

local net = net


include("zeta/zetateampanel.lua")

if ( SERVER ) then

    -- Networked 

    util.AddNetworkString("zetapanel_sendprop")
    util.AddNetworkString("zetapanel_getprops")
    util.AddNetworkString("zetapanel_removeprop")

    util.AddNetworkString("zetapanel_sendnpc")
    util.AddNetworkString("zetapanel_getnpcs")
    util.AddNetworkString("zetapanel_removenpc")

    util.AddNetworkString("zetapanel_sendent")
    util.AddNetworkString("zetapanel_getents")
    util.AddNetworkString("zetapanel_removeent")

    util.AddNetworkString("zetapanel_getprofiles")
    util.AddNetworkString("zetapanel_sendprofile")
    util.AddNetworkString("zetapanel_removeprofile")
    util.AddNetworkString("zetapanel_compileprofiledata")

    util.AddNetworkString("zetapanel_changeinpanelstate")
    util.AddNetworkString("zetapanel_updatepanel")

    util.AddNetworkString("zetapanel_gettextdata")
    util.AddNetworkString("zetapanel_sendtextdata")
    util.AddNetworkString("zetapanel_removetext")
    util.AddNetworkString("zetapanel_addtext")

    util.AddNetworkString("zetapanel_getvotedata")
    util.AddNetworkString("zetapanel_sendvotedata")
    util.AddNetworkString("zetapanel_addvotedata")
    util.AddNetworkString("zetapanel_removevotedata")
    
    
    
    util.AddNetworkString("zetapanel_sendmediadata")
    util.AddNetworkString("zetapanel_getmediadata")
    util.AddNetworkString("zetapanel_removemedia")
    util.AddNetworkString("zetapanel_addmedia")



    util.AddNetworkString("zetapanel_getblockedmodels")
    util.AddNetworkString("zetapanel_sendblockedmodel")
    util.AddNetworkString("zetapanel_removeblockedmodel")
    util.AddNetworkString("zetapanel_addblockedmodel")

    util.AddNetworkString("zetapanel_getteamentdata")
    util.AddNetworkString("zetapanel_sendteamentdata")
    util.AddNetworkString("zetapanel_saveteamentdata")
    util.AddNetworkString("zetapanel_loadteamentdata")
    util.AddNetworkString("zetapanel_removeteamentdata")


        -- Name panel
        util.AddNetworkString('zetapanel_getnames')
        util.AddNetworkString('zetapanel_sendnames')
        util.AddNetworkString('zetapanel_resetnames')
        util.AddNetworkString('zetapanel_removename')
        util.AddNetworkString('zetapanel_addname')


    util.AddNetworkString("zetapanel_silentaddname")

    util.AddNetworkString("zetapanel_setpresetsserverside")
    ---------------------

    net.Receive('zetapanel_silentaddname',function(len,ply)
        if !ply:IsSuperAdmin() then return end
        local _string = net.ReadString()


            local json = file.Read("zetaplayerdata/names.json","DATA")
            local decoded = util.JSONToTable(json)
            if table.HasValue(decoded,_string) then return end
            ply:PrintMessage(HUD_PRINTTALK,"Added ".._string.." as a registered name")
            table.insert(decoded,_string)

            local encoded = util.TableToJSON(decoded,true)

            ZetaFileWrite("zetaplayerdata/names.json",encoded)
    end)


    net.Receive("zetapanel_saveteamentdata",function()
        _ZetaSaveTeamEntities(net.ReadString())
    end)

    net.Receive("zetapanel_removeteamentdata",function()
        file.Delete("zetaplayerdata/teamentdata/"..game.GetMap().."/"..net.ReadString()..".json")
    end)

    net.Receive("zetapanel_loadteamentdata",function()
        _ZetaReadAndInitializeTeamEnts("zetaplayerdata/teamentdata/"..game.GetMap().."/"..net.ReadString()..".json")
    end)

    net.Receive("zetapanel_getteamentdata",function(len,ply)
        local teamentfiles,dirs = file.Find("zetaplayerdata/teamentdata/"..game.GetMap().."/*","DATA")
        for k,files_ in ipairs(teamentfiles) do
            local isdone = false
            if k == #teamentfiles then
                isdone = true
            end
            net.Start("zetapanel_sendteamentdata")
            net.WriteString(string.StripExtension(files_))
            net.WriteBool(isdone)
            net.Send(ply)
        end
        if table.Count(teamentfiles) <= 0 then
            net.Start("zetapanel_sendteamentdata")
            net.WriteString("PLACEHOLDER")
            net.WriteBool(true)
            net.Send(ply)
        end
    end)


    function CreateZetaProfile(tbl)

        local profiles = file.Read("zetaplayerdata/profiles.json","DATA")
        local decoded = util.JSONToTable(profiles)

        decoded[tbl.name] = tbl

        local encoded = util.TableToJSON(decoded,true)

        ZetaFileWrite("zetaplayerdata/profiles.json",encoded)

    end

    net.Receive("zetapanel_changeinpanelstate",function(len,ply)
        ply.IsInZetaPanel = net.ReadBool()
    end)


    net.Receive("zetapanel_compileprofiledata",function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to add Profiles!') return end
    
        local profiledata = net.ReadString()
        local decodedDATA = util.JSONToTable(profiledata)

        CreateZetaProfile(decodedDATA)
    end)
    
    -- PROP PANEL

    hook.Add("PlayerSpawnProp","zetapanel_Addmodel",function(ply,mdl)
        if ply.IsInZetaPanel then
            if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to register props!') return false end
    
    
                local json = file.Read("zetaplayerdata/props.json","DATA")
                local decoded = util.JSONToTable(json)
                if table.HasValue(decoded,mdl) then
                     ply:PrintMessage(HUD_PRINTCONSOLE,mdl.." is already registered!")
                     net.Start('zeta_notifycleanup',true)
                     net.WriteString(mdl..' is already registered!')
                     net.WriteBool(true)
                     net.Send(ply)
                    return false 
                end
                table.insert(decoded,mdl)
                local encoded = util.TableToJSON(decoded,true)
                ZetaFileWrite("zetaplayerdata/props.json",encoded)
                ply:PrintMessage(HUD_PRINTCONSOLE,"Added "..mdl.." to Zeta's props")
    
                net.Start('zeta_notifycleanup',true)
                net.WriteString("Added "..mdl.." to Zeta's props")
                net.WriteBool(false)
                net.Send(ply)

                net.Start("zetapanel_updatepanel",true)
                    net.WriteString(mdl)
                net.Send(ply)

            return false
        end
    end)

    

    net.Receive('zetapanel_getprops',function(len,ply)
        local json = file.Read("zetaplayerdata/props.json","DATA")
        local tbl = util.JSONToTable(json)
        for k,prop in ipairs(tbl) do
            local isdone = false
            if k == #tbl then
                isdone = true
            end
            net.Start("zetapanel_sendprop")
            net.WriteString(prop)
            net.WriteBool(isdone)
            net.Send(ply)
        end
        if table.Count(tbl) <= 0 then
            net.Start("zetapanel_sendprop")
            net.WriteString("PLACEHOLDER")
            net.WriteBool(true)
            net.Send(ply)
        end
    end)

    net.Receive('zetapanel_removeprop',function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to remove props!') return end
        local _string = net.ReadString()
        
            local json = file.Read("zetaplayerdata/props.json","DATA")
            local decoded = util.JSONToTable(json)
            if !table.HasValue(decoded,_string) then ply:PrintMessage(HUD_PRINTCONSOLE,_string.." is not Registered!") return end
            table.RemoveByValue(decoded,_string)
            local encoded = util.TableToJSON(decoded,true)
            ZetaFileWrite("zetaplayerdata/props.json",encoded)
            ply:PrintMessage(HUD_PRINTCONSOLE,"Removed ".._string.." from Zeta's props")
    end)


    -- END PROP PANEL


    -- NPC PANEL

    hook.Add("PlayerSpawnNPC","zetapanel_Addnpc",function(ply,class)
        if ply.IsInZetaPanel then
            if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to register NPCs!') return false end
    
    
                local json = file.Read("zetaplayerdata/npcs.json","DATA")
                local decoded = util.JSONToTable(json)
                if table.HasValue(decoded,class) then
                     ply:PrintMessage(HUD_PRINTCONSOLE,class.." is already registered!")
                     net.Start('zeta_notifycleanup',true)
                     net.WriteString(class..' is already registered!')
                     net.WriteBool(true)
                     net.Send(ply)
                    return false 
                end
                table.insert(decoded,class)
                local encoded = util.TableToJSON(decoded,true)
                ZetaFileWrite("zetaplayerdata/npcs.json",encoded)
                ply:PrintMessage(HUD_PRINTCONSOLE,"Added "..class.." to Zeta's NPCs")
    
                net.Start('zeta_notifycleanup',true)
                net.WriteString("Added "..class.." to Zeta's NPCs")
                net.WriteBool(false)
                net.Send(ply)

                net.Start("zetapanel_updatepanel",true)
                    net.WriteString(class)
                net.Send(ply)

            return false
        end
    end)

    net.Receive("zetapanel_getnpcs",function(len,ply)
        local json = file.Read("zetaplayerdata/npcs.json","DATA")
        local tbl = util.JSONToTable(json)
        for k,npc in ipairs(tbl) do
            local isdone = false
            if k == #tbl then
                isdone = true
            end
            net.Start("zetapanel_sendnpc")
            net.WriteString(npc)
            net.WriteBool(isdone)
            net.Send(ply)
        end
        if table.Count(tbl) <= 0 then
            net.Start("zetapanel_sendnpc")
            net.WriteString("PLACEHOLDER")
            net.WriteBool(true)
            net.Send(ply)
        end
    end)

    net.Receive('zetapanel_removenpc',function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to remove NPCs!') return end
        local _string = net.ReadString()
        
            local json = file.Read("zetaplayerdata/npcs.json","DATA")
            local decoded = util.JSONToTable(json)
            if !table.HasValue(decoded,_string) then ply:PrintMessage(HUD_PRINTCONSOLE,_string.." is not Registered!") return end
            table.RemoveByValue(decoded,_string)
            local encoded = util.TableToJSON(decoded,true)
            ZetaFileWrite("zetaplayerdata/npcs.json",encoded)
            ply:PrintMessage(HUD_PRINTCONSOLE,"Removed ".._string.." from Zeta's NPCs")
    end)


    -- END NPC PANEL



    -- ENTS PANEL

    hook.Add("PlayerSpawnSENT","zetapanel_Addentity",function(ply,class)
        if ply.IsInZetaPanel then
            if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to register Entities!') return false end
    
    
                local json = file.Read("zetaplayerdata/ents.json","DATA")
                local decoded = util.JSONToTable(json)
                if table.HasValue(decoded,class) then
                     ply:PrintMessage(HUD_PRINTCONSOLE,class.." is already registered!")
                     net.Start('zeta_notifycleanup',true)
                     net.WriteString(class..' is already registered!')
                     net.WriteBool(true)
                     net.Send(ply)
                    return false 
                end
                table.insert(decoded,class)
                local encoded = util.TableToJSON(decoded,true)
                ZetaFileWrite("zetaplayerdata/ents.json",encoded)
                ply:PrintMessage(HUD_PRINTCONSOLE,"Added "..class.." to Zeta's Entities")
    
                net.Start('zeta_notifycleanup',true)
                net.WriteString("Added "..class.." to Zeta's Entities")
                net.WriteBool(false)
                net.Send(ply)

                net.Start("zetapanel_updatepanel",true)
                    net.WriteString(class)
                net.Send(ply)

            return false
        end
    end)

    net.Receive("zetapanel_getents",function(len,ply)
        local json = file.Read("zetaplayerdata/ents.json","DATA")
        local tbl = util.JSONToTable(json)
        for k,ent in ipairs(tbl) do
            local isdone = false
            if k == #tbl then
                isdone = true
            end
            net.Start("zetapanel_sendent")
            net.WriteString(ent)
            net.WriteBool(isdone)
            net.Send(ply)
        end
        if table.Count(tbl) <= 0 then
            net.Start("zetapanel_sendent")
            net.WriteString("PLACEHOLDER")
            net.WriteBool(true)
            net.Send(ply)
        end
    end)

    net.Receive('zetapanel_removeent',function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to remove Entities!') return end
        local _string = net.ReadString()
        
            local json = file.Read("zetaplayerdata/ents.json","DATA")
            local decoded = util.JSONToTable(json)
            if !table.HasValue(decoded,_string) then ply:PrintMessage(HUD_PRINTCONSOLE,_string.." is not Registered!") return end
            table.RemoveByValue(decoded,_string)
            local encoded = util.TableToJSON(decoded,true)
            ZetaFileWrite("zetaplayerdata/ents.json",encoded)
            ply:PrintMessage(HUD_PRINTCONSOLE,"Removed ".._string.." from Zeta's Entities")
    end)

    -- END ENTS PANEL


    -- PROFILE PANEL

    net.Receive("zetapanel_getprofiles",function(len,ply)

        local i = 1
        local json = file.Read("zetaplayerdata/profiles.json","DATA")
        local tbl = util.JSONToTable(json)

        for k,profile in pairs(tbl) do

            local isdone = false
            if i == table.Count( tbl ) then
                isdone = true
            end
            net.Start("zetapanel_sendprofile")
            net.WriteString(util.TableToJSON(profile))
            net.WriteBool(isdone)
            net.Send(ply)
            i = i + 1
        end

        if table.Count(tbl) <= 0 then
            net.Start("zetapanel_sendprofile")
            net.WriteString("[]")
            net.WriteBool(true)
            net.Send(ply)
        end
    end)

    net.Receive('zetapanel_removeprofile',function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to remove profiles!') return end
        local profile = net.ReadString()

        local tbl = util.JSONToTable(profile)
        
        local profilesfile = file.Read("zetaplayerdata/profiles.json","DATA")
        local profiles = util.JSONToTable(profilesfile)

        profiles[tbl["name"]] = nil


        local encode = util.TableToJSON(profiles,true)

        ZetaFileWrite("zetaplayerdata/profiles.json",encode)
        

    end)

    -- END PROFILE PANEL

    -- TEXT DATA PANEL

    net.Receive('zetapanel_removetext',function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to remove Text!') return end
        local text = net.ReadString()
        local position = net.ReadString()
        
        local TextDataJSON = file.Read("zetaplayerdata/textchatdata.json","DATA")
        local TextData = util.JSONToTable(TextDataJSON)

        table.RemoveByValue(TextData[position],text)


        local encode = util.TableToJSON(TextData,true)

        ZetaFileWrite("zetaplayerdata/textchatdata.json",encode)
        

    end)

    net.Receive('zetapanel_addtext',function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to add Text!') return end
        local text = net.ReadString()
        local position = net.ReadString()
        
        local TextDataJSON = file.Read("zetaplayerdata/textchatdata.json","DATA")
        local TextData = util.JSONToTable(TextDataJSON)

        table.insert(TextData[position],text) 


        local encode = util.TableToJSON(TextData,true)

        ZetaFileWrite("zetaplayerdata/textchatdata.json",encode)
        

    end)


    net.Receive("zetapanel_gettextdata",function(len,ply)

        local i = 1
        local json = file.Read("zetaplayerdata/textchatdata.json","DATA")
        local tbl = util.JSONToTable(json)
        local isdone = false
        local mainfinished = false

        for type_,interntbl in pairs(tbl) do

            if i == table.Count( tbl ) then
                mainfinished = true
            end

            for k,text in ipairs(interntbl) do
                if mainfinished then
                    if k == table.Count( interntbl ) then
                        isdone = true
                    end
                end
                net.Start("zetapanel_sendtextdata")
                net.WriteString(text)
                net.WriteString(type_)
                net.WriteBool(isdone)
                net.Send(ply)
                
            end


            i = i + 1
        end

        if table.Count(tbl) <= 0 then
            net.Start("zetapanel_sendtextdata")
            net.WriteString("")
            net.WriteString("")
            net.WriteBool(true)
            net.Send(ply)
        end
    end)

    -- END TEXT DATA PANEL 

    -- MEDIA PANEL 

    net.Receive("zetapanel_getmediadata",function(len,ply)
        local json = file.Read("zetaplayerdata/mediaplayerdata.json","DATA")
        local tbl = util.JSONToTable(json)
        for k,data in ipairs(tbl) do
            local isdone = false
            if k == #tbl then
                isdone = true
            end
            net.Start("zetapanel_sendmediadata")
            net.WriteString(util.TableToJSON(data))
            net.WriteBool(isdone)
            net.Send(ply)
        end
        if table.Count(tbl) <= 0 then
            net.Start("zetapanel_sendmediadata")
            net.WriteString("PLACEHOLDER")
            net.WriteBool(true)
            net.Send(ply)
        end
    end)

    net.Receive('zetapanel_addmedia',function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to add Media!') return end
        local mediadata = net.ReadString()
        mediadata = util.JSONToTable(mediadata)

        
        local MediaPlayerJSON = file.Read("zetaplayerdata/mediaplayerdata.json","DATA")
        local MediaPlayerData = util.JSONToTable(MediaPlayerJSON)

        table.insert(MediaPlayerData,mediadata) 


        local encode = util.TableToJSON(MediaPlayerData,true)

        ZetaFileWrite("zetaplayerdata/mediaplayerdata.json",encode)
        

    end)

    net.Receive('zetapanel_removemedia',function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to remove Media!') return end
        local mediadata = net.ReadString()
        mediadata = util.JSONToTable(mediadata)
        
        local MediaPlayerJSON = file.Read("zetaplayerdata/mediaplayerdata.json","DATA")
        local MediaPlayerData = util.JSONToTable(MediaPlayerJSON)

        for k,v in ipairs(MediaPlayerData) do

            if v[1] == mediadata[1] then
                table.remove(MediaPlayerData,k)
                break
            end
        end

        local encode = util.TableToJSON(MediaPlayerData,true)

        ZetaFileWrite("zetaplayerdata/mediaplayerdata.json",encode)

    end)


    -- END MEDIA PANEL

    -- BLOCKED MODELS PANEL

    net.Receive("zetapanel_getblockedmodels",function(len,ply)
        local json = file.Read("zetaplayerdata/blockedplayermodels.json","DATA")
        local tbl = util.JSONToTable(json)
        for k,mdl in ipairs(tbl) do
            local isdone = false
            if k == #tbl then
                isdone = true
            end
            net.Start("zetapanel_sendblockedmodel")
            net.WriteString(mdl)
            net.WriteBool(isdone)
            net.Send(ply)
        end
        if table.Count(tbl) <= 0 then
            net.Start("zetapanel_sendblockedmodel")
            net.WriteString("PLACEHOLDER")
            net.WriteBool(true)
            net.Send(ply)
        end
    end)


    net.Receive('zetapanel_removeblockedmodel',function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to remove Blocked models!') return end
        local _string = net.ReadString()
        
            local json = file.Read("zetaplayerdata/blockedplayermodels.json","DATA")
            local decoded = util.JSONToTable(json)
            table.RemoveByValue(decoded,_string)
            local encoded = util.TableToJSON(decoded,true)
            ZetaFileWrite("zetaplayerdata/blockedplayermodels.json",encoded)
            ply:PrintMessage(HUD_PRINTCONSOLE,"Removed ".._string.." from Blocked Models")
    end)


    net.Receive("zetapanel_addblockedmodel",function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to register Blocked Models!') return end

            local mdl = net.ReadString()
        
            local json = file.Read("zetaplayerdata/blockedplayermodels.json","DATA")
            local decoded = util.JSONToTable(json)
            if table.HasValue(decoded,mdl) then
                ply:PrintMessage(HUD_PRINTCONSOLE,mdl.." is already registered!")
                net.Start('zeta_notifycleanup',true)
                net.WriteString(mdl..' is already registered!')
                net.WriteBool(true)
                net.Send(ply)
                return 
            end
            table.insert(decoded,mdl)
            local encoded = util.TableToJSON(decoded,true)
            ZetaFileWrite("zetaplayerdata/blockedplayermodels.json",encoded)
            ply:PrintMessage(HUD_PRINTCONSOLE,"Added "..mdl.." to Blocked Models")

            net.Start('zeta_notifycleanup',true)
            net.WriteString("Added "..mdl.." to Blocked Models")
            net.WriteBool(false)
            net.Send(ply)
        
    end)
    

    -- END BLOCKED MODELS PANEL 


    -- Start Voting panel

    net.Receive("zetapanel_getvotedata",function(len,ply)
        local json = file.Read("zetaplayerdata/votingdata.json","DATA")
        local tbl = util.JSONToTable(json)
        for k,data in ipairs(tbl) do
            local isdone = false
            if k == #tbl then
                isdone = true
            end
            net.Start("zetapanel_sendvotedata")
            net.WriteString(util.TableToJSON(data))
            net.WriteBool(isdone)
            net.Send(ply)
        end
        if table.Count(tbl) <= 0 then
            net.Start("zetapanel_sendvotedata")
            net.WriteString("PLACEHOLDER")
            net.WriteBool(true)
            net.Send(ply)
        end
    end)

    net.Receive("zetapanel_addvotedata",function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to add Vote data!') return end

            local data = net.ReadString()
        
            local json = file.Read("zetaplayerdata/votingdata.json","DATA")
            local decoded = util.JSONToTable(json)
            local datadecode = util.JSONToTable(data)
        
            table.insert(decoded,datadecode)
            local encoded = util.TableToJSON(decoded,true)
            ZetaFileWrite("zetaplayerdata/votingdata.json",encoded)
            ply:PrintMessage(HUD_PRINTCONSOLE,"Added "..datadecode[1].." to Voting Data")

            net.Start('zeta_notifycleanup',true)
            net.WriteString("Added "..datadecode[1].." to Voting Data")
            net.WriteBool(false)
            net.Send(ply)
        
    end)

    net.Receive('zetapanel_removevotedata',function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to remove Voting Data!') return end
        local _string = net.ReadString()
        
            local json = file.Read("zetaplayerdata/votingdata.json","DATA")
            local decoded = util.JSONToTable(json)

            for k,v in ipairs(decoded) do
                if v[1] == _string then
                    table.remove(decoded,k)
                    break
                end
            end
            
            local encoded = util.TableToJSON(decoded,true)
            ZetaFileWrite("zetaplayerdata/votingdata.json",encoded)
            ply:PrintMessage(HUD_PRINTCONSOLE,"Removed ".._string.." from Voting Data")
    end)


    
    

    -- END VOTING PANEL
    

elseif ( CLIENT ) then


    local function InitializeCoroutineThread(func,warnend)
        local thread = coroutine.create(func)
        local id = math.random(1000000)
        hook.Add("Think","zetacoroutineengine"..id,function()
            if coroutine.status(thread) != "dead" then
                local result, msg = coroutine.resume(thread)

                if !result then
                    ErrorNoHalt(msg)
                end
            else
                hook.Remove("Think","zetacoroutineengine"..id)
                if warnend then
                    print("Coroutine Thread was returned!")    
                end
            end
        end)
    end



    local function GetSound(dir) 
        local mp3check = string.EndsWith(dir,".mp3")
        local wavcheck = string.EndsWith(dir,".wav")

        if mp3check or wavcheck then
            return dir
        end

        local files,dirs = file.Find("sound/"..dir,"GAME")
        local replace = dir
        pcall( function() replace = string.Replace((dir..files[math.random(#files)]),"*","") end )

        return replace
    end


    function OpenPropPanel()

        local props = {}

        net.Start('zetapanel_getprops')
        net.SendToServer()

        local starttime = CurTime()

        net.Receive('zetapanel_sendprop',function()
            local prop = net.ReadString()
            local isdone = net.ReadBool()

            if prop != "PLACEHOLDER" then
                table.insert(props,prop)
            end

            if isdone then -- Make the panel

                local sndchan

                if GetConVar("zetaplayer_panelbgm"):GetString() != "" then
                    sound.PlayFile("sound/"..GetSound(GetConVar("zetaplayer_panelbgm"):GetString()), "", function(chan,errorid,erroname)
                        if !IsValid(chan) then
                            notification.AddLegacy("Warning! BGM Sound failed to load! Make sure the file path is correct!",NOTIFY_ERROR,7)
                            return
                        end

                        sndchan = chan
                        sndchan:EnableLooping( true )
                        sndchan:SetVolume(0.3)
                    end)
                end


                net.Start("zetapanel_changeinpanelstate")
                net.WriteBool(true)
                net.SendToServer()

                notification.AddLegacy("Received all props! Took "..CurTime()-starttime.." seconds",NOTIFY_CLEANUP,4)
                local count = #props
                
                local frame = vgui.Create( 'DFrame' )
                frame:SetDeleteOnClose( true )
                frame:CenterHorizontal(0.3)
                frame:CenterVertical(0.4)
                frame:SetTitle('Zeta Prop Panel')
                frame:SetIcon( 'icon/physgun.png' )
                frame:SetSize(1000,500)
                frame:MakePopup()

                local label = vgui.Create( 'DLabel', frame )
                label:SetText('Welcome to the Prop Panel! There are '..count..' Props. Right click a model path in the list to the right to remove it')
                label:Dock(TOP)

                local label2 = vgui.Create( 'DLabel', frame )
                label2:SetText('Left click a model on the left to add it to the Zeta prop list')
                label2:Dock(TOP)


                local sheet = vgui.Create( "DPropertySheet", frame )
                sheet:SetSize(600,100)
                sheet:Dock( LEFT )

                local panellist = vgui.Create( 'DListView', frame )

                panellist:Dock(RIGHT)
                panellist:SetSize(400,300)
                panellist:AddColumn('Zeta Props',1)

                for k,v in ipairs(props) do
                    local line = panellist:AddLine(v)
                    line:SetSortValue( 1, v )
                end

                function panellist:OnRowRightClick(id,line)
                    net.Start('zetapanel_removeprop')
                    net.WriteString(line:GetSortValue(1))
                    net.SendToServer()
                    notification.AddLegacy('Removed '..line:GetSortValue(1)..' from Zeta props',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')
                    panellist:RemoveLine( id )
                    panellist:SetDirty( true )
                    count = count - 1
                    label:SetText('Welcome to the Prop Panel! There are '..count..' Props. Right click a model path in the list to the right to remove it')
                end

                net.Receive("zetapanel_updatepanel",function()
                    local npc = net.ReadString()

                    local line = panellist:AddLine(npc)
                    line:SetSortValue( 1, npc )
                    panellist:SetDirty( true )
                    count = count + 1
                    label:SetText('Welcome to the Prop Panel! There are '..count..' Props. Right click a model path in the list to the right to remove it')
                
                end)



                local panel = spawnmenu.GetCreationTabs()["#spawnmenu.content_tab"].Function()
                panel:SetParent( sheet )

                sheet:AddSheet("#spawnmenu.content_tab", panel, spawnmenu.GetCreationTabs()["#spawnmenu.content_tab"].Icon )


                function frame:OnClose() 
                    net.Start("zetapanel_changeinpanelstate")
                    net.WriteBool(false)
                    net.SendToServer()
                    if IsValid(sndchan) then
                    sndchan:Stop()
                    end

                end



            end

        end) -- End Net message


    end








    function OpenNPCPanel()

        local npcs = {}

        net.Start('zetapanel_getnpcs')
        net.SendToServer()

        local starttime = CurTime()

        net.Receive('zetapanel_sendnpc',function()
            local npc = net.ReadString()
            local isdone = net.ReadBool()

            if npc != "PLACEHOLDER" then
                table.insert(npcs,npc)
            end

            if isdone then -- Make the panel

                if GetConVar("zetaplayer_panelbgm"):GetString() != "" then
                    sound.PlayFile("sound/"..GetSound(GetConVar("zetaplayer_panelbgm"):GetString()), "", function(chan,errorid,erroname)
                        if !IsValid(chan) then
                            notification.AddLegacy("Warning! BGM Sound failed to load! Make sure the file path is correct!",NOTIFY_ERROR,7)
                            return
                        end

                        sndchan = chan
                        sndchan:EnableLooping( true )
                        sndchan:SetVolume(0.3)
                    end)
                end



                net.Start("zetapanel_changeinpanelstate")
                net.WriteBool(true)
                net.SendToServer()

                notification.AddLegacy("Received all NPCs! Took "..CurTime()-starttime.." seconds",NOTIFY_CLEANUP,4)
                local count = #npcs
                
                local frame = vgui.Create( 'DFrame' )
                frame:SetDeleteOnClose( true )
                frame:CenterHorizontal(0.3)
                frame:CenterVertical(0.4)
                frame:SetTitle('Zeta NPC Panel')
                frame:SetIcon( 'icon/physgun.png' )
                frame:SetSize(1000,500)
                frame:MakePopup()

                local label = vgui.Create( 'DLabel', frame )
                label:SetText('Welcome to the NPC Panel! There are '..count..' NPCs. Right click a NPC class in the list to the right to remove it')
                label:Dock(TOP)

                local label2 = vgui.Create( 'DLabel', frame )
                label2:SetText('Left click a NPC on the left to add it to the Zeta NPC list')
                label2:Dock(TOP)


                local sheet = vgui.Create( "DPropertySheet", frame )
                sheet:SetSize(600,100)
                sheet:Dock( LEFT )

                local panellist = vgui.Create( 'DListView', frame )

                panellist:Dock(RIGHT)
                panellist:SetSize(400,300)
                panellist:AddColumn('Zeta NPCs',1)

                for k,v in ipairs(npcs) do
                    local line = panellist:AddLine(v)
                    line:SetSortValue( 1, v )
                end

                function panellist:OnRowRightClick(id,line)
                    net.Start('zetapanel_removenpc')
                    net.WriteString(line:GetSortValue(1))
                    net.SendToServer()
                    notification.AddLegacy('Removed '..line:GetSortValue(1)..' from Zeta NPCs',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')
                    panellist:RemoveLine( id )
                    panellist:SetDirty( true )
                    count = count - 1
                    label:SetText('Welcome to the NPC Panel! There are '..count..' NPCs. Right click a NPC class in the list to the right to remove it')
                end

                net.Receive("zetapanel_updatepanel",function()
                    local mdl = net.ReadString()

                    local line = panellist:AddLine(mdl)
                    line:SetSortValue( 1, mdl )
                    panellist:SetDirty( true )
                    count = count + 1
                    label:SetText('Welcome to the NPC Panel! There are '..count..' NPCs. Right click a NPC class in the list to the right to remove it')
                
                end)



                local panel = spawnmenu.GetCreationTabs()["#spawnmenu.category.npcs"].Function()
                panel:SetParent( sheet )

                sheet:AddSheet("#spawnmenu.category.npcs", panel, spawnmenu.GetCreationTabs()["#spawnmenu.category.npcs"].Icon )


                function frame:OnClose() 
                    net.Start("zetapanel_changeinpanelstate")
                    net.WriteBool(false)
                    net.SendToServer()

                    if IsValid(sndchan) then
                    sndchan:Stop()
                    end

                end



            end

        end) -- End Net message


    end




    function OpenEntPanel()

        local entities = {}

        net.Start('zetapanel_getents')
        net.SendToServer()

        local starttime = CurTime()

        net.Receive('zetapanel_sendent',function()
            local ent = net.ReadString()
            local isdone = net.ReadBool()

            if ent != "PLACEHOLDER" then
                table.insert(entities,ent)
            end

            if isdone then -- Make the panel

                if GetConVar("zetaplayer_panelbgm"):GetString() != "" then
                    sound.PlayFile("sound/"..GetSound(GetConVar("zetaplayer_panelbgm"):GetString()), "", function(chan,errorid,erroname)
                        if !IsValid(chan) then
                            notification.AddLegacy("Warning! BGM Sound failed to load! Make sure the file path is correct!",NOTIFY_ERROR,7)
                            return
                        end

                        sndchan = chan
                        sndchan:EnableLooping( true )
                        sndchan:SetVolume(0.3)
                    end)
                end


                net.Start("zetapanel_changeinpanelstate")
                net.WriteBool(true)
                net.SendToServer()

                notification.AddLegacy("Received all Entities! Took "..CurTime()-starttime.." seconds",NOTIFY_CLEANUP,4)
                local count = #entities
                
                local frame = vgui.Create( 'DFrame' )
                frame:SetDeleteOnClose( true )
                frame:CenterHorizontal(0.3)
                frame:CenterVertical(0.4)
                frame:SetTitle('Zeta Entity Panel')
                frame:SetIcon( 'icon/physgun.png' )
                frame:SetSize(1000,500)
                frame:MakePopup()


                local label = vgui.Create( 'DLabel', frame )
                label:SetText('Welcome to the Entity Panel! There are '..count..' Entities. Right click a Entity class in the list to the right to remove it')
                label:Dock(TOP)

                local label2 = vgui.Create( 'DLabel', frame )
                label2:SetText('Left click a Entity on the left to add it to the Zeta Entity list')
                label2:Dock(TOP)


                local sheet = vgui.Create( "DPropertySheet", frame )
                sheet:SetSize(600,100)
                sheet:Dock( LEFT )

                local panellist = vgui.Create( 'DListView', frame )

                panellist:Dock(RIGHT)
                panellist:SetSize(400,300)
                panellist:AddColumn('Zeta Entities',1)

                for k,v in ipairs(entities) do
                    local line = panellist:AddLine(v)
                    line:SetSortValue( 1, v )
                end

                function panellist:OnRowRightClick(id,line)
                    net.Start('zetapanel_removeent')
                    net.WriteString(line:GetSortValue(1))
                    net.SendToServer()
                    notification.AddLegacy('Removed '..line:GetSortValue(1)..' from Zeta Entites',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')
                    panellist:RemoveLine( id )
                    panellist:SetDirty( true )
                    count = count - 1
                    label:SetText('Welcome to the Entity Panel! There are '..count..' Entities. Right click a Entity class in the list to the right to remove it')
                end

                net.Receive("zetapanel_updatepanel",function()
                    local ent = net.ReadString()

                    local line = panellist:AddLine(ent)
                    line:SetSortValue( 1, ent )
                    panellist:SetDirty( true )
                    count = count + 1
                    label:SetText('Welcome to the Entity Panel! There are '..count..' Entities. Right click a Entity class in the list to the right to remove it')
                
                end)



                local panel = spawnmenu.GetCreationTabs()["#spawnmenu.category.entities"].Function()
                panel:SetParent( sheet )

                sheet:AddSheet("#spawnmenu.category.entities", panel, spawnmenu.GetCreationTabs()["#spawnmenu.category.entities"].Icon )


                function frame:OnClose() 
                    net.Start("zetapanel_changeinpanelstate")
                    net.WriteBool(false)
                    net.SendToServer()

                    if IsValid(sndchan) then
                    sndchan:Stop()
                    end
                end



            end

        end) -- End Net message


    end







    function OpenProfilePanel()

        local profiles = {}
        net.Start('zetapanel_getprofiles')
        net.SendToServer()

        local starttime = CurTime()

        net.Receive('zetapanel_sendprofile',function()
            local profile = net.ReadString()
            local isdone = net.ReadBool()
            local tbl = util.JSONToTable(profile)

            if tbl["name"] then
                profiles[tbl["name"]] = tbl
            end

            if isdone then -- Make the panel
                local sndchan

                if GetConVar("zetaplayer_panelbgm"):GetString() != "" then
                    sound.PlayFile("sound/"..GetSound(GetConVar("zetaplayer_panelbgm"):GetString()), "", function(chan,errorid,erroname)
                        if !IsValid(chan) then
                            notification.AddLegacy("Warning! BGM Sound failed to load! Make sure the file path is correct!",NOTIFY_ERROR,7)
                            return
                        end

                        sndchan = chan
                        sndchan:EnableLooping( true )
                        sndchan:SetVolume(0.3)
                    end)
                end

                local UpdateBodyGroups
                local modelpreview
                local skinslider
                local bodygrouppanels
                notification.AddLegacy("Received all Profiles! Took "..CurTime()-starttime.." seconds",NOTIFY_CLEANUP,4)
                local count = table.Count(profiles)


                local frame = vgui.Create( 'DFrame' )
                frame:SetDeleteOnClose( true )
                frame:CenterHorizontal(0.3)
                frame:CenterVertical(0.4)
                frame:SetTitle('Zeta Profile Panel')
                frame:SetIcon( 'icon/physgun.png' )
                frame:SetSize(1150,500)
                frame:MakePopup()

                function frame:OnClose()
                    if IsValid(sndchan) then
                    sndchan:Stop()
                    end
                end

                local mainsheet = vgui.Create("DPropertySheet",frame)
                mainsheet:Dock(FILL)

                local setting1 = vgui.Create("EditablePanel",mainsheet)
                setting1:Dock(FILL)

                mainsheet:AddSheet("Settings 1",setting1)

                local setting2 = vgui.Create("EditablePanel",mainsheet)
                setting2:Dock(FILL)

                mainsheet:AddSheet("Settings 2",setting2)



                --- SETTING 1 ---

                local label = vgui.Create( 'DLabel', setting1 )
                label:SetText('Welcome to the Profile Panel! There are '..count..' Profiles.')
                label:Dock(TOP)


                local panellist = vgui.Create( 'DListView', setting1 )

                panellist:DockMargin(0,60,0,0)
                panellist:Dock(RIGHT)
                panellist:SetSize(200,300)
                panellist:AddColumn('Zeta Profile',1)

                local searchbar = vgui.Create( "DTextEntry", setting1 )
                searchbar:SetPos( 950, 50 )
                searchbar:SetSize( 180, 20 )
                searchbar:SetPlaceholderText( "Search bar" )

                for k,v in SortedPairs(profiles) do
                    local line = panellist:AddLine(v["name"])
                    line:SetSortValue( 1, v )
                end



                function searchbar:OnChange()
                    panellist:Clear()

                    if searchbar:GetText() == "" then

                        for k,v in SortedPairs(profiles) do
                            local line = panellist:AddLine(v["name"])
                            line:SetSortValue( 1, v )
                        end

                    else

                        local keytext = searchbar:GetText()

                        for k,v in SortedPairs(profiles) do

                            local match = string.find( string.lower( v["name"] ), string.lower( keytext ) )

                            if match then

                                local line = panellist:AddLine(v["name"])
                                line:SetSortValue( 1, v )

                            end
                        end

                    end
                end

                local namelabel = vgui.Create( 'DLabel', setting1 )
                namelabel:SetText('Double left click to load a profile')
                namelabel:SetSize(650,50)
                namelabel:SetPos(950,0)

                namelabel = vgui.Create( 'DLabel', setting1 )
                namelabel:SetText('Right click to remove a profile')
                namelabel:SetSize(650,50)
                namelabel:SetPos(950,15)

                local isadminbox = vgui.Create("DCheckBox",setting1)
                isadminbox:SetPos(10,370)
                isadminbox:SetSize(20,20)

                local adminlabel = vgui.Create( 'DLabel', setting1 )
                adminlabel:SetText('Is Admin')
                adminlabel:SetPos(40,370)

                local mingebagbox = vgui.Create("DCheckBox",setting1)
                mingebagbox:SetPos(10,340)
                mingebagbox:SetSize(20,20)

                local mingebaglabel = vgui.Create( 'DLabel', setting1 )
                mingebaglabel:SetText('Is Mingebag')
                mingebaglabel:SetPos(40,340)

                local strictnessslider = vgui.Create( 'DNumSlider', setting1 )
                strictnessslider:SetSize(300,20)
                strictnessslider:SetPos(10,400)
                strictnessslider:SetMax(100)
                strictnessslider:SetMin(0)
                strictnessslider:SetDecimals( 0 )	
                strictnessslider:SetText("Admin Strictness")

                local zetanameentry = vgui.Create( 'DTextEntry', setting1 )
                zetanameentry:SetSize(200,20)
                zetanameentry:SetPos(10,30)

                local namelabel = vgui.Create( 'DLabel', setting1 )
                namelabel:SetSize(200,20)
                namelabel:SetText('Zeta Name { REQUIRED ! }')
                namelabel:SetPos(220,30)

                local viewnames = vgui.Create( "DButton", setting1 )
                viewnames:SetSize( 150, 20)
                viewnames:SetText( "View Registered names" )
                viewnames:SetPos( 10, 50)



                function viewnames:DoClick()

                    local namejson = file.Read( "zetaplayerdata/names.json" )

                    local nameframe = vgui.Create( "DFrame" )
                    nameframe:SetSize( 300, 300 )
                    nameframe:Center()
                    nameframe:MakePopup()
                    nameframe:SetSizable( true )
                    nameframe:SetTitle( "Name List" )

                    local hint = vgui.Create( "DLabel", nameframe )
                    hint:Dock( TOP )
                    hint:SetText( "Click on a name to automatically use it" )

                    local namesearchbar = vgui.Create( "DTextEntry", nameframe )
                    namesearchbar:Dock( TOP )
                    namesearchbar:SetPlaceholderText( "Search bar" )

                    local namelist = vgui.Create( "DListView", nameframe )
                    namelist:Dock( FILL )
                    namelist:AddColumn( "Names", 1 )

                    local newnametbl = {}

                    if namejson then

                        namejson = util.JSONToTable( namejson )

                        

                        for k, v in ipairs( namejson ) do
                            newnametbl[ v ] = v
                        end

                        for k, v in SortedPairs( newnametbl ) do
                            
                            local line = namelist:AddLine( v )
                            line:SetSortValue( 1, v )

                        end

                    end


                    function namelist:OnRowSelected( id, line )

                        zetanameentry:SetText( line:GetSortValue( 1 ) )
                        nameframe:Remove()

                    end

                    function namesearchbar:OnChange()
                        local text = namesearchbar:GetText()

                        if text == "" then

                            for k, v in SortedPairs( newnametbl ) do
                            
                                local line = namelist:AddLine( v )
                                line:SetSortValue( 1, v )
    
                            end

                            return
                        end

                        namelist:Clear()

                        for k, v in SortedPairs( newnametbl ) do

                            local match = string.find( string.lower( v ), string.lower( text ) )
                            
                            if match then

                                local line = namelist:AddLine( v )
                                line:SetSortValue( 1, v )

                            end

                        end

                    end

                end






                local playermodel = vgui.Create( 'DTextEntry', setting1 )
                playermodel:SetSize(200,20)
                playermodel:SetPos(10,90)
                playermodel:SetText("models/player/kleiner.mdl")


                namelabel = vgui.Create( 'DLabel', setting1 )
                namelabel:SetText('Player Model')
                namelabel:SetPos(220,90)

                namelabel = vgui.Create( 'DLabel', setting1 )
                namelabel:SetText('Leave blank for random models')
                namelabel:SetSize(200,20)
                namelabel:SetPos(10,110)

                local playermodelpreview = vgui.Create("DImage", setting1)
                playermodelpreview:SetSize(30,30)
                playermodelpreview:SetPos(290,90)
                playermodelpreview:SetImage("spawnicons/models/player/kleiner.png")


                local pfp = vgui.Create( 'DTextEntry', setting1 )
                pfp:SetSize(200,20)
                pfp:SetPos(10,170)
                pfp:SetText("yourpfp.png")

                namelabel = vgui.Create( 'DLabel', setting1 )
                namelabel:SetText('Profile Picture')
                namelabel:SetSize(100,20)
                namelabel:SetPos(220,170)

                namelabel = vgui.Create( 'DLabel', setting1 )
                namelabel:SetText('Leave blank for a random profile pictures')
                namelabel:SetSize(200,20)
                namelabel:SetPos(80,210)

                namelabel = vgui.Create( 'DLabel', setting1 )
                namelabel:SetText('Insert a image file name from the custom_avatars folder')
                namelabel:SetSize(300,20)
                namelabel:SetPos(80,230)

                local pfpviewerbutton = vgui.Create( "DButton", setting1 )
                pfpviewerbutton:SetPos( 80, 250 )
                pfpviewerbutton:SetSize( 150, 20 )
                pfpviewerbutton:SetText( "View Profile Pictures" )

                function pfpviewerbutton:DoClick()

                    local pfpviewerframe = vgui.Create( "DFrame" )
                    pfpviewerframe:SetSize( 550, 550 )
                    pfpviewerframe:Center()
                    pfpviewerframe:SetSizable( true )
                    pfpviewerframe:MakePopup()
                    pfpviewerframe:SetTitle( "Profile Picture Viewer" )

                    local hint = vgui.Create( "DLabel", pfpviewerframe )
                    hint:Dock( TOP )
                    hint:SetText( "Click on a image to use it" )

                    local pfpscroll = vgui.Create( "DScrollPanel", pfpviewerframe )
                    pfpscroll:Dock( FILL )

                    local organizedlist = vgui.Create( "DIconLayout", pfpscroll )
                    organizedlist:Dock( FILL )
                    organizedlist:SetSpaceY( 5 )
                    organizedlist:SetSpaceX( 5 )


                    
                    local pfps, _ = file.Find( "zetaplayerdata/custom_avatars/*.jpg", "DATA", "dateasc" )
                    local pngs, _ = file.Find( "zetaplayerdata/custom_avatars/*.png", "DATA", "dateasc" )
                    table.Add( pfps, pngs )

                    for k, v in ipairs( pfps ) do

                        local DPanel = organizedlist:Add( "DPanel" )
                        DPanel:SetSize(100,100)

                        local image = vgui.Create( "DImageButton", DPanel )
                        image:Dock( FILL )

                        image:SetMaterial( Material( "../data/zetaplayerdata/custom_avatars/" .. v ) )

                        function image:DoClick()

                            pfp:SetValue( v )
                            pfp:OnChange()

                            pfpviewerframe:Remove()
                        end

                        local label = vgui.Create( "DLabel", DPanel )
                        label:Dock( BOTTOM )
                        label:SetText( v )

                    end

                end

                local pfppreview = vgui.Create("DImage", setting1)
                pfppreview:SetSize(70,70)
                pfppreview:SetPos(10,200)
                pfppreview:SetImage("spawnicons/models/player/kleiner.png")

                function pfp:OnChange()
                    pfppreview:SetImage("../data/zetaplayerdata/custom_avatars/"..pfp:GetText())
                end

                local scrollpan = vgui.Create( "DScrollPanel", setting1 )
                scrollpan:SetSize(350,100)
                scrollpan:Dock( RIGHT )

                local List = vgui.Create( "DIconLayout", scrollpan )
                List:Dock( FILL )
                List:SetSpaceY( 12 )
                List:SetSpaceX( 12 )

                for k, v in pairs(player_manager.AllValidModels()) do
                    
                    local mdlbutton = List:Add( "SpawnIcon" )
                    mdlbutton:SetModel( v )

                    function mdlbutton:DoClick()

                        playermodel:SetText( mdlbutton:GetModelName() )
                        playermodel:OnChange()
                    end


                end



                namelabel = vgui.Create( 'DLabel', setting1 )
                namelabel:SetText('Use this menu to easily select a Playermodel')
                namelabel:SetSize(650,50)
                namelabel:SetPos(600,-15)


                local voicepitch = vgui.Create("DNumSlider", setting1)
                voicepitch:SetSize(300,20)
                voicepitch:SetPos(10,290)
                voicepitch:SetMax(255)
                voicepitch:SetMin(10)
                voicepitch:SetDecimals( 0 )
                voicepitch:SetValue(100)
                voicepitch:SetText("Voice Pitch")

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


                local weapon = vgui.Create("DComboBox",setting1)
                weapon:SetSize(150,20)
                weapon:SetPos(420,350)

                weapon:SetSortItems(false)

                weapon:AddChoice('None/Holster', 'NONE')
                weapon:AddChoice("Random Weapon","RND")
                weapon:AddChoice("Random Lethal Weapon","RNDLETHAL")
                
                weapon:AddSpacer()
                
                weapon:AddChoice('[HL2] Crowbar', 'CROWBAR')
                weapon:AddChoice('[HL2] Stunstick', 'STUNSTICK')
                weapon:AddChoice('[HL2] Pistol', 'PISTOL')
                weapon:AddChoice('[HL2] 357. Revolver', 'REVOLVER')
                weapon:AddChoice('[HL2] SMG1', 'SMG')
                weapon:AddChoice('[HL2] AR2', 'AR2')
                weapon:AddChoice('[HL2] Shotgun', 'SHOTGUN')
                weapon:AddChoice('[HL2] Crossbow','CROSSBOW')
                weapon:AddChoice('[HL2] RPG', 'RPG')
                weapon:AddChoice("[HL2] Grenade","GRENADE")
                
                weapon:AddSpacer()
                
                weapon:AddChoice('[Misc] Fists','FIST')
                weapon:AddChoice('[Misc] Physics Gun', 'PHYSGUN')
                weapon:AddChoice('[Misc] Toolgun', 'TOOLGUN')
                weapon:AddChoice('[Misc] Camera','CAMERA')
                weapon:AddChoice("[Misc] Junk Launcher","JPG")
                if #gmodWeps > 0 then
                    for i = 1, #gmodWeps do
                        weapon:AddChoice('[Misc] '..gmodWeps[i][1], gmodWeps[i][2])
                    end
                end

                weapon:AddSpacer()

                if #customAddonweps > 0 then
                    for i = 1, #customAddonweps do
                        weapon:AddChoice('[Addon] '..customAddonweps[i][1], customAddonweps[i][2])
                    end
                end
                
                weapon:AddSpacer()

                if #customweps > 0 then
                    for i = 1, #customweps do
                        weapon:AddChoice('[Custom] '..customweps[i][1], customweps[i][2])
                    end
                end
                
                weapon:AddSpacer()
                
                weapon:AddChoice('[CS:S] Knife','KNIFE')
                weapon:AddChoice("[CS:S] Desert Eagle","DEAGLE")
                weapon:AddChoice("[CS:S] MP5","MP5")
                weapon:AddChoice('[CS:S] M4A1','M4A1')
                weapon:AddChoice("[CS:S] AK47","AK47")
                weapon:AddChoice('[CS:S] AWP','AWP')
                weapon:AddChoice("[CS:S] M249 Machine Gun","MACHINEGUN")
                if #cssWeps > 0 then
                    for i = 1, #cssWeps do
                        weapon:AddChoice('[CS:S] '..cssWeps[i][1], cssWeps[i][2])
                    end
                end
                
                weapon:AddSpacer()
                
                weapon:AddChoice('[TF2] Wrench','WRENCH')
                weapon:AddChoice("[TF2] Pistol","TF2PISTOL")
                weapon:AddChoice("[TF2] Shotgun","TF2SHOTGUN")
                weapon:AddChoice('[TF2] Scatter Gun','SCATTERGUN')
                weapon:AddChoice("[TF2] Sniper Rifle","TF2SNIPER")
                if #tf2Weps > 0 then
                    for i = 1, #tf2Weps do
                        local wepStr = string.Replace(tf2Weps[i][1], 'TF2 ', '')
                        weapon:AddChoice('[TF2] '..wepStr, tf2Weps[i][2])
                    end
                end
                
                weapon:AddSpacer()
                
                if #hl1Weps > 0 then
                    for i = 1, #hl1Weps do
                        local wepStr = string.Replace(hl1Weps[i][1], 'HL1 ', '')
                        weapon:AddChoice('[HL1] '..wepStr, hl1Weps[i][2])
                    end
                
                    weapon:AddSpacer()
                end
                
                if #dodWeps > 0 then
                    for i = 1, #dodWeps do
                        weapon:AddChoice('[DOD:S] '..dodWeps[i][1], dodWeps[i][2])
                    end
                
                    weapon:AddSpacer()
                end
                
                if #l4dWeps > 0 then
                    for i = 1, #l4dWeps do
                        weapon:AddChoice(l4dWeps[i][1], l4dWeps[i][2])
                    end
                
                    weapon:AddSpacer()
                end

                if #mp1Weps > 0 then
                    for i = 1, #mp1Weps do
                        weapon:AddChoice(mp1Weps[i][1], mp1Weps[i][2])
                    end
                
                    weapon:AddSpacer()
                end

                namelabel = vgui.Create( 'DLabel', setting1 )
                namelabel:SetText('Weapon Override')
                namelabel:SetSize(300,20)
                namelabel:SetPos(420,370)
                

                local usepersonalitybox = vgui.Create("DCheckBox",setting1)
                usepersonalitybox:SetPos(420,10)
                usepersonalitybox:SetSize(20,20)

                local personalitylabel = vgui.Create( 'DLabel', setting1 )
                personalitylabel:SetText('Use Custom Personality Sliders')
                personalitylabel:SetPos(445,10)
                personalitylabel:SetSize(150,20)

                local BuildChance = vgui.Create( 'DNumSlider', setting1 )
                BuildChance:SetSize(200,20)
                BuildChance:SetPos(420,40)
                BuildChance:SetMax(100)
                BuildChance:SetMin(0)
                BuildChance:SetDecimals( 0 )	
                BuildChance:SetText("Build Chance")

                local ToolChance = vgui.Create( 'DNumSlider', setting1 )
                ToolChance:SetSize(200,20)
                ToolChance:SetPos(420,70)
                ToolChance:SetMax(100)
                ToolChance:SetMin(0)
                ToolChance:SetDecimals( 0 )	
                ToolChance:SetText("Tool Chance")

                local PhysgunChance = vgui.Create( 'DNumSlider', setting1 )
                PhysgunChance:SetSize(200,20)
                PhysgunChance:SetPos(420,100)
                PhysgunChance:SetMax(100)
                PhysgunChance:SetMin(0)
                PhysgunChance:SetDecimals( 0 )	
                PhysgunChance:SetText("Physgun Chance")

                local CombatChance = vgui.Create( 'DNumSlider', setting1 )
                CombatChance:SetSize(200,20)
                CombatChance:SetPos(420,130)
                CombatChance:SetMax(100)
                CombatChance:SetMin(0)
                CombatChance:SetDecimals( 0 )	
                CombatChance:SetText("Combat Chance")

                local DisrespectChance = vgui.Create( 'DNumSlider', setting1 )
                DisrespectChance:SetSize(200,20)
                DisrespectChance:SetPos(420,160)
                DisrespectChance:SetMax(100)
                DisrespectChance:SetMin(0)
                DisrespectChance:SetDecimals( 0 )	
                DisrespectChance:SetText("Disrespect Chance")

                local WatchmediaChance = vgui.Create( 'DNumSlider', setting1 )
                WatchmediaChance:SetSize(200,20)
                WatchmediaChance:SetPos(420,190)
                WatchmediaChance:SetMax(100)
                WatchmediaChance:SetMin(0)
                WatchmediaChance:SetDecimals( 0 )	
                WatchmediaChance:SetText("Watch Media Chance")

                local FriendlyChance = vgui.Create( 'DNumSlider', setting1 )
                FriendlyChance:SetSize(200,20)
                FriendlyChance:SetPos(420,220)
                FriendlyChance:SetMax(100)
                FriendlyChance:SetMin(0)
                FriendlyChance:SetDecimals( 0 )	
                FriendlyChance:SetText("Friendly Chance")

                local VoiceChance = vgui.Create( 'DNumSlider', setting1 )
                VoiceChance:SetSize(200,20)
                VoiceChance:SetPos(420,250)
                VoiceChance:SetMax(100)
                VoiceChance:SetMin(0)
                VoiceChance:SetDecimals( 0 )	
                VoiceChance:SetText("Voice Chance")

                local VehicleChance = vgui.Create( 'DNumSlider', setting1 )
                VehicleChance:SetSize(200,20)
                VehicleChance:SetPos(420,280)
                VehicleChance:SetMax(100)
                VehicleChance:SetMin(0)
                VehicleChance:SetDecimals( 0 )	
                VehicleChance:SetText("Vehicle Chance")

                local TextChance = vgui.Create( 'DNumSlider', setting1 )
                TextChance:SetSize(200,20)
                TextChance:SetPos(420,310)
                TextChance:SetMax(100)
                TextChance:SetMin(0)
                TextChance:SetDecimals( 0 )	
                TextChance:SetText("Text Chance")

                local savebutton = vgui.Create( 'DButton', setting1 )
                savebutton:SetSize(200,20)
                savebutton:SetPos(390,400)
                savebutton:SetText("Save Profile")

                --- END SETTING 1 ---


                --- SETTING 2 ---

                local favoriteweapon = vgui.Create("DComboBox",setting2)
                favoriteweapon:SetSize(150,20)
                favoriteweapon:SetPos(10,350)

                favoriteweapon:SetSortItems(false)

                favoriteweapon:AddChoice('No Favorite Weapon', 'NONE')
                favoriteweapon:AddChoice("Random Weapon","RND")
                favoriteweapon:AddChoice("Random Lethal Weapon","RNDLETHAL")
                
                favoriteweapon:AddSpacer()
                
                favoriteweapon:AddChoice('[HL2] Crowbar', 'CROWBAR')
                favoriteweapon:AddChoice('[HL2] Stunstick', 'STUNSTICK')
                favoriteweapon:AddChoice('[HL2] Pistol', 'PISTOL')
                favoriteweapon:AddChoice('[HL2] 357. Revolver', 'REVOLVER')
                favoriteweapon:AddChoice('[HL2] SMG1', 'SMG')
                favoriteweapon:AddChoice('[HL2] AR2', 'AR2')
                favoriteweapon:AddChoice('[HL2] Shotgun', 'SHOTGUN')
                favoriteweapon:AddChoice('[HL2] Crossbow','CROSSBOW')
                favoriteweapon:AddChoice('[HL2] RPG', 'RPG')
                favoriteweapon:AddChoice("[HL2] Grenade","GRENADE")
                
                favoriteweapon:AddSpacer()
                
                favoriteweapon:AddChoice('[Misc] Fists','FIST')
                favoriteweapon:AddChoice('[Misc] Physics Gun', 'PHYSGUN')
                favoriteweapon:AddChoice('[Misc] Toolgun', 'TOOLGUN')
                favoriteweapon:AddChoice('[Misc] Camera','CAMERA')
                favoriteweapon:AddChoice("[Misc] Junk Launcher","JPG")
                if #gmodWeps > 0 then
                    for i = 1, #gmodWeps do
                        favoriteweapon:AddChoice('[Misc] '..gmodWeps[i][1], gmodWeps[i][2])
                    end
                end

                favoriteweapon:AddSpacer()
                
                if #customAddonweps > 0 then
                    for i = 1, #customAddonweps do
                        favoriteweapon:AddChoice('[Addon] '..customAddonweps[i][1], customAddonweps[i][2])
                    end
                end
                
                favoriteweapon:AddSpacer()
                if #customweps > 0 then
                    for i = 1, #customweps do
                        favoriteweapon:AddChoice('[Custom] '..customweps[i][1], customweps[i][2])
                    end
                end
                
                favoriteweapon:AddSpacer()
                
                favoriteweapon:AddChoice('[CS:S] Knife','KNIFE')
                favoriteweapon:AddChoice("[CS:S] Desert Eagle","DEAGLE")
                favoriteweapon:AddChoice("[CS:S] MP5","MP5")
                favoriteweapon:AddChoice('[CS:S] M4A1','M4A1')
                favoriteweapon:AddChoice("[CS:S] AK47","AK47")
                favoriteweapon:AddChoice('[CS:S] AWP','AWP')
                favoriteweapon:AddChoice("[CS:S] M249 Machine Gun","MACHINEGUN")
                if #cssWeps > 0 then
                    for i = 1, #cssWeps do
                        favoriteweapon:AddChoice('[CS:S] '..cssWeps[i][1], cssWeps[i][2])
                    end
                end
                
                favoriteweapon:AddSpacer()
                
                favoriteweapon:AddChoice('[TF2] Wrench','WRENCH')
                favoriteweapon:AddChoice("[TF2] Pistol","TF2PISTOL")
                favoriteweapon:AddChoice("[TF2] Shotgun","TF2SHOTGUN")
                favoriteweapon:AddChoice('[TF2] Scatter Gun','SCATTERGUN')
                favoriteweapon:AddChoice("[TF2] Sniper Rifle","TF2SNIPER")
                if #tf2Weps > 0 then
                    for i = 1, #tf2Weps do
                        local wepStr = string.Replace(tf2Weps[i][1], 'TF2 ', '')
                        favoriteweapon:AddChoice('[TF2] '..wepStr, tf2Weps[i][2])
                    end
                end
                
                favoriteweapon:AddSpacer()
                
                if #hl1Weps > 0 then
                    for i = 1, #hl1Weps do
                        local wepStr = string.Replace(hl1Weps[i][1], 'HL1 ', '')
                        favoriteweapon:AddChoice('[HL1] '..wepStr, hl1Weps[i][2])
                    end
                
                    favoriteweapon:AddSpacer()
                end
                
                if #dodWeps > 0 then
                    for i = 1, #dodWeps do
                        favoriteweapon:AddChoice('[DOD:S] '..dodWeps[i][1], dodWeps[i][2])
                    end
                
                    favoriteweapon:AddSpacer()
                end
                
                if #l4dWeps > 0 then
                    for i = 1, #l4dWeps do
                        favoriteweapon:AddChoice(l4dWeps[i][1], l4dWeps[i][2])
                    end
                
                    favoriteweapon:AddSpacer()
                end

                if #mp1Weps > 0 then
                    for i = 1, #mp1Weps do
                        favoriteweapon:AddChoice(mp1Weps[i][1], mp1Weps[i][2])
                    end
                
                    favoriteweapon:AddSpacer()
                end

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Favourite Weapon. (Most picked weapon)')
                namelabel:SetSize(300,20)
                namelabel:SetPos(10,370)

                local playermodelcolor = vgui.Create("DColorMixer",setting2)
                playermodelcolor:SetPos(900,200)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Playermodel Color')
                namelabel:SetSize(300,20)
                namelabel:SetPos(900,180)

                local useplayermodelcolorbox = vgui.Create("DCheckBox",setting2)
                useplayermodelcolorbox:SetPos(900,160)
                useplayermodelcolorbox:SetSize(20,20)

                local namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Use Playermodel Color')
                namelabel:SetPos(930,160)
                namelabel:SetSize(150,20)


                local physguncolor = vgui.Create("DColorMixer",setting2)
                physguncolor:SetPos(630,200)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Physgun Color')
                namelabel:SetSize(300,20)
                namelabel:SetPos(630,180)

                local usephysguncolorbox = vgui.Create("DCheckBox",setting2)
                usephysguncolorbox:SetPos(630,160)
                usephysguncolorbox:SetSize(20,20)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Use Physgun Color')
                namelabel:SetPos(660,160)
                namelabel:SetSize(150,20)

                local health = vgui.Create( 'DNumSlider', setting2 )
                health:SetSize(200,20)
                health:SetPos(10,310)
                health:SetMax(10000)
                health:SetMin(1)
                health:SetDecimals( 0 )	
                health:SetText("Spawn Health")
                health:SetValue(100)

                local armor = vgui.Create( 'DNumSlider', setting2 )
                armor:SetSize(200,20)
                armor:SetPos(10,270)
                armor:SetMax(10000)
                armor:SetMin(0)
                armor:SetDecimals( 0 )	
                armor:SetText("Spawn Armor")

                local usecustomidle = vgui.Create("DCheckBox",setting2)
                usecustomidle:SetPos(10,240)
                usecustomidle:SetSize(20,20)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Use Custom Idle Lines')
                namelabel:SetPos(35,240)
                namelabel:SetSize(150,20)

                local usecustomdeath = vgui.Create("DCheckBox",setting2)
                usecustomdeath:SetPos(10,210)
                usecustomdeath:SetSize(20,20)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Use Custom Death Lines')
                namelabel:SetPos(35,210)
                namelabel:SetSize(150,20)

                local usecustomkill = vgui.Create("DCheckBox",setting2)
                usecustomkill:SetPos(10,180)
                usecustomkill:SetSize(20,20)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Use Custom Kill Lines')
                namelabel:SetPos(35,180)
                namelabel:SetSize(150,20)

                local usecustomtaunt = vgui.Create("DCheckBox",setting2)
                usecustomtaunt:SetPos(10,150)
                usecustomtaunt:SetSize(20,20)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Use Custom Taunt Lines')
                namelabel:SetPos(35,150)
                namelabel:SetSize(150,20)

                local usecustompanic = vgui.Create("DCheckBox",setting2)
                usecustompanic:SetPos(10,120)
                usecustompanic:SetSize(20,20)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Use Custom Panic Lines')
                namelabel:SetPos(35,120)
                namelabel:SetSize(150,20)

                local usecustomassist = vgui.Create("DCheckBox",setting2)
                usecustomassist:SetPos(10,90)
                usecustomassist:SetSize(20,20)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Use Custom Assist Lines')
                namelabel:SetPos(35,90)
                namelabel:SetSize(150,20)

                local usecustomlaugh = vgui.Create("DCheckBox",setting2)
                usecustomlaugh:SetPos(10,60)
                usecustomlaugh:SetSize(20,20)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Use Custom Laugh Lines')
                namelabel:SetPos(35,60)
                namelabel:SetSize(150,20)

                local usecustomwitness = vgui.Create("DCheckBox",setting2)
                usecustomwitness:SetPos(10,30)
                usecustomwitness:SetSize(20,20)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Use Custom Witness Lines')
                namelabel:SetPos(35,30)
                namelabel:SetSize(150,20)

                local usecustomadminscold = vgui.Create("DCheckBox",setting2)
                usecustomadminscold:SetPos(10,0)
                usecustomadminscold:SetSize(20,20)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Use Custom Admin Scold Lines')
                namelabel:SetPos(35,0)
                namelabel:SetSize(150,20)

                local usecustomFalling = vgui.Create("DCheckBox",setting2)
                usecustomFalling:SetPos(200,0)
                usecustomFalling:SetSize(20,20)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Use Custom Falling Lines')
                namelabel:SetPos(235,0)
                namelabel:SetSize(150,20)

                local usecustomSitRespond = vgui.Create("DCheckBox",setting2)
                usecustomSitRespond:SetPos(200,30)
                usecustomSitRespond:SetSize(20,20)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Use Custom SitRespond Lines')
                namelabel:SetPos(235,30)
                namelabel:SetSize(150,20)

                local usecustomQuestion = vgui.Create("DCheckBox",setting2)
                usecustomQuestion:SetPos(200,60)
                usecustomQuestion:SetSize(20,20)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Use Custom Question Lines')
                namelabel:SetPos(235,60)
                namelabel:SetSize(150,20)
                
                local usecustomConRespond = vgui.Create("DCheckBox",setting2)
                usecustomConRespond:SetPos(200,90)
                usecustomConRespond:SetSize(20,20)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Use Custom Con Respond Lines')
                namelabel:SetPos(235,90)
                namelabel:SetSize(190,20)

                local usecustomMediaWatch = vgui.Create("DCheckBox",setting2)
                usecustomMediaWatch:SetPos(200,120)
                usecustomMediaWatch:SetSize(20,20)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Use Custom Media Watch Lines')
                namelabel:SetPos(235,120)
                namelabel:SetSize(190,20)

                local voicepack = vgui.Create("DComboBox",setting2)
                voicepack:SetPos(450,370)
                voicepack:SetSize(150,20)
                voicepack:AddChoice("None","none",true)

                local teamfile = file.Read("zetaplayerdata/teams.json")

                local teamoverride = vgui.Create("DComboBox",setting2)
                teamoverride:SetPos(450,300)
                teamoverride:SetSize(150,20)

                teamoverride:AddChoice("None","")

                if teamfile then
                    teamfile = util.JSONToTable(teamfile)



                    for k,v in ipairs(teamfile) do
                        teamoverride:AddChoice(v[1],v[1])
                    end
            
                      
                end

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Team Override')
                namelabel:SetPos(450,330)
                namelabel:SetSize(190,20)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText('Voice Pack')
                namelabel:SetPos(450,395)
                namelabel:SetSize(190,20)

                local nodisconnect = vgui.Create("DCheckBox",setting2)
                nodisconnect:SetPos(200,240)
                nodisconnect:SetSize(20,20)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText("Disallow Disconnecting")
                namelabel:SetPos(235,240)
                namelabel:SetSize(190,20)

                local ispermafriend = vgui.Create("DCheckBox",setting2)
                ispermafriend:SetPos(200,210)
                ispermafriend:SetSize(20,20)

                namelabel = vgui.Create( 'DLabel', setting2 )
                namelabel:SetText("Is Your Permanent Friend")
                namelabel:SetPos(235,210)
                namelabel:SetSize(190,20)


                local _,folders = file.Find("sourceengine/sound/zetaplayer/custom_vo/*","BASE_PATH","namedesc")
                local _,addonfolders = file.Find("sound/zetaplayer/custom_vo/*","GAME","namedesc")
        
                table.Merge(folders,addonfolders)

                local VPIDS = {}
                
                for _,v in ipairs(folders) do
                    local IsVP = string.find(v,"vp_")
                    if isnumber(IsVP) then
                        local name = string.Replace(v,"vp_","")
                        local id = voicepack:AddChoice(name,v)
                        VPIDS[v] = id
                    end
                end


                local bodygroupPANEL = vgui.Create("EditablePanel",setting2)
                bodygroupPANEL:SetPos(820,0)
                bodygroupPANEL:SetSize(300,100)

                local scrollpanel = vgui.Create( "DScrollPanel", bodygroupPANEL )
                scrollpanel:Dock( FILL )

                modelpreview = vgui.Create("DModelPanel",setting2)
                modelpreview:SetPos(600,0)
                modelpreview:SetSize(200,150)
                modelpreview:SetModel(playermodel:GetText())
                modelpreview:SetDirectionalLight(BOX_TOP, Color(0, 0, 0))
                modelpreview:SetDirectionalLight(BOX_FRONT, Color(0, 0, 0))
                modelpreview:SetAmbientLight( Color(180,180,180) )

                local col = playermodelcolor:GetColor()
                local ent = modelpreview:GetEntity()
                if IsValid(ent) then
                    ent.GetPlayerColor = function() return Color(col.r,col.g,col.b):ToVector() end
                end

                skinslider = vgui.Create("DNumSlider",setting2)
                skinslider:SetPos(820,110)
                skinslider:SetSize(200,30)
                skinslider:SetMax(modelpreview:GetEntity():SkinCount())
                skinslider:SetMin(0)
                skinslider:SetDecimals( 0 )	
                skinslider:SetText("Skin")

                function modelpreview:LayoutEntity( ent )

                    ent:SetAngles(Angle(0,RealTime()*50,0))
                end

                bodygrouppanels = {}


                local function MakeNiceName( str ) -- Gmod's function for bodygroup names
                    local newname = {}
        
                    for _, s in pairs( string.Explode( "_", str ) ) do
                        if ( string.len( s ) == 1 ) then table.insert( newname, string.upper( s ) ) continue end
                        table.insert( newname, string.upper( string.Left( s, 1 ) ) .. string.Right( s, string.len( s ) - 1 ) ) // Ugly way to capitalize first letters.
                    end
        
                    return string.Implode( " ", newname )
                end


                function UpdateBodyGroups()

                    table.Empty(bodygrouppanels)

                    scrollpanel:Clear()

                    local dummyent = ents.CreateClientside("base_anim")
                    dummyent:SetModel(playermodel:GetText())
                    dummyent:Spawn()
                    

                    for k = 0, dummyent:GetNumBodyGroups() - 1 do
                    if ( dummyent:GetBodygroupCount( k ) <= 1 ) then continue end

                        local slider = vgui.Create( 'DNumSlider', scrollpanel )
                        slider:Dock( TOP )
                        slider:DockMargin( 0, 0, 0, 5 )
                        slider:SetMax(dummyent:GetBodygroupCount( k ) - 1)
                        slider:SetDecimals( 0 )	
                        slider:SetText(MakeNiceName( dummyent:GetBodygroupName( k ) ))

                        function slider:OnValueChanged( value )
                            local ent = modelpreview:GetEntity()
                            ent:SetBodygroup(k,value)
                        end

                        table.insert(bodygrouppanels,{slider,k})

                        scrollpanel:AddItem(slider)
                    end

                    skinslider:SetMax(dummyent:SkinCount())
                    skinslider:SetValue(0)
                    
                    dummyent:Remove()

                end

                UpdateBodyGroups()

                function skinslider:OnValueChanged( value )
                    local ent = modelpreview:GetEntity()
                    if IsValid(ent) then
                        ent:SetSkin(value)
                    end
                end

                function playermodelcolor:ValueChanged( col )
                    local ent = modelpreview:GetEntity()
                    if IsValid(ent) then
                        ent.GetPlayerColor = function() return Color(col.r,col.g,col.b):ToVector() end
                    end
                end

                function playermodel:OnChange()
                    playermodelpreview:SetImage(string.Replace( "spawnicons/"..playermodel:GetText(),".mdl",".png"))
                    UpdateBodyGroups()
                    
                    modelpreview:SetModel(playermodel:GetText())
                end

--[[            for k = 0, dummyent:GetNumBodyGroups() - 1 do
                    if ( dummyent:GetBodygroupCount( k ) <= 1 ) then continue end

                    local slider = vgui.Create( 'DNumSlider', scrollpanel )
                    slider:Dock( TOP )
                    slider:DockMargin( 0, 0, 0, 5 )
                    slider:SetMax(dummyent:GetBodygroupCount( k ) - 1)
                    slider:SetDecimals( 0 )	
                    slider:SetText(MakeNiceName( dummyent:GetBodygroupName( k ) ))
                    table.insert(bodygrouppanels,slider)
                end ]]


                local accuracylevel = vgui.Create("DNumSlider",setting2)
                accuracylevel:SetPos(450,260)
                accuracylevel:SetSize(200,30)
                accuracylevel:SetMax(4)
                accuracylevel:SetMin(0)
                accuracylevel:SetDecimals( 0 )	
                accuracylevel:SetText("Accuracy Level")

                


                --- END SETTING 2 ---

                function savebutton:DoClick() 
                    if zetanameentry:GetText() == "" then
                        LocalPlayer():EmitSound("buttons/button10.wav")
                         
                        notification.AddLegacy("Add a name!",NOTIFY_ERROR,4)
                        return
                    end
                    LocalPlayer():EmitSound("buttons/button5.wav")

                    notification.AddLegacy("Saved "..zetanameentry:GetText().."'s profile!",NOTIFY_CLEANUP,4)


                    local profileDATA = {}

                    net.Start( "zetapanel_silentaddname" )
                        net.WriteString( zetanameentry:GetText() )
                    net.SendToServer()

                    profileDATA["name"] = zetanameentry:GetText()
                    profileDATA["avatar"] = pfp:GetText() != "" and pfp:GetText() or nil
                    profileDATA["playermodel"] = playermodel:GetText() != "" and playermodel:GetText() or nil
                    
                    if isadminbox:GetChecked() then
                        profileDATA["admindata"] = {}

                        profileDATA["admindata"]["isadmin"] = isadminbox:GetChecked()
                        profileDATA["admindata"]["strictness"] = strictnessslider:GetValue()
                    end

                    local strin, data = favoriteweapon:GetSelected()
                    if data != "NONE" then
                        profileDATA["favouriteweapon"] = data
                    end

                    if useplayermodelcolorbox:GetChecked() then
                        profileDATA["playermodelcolor"] = playermodelcolor:GetColor()
                    end

                    if usephysguncolorbox:GetChecked() then
                        profileDATA["physguncolor"] = physguncolor:GetColor()
                    end

                    profileDATA["accuracylevel"] = accuracylevel:GetValue()
                    
                    if mingebagbox:GetChecked() then
                        profileDATA["mingebag"] = true
                    end 

                    if teamoverride:GetSelected() != "" then
                        profileDATA["teamoverride"] = teamoverride:GetSelected()
                    end

                    if nodisconnect:GetChecked() then
                        profileDATA["nodisconnect"] = true
                    end 

                    if ispermafriend:GetChecked() then
                        profileDATA["permafriend"] = true
                    end

                    

                    local bodygroups = {}

                    for k,v in ipairs(bodygrouppanels) do
                        table.insert(bodygroups,{math.Round(v[1]:GetValue(),0),math.Round(v[2],0)})
                    end

                    profileDATA["bodygroups"] = bodygroups

                    profileDATA["skin"] = math.Round(skinslider:GetValue(),0)

                    

                    if health:GetValue() != 100 then
                        profileDATA["health"] = health:GetValue()
                    end

                    if armor:GetValue() != 0 then
                        profileDATA["armor"] = armor:GetValue()
                    end
                    local name,data = voicepack:GetSelected()
                    if data != "none" then
                        profileDATA["voicepack"] = data
                    end

                    profileDATA["voicepitch"] = voicepitch:GetValue()

                    
                    profileDATA["usecustomidle"] = usecustomidle:GetChecked() or nil
                    profileDATA["usecustomdeath"] = usecustomdeath:GetChecked() or nil
                    profileDATA["usecustomkill"] = usecustomkill:GetChecked() or nil
                    profileDATA["usecustomtaunt"] = usecustomtaunt:GetChecked() or nil
                    profileDATA["usecustompanic"] = usecustompanic:GetChecked() or nil
                    profileDATA["usecustomassist"] = usecustomassist:GetChecked() or nil
                    profileDATA["usecustomlaugh"] = usecustomlaugh:GetChecked() or nil
                    profileDATA["usecustomwitness"] = usecustomwitness:GetChecked() or nil
                    profileDATA["usecustomadminscold"] = usecustomadminscold:GetChecked() or nil
                    profileDATA["usecustomFalling"] = usecustomFalling:GetChecked() or nil
                    profileDATA["usecustomSitRespond"] = usecustomSitRespond:GetChecked() or nil
                    profileDATA["usecustomQuestion"] = usecustomQuestion:GetChecked() or nil
                    profileDATA["usecustomConRespond"] = usecustomConRespond:GetChecked() or nil
                    profileDATA["usecustomMediaWatch"] = usecustomMediaWatch:GetChecked() or nil
                    

                    if usepersonalitybox:GetChecked() then
                        profileDATA["personality"] = {}

                        profileDATA["personality"]["build"] = BuildChance:GetValue()
                        profileDATA["personality"]["tool"] = ToolChance:GetValue()
                        profileDATA["personality"]["combat"] = CombatChance:GetValue()
                        profileDATA["personality"]["physgun"] = PhysgunChance:GetValue()
                        profileDATA["personality"]["disrespect"] = DisrespectChance:GetValue()
                        profileDATA["personality"]["watchmedia"] = WatchmediaChance:GetValue()
                        profileDATA["personality"]["friendly"] = FriendlyChance:GetValue()
                        profileDATA["personality"]["voice"] = VoiceChance:GetValue()
                        profileDATA["personality"]["vehicle"] = VehicleChance:GetValue()
                        profileDATA["personality"]["text"] = TextChance:GetValue()
                        
                    end

                    strin, data = weapon:GetSelected()
                    if data != "NONE" then
                        profileDATA["weapon"] = data
                    end

                    if LocalPlayer():IsSuperAdmin() and !profiles[zetanameentry:GetText()] then
                        
                        local line = panellist:AddLine(profileDATA["name"])
                        line:SetSortValue( 1, profileDATA )
                        count = count + 1
                        panellist:SetDirty( true )
                        label:SetText('Welcome to the Profile Panel! There are '..count..' Profiles.')
                    elseif LocalPlayer():IsSuperAdmin() and profiles[zetanameentry:GetText()] then
                        local lines = panellist:GetLines()

                        for k,v in ipairs(lines) do
                            local tbl = v:GetSortValue(1)
                            if tbl["name"] == zetanameentry:GetText() then
                                v:SetSortValue(1,profileDATA)
                            end
                        end
                        
                    end

                    
                    net.Start("zetapanel_compileprofiledata")
                    net.WriteString(util.TableToJSON(profileDATA,true ))
                    net.SendToServer()
                end

                net.Receive("zetapanel_updatepanel",function()

                
                end)

                function panellist:OnRowRightClick(id,line)

                    local selectedprofile = line:GetSortValue(1)

                    local encode = util.TableToJSON(selectedprofile)

                    net.Start("zetapanel_removeprofile")
                        net.WriteString( encode )
                    net.SendToServer()

                    notification.AddLegacy('Removed '..line:GetSortValue(1)["name"].."'s profile",NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')
                    panellist:RemoveLine( id )
                    panellist:SetDirty( true )
                    count = count - 1
                    label:SetText('Welcome to the Profile Panel! There are '..count..' Profiles.')

                end
                

                function panellist:DoDoubleClick(id,line)
                    local tbl = line:GetSortValue(1)
                    LocalPlayer():EmitSound("buttons/blip1.wav")

                    playermodel:SetText(tbl["playermodel"] or "")
                    isadminbox:SetChecked(tbl["admindata"] and tbl["admindata"]["isadmin"] or false)
                    mingebagbox:SetChecked(tbl["mingebag"] or false)
                    strictnessslider:SetValue(tbl["admindata"] and tbl["admindata"]["strictness"] or 0)
                    zetanameentry:SetText(tbl["name"] or "")
                    pfp:SetText(tbl["avatar"] or "")

                    BuildChance:SetValue(tbl["personality"] and tbl["personality"]["build"] or 0)
                    ToolChance:SetValue(tbl["personality"] and tbl["personality"]["tool"] or 0)
                    CombatChance:SetValue(tbl["personality"] and tbl["personality"]["combat"] or 0)
                    PhysgunChance:SetValue(tbl["personality"] and tbl["personality"]["physgun"] or 0)
                    DisrespectChance:SetValue(tbl["personality"] and tbl["personality"]["disrespect"] or 0)
                    WatchmediaChance:SetValue(tbl["personality"] and tbl["personality"]["watchmedia"] or 0)
                    FriendlyChance:SetValue(tbl["personality"] and tbl["personality"]["friendly"] or 0)
                    VoiceChance:SetValue(tbl["personality"] and tbl["personality"]["voice"] or 0)
                    VehicleChance:SetValue(tbl["personality"] and tbl["personality"]["vehicle"] or 0)
                    TextChance:SetValue(tbl["personality"] and tbl["personality"]["text"] or 0)
                    voicepitch:SetValue(tbl["voicepitch"] or 100)
                    weapon:SetValue(tbl["weapon"] and weapon:GetOptionTextByData(tbl["weapon"]) or weapon:GetOptionTextByData( "NONE" ))

                    usepersonalitybox:SetChecked(tbl["personality"] and true or false )

                    playermodelcolor:SetColor(tbl["playermodelcolor"] or Color(255,255,255))

                    physguncolor:SetColor(tbl["physguncolor"] or Color(255,255,255))

                    useplayermodelcolorbox:SetChecked(tbl["playermodelcolor"] != nil)
                    usephysguncolorbox:SetChecked(tbl["physguncolor"] != nil)

                    nodisconnect:SetChecked(tbl["nodisconnect"] or false)
                    
                    accuracylevel:SetValue(tbl["accuracylevel"]) 

                    teamoverride:SetValue(teamoverride:GetOptionTextByData( tbl["teamoverride"] or "None" ))

                    ispermafriend:SetChecked(tbl["permafriend"] or false)
                    
                    
                    modelpreview:SetModel(tbl["playermodel"] or "models/player/kleiner.mdl")
                    UpdateBodyGroups()

                    local ent = modelpreview:GetEntity()
                    local bodygroups = tbl["bodygroups"]
                    if bodygroups then
                        for k,v in ipairs(bodygroups) do
                            ent:SetBodygroup(v[2],v[1])
                            if IsValid( bodygrouppanels ) then
                                bodygrouppanels[k][1]:SetValue(v[1])
                            end
                        end
                    end

                    skinslider:SetValue(tbl["skin"] or 0)
                    

                    voicepack:ChooseOptionID( VPIDS[tbl["voicepack"]] or 1 )
                    favoriteweapon:SetValue(tbl["favouriteweapon"] and favoriteweapon:GetOptionTextByData(tbl["favouriteweapon"]) or favoriteweapon:GetOptionTextByData( "NONE" ))

                    health:SetValue(tbl["health"] or 100)

                    armor:SetValue(tbl["armor"] or 0)

                    usecustomidle:SetChecked(tbl["usecustomidle"] or false)
                    usecustomdeath:SetChecked(tbl["usecustomdeath"] or false)
                    usecustomkill:SetChecked(tbl["usecustomkill"] or false)
                    usecustomtaunt:SetChecked(tbl["usecustomtaunt"] or false)
                    usecustompanic:SetChecked(tbl["usecustompanic"] or false)
                    usecustomassist:SetChecked(tbl["usecustomassist"] or false)
                    usecustomlaugh:SetChecked(tbl["usecustomlaugh"] or false)
                    usecustomwitness:SetChecked(tbl["usecustomwitness"] or false)
                    usecustomadminscold:SetChecked(tbl["usecustomadminscold"] or false)
                    usecustomFalling:SetChecked(tbl["usecustomFalling"] or false)
                    usecustomSitRespond:SetChecked(tbl["usecustomSitRespond"] or false)
                    usecustomQuestion:SetChecked(tbl["usecustomQuestion"] or false)
                    usecustomConRespond:SetChecked(tbl["usecustomConRespond"] or false)
                    usecustomMediaWatch:SetChecked(tbl["usecustomMediaWatch"] or false)

                    local col = playermodelcolor:GetColor()
                    local ent = modelpreview:GetEntity()
                    if IsValid(ent) then
                        ent.GetPlayerColor = function() return Color(col.r,col.g,col.b):ToVector() end
                    end

                    local profilepic = tbl["avatar"] or ""
                    local model = tbl["playermodel"] or ""

                    pfppreview:SetImage("../data/zetaplayerdata/custom_avatars/"..profilepic)
                    playermodelpreview:SetImage(string.Replace( "spawnicons/"..model,".mdl",".png"))
                end

            end
        end)

    end





    function OpenTextDataPanel()

        local textdata = {}
        net.Start('zetapanel_gettextdata')
        net.SendToServer()

        local starttime = CurTime()

        net.Receive('zetapanel_sendtextdata',function()
            local text = net.ReadString()
            local position = net.ReadString()
            local isdone = net.ReadBool()

            if !textdata[position] then
                textdata[position] = {}
            end
            table.insert(textdata[position],text)


            if isdone then -- Make the panel

                if GetConVar("zetaplayer_panelbgm"):GetString() != "" then
                    sound.PlayFile("sound/"..GetSound(GetConVar("zetaplayer_panelbgm"):GetString()), "", function(chan,errorid,erroname)
                        if !IsValid(chan) then
                            notification.AddLegacy("Warning! BGM Sound failed to load! Make sure the file path is correct!",NOTIFY_ERROR,7)
                            return
                        end

                        sndchan = chan
                        sndchan:EnableLooping( true )
                        sndchan:SetVolume(0.3)
                    end)
                end


                notification.AddLegacy("Received Text Data! Took "..CurTime()-starttime.." seconds",NOTIFY_CLEANUP,4)

                local frame = vgui.Create( 'DFrame' )
                frame:SetDeleteOnClose( true )
                frame:CenterHorizontal(0.3)
                frame:CenterVertical(0.4)
                frame:SetTitle('Zeta Text Data Panel')
                frame:SetIcon( 'icon/physgun.png' )
                frame:SetSize(1150,500)
                frame:MakePopup()

                function frame:OnClose()
                    if IsValid(sndchan) then
                    sndchan:Stop()
                    end
                end

                local mainsheet = vgui.Create("DPropertySheet",frame)
                mainsheet:Dock(FILL)

                local setting1 = vgui.Create("EditablePanel",mainsheet)
                setting1:Dock(FILL)

                mainsheet:AddSheet("Page 1",setting1)


                label = vgui.Create("DLabel",setting1)
                label:SetSize(1300,20)
                label:SetText("Welcome to the Text Data Panel! PLEASE READ IN THE Help/about TAB BEFORE USING THIS PANEL! Right click a line to remove it. Use the text boxes to add lines! Double click a line to copy it to a text box below it")
                label:SetPos(0,410)

                local idlelistview = vgui.Create("DListView",setting1)
                idlelistview:SetSize(200,350)
                idlelistview:SetPos(900,0)
                idlelistview:AddColumn( "IDLE", 1 )

                if textdata["idle"] and istable(textdata["idle"]) then
                    for k,v in ipairs(textdata["idle"]) do
                        local line = idlelistview:AddLine(v)
                        line:SetSortValue( 1, v )
                    end
                end

                function idlelistview:OnRowRightClick(id,line)
                    net.Start('zetapanel_removetext')
                    net.WriteString(line:GetSortValue(1))
                    net.WriteString("idle")
                    net.SendToServer()
                    notification.AddLegacy('Removed '..line:GetSortValue(1)..' from Text Data',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')
                    idlelistview:RemoveLine( id )
                    idlelistview:SetDirty( true )
                end

                local idletextbox = vgui.Create("DTextEntry",setting1)
                idletextbox:SetSize(200,20)
                idletextbox:SetPos(900,370)

                function idlelistview:DoDoubleClick(lineid,line)
                    idletextbox:SetText(line:GetSortValue(1))
                    LocalPlayer():EmitSound('buttons/button15.wav')
                end

                function idletextbox:OnEnter(val)
                    local line = idlelistview:AddLine(val)
                    line:SetSortValue( 1, val )
                    idlelistview:SetDirty( true )

                    notification.AddLegacy('Added '..val..' to Idle data',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')

                    idletextbox:SetText('')

                    net.Start("zetapanel_addtext")
                        net.WriteString(val)
                        net.WriteString("idle")
                    net.SendToServer()
                end


                label = vgui.Create("DLabel",setting1)
                label:SetSize(200,20)
                label:SetText("Idle Text Box")
                label:SetPos(900,390)

                local insultlistview = vgui.Create("DListView",setting1)
                insultlistview:SetSize(200,350)
                insultlistview:SetPos(690,0)
                insultlistview:AddColumn( "INSULT", 1 )

                if textdata["insult"] and istable(textdata["insult"]) then
                    for k,v in ipairs(textdata["insult"]) do
                        local line = insultlistview:AddLine(v)
                        line:SetSortValue( 1, v )
                    end
                end

                function insultlistview:OnRowRightClick(id,line)
                    net.Start('zetapanel_removetext')
                    net.WriteString(line:GetSortValue(1))
                    net.WriteString("insult")
                    net.SendToServer()
                    notification.AddLegacy('Removed '..line:GetSortValue(1)..' from Text Data',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')
                    insultlistview:RemoveLine( id )
                    insultlistview:SetDirty( true )
                end

                local insulttextbox = vgui.Create("DTextEntry",setting1)
                insulttextbox:SetSize(200,20)
                insulttextbox:SetPos(690,370)

                function insultlistview:DoDoubleClick(lineid,line)
                    insulttextbox:SetText(line:GetSortValue(1))
                    LocalPlayer():EmitSound('buttons/button15.wav')
                end

                function insulttextbox:OnEnter(val)
                    local line = insultlistview:AddLine(val)
                    line:SetSortValue( 1, val )
                    insultlistview:SetDirty( true )

                    notification.AddLegacy('Added '..val..' to Insult data',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')

                    insulttextbox:SetText('')

                    net.Start("zetapanel_addtext")
                        net.WriteString(val)
                        net.WriteString("insult")
                    net.SendToServer()
                end

                label = vgui.Create("DLabel",setting1)
                label:SetSize(200,20)
                label:SetText("Insult Text Box")
                label:SetPos(690,390)

                local responselistview = vgui.Create("DListView",setting1)
                responselistview:SetSize(200,350)
                responselistview:SetPos(480,0)
                responselistview:AddColumn( "RESPONSE", 1 )

                if textdata["response"] and istable(textdata["response"]) then
                    for k,v in ipairs(textdata["response"]) do
                        local line = responselistview:AddLine(v)
                        line:SetSortValue( 1, v )
                    end
                end

                function responselistview:OnRowRightClick(id,line)
                    net.Start('zetapanel_removetext')
                    net.WriteString(line:GetSortValue(1))
                    net.WriteString("response")
                    net.SendToServer()
                    notification.AddLegacy('Removed '..line:GetSortValue(1)..' from Text Data',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')
                    responselistview:RemoveLine( id )
                    responselistview:SetDirty( true )
                end

                local responsetextbox = vgui.Create("DTextEntry",setting1)
                responsetextbox:SetSize(200,20)
                responsetextbox:SetPos(480,370)

                function responselistview:DoDoubleClick(lineid,line)
                    responsetextbox:SetText(line:GetSortValue(1))
                    LocalPlayer():EmitSound('buttons/button15.wav')
                end

                function responsetextbox:OnEnter(val)
                    local line = responselistview:AddLine(val)
                    line:SetSortValue( 1, val )
                    responselistview:SetDirty( true )

                    notification.AddLegacy('Added '..val..' to Response data',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')

                    responsetextbox:SetText('')

                    net.Start("zetapanel_addtext")
                        net.WriteString(val)
                        net.WriteString("response")
                    net.SendToServer()
                end

                label = vgui.Create("DLabel",setting1)
                label:SetSize(200,20)
                label:SetText("Response Text Box")
                label:SetPos(480,390)

                local deathlistview = vgui.Create("DListView",setting1)
                deathlistview:SetSize(200,350)
                deathlistview:SetPos(270,0)
                deathlistview:AddColumn( "DEATH", 1 )

                if textdata["death"] and istable(textdata["death"]) then
                    for k,v in ipairs(textdata["death"]) do
                        local line = deathlistview:AddLine(v)
                        line:SetSortValue( 1, v )
                    end
                end

                function deathlistview:OnRowRightClick(id,line)
                    net.Start('zetapanel_removetext')
                    net.WriteString(line:GetSortValue(1))
                    net.WriteString("death")
                    net.SendToServer()
                    notification.AddLegacy('Removed '..line:GetSortValue(1)..' from Text Data',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')
                    deathlistview:RemoveLine( id )
                    deathlistview:SetDirty( true )
                end

                local deathtextbox= vgui.Create("DTextEntry",setting1)
                deathtextbox:SetSize(200,20)
                deathtextbox:SetPos(270,370)

                function deathlistview:DoDoubleClick(lineid,line)
                    deathtextbox:SetText(line:GetSortValue(1))
                    LocalPlayer():EmitSound('buttons/button15.wav')
                end

                function deathtextbox:OnEnter(val)
                    local line = deathlistview:AddLine(val)
                    line:SetSortValue( 1, val )
                    deathlistview:SetDirty( true )

                    notification.AddLegacy('Added '..val..' to Death data',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')

                    deathtextbox:SetText('')

                    net.Start("zetapanel_addtext")
                        net.WriteString(val)
                        net.WriteString("death")
                    net.SendToServer()
                end

                label = vgui.Create("DLabel",setting1)
                label:SetSize(200,20)
                label:SetText("Death Text Box")
                label:SetPos(270,390)

                local admininterrorlistview = vgui.Create("DListView",setting1)
                admininterrorlistview:SetSize(200,350)
                admininterrorlistview:SetPos(60,0)
                admininterrorlistview:AddColumn( "ADMIN INTERRO", 1 )

                if textdata["admininterror"] and istable(textdata["admininterror"]) then
                    for k,v in ipairs(textdata["admininterror"]) do
                        local line = admininterrorlistview:AddLine(v)
                        line:SetSortValue( 1, v )
                    end
                end

                function admininterrorlistview:OnRowRightClick(id,line)
                    net.Start('zetapanel_removetext')
                    net.WriteString(line:GetSortValue(1))
                    net.WriteString("admininterror")
                    net.SendToServer()
                    notification.AddLegacy('Removed '..line:GetSortValue(1)..' from Text Data',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')
                    admininterrorlistview:RemoveLine( id )
                    admininterrorlistview:SetDirty( true )
                end

                local admininterrortextbox = vgui.Create("DTextEntry",setting1)
                admininterrortextbox:SetSize(200,20)
                admininterrortextbox:SetPos(60,370)

                function admininterrorlistview:DoDoubleClick(lineid,line)
                    admininterrortextbox:SetText(line:GetSortValue(1))
                    LocalPlayer():EmitSound('buttons/button15.wav')
                end

                function admininterrortextbox:OnEnter(val)
                    local line = admininterrorlistview:AddLine(val)
                    line:SetSortValue( 1, val )
                    admininterrorlistview:SetDirty( true )

                    notification.AddLegacy('Added '..val..' to Admininterror data',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')

                    admininterrortextbox:SetText('')

                    net.Start("zetapanel_addtext")
                        net.WriteString(val)
                        net.WriteString("admininterror")
                    net.SendToServer()
                end

                label = vgui.Create("DLabel",setting1)
                label:SetSize(200,20)
                label:SetText("Admininterror Text Box")
                label:SetPos(60,390)


                
                
                




                local setting2 = vgui.Create("EditablePanel",mainsheet)
                setting2:Dock(FILL)

                local button = vgui.Create("DButton",setting2)
                button:SetPos(10,300)
                button:SetSize(200,30)
                button:SetText("Reset Text Data to Default")

                function button:DoClick()
                    RunConsoleCommand("zetaplayer_resettextdata")
                    notification.AddLegacy('Text Data has been Reset',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')
                    frame:Remove()
                end

                -- Function to make this easier.
                -- Why haven't I done this earlier? Oh well
                local function CreateTextLineList(name,textType,x,y,parent)

                    local linelistview = vgui.Create("DListView",parent) 
                    linelistview:SetSize(200,350)
                    linelistview:SetPos(x,y)
                    linelistview:AddColumn( name, 1 )
    
                    if textdata[textType] and istable(textdata[textType]) then
                        for k,v in ipairs(textdata[textType]) do
                            local line = linelistview:AddLine(v)
                            line:SetSortValue( 1, v )
                        end
                    end
    
                    function linelistview:OnRowRightClick(id,line)
                        net.Start('zetapanel_removetext')
                        net.WriteString(line:GetSortValue(1))
                        net.WriteString(textType)
                        net.SendToServer()
                        notification.AddLegacy('Removed '..line:GetSortValue(1)..' from Text Data',NOTIFY_CLEANUP,4)
                        LocalPlayer():EmitSound('buttons/button15.wav')
                        linelistview:RemoveLine( id )
                        linelistview:SetDirty( true )
                    end


    
                    local linetextbox = vgui.Create("DTextEntry",parent)
                    linetextbox:SetSize(200,20)
                    linetextbox:SetPos(x,y+370)

                    function linelistview:DoDoubleClick(lineid,line)
                        linetextbox:SetText(line:GetSortValue(1))
                        LocalPlayer():EmitSound('buttons/button15.wav')
                    end
    
                    function linetextbox:OnEnter(val)
                        local line = linelistview:AddLine(val)
                        line:SetSortValue( 1, val )
                        linelistview:SetDirty( true )
    
                        notification.AddLegacy('Added '..val..' to '..name..' data',NOTIFY_CLEANUP,4)
                        LocalPlayer():EmitSound('buttons/button15.wav')
    
                        linetextbox:SetText('')
    
                        net.Start("zetapanel_addtext")
                            net.WriteString(val)
                            net.WriteString(textType)
                        net.SendToServer()
                    end
    
    
                    label = vgui.Create("DLabel",parent)
                    label:SetSize(200,20)
                    label:SetText(name.." Text Box")
                    label:SetPos(x,y+390)

                end


                local mediawatchlistview = vgui.Create("DListView",setting2) 
                mediawatchlistview:SetSize(200,350)
                mediawatchlistview:SetPos(900,0)
                mediawatchlistview:AddColumn( "MEDIA WATCH", 1 )

                if textdata["mediawatch"] and istable(textdata["mediawatch"]) then
                    for k,v in ipairs(textdata["mediawatch"]) do
                        local line = mediawatchlistview:AddLine(v)
                        line:SetSortValue( 1, v )
                    end
                end

                function mediawatchlistview:OnRowRightClick(id,line)
                    net.Start('zetapanel_removetext')
                    net.WriteString(line:GetSortValue(1))
                    net.WriteString("idle")
                    net.SendToServer()
                    notification.AddLegacy('Removed '..line:GetSortValue(1)..' from Text Data',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')
                    mediawatchlistview:RemoveLine( id )
                    mediawatchlistview:SetDirty( true )
                end

                local mediawatchtextbox = vgui.Create("DTextEntry",setting2)
                mediawatchtextbox:SetSize(200,20)
                mediawatchtextbox:SetPos(900,370)

                function mediawatchlistview:DoDoubleClick(lineid,line)
                    mediawatchtextbox:SetText(line:GetSortValue(1))
                    LocalPlayer():EmitSound('buttons/button15.wav')
                end

                function mediawatchtextbox:OnEnter(val)
                    local line = mediawatchlistview:AddLine(val)
                    line:SetSortValue( 1, val )
                    mediawatchlistview:SetDirty( true )

                    notification.AddLegacy('Added '..val..' to Idle data',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')

                    mediawatchtextbox:SetText('')

                    net.Start("zetapanel_addtext")
                        net.WriteString(val)
                        net.WriteString("mediawatch")
                    net.SendToServer()
                end


                label = vgui.Create("DLabel",setting2)
                label:SetSize(200,20)
                label:SetText("Media Watch Text Box")
                label:SetPos(900,390)


                CreateTextLineList("Disconnect","disconnect",690,0,setting2)

                CreateTextLineList("Connect","connect",480,0,setting2)

                CreateTextLineList("Acknowledge","acknowledge",270,0,setting2)

                


                mainsheet:AddSheet("Page 2",setting2)

                local help = vgui.Create("EditablePanel",mainsheet)
                help:Dock(FILL)


                label = vgui.Create("DLabel",help)
                label:SetPos(10,-200)
                label:SetSize(1000,600)
                label:SetText("KeyPhrases. \n\n KeyPhrases are used to be replaced by whatever it is representing.\nFor example, /rndmap/ will be replaced with a map you have.\n\n-- KEYPHRASE LIST --\n\n/map/  This will translate to the current map being played on. This can be used anywhere\n/rndent/    This will translate to a random Zeta's or Player's name. This can be used anywhere\n/keyent/   This will used to mention a certain player or zeta in a certain situation. This can only be used in, response, death, insult, acknowledge, and admininterror.\n/rndmap/   This will translate into a random map you have. This can be used anywhere\n/curday/    This will translate to the current day of the week. For example, Friday. This can be used anywhere\n/rndword/ Translates to random word a Zeta said. This can only be used in Response\n/realplayer/ Translates to your name. This can be used anywhere\n/self/ Translates to the Zeta speaking the message. This can be used anywhere\n/rndaddon/ Translates to a random addon you have installed. This can be used anywhere")

                label = vgui.Create("DLabel",help)
                label:SetPos(10,-20)
                label:SetSize(1000,600)
                label:SetText("-- TEXT TYPES --\n\nadmininterror  This is used for Admins scolding a offender. Like adminscold voice lines. \nidle  Idle is idle. Self explanatory\ninsult  Insult is used for a zeta who has killed someone. Just like kill voice lines. \nresponse    Response is used for a Zeta who wants to respond to someone in text chat.\ndeath  Death is used for when the zeta dies.\n mediawatch is used for zetas watching a media player\nConnect  is used for when a Zeta spawns\nDisconnect is for when a Zeta is about to leave\nAcknowledge is for when a zeta acknowledges a command")



                mainsheet:AddSheet("Help/about",help)

            end
        
        end)

    end

    function OpenMediaPanel()

        local mediaurls = {}
        net.Start('zetapanel_getmediadata')
        net.SendToServer()

        local starttime = CurTime()
        net.Receive('zetapanel_sendmediadata',function()
            local urldata = net.ReadString()
            local isdone = net.ReadBool()

            if urldata != "PLACEHOLER" then
                local decode = util.JSONToTable(urldata)
                table.insert(mediaurls,decode)
            end


            if isdone then -- Make the panel

                if GetConVar("zetaplayer_panelbgm"):GetString() != "" then
                    sound.PlayFile("sound/"..GetSound(GetConVar("zetaplayer_panelbgm"):GetString()), "", function(chan,errorid,erroname)
                        if !IsValid(chan) then
                            notification.AddLegacy("Warning! BGM Sound failed to load! Make sure the file path is correct!",NOTIFY_ERROR,7)
                            return
                        end

                        sndchan = chan
                        sndchan:EnableLooping( true )
                        sndchan:SetVolume(0.3)
                    end)
                end


                notification.AddLegacy("Received Media URLs! Took "..CurTime()-starttime.." seconds",NOTIFY_CLEANUP,4)

                local frame = vgui.Create( 'DFrame' )
                frame:SetDeleteOnClose( true )
                frame:CenterHorizontal(0.3)
                frame:CenterVertical(0.4)
                frame:SetTitle('Zeta Text Data Panel')
                frame:SetIcon( 'icon/physgun.png' )
                frame:SetSize(1150,500)
                frame:MakePopup()

                function frame:OnClose()
                    if IsValid(sndchan) then
                    sndchan:Stop()
                    end
                end

                local mainsheet = vgui.Create("DPropertySheet",frame)
                mainsheet:Dock(FILL)

                local setting1 = vgui.Create("EditablePanel",mainsheet)
                setting1:Dock(FILL)

                mainsheet:AddSheet("Page 1",setting1)


                local label = vgui.Create("DLabel",setting1)
                label:SetSize(900,400)
                label:SetText("Welcome to the Media Panel!\n\nDouble left click a line to load it\n for editing\nRight click a line to remove it\nRead the text at the very\n bottom for details\non adding new videos")
                label:SetPos(10,-140)

                local MainLISTVIEW = vgui.Create("DListView",setting1)
                MainLISTVIEW:SetSize(800,250)
                MainLISTVIEW:SetPos(200,0)
                MainLISTVIEW:AddColumn( "Video Title", 2 )
                MainLISTVIEW:AddColumn( "Duration (In Seconds)", 3 )
                MainLISTVIEW:AddColumn( "URL", 4 )

                local function Addmediadatatolist(title,duration,url)
                    local line = MainLISTVIEW:AddLine({title,duration,url})
                    line:SetSortValue( 2, title )
                    line:SetColumnText( 2, tostring(title) )
                    line:SetSortValue( 3, duration )
                    line:SetColumnText( 3, tostring(duration) )
                    line:SetSortValue( 4, url )
                    line:SetColumnText( 4, tostring(url) )
                end

                local function compilelinemediadata(line)
                    local title = line:GetSortValue(2)
                    local duration = line:GetSortValue(3)
                    local url = line:GetSortValue(4)

                    return {title,duration,url}
                end



                local title = vgui.Create("DTextEntry",setting1)
                title:SetSize(280,30)
                title:SetPos(200,270)

                label = vgui.Create("DLabel",setting1)
                label:SetSize(900,20)
                label:SetText("Video Title")
                label:SetPos(200,300)

                local duration = vgui.Create("DTextEntry",setting1)
                duration:SetSize(200,30)
                duration:SetPos(510,270)

                label = vgui.Create("DLabel",setting1)
                label:SetSize(900,20)
                label:SetText("Video Duration")
                label:SetPos(510,300)

                local url = vgui.Create("DTextEntry",setting1)
                url:SetSize(280,30)
                url:SetPos(730,270)

                label = vgui.Create("DLabel",setting1)
                label:SetSize(900,20)
                label:SetText("Video URL")
                label:SetPos(730,300)

                label = vgui.Create("DLabel",setting1)
                label:SetSize(900,200)
                label:SetText("Add a Video Title to the Video Title box.\n Add the duration IN SECONDS! to the Video Duration box. \nNext add the video URL to the Video URL box. \nWhen you are done, press Send Media to save it")
                label:SetPos(200,300)

                for k,v in ipairs(mediaurls) do
                    Addmediadatatolist(v[1],v[2],v[3])
                end

                local function CompileTextEntrydata()
                    local mediatitle = title:GetText()
                    local mediaduration = tonumber(duration:GetText())
                    local mediaurl = url:GetText()

                    title:SetText("")
                    duration:SetText("")
                    url:SetText("")

                    return {mediatitle,mediaduration,mediaurl}
                end

                local add = vgui.Create("DButton",setting1)
                add:SetSize(110,20)
                add:SetText("Send Media")
                add:SetPos(1020,275)

                function add:DoClick() 

                    local mediadata = CompileTextEntrydata()

                    if mediadata[1] == "" then
                        notification.AddLegacy('NO VIDEO TITLE SET!',NOTIFY_ERROR,4)
                        LocalPlayer():EmitSound('buttons/button10.wav')
                        return 
                    elseif mediadata[2] == "" then
                        notification.AddLegacy('NO VIDEO DURATION SET!',NOTIFY_ERROR,4)
                        LocalPlayer():EmitSound('buttons/button10.wav')
                        return 
                    elseif mediadata[3] == "" then
                        notification.AddLegacy('NO VIDEO URL SET!',NOTIFY_ERROR,4)
                        LocalPlayer():EmitSound('buttons/button10.wav')
                        return 
                    end

                    net.Start("zetapanel_addmedia",true)
                        net.WriteString(util.TableToJSON(mediadata))
                    net.SendToServer()

                    Addmediadatatolist(mediadata[1],mediadata[2],mediadata[3])

                    notification.AddLegacy('Sent '..mediadata[1]..' to Media Data',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')
                end

                
                local reset = vgui.Create("DButton",setting1)
                reset:SetSize(110,20)
                reset:SetText("Reset to Default")
                reset:SetPos(1020,415)

                function reset:DoClick() 
                    frame:Remove()
                    RunConsoleCommand("zetaplayer_reseturllist")
                    notification.AddLegacy('Reset Media Data',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')
                end
                
                function MainLISTVIEW:OnRowRightClick(id,line)

                    local mediadata = compilelinemediadata(line)

                    notification.AddLegacy('Removed '..mediadata[1],NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')
                    MainLISTVIEW:RemoveLine( id )
                    MainLISTVIEW:SetDirty( true )

                    mediadata = util.TableToJSON(mediadata)

                    net.Start("zetapanel_removemedia",true)
                        net.WriteString(mediadata)
                    net.SendToServer()
                end

                function MainLISTVIEW:DoDoubleClick( lineID, line )

                    local mediadata = compilelinemediadata(line)

                    title:SetText(mediadata[1])
                    duration:SetText(mediadata[2])
                    url:SetText(mediadata[3])
                    LocalPlayer():EmitSound('buttons/button15.wav')
                end

            end
        
        end)

    end




    function OpenBlockPanel()

        local blockedmodels = {}

        net.Start('zetapanel_getblockedmodels')
        net.SendToServer()

        local starttime = CurTime()

        net.Receive('zetapanel_sendblockedmodel',function()
            local ent = net.ReadString()
            local isdone = net.ReadBool()

            if ent != "PLACEHOLDER" then
                table.insert(blockedmodels,ent)
            end

            if isdone then -- Make the panel

                if GetConVar("zetaplayer_panelbgm"):GetString() != "" then
                    sound.PlayFile("sound/"..GetSound(GetConVar("zetaplayer_panelbgm"):GetString()), "", function(chan,errorid,erroname)
                        if !IsValid(chan) then
                            notification.AddLegacy("Warning! BGM Sound failed to load! Make sure the file path is correct!",NOTIFY_ERROR,7)
                            return
                        end

                        sndchan = chan
                        sndchan:EnableLooping( true )
                        sndchan:SetVolume(0.3)
                    end)
                end


                notification.AddLegacy("Received all Blocked Models! Took "..CurTime()-starttime.." seconds",NOTIFY_CLEANUP,4)
                local count = #blockedmodels
                
                local frame = vgui.Create( 'DFrame' )
                frame:SetDeleteOnClose( true )
                frame:CenterHorizontal(0.3)
                frame:CenterVertical(0.4)
                frame:SetTitle('Blocked Playermodels Panel')
                frame:SetIcon( 'icon/physgun.png' )
                frame:SetSize(1000,500)
                frame:MakePopup()

                function frame:OnClose()
                    if IsValid(sndchan) then
                    sndchan:Stop()
                    end
                end

                local label = vgui.Create( 'DLabel', frame )
                label:SetText('Welcome to the Blocked Models Panel! There are '..count..' Blocked Models. Right click a Model path in the list to the right to remove it')
                label:Dock(TOP)

                local label2 = vgui.Create( 'DLabel', frame )
                label2:SetText('Click on a model to block it')
                label2:Dock(TOP)



                local scrollpan = vgui.Create( "DScrollPanel", frame )
                scrollpan:SetSize(600,100)
                scrollpan:Dock( LEFT )

                local List = vgui.Create( "DIconLayout", scrollpan )
                List:Dock( FILL )
                List:SetSpaceY( 12 )
                List:SetSpaceX( 12 )



                local panellist = vgui.Create( 'DListView', frame )

                panellist:Dock(RIGHT)
                panellist:SetSize(400,300)
                panellist:AddColumn('Blocked Playermodels',1)


                for k,v in ipairs(blockedmodels) do
                    local line = panellist:AddLine(v)
                    line:SetSortValue( 1, v )
                end

                function panellist:OnRowRightClick(id,line)

                    net.Start('zetapanel_removeblockedmodel')
                    net.WriteString(line:GetSortValue(1))
                    net.SendToServer()

                    notification.AddLegacy('Removed '..line:GetSortValue(1)..' from Blocked Models',NOTIFY_CLEANUP,4)
                    LocalPlayer():EmitSound('buttons/button15.wav')
                    panellist:RemoveLine( id )
                    panellist:SetDirty( true )
                    count = count - 1
                    label:SetText('Welcome to the Blocked Models Panel! There are '..count..' Blocked Models. Right click a Model path in the list to the right to remove it')
                end



                for k, v in pairs(player_manager.AllValidModels()) do
                    
                    local mdlbutton = List:Add( "SpawnIcon" )
                    mdlbutton:SetModel( v )

                    function mdlbutton:DoClick()

                        net.Start('zetapanel_addblockedmodel')
                        net.WriteString(mdlbutton:GetModelName())
                        net.SendToServer()


                    
                        local line = panellist:AddLine( mdlbutton:GetModelName() )
                        line:SetSortValue( 1, mdlbutton:GetModelName() )
                        panellist:SetDirty( true )
                        count = count + 1
                        label:SetText('Welcome to the Blocked Models Panel! There are '..count..' Blocked Models. Right click a Model path in the list to the right to remove it')

                    end


                end




            end

        end) -- End Net message
        end


        function OpenVotingPanel()

            local votingdata = {}
    
            net.Start('zetapanel_getvotedata')
            net.SendToServer()
    
            local starttime = CurTime()
    
            net.Receive('zetapanel_sendvotedata',function()
                local data = net.ReadString()
                local isdone = net.ReadBool()
    
                local tbl = util.JSONToTable(data)
                if ent != "PLACEHOLDER" then
                    table.insert(votingdata,tbl)
                end
    
                if isdone then -- Make the panel

                    if GetConVar("zetaplayer_panelbgm"):GetString() != "" then
                        sound.PlayFile("sound/"..GetSound(GetConVar("zetaplayer_panelbgm"):GetString()), "", function(chan,errorid,erroname)
                            if !IsValid(chan) then
                                notification.AddLegacy("Warning! BGM Sound failed to load! Make sure the file path is correct!",NOTIFY_ERROR,7)
                                return
                            end
    
                            sndchan = chan
                            sndchan:EnableLooping( true )
                            sndchan:SetVolume(0.3)
                        end)
                    end

    
                    notification.AddLegacy("Received all Vote Data! Took "..CurTime()-starttime.." seconds",NOTIFY_CLEANUP,4)
                    
                    local frame = vgui.Create( 'DFrame' )
                    frame:SetDeleteOnClose( true )
                    frame:CenterHorizontal(0.3)
                    frame:CenterVertical(0.4)
                    frame:SetTitle('Voting Data Panel')
                    frame:SetIcon( 'icon/physgun.png' )
                    frame:SetSize(700,500)
                    frame:MakePopup()

                    function frame:OnClose()
                        if IsValid(sndchan) then
                        sndchan:Stop()
                        end
                    end
                    

                    local label = vgui.Create( 'DLabel', frame )
                    label:SetText('Welcome to the Vote Data Panel!')
                    label:Dock(TOP)

                    label = vgui.Create( 'DLabel', frame )
                    label:SetText('Right click a row here to remove it')
                    label:SetPos(5,70)
                    label:SetSize(350,20)

                    label = vgui.Create( 'DLabel', frame )
                    label:SetText('Add a title to the vote you want to add\nand add options to the vote')
                    label:SetPos(320,100)
                    label:SetSize(350,40)

                    local DataList = vgui.Create("DListView",frame)
                    DataList:AddColumn("Voting Data",1)
                    DataList:SetPos(0,100)
                    DataList:SetSize(300,300)

                    for k,v in ipairs(votingdata) do
                        local line = DataList:AddLine(v[1])
                        line:SetSortValue(1,v[2])
                    end



                    local optionsList = vgui.Create("DListView",frame)
                    optionsList:AddColumn("Vote Options",1)
                    optionsList:SetPos(320,200)
                    optionsList:SetSize(300,200)

                    local Title = vgui.Create("DTextEntry",frame)
                    Title:SetPos(320,170)
                    Title:SetSize(300,20)

                    label = vgui.Create( 'DLabel', frame )
                    label:SetText('Vote Title')
                    label:SetPos(320,150)
                    label:SetSize(300,20)

                    function DataList:DoDoubleClick(id,line)
                        optionsList:Clear()
                        
                        local data = line:GetSortValue(1)
                        Title:SetValue(line:GetColumnText( 1 ))
                        for k,v in ipairs(data) do
                            local line = optionsList:AddLine(v)
                            line:SetSortValue(1,v)
                        end
                    end

                    function optionsList:OnRowRightClick(id,line)

                        optionsList:RemoveLine( id )
                        optionsList:SetDirty( true )
                        LocalPlayer():EmitSound("buttons/button14.wav")
                    end

                    local optionTextPanel = vgui.Create("DTextEntry",frame)
                    optionTextPanel:SetPos(320,410)
                    optionTextPanel:SetSize(300,20)

                    label = vgui.Create( 'DLabel', frame )
                    label:SetText('Add vote options here. Note that you can only have 10 options')
                    label:SetPos(320,430)
                    label:SetSize(350,20)
    
                    local addbutton = vgui.Create("DButton",frame)
                    addbutton:SetText("Submit Vote Data")
                    addbutton:SetPos(320,460)
                    addbutton:SetSize(300,20)

                    function optionTextPanel:OnEnter(val)
                        local options = optionsList:GetLines()
                        if #options >= 10 then
                            LocalPlayer():EmitSound("buttons/button10.wav")
                            notification.AddLegacy("Reached Option limit!",NOTIFY_ERROR,3)
                            return
                        end
                        local line = optionsList:AddLine(val)
                        line:SetSortValue(1,val)
                        optionTextPanel:SetText("")
                        LocalPlayer():EmitSound("buttons/button14.wav")
                    end

                    local function IsTitleUsed(title)
                        local lines = DataList:GetLines()
                        local titleused = false
                        for k,v in ipairs(lines) do
                            if v:GetColumnText(1) == title then
                                titleused = true
                                break
                            end
                        end

                        return titleused
                    end

                    local function CompileVoteData()
                        local title = Title:GetText()

                        if IsTitleUsed(title) then
                            LocalPlayer():EmitSound("buttons/button10.wav")
                            notification.AddLegacy("Inputted Title already exists!",NOTIFY_ERROR,3)
                            return false
                        end

                        if title == "" then
                            LocalPlayer():EmitSound("buttons/button10.wav")
                            notification.AddLegacy("No Title set!",NOTIFY_ERROR,3)
                            return false
                        end
                        local options = optionsList:GetLines()
                        if #options < 2 then
                            LocalPlayer():EmitSound("buttons/button10.wav")
                            notification.AddLegacy("You must have more than one option!",NOTIFY_ERROR,3)
                            return false
                        end

                        local compiledoptions = {}

                        for k,v in ipairs(options) do
                            compiledoptions[#compiledoptions+1] = v:GetSortValue(1)
                        end

                        

                        return {title,compiledoptions}
                    end

                    function DataList:OnRowRightClick(id,line)

                        DataList:RemoveLine( id )
                        DataList:SetDirty( true )
                        LocalPlayer():EmitSound("buttons/button14.wav")
                        net.Start("zetapanel_removevotedata",true)
                        net.WriteString(line:GetColumnText(1))
                        net.SendToServer()
                    end

                    

                    function addbutton:DoClick()
                        local data = CompileVoteData()
                        if !data then return end

                        local line = DataList:AddLine(data[1])
                        line:SetSortValue(1,data[2])

                        net.Start("zetapanel_addvotedata",true)
                        net.WriteString(util.TableToJSON(data))
                        net.SendToServer()
                    end
    
    
    
                end
    
            end) -- End Net message

        end



        function OpenTeamEntSavePanel()
            local MapEntData = {}
    
            net.Start('zetapanel_getteamentdata')
            net.SendToServer()
    
            local starttime = CurTime()
    
            net.Receive('zetapanel_sendteamentdata',function()
                local data = net.ReadString()
                local isdone = net.ReadBool()
    
                if data != "PLACEHOLDER" then
                    table.insert(MapEntData,data)
                end
    
                if isdone then -- Make the panel

                    if GetConVar("zetaplayer_panelbgm"):GetString() != "" then
                        sound.PlayFile("sound/"..GetSound(GetConVar("zetaplayer_panelbgm"):GetString()), "", function(chan,errorid,erroname)
                            if !IsValid(chan) then
                                notification.AddLegacy("Warning! BGM Sound failed to load! Make sure the file path is correct!",NOTIFY_ERROR,7)
                                return
                            end
    
                            sndchan = chan
                            sndchan:EnableLooping( true )
                            sndchan:SetVolume(0.3)
                        end)
                    end

    
                    notification.AddLegacy("Received all Team Ent Data! Took "..CurTime()-starttime.." seconds",NOTIFY_CLEANUP,4)
                    
                    local frame = vgui.Create( 'DFrame' )
                    frame:SetDeleteOnClose( true )
                    frame:CenterHorizontal(0.3)
                    frame:CenterVertical(0.4)
                    frame:SetTitle('Team Ent Save Data Panel')
                    frame:SetIcon( 'icon/physgun.png' )
                    frame:SetSize(500,400)
                    frame:MakePopup()

                    function frame:OnClose()
                        if IsValid(sndchan) then
                        sndchan:Stop()
                        end
                    end
                    

                    local label = vgui.Create( 'DLabel', frame )
                    label:SetText('Welcome to the Team Ent Data Panel!')
                    label:Dock(TOP)

                    local DataList = vgui.Create("DListView",frame)
                    DataList:AddColumn("Team Ent Data Files",1)
                    DataList:SetPos(0,100)
                    DataList:SetSize(300,300)

                    for k,v in ipairs(MapEntData) do
                        local line = DataList:AddLine(v)
                        line:SetSortValue(1,v)
                    end

                    label = vgui.Create( 'DLabel', frame )
                    label:SetText('Enter the name of the save and\n press enter to save it')
                    label:SetSize(400, 50)
                    label:SetPos(300,50)

                    label = vgui.Create( 'DLabel', frame )
                    label:SetText('Select a row below and press Load Selected File\nto load it in game')
                    label:SetSize(400, 50)
                    label:SetPos(10,50)

                    local saveents = vgui.Create("DTextEntry",frame)
                    saveents:SetSize(200, 20)
                    saveents:SetPos(300,100)

                    local loadents = vgui.Create("DButton",frame)
                    loadents:SetSize(200, 40)
                    loadents:SetPos(300,360)
                    loadents:SetText("Load Selected File")

                    function saveents:OnEnter(val)
                        local line = DataList:AddLine(val)
                        line:SetSortValue(1,val)
                        saveents:SetText("")
                        LocalPlayer():EmitSound("buttons/button14.wav")
                        net.Start("zetapanel_saveteamentdata")
                        net.WriteString(val)
                        net.SendToServer()
                    end

                    function DataList:OnRowRightClick(id,line)
                        net.Start("zetapanel_removeteamentdata")
                        net.WriteString(line:GetSortValue(1))
                        net.SendToServer()
                        DataList:RemoveLine(id)
                        DataList:SetDirty(true)
                        LocalPlayer():EmitSound("buttons/button15.wav")
                    end

                    function loadents:DoClick()
                        local id,line = DataList:GetSelectedLine()
                        if line then
                            LocalPlayer():EmitSound("buttons/button14.wav")
                            net.Start("zetapanel_loadteamentdata")
                            net.WriteString(line:GetSortValue(1))
                            net.SendToServer()
                        end
                    end
    
                end
    
            end) -- End Net message
        end



        function OpenZetaPresetPanel()

            if !file.Exists( "zetaplayerdata/presets.json", "DATA" ) then
                ZetaFileWrite( "zetaplayerdata/presets.json", util.Compress( util.TableToJSON( { ["Default"] = _zetaconvardefault } ) ) )
            end

            file.CreateDir("zetaplayerdata/preset_import")

            if GetConVar("zetaplayer_panelbgm"):GetString() != "" then
                sound.PlayFile("sound/"..GetSound(GetConVar("zetaplayer_panelbgm"):GetString()), "", function(chan,errorid,erroname)
                    if !IsValid(chan) then
                        notification.AddLegacy("Warning! BGM Sound failed to load! Make sure the file path is correct!",NOTIFY_ERROR,7)
                        return
                    end

                    sndchan = chan
                    sndchan:EnableLooping( true )
                    sndchan:SetVolume(0.3)
                end)
            end
            
            local frame = vgui.Create( "DFrame" )
            frame:SetSize(400,300)
            frame:Center()
            frame:MakePopup()
            frame:SetTitle( "Zeta Preset panel")

            function frame:OnClose()
                if IsValid(sndchan) then
                sndchan:Stop()
                end
            end

            local label = vgui.Create( "DLabel", frame )
            label:SetText( "Right Click a preset in the list below to show a list of options for that preset" )
            label:Dock( TOP )

            local listview = vgui.Create( "DListView", frame )
            listview:Dock(FILL)
            listview:AddColumn( "Presets", 1 )

            local presetjson = file.Read( "zetaplayerdata/presets.json" )

            if presetjson then

                presetjson = util.Decompress( presetjson )
                presetjson = util.JSONToTable( presetjson )

                for k, v in pairs( presetjson ) do
                    local line = listview:AddLine( k )
                    line:SetSortValue( 1, v )
                end

            end

            local savebutton = vgui.Create( "DButton", frame )

            savebutton:SetText( "Save current settings" )
            savebutton:Dock(BOTTOM)

            local exportconvarsbutton = vgui.Create( "DButton", frame )
            exportconvarsbutton:SetText( "Export Current Settings" )
            exportconvarsbutton:Dock(BOTTOM)

            local importconvarsbutton = vgui.Create( "DButton", frame )
            importconvarsbutton:SetText( "Import Zeta Preset" )
            importconvarsbutton:Dock(BOTTOM)



            function listview:OnRowRightClick( id, line )

                local menu = DermaMenu( false, frame )

                menu:AddOption( "View Convars", function() 
                
                    local convarframe = vgui.Create( "DFrame" )
                    convarframe:SetSize(600,300)
                    convarframe:Center()
                    convarframe:MakePopup()
                    convarframe:SetTitle( line:GetColumnText( 1 ).." Convars" )
                    convarframe:SetSizable( true )


                    local convarlist = vgui.Create( "DListView", convarframe )
                    convarlist:Dock(FILL)
                    convarlist:AddColumn( "Convar Name", 1 )
                    convarlist:AddColumn( "Convar Value", 2 )

                    for k, v in pairs( line:GetSortValue( 1 ) ) do
                        local newline = convarlist:AddLine( k, tostring( v ) )
                    end
                
                end )

                

                    menu:AddOption( "Apply this preset", function()
                    
                        _ZetaApplyPreset( line:GetSortValue( 1 ) )

                        local data = util.TableToJSON( line:GetSortValue( 1 ) )
                        data = util.Compress( data )

                        net.Start( "zetapanel_setpresetsserverside" )
                            net.WriteUInt( #data, 32 )
                            net.WriteData( data )
                        net.SendToServer()

                    end )

                    if line:GetColumnText( 1 ) != "Default" then


                    menu:AddOption( "Delete This Preset", function()
                    
                        Derma_Query( "Are you sure you want to delete this preset?", "Confirmation:", "Yes", 
                        
                        function() 

                            

                            local newpresetjson = file.Read( "zetaplayerdata/presets.json" )

                            if newpresetjson then
                                
                                newpresetjson = util.Decompress( newpresetjson )
                                newpresetjson = util.JSONToTable( newpresetjson )

                                newpresetjson[ line:GetColumnText( 1 ) ] = nil

                                newpresetjson = util.TableToJSON( newpresetjson )
                                newpresetjson = util.Compress( newpresetjson )

                                ZetaFileWrite( "zetaplayerdata/presets.json", newpresetjson )
                            end

                            listview:RemoveLine( id )

                        end, "No" )

                    end )

                    menu:AddOption( "Rename This Preset", function()
                    
                        Derma_StringRequest( "Rename Preset", "Input a new name for this preset", "", function( text ) 

                            

                            local newpresetjson = file.Read( "zetaplayerdata/presets.json" )

                            if newpresetjson then
                                
                                newpresetjson = util.Decompress( newpresetjson )
                                newpresetjson = util.JSONToTable( newpresetjson )


                                newpresetjson[ text ] = line:GetSortValue( 1 )

                                local newline = listview:AddLine( text )
                                newline:SetSortValue( 1, line:GetSortValue( 1 ) )

                                newpresetjson[ line:GetColumnText( 1 ) ] = nil

                                newpresetjson = util.TableToJSON( newpresetjson )
                                newpresetjson = util.Compress( newpresetjson )

                                ZetaFileWrite( "zetaplayerdata/presets.json", newpresetjson )
                            end

                            listview:RemoveLine( id )

                        end )

                    end )

                end

            end


            local function GetZetaConvars()
                local currentconvarsettings = {}

                for k, v in pairs( _zetaconvardefault ) do
                    currentconvarsettings[ k ] = GetConVar( k ):GetString() 
                end

                return currentconvarsettings
            end

            local function SavePreset( name, isoverwrite )
                if name == "Default" then return end

                local convars = GetZetaConvars()

                local tbl = presetjson or {}

                tbl[ name ] = convars

                if !isoverwrite then
                    local line = listview:AddLine( name )
                    line:SetSortValue( 1, convars )

                    listview:InvalidateLayout()
                end

                local json = util.TableToJSON( tbl )
                json = util.Compress( json )

                ZetaFileWrite( "zetaplayerdata/presets.json" , json )
            end

            function exportconvarsbutton:DoClick()

                Derma_StringRequest( "Export Preset", "Input a name for this preset", "", function( text ) 

                    file.CreateDir("zetaplayerdata/preset_exports")

                    local convars = GetZetaConvars()

                    local tbl = {}

                    tbl[ text ] = convars

                    local json = util.TableToJSON( tbl )
                    json = util.Compress( json )

                    local filename = "presetexport_"..text

                    ZetaFileWrite( "zetaplayerdata/preset_exports/"..filename..".json" , json )

                    Derma_Message("Exported Current Settings to garrysmod/data/zetaplayerdata/preset_exports/"..filename..".json", "ConVar Export", "Ok" )

                end )

            end

            function importconvarsbutton:DoClick()

                local fileframe = vgui.Create( "DFrame" )
                fileframe:SetSize(600,300)
                fileframe:Center()
                fileframe:MakePopup()
                fileframe:SetTitle( "Import Settings File" )

                local importlabel = vgui.Create( "DLabel", fileframe )
                importlabel:SetText( "Place exported setting files in garrysmod/data/zetaplayerdata/preset_import folder. Click on a file below to import it" )
                importlabel:Dock( TOP )

                local presetlist = vgui.Create( "DListView", fileframe )
                presetlist:Dock(FILL)
                presetlist:AddColumn( "Found Preset Files", 1)

                local files = file.Find( "zetaplayerdata/preset_import/*", "DATA", "namedesc")

                if files then
                    
                    for k, v in ipairs( files ) do
                        local line = presetlist:AddLine( v )
                    end

                end

                function presetlist:OnRowSelected( id, line )

                    Derma_Query( "Import settings file "..line:GetColumnText( 1 ).."?", "Settings Import", "Import", function() 
                    
                        local presetfile = file.Read( "zetaplayerdata/preset_import/"..line:GetColumnText( 1 ) )

                        if presetfile then
                            
                            presetfile = util.Decompress( presetfile )
                            presetfile = util.JSONToTable( presetfile )

                            local name = "NULL"

                            for k, v in pairs( presetfile ) do

                                name = k

                                local newline = listview:AddLine( k )
                                newline:SetSortValue( 1, v )
                                
                                break
                            end

                            local newpresetjson = file.Read( "zetaplayerdata/presets.json" )

                            if newpresetjson then
                                
                                newpresetjson = util.Decompress( newpresetjson )
                                newpresetjson = util.JSONToTable( newpresetjson )

                                newpresetjson[ name ] = presetfile

                                newpresetjson = util.TableToJSON( newpresetjson )
                                newpresetjson = util.Compress( newpresetjson )

                                ZetaFileWrite( "zetaplayerdata/presets.json", newpresetjson )

                                fileframe:Remove()
                            end

                            

                        end
                    
                    end, "Cancel")

                end

            end

            function savebutton:DoClick()

                Derma_StringRequest( "Save Preset", "Input a name for this new preset", "", function( text ) 
                    
                    if presetjson and istable( presetjson ) and presetjson[ text ] then
                        if text == "Default" then Derma_Message( "You can't overwrite the Default Preset!", "Preset Save Warning", "Ok" ) return end
                        
                        Derma_Query( "A Preset with this name already exists! Would you like to overwrite it?", "Confirmation:", "Yes", function() SavePreset( text, true ) end, "No" )

                        return
                    end

                    SavePreset( text )
                
                end, nil, "Save")

            end 



        end


        function OpenViewShotViewerPanel()

            local frame = vgui.Create( "DFrame" )
            frame:SetSize(800,800)
            frame:Center()
            frame:MakePopup()
            frame:SetSizable( true )
            frame:SetTitle( "View Shots" )

            local scrollpanel = vgui.Create( "DScrollPanel", frame )
            scrollpanel:Dock( FILL )

            local cleanviewshots = vgui.Create( "DButton", frame )
            cleanviewshots:Dock(BOTTOM)
            cleanviewshots:SetText( "Delete all View Shots" )

            local viewshots = file.Find( "zetaplayerdata/zeta_viewshots/*", "DATA", "datedesc" )

            local stopgenerating = false

            function cleanviewshots:DoClick()

                stopgenerating = true

                for k, v in ipairs( viewshots ) do

                    file.Delete( "zetaplayerdata/zeta_viewshots/" .. v )

                end

                scrollpanel:Clear()
                surface.PlaySound( "buttons/button5.wav" )
            end
            

            if viewshots and #viewshots > 0 then
                
                InitializeCoroutineThread( function()
                    
                    for k, v in ipairs( viewshots ) do
                        if !IsValid( frame ) or stopgenerating then return end
                        
                        local image = vgui.Create( "DImageButton", scrollpanel )
                        image:SetSize(100,400)
                        image:DockMargin( 0, 30, 0, 0)
                        image:Dock( TOP )
                        image:SetMaterial( Material( "../data/zetaplayerdata/zeta_viewshots/" .. v ) )

                        local name = vgui.Create( "DLabel", scrollpanel )
                        name:SetText( "View Shot Name: " .. v )
                        name:Dock( TOP )



                        function image:DoClick()

                            local imagename = name
                            local filename = v

                            local menu = DermaMenu( false, image )

                            menu:AddOption( "Delete File", function() 

                                file.Delete( "zetaplayerdata/zeta_viewshots/" .. filename )
                                
                                image:Remove()
                                imagename:Remove()

                                surface.PlaySound( "buttons/button9.wav" )
                            
                            end )

                        end

                        coroutine.wait( 0.3 )
                    end
                
                end )

            end
        end






        file.CreateDir( "zetaplayerdata/names_import")

        function OpenNameRegisterPanel(caller)
            
            

            local keynames = {}

            local frame = vgui.Create( "DFrame" )
            frame:SetSize( 400, 400 )
            frame:Center()
            frame:SetSizable( true )
            frame:MakePopup()
            frame:SetTitle( "Name Panel" )

            local namelist = vgui.Create( "DListView", frame )
            namelist:Dock( FILL )
            namelist:AddColumn( "Names", 1 )

            local importfilebutton = vgui.Create( "DButton", frame )
            importfilebutton:DockMargin( 0, 30, 0, 0 )
            importfilebutton:Dock( BOTTOM )
            importfilebutton:SetText( "Import Name .TXT or .JSON" )

            local nameentry = vgui.Create( "DTextEntry", frame )
            nameentry:Dock( BOTTOM )
            nameentry:SetPlaceholderText( "Enter a new name here" )

            local searchbar = vgui.Create( "DTextEntry", frame )
            searchbar:Dock( TOP )
            searchbar:SetPlaceholderText( "Search bar" )

            local hint = vgui.Create( "DLabel", frame )
            hint:Dock( TOP )
            hint:SetText( "Right Click a name listed to remove it" )

            local hint2 = vgui.Create( "DLabel", frame )
            hint2:Dock( TOP )
            hint2:SetText( "Enter a name in the text box below to add it to the name list" )

            local names = file.Read( "zetaplayerdata/names.json" )

            if names then

                names = util.JSONToTable( names )

                for k, v in ipairs( names ) do
                    keynames[ v ] = v
                end

            end

            for k, v in SortedPairs( keynames ) do
                
                local line = namelist:AddLine( v )
                line:SetSortValue( 1, v )

            end

            function searchbar:OnChange()

                namelist:Clear()

                if searchbar:GetText() == "" then

                    for k, v in SortedPairs( keynames ) do
                
                        local line = namelist:AddLine( v )
                        line:SetSortValue( 1, v )
        
                    end

                    return 
                end

                

                for k, v in SortedPairs( keynames ) do
                    
                    local match = string.find( string.lower( v ), string.lower( searchbar:GetText() ) )

                    if match then

                        local line = namelist:AddLine( v )
                        line:SetSortValue( 1, v )
                        
                    end

                end

            end


            function nameentry:OnEnter( val )

                nameentry:SetText( "" )

                local json = file.Read( "zetaplayerdata/names.json", "DATA" )
                local decoded = util.JSONToTable( json )


                if table.HasValue( decoded, val ) then
                        notification.AddLegacy( val .. " is already registered!", NOTIFY_ERROR, 3)
                        surface.PlaySound( "buttons/button10.wav" )
                    return
                end

                table.insert( decoded, val )

                local encoded = util.TableToJSON( decoded, true )

                ZetaFileWrite("zetaplayerdata/names.json",encoded)

                notification.AddLegacy( "Added " .. val .. " to the name list!", NOTIFY_GENERIC, 1.5)

                surface.PlaySound( "buttons/button14.wav" )

                local line = namelist:AddLine( val )
                line:SetSortValue( 1, val )

                keynames[ val ] = val

            end

            function namelist:OnRowRightClick( id, line )

                local namesjson = file.Read( "zetaplayerdata/names.json", "DATA" )
                namesjson = util.JSONToTable( namesjson )

                table.RemoveByValue( namesjson,  line:GetSortValue( 1 ) )

                local encoded = util.TableToJSON( namesjson, true )

                ZetaFileWrite("zetaplayerdata/names.json",encoded)

                notification.AddLegacy( "Removed " .. line:GetSortValue( 1 ) .. " from the name list!", NOTIFY_CLEANUP, 1.5)

                surface.PlaySound( "buttons/button14.wav" )

                namelist:RemoveLine( id )

                namelist:InvalidateLayout()

            end

            function importfilebutton:DoClick()

                local importframe = vgui.Create( "DFrame" )
                importframe:SetSize( 500, 400 )
                importframe:Center()
                importframe:SetSizable( true )
                importframe:MakePopup()
                importframe:SetTitle( "File Importer" )

                local importlist = vgui.Create( "DListView", importframe )
                importlist:Dock( FILL )
                importlist:AddColumn( "Files", 1 )

                local hint = vgui.Create( "DLabel", importframe )
                hint:Dock( TOP )
                hint:SetText( "Put names.jsons or txt files that are formatted like" )

                local hint3 = vgui.Create( "DLabel", importframe )
                hint3:DockMargin( 0, 10, 0, 0 )
                hint3:Dock( TOP )
                hint3:SetText( "Lucy" )

                local hint4 = vgui.Create( "DLabel", importframe )
                hint4:Dock( TOP )
                hint4:SetText( "Harmony" )

                local hint5 = vgui.Create( "DLabel", importframe )
                hint5:Dock( TOP )
                hint5:SetText( "Thorn" )
                hint5:DockMargin( 0, 0, 0, 10 )

                local hint2 = vgui.Create( "DLabel", importframe )
                hint2:Dock( TOP )
                hint2:SetText( "in garrysmod/data/zetaplayerdata/names_import" )


                
                local hint2 = vgui.Create( "DLabel", importframe )
                hint2:Dock( TOP )
                hint2:SetText( "Click on a file to attempt to import it" )

                local files = file.Find( "zetaplayerdata/names_import/*", "DATA" )

                for k, v in ipairs( files ) do
                    
                    local namefile = importlist:AddLine( v )
                    namefile:SetSortValue( 1, v )

                end


                function importlist:OnRowSelected( id, line )
                    local filename = line:GetSortValue( 1 )

                    Derma_Query( "Import "..filename.."?", "Names Import", "Import", function() 
                        
                        local stringdata = file.Read( "zetaplayerdata/names_import/" .. filename )

                        if !stringdata then Derma_Message( "Failed to import "..filename.."! String data came out as NIL", "Import Failure", "Ok" ) return end
                    
                        local json = util.JSONToTable( stringdata )

                        if json and istable( json ) then

                            local count = 0

                            local namesjson = file.Read( "zetaplayerdata/names.json", "DATA" )
                            namesjson = util.JSONToTable( namesjson )

                            for k, v in ipairs( json ) do
                                
                                if table.HasValue( namesjson, v ) then continue end
            
                                table.insert( namesjson, v )
                                count = count + 1

                                print( "Imported "..v.." into the Zeta Name List" )

                                local line = namelist:AddLine( v )
                                line:SetSortValue( 1, v )

                                keynames[ v ] = v

                            end


                            local encoded = util.TableToJSON( namesjson, true )

                            ZetaFileWrite("zetaplayerdata/names.json",encoded)
            
                            notification.AddLegacy( "Imported " .. count .. " names to the name list!", NOTIFY_GENERIC, 1.5)
            
                            surface.PlaySound( "buttons/button14.wav" )
            



                            return
                        end

                        local split = string.Explode( "\n", stringdata )

                        local count = 0

                        local namesjson = file.Read( "zetaplayerdata/names.json", "DATA" )
                        namesjson = util.JSONToTable( namesjson )

                        for k, v in ipairs( split ) do
                            
                            if table.HasValue( namesjson, v ) then continue end
            
                            table.insert( namesjson, v )
                            count = count + 1

                            print( "Imported "..v.." into the Zeta Name List" )

                            local line = namelist:AddLine( v )
                            line:SetSortValue( 1, v )

                            keynames[ v ] = v

                        end

                        local encoded = util.TableToJSON( namesjson, true )

                        ZetaFileWrite("zetaplayerdata/names.json",encoded)
        
                        notification.AddLegacy( "Imported " .. count .. " names to the name list!", NOTIFY_GENERIC, 1.5)
        
                        surface.PlaySound( "buttons/button14.wav" )

                    
                    
                    end, "Cancel" )

                end

            end




        end




        local function GetBonePosAngs( self, index)
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
          
        local function GetAttachmentPoint( self, pointtype)
          
            if pointtype == "hand" then
          
              local lookup = self:LookupAttachment('anim_attachment_RH')
          
              if lookup == 0 then
                  local bone = self:LookupBone("ValveBiped.Bip01_R_Hand")
                
                  if !bone then
                    return {Pos = (self:GetPos()+self:OBBCenter()),Ang = self:GetForward():Angle()}
                  else
                    if isnumber(bone) then
                      return GetBonePosAngs( self, bone)
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
          


          local green = Color( 0, 255, 0 )

          file.CreateDir( "zetaplayerdata/weapon_import" )

        function OpenWeaponCreationPanel()

            local weaponmdl
            local shelloffsetx = 0
            local shelloffsety = 0
            local shelloffsetz = 0
            local shellanglep = 0
            local shellangley = 0
            local shellangler = 0
            local savedweapondata
            local useshelldata = true 
            local shellname = "ShellEject"
            local weaponscalevar = 1
            local precallbackcode 
            local onchangecode
            local onthinkcode
            local ondamagedcode
            local reloadtimecode
            local disablebonemerge = false

            local frame = vgui.Create( "DFrame" )
            frame:SetSize( 300, 300 )
            frame:Center()
            frame:SetSizable( true )
            frame:MakePopup()
            frame:SetTitle( "Weapon Creation Panel" )

            local createnewranged = vgui.Create( "DButton", frame )
            createnewranged:Dock( TOP )
            createnewranged:SetText( "Create New Ranged Weapon" )

            local createnewmelee = vgui.Create( "DButton", frame )
            createnewmelee:Dock( TOP )
            createnewmelee:SetText( "Create New Melee Weapon" )

            local importweapondata = vgui.Create( "DButton", frame )
            importweapondata:Dock( TOP )
            importweapondata:SetText( "Import weapon .vmt files" )

            local weaponlist = vgui.Create( "DListView", frame )
            weaponlist:Dock( FILL )
            weaponlist:AddColumn( "Weapons", 1 ) 



            local weapondata = file.Read( "zetaplayerdata/weapondata.dat" )

            if !weapondata then weapondata = util.Compress( "[]" ) ZetaFileWrite( "zetaplayerdata/weapondata.dat", util.Compress( "[]" ) ) end

            weapondata = util.Decompress( weapondata )
            weapondata = util.JSONToTable( weapondata )

            for k, v in SortedPairs( weapondata ) do
                
                local line = weaponlist:AddLine( v.prettyPrint )
                line:SetSortValue( 1, { k, v } )

            end


            function weaponlist:OnRowRightClick( id, line )
                local sortval = line:GetSortValue( 1 )
                local confirm = Derma_Query( "Delete " .. sortval[ 2 ].prettyPrint .. "?", "Delete Weapon", "Delete", function() 
                
                    local data = file.Read( "zetaplayerdata/weapondata.dat" )

                    data = util.Decompress( data )
                    data = util.JSONToTable( data )

                    data[ sortval[ 1 ] ] = nil 

                    weaponlist:RemoveLine( id )

                    surface.PlaySound( "buttons/button15.wav" )

                    data = util.TableToJSON( data )
                    data = util.Compress( data )

                    ZetaFileWrite( "zetaplayerdata/weapondata.dat", data )

                    timer.Simple( 0, function()

                        notification.AddLegacy( "Updating Spawnmenu and Weapons.. You may experience lag for a few seconds", NOTIFY_HINT, 4 )

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
                        net.Start( "zetaweaponcreator_updateweapons" )
                        net.SendToServer()

                        include("zeta/weapon_tables.lua")

                        _ZetaRegisterDefaultWeapons()
                        
                    end)
                
                end, "Cancel" )

            end


            function weaponlist:OnRowSelected( id, line )

                local menu = DermaMenu( false, weaponlist )
                menu:Center()

                menu:AddOption( "Load Weapon", function()
                
                    savedweapondata = line:GetSortValue( 1 )


                    if savedweapondata[ 2 ].range then

                        createnewranged:DoClick()

                    elseif savedweapondata[ 2 ].melee then
                        
                        createnewmelee:DoClick()

                    end
                
                end )

                menu:AddOption( "Export Weapon", function()
                    local sortval = line:GetSortValue( 1 )

                    local weaponholder = {}

                    weaponholder[ sortval[ 1 ] ] = sortval[ 2 ]

                    local data = util.TableToJSON( weaponholder )
                    data = util.Compress( data )

                    file.CreateDir( "zetaplayerdata/weapon_exports" )
                    file.Write( "zetaplayerdata/weapon_exports/" .. sortval[ 1 ] .. ".vmt", data )

                    Derma_Message( "Exported " .. sortval[ 2 ].prettyPrint .. " to zetaplayerdata/weapon_exports/" .. sortval[ 1 ] .. ".vmt" )

                end )

            end





            function importweapondata:DoClick()

                file.CreateDir( "zetaplayerdata/weapon_import" )

                local fileframe = vgui.Create( "DFrame" )
                fileframe:SetSize(600,300)
                fileframe:Center()
                fileframe:MakePopup()
                fileframe:SetTitle( "Import Weapon data" )

                local importlabel = vgui.Create( "DLabel", fileframe )
                importlabel:SetText( "Place exported weapon .vmt files in garrysmod/data/zetaplayerdata/weapon_import folder. Click on a file below to import it" )
                importlabel:Dock( TOP )

                local newweaponlist = vgui.Create( "DListView", fileframe )
                newweaponlist:Dock(FILL)
                newweaponlist:AddColumn( "Found Weapon .vmt Files", 1)

                local files = file.Find( "zetaplayerdata/weapon_import/*.vmt", "DATA", "namedesc")
                local addonfiles = file.Find( "materials/zetaplayer/custom_weapons/*.vmt", "GAME" )
                

                if files then
                    
                    for k, v in ipairs( files ) do
                        local line = newweaponlist:AddLine( v )
                        line:SetSortValue( 1, v )
                    end

                end

                if addonfiles then
                    
                    for k, v in ipairs( addonfiles ) do
                        local line = newweaponlist:AddLine( "[ ADDON WEAPON ] " .. v )
                        line:SetSortValue( 1, v )
                    end

                end

                function newweaponlist:OnRowSelected( id, line )

                    Derma_Query( "Import Weapon .vmt file " .. line:GetSortValue( 1 ) .. "?", "Weapons Import", "Import", function() 
                    
                        local weaponfile = file.Read( "zetaplayerdata/weapon_import/" .. line:GetSortValue( 1 ) ) or file.Read( "materials/zetaplayer/custom_weapons/" .. line:GetSortValue( 1 ), "GAME" )

                        if weaponfile then
                            
                            local data = util.Decompress( weaponfile )
                            data = util.JSONToTable( data )

                            local weapondata = file.Read( "zetaplayerdata/weapondata.dat" )

                            weapondata = util.Decompress( weapondata )
                            weapondata = util.JSONToTable( weapondata )

                            for k, v in pairs( data ) do

                                if weapondata[ k ] then

                                    Derma_Query( "Weapon Classname " .. k .. " already exists! Would you like to overwrite it?", "Weapon Conflict", "Yes", function()

                                        local line = weaponlist:AddLine( v.prettyPrint )
                                        line:SetSortValue( 1, { k, v } )

                                        weaponlist:InvalidateLayout()
                                    
                                        weapondata[ k ] = v

                                        weapondata = util.TableToJSON( weapondata )
                                        weapondata = util.Compress( weapondata )
        
                                        ZetaFileWrite( "zetaplayerdata/weapondata.dat", weapondata )
        
        
        
        
        
                                        timer.Simple( 0, function()
        
                                            notification.AddLegacy( "Updating Spawnmenu and Weapons.. You may experience lag for a few seconds", NOTIFY_HINT, 4 )
                    
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
                    
                                            net.Start( "zetaweaponcreator_updateweapons" )
                                            net.SendToServer()
                    
                                            include("zeta/weapon_tables.lua")
                    
                                            _ZetaRegisterDefaultWeapons()
                                            
                                        end)

                                        surface.PlaySound( "buttons/button5.wav" )


                                    
                                    
                                    end, "No" )

                                    
                                    
                                    return
                                end
                                
                                weapondata[ k ] = v

                                weapondata = util.TableToJSON( weapondata )
                                weapondata = util.Compress( weapondata )

                                ZetaFileWrite( "zetaplayerdata/weapondata.dat", weapondata )





                                timer.Simple( 0, function()

                                    notification.AddLegacy( "Updating Spawnmenu and Weapons.. You may experience lag for a few seconds", NOTIFY_HINT, 4 )
            
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
            
                                    net.Start( "zetaweaponcreator_updateweapons" )
                                    net.SendToServer()
            
                                    include("zeta/weapon_tables.lua")
            
                                    _ZetaRegisterDefaultWeapons()
                                    
                                end)


                                surface.PlaySound( "buttons/button5.wav" )

                                local line = weaponlist:AddLine( v.prettyPrint )
                                line:SetSortValue( 1, { k, v } )

                                weaponlist:InvalidateLayout()
                                

                            end

                        end
                    
                    end, "Cancel")

                end

            end



            -- Ranged weapon panel
            function createnewranged:DoClick()
                frame:Remove()

                local rangedframe = vgui.Create( "DFrame" )
                rangedframe:SetSize( 900, 700 )
                rangedframe:Center()
                rangedframe:MakePopup()
                rangedframe:SetTitle( "Ranged Weapon Panel" )

                local leftpnl = vgui.Create( "EditablePanel", rangedframe )
                leftpnl:SetSize( 200, 200 )
                leftpnl:Dock( LEFT )

                local label = vgui.Create( "DLabel", leftpnl )
                label:Dock( TOP )
                label:SetText( "Weapon Class Name ( Must be unique )" )

                label = vgui.Create( "DLabel", leftpnl )
                label:Dock( TOP )
                label:SetText( "Example: STRIKER" )
 
                local weaponsclassname = vgui.Create( "DTextEntry", leftpnl )
                weaponsclassname:Dock( TOP )
                weaponsclassname:SetText( savedweapondata and savedweapondata[ 1 ] or "" )



                label = vgui.Create( "DLabel", leftpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Weapon Pretty Print" )

                label = vgui.Create( "DLabel", leftpnl )
                label:Dock( TOP )
                label:SetText( "Example: Striker" )

                label = vgui.Create( "DLabel", leftpnl )
                label:Dock( TOP )
                label:SetText( "( The name that's displayed in kill feed," )

                label = vgui.Create( "DLabel", leftpnl )
                label:Dock( TOP )
                label:SetText( "stats, ect )" )
 
                local weaponsprettyname = vgui.Create( "DTextEntry", leftpnl )
                weaponsprettyname:Dock( TOP )
                weaponsprettyname:SetText( savedweapondata and savedweapondata[ 2 ].prettyPrint or "")

                label = vgui.Create( "DLabel", leftpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "The amount of ammo in the clip" )

                local clip = vgui.Create( "DNumSlider", leftpnl )
                clip:Dock( TOP )
                clip:SetDecimals( 0 )
                clip:SetMax( 2000 )
                clip:SetMin( 1 )
                clip:SetValue( savedweapondata and savedweapondata[ 2 ].clip or 30 )
                clip:SetText( "Clip" )

                label = vgui.Create( "DLabel", leftpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "The animations to use with" )

                local enumtostring = {
                    [ ACT_HL2MP_IDLE_PISTOL ] = "Pistol",
                    [ ACT_HL2MP_IDLE_AR2 ] = "Ar2",
                    [ ACT_HL2MP_IDLE_REVOLVER ] = "357",
                    [ ACT_HL2MP_IDLE_SHOTGUN ] = "Shotgun",
                    [ ACT_HL2MP_IDLE_CAMERA ] = "Camera",
                    [ ACT_HL2MP_IDLE_SMG1 ] = "SMG1",
                    [ ACT_HL2MP_IDLE_PHYSGUN ] = "Physgun",
                    [ ACT_HL2MP_IDLE_GRENADE ] = "Grenade",
                    [ ACT_HL2MP_IDLE_RPG ] = "RPG",
                    [ ACT_HL2MP_IDLE_CROSSBOW ] = "Crossbow",
                    [ ACT_HL2MP_IDLE ] = "Holster",
                    [ ACT_HL2MP_IDLE_MAGIC ] = "Magic",
                    [ ACT_HL2MP_IDLE_DUEL ] = "Duel"
                }

                local indextranslation = {
                    [ "Ar2" ] = 1,
                    [ "Pistol" ] = 2,
                    [ "357" ] = 3,
                    [ "Shotgun" ] = 4,
                    [ "SMG1" ] = 5,
                    [ "RPG" ] = 6,
                    [ "Physgun" ] = 7,
                    [ "Camera" ] = 8,
                    [ "Crossbow" ] = 9,
                    [ "Grenade" ] = 10,
                    [ "Holster" ] = 11,
                    [ "Magic" ] = 12,
                    [ "Duel" ] = 13
                }
                

                local animations = vgui.Create( "DComboBox", leftpnl )
                animations:Dock( TOP )
                animations:AddChoice( "Ar2", "Ar2", true )
                animations:AddChoice( "Pistol" )
                animations:AddChoice( "357" )
                animations:AddChoice( "Shotgun" )
                animations:AddChoice( "SMG1" )
                animations:AddChoice( "RPG" )
                animations:AddChoice( "Physgun" )
                animations:AddChoice( "Camera" )
                animations:AddChoice( "Crossbow" )
                animations:AddChoice( "Grenade" )
                animations:AddChoice( "Holster" )
                animations:AddChoice( "Magic" )
                animations:AddChoice( "Duel" )

                if savedweapondata then
                    animations:ChooseOptionID( indextranslation[ enumtostring[ savedweapondata[ 2 ].anims.idle ] ] )
                end

                label = vgui.Create( "DLabel", leftpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "The distance this should be shot from" )

                local keepdistance = vgui.Create( "DNumSlider", leftpnl )
                keepdistance:Dock( TOP )
                keepdistance:SetDecimals( 0 )
                keepdistance:SetMax( 2000 )
                keepdistance:SetMin( 1 )
                keepdistance:SetValue( savedweapondata and savedweapondata[ 2 ].keepDistance or 300 )
                keepdistance:SetText( "Keep Distance" )


                local midpnl = vgui.Create( "EditablePanel", rangedframe )
                midpnl:DockMargin( 30, 0, 0, 0 )
                midpnl:SetSize( 200, 200 )
                midpnl:Dock( LEFT )

                label = vgui.Create( "DLabel", midpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "The minimum amount of time to" )

                label = vgui.Create( "DLabel", midpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "shoot the weapon" )

                local fireratemin = vgui.Create( "DNumSlider", midpnl )
                fireratemin:Dock( TOP )
                fireratemin:SetDecimals( 2 )
                fireratemin:SetMax( 20 )
                fireratemin:SetMin( 0.01 )
                fireratemin:SetValue( savedweapondata and savedweapondata[ 2 ].fireData.rateMin or 0.3 )
                fireratemin:SetText( "Fire Rate Min" )



                label = vgui.Create( "DLabel", midpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "The maximum amount of time to" )

                label = vgui.Create( "DLabel", midpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "shoot the weapon" )

                local fireratemax = vgui.Create( "DNumSlider", midpnl )
                fireratemax:Dock( TOP )
                fireratemax:SetDecimals( 2 )
                fireratemax:SetMax( 20 )
                fireratemax:SetMin( 0.01 )
                fireratemax:SetValue( savedweapondata and savedweapondata[ 2 ].fireData.rateMax or 0.6 )
                fireratemax:SetText( "Fire Rate Max" )


                label = vgui.Create( "DLabel", midpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Recoil Animation" )


                local recoilenumtostring = {
                    [ ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL ] = "Pistol",
                    [ ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2 ] = "Ar2",
                    [ ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER ] = "357",
                    [ ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN ] = "Shotgun",
                    [ ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1 ] = "SMG1",
                    [ ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE ] = "Grenade",
                    [ ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG ] = "RPG",
                    [ ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW ] = "Crossbow",
                }

                local recoilindextranslation = {
                    [ "Ar2" ] = 1,
                    [ "Pistol" ] = 2,
                    [ "357" ] = 3,
                    [ "Shotgun" ] = 4,
                    [ "SMG1" ] = 5,
                    [ "RPG" ] = 6,
                    [ "Crossbow" ] = 7,
                    [ "Grenade" ] = 8,
                }

                local recoilanimations = vgui.Create( "DComboBox", midpnl )
                recoilanimations:Dock( TOP )
                recoilanimations:AddChoice( "Ar2", "Ar2", true )
                recoilanimations:AddChoice( "Pistol" )
                recoilanimations:AddChoice( "357" )
                recoilanimations:AddChoice( "Shotgun" )
                recoilanimations:AddChoice( "SMG1" )
                recoilanimations:AddChoice( "RPG" )
                recoilanimations:AddChoice( "Crossbow" )
                recoilanimations:AddChoice( "Grenade" )

                if savedweapondata then
                    local enum = recoilenumtostring[ savedweapondata[ 2 ].fireData.anim ]
                    recoilanimations:ChooseOptionID( recoilindextranslation[ enum ] )
                end

                label = vgui.Create( "DLabel", midpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "MuzzleFlash Type" )

                local flashtranslation = {
                    [ 1 ] = 1,
                    [ 7 ] = 2,
                    [ 5 ] = 3
                }

                local Muzzleflash = vgui.Create( "DComboBox", midpnl )
                Muzzleflash:Dock( TOP )
                Muzzleflash:AddChoice( "Generic Muzzleflash", 1, true )
                Muzzleflash:AddChoice( "Larger Generic Muzzleflash", 7 )
                Muzzleflash:AddChoice( "Ar2 Muzzleflash", 5 )

                if savedweapondata then
                    Muzzleflash:ChooseOptionID( flashtranslation[ savedweapondata[ 2 ].fireData.muzzleFlash ] )
                end

                label = vgui.Create( "DLabel", midpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Tracer Type" )

                local tracertranslation = {
                    [ "Tracer" ] = 1,
                    [ "AR2Tracer" ] = 2,
                    [ "LaserTracer" ] = 3,
                    [ "ToolTracer" ] = 4
                }

                local tracer = vgui.Create( "DComboBox", midpnl )
                tracer:Dock( TOP )
                tracer:AddChoice( "Generic Tracer", "Tracer", true )
                tracer:AddChoice( "AR2 Tracer", "AR2Tracer" )
                tracer:AddChoice( "Laser Tracer", "LaserTracer" )
                tracer:AddChoice( "Toolgun Tracer", "ToolTracer" )

                if savedweapondata then
                    tracer:ChooseOptionID( tracertranslation[ savedweapondata[ 2 ].fireData.tracer ] )
                end


                label = vgui.Create( "DLabel", midpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Edit Shell Eject Effects" )

                local shelleditbutton = vgui.Create( "DButton", midpnl )
                shelleditbutton:Dock( TOP )
                shelleditbutton:SetText( "Open Shell Eject Editor" )


                
                if savedweapondata and savedweapondata[ 2 ].shellData then
                    shelloffsetx = savedweapondata[ 2 ].shellData.offPos.forward
                    shelloffsety = savedweapondata[ 2 ].shellData.offPos.right
                    shelloffsetz = savedweapondata[ 2 ].shellData.offPos.up

                    shellanglep = savedweapondata[ 2 ].shellData.offAng[ 1 ]
                    shellangley = savedweapondata[ 2 ].shellData.offAng[ 2 ]
                    shellangler = savedweapondata[ 2 ].shellData.offAng[ 3 ]
                end


                function shelleditbutton:DoClick()

                    local shellframe = vgui.Create( "DFrame" )
                    shellframe:SetSize( 500, 700 )
                    shellframe:Center()
                    shellframe:SetSizable( true )
                    shellframe:MakePopup()
                    shellframe:SetTitle( "Shell Eject Editor" )

                    label = vgui.Create( "DLabel", shellframe )
                    label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "Eject Shells?" )
                    
                    local ejectshellallowed = vgui.Create( "DCheckBox", shellframe )
                    ejectshellallowed:SetSize( 40, 40 )
                    ejectshellallowed:DockMargin( 0, 0, 440, 0 )
                    ejectshellallowed:Dock( TOP )

                    ejectshellallowed:SetChecked( savedweapondata and savedweapondata[ 2 ].shellData != nil or !savedweapondata and useshelldata )

                    function ejectshellallowed:OnChange( val )
                        useshelldata = val
                    end

                    local shelltranslation = {
                        [ "ShellEject" ] = 1,
                        [ "RifleShellEject" ] = 2,
                        [ "ShotgunShellEject" ] = 3,
                    }
                    
                    label = vgui.Create( "DLabel", shellframe )
                    label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "Shell Type" )

                    local shellnames = vgui.Create( "DComboBox", shellframe )
                    shellnames:Dock( TOP )
                    shellnames:AddChoice( "ShellEject", "ShellEject", true )
                    shellnames:AddChoice( "RifleShellEject" )
                    shellnames:AddChoice( "ShotgunShellEject" )

    
                    if savedweapondata and savedweapondata[ 2 ].shellData and savedweapondata[ 2 ].shellData.name then
                        local enum = shelltranslation[ savedweapondata[ 2 ].shellData.name ]
                        recoilanimations:ChooseOptionID( enum )
                        shellname = enum
                    end

                    function shellnames:OnSelect( index, val, data )

                        shellname = val

                    end
                    


                    label = vgui.Create( "DLabel", shellframe )
                    label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "Position Offset" ) 
    
                    local offsetx = vgui.Create( "DNumSlider", shellframe )
                    offsetx:Dock( TOP )
                    offsetx:SetDecimals( 3 )
                    offsetx:SetMax( 1000 )
                    offsetx:SetMin( -1000 )
                    offsetx:SetValue( shelloffsetx or 0 )
                    offsetx:SetText( "X" )
    
                    local offsety = vgui.Create( "DNumSlider", shellframe )
                    offsety:Dock( TOP )
                    offsety:SetDecimals( 3 )
                    offsety:SetMax( 1000 )
                    offsety:SetMin( -1000 )
                    offsety:SetValue( shelloffsety or 0 )
                    offsety:SetText( "Y" )
    
                    local offsetz = vgui.Create( "DNumSlider", shellframe )
                    offsetz:Dock( TOP )
                    offsetz:SetDecimals( 3 )
                    offsetz:SetMax( 1000 )
                    offsetz:SetMin( -1000 )
                    offsetz:SetValue( shelloffsetz or 0 )
                    offsetz:SetText( "Z" )
    
    
    
                    label = vgui.Create( "DLabel", shellframe )
                    label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "Angle Offset" ) 
    
                    local offsetp = vgui.Create( "DNumSlider", shellframe )
                    offsetp:Dock( TOP )
                    offsetp:SetDecimals( 3 )
                    offsetp:SetMax( 180 )
                    offsetp:SetMin( -180 )
                    offsetp:SetValue( shellanglep or 0 )
                    offsetp:SetText( "Pitch" )
    
                    local offsetyAng = vgui.Create( "DNumSlider", shellframe )
                    offsetyAng:Dock( TOP )
                    offsetyAng:SetDecimals( 3 )
                    offsetyAng:SetMax( 180 )
                    offsetyAng:SetMin( -180 )
                    offsetyAng:SetValue( shellangley or 0 )
                    offsetyAng:SetText( "Yaw" )
    
                    local offsetr = vgui.Create( "DNumSlider", shellframe )
                    offsetr:Dock( TOP )
                    offsetr:SetDecimals( 3 )
                    offsetr:SetMax( 180 )
                    offsetr:SetMin( -180 )
                    offsetr:SetValue( shellangler or 0 )
                    offsetr:SetText( "Roll" )



                    local weaponpreview = vgui.Create( "DAdjustableModelPanel", shellframe )
                    weaponpreview:SetSize( 100, 200)
                    weaponpreview:Dock( FILL )
                    weaponpreview:SetModel( weaponmdl:GetText() )

                    local previewent = weaponpreview:GetEntity()
                    previewent:SetAngles( Angle(0,0,0) )


                    weaponpreview:OnMousePressed( MOUSE_LEFT )

                    timer.Simple( 0, function() 
                        weaponpreview:OnMouseReleased( MOUSE_LEFT )
                    end )
    
                    

                    function weaponpreview:LayoutEntity( ent )
                    end

                    function weaponpreview:PostDrawModel( ent )
                        shelloffsetx = offsetx:GetValue()
                        shelloffsety = offsety:GetValue()
                        shelloffsetz = offsetz:GetValue()

                        shellanglep = offsetp:GetValue()
                        shellangley = offsetyAng:GetValue()
                        shellangler = offsetr:GetValue()

                        local pos = Vector( shelloffsetx, shelloffsety, shelloffsetz )
                        local ang = Angle( shellanglep, shellangley, shellangler )
                        
                        
                        
                        render.DrawLine( pos, pos + ang:Forward() * 40, Color( 255, 0, 0) )

                        render.SetColorMaterial()

                        render.DrawSphere( pos, 1, 50, 50, color_white )


                    end

                end
                
                
                
                
                
                local enumreloadtostring = {
                    [ACT_HL2MP_GESTURE_RELOAD_AR2] = "Ar2",
                    [ACT_HL2MP_GESTURE_RELOAD_PISTOL] = "Pistol",
                    [ACT_HL2MP_GESTURE_RELOAD_REVOLVER] = "357",
                    [ACT_HL2MP_GESTURE_RELOAD_SHOTGUN] = "Shotgun",
                    [ACT_HL2MP_GESTURE_RELOAD_SMG1] = "SMG1"
                }

                local reloadanim = savedweapondata and enumreloadtostring[ savedweapondata[ 2 ].reloadData.anim ] or "Ar2"
                local reloadtime = savedweapondata and savedweapondata[ 2 ].reloadData.time or 1.5
                local reloadsounds = savedweapondata and savedweapondata[ 2 ].reloadData.snds or {}


                label = vgui.Create( "DLabel", midpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Edit Reload Sounds/time" )

                local reloadeditbutton = vgui.Create( "DButton", midpnl )
                reloadeditbutton:Dock( TOP )
                reloadeditbutton:SetText( "Open Reload Editor" )

                function reloadeditbutton:DoClick()

                    local reloadframe = vgui.Create( "DFrame" )
                    reloadframe:SetSize( 500, 500 )
                    reloadframe:Center()
                    reloadframe:SetSizable( true )
                    reloadframe:MakePopup()
                    reloadframe:SetTitle( "Reload Editor" )

                    label = vgui.Create( "DLabel", reloadframe )
                    --label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "Reload Animation" )
    
                    local reloadanimations = vgui.Create( "DComboBox", reloadframe )
                    reloadanimations:Dock( TOP )
                    reloadanimations:AddChoice( "Ar2", "Ar2", true )
                    reloadanimations:AddChoice( "Pistol" )
                    reloadanimations:AddChoice( "357" )
                    reloadanimations:AddChoice( "Shotgun" )
                    reloadanimations:AddChoice( "SMG1" )

                    local translations = {
                        [ "Ar2" ] = 1,
                        [ "Pistol" ] = 2,
                        [ "357" ] = 3,
                        [ "Shotgun" ] = 4,
                        [ "SMG1" ] = 5
                    }
                    
                    reloadanimations:ChooseOptionID( translations[ reloadanim ])
                    


                    function reloadanimations:OnSelect( index, val, data )
                        reloadanim = val
                    end

                    local previewreloadbutton = vgui.Create( "DButton", reloadframe )
                    previewreloadbutton:Dock( TOP )
                    previewreloadbutton:SetText( "Preview Reload" )




                    function previewreloadbutton:DoClick()

                        local previewframe = vgui.Create( "DFrame" )
                        previewframe:SetSize( 500, 500 )
                        previewframe:Center()
                        previewframe:SetSizable( true )
                        previewframe:MakePopup()
                        previewframe:SetTitle( "Reload Preview" )

                        local weaponpreview = vgui.Create( "DAdjustableModelPanel", previewframe )
                        weaponpreview:SetSize( 100, 200 )
                        weaponpreview:Dock( FILL )
                        weaponpreview:SetModel( "models/player/breen.mdl" )
                        weaponpreview:SetFOV( 40 )
                        weaponpreview:SetAnimated( true )
        
                        weaponpreview:OnMousePressed( MOUSE_LEFT )
        
                        timer.Simple( 0, function() 
                            weaponpreview:OnMouseReleased( MOUSE_LEFT )
                        end )

                        local reloadent = weaponpreview:GetEntity()
                        reloadent:SetAngles( Angle(0,0,0) )
                        reloadent:SetNoDraw( false )

                        local weaponent = ClientsideModel( weaponmdl:GetText() )
                        weaponent:SetNoDraw( false )
        
                        function weaponmdl:OnEnter( val )
                            weaponent:SetModel( val )
                        end
        
                        local lookup = reloadent:LookupAttachment('anim_attachment_RH')
                        local attach = GetAttachmentPoint( reloadent, "hand" )
        
                        weaponent:SetPos( attach.Pos )
                        weaponent:SetAngles( attach.Ang )
                        weaponent:AddFlags( EF_BONEMERGE )
                        weaponent:SetParent( reloadent, lookup )

                        local compilereloadanimations = {
                            [ "Ar2" ] = "reload_ar2",
                            [ "Pistol" ] = "reload_pistol",
                            [ "357" ] = "reload_revolver",
                            [ "Shotgun" ] = "reload_shotgun",
                            [ "SMG1" ] = "reload_smg1_alt"
                        }

                        timer.Simple( 1, function()
                            if !IsValid( reloadent ) then timer.Remove( "zetapanel_previewanimation" ) return end

                            reloadent:SetSequence( "idle_all_01" ) 

                            reloadent:SetSequence( compilereloadanimations[ reloadanim ] ) 
                            reloadent:ResetSequenceInfo()
                            --local _, dur = reloadent:LookupSequence( compilereloadanimations[ reloadanim ] )
                            
                            timer.Simple( reloadtime, function() 
                                if IsValid( previewframe ) then
                                    previewframe:Remove()
                                end
                            end )

                            for k, v in pairs( reloadsounds ) do
                                timer.Simple( v[ 1 ], function() 
                                    if !IsValid( reloadent ) then return end

                                    surface.PlaySound( v[ 2 ] )
                                end )

                            end
                        
                        end )
                        
        
        
                        function weaponpreview:PostDrawModel()
                            local attach = GetAttachmentPoint( reloadent, "hand" )
                            local pos = attach.Pos + Vector( offsetx and offsetx:GetValue() or 0, offsety and offsety:GetValue() or 0, offsetz and offsetz:GetValue() or 0 )
                            local ang = attach.Ang + Angle( offsetp and offsetp:GetValue() or 0, offsetyAng and offsetyAng:GetValue() or 0, offsetr and offsetr:GetValue() or 0 )
        
                            weaponent:SetPos( pos )
                            weaponent:SetAngles( ang )
        
                            weaponent:SetModelScale( weaponscalevar, 0 )
        
                            weaponent:DrawModel()
                        end
        
                        function rangedframe:OnClose()
                            if IsValid( weaponent ) then
                                weaponent:Remove()
                            end
                        end

                        function weaponpreview:OnClose()
                            if IsValid( weaponent ) then
                                weaponent:Remove()
                            end
                        end

                    end



                    label = vgui.Create( "DLabel", reloadframe )
                    label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "How long should a reload take" )
    
                    local reloadtimeslider = vgui.Create( "DNumSlider", reloadframe )
                    reloadtimeslider:Dock( TOP )
                    reloadtimeslider:SetDecimals( 1 )
                    reloadtimeslider:SetMax( 20 )
                    reloadtimeslider:SetMin( 0.1 )
                    reloadtimeslider:SetValue( reloadtime )
                    reloadtimeslider:SetText( "Reload Time" )

                    local timerfunctionbutton = vgui.Create( "DButton", reloadframe )
                    timerfunctionbutton:Dock( TOP )
                    timerfunctionbutton:SetText( "Edit Reload Time Function" )


                    function timerfunctionbutton:DoClick()


                            local precallbackframe = vgui.Create( "DFrame" )
                            precallbackframe:SetSize( 500, 500 )
                            precallbackframe:Center()
                            precallbackframe:SetSizable( true )
                            precallbackframe:MakePopup()
                            precallbackframe:SetTitle( "Reload Time Function Editor" )
        
                            local docsframe = vgui.Create( "DFrame" )
                            docsframe:SetSize( 370, 300 )
                            docsframe:CenterHorizontal( 0.2 )
                            docsframe:CenterVertical( 0.5 )
                            docsframe:SetSizable( true )
                            docsframe:MakePopup()
                            docsframe:SetTitle( "Reload Time Function Editor Docs" )
        
        
                            label = vgui.Create( "DLabel", docsframe )
                            --label:DockMargin( 0, 20, 0, 0 )
                            label:Dock( TOP )
                            label:SetText( "Adding code here will make the reload time" )
        
                            label = vgui.Create( "DLabel", docsframe )
                            --label:DockMargin( 0, 20, 0, 0 )
                            label:Dock( TOP )
                            label:SetText( "call this function. This can used for making" )

                            label = vgui.Create( "DLabel", docsframe )
                            --label:DockMargin( 0, 20, 0, 0 )
                            label:Dock( TOP )
                            label:SetText( "shotguns reload one by one and more" )
        
        
        
                            label = vgui.Create( "DLabel", docsframe )
                            label:DockMargin( 0, 20, 0, 0 )
                            label:Dock( TOP )
                            label:SetText( "There are three variables you can use in your code" )
        
                            label = vgui.Create( "DLabel", docsframe )
                            label:DockMargin( 0, 10, 0, 0 )
                            label:Dock( TOP )
                            label:SetText( "zeta  |  The zeta holding this weapon" )
                            label:SetColor( green )
        
                            label = vgui.Create( "DLabel", docsframe )
                            label:DockMargin( 0, 10, 0, 0 )
                            label:Dock( TOP )
                            label:SetText( "wepENT  |  The weapon entity being used" )
                            label:SetColor( green )
        
                            label = vgui.Create( "DLabel", docsframe )
                            label:DockMargin( 0, 10, 0, 0 )
                            label:Dock( TOP )
                            label:SetText( "time  |  The time it will take to finish reloading" )
                            label:SetColor( green )

                            label = vgui.Create( "DLabel", docsframe )
                            --label:DockMargin( 0, 10, 0, 0 )
                            label:Dock( TOP )
                            label:SetText( "You can edit this variable to change the time. Time by default is 1.5 seconds" )
                            label:SetColor( green )

                            label = vgui.Create( "DLabel", docsframe )
                            --label:DockMargin( 0, 10, 0, 0 )
                            label:Dock( TOP )
                            label:SetText( "EXAMPLE: time = 1 + 2   Reload finishes in three seconds" )
                            label:SetColor( green )
                            
                            
                            
        
                            local codepanel = vgui.Create( "DTextEntry", precallbackframe )
                            codepanel:SetMultiline( true )
                            codepanel:Dock( FILL )
                            codepanel:SetEnterAllowed( false )
                            codepanel:SetTabbingDisabled( false )
                            reloadtimecode = reloadtimecode or savedweapondata and savedweapondata[ 2 ]._customreloadtimecode or nil
                            codepanel:SetText( reloadtimecode or "" )
        
                            function codepanel:OnChange()
                                reloadtimecode = codepanel:GetText() == "" and nil or codepanel:GetText()
                            end

                    end



                    function reloadtimeslider:OnValueChanged( val )
                        reloadtime = val
                    end

                    local reloadsoundlist = vgui.Create( "DListView", reloadframe )
                    reloadsoundlist:Dock( FILL )
                    reloadsoundlist:AddColumn( "Play Sound Delay", 1 )
                    reloadsoundlist:AddColumn( "Sound File", 2 )

                    function reloadsoundlist:OnRowRightClick( id, line )

                        for k, v in pairs( reloadsounds ) do
                            
                            if v[ 1 ] == line:GetSortValue( 1 )[ 1 ] and v[ 2 ] == line:GetSortValue( 1 )[ 2 ] then 

                                reloadsounds[ k ] = nil

                                reloadsoundlist:RemoveLine(id )

                                reloadsoundlist:InvalidateLayout()
        
                                surface.PlaySound( "buttons/button15.wav" )


                                break
                            end

                        end

                    end

                    for k, v in pairs( reloadsounds ) do

                        local line = reloadsoundlist:AddLine( tostring( v[ 1 ], 2  ), v[ 2 ] )
                        line:SetSortValue( 1, v )

                    end
    
                    local reloadeditbutton = vgui.Create( "DButton", reloadframe )
                    reloadeditbutton:Dock( TOP )
                    reloadeditbutton:SetText( "Add New Reload Sound" )

                        function reloadeditbutton:DoClick()

                            local soundframe = vgui.Create( "DFrame" )
                            soundframe:SetSize( 500, 150 )
                            soundframe:Center()
                            soundframe:SetSizable( true )
                            soundframe:MakePopup()
                            soundframe:SetTitle( "Reload Sound Input" )

                            local leftpanel = vgui.Create( "EditablePanel", soundframe )
                            leftpanel:SetSize( 250, 100 )
                            leftpanel:Dock( LEFT )

                            label = vgui.Create( "DLabel", leftpanel )
                            label:Dock( TOP )
                            label:SetText( "The time in seconds before the sound plays" )

                            local sounddelay = vgui.Create( "DNumSlider", leftpanel )
                            sounddelay:Dock( TOP )
                            sounddelay:SetDecimals( 2 )
                            sounddelay:SetMax( 20 )
                            sounddelay:SetMin( 0.1 )
                            sounddelay:SetValue( 0 )
                            sounddelay:SetText( "Sound Delay" )

                            local rightpanel = vgui.Create( "EditablePanel", soundframe )
                            rightpanel:SetSize( 250, 100 )
                            rightpanel:Dock( RIGHT )

                            local soundfile = vgui.Create( "DTextEntry", rightpanel )
                            soundfile:Dock( TOP )
                            soundfile:SetPlaceholderText( "Input a Sound Path here" )

                            local soundbrowserbutton = vgui.Create( "DButton", rightpanel )
                            soundbrowserbutton:Dock( TOP )
                            soundbrowserbutton:SetText( "Open Sound Browser" )

                            local submitbutton = vgui.Create( "DButton", rightpanel )
                            submitbutton:Dock( TOP )
                            submitbutton:SetText( "Submit Sound" )

                            function submitbutton:DoClick()
                                if soundfile:GetText() == "" then notification.AddLegacy("Add a sound!", NOTIFY_ERROR, 2) surface.PlaySound( "buttons/button10.wav" ) return end

                                

                                local line = reloadsoundlist:AddLine( tostring( math.Round( sounddelay:GetValue(), 2 ) ), soundfile:GetText() )

                                table.insert( reloadsounds, { math.Round( sounddelay:GetValue(), 2 ), soundfile:GetText() } )

                                line:SetSortValue( 1, { math.Round( sounddelay:GetValue(), 2 ), soundfile:GetText() } )


                                

                                surface.PlaySound( "buttons/button14.wav" )

                                soundframe:Remove()
                            end

                            function soundbrowserbutton:DoClick()

                                local soundbrowserframe = vgui.Create( "DFrame" )
                                soundbrowserframe:SetSize( 500, 500 )
                                soundbrowserframe:Center()
                                soundbrowserframe:SetSizable( true )
                                soundbrowserframe:MakePopup()
                                soundbrowserframe:SetTitle( "Sound Browser" )

                                label = vgui.Create( "DLabel", soundbrowserframe )
                                label:Dock( TOP )
                                label:SetText( "Left click to preview a sound. Right click a sound to select it and use it" )
            
                                local searchbar = vgui.Create( "DTextEntry", soundbrowserframe )
                                searchbar:Dock( TOP )
                                searchbar:SetPlaceholderText( "Search Bar" )
                            
            
                                local soundbrowser = vgui.Create( "DFileBrowser", soundbrowserframe )
                                soundbrowser:Dock( FILL )
                                soundbrowser:SetBaseFolder( "sound" )
                                soundbrowser:SetOpen( true, true )
                                soundbrowser:SetFileTypes( "*.wav *.mp3" )

                                local sndpatch


                                function soundbrowser:OnRightClick( path )
                                    

                                    local soundpath = string.Explode( "sound/", path )

                                    soundfile:SetText( soundpath[ 2 ] )

                                    soundbrowserframe:Remove()
                                end
            
                                function soundbrowser:OnSelect( path )

                                    local soundpath = string.Explode( "sound/", path )

                                    if sndpatch then sndpatch:Stop() end

                                    sndpatch = CreateSound( LocalPlayer(), soundpath[ 2 ] )

                                    sndpatch:Play()
                                    
                                end

                                function soundbrowserframe:OnClose()
                                    if sndpatch then sndpatch:Stop() end
                                end
            
                                function searchbar:OnEnter( val )
                                    if val == "" then soundbrowser:SetSearch( "*" ) return end
            
                                    soundbrowser:SetSearch( val )
                                end

                            end

                        end


                end


                label = vgui.Create( "DLabel", midpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Lua Code Weapon Callbacks" )

                label = vgui.Create( "DLabel", midpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Code knowledge required for these!" )

                local precalleditbutton = vgui.Create( "DButton", midpnl )
                precalleditbutton:Dock( TOP )
                precalleditbutton:SetText( "Edit On Shoot Precallback" )

                local onchangecalleditbutton = vgui.Create( "DButton", midpnl )
                onchangecalleditbutton:Dock( TOP )
                onchangecalleditbutton:SetText( "Edit On Change Callback" )




                function onchangecalleditbutton:DoClick()

                    local precallbackframe = vgui.Create( "DFrame" )
                    precallbackframe:SetSize( 500, 500 )
                    precallbackframe:Center()
                    precallbackframe:SetSizable( true )
                    precallbackframe:MakePopup()
                    precallbackframe:SetTitle( "On Change Callback Editor" )

                    local docsframe = vgui.Create( "DFrame" )
                    docsframe:SetSize( 370, 200 )
                    docsframe:CenterHorizontal( 0.2 )
                    docsframe:CenterVertical( 0.5 )
                    docsframe:SetSizable( true )
                    docsframe:MakePopup()
                    docsframe:SetTitle( "Callback Editor Docs" )


                    label = vgui.Create( "DLabel", docsframe )
                    --label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "This call back is called when a zeta" )

                    label = vgui.Create( "DLabel", docsframe )
                    --label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "switches their weapon to this weapon" )


                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "There are two variables you can use in your code" )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "zeta  |  The zeta that changed their weapon to this" )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "wepENT  |  The weapon entity being used" )
                    label:SetColor( green )
                    
                    
                    

                    local codepanel = vgui.Create( "DTextEntry", precallbackframe )
                    codepanel:SetMultiline( true )
                    codepanel:Dock( FILL )
                    codepanel:SetEnterAllowed( false )
                    codepanel:SetTabbingDisabled( false )
                    onchangecode = onchangecode or savedweapondata and savedweapondata[ 2 ]._customonchangecode or nil
                    codepanel:SetText( onchangecode or "" )

                    function codepanel:OnChange()
                        onchangecode = codepanel:GetText() == "" and nil or codepanel:GetText()
                    end

                end






                local thinkcallbackitbutton = vgui.Create( "DButton", midpnl )
                thinkcallbackitbutton:Dock( TOP )
                thinkcallbackitbutton:SetText( "Edit On Think Callback" )




                function thinkcallbackitbutton:DoClick()

                    local precallbackframe = vgui.Create( "DFrame" )
                    precallbackframe:SetSize( 500, 500 )
                    precallbackframe:Center()
                    precallbackframe:SetSizable( true )
                    precallbackframe:MakePopup()
                    precallbackframe:SetTitle( "On Think Callback Editor" )

                    local docsframe = vgui.Create( "DFrame" )
                    docsframe:SetSize( 370, 200 )
                    docsframe:CenterHorizontal( 0.2 )
                    docsframe:CenterVertical( 0.5 )
                    docsframe:SetSizable( true )
                    docsframe:MakePopup()
                    docsframe:SetTitle( "Callback Editor Docs" )


                    label = vgui.Create( "DLabel", docsframe )
                    --label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "This call back is called every Server Tick and Client Frame" )

                    label = vgui.Create( "DLabel", docsframe )
                    --label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "That means this code is Shared!" )


                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "There are two variables you can use in your code" )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "zeta  |  The zeta holding this weapon" )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "wepENT  |  The weapon entity being used" )
                    label:SetColor( green )
                    
                    
                    

                    local codepanel = vgui.Create( "DTextEntry", precallbackframe )
                    codepanel:SetMultiline( true )
                    codepanel:Dock( FILL )
                    codepanel:SetEnterAllowed( false )
                    codepanel:SetTabbingDisabled( false )
                    onthinkcode = onthinkcode or savedweapondata and savedweapondata[ 2 ]._customonthinkcode or nil
                    codepanel:SetText( onthinkcode or "" )

                    function codepanel:OnChange()
                        onthinkcode = codepanel:GetText() == "" and nil or codepanel:GetText()
                    end

                end




                local ondamagededitbutton = vgui.Create( "DButton", midpnl )
                ondamagededitbutton:Dock( TOP )
                ondamagededitbutton:SetText( "Edit On Damage Callback" )




                function ondamagededitbutton:DoClick()

                    local precallbackframe = vgui.Create( "DFrame" )
                    precallbackframe:SetSize( 500, 500 )
                    precallbackframe:Center()
                    precallbackframe:SetSizable( true )
                    precallbackframe:MakePopup()
                    precallbackframe:SetTitle( "On Damage Callback Editor" )

                    local docsframe = vgui.Create( "DFrame" )
                    docsframe:SetSize( 370, 200 )
                    docsframe:CenterHorizontal( 0.2 )
                    docsframe:CenterVertical( 0.5 )
                    docsframe:SetSizable( true )
                    docsframe:MakePopup()
                    docsframe:SetTitle( "Callback Editor Docs" )


                    label = vgui.Create( "DLabel", docsframe )
                    --label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "This call back is called when the zeta" )

                    label = vgui.Create( "DLabel", docsframe )
                    --label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "holding this weapon is damaged/hurt" )



                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "There are three variables you can use in your code" )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "zeta  |  The zeta holding this weapon" )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "wepENT  |  The weapon entity being used" )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "dmginfo  |  The Damage Info object of the damage" )
                    label:SetColor( green )
                    
                    
                    

                    local codepanel = vgui.Create( "DTextEntry", precallbackframe )
                    codepanel:SetMultiline( true )
                    codepanel:Dock( FILL )
                    codepanel:SetEnterAllowed( false )
                    codepanel:SetTabbingDisabled( false )
                    ondamagedcode = ondamagedcode or savedweapondata and savedweapondata[ 2 ]._customondamagedcode or nil
                    codepanel:SetText( ondamagedcode or "" )

                    function codepanel:OnChange()
                        ondamagedcode = codepanel:GetText() == "" and nil or codepanel:GetText()
                    end

                end





                function precalleditbutton:DoClick()

                    local precallbackframe = vgui.Create( "DFrame" )
                    precallbackframe:SetSize( 500, 500 )
                    precallbackframe:Center()
                    precallbackframe:SetSizable( true )
                    precallbackframe:MakePopup()
                    precallbackframe:SetTitle( "Pre Callback Editor" )

                    local docsframe = vgui.Create( "DFrame" )
                    docsframe:SetSize( 370, 700 )
                    docsframe:CenterHorizontal( 0.2 )
                    docsframe:CenterVertical( 0.5 )
                    docsframe:SetSizable( true )
                    docsframe:MakePopup()
                    docsframe:SetTitle( "Pre Callback Editor Docs" )

                    label = vgui.Create( "DLabel", docsframe )
                    --label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "This call back is called when a zeta" )

                    label = vgui.Create( "DLabel", docsframe )
                    --label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "fires their weapon" )


                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "There are four variables you can use in your code" )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "zeta  |  The zeta that is shooting this weapon" )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "wepENT  |  The weapon entity being used" )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "target  |  The entity that's being attacked" )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "blockdata  |  A Table of keys holding bools allowing you to" )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    --label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "prevent certain elements from running to" )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    --label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "allow for more custom functionality." )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "Return true for any key as mentioned below to" )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    --label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "prevent it from running" )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    label:SetSize( 100,100)
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "Example:\n\nblockdata.bullet = true\nblockdata.snd = true\n\nThis prevents bullets from being fired\nand prevents sounds from playing" )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "--- blockdata keys ---" )

                    --{cooldown = false, anim = false, muzzle = false, shell = false, snd = false, bullet = false, clipRemove = false}

                    label = vgui.Create( "DLabel", docsframe )
                    label:SetSize( 100,200)
                    label:DockMargin( 0, 3, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( [[bullet | Return true to prevent default bullets from firing
snd | Return true to prevent the firing sound
muzzle | Return true to prevent the muzzle flash
anim | Return true to prevent the recoil animation
cooldown | Return true to prevent the cooldown ( For custom cooldowns )
shell | Return true to prevent shell ejects
clipRemove | Return true to prevent the subtraction of a clip's ammo

                    ]] )
                    
                    
                    

                    local codepanel = vgui.Create( "DTextEntry", precallbackframe )
                    codepanel:SetMultiline( true )
                    codepanel:Dock( FILL )
                    codepanel:SetEnterAllowed( false )
                    codepanel:SetTabbingDisabled( false )
                    precallbackcode = precallbackcode or savedweapondata and savedweapondata[ 2 ].fireData._customprecallcode or nil
                    codepanel:SetText( precallbackcode or "" )

                    function codepanel:OnChange()
                        precallbackcode = codepanel:GetText() == "" and nil or codepanel:GetText()
                    end

                end















                local rightpnl = vgui.Create( "EditablePanel", rangedframe )
                rightpnl:DockMargin( 30, 0, 0, 0 )
                rightpnl:SetSize( 200, 200 )
                rightpnl:Dock( LEFT )



                label = vgui.Create( "DLabel", rightpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "The minimum amount of damage" )

                local dmgmin = vgui.Create( "DNumSlider", rightpnl )
                dmgmin:Dock( TOP )
                dmgmin:SetDecimals( 0 )
                dmgmin:SetMax( 2000 )
                dmgmin:SetMin( 1 )
                dmgmin:SetValue( savedweapondata and savedweapondata[ 2 ].fireData.dmgMin or 5 )
                dmgmin:SetText( "Damage Min" )



                label = vgui.Create( "DLabel", rightpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "The maximum amount of damage" )

                local dmgemax = vgui.Create( "DNumSlider", rightpnl )
                dmgemax:Dock( TOP )
                dmgemax:SetDecimals( 0 )
                dmgemax:SetMax( 2000 )
                dmgemax:SetMin( 1 )
                dmgemax:SetValue( savedweapondata and savedweapondata[ 2 ].fireData.dmgMax or 13 )
                dmgemax:SetText( "Damage Max" )


                label = vgui.Create( "DLabel", rightpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Damage Force" )

                local dmgforce = vgui.Create( "DNumSlider", rightpnl )
                dmgforce:Dock( TOP )
                dmgforce:SetDecimals( 0 )
                dmgforce:SetMax( 2000 )
                dmgforce:SetMin( 1 )
                dmgforce:SetValue( savedweapondata and savedweapondata[ 2 ].fireData.force or 30 )
                dmgforce:SetText( "Damage Force" )

                label = vgui.Create( "DLabel", rightpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Spread" )

                local bulletspread = vgui.Create( "DNumSlider", rightpnl )
                bulletspread:Dock( TOP )
                bulletspread:SetDecimals( 4 )
                bulletspread:SetMax( 1 )
                bulletspread:SetMin( 0 )
                bulletspread:SetValue( savedweapondata and savedweapondata[ 2 ].fireData.spread or 0.1 )
                bulletspread:SetText( "Bullet Spread" )

                label = vgui.Create( "DLabel", rightpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Shoot sound" )
                
                label = vgui.Create( "DLabel", rightpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "The Sound that will play when fired" )

                local shootsnd = vgui.Create( "DTextEntry", rightpnl )
                shootsnd:Dock( TOP )
                shootsnd:SetText( savedweapondata and savedweapondata[ 2 ].fireData.snd or "weapons/smg1/smg1_fire1.wav" )



                local soundbrowserbutton = vgui.Create( "DButton", rightpnl )
                soundbrowserbutton:Dock( TOP )
                soundbrowserbutton:SetText( "Open Sound Browser" )

                
                function soundbrowserbutton:DoClick()

                    local soundbrowserframe = vgui.Create( "DFrame" )
                    soundbrowserframe:SetSize( 500, 500 )
                    soundbrowserframe:Center()
                    soundbrowserframe:SetSizable( true )
                    soundbrowserframe:MakePopup()
                    soundbrowserframe:SetTitle( "Sound Browser" )

                    label = vgui.Create( "DLabel", soundbrowserframe )
                    label:Dock( TOP )
                    label:SetText( "Left click to preview a sound. Right click a sound to select it and use it" )

                    local searchbar = vgui.Create( "DTextEntry", soundbrowserframe )
                    searchbar:Dock( TOP )
                    searchbar:SetPlaceholderText( "Search Bar" )
                

                    local soundbrowser = vgui.Create( "DFileBrowser", soundbrowserframe )
                    soundbrowser:Dock( FILL )
                    soundbrowser:SetBaseFolder( "sound" )
                    soundbrowser:SetOpen( true, true )
                    soundbrowser:SetFileTypes( "*.wav *.mp3" )

                    local sndpatch


                    function soundbrowser:OnRightClick( path )

                        local soundpath = string.Explode( "sound/", path )

                        shootsnd:SetText( soundpath[ 2 ] )

                        soundbrowserframe:Remove()
                    end

                    function soundbrowser:OnSelect( path )

                        local soundpath = string.Explode( "sound/", path )

                        if sndpatch then sndpatch:Stop() end

                        sndpatch = CreateSound( LocalPlayer(), soundpath[ 2 ] )

                        sndpatch:Play()
                        
                    end

                    function soundbrowserframe:OnClose()
                        if sndpatch then sndpatch:Stop() end
                    end

                    function searchbar:OnEnter( val )
                        if val == "" then soundbrowser:SetSearch( "*" ) return end

                        soundbrowser:SetSearch( val )
                    end

                end






                label = vgui.Create( "DLabel", rightpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "How many bullets should be shot" )

                label = vgui.Create( "DLabel", rightpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "when fired" )

                local bulletcount = vgui.Create( "DNumSlider", rightpnl )
                bulletcount:Dock( TOP )
                bulletcount:SetDecimals( 0 )
                bulletcount:SetMax( 50 )
                bulletcount:SetMin( 1 )
                bulletcount:SetValue( savedweapondata and savedweapondata[ 2 ].fireData.num or 1 )
                bulletcount:SetText( "Bullet Amount" )


                label = vgui.Create( "DLabel", rightpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Weapon Scale requires no Bone" )

                label = vgui.Create( "DLabel", rightpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Merge!" )

                local weaponscale = vgui.Create( "DNumSlider", rightpnl )
                weaponscale:Dock( TOP )
                weaponscale:SetDecimals( 3 )
                weaponscale:SetMax( 100 )
                weaponscale:SetMin( 0 )
                weaponscale:SetValue( savedweapondata and savedweapondata[ 2 ].weaponscale or 1 )
                weaponscale:SetText( "Weapon Scale" )
                weaponscalevar = savedweapondata and savedweapondata[ 2 ].weaponscale or 1
                function weaponscale:OnValueChanged( val ) weaponscalevar = val end

                label = vgui.Create( "DLabel", rightpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "No Bone Merge" )

                local bonemerge = vgui.Create( "DCheckBox", rightpnl )
                bonemerge:DockMargin( 0, 0, 150, 0 )
                bonemerge:Dock( TOP )
                
                disablebonemerge = savedweapondata and savedweapondata[ 2 ].nobonemerge

                bonemerge:SetChecked( tobool( disablebonemerge ) )

                function bonemerge:OnChange( val ) disablebonemerge = val end
                



                local rightpnl2 = vgui.Create( "EditablePanel", rangedframe )
                rightpnl2:DockMargin( 30, 0, 0, 0 )
                rightpnl2:SetSize( 200, 200 )
                rightpnl2:Dock( LEFT )

                label = vgui.Create( "DLabel", rightpnl2 )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Weapon Model" ) 

                local offsetx
                local offsety
                local offsetz


                weaponmdl = vgui.Create( "DTextEntry", rightpnl2 )
                weaponmdl:Dock( TOP )
                weaponmdl:SetText( savedweapondata and savedweapondata[ 2 ].mdl or "models/weapons/w_smg1.mdl" )

                local viewmodels = vgui.Create( "DButton", rightpnl2 )
                viewmodels:Dock( TOP )
                viewmodels:SetText( "Find Models")

                function viewmodels:DoClick()

                    local modelbrowserframe = vgui.Create( "DFrame" )
                    modelbrowserframe:SetSize( 500, 500 )
                    modelbrowserframe:Center()
                    modelbrowserframe:SetSizable( true )
                    modelbrowserframe:MakePopup()
                    modelbrowserframe:SetTitle( "Model Viewer" )

                    local searchbar = vgui.Create( "DTextEntry", modelbrowserframe )
                    searchbar:Dock( TOP )
                    searchbar:SetPlaceholderText( "Search Bar" )
                

                    local modelbrowser = vgui.Create( "DFileBrowser", modelbrowserframe )
                    modelbrowser:Dock( FILL )
                    modelbrowser:SetModels( true )
                    modelbrowser:SetBaseFolder( "models" )
                    modelbrowser:SetOpen( true )
                    modelbrowser:SetFileTypes( "*.mdl" )

                    function modelbrowser:OnSelect( path )
                        modelbrowserframe:Remove()

                        weaponmdl:SetText( path )
                        weaponmdl:OnEnter( path )
                    end

                    function searchbar:OnEnter( val )
                        if val == "" then modelbrowser:SetSearch( "*" ) return end

                        modelbrowser:SetSearch( val )
                    end



                end

                label = vgui.Create( "DLabel", rightpnl2 )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Position Offset" ) 

                offsetx = vgui.Create( "DNumSlider", rightpnl2 )
                offsetx:Dock( TOP )
                offsetx:SetDecimals( 3 )
                offsetx:SetMax( 1000 )
                offsetx:SetMin( -1000 )
                offsetx:SetValue( savedweapondata and savedweapondata[ 2 ].offPos[ 1 ] or 0 )
                offsetx:SetText( "X" )

                offsety = vgui.Create( "DNumSlider", rightpnl2 )
                offsety:Dock( TOP )
                offsety:SetDecimals( 3 )
                offsety:SetMax( 1000 )
                offsety:SetMin( -1000 )
                offsety:SetValue( savedweapondata and savedweapondata[ 2 ].offPos[ 2 ] or 0 )
                offsety:SetText( "Y" )

                offsetz = vgui.Create( "DNumSlider", rightpnl2 )
                offsetz:Dock( TOP )
                offsetz:SetDecimals( 3 )
                offsetz:SetMax( 1000 )
                offsetz:SetMin( -1000 )
                offsetz:SetValue( savedweapondata and savedweapondata[ 2 ].offPos[ 3 ] or 0 )
                offsetz:SetText( "Z" )



                label = vgui.Create( "DLabel", rightpnl2 )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Angle Offset" ) 

                local offsetp = vgui.Create( "DNumSlider", rightpnl2 )
                offsetp:Dock( TOP )
                offsetp:SetDecimals( 3 )
                offsetp:SetMax( 180 )
                offsetp:SetMin( -180 )
                offsetp:SetValue( savedweapondata and savedweapondata[ 2 ].offAng[ 1 ] or 0 )
                offsetp:SetText( "Pitch" )

                local offsetyAng = vgui.Create( "DNumSlider", rightpnl2 )
                offsetyAng:Dock( TOP )
                offsetyAng:SetDecimals( 3 )
                offsetyAng:SetMax( 180 )
                offsetyAng:SetMin( -180 )
                offsetyAng:SetValue( savedweapondata and savedweapondata[ 2 ].offAng[ 2 ] or 0 )
                offsetyAng:SetText( "Yaw" )

                local offsetr = vgui.Create( "DNumSlider", rightpnl2 )
                offsetr:Dock( TOP )
                offsetr:SetDecimals( 3 )
                offsetr:SetMax( 180 )
                offsetr:SetMin( -180 )
                offsetr:SetValue( savedweapondata and savedweapondata[ 2 ].offAng[ 3 ] or 0 )
                offsetr:SetText( "Roll" )



                local weaponpreview = vgui.Create( "DAdjustableModelPanel", rightpnl2 )
                weaponpreview:SetSize( 100, 200)
                weaponpreview:Dock( TOP )
                weaponpreview:SetModel( "models/player/breen.mdl" )
                weaponpreview:SetFOV( 40 )

                weaponpreview:OnMousePressed( MOUSE_LEFT )

                timer.Simple( 0, function() 
                    weaponpreview:OnMouseReleased( MOUSE_LEFT )
                end )

                local previewent = weaponpreview:GetEntity()
                previewent:SetAngles( Angle(0,0,0) )
                previewent:SetNoDraw( false )

                local weaponent = ClientsideModel( weaponmdl:GetText() )
                weaponent:SetNoDraw( false )

                function weaponmdl:OnEnter( val )
                    weaponent:SetModel( val )
                end

                local lookup = previewent:LookupAttachment('anim_attachment_RH')
                local attach = GetAttachmentPoint( previewent, "hand" )

                weaponent:SetPos( attach.Pos )
                weaponent:SetAngles( attach.Ang )
                weaponent:AddFlags( EF_BONEMERGE )
                weaponent:SetParent( previewent, lookup )
                

                function weaponpreview:LayoutEntity( ent )
                    
                end

                function weaponpreview:PostDrawModel()
                    local attach = GetAttachmentPoint( previewent, "hand" )
                    local pos = attach.Pos + Vector( offsetx and offsetx:GetValue() or 0, offsety and offsety:GetValue() or 0, offsetz and offsetz:GetValue() or 0 )
                    local ang = attach.Ang + Angle( offsetp and offsetp:GetValue() or 0, offsetyAng and offsetyAng:GetValue() or 0, offsetr and offsetr:GetValue() or 0 )

                    render.DrawLine( weaponent:GetPos(), weaponent:GetPos() + Vector( 0, 0, 40 ), Color( 0, 0, 255 ) )
                    render.DrawLine( weaponent:GetPos(), weaponent:GetPos() + Vector( 0, 40, 0 ), Color( 0, 255, 0 ) )
                    render.DrawLine( weaponent:GetPos(), weaponent:GetPos() + Vector( 40, 0, 0 ), Color( 255, 0, 0 ) )

                    weaponent:SetPos( pos )
                    weaponent:SetAngles( ang )

                    weaponent:SetModelScale( weaponscale:GetValue(), 0 )

                    weaponent:DrawModel()
                end

                function rangedframe:OnClose()
                    if IsValid( weaponent ) then
                        weaponent:Remove()
                    end
                end

                function weaponpreview:OnClose()
                    if IsValid( weaponent ) then
                        weaponent:Remove()
                    end
                end
                

                local animationtranslation = {
                    [ "Pistol" ] = "idle_pistol",
                    [ "Ar2" ] = "idle_ar2",
                    [ "357" ] = "idle_revolver",
                    [ "Shotgun" ] = "idle_shotgun",
                    [ "Camera" ] = "idle_camera",
                    [ "SMG1" ] = "idle_smg1",
                    [ "Physgun" ] = "idle_physgun",
                    [ "Grenade" ] = "idle_grenade",
                    [ "RPG" ] = "idle_rpg",
                    [ "Crossbow" ] = "idle_crossbow",
                    [ "Holster" ] = "idle_all_01",
                    [ "Magic" ] = "idle_magic",
                    [ "Duel" ] = "idle_dual"
                }

                function animations:OnSelect( index, val, data )
                    previewent:SetSequence( previewent:LookupSequence( animationtranslation[ val ] ) )
                    previewent:ResetSequenceInfo()
                end
                
                previewent:SetSequence( previewent:LookupSequence( animationtranslation[ animations:GetSelected() ] ) )


                local compileanimationtranslations = {
                    [ "Pistol" ] = { idle = ACT_HL2MP_IDLE_PISTOL, move = ACT_HL2MP_RUN_PISTOL, jump = ACT_HL2MP_JUMP_PISTOL, crouch = ACT_HL2MP_WALK_CROUCH_PISTOL },
                    [ "Ar2" ] = { idle = ACT_HL2MP_IDLE_AR2, move = ACT_HL2MP_RUN_AR2, jump = ACT_HL2MP_JUMP_AR2, crouch = ACT_HL2MP_WALK_CROUCH_AR2 },
                    [ "357" ] = { idle = ACT_HL2MP_IDLE_REVOLVER, move = ACT_HL2MP_RUN_REVOLVER, jump = ACT_HL2MP_JUMP_REVOLVER, crouch = ACT_HL2MP_WALK_CROUCH_REVOLVER },
                    [ "Shotgun" ] = { idle = ACT_HL2MP_IDLE_SHOTGUN, move = ACT_HL2MP_RUN_SHOTGUN, jump = ACT_HL2MP_JUMP_SHOTGUN, crouch = ACT_HL2MP_WALK_CROUCH_SHOTGUN },
                    [ "Camera" ] = { idle = ACT_HL2MP_IDLE_CAMERA, move = ACT_HL2MP_RUN_CAMERA, jump = ACT_HL2MP_JUMP_CAMERA, crouch = ACT_HL2MP_WALK_CROUCH_CAMERA },
                    [ "SMG1" ] = { idle = ACT_HL2MP_IDLE_SMG1, move = ACT_HL2MP_RUN_SMG1, jump = ACT_HL2MP_JUMP_SMG1, crouch = ACT_HL2MP_WALK_CROUCH_SMG1 },
                    [ "Physgun" ] = { idle = ACT_HL2MP_IDLE_PHYSGUN, move = ACT_HL2MP_RUN_PHYSGUN, jump = ACT_HL2MP_JUMP_PHYSGUN, crouch = ACT_HL2MP_WALK_CROUCH_PHYSGUN },
                    [ "Grenade" ] = { idle = ACT_HL2MP_IDLE_GRENADE, move = ACT_HL2MP_RUN_GRENADE, jump = ACT_HL2MP_JUMP_GRENADE, crouch = ACT_HL2MP_WALK_CROUCH_GRENADE },
                    [ "RPG" ] = { idle = ACT_HL2MP_IDLE_RPG, move = ACT_HL2MP_RUN_RPG, jump = ACT_HL2MP_JUMP_RPG, crouch = ACT_HL2MP_WALK_CROUCH_RPG },
                    [ "Crossbow" ] = { idle = ACT_HL2MP_IDLE_CROSSBOW, move = ACT_HL2MP_RUN_CROSSBOW, jump = ACT_HL2MP_JUMP_CROSSBOW, crouch = ACT_HL2MP_WALK_CROUCH_CROSSBOW },
                    [ "Holster" ] = { idle = ACT_HL2MP_IDLE, move = ACT_HL2MP_RUN, jump = ACT_HL2MP_JUMP_FIST, crouch = ACT_HL2MP_WALK_CROUCH },
                    [ "Magic" ] = { idle = ACT_HL2MP_IDLE_MAGIC, move = ACT_HL2MP_RUN_MAGIC, jump = ACT_HL2MP_JUMP_MAGIC, crouch = ACT_HL2MP_WALK_CROUCH_MAGIC },
                    [ "Duel" ] = { idle = ACT_HL2MP_IDLE_DUEL, move = ACT_HL2MP_RUN_DUEL, jump = ACT_HL2MP_JUMP_DUEL, crouch = ACT_HL2MP_WALK_CROUCH_DUEL }
                }

                local compilerecoilanimations = {
                    [ "Ar2" ] = ACT_HL2MP_GESTURE_RANGE_ATTACK_AR2,
                    [ "Pistol" ] = ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL,
                    [ "357" ] = ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER,
                    [ "Shotgun" ] = ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN,
                    [ "SMG1" ] = ACT_HL2MP_GESTURE_RANGE_ATTACK_SMG1,
                    [ "RPG" ] = ACT_HL2MP_GESTURE_RANGE_ATTACK_RPG,
                    [ "Crossbow" ] = ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW,
                    [ "Grenade" ] = ACT_HL2MP_GESTURE_RANGE_ATTACK_GRENADE
                }

                local compilereloadanimations = {
                    [ "Ar2" ] = ACT_HL2MP_GESTURE_RELOAD_AR2,
                    [ "Pistol" ] = ACT_HL2MP_GESTURE_RELOAD_PISTOL,
                    [ "357" ] = ACT_HL2MP_GESTURE_RELOAD_REVOLVER,
                    [ "Shotgun" ] = ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,
                    [ "SMG1" ] = ACT_HL2MP_GESTURE_RELOAD_SMG1
                }

                local function CompileWeaponData()
                    if weaponsclassname:GetText() == "" or weaponsprettyname:GetText() == "" then surface.PlaySound( "buttons/button10.wav" ) notification.AddLegacy( "Weapon is missing Class name or is missing Pretty print!") return end



                    local compiledtableholder = {}

                    local compiledanimations = compileanimationtranslations[ animations:GetSelected() ]

                    
                    local _, muzzle = Muzzleflash:GetSelected()
                    local _, tracer = tracer:GetSelected()
                    
                    local shelldatatable = useshelldata == true and {
                        name = shellname,
                        offPos = {
                            forward = shelloffsetx or 0,
                            right = shelloffsety or 0,
                            up = shelloffsetz or 0
                        },
                        offAng = Angle( shellanglep or 0, shellangley or 0, shellangler or 0 )
                    } or nil
                    
                    local precallback = [[

                        local args = { ... }

                        local zeta = args[ 1 ]
                        local wepENT = args[ 2 ]
                        local target = args[ 3 ]
                        local blockdata = args[ 4 ]

                    ]]

                    local returnblockdata = [[

                    if true then return blockdata end
                    ]]


                    local onchangecallback = [[

                        local args = { ... }

                        local zeta = args[ 1 ]
                        local wepENT = args[ 2 ]

                    ]]


                    local onthinkcallback = [[

                        local args = { ... }

                        local zeta = args[ 1 ]
                        local wepENT = args[ 2 ]

                    ]]

                    local ondamagedcallback = [[

                        local args = { ... }

                        local zeta = args[ 1 ]
                        local wepENT = args[ 2 ]
                        local dmginfo = args[ 3 ]

                    ]]

                    local reloadtimefunction = [[

                        local args = { ... }

                        local zeta = args[ 1 ]
                        local wepENT = args[ 2 ]
                        local time = 1.5

                    ]]

                    local returnreloadtime = [[

                        if true then return time end
                        ]]
    

                    if precallbackcode then
                        precallback = precallback .. precallbackcode .. returnblockdata
                    else
                        precallback = nil
                    end

                    if onchangecode then
                        onchangecallback = onchangecallback .. onchangecode
                    else
                        onchangecallback = nil
                    end

                    if onthinkcode then
                        onthinkcallback = onthinkcallback .. onthinkcode
                    else
                        onthinkcallback = nil
                    end


                    if ondamagedcode then
                        ondamagedcallback = ondamagedcallback .. ondamagedcode
                    else
                        ondamagedcallback = nil
                    end

                    if reloadtimecode then
                        reloadtimefunction = reloadtimefunction .. reloadtimecode .. returnreloadtime
                        reloadtime = reloadtimefunction
                    else
                        reloadtimefunction = nil
                    end

                    
                    print( weaponscalevar )

                    compiledtableholder[ weaponsclassname:GetText() ] = {

                        mdl = weaponmdl:GetText(),

                        hidewep = false,
                        offPos = Vector( offsetx and offsetx:GetValue() or 0, offsety and offsety:GetValue() or 0, offsetz and offsetz:GetValue() or 0 ),
                        offAng = Angle( offsetp and offsetp:GetValue() or 0, offsetyAng and offsetyAng:GetValue() or 0, offsetr and offsetr:GetValue() or 0 ),
                        lethal = true,
                        range = true,
                        melee = false,
                        clip = clip:GetValue(),
                        keepDistance = keepdistance:GetValue(),
                        prettyPrint = weaponsprettyname:GetText(),
                        weaponscale = weaponscalevar,
                        nobonemerge = disablebonemerge,

                        anims = {
                            idle = compiledanimations.idle,
                            move = compiledanimations.move,
                            jump = compiledanimations.jump,
                            crouch = compiledanimations.crouch
                        },

                        _customreloadtimecode = reloadtimecode,

                        onThink = onthinkcallback,
                        _customonthinkcode = onthinkcode,

                        onDamageCallback = ondamagedcallback,
                        _customondamagedcode  = ondamagedcode,

                        changeCallback = onchangecallback,
                        _customonchangecode = onchangecode,

                        fireData = {
                            rateMin = fireratemin:GetValue(),
                            rateMax = fireratemax:GetValue(),
                            anim = compilerecoilanimations[ recoilanimations:GetSelected() ],
                            muzzleFlash = muzzle,
                            snd = shootsnd:GetText(),
                            num = bulletcount:GetValue(),
                            dmgMin = dmgmin:GetValue(),
                            dmgMax = dmgemax:GetValue(),
                            force = dmgforce:GetValue(),
                            ammo = '9mm',
                            spread = bulletspread:GetValue(),
                            tracer = tracer,

                            _customprecallcode = precallbackcode,
                            preCallback = precallback

                        },

                        shellData = shelldatatable,

                        reloadData = {
                            anim = compilereloadanimations[ reloadanim ],
                            time = reloadtime,
                            snds = reloadsounds
                        }

                    }
                    
                    
                    local data = file.Read( "zetaplayerdata/weapondata.dat" )

                    if !data then data = util.Compress( "[]" ) ZetaFileWrite( "zetaplayerdata/weapondata.dat", util.Compress( "[]" ) ) end

                    surface.PlaySound( "buttons/button15.wav" )
                    notification.AddLegacy( "Added/Updated " .. weaponsprettyname:GetText(), NOTIFY_GENERIC, 2 )

                    data = util.Decompress( data )
                    data = util.JSONToTable( data )

                    data[ weaponsclassname:GetText() ] = compiledtableholder[ weaponsclassname:GetText() ]

                    data = util.TableToJSON( data )
                    data = util.Compress( data )

                    ZetaFileWrite( "zetaplayerdata/weapondata.dat", data )



                    timer.Simple( 0, function()

                        notification.AddLegacy( "Updating Spawnmenu and Weapons.. You may experience lag for a few seconds", NOTIFY_HINT, 4 )

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

                        net.Start( "zetaweaponcreator_updateweapons" )
                        net.SendToServer()

                        include("zeta/weapon_tables.lua")

                        _ZetaRegisterDefaultWeapons()

                    end)

                end



                label = vgui.Create( "DLabel", leftpnl )
                label:DockMargin( 0, 60, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Submit Weapon" )

                local compile = vgui.Create( "DButton", leftpnl )
                compile:Dock( TOP )
                compile:SetText( "Compile Weapon Data" )

                compile.DoClick = CompileWeaponData

            end




















             -- Melee weapon panel
             function createnewmelee:DoClick()
                frame:Remove()

                local rangedframe = vgui.Create( "DFrame" )
                rangedframe:SetSize( 900, 600 )
                rangedframe:Center()
                rangedframe:MakePopup()
                rangedframe:SetTitle( "Melee Weapon Panel" )

                local leftpnl = vgui.Create( "EditablePanel", rangedframe )
                leftpnl:SetSize( 200, 200 )
                leftpnl:Dock( LEFT )

                local label = vgui.Create( "DLabel", leftpnl )
                label:Dock( TOP )
                label:SetText( "Weapon Class Name ( Must be unique )" )

                label = vgui.Create( "DLabel", leftpnl )
                label:Dock( TOP )
                label:SetText( "Example: STRIKER" )
 
                local weaponsclassname = vgui.Create( "DTextEntry", leftpnl )
                weaponsclassname:Dock( TOP )
                weaponsclassname:SetText( savedweapondata and savedweapondata[ 1 ] or "" )



                label = vgui.Create( "DLabel", leftpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Weapon Pretty Print" )

                label = vgui.Create( "DLabel", leftpnl )
                label:Dock( TOP )
                label:SetText( "Example: Striker" )

                label = vgui.Create( "DLabel", leftpnl )
                label:Dock( TOP )
                label:SetText( "( The name that's displayed in kill feed," )

                label = vgui.Create( "DLabel", leftpnl )
                label:Dock( TOP )
                label:SetText( "stats, ect )" )
 
                local weaponsprettyname = vgui.Create( "DTextEntry", leftpnl )
                weaponsprettyname:Dock( TOP )
                weaponsprettyname:SetText( savedweapondata and savedweapondata[ 2 ].prettyPrint or "")


                label = vgui.Create( "DLabel", leftpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "The animations to use with" )

                local enumtostring = {
                    [ ACT_HL2MP_IDLE_MELEE ] = "Melee",
                    [ ACT_HL2MP_IDLE_MELEE2 ] = "Melee2",
                    [ ACT_HL2MP_IDLE_KNIFE ] = "Knife",
                    [ ACT_HL2MP_IDLE_DUEL ] = "Duel",
                    [ ACT_HL2MP_IDLE_FIST ] = "Fists",
                }

                local indextranslation = {
                    [ "Melee" ] = 1,
                    [ "Melee2" ] = 2,
                    [ "Knife" ] = 3,
                    [ "Duel" ] = 4,
                    [ "Fists" ] = 5,
                }
                

                local animations = vgui.Create( "DComboBox", leftpnl )
                animations:Dock( TOP )
                animations:AddChoice( "Melee", "Melee", true )
                animations:AddChoice( "Melee2" )
                animations:AddChoice( "Knife" )
                animations:AddChoice( "Duel" )
                animations:AddChoice( "Fists" )

                if savedweapondata then
                    animations:ChooseOptionID( indextranslation[ enumtostring[ savedweapondata[ 2 ].anims.idle ] ] )
                end

                local midpnl = vgui.Create( "EditablePanel", rangedframe )
                midpnl:DockMargin( 30, 0, 0, 0 )
                midpnl:SetSize( 200, 200 )
                midpnl:Dock( LEFT )

                label = vgui.Create( "DLabel", midpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "The minimum amount of time to" )

                label = vgui.Create( "DLabel", midpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "swinging the weapon" )

                local fireratemin = vgui.Create( "DNumSlider", midpnl )
                fireratemin:Dock( TOP )
                fireratemin:SetDecimals( 2 )
                fireratemin:SetMax( 20 )
                fireratemin:SetMin( 0.01 )
                fireratemin:SetValue( savedweapondata and savedweapondata[ 2 ].fireData.rateMin or 0.3 )
                fireratemin:SetText( "Attack Rate Min" )



                label = vgui.Create( "DLabel", midpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "The maximum amount of time to" )

                label = vgui.Create( "DLabel", midpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "swinging the weapon" )

                local fireratemax = vgui.Create( "DNumSlider", midpnl )
                fireratemax:Dock( TOP )
                fireratemax:SetDecimals( 2 )
                fireratemax:SetMax( 20 )
                fireratemax:SetMin( 0.01 )
                fireratemax:SetValue( savedweapondata and savedweapondata[ 2 ].fireData.rateMax or 0.6 )
                fireratemax:SetText( "Attack Rate Max" )

                label = vgui.Create( "DLabel", midpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "The distance from the target to" )

                label = vgui.Create( "DLabel", midpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "attack from" )

                local attackdistance = vgui.Create( "DNumSlider", midpnl )
                attackdistance:Dock( TOP )
                attackdistance:SetDecimals( 0 )
                attackdistance:SetMax( 2000 )
                attackdistance:SetMin( 48 )
                attackdistance:SetValue( savedweapondata and savedweapondata[ 2 ].fireData.range or 48 )
                attackdistance:SetText( "Attack Range" )
                

                label = vgui.Create( "DLabel", midpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Recoil Animation" )


                local recoilenumtostring = {
                    [ ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE ] = "Melee",
                    [ ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2 ] = "Melee2",
                    [ ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE ] = "Knife",
                    [ ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST ] = "Fists",
                }

                local recoilindextranslation = {
                    [ "Melee" ] = 1,
                    [ "Melee2" ] = 2,
                    [ "Knife" ] = 3,
                    [ "Fists" ] = 4,
                }

                local recoilanimations = vgui.Create( "DComboBox", midpnl )
                recoilanimations:Dock( TOP )
                recoilanimations:AddChoice( "Melee", "Melee", true )
                recoilanimations:AddChoice( "Melee2" )
                recoilanimations:AddChoice( "Knife" )
                recoilanimations:AddChoice( "Fists" )

                if savedweapondata then
                    local enum = recoilenumtostring[ savedweapondata[ 2 ].fireData.anim ]
                    recoilanimations:ChooseOptionID( recoilindextranslation[ enum ] )
                end





                label = vgui.Create( "DLabel", midpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Lua Code Melee callbacks" )

                label = vgui.Create( "DLabel", midpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Code knowledge required for these!" )

                local precalleditbutton = vgui.Create( "DButton", midpnl )
                precalleditbutton:Dock( TOP )
                precalleditbutton:SetText( "Edit Weapon Hit callback" )



                function precalleditbutton:DoClick()

                    local precallbackframe = vgui.Create( "DFrame" )
                    precallbackframe:SetSize( 500, 500 )
                    precallbackframe:Center()
                    precallbackframe:SetSizable( true )
                    precallbackframe:MakePopup()
                    precallbackframe:SetTitle( "Pre Callback Editor" )

                    local docsframe = vgui.Create( "DFrame" )
                    docsframe:SetSize( 370, 700 )
                    docsframe:CenterHorizontal( 0.2 )
                    docsframe:CenterVertical( 0.5 )
                    docsframe:SetSizable( true )
                    docsframe:MakePopup()
                    docsframe:SetTitle( "Pre Callback Editor Docs" )


                    label = vgui.Create( "DLabel", docsframe )
                    --label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "There are three variables you can use in your code" )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "zeta  |  The zeta that is shooting this weapon" )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "wepENT  |  The weapon entity being used" )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "target  |  The entity that's being attacked" )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "There is no blockdata table for melee weapons" )
                    label:SetColor( green )
  

                    local codepanel = vgui.Create( "DTextEntry", precallbackframe )
                    codepanel:SetMultiline( true )
                    codepanel:Dock( FILL )
                    codepanel:SetEnterAllowed( false )
                    codepanel:SetTabbingDisabled( false )
                    precallbackcode = precallbackcode or savedweapondata and savedweapondata[ 2 ].fireData._customprecallcode or nil
                    codepanel:SetText( precallbackcode or "" )

                    function codepanel:OnChange()
                        precallbackcode = codepanel:GetText() == "" and nil or codepanel:GetText()
                    end

                end





                local onchangecalleditbutton = vgui.Create( "DButton", midpnl )
                onchangecalleditbutton:Dock( TOP )
                onchangecalleditbutton:SetText( "Edit On Change Callback" )




                function onchangecalleditbutton:DoClick()

                    local precallbackframe = vgui.Create( "DFrame" )
                    precallbackframe:SetSize( 500, 500 )
                    precallbackframe:Center()
                    precallbackframe:SetSizable( true )
                    precallbackframe:MakePopup()
                    precallbackframe:SetTitle( "On Change Callback Editor" )

                    local docsframe = vgui.Create( "DFrame" )
                    docsframe:SetSize( 370, 200 )
                    docsframe:CenterHorizontal( 0.2 )
                    docsframe:CenterVertical( 0.5 )
                    docsframe:SetSizable( true )
                    docsframe:MakePopup()
                    docsframe:SetTitle( "Callback Editor Docs" )


                    label = vgui.Create( "DLabel", docsframe )
                    --label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "This call back is called when a zeta" )

                    label = vgui.Create( "DLabel", docsframe )
                    --label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "switches their weapon to this weapon" )


                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "There are two variables you can use in your code" )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "zeta  |  The zeta that changed their weapon to this" )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "wepENT  |  The weapon entity being used" )
                    label:SetColor( green )
                    
                    
                    

                    local codepanel = vgui.Create( "DTextEntry", precallbackframe )
                    codepanel:SetMultiline( true )
                    codepanel:Dock( FILL )
                    codepanel:SetEnterAllowed( false )
                    codepanel:SetTabbingDisabled( false )
                    onchangecode = onchangecode or savedweapondata and savedweapondata[ 2 ]._customonchangecode or nil
                    codepanel:SetText( onchangecode or "" )

                    function codepanel:OnChange()
                        onchangecode = codepanel:GetText() == "" and nil or codepanel:GetText()
                    end

                end





                local thinkcallbackitbutton = vgui.Create( "DButton", midpnl )
                thinkcallbackitbutton:Dock( TOP )
                thinkcallbackitbutton:SetText( "Edit On Think Callback" )




                function thinkcallbackitbutton:DoClick()

                    local precallbackframe = vgui.Create( "DFrame" )
                    precallbackframe:SetSize( 500, 500 )
                    precallbackframe:Center()
                    precallbackframe:SetSizable( true )
                    precallbackframe:MakePopup()
                    precallbackframe:SetTitle( "On Think Callback Editor" )

                    local docsframe = vgui.Create( "DFrame" )
                    docsframe:SetSize( 370, 200 )
                    docsframe:CenterHorizontal( 0.2 )
                    docsframe:CenterVertical( 0.5 )
                    docsframe:SetSizable( true )
                    docsframe:MakePopup()
                    docsframe:SetTitle( "Callback Editor Docs" )


                    label = vgui.Create( "DLabel", docsframe )
                    --label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "This call back is called every Server Tick and Client Frame" )

                    label = vgui.Create( "DLabel", docsframe )
                    --label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "That means this code is Shared!" )



                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "There are two variables you can use in your code" )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "zeta  |  The zeta holding this weapon" )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "wepENT  |  The weapon entity being used" )
                    label:SetColor( green )
                    
                    
                    

                    local codepanel = vgui.Create( "DTextEntry", precallbackframe )
                    codepanel:SetMultiline( true )
                    codepanel:Dock( FILL )
                    codepanel:SetEnterAllowed( false )
                    codepanel:SetTabbingDisabled( false )
                    onthinkcode = onthinkcode or savedweapondata and savedweapondata[ 2 ]._customonthinkcode or nil
                    codepanel:SetText( onthinkcode or "" )

                    function codepanel:OnChange()
                        onthinkcode = codepanel:GetText() == "" and nil or codepanel:GetText()
                    end

                end




                local ondamagededitbutton = vgui.Create( "DButton", midpnl )
                ondamagededitbutton:Dock( TOP )
                ondamagededitbutton:SetText( "Edit On Damage Callback" )




                function ondamagededitbutton:DoClick()

                    local precallbackframe = vgui.Create( "DFrame" )
                    precallbackframe:SetSize( 500, 500 )
                    precallbackframe:Center()
                    precallbackframe:SetSizable( true )
                    precallbackframe:MakePopup()
                    precallbackframe:SetTitle( "On Damage Callback Editor" )

                    local docsframe = vgui.Create( "DFrame" )
                    docsframe:SetSize( 370, 200 )
                    docsframe:CenterHorizontal( 0.2 )
                    docsframe:CenterVertical( 0.5 )
                    docsframe:SetSizable( true )
                    docsframe:MakePopup()
                    docsframe:SetTitle( "Callback Editor Docs" )


                    label = vgui.Create( "DLabel", docsframe )
                    --label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "This call back is called when the zeta" )

                    label = vgui.Create( "DLabel", docsframe )
                    --label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "holding this weapon is damaged/hurt" )



                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 20, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "There are three variables you can use in your code" )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "zeta  |  The zeta holding this weapon" )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "wepENT  |  The weapon entity being used" )
                    label:SetColor( green )

                    label = vgui.Create( "DLabel", docsframe )
                    label:DockMargin( 0, 10, 0, 0 )
                    label:Dock( TOP )
                    label:SetText( "dmginfo  |  The Damage Info object of the damage" )
                    label:SetColor( green )
                    
                    
                    

                    local codepanel = vgui.Create( "DTextEntry", precallbackframe )
                    codepanel:SetMultiline( true )
                    codepanel:Dock( FILL )
                    codepanel:SetEnterAllowed( false )
                    codepanel:SetTabbingDisabled( false )
                    ondamagedcode = ondamagedcode or savedweapondata and savedweapondata[ 2 ]._customondamagedcode or nil
                    codepanel:SetText( ondamagedcode or "" )

                    function codepanel:OnChange()
                        ondamagedcode = codepanel:GetText() == "" and nil or codepanel:GetText()
                    end

                end







                local rightpnl = vgui.Create( "EditablePanel", rangedframe )
                rightpnl:DockMargin( 30, 0, 0, 0 )
                rightpnl:SetSize( 200, 200 )
                rightpnl:Dock( LEFT )



                label = vgui.Create( "DLabel", rightpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "The minimum amount of damage" )

                local dmgmin = vgui.Create( "DNumSlider", rightpnl )
                dmgmin:Dock( TOP )
                dmgmin:SetDecimals( 0 )
                dmgmin:SetMax( 2000 )
                dmgmin:SetMin( 1 )
                dmgmin:SetValue( savedweapondata and savedweapondata[ 2 ].fireData.dmgMin or 5 )
                dmgmin:SetText( "Damage Min" )



                label = vgui.Create( "DLabel", rightpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "The maximum amount of damage" )

                local dmgemax = vgui.Create( "DNumSlider", rightpnl )
                dmgemax:Dock( TOP )
                dmgemax:SetDecimals( 0 )
                dmgemax:SetMax( 2000 )
                dmgemax:SetMin( 1 )
                dmgemax:SetValue( savedweapondata and savedweapondata[ 2 ].fireData.dmgMax or 13 )
                dmgemax:SetText( "Damage Max" )

                label = vgui.Create( "DLabel", rightpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Swing sound" )
                
                label = vgui.Create( "DLabel", rightpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "The Sound that will play when swung" )

                local shootsnd = vgui.Create( "DTextEntry", rightpnl )
                shootsnd:Dock( TOP )
                shootsnd:SetText( savedweapondata and savedweapondata[ 2 ].fireData.snd or "weapons/iceaxe/iceaxe_swing1.wav" )

                label = vgui.Create( "DLabel", rightpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Hit sound" )

                label = vgui.Create( "DLabel", rightpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "The Sound that will play when the" )

                label = vgui.Create( "DLabel", rightpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "target is hit" )

                local hitsoundentry = vgui.Create( "DTextEntry", rightpnl )
                hitsoundentry:Dock( TOP )
                hitsoundentry:SetText( savedweapondata and savedweapondata[ 2 ].fireData.swingsnd or 'physics/flesh/flesh_impact_bullet1.wav' )
                
                label = vgui.Create( "DLabel", rightpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Browse sounds to add to" )

                label = vgui.Create( "DLabel", rightpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Swing sound and Hit Sound" )

                local soundbrowserbutton = vgui.Create( "DButton", rightpnl )
                soundbrowserbutton:Dock( TOP )
                soundbrowserbutton:SetText( "Open Sound Browser" )

                
                function soundbrowserbutton:DoClick()

                    local soundbrowserframe = vgui.Create( "DFrame" )
                    soundbrowserframe:SetSize( 500, 500 )
                    soundbrowserframe:Center()
                    soundbrowserframe:SetSizable( true )
                    soundbrowserframe:MakePopup()
                    soundbrowserframe:SetTitle( "Sound Browser" )

                    label = vgui.Create( "DLabel", soundbrowserframe )
                    label:Dock( TOP )
                    label:SetText( "Left click to preview a sound. Right click a sound to select it and use it" )

                    local searchbar = vgui.Create( "DTextEntry", soundbrowserframe )
                    searchbar:Dock( TOP )
                    searchbar:SetPlaceholderText( "Search Bar" )
                

                    local soundbrowser = vgui.Create( "DFileBrowser", soundbrowserframe )
                    soundbrowser:Dock( FILL )
                    soundbrowser:SetBaseFolder( "sound" )
                    soundbrowser:SetOpen( true, true )
                    soundbrowser:SetFileTypes( "*.wav *.mp3" )

                    local sndpatch


                    function soundbrowser:OnRightClick( path, pan )

                        local menu = DermaMenu( false, soundbrowser )
                        menu:Center()


                        menu:AddOption( "Use as Swing Sound", function()

                            local soundpath = string.Explode( "sound/", path )

                            shootsnd:SetText( soundpath[ 2 ] )

                            soundbrowserframe:Remove()

                        end )

                        menu:AddOption( "Use as Hit Sound", function()
                            
                            local soundpath = string.Explode( "sound/", path )

                            hitsoundentry:SetText( soundpath[ 2 ] )

                            soundbrowserframe:Remove()

                        end )
                    end

                    function soundbrowser:OnSelect( path )

                        local soundpath = string.Explode( "sound/", path )

                        if sndpatch then sndpatch:Stop() end

                        sndpatch = CreateSound( LocalPlayer(), soundpath[ 2 ] )

                        sndpatch:Play()
                        
                    end

                    function soundbrowserframe:OnClose()
                        if sndpatch then sndpatch:Stop() end
                    end

                    function searchbar:OnEnter( val )
                        if val == "" then soundbrowser:SetSearch( "*" ) return end

                        soundbrowser:SetSearch( val )
                    end

                end



                label = vgui.Create( "DLabel", rightpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Weapon Scale requires no Bone" )

                label = vgui.Create( "DLabel", rightpnl )
                --label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Merge!" )

                local weaponscale = vgui.Create( "DNumSlider", rightpnl )
                weaponscale:Dock( TOP )
                weaponscale:SetDecimals( 3 )
                weaponscale:SetMax( 100 )
                weaponscale:SetMin( 0 )
                weaponscale:SetValue( savedweapondata and savedweapondata[ 2 ].weaponscale or 1 )
                weaponscale:SetText( "Weapon Scale" )
                weaponscalevar = savedweapondata and savedweapondata[ 2 ].weaponscale or 1
                function weaponscale:OnValueChanged( val ) weaponscalevar = val end

                label = vgui.Create( "DLabel", rightpnl )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "No Bone Merge" )

                local bonemerge = vgui.Create( "DCheckBox", rightpnl )
                bonemerge:DockMargin( 0, 0, 150, 0 )
                bonemerge:Dock( TOP )
                
                disablebonemerge = savedweapondata and savedweapondata[ 2 ].nobonemerge

                bonemerge:SetChecked( tobool( disablebonemerge ) )

                function bonemerge:OnChange( val ) disablebonemerge = val end




                local rightpnl2 = vgui.Create( "EditablePanel", rangedframe )
                rightpnl2:DockMargin( 30, 0, 0, 0 )
                rightpnl2:SetSize( 200, 200 )
                rightpnl2:Dock( LEFT )

                label = vgui.Create( "DLabel", rightpnl2 )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Weapon Model" ) 

                local offsetx
                local offsety
                local offsetz


                weaponmdl = vgui.Create( "DTextEntry", rightpnl2 )
                weaponmdl:Dock( TOP )
                weaponmdl:SetText( savedweapondata and savedweapondata[ 2 ].mdl or "models/weapons/w_crowbar.mdl" )

                local viewmodels = vgui.Create( "DButton", rightpnl2 )
                viewmodels:Dock( TOP )
                viewmodels:SetText( "Find Models")

                function viewmodels:DoClick()

                    local modelbrowserframe = vgui.Create( "DFrame" )
                    modelbrowserframe:SetSize( 500, 500 )
                    modelbrowserframe:Center()
                    modelbrowserframe:SetSizable( true )
                    modelbrowserframe:MakePopup()
                    modelbrowserframe:SetTitle( "Model Viewer" )

                    local searchbar = vgui.Create( "DTextEntry", modelbrowserframe )
                    searchbar:Dock( TOP )
                    searchbar:SetPlaceholderText( "Search Bar" )
                

                    local modelbrowser = vgui.Create( "DFileBrowser", modelbrowserframe )
                    modelbrowser:Dock( FILL )
                    modelbrowser:SetModels( true )
                    modelbrowser:SetBaseFolder( "models" )
                    modelbrowser:SetOpen( true )
                    modelbrowser:SetFileTypes( "*.mdl" )

                    function modelbrowser:OnSelect( path )
                        modelbrowserframe:Remove()

                        weaponmdl:SetText( path )
                        weaponmdl:OnEnter( path )
                    end

                    function searchbar:OnEnter( val )
                        if val == "" then modelbrowser:SetSearch( "*" ) return end

                        modelbrowser:SetSearch( val )
                    end



                end

                label = vgui.Create( "DLabel", rightpnl2 )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Position Offset" ) 

                offsetx = vgui.Create( "DNumSlider", rightpnl2 )
                offsetx:Dock( TOP )
                offsetx:SetDecimals( 3 )
                offsetx:SetMax( 1000 )
                offsetx:SetMin( -1000 )
                offsetx:SetValue( savedweapondata and savedweapondata[ 2 ].offPos[ 1 ] or 0 )
                offsetx:SetText( "X" )

                offsety = vgui.Create( "DNumSlider", rightpnl2 )
                offsety:Dock( TOP )
                offsety:SetDecimals( 3 )
                offsety:SetMax( 1000 )
                offsety:SetMin( -1000 )
                offsety:SetValue( savedweapondata and savedweapondata[ 2 ].offPos[ 2 ] or 0 )
                offsety:SetText( "Y" )

                offsetz = vgui.Create( "DNumSlider", rightpnl2 )
                offsetz:Dock( TOP )
                offsetz:SetDecimals( 3 )
                offsetz:SetMax( 1000 )
                offsetz:SetMin( -1000 )
                offsetz:SetValue( savedweapondata and savedweapondata[ 2 ].offPos[ 3 ] or 0 )
                offsetz:SetText( "Z" )



                label = vgui.Create( "DLabel", rightpnl2 )
                label:DockMargin( 0, 20, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Angle Offset" ) 

                local offsetp = vgui.Create( "DNumSlider", rightpnl2 )
                offsetp:Dock( TOP )
                offsetp:SetDecimals( 3 )
                offsetp:SetMax( 180 )
                offsetp:SetMin( -180 )
                offsetp:SetValue( savedweapondata and savedweapondata[ 2 ].offAng[ 1 ] or 0 )
                offsetp:SetText( "Pitch" )

                local offsetyAng = vgui.Create( "DNumSlider", rightpnl2 )
                offsetyAng:Dock( TOP )
                offsetyAng:SetDecimals( 3 )
                offsetyAng:SetMax( 180 )
                offsetyAng:SetMin( -180 )
                offsetyAng:SetValue( savedweapondata and savedweapondata[ 2 ].offAng[ 2 ] or 0 )
                offsetyAng:SetText( "Yaw" )

                local offsetr = vgui.Create( "DNumSlider", rightpnl2 )
                offsetr:Dock( TOP )
                offsetr:SetDecimals( 3 )
                offsetr:SetMax( 180 )
                offsetr:SetMin( -180 )
                offsetr:SetValue( savedweapondata and savedweapondata[ 2 ].offAng[ 3 ] or 0 )
                offsetr:SetText( "Roll" )



                local weaponpreview = vgui.Create( "DAdjustableModelPanel", rightpnl2 )
                weaponpreview:SetSize( 100, 200)
                weaponpreview:Dock( TOP )
                weaponpreview:SetModel( "models/player/breen.mdl" )
                weaponpreview:SetFOV( 40 )

                weaponpreview:OnMousePressed( MOUSE_LEFT )

                timer.Simple( 0, function() 
                    weaponpreview:OnMouseReleased( MOUSE_LEFT )
                end )

                local previewent = weaponpreview:GetEntity()
                previewent:SetAngles( Angle(0,0,0) )
                previewent:SetNoDraw( false )

                local weaponent = ClientsideModel( weaponmdl:GetText() )
                weaponent:SetNoDraw( false )

                function weaponmdl:OnEnter( val )
                    weaponent:SetModel( val )
                end

                local lookup = previewent:LookupAttachment('anim_attachment_RH')
                local attach = GetAttachmentPoint( previewent, "hand" )

                weaponent:SetPos( attach.Pos )
                weaponent:SetAngles( attach.Ang )
                weaponent:AddFlags( EF_BONEMERGE )
                weaponent:SetParent( previewent, lookup )
                

                function weaponpreview:LayoutEntity( ent )
                    
                end

                function weaponpreview:PostDrawModel()
                    local attach = GetAttachmentPoint( previewent, "hand" )
                    local pos = attach.Pos + Vector( offsetx and offsetx:GetValue() or 0, offsety and offsety:GetValue() or 0, offsetz and offsetz:GetValue() or 0 )
                    local ang = attach.Ang + Angle( offsetp and offsetp:GetValue() or 0, offsetyAng and offsetyAng:GetValue() or 0, offsetr and offsetr:GetValue() or 0 )

                    render.DrawLine( weaponent:GetPos(), weaponent:GetPos() + Vector( 0, 0, 40 ), Color( 0, 0, 255 ) )
                    render.DrawLine( weaponent:GetPos(), weaponent:GetPos() + Vector( 0, 40, 0 ), Color( 0, 255, 0 ) )
                    render.DrawLine( weaponent:GetPos(), weaponent:GetPos() + Vector( 40, 0, 0 ), Color( 255, 0, 0 ) )

                    weaponent:SetPos( pos )
                    weaponent:SetAngles( ang )

                    weaponent:SetModelScale( weaponscale:GetValue(), 0 )

                    weaponent:DrawModel()
                end

                function rangedframe:OnClose()
                    weaponent:Remove()
                end

                

                local animationtranslation = {
                    ["Melee"] = "idle_melee",
                    ["Melee2"] = "idle_melee2",
                    ["Knife"] = "idle_knife",
                    ["Duel"] = "idle_dual",
                    ["Fists"] = "idle_fist"
                }

                function animations:OnSelect( index, val, data )
                    previewent:SetSequence( previewent:LookupSequence( animationtranslation[ val ] ) )
                    previewent:ResetSequenceInfo()
                end
                
                previewent:SetSequence( previewent:LookupSequence( animationtranslation[ animations:GetSelected() ] ) )


                local compileanimationtranslations = {
                    [ "Melee" ] = { idle = ACT_HL2MP_IDLE_MELEE, move = ACT_HL2MP_RUN_MELEE, jump = ACT_HL2MP_JUMP_MELEE, crouch = ACT_HL2MP_WALK_CROUCH_MELEE },
                    [ "Melee2" ] = { idle = ACT_HL2MP_IDLE_MELEE2, move = ACT_HL2MP_RUN_MELEE2, jump = ACT_HL2MP_JUMP_MELEE2, crouch = ACT_HL2MP_WALK_CROUCH_MELEE2 },
                    [ "Knife" ] = { idle = ACT_HL2MP_IDLE_KNIFE, move = ACT_HL2MP_RUN_KNIFE, jump = ACT_HL2MP_JUMP_KNIFE, crouch = ACT_HL2MP_WALK_CROUCH_KNIFE },
                    [ "Duel" ] = { idle = ACT_HL2MP_IDLE_DUEL, move = ACT_HL2MP_RUN_DUEL, jump = ACT_HL2MP_JUMP_DUEL, crouch = ACT_HL2MP_WALK_CROUCH_DUEL },
                    [ "Fists" ] = { idle = ACT_HL2MP_IDLE_FIST, move = ACT_HL2MP_RUN_FIST, jump = ACT_HL2MP_JUMP_FIST, crouch = ACT_HL2MP_WALK_CROUCH_FIST },
                }

                local compilerecoilanimations = {
                    [ "Melee" ] = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE,
                    [ "Melee2" ] = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2,
                    [ "Knife" ] = ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE,
                    [ "Fists" ] = ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST,
                }


                local function CompileWeaponData()
                    if weaponsclassname:GetText() == "" or weaponsprettyname:GetText() == "" then surface.PlaySound( "buttons/button10.wav" ) notification.AddLegacy( "Weapon is missing Class name or is missing Pretty print!", NOTIFY_ERROR, 4) return end



                    local compiledtableholder = {}

                    local compiledanimations = compileanimationtranslations[ animations:GetSelected() ]

                    local precallback = [[


                    ]]

                    local onchangecallback = [[

                        local args = { ... }

                        local zeta = args[ 1 ]
                        local wepENT = args[ 2 ]

                    ]]

                    local onthinkcallback = [[

                        local args = { ... }

                        local zeta = args[ 1 ]
                        local wepENT = args[ 2 ]

                    ]]

                    local ondamagedcallback = [[

                        local args = { ... }

                        local zeta = args[ 1 ]
                        local wepENT = args[ 2 ]
                        local dmginfo = args[ 3 ]

                    ]]

                    if precallbackcode then
                        precallback = precallback .. precallbackcode
                    else
                        precallback = ""
                    end

                    if onchangecode then
                        onchangecallback = onchangecallback .. onchangecode
                    else
                        onchangecallback = nil
                    end


                    if onthinkcode then
                        onthinkcallback = onthinkcallback .. onthinkcode
                    else
                        onthinkcallback = nil
                    end

                    if ondamagedcode then
                        ondamagedcallback = ondamagedcallback .. ondamagedcode
                    else
                        ondamagedcallback = nil
                    end

                    


                    compiledtableholder[ weaponsclassname:GetText() ] = {

                        mdl = weaponmdl:GetText(),

                        hidewep = false,
                        offPos = Vector( offsetx and offsetx:GetValue() or 0, offsety and offsety:GetValue() or 0, offsetz and offsetz:GetValue() or 0 ),
                        offAng = Angle( offsetp and offsetp:GetValue() or 0, offsetyAng and offsetyAng:GetValue() or 0, offsetr and offsetr:GetValue() or 0 ),
                        lethal = true,
                        range = false,
                        melee = true,
                        clip = 1,
                        prettyPrint = weaponsprettyname:GetText(),
                        weaponscale = weaponscalevar,
                        nobonemerge = disablebonemerge,

                        anims = {
                            idle = compiledanimations.idle,
                            move = compiledanimations.move,
                            jump = compiledanimations.jump,
                            crouch = compiledanimations.crouch
                        },
                        
                        changeCallback = onchangecallback,
                        _customonchangecode = onchangecode,

                        onDamageCallback = ondamagedcallback,
                        _customondamagedcode  = ondamagedcode,

                        onThink = onthinkcallback,
                        _customonthinkcode = onthinkcode,
                        
                        fireData = {
                            rateMin = fireratemin:GetValue(),
                            rateMax = fireratemax:GetValue(),
                            dmgMin = dmgmin:GetValue(),
                            dmgMax = dmgemax:GetValue(),

                            range = attackdistance:GetValue(),
                            anim = compilerecoilanimations[ recoilanimations:GetSelected() ],
                            snd = shootsnd:GetText(),
                            swingsnd = hitsoundentry:GetText(),
                            
                            _customprecallcode = precallbackcode,
                            preCallback = string.format( [[

                                local args = { ... }

                                local zeta = args[ 1 ]
                                local wepENT = args[ 2 ]
                                local target = args[ 3 ]

                                


                                local ratemin = %s
                                local ratemax = %s
                                local gestureanim = %s
                                local swingsound = %q
                                local damagemin = %s
                                local damagemax = %s
                                local hitsound = %q

                                if CurTime() <= zeta.AttackCooldown then return end

                                zeta.AttackCooldown = CurTime() + math.Rand( ratemin, ratemax )


                    
                                if zeta:IsPlayingGesture( gestureanim ) then
                                    zeta:RemoveGesture( gestureanim )
                                end
                                
                                zeta:AddGesture( gestureanim , true)
                                zeta:FaceTick(target, 100)
                                wepENT:EmitSound( swingsound, 80)
                    
                                local dmg = DamageInfo()
                                dmg:SetDamage( math.Rand( damagemin, damagemax ) / GetConVar("zetaplayer_damagedivider"):GetInt())
                                dmg:SetAttacker(zeta)
                                dmg:SetInflictor(wepENT)
                                dmg:SetDamageType(bit.bor(DMG_CLUB, DMG_SLASH))
                                target:TakeDamageInfo(dmg)
                    
                                target:EmitSound( hitsound, 80)
                            ]], fireratemin:GetValue(), fireratemax:GetValue(), compilerecoilanimations[ recoilanimations:GetSelected() ], shootsnd:GetText(), dmgmin:GetValue(), dmgemax:GetValue(), hitsoundentry:GetText() ) .. precallback
                        },

                    }

                    local data = file.Read( "zetaplayerdata/weapondata.dat" )

                    if !data then data = util.Compress( "[]" ) ZetaFileWrite( "zetaplayerdata/weapondata.dat", util.Compress( "[]" ) ) end

                    surface.PlaySound( "buttons/button15.wav" )
                    notification.AddLegacy( "Added/Updated " .. weaponsprettyname:GetText(), NOTIFY_GENERIC, 2 )

                    data = util.Decompress( data )
                    data = util.JSONToTable( data )

                    data[ weaponsclassname:GetText() ] = compiledtableholder[ weaponsclassname:GetText() ]

                    data = util.TableToJSON( data )
                    data = util.Compress( data )

                    ZetaFileWrite( "zetaplayerdata/weapondata.dat", data )



                    timer.Simple( 0, function()

                        notification.AddLegacy( "Updating Spawnmenu and Weapons.. You may experience lag for a few seconds", NOTIFY_HINT, 4 )

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

                        net.Start( "zetaweaponcreator_updateweapons" )
                        net.SendToServer()

                        include("zeta/weapon_tables.lua")

                        _ZetaRegisterDefaultWeapons()
                        
                    end)

                end



                label = vgui.Create( "DLabel", leftpnl )
                label:DockMargin( 0, 60, 0, 0 )
                label:Dock( TOP )
                label:SetText( "Submit Weapon" )

                local compile = vgui.Create( "DButton", leftpnl )
                compile:Dock( TOP )
                compile:SetText( "Compile Weapon Data" )

                compile.DoClick = CompileWeaponData

            end







        end




    hook.Add("Initialize","ZetaClientConsolecommands",function()
        concommand.Add('zetaplayer_openweaponcreatorpanel',OpenWeaponCreationPanel,nil,'Opens the Weapon Creation Panel')
        concommand.Add('zetaplayer_opennamepanel',OpenNameRegisterPanel,nil,'Opens the Name Register Panel')
        concommand.Add('zetaplayer_openteamentsavepanel',OpenTeamEntSavePanel,nil,'Opens the team ent data Register Panel')
        concommand.Add('zetaplayer_openproppanel',OpenPropPanel,nil,'Opens the Prop Register Panel')
        concommand.Add('zetaplayer_openvotingpanel',OpenVotingPanel,nil,'Opens the Voting Data Panel')
        concommand.Add('zetaplayer_openentpanel',OpenEntPanel,nil,'Opens the Entity Register Panel')
        concommand.Add('zetaplayer_openmediapanel',OpenMediaPanel,nil,'Opens the Media URL Register Panel')
        concommand.Add('zetaplayer_opennpcpanel',OpenNPCPanel,nil,'Opens the NPC Register Panel')
        concommand.Add('zetaplayer_openprofilepanel',OpenProfilePanel,nil,'Opens the Profile Panel')
        concommand.Add('zetaplayer_openblockedmodelpanel',OpenBlockPanel,nil,'Opens the Blocked Model Panel')
        concommand.Add('zetaplayer_opentextdatapanel',OpenTextDataPanel,nil,'Opens the Text Data Panel')
        concommand.Add('zetaplayer_openpresetpanel',OpenZetaPresetPanel,nil,'Opens the Preset Panel')
        concommand.Add('zetaplayer_openviewshotviewer',OpenViewShotViewerPanel,nil,'Opens the View Shot Viewer')
    end)
    
    concommand.Add('zetaplayer_openweaponcreatorpanel',OpenWeaponCreationPanel,nil,'Opens the Weapon Creation Panel')
    concommand.Add('zetaplayer_opennamepanel',OpenNameRegisterPanel,nil,'Opens the Name Register Panel')
    concommand.Add('zetaplayer_openviewshotviewer',OpenViewShotViewerPanel,nil,'Opens the View Shot Viewer')
    concommand.Add('zetaplayer_openpresetpanel',OpenZetaPresetPanel,nil,'Opens the Preset Panel')
    concommand.Add('zetaplayer_openteamentsavepanel',OpenTeamEntSavePanel,nil,'Opens the team ent data Register Panel')
    concommand.Add('zetaplayer_openvotingpanel',OpenVotingPanel,nil,'Opens the Voting Data Panel')
    concommand.Add('zetaplayer_openmediapanel',OpenMediaPanel,nil,'Opens the Media URL Register Panel')
    concommand.Add('zetaplayer_openproppanel',OpenPropPanel,nil,'Opens the Prop Register Panel')
    concommand.Add('zetaplayer_openentpanel',OpenEntPanel,nil,'Opens the Entity Register Panel')
    concommand.Add('zetaplayer_opennpcpanel',OpenNPCPanel,nil,'Opens the NPC Register Panel')
    concommand.Add('zetaplayer_openprofilepanel',OpenProfilePanel,nil,'Opens the Profile Panel')
    concommand.Add('zetaplayer_opentextdatapanel',OpenTextDataPanel,nil,'Opens the Text Data Panel')
    concommand.Add('zetaplayer_openblockedmodelpanel',OpenBlockPanel,nil,'Opens the Blocked Model Panel')
end 