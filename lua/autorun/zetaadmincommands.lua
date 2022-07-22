
if SERVER then -- Player admin commands will be handled here

    local function SourceCut(self)
        local pos = self:GetPos()
    
        local beams = {}
        local dist = GetConVar("zetaplayer_sourcecutdistance"):GetInt()
    
        self:EmitSound("zetaplayer/weapon/katana/sourcecut.wav",160)
    
        for i=1, 20 do
            beams[i] = ents.Create("base_anim")
            beams[i]:SetModel("models/hunter/plates/plate.mdl")
            beams[i]:SetNoDraw(true)
            beams[i]:SetPos(pos+VectorRand(-dist,dist))
            beams[i]:Spawn()
            util.SpriteTrail( beams[i], 0, color_white, true, 10, 0, 15, 1 / ( 10 + 0 ) * 0.5, "trails/laser" )
        end
    
        timer.Create("SourceCut",0,40,function()
            util.ScreenShake(pos,5,140,2,3000)
            for i=1, 20 do
                beams[i]:SetPos(pos+VectorRand(-dist,dist))
            end
        end)
    
        
    
        timer.Simple(3.3,function()
            util.ScreenShake(pos,13,340,4,3000)
    
            local caughtents = ents.FindInSphere(pos,dist+300)
    
            for k,v in ipairs(caughtents) do
                if IsValid(v) and v != self then
                    v:TakeDamage(4000,self,self)
                end
            end
    
            for i=1,30 do
                local shard = ents.Create("prop_physics")
                shard:SetModel("models/gibs/glass_shard0"..math.random(1,6)..".mdl")
                shard:SetPos(pos+VectorRand(-dist,dist))
                shard:SetAngles(AngleRand(-180,180))
                shard:Spawn()
                shard:EmitSound("physics/glass/glass_largesheet_break"..math.random(1,3)..".wav")
                local phys = shard:GetPhysicsObject()
                if IsValid(phys) then
                    phys:ApplyForceCenter(VectorRand(-400,400))
                    phys:SetAngleVelocity(VectorRand(-380,380))
                end
                timer.Simple(10,function()
                    if IsValid(shard) then
                        shard:Remove()
                    end
                end)
            end
        end)
    
        timer.Simple(16,function()
            for k,v in ipairs(beams) do
                if IsValid(v) then
                    v:Remove()
                end
            end
        end)
    
    
    end
    
    local function GetNormalTo(pos1,pos2)
        local point = (pos1-pos2):Angle()
        return point:Forward()
    end

    local function PlayerGOTOZeta(zeta,caller)
        if GetConVar("zetaplayer_adminprintecho"):GetBool() then

            
            net.Start("zeta_sendcoloredtext",true)
            net.WriteString(util.TableToJSON({Color(0,255,0),"You",Color(130,164,192)," teleported to ",Color(0,255,0),zeta.zetaname}))
            net.Broadcast()
        end
        caller.zetaLastPosition = caller:GetPos()
        caller:SetPos(zeta:GetPos()+GetNormalTo(caller:GetPos(),zeta:GetPos())*100)
    end

    local function PlayerReturnZeta(ent,caller)
        if ent.zetaLastPosition then
            if GetConVar("zetaplayer_adminprintecho"):GetBool() then
                local name
                if ent:IsPlayer() then
                name = "Yourself"
                elseif ent.IsZetaPlayer then
                    name = ent.zetaname
                end
                net.Start("zeta_sendcoloredtext",true)
                net.WriteString(util.TableToJSON({Color(0,255,0),"You",Color(130,164,192)," returned ",Color(0,255,0),name,Color(130,164,192)," back to their original position"}))
                net.Broadcast()
            end
            ent:SetPos(ent.zetaLastPosition)
        end
    end

    local function PlayerBringZeta(zeta,caller)
        if !IsValid(zeta) then return end
        if GetConVar("zetaplayer_adminprintecho"):GetBool() then

            
            net.Start("zeta_sendcoloredtext",true)
            net.WriteString(util.TableToJSON({Color(0,255,0),"You",Color(130,164,192)," brought ",Color(0,255,0),zeta.zetaname,Color(130,164,192),"to yourself"}))
            net.Broadcast()
        end
        zeta.zetaLastPosition = zeta:GetPos()
        zeta.CurNoclipPos = caller:GetEyeTrace().HitPos
        zeta:SetPos(caller:GetPos()+caller:GetForward()*100)
    end

    local function PlayerSlayZeta(zeta,caller)
        if GetConVar("zetaplayer_adminprintecho"):GetBool() then
            local name = zeta.zetaname
            net.Start("zeta_sendcoloredtext",true)
            net.WriteString(util.TableToJSON({Color(0,255,0),caller:GetName(),Color(130,164,192)," slayed ",Color(0,255,0),name}))
            net.Broadcast()
        end

        
        zeta:TakeDamage(zeta:GetMaxHealth()*1000,caller,caller)
    end

    local function PlayerKickZeta(zeta,caller,reason)
        if GetConVar("zetaplayer_adminprintecho"):GetBool() then
            local name = zeta.zetaname
            if reason == "" or !reason then
                reason = "No reason"
            end
            net.Start("zeta_sendcoloredtext",true)
            net.WriteString(util.TableToJSON({Color(0,255,0),caller:GetName(),Color(130,164,192)," kicked ",Color(0,255,0),name," ",Color(130,164,192),"(",Color(0,255,0),reason,Color(130,164,192),")"}))
            net.Broadcast()
        end
        if zeta.IsJailed then
            RemoveJailOnEnt(zeta)
        end
        if IsValid(zeta.Spawner) then
            zeta.Spawner:Remove()
        end
        zeta:Remove()
    end

    local function PlayerBanZeta(zeta,caller,reason,time)
        local length = time or 60
        if GetConVar("zetaplayer_adminprintecho"):GetBool() then
            local name = zeta.zetaname


            net.Start("zeta_sendcoloredtext",true)
            net.WriteString(util.TableToJSON({Color(0,255,0),caller:GetName(),Color(130,164,192)," banned ",Color(0,255,0),name,Color(130,164,192)," for ",Color(0,255,0),tostring(length),Color(130,164,192)," second(s) ",Color(130,164,192),"(",Color(0,255,0),reason,Color(130,164,192),")"}))
            net.Broadcast()
        end
        if zeta.IsJailed then
            RemoveJailOnEnt(zeta)
        end
        local id = zeta:GetCreationID()
        _bannedzetas[id] = zeta.zetaname
        timer.Simple(length,function()
            _bannedzetas[id] = nil
        end)
        if IsValid(zeta.Spawner) then
            zeta.Spawner:Remove()
        end
        zeta:Remove()
    end


    local function PlayerslapZeta(ent,caller,damage)
        if GetConVar("zetaplayer_adminprintecho"):GetBool() then


            local name = ent.zetaname

            net.Start("zeta_sendcoloredtext",true)
            net.WriteString(util.TableToJSON({Color(0,255,0),caller:GetName(),Color(130,164,192)," slapped ",Color(0,255,0),name,Color(130,164,192)," with ",Color(0,255,0),tostring(damage),Color(130,164,192)," damage"}))
            net.Broadcast()
        end
        if ent.IsZetaPlayer then
            ent.IsJumping = true 
            ent:SetLastActivity(ent:GetActivity())
            ent.loco:Jump()
            ent.loco:SetVelocity(VectorRand(-1000,1000))
        end
        ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(1,6)..".wav",65)
        ent:TakeDamage(tonumber(damage),caller,caller)
    end


    local function PlayerWhipZeta(ent,caller,damage,times)
        damage = damage or 0
        times = times or 10
        if GetConVar("zetaplayer_adminprintecho"):GetBool() then

            local name = ent.zetaname


            net.Start("zeta_sendcoloredtext",true)
            net.WriteString(util.TableToJSON({Color(0,255,0),caller:GetName(),Color(130,164,192)," whipped ",Color(0,255,0),name," ",tostring(times),Color(130,164,192)," times with ",Color(0,255,0),tostring(damage),Color(130,164,192)," damage"}))
            net.Broadcast()
        end
        local rndid = math.random(0,100000)
        timer.Create("zetaadminwhip"..rndid,0.5,times,function()
            if !IsValid(ent) then timer.Remove("zetaadminwhip"..rndid) return end
            if ent.IsZetaPlayer then
                ent.IsJumping = true 
                ent:SetLastActivity(ent:GetActivity())
                ent.loco:Jump()
                ent.loco:SetVelocity(VectorRand(-1000,1000))
            end
            ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(1,6)..".wav",65)
            ent:TakeDamage(tonumber(damage),caller,caller)
        end)

    end

    local function PlayerigniteZeta(ent,caller,length)
        length = length or 5
        if GetConVar("zetaplayer_adminprintecho"):GetBool() then
            local name = ent.zetaname
            net.Start("zeta_sendcoloredtext",true)
            net.WriteString(util.TableToJSON({Color(0,255,0),caller:GetName(),Color(130,164,192)," ignited ",Color(0,255,0),name,Color(130,164,192)," for ",Color(0,255,0),tostring(length)," seconds"}))
            net.Broadcast()
        end
        ent:Ignite(length)
    end

    local function PlayersethealthZeta(ent,caller,amount)
        if GetConVar("zetaplayer_adminprintecho"):GetBool() then

            local name = ent.zetaname

            net.Start("zeta_sendcoloredtext",true)
            net.WriteString(util.TableToJSON({Color(0,255,0),caller:GetName(),Color(130,164,192)," set ",Color(0,255,0),name,Color(130,164,192)," health to ",Color(0,255,0),tostring(amount)}))
            net.Broadcast()
        end
        ent:SetHealth(amount)
    end

    local function PlayersetarmorZeta(ent,caller,amount)
        if !IsValid(ent) or !IsValid(self) then return end
        if GetConVar("zetaplayer_adminprintecho"):GetBool() then
            local name = ent.zetaname

            net.Start("zeta_sendcoloredtext",true)
            net.WriteString(util.TableToJSON({Color(0,255,0),self.zetaname,Color(130,164,192)," set ",Color(0,255,0),name,Color(130,164,192)," armor to ",Color(0,255,0),tostring(amount)}))
            net.Broadcast()
        end
        if ent.IsZetaPlayer then
            ent.CurrentArmor = amount
        end
    end

    local function PlayerGodModeZeta(ent,caller)
        if GetConVar("zetaplayer_adminprintecho"):GetBool() then

            local name = ent.zetaname

            net.Start("zeta_sendcoloredtext",true)
            net.WriteString(util.TableToJSON({Color(0,255,0),caller:GetName(),Color(130,164,192)," granted god mode upon ",Color(0,255,0),name}))
            net.Broadcast()
        end
        ent.zetaIngodmode = true
    end

    local function PlayerUnGodZeta(ent,caller)
        if GetConVar("zetaplayer_adminprintecho"):GetBool() then

            local name = ent.zetaname

            net.Start("zeta_sendcoloredtext",true)
            net.WriteString(util.TableToJSON({Color(0,255,0),caller:GetName(),Color(130,164,192)," revoked god mode from ",Color(0,255,0),name}))
            net.Broadcast()
        end
        ent.zetaIngodmode = false
    end

    local function PlayerjailZeta(ent,caller)

        if GetConVar("zetaplayer_adminprintecho"):GetBool() then

            local name = ent.zetaname


            net.Start("zeta_sendcoloredtext",true)
            net.WriteString(util.TableToJSON({Color(0,255,0),caller:GetName(),Color(130,164,192)," jailed ",Color(0,255,0),name}))
            net.Broadcast()
        end
        ent.IsJailed = true
        CreateJailOnEnt(ent)
    end

    local function PlayerunjailZeta(ent,caller)

        if GetConVar("zetaplayer_adminprintecho"):GetBool() then

            local name = ent.zetaname


            net.Start("zeta_sendcoloredtext",true)
            net.WriteString(util.TableToJSON({Color(0,255,0),caller:GetName(),Color(130,164,192)," unjailed ",Color(0,255,0),name}))
            net.Broadcast()
        end
        ent.IsJailed = false
        RemoveJailOnEnt(ent)
    end

    local function PlayertpjailZeta(ent,caller)
        if GetConVar("zetaplayer_adminprintecho"):GetBool() then

            local name = ent.zetaname

            net.Start("zeta_sendcoloredtext",true)
            net.WriteString(util.TableToJSON({Color(0,255,0),caller:GetName(),Color(130,164,192)," teleported and jailed ",Color(0,255,0),name}))
            net.Broadcast()
        end
        ent.zetaLastPosition = ent:GetPos()
        ent.CurNoclipPos = caller:GetEyeTrace().HitPos
        ent:SetPos(caller:GetEyeTrace().HitPos)
        ent.IsJailed = true
        CreateJailOnEnt(ent)
    end

    hook.Add("PlayerSay","ZetaAdminCommands_PlayerCmds",function(ply,text)
        local split = string.Explode(" ",text)

        if split[1] == ",goto" then
            local name = string.Replace(text,",goto ","")
            local zeta = FindZetaByName(name)
            if !IsValid(zeta) then ply:PrintMessage(HUD_PRINTTALK,name.." Is not valid") return "" end

            PlayerGOTOZeta(zeta,ply)
            return ""
        end

        if split[1] == ",bring" then
            local name = string.Replace(text,",bring ","")
            local zeta = FindZetaByName(name)
            if !IsValid(zeta) then ply:PrintMessage(HUD_PRINTTALK,name.." Is not valid") return "" end

            PlayerBringZeta(zeta,ply)
            return ""
        end

        if split[1] == ",return" then
            local name = string.Replace(text,",return ","")
            local zeta = FindZetaByName(name)
            if !IsValid(zeta) then ply:PrintMessage(HUD_PRINTTALK,name.." Is not valid") return "" end

            PlayerReturnZeta(zeta,ply)
            return ""
        end

        if split[1] == ",slay" then
            local name = string.Replace(text,",slay ","")
            local zeta = FindZetaByName(name)
            if !IsValid(zeta) then ply:PrintMessage(HUD_PRINTTALK,name.." Is not valid") return "" end

            PlayerSlayZeta(zeta,ply)
            return ""
        end
        
        if split[1] == ",kick" then
            local name = string.Replace(text,",kick ","")
            local zeta = FindZetaByName(split[2])
            local reason = string.Replace(text,split[2])
            reason = string.Replace(reason,",kick ","")
            if !IsValid(zeta) then ply:PrintMessage(HUD_PRINTTALK,name.." Is not valid") return "" end

            PlayerKickZeta(zeta,ply,reason)
            return ""
        end

        if split[1] == ",ban" then
            local reason = ""
            local time 
            local name 
            for k,v in ipairs(split) do
                if k == 2 then
                    name = v
                elseif k == 3 then
                    time = v
                elseif k >= 4 then
                    reason = reason..v.." "
                end
            end

            local zeta = FindZetaByName(name)

            if !IsValid(zeta) then ply:PrintMessage(HUD_PRINTTALK,name.." Is not valid") return "" end

            PlayerBanZeta(zeta,ply,reason,tonumber(time))
            return ""
        end

        if split[1] == ",slap" then
            local name = split[2]
            local dmg = split[3] or 0

            local zeta = FindZetaByName(name)

            if !IsValid(zeta) then ply:PrintMessage(HUD_PRINTTALK,name.." Is not valid") return "" end

            PlayerslapZeta(zeta,ply,dmg)
            return ""
        end

        if split[1] == ",whip" then
            local name = split[2]
            local dmg = split[3] or 0
            local times = split[4] or 10

            local zeta = FindZetaByName(name)

            if !IsValid(zeta) then ply:PrintMessage(HUD_PRINTTALK,name.." Is not valid") return "" end

            PlayerWhipZeta(zeta,ply,dmg,times)
            return ""
        end

        if split[1] == ",ignite" then
            local name = split[2]
            local length = split[3] or 5

            local zeta = FindZetaByName(name)

            if !IsValid(zeta) then ply:PrintMessage(HUD_PRINTTALK,name.." Is not valid") return "" end

            PlayerigniteZeta(zeta,ply,length)
            return ""
        end

        if split[1] == ",sethealth" then
            local name = split[2]
            local hp = split[3] or 100

            local zeta = FindZetaByName(name)

            if !IsValid(zeta) then ply:PrintMessage(HUD_PRINTTALK,name.." Is not valid") return "" end

            PlayersethealthZeta(zeta,ply,hp)
            return ""
        end

        if split[1] == ",setarmor" then
            local name = split[2]
            local armor = split[3] or 0

            local zeta = FindZetaByName(name)

            if !IsValid(zeta) then ply:PrintMessage(HUD_PRINTTALK,name.." Is not valid") return "" end

            PlayersetarmorZeta(zeta,ply,armor)
            return ""
        end

        if split[1] == ",god" then
            local name = split[2]

            local zeta = FindZetaByName(name)

            if !IsValid(zeta) then ply:PrintMessage(HUD_PRINTTALK,name.." Is not valid") return "" end

            PlayerGodModeZeta(zeta,ply)
            return ""
        end

        if split[1] == ",ungod" then
            local name = split[2]

            local zeta = FindZetaByName(name)

            if !IsValid(zeta) then ply:PrintMessage(HUD_PRINTTALK,name.." Is not valid") return "" end

            PlayerUnGodZeta(zeta,ply)
            return ""
        end

        if split[1] == ",jail" then
            local name = split[2]

            local zeta = FindZetaByName(name)

            if !IsValid(zeta) then ply:PrintMessage(HUD_PRINTTALK,name.." Is not valid") return "" end

            PlayerjailZeta(zeta,ply)
            return ""
        end

        if split[1] == ",tpjail" then
            local name = split[2]

            local zeta = FindZetaByName(name)

            if !IsValid(zeta) then ply:PrintMessage(HUD_PRINTTALK,name.." Is not valid") return "" end

            PlayertpjailZeta(zeta,ply)
            return ""
        end
        
        if split[1] == ",unjail" then
            local name = split[2]

            local zeta = FindZetaByName(name)

            if !IsValid(zeta) then ply:PrintMessage(HUD_PRINTTALK,name.." Is not valid") return "" end

            PlayerunjailZeta(zeta,ply)
            return ""
        end

        if split[1] == ",sourcecut" then
            SourceCut(ply)
            return ""
        end
        
        
    end)





end