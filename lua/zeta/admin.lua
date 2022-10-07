AddCSLuaFile()

ENT.CurrentRuleData = {}
local IsValid = IsValid

local props = {
    ["prop_physics"] = true,
    ["prop_physics_multiplayer"] = true,
    ["prop_ragdoll"] = true

}


function ENT:Interrogate(times,offender)
    if offender.IsZetaPlayer then offender:CancelMove() offender:SetState("jailed/held") end
    local stop = false
    local curtimes = 0
    local dur
    while self.IsSpeaking do
        coroutine.yield()
    end
    timer.Create("zetaAdmin_interrogate"..self:EntIndex(),1,times,function()
        if !IsValid(self) or !IsValid(offender) then timer.Remove("zetaAdmin_interrogate"..self:EntIndex()) return end
        timer.Pause("zetaAdmin_interrogate"..self:EntIndex())
        self.AllowResponse = false
        curtimes = curtimes + 1


        self.text_keyent = offender:IsPlayer() and offender:GetName() or offender.IsZetaPlayer and offender.zetaname
        if self.UseTextChat then
            dur = self:TypeMessage("admininterror")
        else
            dur = self:PlayScoldSound() or 1
        end
        


        timer.Simple(dur,function()
            if curtimes == times then
                stop = true 
                return 
            end
            if offender.IsZetaPlayer then
                offender.AllowResponse = true
            elseif offender:IsPlayer() then
                timer.Create("zetadminplayerinterro_timeout"..self:EntIndex(),10,1,function()
                    self.AllowResponse = true
                end)
            end

        end) 

    end)

    while true do 
        if !IsValid(offender) then break end
        if offender.IsZetaPlayer then if !offender.SitAdmin then offender.SitAdmin = self end offender:CancelMove() offender:SetEnemy(NULL) if offender:GetState() != "jailed/held" then offender:SetState("jailed/held") end end
        if stop then break end
        if self.AllowResponse then timer.UnPause("zetaAdmin_interrogate"..self:EntIndex()) end
        coroutine.yield()
    end

end

function ENT:GetAdmins()
    local admins = {}

    for k,v in ipairs(ents.FindByClass("npc_zetaplayer")) do
        if v.IsAdmin then
            table.insert(admins,v)
        end
    end

    return admins
end


function ENT:FindAdminSitArea()
    local areas = navmesh.GetAllNavAreas()
    local primesitareas = {}


    for k,v in ipairs(areas) do
    if IsValid(v) and !v:IsUnderwater() then

      if v:GetAttributes() == NAV_MESH_TRANSIENT then
        table.insert(primesitareas,v)
      end

    end
  end

  if #primesitareas > 0 then
    for k,v in RandomPairs(primesitareas) do
        if IsValid(v) then
            return v:GetRandomPoint()
        end
    end

  else

    for k,v in RandomPairs(areas) do
        if IsValid(v) and !v:IsUnderwater() then

            if v:GetSizeX() >= 100 or v:GetSizeY() >= 100 then
                return v:GetRandomPoint()
            end
    
        end
    end
  end



end


function ENT:GetPlayerZetas()
    local members = {}

    for k,v in ipairs(ents.GetAll()) do
        if v.IsZetaPlayer and v != self or v:IsPlayer() then
            table.insert(members,v)
        end
    end

    return members
end

function ENT:GetAllowedCommands()
    local admincmds = {}

    if GetConVar("zetaplayer_adminallowgodmode"):GetInt() == 1 then

        local function adminGodMode()
            if !self.zetaIngodmode then
                self:COMMAND_Godmode(self)
            else
                self:COMMAND_UnGod(self)
            end
        end

        
        table.insert(admincmds,adminGodMode)
    end
    
    if GetConVar("zetaplayer_adminallowsethealth"):GetInt() == 1 then
        local function adminSetHealth()
            self:COMMAND_SetHealth(self,math.random(1,1000000))
        end

        table.insert(admincmds,adminSetHealth)
    end

    if GetConVar("zetaplayer_adminallowsetarmor"):GetInt() == 1 then
        local function adminSetArmor()
            self:COMMAND_SetArmor(self,math.random(1,255))
        end

        table.insert(admincmds,adminSetArmor)
    end

    if GetConVar("zetaplayer_adminallowgoto"):GetInt() == 1 then
        local function adminGoto()
            local members = self:GetPlayerZetas()
            local ply = members[math.random(#members)]
            if IsValid(ply) then
                self:COMMAND_Goto(ply)
            end
        end

        table.insert(admincmds,adminGoto)
    end

    if GetConVar("zetaplayer_adminallowsetpos"):GetInt() == 1 then
        local function adminSetPos()
            local pos 
            local areas = navmesh.GetAllNavAreas()
            for k,v in RandomPairs(areas) do
                if IsValid(v) and !v:IsUnderwater() then
        
                    if v:GetSizeX() >= 100 or v:GetSizeY() >= 100 then
                        pos = v:GetRandomPoint()
                        break
                    end
            
                end
            end
            if pos then
                self:COMMAND_SetPos(pos)
            end
        end

        table.insert(admincmds,adminSetPos)
    end

    return admincmds
end

function ENT:DecideOnOffender(ent,reason)

    if 100 * math.random() < self.Strictness then
        if 200 * math.random() < self.Strictness then

            if ent.IsZetaPlayer then
                local dur = math.random(0.5,3.0)
            self:AddGesture( ACT_GMOD_IN_CHAT,false )
            self:Wait(dur)
            self:RemoveGesture(ACT_GMOD_IN_CHAT)

            self:ChooseHardPunishment(ent,reason)
            return
            elseif ent:IsPlayer() then
                if ent.IsJailed then
                    local dur = math.random(0.5,3.0)
                    self:AddGesture( ACT_GMOD_IN_CHAT,false )
                    self:Wait(dur)
                    self:RemoveGesture(ACT_GMOD_IN_CHAT)
            
                    self:COMMAND_UnJail(ent)
                end

                self:AddGesture( ACT_GMOD_IN_CHAT,false )
                local dur = math.random(0.5,3.0)
                self:Wait(dur)
                self:RemoveGesture(ACT_GMOD_IN_CHAT)

                self:ChoosePunishment(ent)

                if IsValid(ent) and ent:IsPlayer() and ent:Alive() then
                    local dur = math.random(0.5,3.0)
                    self:AddGesture( ACT_GMOD_IN_CHAT,false )
                    self:Wait(dur)
                    self:RemoveGesture(ACT_GMOD_IN_CHAT)
    
                    self:COMMAND_Return(ent)
                end
                return
            end
        end

        if ent.IsJailed then
            local dur = math.random(0.5,3.0)
            self:AddGesture( ACT_GMOD_IN_CHAT,false )
            self:Wait(dur)
            self:RemoveGesture(ACT_GMOD_IN_CHAT)

            self:COMMAND_UnJail(ent)
            
        end
        local dur = math.random(0.5,3.0)
        self:AddGesture( ACT_GMOD_IN_CHAT,false )
        self:Wait(dur)
        self:RemoveGesture(ACT_GMOD_IN_CHAT)

        self:ChoosePunishment(ent)


    else
        if ent.IsJailed then
            local dur = math.random(0.5,3.0)
            self:AddGesture( ACT_GMOD_IN_CHAT,false )
            self:Wait(dur)
            self:RemoveGesture(ACT_GMOD_IN_CHAT)

            self:COMMAND_UnJail(ent)
            
        end
    end

    if IsValid(ent) and ent.zetaLastPosition then 

        local dur = math.random(0.5,3.0)

        self:AddGesture( ACT_GMOD_IN_CHAT,false )
        self:Wait(dur)
        self:RemoveGesture(ACT_GMOD_IN_CHAT)
        
        if ent.IsZetaPlayer then
            if IsValid(ent) then
                self:COMMAND_Return(ent)
            end
        else
            if IsValid(ent) and ent:IsPlayer() and ent:Alive() then
                self:COMMAND_Return(ent)
            end
        end
    end

end

function ENT:ChooseHardPunishment(ent,reason)
    if ent.IsZetaPlayer then
        local decide = math.random(1,2)

        if ( decide == 1 ) then
            self:COMMAND_Kick(ent,reason)
        elseif ( decide == 2 ) then
            self:COMMAND_Ban(ent,reason)
        end
    elseif ent:IsPlayer() then
        self:ChoosePunishment(ent)
    end
end

function ENT:ChoosePunishment(ent)
    local decide = math.random(1,3)

    if ( decide == 1 ) then
        self:COMMAND_Slay(ent)
    elseif ( decide == 2 ) then
        self:COMMAND_Ignite(ent)
    elseif ( decide == 3 ) then
        self:COMMAND_Slap(ent)
    elseif ( decide == 4 ) then
        self:COMMAND_Whip(ent)
    end
end


--- ADMIN COMMANDS ---

-- The Admin's Display color: Color(r,g,b)
-- Color of a key point: Color(0,255,0)
-- Color for detail on what before or after the key point example, set their position : Color(130,164,192)

function ENT:COMMAND_SetPos(pos)
    if !IsValid(self) then return end
    if GetConVar("zetaplayer_adminprintecho"):GetBool() then
        local r,g,b = GetConVar("zetaplayer_admindisplaynameRed"):GetInt(),GetConVar("zetaplayer_admindisplaynameGreen"):GetInt(),GetConVar("zetaplayer_admindisplaynameBlue"):GetInt()
        net.Start("zeta_sendcoloredtext",true)
        net.WriteString(util.TableToJSON({Color(r,g,b),self.zetaname,Color(130,164,192)," set their position ",Color(0,255,0),"Somewhere"}))
        net.Broadcast()
    end
    self.zetaLastPosition = self:GetPos()
    self:SetPos(pos)
end

function ENT:COMMAND_Goto(ent)
    if !IsValid(ent) or !IsValid(self) then return end
    if GetConVar("zetaplayer_adminprintecho"):GetBool() then
        local name 
        if ent:IsPlayer() then 
            name = "You"
        elseif ent.IsZetaPlayer then
            name = ent.zetaname
        end
        local r,g,b = GetConVar("zetaplayer_admindisplaynameRed"):GetInt(),GetConVar("zetaplayer_admindisplaynameGreen"):GetInt(),GetConVar("zetaplayer_admindisplaynameBlue"):GetInt()
        net.Start("zeta_sendcoloredtext",true)
        net.WriteString(util.TableToJSON({Color(r,g,b),self.zetaname,Color(130,164,192)," teleported to ",Color(0,255,0),name}))
        net.Broadcast()
    end
    self:SetPos(ent:GetPos()+self:GetNormalTo(self:GetPos(),ent:GetPos())*100)
end

function ENT:COMMAND_Return(ent)
    if !IsValid(ent) or !IsValid(self) then return end
    if ent.zetaLastPosition then
        if GetConVar("zetaplayer_adminprintecho"):GetBool() then
            local name 
            if ent:IsPlayer() then 
                name = "You"
            elseif ent == self then
                name = "Themselves"
            elseif ent.IsZetaPlayer then
                name = ent.zetaname
            end
            local r,g,b = GetConVar("zetaplayer_admindisplaynameRed"):GetInt(),GetConVar("zetaplayer_admindisplaynameGreen"):GetInt(),GetConVar("zetaplayer_admindisplaynameBlue"):GetInt()
            net.Start("zeta_sendcoloredtext",true)
            net.WriteString(util.TableToJSON({Color(r,g,b),self.zetaname,Color(130,164,192)," returned ",Color(0,255,0),name,Color(130,164,192)," back to their original position"}))
            net.Broadcast()
        end
        ent:SetPos(ent.zetaLastPosition)
    end
end

function ENT:COMMAND_Slay(ent)
    if !IsValid(ent) or !IsValid(self) then return end
    if GetConVar("zetaplayer_adminprintecho"):GetBool() then
        local name 
        if ent:IsPlayer() then 
            name = "You"
        elseif ent.IsZetaPlayer then
            name = ent.zetaname
        end
        local r,g,b = GetConVar("zetaplayer_admindisplaynameRed"):GetInt(),GetConVar("zetaplayer_admindisplaynameGreen"):GetInt(),GetConVar("zetaplayer_admindisplaynameBlue"):GetInt()
        net.Start("zeta_sendcoloredtext",true)
        net.WriteString(util.TableToJSON({Color(r,g,b),self.zetaname,Color(130,164,192)," slayed ",Color(0,255,0),name}))
        net.Broadcast()
    end

    
    ent:TakeDamage(ent:GetMaxHealth()*1000,self,self)
end

function ENT:COMMAND_Kick(ent,reason)
    if !IsValid(ent) or !IsValid(self) then return end
    if GetConVar("zetaplayer_adminprintecho"):GetBool() then
        local name 
        if ent:IsPlayer() then 
            name = "You"
        elseif ent.IsZetaPlayer then
            name = ent.zetaname
        end
        local r,g,b = GetConVar("zetaplayer_admindisplaynameRed"):GetInt(),GetConVar("zetaplayer_admindisplaynameGreen"):GetInt(),GetConVar("zetaplayer_admindisplaynameBlue"):GetInt()
        net.Start("zeta_sendcoloredtext",true)
        net.WriteString(util.TableToJSON({Color(r,g,b),self.zetaname,Color(130,164,192)," kicked ",Color(0,255,0),name," ",Color(130,164,192),"(",Color(0,255,0),reason,Color(130,164,192),")"}))
        net.Broadcast()
    end
    if ent.IsJailed then
        RemoveJailOnEnt(ent)
    end
    ent:Remove()
end

function ENT:COMMAND_Ban(ent,reason)
    if !IsValid(ent) or !IsValid(self) then return end
    local length = math.random(30,360)
    if GetConVar("zetaplayer_adminprintecho"):GetBool() then
        local name 
        if ent:IsPlayer() then 
            name = "You"
        elseif ent.IsZetaPlayer then
            name = ent.zetaname
        end
        local r,g,b = GetConVar("zetaplayer_admindisplaynameRed"):GetInt(),GetConVar("zetaplayer_admindisplaynameGreen"):GetInt(),GetConVar("zetaplayer_admindisplaynameBlue"):GetInt()
        net.Start("zeta_sendcoloredtext",true)
        net.WriteString(util.TableToJSON({Color(r,g,b),self.zetaname,Color(130,164,192)," banned ",Color(0,255,0),name,Color(130,164,192)," for ",Color(0,255,0),tostring(length),Color(130,164,192)," second(s) ",Color(130,164,192),"(",Color(0,255,0),reason,Color(130,164,192),")"}))
        net.Broadcast()
    end
    if ent.IsJailed then
        RemoveJailOnEnt(ent)
    end
    local id = ent:GetCreationID()
    _bannedzetas[id] = ent.zetaname
    timer.Simple(length,function()
        _bannedzetas[id] = nil
    end)
    ent:Remove()
end

function ENT:COMMAND_Slap(ent)
    if !IsValid(ent) or !IsValid(self) then return end
    local damage = math.random(0,100)
    if GetConVar("zetaplayer_adminprintecho"):GetBool() then
        local name 
        if ent:IsPlayer() then 
            name = "You"
        elseif ent.IsZetaPlayer then
            name = ent.zetaname
        end
        local r,g,b = GetConVar("zetaplayer_admindisplaynameRed"):GetInt(),GetConVar("zetaplayer_admindisplaynameGreen"):GetInt(),GetConVar("zetaplayer_admindisplaynameBlue"):GetInt()
        net.Start("zeta_sendcoloredtext",true)
        net.WriteString(util.TableToJSON({Color(r,g,b),self.zetaname,Color(130,164,192)," slapped ",Color(0,255,0),name,Color(130,164,192)," with ",Color(0,255,0),tostring(damage),Color(130,164,192)," damage"}))
        net.Broadcast()
    end
    if ent.IsZetaPlayer then
        ent.loco:SetVelocity(VectorRand(-1000,1000))
    elseif ent:IsPlayer() then
        local vec = VectorRand(-500,500)
        ent:SetVelocity(vec)
        ent:ViewPunch(vec:Angle()/10)
    end
    ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(1,6)..".wav",65)
    ent:TakeDamage(damage,self,self)
end

function ENT:COMMAND_Whip(ent)
    if !IsValid(ent) or !IsValid(self) then return end
    local damage = math.random(0,10)
    local times = math.random(1,100)
    if GetConVar("zetaplayer_adminprintecho"):GetBool() then
        local name 
        if ent:IsPlayer() then 
            name = "You"
        elseif ent.IsZetaPlayer then
            name = ent.zetaname
        end
        local r,g,b = GetConVar("zetaplayer_admindisplaynameRed"):GetInt(),GetConVar("zetaplayer_admindisplaynameGreen"):GetInt(),GetConVar("zetaplayer_admindisplaynameBlue"):GetInt()
        net.Start("zeta_sendcoloredtext",true)
        net.WriteString(util.TableToJSON({Color(r,g,b),self.zetaname,Color(130,164,192)," whipped ",Color(0,255,0),name," ",tostring(times),Color(130,164,192)," times with ",Color(0,255,0),tostring(damage),Color(130,164,192)," damage"}))
        net.Broadcast()
    end
    timer.Create("zetaadminwhip"..self:EntIndex(),0.5,times,function()
        if !IsValid(self) or !IsValid(ent) or IsValid(ent) and ent:IsPlayer() and !ent:Alive() then timer.Remove("zetaadminwhip"..self:EntIndex()) return end
        if ent.IsZetaPlayer then
            ent.loco:SetVelocity(VectorRand(-1000,1000))
        elseif ent:IsPlayer() then
            local vec = VectorRand(-500,500)
            ent:SetVelocity(vec)
            ent:ViewPunch(vec:Angle()/10)
        end
        ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(1,6)..".wav",65)
        ent:TakeDamage(damage,self,self)
    end)
end

function ENT:COMMAND_Ignite(ent)
    if !IsValid(ent) or !IsValid(self) then return end
    local ignitelength = math.random(1,120)
    if GetConVar("zetaplayer_adminprintecho"):GetBool() then
        local name 
        if ent:IsPlayer() then 
            name = "You"
        elseif ent.IsZetaPlayer then
            name = ent.zetaname
        end 
        local r,g,b = GetConVar("zetaplayer_admindisplaynameRed"):GetInt(),GetConVar("zetaplayer_admindisplaynameGreen"):GetInt(),GetConVar("zetaplayer_admindisplaynameBlue"):GetInt()
        net.Start("zeta_sendcoloredtext",true)
        net.WriteString(util.TableToJSON({Color(r,g,b),self.zetaname,Color(130,164,192)," ignited ",Color(0,255,0),name,Color(130,164,192)," for ",Color(0,255,0),tostring(ignitelength)," seconds"}))
        net.Broadcast()
    end
    ent:Ignite(ignitelength)
end

function ENT:COMMAND_SetHealth(ent,value)
    if !IsValid(ent) or !IsValid(self) then return end
    if GetConVar("zetaplayer_adminprintecho"):GetBool() then
        local name 
        if ent:IsPlayer() then 
            name = "Your"
        elseif ent.IsZetaPlayer and ent == self then
            name = "Their"
        elseif ent.IsZetaPlayer and ent != self then
            name = ent.zetaname
        end
        local r,g,b = GetConVar("zetaplayer_admindisplaynameRed"):GetInt(),GetConVar("zetaplayer_admindisplaynameGreen"):GetInt(),GetConVar("zetaplayer_admindisplaynameBlue"):GetInt()
        net.Start("zeta_sendcoloredtext",true)
        net.WriteString(util.TableToJSON({Color(r,g,b),self.zetaname,Color(130,164,192)," set ",Color(0,255,0),name,Color(130,164,192)," health to ",Color(0,255,0),tostring(value)}))
        net.Broadcast()
    end
    ent:SetHealth(value)
end

function ENT:COMMAND_SetArmor(ent,value)
    if !IsValid(ent) or !IsValid(self) then return end
    if GetConVar("zetaplayer_adminprintecho"):GetBool() then
        local name 
        if ent:IsPlayer() then 
            name = "Your"
        elseif ent.IsZetaPlayer and ent == self then
            name = "Their"
        elseif ent.IsZetaPlayer and ent != self then
            name = ent.zetaname
        end
        local r,g,b = GetConVar("zetaplayer_admindisplaynameRed"):GetInt(),GetConVar("zetaplayer_admindisplaynameGreen"):GetInt(),GetConVar("zetaplayer_admindisplaynameBlue"):GetInt()
        net.Start("zeta_sendcoloredtext",true)
        net.WriteString(util.TableToJSON({Color(r,g,b),self.zetaname,Color(130,164,192)," set ",Color(0,255,0),name,Color(130,164,192)," armor to ",Color(0,255,0),tostring(value)}))
        net.Broadcast()
    end
    if ent.IsZetaPlayer then
    ent.CurrentArmor = value
    elseif ent:IsPlayer() then
        ent:SetArmor(value)
    end
end

function ENT:COMMAND_Godmode(ent)
    if !IsValid(ent) or !IsValid(self) then return end
    if GetConVar("zetaplayer_adminprintecho"):GetBool() then
        local name 
        if ent:IsPlayer() then 
            name = "You"
        elseif ent.IsZetaPlayer and ent == self then
            name = "Themselves"
        elseif ent.IsZetaPlayer and ent != self then
            name = ent.zetaname
        end
        local r,g,b = GetConVar("zetaplayer_admindisplaynameRed"):GetInt(),GetConVar("zetaplayer_admindisplaynameGreen"):GetInt(),GetConVar("zetaplayer_admindisplaynameBlue"):GetInt()
        net.Start("zeta_sendcoloredtext",true)
        net.WriteString(util.TableToJSON({Color(r,g,b),self.zetaname,Color(130,164,192)," granted god mode upon ",Color(0,255,0),name}))
        net.Broadcast()
    end
    ent.zetaIngodmode = true
end

function ENT:COMMAND_UnGod(ent)
    if !IsValid(ent) or !IsValid(self) then return end
    if GetConVar("zetaplayer_adminprintecho"):GetBool() then
        local name 
        if ent:IsPlayer() then 
            name = "You"
        elseif ent.IsZetaPlayer and ent == self then
            name = "Themselves"
        elseif ent.IsZetaPlayer and ent != self then
            name = ent.zetaname
        end
        local r,g,b = GetConVar("zetaplayer_admindisplaynameRed"):GetInt(),GetConVar("zetaplayer_admindisplaynameGreen"):GetInt(),GetConVar("zetaplayer_admindisplaynameBlue"):GetInt()
        net.Start("zeta_sendcoloredtext",true)
        net.WriteString(util.TableToJSON({Color(r,g,b),self.zetaname,Color(130,164,192)," revoked god mode from ",Color(0,255,0),name}))
        net.Broadcast()
    end
    ent.zetaIngodmode = false
end



function ENT:COMMAND_Bring(ent)
    if !IsValid(ent) or !IsValid(self) then return end
    if GetConVar("zetaplayer_adminprintecho"):GetBool() then
        local name 
        if ent:IsPlayer() then 
            name = "You"
        elseif ent.IsZetaPlayer then
            name = ent.zetaname
        end
        local r,g,b = GetConVar("zetaplayer_admindisplaynameRed"):GetInt(),GetConVar("zetaplayer_admindisplaynameGreen"):GetInt(),GetConVar("zetaplayer_admindisplaynameBlue"):GetInt()
        net.Start("zeta_sendcoloredtext",true)
        net.WriteString(util.TableToJSON({Color(r,g,b),self.zetaname,Color(130,164,192)," brought ",Color(0,255,0),name,Color(130,164,192)," to them"}))
        net.Broadcast()
    end
    ent.zetaLastPosition = ent:GetPos()
    ent:SetPos(self:GetPos()+self:GetForward()*100)
end


function ENT:COMMAND_TpJail(ent)
    if !IsValid(ent) or !IsValid(self) then return end
    if GetConVar("zetaplayer_adminprintecho"):GetBool() then
        local name 
        if ent:IsPlayer() then 
            name = "You"
        elseif ent.IsZetaPlayer then
            name = ent.zetaname
        end
        local r,g,b = GetConVar("zetaplayer_admindisplaynameRed"):GetInt(),GetConVar("zetaplayer_admindisplaynameGreen"):GetInt(),GetConVar("zetaplayer_admindisplaynameBlue"):GetInt()
        net.Start("zeta_sendcoloredtext",true)
        net.WriteString(util.TableToJSON({Color(r,g,b),self.zetaname,Color(130,164,192)," teleported and jailed ",Color(0,255,0),name}))
        net.Broadcast()
    end
    ent.zetaLastPosition = ent:GetPos()
    ent:SetPos(self:GetPos()+self:GetForward()*100)
    ent.IsJailed = true
    CreateJailOnEnt(ent)
end


function ENT:COMMAND_Jail(ent)
    if !IsValid(ent) or !IsValid(self) then return end
    if GetConVar("zetaplayer_adminprintecho"):GetBool() then
        local name 
        if ent:IsPlayer() then 
            name = "You"
        elseif ent.IsZetaPlayer then
            name = ent.zetaname
        end
        local r,g,b = GetConVar("zetaplayer_admindisplaynameRed"):GetInt(),GetConVar("zetaplayer_admindisplaynameGreen"):GetInt(),GetConVar("zetaplayer_admindisplaynameBlue"):GetInt()
        net.Start("zeta_sendcoloredtext",true)
        net.WriteString(util.TableToJSON({Color(r,g,b),self.zetaname,Color(130,164,192)," jailed ",Color(0,255,0),name}))
        net.Broadcast()
    end
    ent.IsJailed = true
    CreateJailOnEnt(ent)
end

function ENT:COMMAND_UnJail(ent)
    if !IsValid(ent) or !IsValid(self) then return end
    if GetConVar("zetaplayer_adminprintecho"):GetBool() then
        local name 
        if ent:IsPlayer() then 
            name = "You"
        elseif ent.IsZetaPlayer then
            name = ent.zetaname
        end
        local r,g,b = GetConVar("zetaplayer_admindisplaynameRed"):GetInt(),GetConVar("zetaplayer_admindisplaynameGreen"):GetInt(),GetConVar("zetaplayer_admindisplaynameBlue"):GetInt()
        net.Start("zeta_sendcoloredtext",true)
        net.WriteString(util.TableToJSON({Color(r,g,b),self.zetaname,Color(130,164,192)," unjailed ",Color(0,255,0),name}))
        net.Broadcast()
    end
    ent.IsJailed = false
    RemoveJailOnEnt(ent)
end