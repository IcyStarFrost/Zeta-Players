AddCSLuaFile()

if ( CLIENT ) then return end

_ZetaCurrentVote = "NIL"
_ZetaCurrentVotedOptions = {}
local zetavote_quickindex = {}

local color_glacier = Color(130, 164, 192)
local color_green = Color(0, 255, 0)

hook.Add("PlayerSay", "zetaplayerPlayerSay_votehook", function(ply, text)
    local explode = string.Explode(" ", text)
    if explode[1] == ",startvote" then
        local title, options = ZetaPlayer_CompileVoteOptions(ply, text)
        if title == "failed" then return "" end
        ZetaPlayer_CreateVote(ply, title, options)
        return ""
    elseif explode[1] == ",vote" then
        ZetaPlayer_DispatchVote(ply, string.Replace(text, ",vote ", ""))
        return ""
    end 
end)

function ZetaPlayer_CompileVoteOptions(ply,text)
    local explode = string.Explode('"', text)
    if !explode[3] then
        if IsValid(ply) and ply:IsPlayer() then
            ply:PrintMessage(HUD_PRINTTALK, "Vote options are missing!") 
        end
        return "failed"
    end 
    if !explode[2] then
        if IsValid(ply) and ply:IsPlayer() then
            ply:PrintMessage(HUD_PRINTTALK, "Vote Title is missing!") 
        end
        return "failed"
    end 

    local title = explode[2]
    local args = string.TrimLeft(explode[3], " ")
    local options = string.Explode(" ", args)
    return title, options
end

function ZetaPlayer_Translateindex(int) -- Should support normal strings by returning it
    local translatedvalue = int
    local convertedval = tonumber(int)


    -- Adding a compare between the quick indexes and the value seemed to fix the issue with number options erroring
    if isnumber(convertedval) and convertedval <= #zetavote_quickindex then 
        translatedvalue = zetavote_quickindex[convertedval]
    end
    return translatedvalue
end

function ZetaPlayer_DispatchVote(ply,option)
    option = ZetaPlayer_Translateindex(option)

    if _ZetaCurrentVote == "NIL" then
        if ply:IsPlayer() then ply:PrintMessage(HUD_PRINTTALK, "There is no active vote at the moment") end 
        return
    end

    if !_ZetaCurrentVotedOptions[option] then
        if ply:IsPlayer() then ply:PrintMessage(HUD_PRINTTALK, option.." isn't a option in the current vote") end 
        return
    end

    -- Now onto the real code --

    _ZetaCurrentVotedOptions[option] = _ZetaCurrentVotedOptions[option] + 1

    local r, g, b
    if ply:IsPlayer() then
        local teamColor = team.GetColor(ply:Team())
        r, g, b = teamColor.r, teamColor.g, teamColor.b
    elseif ply.IsZetaPlayer then
        r, g, b = ply:GetColorByRank()
    end

    net.Start("zeta_sendcoloredtext", true)
        net.WriteString(util.TableToJSON({Color(r, g, b), ply:Name(), color_glacier, " voted for ", color_glacier, "(",color_green,option,color_glacier,")"}))
    net.Broadcast()
end

function ZetaPlayer_CompileVoteResults()
    local highestname, highestvalue 
    for k, v in pairs(_ZetaCurrentVotedOptions) do
        if !highestname and !highestvalue then highestvalue = v highestname = k continue end
        if v > highestvalue then
            highestvalue = v
            highestname = k
        elseif v == highestvalue and math.random(2) == 1 then
            highestvalue = v
            highestname = k
        end
    end
    return highestname, highestvalue
end

function ZetaPlayer_CreateVote(ply,title,options)
    if _ZetaCurrentVote != "NIL" then
        if ply:IsPlayer() then ply:PrintMessage(HUD_PRINTTALK, "There is already a vote active!") end 
        return
    end
    if #options < 2 then 
        if ply:IsPlayer() then ply:PrintMessage(HUD_PRINTTALK, "You must have more than one option!") end 
        return 
    elseif #options > 10 then
        if ply:IsPlayer() then ply:PrintMessage(HUD_PRINTTALK, "Exceeded max option limit! (10)") end 
        return 
    end

    table.Empty(_ZetaCurrentVotedOptions)
    table.Empty(zetavote_quickindex)
    _ZetaCurrentVote = title
    hook.Run("OnZetaVoteDispatched",ply,title,options)

    local r, g, b 
    if ply:IsPlayer() then
        local teamColor = team.GetColor(ply:Team())
        r, g, b = teamColor.r, teamColor.g, teamColor.b
    elseif ply.IsZetaPlayer then
        r, g, b = ply:GetColorByRank()
    end

    net.Start("zeta_sendcoloredtext", true)
        net.WriteString(util.TableToJSON({Color(r, g, b), ply:Name(), color_glacier, " started a vote ", color_white, "(",color_green,title,color_white,")"}))
    net.Broadcast()

    for i = 1, #options do
        _ZetaCurrentVotedOptions[options[i]] = 0
        net.Start("zeta_sendcoloredtext", true)
            net.WriteString(util.TableToJSON({color_glacier, "[Option"..i.."] ", color_green, options[i]}))
        net.Broadcast()
        zetavote_quickindex[i] = options[i]
    end

    timer.Simple(10, function()
        local wonOption, value = ZetaPlayer_CompileVoteResults()
        _ZetaCurrentVote = "NIL"

        local addPlural = (value > 0 and 's' or '')
        net.Start("zeta_sendcoloredtext", true)
            net.WriteString(util.TableToJSON({color_glacier, "(", color_green, title, color_glacier, ") vote results: ", color_green, wonOption, color_glacier, " won with ", color_green, tostring(value), color_glacier, " vote"..addPlural}))
        net.Broadcast()
    end)
end