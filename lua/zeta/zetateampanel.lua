AddCSLuaFile()


if SERVER then
    util.AddNetworkString('zetapanel_getteams')
    util.AddNetworkString('zetapanel_sendteams')
    util.AddNetworkString('zetapanel_resetteams')
    util.AddNetworkString('zetapanel_removeteam')
    util.AddNetworkString('zetapanel_addteam')
    util.AddNetworkString('zetapanel_setteam')



    net.Receive('zetapanel_setteam',function()
        local selectedteam = net.ReadString()
        GetConVar('zetaplayer_playerteam'):SetString(selectedteam)
    end)


    net.Receive('zetapanel_getteams',function(len,ply)
        local json = file.Read("zetaplayerdata/teams.json","DATA")
        local tbl = util.JSONToTable(json)
        for k,teamtbl in ipairs(tbl) do
            local isdone = false
            if k == #tbl then
                isdone = true
            end
            net.Start("zetapanel_sendteams")
            net.WriteString(util.TableToJSON(teamtbl))
            net.WriteBool(isdone)
            net.Send(ply)
        end
        if table.Count(tbl) <= 0 then
            net.Start("zetapanel_sendteams")
            net.WriteString("PLACEHOLDER")
            net.WriteBool(true)
            net.Send(ply)
        end
    end)

    net.Receive("zetapanel_addteam",function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to register Teams!') return end

            local team_ = net.ReadString()
            team_ = util.JSONToTable(team_)
        
            local json = file.Read("zetaplayerdata/teams.json","DATA")

            local decoded = util.JSONToTable(json)

            for k,v in ipairs(decoded) do
                if v[1] == team_[1] then
                    net.Start('zeta_notifycleanup',true)
                    net.WriteString(team_[1].." is already a team!")
                    net.WriteBool(true)
                    net.Send(ply)
                    return
                end
            end

            table.insert(decoded,team_)
            local encoded = util.TableToJSON(decoded,true)
            file.Write("zetaplayerdata/teams.json",encoded)
            ply:PrintMessage(HUD_PRINTCONSOLE,"Added "..team_[1].." to teams")

            net.Start('zeta_notifycleanup',true)
            net.WriteString("Added "..team_[1].." to teams")
            net.WriteBool(false)
            net.Send(ply)
        
    end)

    net.Receive("zetapanel_removeteam",function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to remove Teams!') return end

        local team_ = net.ReadString()
        team_ = util.JSONToTable(team_)

        local json = file.Read("zetaplayerdata/teams.json","DATA")
        local teamtbl = util.JSONToTable(json)

        for k,v in ipairs(teamtbl) do
            if team_[1] == v[1] then
                table.remove(teamtbl,k)
            end
        end

        local encoded = util.TableToJSON(teamtbl,true)
        file.Write("zetaplayerdata/teams.json",encoded)

        ply:PrintMessage(HUD_PRINTCONSOLE,"Removed "..team_[1].." from teams")

        net.Start('zeta_notifycleanup',true)
        net.WriteString("Removed "..team_[1].." from teams")
        net.WriteBool(false)
        net.Send(ply)
    
    end)

    function _ZetaSaveTeamEntities(filename)
        local teamspawns = ents.FindByClass("zeta_teamspawnpoint")
        local KOTHMarkers = ents.FindByClass("zeta_koth")
        local Flags = ents.FindByClass("zeta_flag")
        local TEAMENTS = {spawns = {},kothpoints = {},flags = {}}

        if #teamspawns == 0 and #KOTHMarkers == 0 then PrintMessage(HUD_PRINTTALK,"There are no Ents to save!") return end

        for k,spawn in ipairs(teamspawns) do
            local data = {
                pos = spawn:GetPos(),
                teamspawn = spawn:GetTeamSpawn()
            }

            table.insert(TEAMENTS.spawns,data)
        end

        for k,point in ipairs(KOTHMarkers) do
            local data = {
                pos = point:GetPos(),
                name = point.Identity
            }

            table.insert(TEAMENTS.kothpoints,data)
        end

        for k,point in ipairs(Flags) do
            local data = {
                pos = point.CaptureZone:GetPos(),
                name = point.customname,
                zetateam = point.teamowner,
                canpickup = point.CanBePickedUp,
            }

            table.insert(TEAMENTS.flags,data)
        end
        
        local encodedjson = util.TableToJSON(TEAMENTS,true)
        file.Write("zetaplayerdata/teamentdata/"..game.GetMap().."/"..filename..".json",encodedjson)
        print("Successfully wrote all Team Related Entities to, ".."zetaplayerdata/teamentdata/"..game.GetMap().."/"..filename..".json")
    end

    function _ZetaReadAndInitializeTeamEnts(filepath)
        local TEAMENTFILE = file.Read(filepath)
        local ENTDATA = util.JSONToTable(TEAMENTFILE)

        local Currentteams = {}

        print("Reading Team spawns..")
        for k,enttable in ipairs(ENTDATA.spawns) do
            local spawn = ents.Create("zeta_teamspawnpoint")
            spawn:SetPos(enttable.pos)
            spawn.teamspawn = enttable.teamspawn
            spawn:SetNW2String("zetateamspawn_team",enttable.teamspawn)
            spawn:Spawn()

            if !Currentteams[spawn.teamspawn] then
                Currentteams[spawn.teamspawn] = spawn.teamspawn
            end
            

            local spawnindex = spawn:GetCreationID()

            undo.Create("Zeta Team Spawn {"..enttable.teamspawn.." "..spawnindex.."}")
                undo.SetPlayer(Entity(1))
                undo.AddEntity(spawn)
            undo.Finish("Zeta Team Spawn {"..enttable.teamspawn.." "..spawnindex.."}")

            Entity(1):AddCleanup( "sents", spawn )

        end

        print("Reading KOTH Points..")
        for k,enttable in ipairs(ENTDATA.kothpoints) do
            local kothmarker = ents.Create("zeta_koth")
            kothmarker:SetPos(enttable.pos)
            kothmarker.Overridename = enttable.name
            kothmarker:Spawn()

            undo.Create("Zeta KOTH Marker "..enttable.name)
                undo.SetPlayer(Entity(1))
                undo.AddEntity(kothmarker)
            undo.Finish("Zeta KOTH Marker "..enttable.name)

            Entity(1):AddCleanup( "sents", kothmarker )

        end

        print("Reading CTF Flags..")
        for k,enttable in ipairs(ENTDATA.flags) do
            local flag = ents.Create("zeta_flag")
            flag:SetPos(enttable.pos)
            flag.customname = enttable.name
            flag.teamowner = enttable.zetateam
            flag.CanBePickedUp = enttable.canpickup
            flag:Spawn()

            undo.Create("Zeta CTF Flag "..enttable.name)
                undo.SetPlayer(Entity(1))
                undo.AddEntity(flag)
            undo.Finish("Zeta CTF Flag "..enttable.name)

            Entity(1):AddCleanup( "sents", flag )

        end

        PrintMessage(HUD_PRINTTALK,"This save contains the following Teams:")
        for k,v in pairs(Currentteams) do
            PrintMessage(HUD_PRINTTALK,v)
        end


        print("Finished creating team ents!")
    end


elseif CLIENT then
    


    function OpenTeamRegisterPanel(caller)
        local teams = {}
        local starttime = CurTime()
        net.Start("zetapanel_getteams")
        net.SendToServer()

        net.Receive('zetapanel_sendteams',function()
            local team_ = net.ReadString()
            local isdone = net.ReadBool()

            if team_ != "PLACEHOLDER" then
                table.insert(teams,util.JSONToTable(team_))
            end

            if isdone then -- Make the panel

                notification.AddLegacy("Received all Teams! Took "..CurTime()-starttime.." seconds",NOTIFY_CLEANUP,4)

                local frame = vgui.Create( 'DFrame' )
                frame:SetDeleteOnClose( true )
                frame:CenterHorizontal(0.3)
                frame:CenterVertical(0.4)
                frame:SetTitle('Zeta Team Panel')
                frame:SetIcon( 'icon/physgun.png' )
                frame:SetSize(700,400)
                frame:MakePopup()

                local label = vgui.Create( 'DLabel', frame )
                local teamadd = (GetConVar("zetaplayer_playerteam"):GetString() != "" and "Your current team is "..GetConVar("zetaplayer_playerteam"):GetString() or "You currently aren't in a team")
                label:SetText("Welcome to the Team Panel! "..teamadd.."\n\nRight click a team row to remove it\n\nDouble Click a row to load it.\nAfter loading a team, you can press the 'Set as your team' button to set your team\n\nCreate a team to the right and press Submit Team when you're done")
                label:SetSize(500,500)
                label:SetPos(0,-170)
                

                local panellist = vgui.Create( 'DListView', frame )

                panellist:DockMargin(0,160,0,0)
                panellist:Dock(LEFT)
                panellist:SetSize(400,300)
                panellist:AddColumn('Teams',1)

                for k,v in ipairs(teams) do

                    local line = panellist:AddLine(v[1])
                    line:SetSortValue( 1, v )

                end

                local teamcolor = vgui.Create("DColorMixer",frame)
                teamcolor:SetPos(410,200)
                teamcolor:SetSize(200,200)

                local model = vgui.Create("DTextEntry",frame)
                model:SetPos(410,130)
                model:SetSize(200,20)

                local namelabel = vgui.Create( 'DLabel', frame )
                namelabel:SetText("Team Model")
                namelabel:SetPos(410,110)
                namelabel:SetSize(300,20)

                namelabel = vgui.Create( 'DLabel', frame )
                namelabel:SetText("Team Name {Required}")
                namelabel:SetPos(410,30)
                namelabel:SetSize(300,20)

                namelabel = vgui.Create( 'DLabel', frame )
                namelabel:SetText("Team Color {Required}")
                namelabel:SetPos(410,180)
                namelabel:SetSize(300,20)

                local teamname = vgui.Create("DTextEntry",frame)
                teamname:SetPos(410,49)
                teamname:SetSize(200,20)

                local submit = vgui.Create("DButton",frame)
                submit:SetPos(610,350)
                submit:SetSize(90,50)
                submit:SetText("Submit Team")

                local setteam = vgui.Create("DButton",frame)
                setteam:SetPos(610,69)
                setteam:SetSize(90,30)
                setteam:SetText("Set as your Team")

                local leaveteam = vgui.Create("DButton",frame)
                leaveteam:SetPos(610,99)
                leaveteam:SetSize(90,30)
                leaveteam:SetText("Leave Team")

                local function CompileTeamData()
                    local tname = teamname:GetText()
                    local mdl = model:GetText()
                    local clr = teamcolor:GetVector()

                    if tname == "" then
                        notification.AddLegacy("Please insert a team name!",NOTIFY_ERROR,4)
                        LocalPlayer():EmitSound('buttons/button10.wav')
                        return false
                    end

                    teamname:SetText("")
                    model:SetText("")
                    if mdl == "" then mdl = nil end

                    return {tname,clr,teammodel = mdl}
                end

                function panellist:DoDoubleClick(id,line)
                    local data = line:GetSortValue(1)
                    teamname:SetText(data[1])

                    if data.teammodel then
                        model:SetText(data.teammodel)
                    end

                    if data[2] then
                        teamcolor:SetColor(data[2]:ToColor())
                    end
                    LocalPlayer():EmitSound('buttons/button15.wav')
                end

                function panellist:OnRowRightClick(id,line)
                    net.Start("zetapanel_removeteam")
                    net.WriteString(util.TableToJSON(line:GetSortValue(1)))
                    net.SendToServer()

                    panellist:RemoveLine(id)
                    panellist:SetDirty(true)
                end

                function submit:DoClick()
                    local data = CompileTeamData()
                    if !data then return end
                    LocalPlayer():EmitSound('buttons/button15.wav')

                    local line = panellist:AddLine(data[1])
                    line:SetSortValue( 1, data )

                    net.Start("zetapanel_addteam")
                    net.WriteString(util.TableToJSON(data))
                    net.SendToServer()
                end

                function setteam:DoClick()
                    local data = CompileTeamData()
                    if !data then return end
                    LocalPlayer():EmitSound('buttons/button15.wav')

                    net.Start("zetapanel_setteam")
                    net.WriteString(data[1])
                    net.SendToServer()
                    timer.Simple(0,function()
                        local teamadd = (GetConVar("zetaplayer_playerteam"):GetString() != "" and "Your current team is "..GetConVar("zetaplayer_playerteam"):GetString() or "You currently aren't in a team")
                        label:SetText("Welcome to the Team Panel! "..teamadd.."\n\nRight click a team row to remove it\n\nDouble Click a row to load it.\nAfter loading a team, you can press the 'Set as your team' button to set your team\n\nCreate a team to the right and press Submit Team when you're done")

                    end)
                end

                function leaveteam:DoClick()
                    LocalPlayer():EmitSound('buttons/button15.wav')

                    net.Start("zetapanel_setteam")
                    net.WriteString("")
                    net.SendToServer()
                    timer.Simple(0,function()
                        local teamadd = (GetConVar("zetaplayer_playerteam"):GetString() != "" and "Your current team is "..GetConVar("zetaplayer_playerteam"):GetString() or "You currently aren't in a team")
                        label:SetText("Welcome to the Team Panel! "..teamadd.."\n\nRight click a team row to remove it\n\nDouble Click a row to load it.\nAfter loading a team, you can press the 'Set as your team' button to set your team\n\nCreate a team to the right and press Submit Team when you're done")

                    end)
                end


            end

        end) -- End Net message


    end




    concommand.Add('zetaplayer_openteampanel',OpenTeamRegisterPanel,nil,'Opens the Team Register Panel')

end