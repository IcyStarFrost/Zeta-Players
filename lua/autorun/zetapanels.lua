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
    ---------------------

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

        file.Write("zetaplayerdata/profiles.json",encoded)

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
                file.Write("zetaplayerdata/props.json",encoded)
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
            file.Write("zetaplayerdata/props.json",encoded)
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
                file.Write("zetaplayerdata/npcs.json",encoded)
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
            file.Write("zetaplayerdata/npcs.json",encoded)
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
                file.Write("zetaplayerdata/ents.json",encoded)
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
            file.Write("zetaplayerdata/ents.json",encoded)
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

        file.Write("zetaplayerdata/profiles.json",encode)
        

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

        file.Write("zetaplayerdata/textchatdata.json",encode)
        

    end)

    net.Receive('zetapanel_addtext',function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to add Text!') return end
        local text = net.ReadString()
        local position = net.ReadString()
        
        local TextDataJSON = file.Read("zetaplayerdata/textchatdata.json","DATA")
        local TextData = util.JSONToTable(TextDataJSON)

        table.insert(TextData[position],text) 


        local encode = util.TableToJSON(TextData,true)

        file.Write("zetaplayerdata/textchatdata.json",encode)
        

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

        file.Write("zetaplayerdata/mediaplayerdata.json",encode)
        

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

        file.Write("zetaplayerdata/mediaplayerdata.json",encode)

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
            file.Write("zetaplayerdata/blockedplayermodels.json",encoded)
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
            file.Write("zetaplayerdata/blockedplayermodels.json",encoded)
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
            file.Write("zetaplayerdata/votingdata.json",encoded)
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
            file.Write("zetaplayerdata/votingdata.json",encoded)
            ply:PrintMessage(HUD_PRINTCONSOLE,"Removed ".._string.." from Voting Data")
    end)


    
    

    -- END VOTING PANEL
    

elseif ( CLIENT ) then


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

                local UpdateBodyGroups

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

                panellist:DockMargin(0,30,0,0)
                panellist:Dock(RIGHT)
                panellist:SetSize(200,300)
                panellist:AddColumn('Zeta Profile',1)

                for k,v in pairs(profiles) do
                    local line = panellist:AddLine(v["name"])
                    line:SetSortValue( 1, v )
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


                function playermodel:OnChange()
                    playermodelpreview:SetImage(string.Replace( "spawnicons/"..playermodel:GetText(),".mdl",".png"))
                    --UpdateBodyGroups()
                end


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

                local pfppreview = vgui.Create("DImage", setting1)
                pfppreview:SetSize(70,70)
                pfppreview:SetPos(10,200)
                pfppreview:SetImage("spawnicons/models/player/kleiner.png")

                function pfp:OnChange()
                    pfppreview:SetImage("../data/zetaplayerdata/custom_avatars/"..pfp:GetText())
                end

                local sheet = vgui.Create( "DPropertySheet", setting1 )
                sheet:SetSize(350,100)
                sheet:Dock( RIGHT )

                local panel = spawnmenu.GetCreationTabs()["#spawnmenu.content_tab"].Function()
                panel:SetParent( sheet )

                sheet:AddSheet("#spawnmenu.content_tab", panel, spawnmenu.GetCreationTabs()["#spawnmenu.content_tab"].Icon )

                namelabel = vgui.Create( 'DLabel', setting1 )
                namelabel:SetText('Use this spawnmenu to copy Playermodel model paths')
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


--[[                 local bodygroupPANEL = vgui.Create("EditablePanel",setting2)
                bodygroupPANEL:SetPos(820,0)
                bodygroupPANEL:SetSize(300,100)

                local scrollpanel = vgui.Create( "DScrollPanel", bodygroupPANEL )
                scrollpanel:Dock( FILL )

                local dummyent = ents.CreateClientside("base_anim")
                dummyent:SetModel(playermodel:GetText())
                dummyent:Spawn()

                local bodygroups = dummyent:GetBodyGroups()
                local bodygrouppanels = {}


                local function MakeNiceName( str ) -- Gmod's function for bodygroup names
                    local newname = {}
        
                    for _, s in pairs( string.Explode( "_", str ) ) do
                        if ( string.len( s ) == 1 ) then table.insert( newname, string.upper( s ) ) continue end
                        table.insert( newname, string.upper( string.Left( s, 1 ) ) .. string.Right( s, string.len( s ) - 1 ) ) // Ugly way to capitalize first letters.
                    end
        
                    return string.Implode( " ", newname )
                end

                function UpdateBodyGroups()
                    if #bodygrouppanels > 0 then
                        for k,v in ipairs(bodygrouppanels) do
                            v:Remove()
                        end
                    end
                    scrollpanel:InvalidateLayout()
                    if !util.IsValidModel(playermodel:GetText()) then return end



                    local dummyent = ents.CreateClientside("base_anim")
                    dummyent:SetModel(playermodel:GetText())
                    dummyent:Spawn()
    
                    local bodygroups = dummyent:GetBodyGroups()
                    local bodygrouppanels = {}

                    for k = 0, dummyent:GetNumBodyGroups() - 1 do
                        if ( dummyent:GetBodygroupCount( k ) <= 1 ) then continue end
    
                        local slider = vgui.Create( 'DNumSlider', scrollpanel )
                        slider:Dock( TOP )
                        slider:DockMargin( 0, 0, 0, 5 )
                        slider:SetMax(dummyent:GetBodygroupCount( k ) - 1)
                        slider:SetDecimals( 0 )	
                        slider:SetText(MakeNiceName( dummyent:GetBodygroupName( k ) ))
                        table.insert(bodygrouppanels,slider)
                    end


    
                    dummyent:Remove()

                end



                for k = 0, dummyent:GetNumBodyGroups() - 1 do
                    if ( dummyent:GetBodygroupCount( k ) <= 1 ) then continue end

                    local slider = vgui.Create( 'DNumSlider', scrollpanel )
                    slider:Dock( TOP )
                    slider:DockMargin( 0, 0, 0, 5 )
                    slider:SetMax(dummyent:GetBodygroupCount( k ) - 1)
                    slider:SetDecimals( 0 )	
                    slider:SetText(MakeNiceName( dummyent:GetBodygroupName( k ) ))
                    table.insert(bodygrouppanels,slider)
                end

                dummyent:Remove() ]]


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

                    
                    if mingebagbox:GetChecked() then
                        profileDATA["mingebag"] = true
                    end 

                    if nodisconnect:GetChecked() then
                        profileDATA["nodisconnect"] = true
                    end 
                    

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


                notification.AddLegacy("Received Text Data! Took "..CurTime()-starttime.." seconds",NOTIFY_CLEANUP,4)

                local frame = vgui.Create( 'DFrame' )
                frame:SetDeleteOnClose( true )
                frame:CenterHorizontal(0.3)
                frame:CenterVertical(0.4)
                frame:SetTitle('Zeta Text Data Panel')
                frame:SetIcon( 'icon/physgun.png' )
                frame:SetSize(1150,500)
                frame:MakePopup()

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

                


                mainsheet:AddSheet("Page 2",setting2)

                local help = vgui.Create("EditablePanel",mainsheet)
                help:Dock(FILL)


                label = vgui.Create("DLabel",help)
                label:SetPos(10,-190)
                label:SetSize(1000,600)
                label:SetText("KeyPhrases. \n\n KeyPhrases are used to be replaced by whatever it is representing.\nFor example, /rndmap/ will be replaced with a map you have.\n\n-- KEYPHRASE LIST --\n\n/map/  This will translate to the current map being played on. This can be used anywhere\n/rndent/    This will translate to a random Zeta's or Player's name. This can be used anywhere\n/keyent/   This will used to mention a certain player or zeta in a certain situation. This can only be used in, response, death, insult and admininterror.\n/rndmap/   This will translate into a random map you have. This can be used anywhere\n/curday/    This will translate to the current day of the week. For example, Friday. This can be used anywhere\n/rndword/ Translates to random word a Zeta said. This can only be used in Response\n/realplayer/ Translates to your name. This can be used anywhere\n/self/ Translates to the Zeta speaking the message. This can be used anywhere\n/rndaddon/ Translates to a random addon you have installed. This can be used anywhere")

                label = vgui.Create("DLabel",help)
                label:SetPos(10,-20)
                label:SetSize(1000,600)
                label:SetText("-- TEXT TYPES --\n\nadmininterror  This is used for Admins scolding a offender. Like adminscold voice lines. \nidle  Idle is idle. Self explanatory\ninsult  Insult is used for a zeta who has killed someone. Just like kill voice lines. \nresponse    Response is used for a Zeta who wants to respond to someone in text chat.\ndeath  Death is used for when the zeta dies.\n mediawatch is used for zetas watching a media player\nConnect  is used for when a Zeta spawns\nDisconnect is for when a Zeta is about to leave")



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


                notification.AddLegacy("Received Media URLs! Took "..CurTime()-starttime.." seconds",NOTIFY_CLEANUP,4)

                local frame = vgui.Create( 'DFrame' )
                frame:SetDeleteOnClose( true )
                frame:CenterHorizontal(0.3)
                frame:CenterVertical(0.4)
                frame:SetTitle('Zeta Text Data Panel')
                frame:SetIcon( 'icon/physgun.png' )
                frame:SetSize(1150,500)
                frame:MakePopup()

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
                
                local textbox = vgui.Create("DTextEntry",frame)
                textbox:DockMargin(0,50,0,0)
                textbox:Dock(BOTTOM)

                local label = vgui.Create( 'DLabel', frame )
                label:SetText('Welcome to the Blocked Models Panel! There are '..count..' Blocked Models. Right click a Model path in the list to the right to remove it')
                label:Dock(TOP)

                local label2 = vgui.Create( 'DLabel', frame )
                label2:SetText('Copy and paste a model path to the text box at the bottom and press enter')
                label2:Dock(TOP)


                local sheet = vgui.Create( "DPropertySheet", frame )
                sheet:SetSize(600,100)
                sheet:Dock( LEFT )

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

                function textbox:OnEnter(val)
                    textbox:SetText("")
                    if !util.IsValidModel(val) then
                        notification.AddLegacy(val..' is not a valid model! Did you accidently add a character?',NOTIFY_ERROR,4)
                        LocalPlayer():EmitSound('buttons/button10.wav')
                        return
                     end

                    net.Start('zetapanel_addblockedmodel')
                        net.WriteString(val)
                    net.SendToServer()


                    
                    local line = panellist:AddLine(val)
                    line:SetSortValue( 1, val )
                    panellist:SetDirty( true )
                    count = count + 1
                    label:SetText('Welcome to the Blocked Models Panel! There are '..count..' Blocked Models. Right click a Model path in the list to the right to remove it')
                end




                local panel = spawnmenu.GetCreationTabs()["#spawnmenu.content_tab"].Function()
                panel:SetParent( sheet )

                sheet:AddSheet("#spawnmenu.content_tab", panel, spawnmenu.GetCreationTabs()["#spawnmenu.content_tab"].Icon )





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
    
                    notification.AddLegacy("Received all Vote Data! Took "..CurTime()-starttime.." seconds",NOTIFY_CLEANUP,4)
                    
                    local frame = vgui.Create( 'DFrame' )
                    frame:SetDeleteOnClose( true )
                    frame:CenterHorizontal(0.3)
                    frame:CenterVertical(0.4)
                    frame:SetTitle('Voting Data Panel')
                    frame:SetIcon( 'icon/physgun.png' )
                    frame:SetSize(700,500)
                    frame:MakePopup()
                    

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
    
                    notification.AddLegacy("Received all Team Ent Data! Took "..CurTime()-starttime.." seconds",NOTIFY_CLEANUP,4)
                    
                    local frame = vgui.Create( 'DFrame' )
                    frame:SetDeleteOnClose( true )
                    frame:CenterHorizontal(0.3)
                    frame:CenterVertical(0.4)
                    frame:SetTitle('Team Ent Save Data Panel')
                    frame:SetIcon( 'icon/physgun.png' )
                    frame:SetSize(500,400)
                    frame:MakePopup()
                    

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



        

    hook.Add("Initialize","ZetaClientConsolecommands",function()
        concommand.Add('zetaplayer_openteamentsavepanel',OpenTeamEntSavePanel,nil,'Opens the team ent data Register Panel')
        concommand.Add('zetaplayer_openproppanel',OpenPropPanel,nil,'Opens the Prop Register Panel')
        concommand.Add('zetaplayer_openvotingpanel',OpenVotingPanel,nil,'Opens the Voting Data Panel')
        concommand.Add('zetaplayer_openentpanel',OpenEntPanel,nil,'Opens the Entity Register Panel')
        concommand.Add('zetaplayer_openmediapanel',OpenMediaPanel,nil,'Opens the Media URL Register Panel')
        concommand.Add('zetaplayer_opennpcpanel',OpenNPCPanel,nil,'Opens the NPC Register Panel')
        concommand.Add('zetaplayer_openprofilepanel',OpenProfilePanel,nil,'Opens the Profile Panel')
        concommand.Add('zetaplayer_openblockedmodelpanel',OpenBlockPanel,nil,'Opens the Blocked Model Panel')
        concommand.Add('zetaplayer_opentextdatapanel',OpenTextDataPanel,nil,'Opens the Text Data Panel')
    end)
    

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