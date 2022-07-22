AddCSLuaFile()




if SERVER then
    SetGlobalBool("_ZetaKOTH_Gameactive", false )

    function _ZetaGetKothWinner()
        local markers = ents.FindByClass("zeta_koth")
        local highestscore
        local winningteam

        local teamscores = {}

        for k,v in ipairs(markers) do
            for teamkey,score in pairs(v.TeamScores) do
                if !teamscores[teamkey] then 
                    teamscores[teamkey] = score
                else
                    teamscores[teamkey] = teamscores[teamkey] + score
                end
            end
        end

        for k,v in pairs(teamscores) do
            if !highestscore then winningteam = k highestscore = v continue end

            if v > highestscore then
                highestscore = v
                winningteam = k
            elseif v == highestscore then
                highestscore = v
                winningteam = k
            end
        end

        return winningteam,highestscore,teamscores
    end

    local function SendChatMessage(...)
        net.Start("zeta_sendcoloredtext", true)
            net.WriteString(util.TableToJSON({...}))
        net.Broadcast()
    end


    local color_glacier = Color(130, 164, 192)


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
                    break
                end
            end
        elseif ent.IsZetaPlayer then
            ent:SetPos(v.SpawnPos)
        end
        
    end


    function GetPlayerZetas()
        local members = {}
    
        for k,v in ipairs(ents.GetAll()) do
            if v.IsZetaPlayer or v:IsPlayer() then
                table.insert(members,v)
            end
        end
    
        return members
    end

    local function GetSound(dir) 
        local mp3check = string.EndsWith(dir,".mp3")
        local wavcheck = string.EndsWith(dir,".wav")

        if mp3check or wavcheck then
            return dir
        end

        local files,dirs = file.Find("sound/"..dir,"GAME")
        local replace = string.Replace((dir..files[math.random(#files)]),"*","")
        return replace
    end


    function _ZetaEndKOTHGame()
        if timer.Exists("_zetaKothTimerCountdown") then
            timer.Adjust("_zetaKothTimerCountdown",0)
        end
    end

    function _ZetaKothStartGame()
        if GetGlobalBool("_ZetaKOTH_Gameactive") then return end
        local time = GetConVar("zetaplayer_kothmodetime"):GetInt()
        local curtime = time
        SetGlobalInt("_ZetaKOTH_time",time)

        SetGlobalBool("_ZetaKOTH_Gameactive", true )

        
        for k,v in ipairs(GetPlayerZetas()) do
            SetEntityToSpawn(v)

            timer.Simple(math.Rand(0.5,2),function()
                if !IsValid(v) or v:IsPlayer() then return end
                v:PlayTauntSound()
            end)
        end

        local markers = ents.FindByClass("zeta_koth")

        for k,v in ipairs(markers) do
            v:RestoretoNeutral()
        end

        if GetConVar("zetaplayer_kothgamestart"):GetString() != "" then
            sound.Play(GetSound(GetConVar("zetaplayer_kothgamestart"):GetString()) ,Vector(0,0,0),0,100,1)
        end

        timer.Create("_zetaKothTimerCountdown",1,time,function()
            curtime = curtime - 1
            SetGlobalInt("_ZetaKOTH_time",curtime)

            if curtime == 10 and GetConVar("zetaplayer_10secondcountdownsound"):GetString() != "" then
                sound.Play(GetSound(GetConVar("zetaplayer_10secondcountdownsound"):GetString()),Vector(0,0,0),0,100,1)
            end

            if curtime == 0 then
                SetGlobalBool("_ZetaKOTH_Gameactive", false )
                local winningteam,score,allteamscores = _ZetaGetKothWinner()
                local col = ZetaGetTeamColor(winningteam)
                local teamcolor = col and col:ToColor() or color_white

                
                if winningteam then
                    local points = (score > 1 and " points" or " point")
                    SendChatMessage(color_white,"[KOTH]",color_glacier," Time limit reached! ",teamcolor,winningteam,color_glacier," won with ",color_white,score,points)
                    

                    if GetConVar("zetaplayer_playerteam"):GetString() != "" and GetConVar("zetaplayer_playerteam"):GetString() != winningteam then
                        if GetConVar("zetaplayer_kothgameover"):GetString() != "" then
                            sound.Play(GetSound(GetConVar("zetaplayer_kothgameover"):GetString()),Vector(0,0,0),0,100,1)
                        end
                    else
                        if GetConVar("zetaplayer_kothvictory"):GetString() != "" then
                            sound.Play(GetSound(GetConVar("zetaplayer_kothvictory"):GetString()),Vector(0,0,0),0,100,1)
                        end
                    end

                    for k,v in pairs(allteamscores) do
                        if k == winningteam then continue end
                        local col = ZetaGetTeamColor(k)

                        local teamcolor = col and col:ToColor() or color_white

                        local points = (v > 1 and " points" or " point")

                        SendChatMessage(color_glacier,"[",teamcolor,k,color_glacier,"]"," ended with a total of ",v,points)
                    end

                    local markers = ents.FindByClass("zeta_koth")

                    for k,v in ipairs(markers) do
                        v:RestoretoNeutral()
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
         end)


    end


    concommand.Add("zetaplayer_beginkothgame", _ZetaKothStartGame)
    concommand.Add("zetaplayer_endkothgame", _ZetaEndKOTHGame)
    

elseif CLIENT then




end