AddCSLuaFile()



if SERVER then
    util.AddNetworkString("zetatdm_begingame")
    util.AddNetworkString("zetatdm_incrementteamscore")
    util.AddNetworkString("zetatdm_endgame")

    SetGlobalBool("_ZetaTDM_Gameactive", false )

    local trackedteams = {}

    local color_glacier = Color(130, 164, 192)

    local kills10sound

    function _ZetaGetTDMWinner()
        local winningteam 
        local highestvalue 

        for k,v in pairs(trackedteams) do
            if !highestvalue then highestvalue = v winningteam = k continue end

            if v > highestvalue then
                highestvalue = v
                winningteam = k
            elseif v == highestvalue and math.random(1,2) then
                highestvalue = v
                winningteam = k                
            end
        end

        return winningteam,highestvalue
    end

    local function SendChatMessage(...)
        net.Start("zeta_sendcoloredtext", true)
            net.WriteString(util.TableToJSON({...}))
        net.Broadcast()
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

    local function SetEntityToSpawn(ent)
        local spawns = ents.FindByClass("zeta_teamspawnpoint")

        local entteam = ent.IsZetaPlayer and ent.zetaTeam or GetConVar("zetaplayer_playerteam"):GetString() != "" and GetConVar("zetaplayer_playerteam"):GetString() or nil

        if ent.IsZetaPlayer then
            ent:CancelMove()
            ent:SetEnemy(NULL)
            ent:SetState("idle")
            ent:ExitVehicle()
        end
        if entteam then
            for k,v in RandomPairs(spawns) do
                if v:GetTeamSpawn() == entteam then
                    ent:SetPos(v:GetPos())
                    if IsValid(ent.Spawner) then
                        ent.Spawner:SetPos(v:GetPos())
                    end
                    break
                end
            end
        elseif ent.IsZetaPlayer then
            ent:SetPos(v.SpawnPos)
        end
        
    end

    local function GetTeams()
        local teams = {}
        for k,v in ipairs(ents.FindByClass("zeta_teamspawnpoint")) do
            if IsValid(v) and !teams[v.teamspawn] then
                teams[v.teamspawn] = 0
            end
        end
        return teams
    end

    local function Sendteamstoclient()
        local teams = {}
        for k,v in ipairs(ents.FindByClass("zeta_teamspawnpoint")) do
            if IsValid(v) and !table.HasValue(teams,v.teamspawn) then
                teams[#teams+1] = v.teamspawn
            end
        end
        
        local index = 1
        for k,v in ipairs(teams) do
            local teamcolorvec = ZetaGetTeamColor(v)
            local teamcolor = teamcolorvec and teamcolorvec:ToColor() or color_white
            net.Start("zetatdm_begingame")
                net.WriteString(v)
                net.WriteColor(teamcolor)
                net.WriteBool(k == #teams)
                net.WriteInt(index,15)
            net.Broadcast()
            index = index + 1
        end
    end

    function _ZetaTDMFinishGame(timelimitreached)
        if !GetGlobalBool("_ZetaTDM_Gameactive", false ) then return end
        SetGlobalBool("_ZetaTDM_Gameactive", false )
        local winningteam,score = _ZetaGetTDMWinner()
        local col = ZetaGetTeamColor(winningteam)
        local teamcolor = col and col:ToColor() or color_white

        hook.Remove("PostEntityTakeDamage","zetatdmkillhook")
        timer.Remove("_zetaTDMTimerCountdown")

        if IsValid(kills10sound) then
            kills10sound:Stop()
        end

        net.Start("zetatdm_endgame")
        net.Broadcast()

        if winningteam then
            local points = (score > 1 and " kills" or " kill")

            if timelimitreached then
                SendChatMessage(color_white,"[TDM]",color_glacier," Time limit reached! ",teamcolor,winningteam,color_glacier," won with ",color_white,tostring(score),points)
            else
                SendChatMessage(color_white,"[TDM]",teamcolor,winningteam,color_glacier," scored the final kill! They won with ",color_white,tostring(score),points)
            end

            

            if GetConVar("zetaplayer_playerteam"):GetString() != "" and GetConVar("zetaplayer_playerteam"):GetString() != winningteam then
                if GetConVar("zetaplayer_tdmlosssound"):GetString() != "" then
                    sound.Play(GetSound(GetConVar("zetaplayer_tdmlosssound"):GetString()),Vector(0,0,0),0,100,1)
                end
            else
                if GetConVar("zetaplayer_tdmvictorysound"):GetString() != "" then
                    sound.Play(GetSound(GetConVar("zetaplayer_tdmvictorysound"):GetString()),Vector(0,0,0),0,100,1)
                end
            end

            for k,v in pairs(trackedteams) do
                if k == winningteam then continue end
                local col = ZetaGetTeamColor(k)

                local teamcolor = col and col:ToColor() or color_white

                local points = (v > 1 and " kills" or " kill")

                SendChatMessage(color_glacier,"[",teamcolor,k,color_glacier,"]"," ended with a total of ",tostring(v),points)
            end

            for k,v in ipairs(GetPlayerZetas()) do
                SetEntityToSpawn(v)
                if v.IsZetaPlayer and v.zetaTeam == winningteam then
                    timer.Simple(math.Rand(0.5,2),function()
                        if !IsValid(v) then return end
                        v:PlayKillSound()
                    end)
                elseif v.IsZetaPlayer then
                    timer.Simple(math.Rand(0.5,2),function()
                        if !IsValid(v) then return end
                        v:PlayDeathSound()
                    end)
                end
            end
        end

    end

    function _ZetaTDMEndGame()
        hook.Remove("PostEntityTakeDamage","zetatdmkillhook")
        timer.Remove("_zetaTDMTimerCountdown")
        _ZetaTDMFinishGame()
    end

    function _ZetaTDMStartGame()
        if !GetConVar("zetaplayer_useteamsystem"):GetBool() then PrintMessage(HUD_PRINTTALK,"You must have Team System enabled!") return end
        if _ZetaIsMinigameActive() then return end
        if table.Count(GetTeams()) < 1 then PrintMessage(HUD_PRINTTALK,"You need atleast 2 seperate team spawn points. Place one for each team you want to play with") return end
        local time = GetConVar("zetaplayer_tdmmodetime"):GetInt()
        local curtime = time
        SetGlobalInt("_ZetaKOTH_time",time)

        SetGlobalBool("_ZetaTDM_Gameactive", true )

        trackedteams = GetTeams()

        local killlimit = GetConVar("zetaplayer_tdmkilllimit"):GetInt()


        Sendteamstoclient()
        
        for k,v in ipairs(GetPlayerZetas()) do
            SetEntityToSpawn(v)

            timer.Simple(math.Rand(0.5,2),function()
                if !IsValid(v) or v:IsPlayer() then return end
                v:PlayTauntSound()
            end)
        end


        hook.Add("PostEntityTakeDamage","zetatdmkillhook",function(ent,dmginfo)
            if ( !ent.IsZetaPlayer and !ent:IsPlayer() ) then return end

            local attacker = dmginfo:GetAttacker()

            if ( !attacker.IsZetaPlayer and !attacker:IsPlayer() ) then return end


            local IsvictimDead = ent:Health() <= 0 

            if ( IsvictimDead ) then

                local attackerteam = attacker.IsZetaPlayer and attacker.zetaTeam or GetConVar("zetaplayer_playerteam"):GetString() != "" and GetConVar("zetaplayer_playerteam"):GetString() or nil

                if attacker and attackerteam then

                    net.Start("zetatdm_incrementteamscore")
                    net.WriteString(attackerteam)
                    net.Broadcast()


                    trackedteams[attackerteam] = trackedteams[attackerteam]+1

                    if trackedteams[attackerteam] == killlimit-10 then
                        local col = ZetaGetTeamColor(attackerteam)

                        local teamcolor = col and col:ToColor() or color_white

                        SendChatMessage(color_white,"[TDM]",teamcolor,attackerteam,color_glacier," needs 10 more kills to win!")

                        if GetConVar("zetaplayer_tdm10killsremain"):GetString() != "" then
                            if IsValid(kills10sound) then
                                kills10sound:Stop()
                            end
                            
                            kills10sound = CreateSound( Entity(0), GetSound(GetConVar("zetaplayer_tdm10killsremain"):GetString()) )
                            kills10sound:SetSoundLevel(0)
                            kills10sound:Play()
                            

                        end

                    elseif trackedteams[attackerteam] >= killlimit then

                        _ZetaTDMFinishGame()

                    end

                end
                

            end
        end)


        if GetConVar("zetaplayer_tdmgamestartsound"):GetString() != "" then
            sound.Play(GetSound(GetConVar("zetaplayer_tdmgamestartsound"):GetString()) ,Vector(0,0,0),0,100,1)
        end

        timer.Create("_zetaTDMTimerCountdown",1,time,function()
            curtime = curtime - 1
            SetGlobalInt("_ZetaKOTH_time",curtime)

            if curtime == 10 and GetConVar("zetaplayer_tdm10secondssound"):GetString() != "" then
                sound.Play(GetSound(GetConVar("zetaplayer_tdm10secondssound"):GetString()),Vector(0,0,0),0,100,1)
            elseif curtime == 30 and GetConVar("zetaplayer_tdm30secondssound"):GetString() != ""  then
                sound.Play(GetSound(GetConVar("zetaplayer_tdm30secondssound"):GetString()),Vector(0,0,0),0,100,1)
            end



            if curtime == 0 then
                _ZetaTDMFinishGame(true)
            end
        end)
    end

    concommand.Add("zetaplayer_begintdmgame",_ZetaTDMStartGame)
    concommand.Add("zetaplayer_endtdmgame",_ZetaTDMEndGame)

elseif CLIENT then

    local teamscores = {}

    net.Receive("zetatdm_begingame",function()
        local teamname = net.ReadString()
        local teamcolor = net.ReadColor()
        local isdone = net.ReadBool()
        local index = net.ReadInt(15)
        teamscores[teamname] = {0,teamcolor,index}

        
        if isdone then
            hook.Add("HUDPaint","ZetaTDMHUD",function()

                draw.SimpleTextOutlined("Playing to "..GetConVar("zetaplayer_tdmkilllimit"):GetInt().." kills","ChatFont",ScrW()/50,ScrH()/2.5,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,color_black)
                
                for k,v in pairs(teamscores) do
                    local w = ScrW()/50
                    local h = (ScrH()/2)-v[3]*20
                    draw.SimpleTextOutlined(k.." Score: "..v[1],"ChatFont",w,h,v[2],TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,color_black)
                end
            
            end)
        end
    end)

    net.Receive("zetatdm_incrementteamscore",function()
        local teamname = net.ReadString()
        if !teamscores[teamname] then return end
        teamscores[teamname][1] = teamscores[teamname][1] + 1
    end)

    net.Receive("zetatdm_endgame",function()
        table.Empty(teamscores)
        hook.Remove("HUDPaint","ZetaTDMHUD")
    end)

end