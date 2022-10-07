
-- MWS

local function GetPossibleSpawns()
    local info_player_starts = ents.FindByClass('info_player_start')
    local info_player_teamspawns = ents.FindByClass("info_player_teamspawn")
    local info_player_terrorist = ents.FindByClass("info_player_terrorist")
    local info_player_counterterrorist = ents.FindByClass("info_player_counterterrorist")
    local info_player_combine = ents.FindByClass("info_player_combine")
    local info_player_rebel = ents.FindByClass("info_player_rebel")
    local info_player_allies = ents.FindByClass("info_player_allies")
    local info_player_axis = ents.FindByClass("info_player_axis")
    local info_coop_spawn = ents.FindByClass("info_coop_spawn")
    local info_survivor_position = ents.FindByClass("info_survivor_position")
    table.Add(info_player_starts,info_player_teamspawns)
    table.Add(info_player_starts,info_player_terrorist)
    table.Add(info_player_starts,info_player_counterterrorist)
    table.Add(info_player_starts,info_player_combine)
    table.Add(info_player_starts,info_player_rebel)
    table.Add(info_player_starts,info_player_allies)
    table.Add(info_player_starts,info_player_axis)
    table.Add(info_player_starts,info_coop_spawn)
    table.Add(info_player_starts,info_survivor_position)
    return info_player_starts
end

function GetMWSRateAndAmount()
    local rate = GetConVar("zetaplayer_naturalspawnrate"):GetFloat()
    local maxamount = GetConVar('zetaplayer_mapwidespawningzetaamount'):GetInt()
    local amount = maxamount


    if GetConVar("zetaplayer_timebasedmws"):GetBool() then
        local time =  os.date( "%I %p" ) -- Hour | am or pm
        local split = string.Explode(" ",time)
        local hour = tonumber(split[1])
        local pmoram = split[2]

        if pmoram == "AM" then

            if hour == 12 then
                rate = 175
                amount = math.Clamp(3, 1, maxamount)
            elseif hour >= 1 and hour < 4 then
                rate = 175
                amount = math.Clamp(3, 1, maxamount)
            elseif hour >= 4 and hour < 6 then
                rate = 125
                amount = math.Clamp(6, 1, maxamount)
            elseif hour >= 6 and hour < 8 then 
                rate = 75
                amount = math.Clamp(9, 1, maxamount)
            elseif hour >= 8 and hour < 10 then 
                rate = 50
                amount = math.Clamp(12, 1, maxamount)
            elseif hour >= 8 and hour < 10 then 
                rate = 25
                amount = math.Clamp(15, 1, maxamount)
            elseif hour >= 10 and hour < 12 then 
                rate = 15
                amount = maxamount
            end

        elseif pmoram == "PM" then

            if hour == 12 then 
                rate = 15
                amount = maxamount
            elseif hour >= 1 and hour < 6 then 
                rate = 15
                amount = maxamount
            elseif hour >= 6 and hour < 8 then
                rate = 50
                amount = math.Clamp(13, 1, maxamount)
            elseif hour >= 8 and hour < 11 then
                rate = 125
                amount = math.Clamp(7, 1, maxamount)
            elseif hour == 11 then
                rate = 175
                amount = math.Clamp(3, 1, maxamount)
            end

        end
    end
    return rate,amount
end



local areas = navmesh.GetAllNavAreas()
local removezetas = false
local area
local point
naturalzetas = {}

local spawnrate,zetaamount = GetMWSRateAndAmount()

local maxzetacount = zetaamount
local rate = CurTime()
local firstspawndelay = CurTime()+6
local spawns = GetPossibleSpawns()

hook.Add("Think","zetamapwidespawn",function()

    local spawnrate,maxzetacount = GetMWSRateAndAmount()

    if GetConVar('zetaplayer_mapwidespawning'):GetInt() == 0 then
        rate = 0
    end

    if CurTime() < firstspawndelay then return end
    if CurTime() < rate then return end
    
    rate = (GetConVar("zetaplayer_mapwidespawningrandom"):GetInt() == 1 or GetConVar("zetaplayer_timebasedmws"):GetBool()) and CurTime()+math.Rand(0.1,spawnrate) or CurTime()+spawnrate
    
    if GetConVar('zetaplayer_mapwidespawning'):GetInt() == 0 then
         if removezetas then 
            removezetas = false  
            for k,v in ipairs(naturalzetas) do
                if v:IsValid() then
                    v:Remove()
                end
            end
            local zetas = ents.FindByClass('npc_zetaplayer')
            for k,v in ipairs(zetas) do
                if v:IsValid() and v.IsNatural then
                    v:Remove()
                end
            end
        end 
        return 
    end

    
    if #naturalzetas > maxzetacount then naturalzetas[math.random(#naturalzetas)]:Remove() return end
    if #naturalzetas >= maxzetacount then return end
    removezetas = true
    if GetConVar('zetaplayer_mapwidespawninguseplayerstart'):GetInt() == 0 then
    area = areas[math.random(#areas)]
    if !area or !area:IsValid() then
        areas = navmesh.GetAllNavAreas()
        area = areas[math.random(#areas)]
    end

    if !area or !area:IsValid() then
        return
    end
    if area:IsUnderwater() then return end
        point = area:GetRandomPoint()
    else
        spawns = GetPossibleSpawns()


        local spawn = spawns[math.random(#spawns)]
        if IsValid(spawn) then
            point = spawn:GetPos()
        else
            print('MAP WIDE SPAWNER WARNING: Player Spawn Is not Valid!')
            return
        end
    end


    if !GetConVar("zetaplayer_mwsspawnrespawningzetas"):GetBool() then
        local zeta = ents.Create('npc_zetaplayer')
        table.insert(naturalzetas,zeta)
        zeta:CallOnRemove('zetacallonremove'..zeta:EntIndex(),function()
            table.RemoveByValue(naturalzetas,zeta)
        end)


        zeta:SetPos(point)
        zeta:SetAngles(Angle(0,math.random(0,360,0),0))
        zeta.IsNatural = true
        zeta.NaturalWeapon = GetConVar("zetaplayer_naturalspawnweapon"):GetString()
        zeta:Spawn()
        zeta:EmitSound(GetConVar("zetaplayer_customspawnsound"):GetString() != "" and GetConVar("zetaplayer_customspawnsound"):GetString() or 'zetaplayer/misc/spawn_zeta.wav',60)
    else
        local zeta = ents.Create('zeta_zetaplayerspawner')
        table.insert(naturalzetas,zeta)
        zeta:CallOnRemove('zetacallonremove'..zeta:EntIndex(),function()
            table.RemoveByValue(naturalzetas,zeta)
        end)


        zeta:SetPos(point)
        zeta:SetAngles(Angle(0,math.random(0,360,0),0))
        zeta.IsNatural = true
        zeta.NaturalWeapon = GetConVar("zetaplayer_naturalspawnweapon"):GetString()
        zeta:Spawn()
        zeta:EmitSound(GetConVar("zetaplayer_customspawnsound"):GetString() != "" and GetConVar("zetaplayer_customspawnsound"):GetString() or 'zetaplayer/misc/spawn_zeta.wav',60)

    end
    

end)