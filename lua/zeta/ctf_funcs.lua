AddCSLuaFile()



if SERVER then
    util.AddNetworkString("zetactf_begingame")
    util.AddNetworkString("zetactf_incrementteamscore")
    util.AddNetworkString("zetactf_endgame")


    SetGlobalBool("_ZetaCTF_Gameactive", false )

    local trackedteams = {}

    local color_glacier = Color(130, 164, 192)

    hook.Add("ZetaCTFOnCapture","TrackCaptureCounts",function(flagteam,capturingteam)
        if !trackedteams[capturingteam] then
            trackedteams[capturingteam] = 1
        else
            trackedteams[capturingteam] = trackedteams[capturingteam] + 1
        end
        net.Start("zetactf_incrementteamscore")
        net.WriteString(capturingteam)
        net.Broadcast()

        if trackedteams[capturingteam] == GetConVar("zetaplayer_ctfcapturelimit"):GetInt() then
            timer.Remove("_zetaCtfTimerCountdown")
            _ZetaFinishGame()
        end
    end)

    function _ZetaGetCTFWinner()
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

    function _ZetaFinishGame(timelimitreached)
        if !GetGlobalBool("_ZetaCTF_Gameactive", false ) then return end
        SetGlobalBool("_ZetaCTF_Gameactive", false )
        local winningteam,score = _ZetaGetCTFWinner()
        local col = ZetaGetTeamColor(winningteam)
        local teamcolor = col and col:ToColor() or color_white


        net.Start("zetactf_endgame")
        net.Broadcast()

        if winningteam then
            local points = (score > 1 and " points" or " point")

            if timelimitreached then
                SendChatMessage(color_white,"[CTF]",color_glacier," Time limit reached! ",teamcolor,winningteam,color_glacier," won with ",color_white,tostring(score),points)
            else
                SendChatMessage(color_white,"[CTF]",teamcolor,winningteam,color_glacier," finished the final capture! They won with ",color_white,tostring(score),points)
            end

            

            if GetConVar("zetaplayer_playerteam"):GetString() != "" and GetConVar("zetaplayer_playerteam"):GetString() != winningteam then
                if GetConVar("zetaplayer_ctflosssound"):GetString() != "" then
                    sound.Play(GetSound(GetConVar("zetaplayer_ctflosssound"):GetString()),Vector(0,0,0),0,100,1)
                end
            else
                if GetConVar("zetaplayer_ctfvictorysound"):GetString() != "" then
                    sound.Play(GetSound(GetConVar("zetaplayer_ctfvictorysound"):GetString()),Vector(0,0,0),0,100,1)
                end
            end

            for k,v in pairs(trackedteams) do
                if k == winningteam then continue end
                local col = ZetaGetTeamColor(k)

                local teamcolor = col and col:ToColor() or color_white

                local points = (v > 1 and " points" or " point")

                SendChatMessage(color_glacier,"[",teamcolor,k,color_glacier,"]"," ended with a total of ",tostring(v),points)
            end

            local flags = ents.FindByClass("zeta_flag")

            for k,v in ipairs(flags) do
                v:ReturnToZone()
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

    function _ZetaEndCTFGame()
        timer.Remove("_zetaCtfTimerCountdown")
        _ZetaFinishGame()
    end


    local function Sendteamstoclient()
        local teams = {}

        for k,v in ipairs(ents.FindByClass("zeta_flag")) do
            if v.teamowner then
                teams[#teams+1] = {v.teamowner,v.TeamColor}
            end
        end
        local index = 1
        for k,v in ipairs(teams) do
            net.Start("zetactf_begingame")
                net.WriteString(v[1])
                net.WriteColor(v[2])
                net.WriteBool(k == #teams)
                net.WriteInt(index,15)
            net.Broadcast()
            index = index + 1
        end
    end

    
    function _ZetaCTFStartGame()
        if !GetConVar("zetaplayer_useteamsystem"):GetBool() then PrintMessage(HUD_PRINTTALK,"You must have Team System enabled!") return end
        if _ZetaIsMinigameActive() then return end
        if #ents.FindByClass("zeta_flag") < 1 then PrintMessage(HUD_PRINTTALK,"You need atleast 2 flags. Place one for each team you want to play with") return end
        local time = GetConVar("zetaplayer_ctfmodetime"):GetInt()
        local curtime = time
        SetGlobalInt("_ZetaKOTH_time",time)

        SetGlobalBool("_ZetaCTF_Gameactive", true )

        trackedteams = {}


        Sendteamstoclient()
        
        for k,v in ipairs(GetPlayerZetas()) do
            SetEntityToSpawn(v)

            timer.Simple(math.Rand(0.5,2),function()
                if !IsValid(v) or v:IsPlayer() then return end
                v:PlayTauntSound()
            end)
        end

        local flags = ents.FindByClass("zeta_flag")

        for k,v in ipairs(flags) do
            v:ReturnToZone()
        end

        if GetConVar("zetaplayer_ctfgamestartsound"):GetString() != "" then
            sound.Play(GetSound(GetConVar("zetaplayer_ctfgamestartsound"):GetString()) ,Vector(0,0,0),0,100,1)
        end

        timer.Create("_zetaCtfTimerCountdown",1,time,function()
            curtime = curtime - 1
            SetGlobalInt("_ZetaKOTH_time",curtime)

            if curtime == 10 and GetConVar("zetaplayer_ctf10secondssound"):GetString() != "" then
                sound.Play(GetSound(GetConVar("zetaplayer_ctf10secondssound"):GetString()),Vector(0,0,0),0,100,1)
            elseif curtime == 30 and GetConVar("zetaplayer_ctf30secondssound"):GetString() != ""  then
                sound.Play(GetSound(GetConVar("zetaplayer_ctf30secondssound"):GetString()),Vector(0,0,0),0,100,1)
            end



            if curtime == 0 then
                _ZetaFinishGame(true)
            end
        end)
    end

    concommand.Add("zetaplayer_beginctfgame",_ZetaCTFStartGame)
    concommand.Add("zetaplayer_endctfgame",_ZetaEndCTFGame)

elseif CLIENT then

    local teamscores = {}

    net.Receive("zetactf_begingame",function()
        local teamname = net.ReadString()
        local teamcolor = net.ReadColor()
        local isdone = net.ReadBool()
        local index = net.ReadInt(15)
        teamscores[teamname] = {0,teamcolor,index}

        
        if isdone then
            hook.Add("HUDPaint","ZetaCtfHUD",function()

                draw.SimpleTextOutlined("Playing to "..GetConVar("zetaplayer_ctfcapturelimit"):GetInt().." captures","ChatFont",ScrW()/50,ScrH()/2.5,color_white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,color_black)
                
                for k,v in pairs(teamscores) do
                    local w = ScrW()/50
                    local h = (ScrH()/2)-v[3]*20
                    draw.SimpleTextOutlined(k.." Score: "..v[1],"ChatFont",w,h,v[2],TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,color_black)
                end
            
            end)
        end
    end)

    net.Receive("zetactf_incrementteamscore",function()
        local teamname = net.ReadString()
        if !teamscores[teamname] then return end
        teamscores[teamname][1] = teamscores[teamname][1] + 1
    end)

    net.Receive("zetactf_endgame",function()
        table.Empty(teamscores)
        hook.Remove("HUDPaint","ZetaCtfHUD")
    end)

end