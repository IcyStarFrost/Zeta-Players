AddCSLuaFile()

ENT.Base = "base_anim"

local util = util
local ents = ents
local math = math 
local IsValid = IsValid
local keynames = {"A","B","C","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
local color_glacier = Color(130, 164, 192)
local vec_white = Vector(1,1,1)

ENT.ZetaFlag = true


function ENT:Initialize()




    
    
    
    if SERVER then
        local mdl = "models/flag/briefcase.mdl"
        if self.custommodel and util.IsValidModel(self.custommodel) then 
            mdl = self.custommodel 
        end
        self:SetModel(mdl)
        self:SetSkin(2)

        self.CaptureZone = ents.Create("base_anim")
        self.CaptureZone:SetModel("models/props_combine/combine_mine01.mdl")
        self.CaptureZone:SetPos(self:GetPos())
        self.CaptureZone:Spawn()
        self.CaptureZone.Flagowner = self
        self.CaptureZone._ZetaCaptureZone = true
        self:DeleteOnRemove(self.CaptureZone)
        

        timer.Simple(0,function()
            self:SetPos(self:GetPos()+Vector(0,0,10))
        end)
        self:SetPickedUp(false)
        self.Holder = NULL
        self.IsAtHome = true
        self.Curtimerepeat = 0

        if !self.customname or self.customname == "" then
            self.customname = keynames[math.random(#keynames)]..self:GetCreationID()
        end

        self.Placeholderangle = Angle(0,SysTime()*50 %360,0)
        self:SetAngles(self.Placeholderangle)

        
        if !self.CanBePickedUp then
            self:SetNW2Bool("zetaflag_capturezone",true)
        end

        


        if self.teamowner == "" then
            self.teamowner = nil
        end
        local col = ZetaGetTeamColor(self.teamowner)
        self.TeamColor = col and col:ToColor() or color_white

        self:SetColor(self.TeamColor)
        self.CaptureZone:SetColor(self.TeamColor)

        self:SetNW2Vector("zetaflag_teamcolor",self.TeamColor:ToVector())
        self:SetNW2String("zetaflag_team",self.teamowner)
        self:SetNW2String("zetaflag_customname",self.customname)

    end

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

function ENT:GetEntTeam(ent)
    return ent.IsZetaPlayer and ent.zetaTeam or GetConVar("zetaplayer_playerteam"):GetString() != "" and GetConVar("zetaplayer_playerteam"):GetString() or nil
end



function ENT:SetPickedUp(bool)
    self.IsPickedUp = bool
    self:SetNW2Bool("zetaflag_pickedup",bool)
end

function ENT:OnRemove()
    if IsValid(self.Holder) then
        self.Holder.HasFlag = false
    end
end

function ENT:Draw3dText(text,pos,ang,scale)
    if SERVER then return end

    local col = self:GetNW2Vector("zetaflag_teamcolor",Vector(1,1,1)):ToColor()
        

    cam.IgnoreZ( true )
        cam.Start3D2D(pos, ang,scale)
            cam.IgnoreZ( true )
            draw.DrawText(text,"ChatFont",0,0,col,TEXT_ALIGN_CENTER)
            
        cam.End3D2D()

        ang:RotateAroundAxis(Vector(0,0,1), 180)

        cam.Start3D2D(pos, ang,scale)
            cam.IgnoreZ( true )
            draw.DrawText(text,"ChatFont",0,0,col,TEXT_ALIGN_CENTER)
        cam.End3D2D()
    cam.IgnoreZ( false )
end

function ENT:FindInSphere(radius,filter)
    local picked = {}
    local sphere = ents.FindInSphere(self:GetPos(),radius)
    for k,v in ipairs(sphere) do
    
       if filter(v) == true then
         table.insert(picked,v)
       end
    end
  
    return picked
  end

  function ENT:FindInSphereCaptureZone(radius,filter)
    local picked = {}
    local sphere = ents.FindInSphere(self.CaptureZone:GetPos(),radius)
    for k,v in ipairs(sphere) do
    
       if filter(v) == true then
         table.insert(picked,v)
       end
    end
  
    return picked
  end

function ENT:Think()
    if CLIENT then return end

    local surrounding = self:FindInSphere(100,function(ent)
        if IsValid(ent) and (ent.IsZetaPlayer or ent:IsPlayer() and !GetConVar("ai_ignoreplayers"):GetBool()) and self:GetEntTeam(ent) != self.teamowner and ent:Alive() then return true end
    end)

    local capturezonearea = self:FindInSphereCaptureZone(100,function(ent)
        if ent.ZetaFlag and ent != self and ent.IsPickedUp and ent.teamowner != self.teamowner and self:GetEntTeam(ent.Holder) == self.teamowner then return true end
    end)

    if #capturezonearea > 0 then 
        for k,v in ipairs(capturezonearea) do
            v:OnCaptured()
        end
    end

    if #surrounding > 0 and !self.IsPickedUp and self.CanBePickedUp then
        for k,v in ipairs(surrounding) do
            if v.HasFlag then continue end
            self.Holder = v
            v.HasFlag = true
            self:SetPickedUp(true)
            self.IsAtHome = false
            self:OnPickup()
        end

    end

    if IsValid(self.Holder) and self.Holder:Alive() then
        local attach
        if self.Holder.IsZetaPlayer then
            attach = self.Holder:GetBackPos()
        else
            attach = {Pos = self.Holder:GetCenteroid()+self.Holder:GetForward()*-10,Ang = self.Holder:GetAngles()+Angle(90,0,90)}
        end
        local pos = attach.Pos
        local ang = attach.Ang
        if !pos then
            local maxs = self.Holder:OBBMaxs()
            maxs[1] = 0
            maxs[2] = 0
            pos = self.Holder:GetPos()+maxs
        end
        if !ang then
            ang = Angle(0,0,-90)
        end

        timer.Remove("zetaflagreturntime"..self:EntIndex())

        self:SetNW2Int("zetaflag_returntime",-1)
        self.Curtimerepeat = 0
        self:SetPos(pos-self.Holder:GetForward()*10)
        self:SetAngles(ang+Angle(0,0,90))
    elseif self.IsPickedUp or IsValid(self.Holder) and !self.Holder:Alive() then
        self.Holder.HasFlag = false
        self.Holder = NULL
        

        if self.Holder:IsPlayer() then
            self.Holder.HasFlag = true
        end

        self:SetPickedUp(false)
        self:OnDrop()

        if !timer.Exists("zetaflagreturntime"..self:EntIndex()) then
            self.Curtimerepeat = GetConVar("zetaplayer_ctfreturntime"):GetInt()
            timer.Create("zetaflagreturntime"..self:EntIndex(),1,GetConVar("zetaplayer_ctfreturntime"):GetInt(),function()
                if !IsValid(self) then timer.Remove("zetaflagreturntime"..self:EntIndex()) return end
                self.Curtimerepeat = self.Curtimerepeat - 1
                self:SetNW2Int("zetaflag_returntime",self.Curtimerepeat)
                if self.Curtimerepeat == 0 then
                    self.IsAtHome = true
                    local mins = self:OBBMins()
                    self:SetPos(self.CaptureZone:GetPos()+Vector(0,0,15))
                    self:SetNW2Int("zetaflag_returntime",-1)
                    if GetConVar("zetaplayer_ctfflagreturn"):GetString() != "" then
                        sound.Play(GetSound(GetConVar("zetaplayer_ctfflagreturn"):GetString()),Vector(0,0,0),0,100,1)
                    end

                    if self.teamowner then
                        self:SendChatMessage(self.TeamColor,self.teamowner,color_glacier,"'s ",self.TeamColor,self.customname,color_glacier," flag has returned back to its zone!")
                    else
                        self:SendChatMessage(self.TeamColor,self.customname,color_glacier," flag has returned back to its zone!")
                    end

                end
            end)
        end
    end



    if !self.IsPickedUp then
        self.Placeholderangle.y = SysTime()*50 %360
        self:SetAngles(self.Placeholderangle)
    end


    self:NextThink(CurTime())
    return true
end
local downtracetbl = {}

function ENT:ReturnToZone()
    self.IsAtHome = true
    local mins = self:OBBMins()
    self:SetPos(self.CaptureZone:GetPos()+Vector(0,0,15))
    self:SetNW2Int("zetaflag_returntime",-1)
    if IsValid(self.Holder) then
        self.Holder.HasFlag = false
    end
    self.Holder = NULL
    self:SetPickedUp(false)
end

function ENT:OnCaptured()
    if IsValid(self.Trail) then
        self.Trail:Remove()
    end

    if self.teamowner then
        self:SendChatMessage(self:GetHolderColor(),self:GetHolderName(),color_glacier," captured ",self.TeamColor,self.teamowner,color_glacier,"'s ",self.TeamColor,self.customname,color_glacier," flag!")
    else
        self:SendChatMessage(self:GetHolderColor(),self:GetHolderName(),color_glacier," captured the ",self.TeamColor,self.customname,color_glacier," flag!")
    end

    if self.Holder.IsZetaPlayer then
        self.Holder:PlayKillSound()
    end

    if GetGlobalBool("_ZetaCTF_Gameactive", false ) then
        hook.Run("ZetaCTFOnCapture",self.teamowner,self:GetEntTeam(self.Holder))
    end

    self.IsAtHome = true
    local mins = self:OBBMins()
    self:SetPos(self.CaptureZone:GetPos()+Vector(0,0,15))
    self:SetNW2Int("zetaflag_returntime",-1)
    self.Holder.HasFlag = false
    self.Holder = NULL
    self:SetPickedUp(false)


    if !self:GetEntTeam(Entity(1)) or self:GetEntTeam(Entity(1)) == self.teamowner then
        if GetConVar("zetaplayer_ctfourflagcapturesound"):GetString() != "" then
            sound.Play(GetSound(GetConVar("zetaplayer_ctfourflagcapturesound"):GetString()),Vector(0,0,0),0,100,1)
        end
    else
        if GetConVar("zetaplayer_ctfenemyflagcapturesound"):GetString() != "" then
            sound.Play(GetSound(GetConVar("zetaplayer_ctfenemyflagcapturesound"):GetString()),Vector(0,0,0),0,100,1)
        end
    end
    


end

function ENT:OnDrop()

    downtracetbl.start = self:GetPos()
    downtracetbl.endpos = self:GetPos()-Vector(0,0,10000)
    downtracetbl.filter = self

    local downtrace = util.TraceLine(downtracetbl)
    local mins = self:OBBMins()

	self:SetPos(downtrace.HitPos - downtrace.HitNormal * mins.z)
    if self.teamowner then
        self:SendChatMessage(self.TeamColor,self.teamowner,color_glacier,"'s ",self.TeamColor,self.customname,color_glacier," flag has been dropped!")
    else
        self:SendChatMessage(self.TeamColor,self.customname,color_glacier," flag has been dropped!")
    end

    if GetConVar("zetaplayer_ctfflagdropped"):GetString() != "" then
        sound.Play(GetSound(GetConVar("zetaplayer_ctfflagdropped"):GetString()),Vector(0,0,0),0,100,1)
    end

    self.Trail:Remove()
end

function ENT:OnPickup()
    self.Trail = util.SpriteTrail(self,0,self.TeamColor,true,40,40,2,1/(40-40)*0.5,"trails/laser")
    if self.teamowner then
        self:SendChatMessage(self:GetHolderColor(),self:GetHolderName(),color_glacier," took ",self.TeamColor,self.teamowner,color_glacier,"'s ",self.TeamColor,self.customname,color_glacier," flag!")
    else
        self:SendChatMessage(self:GetHolderColor(),self:GetHolderName(),color_glacier," took the ",self.TeamColor,self.customname,color_glacier," flag!")
    end

    if !self:GetEntTeam(Entity(1)) or self:GetEntTeam(Entity(1)) == self.teamowner then
        if GetConVar("zetaplayer_ctfourflagstolensound"):GetString() != "" then
            sound.Play(GetSound(GetConVar("zetaplayer_ctfourflagstolensound"):GetString()),Vector(0,0,0),0,100,1)
        end
    else
        if GetConVar("zetaplayer_ctfenemyflagstolensound"):GetString() != "" then
            sound.Play(GetSound(GetConVar("zetaplayer_ctfenemyflagstolensound"):GetString()),Vector(0,0,0),0,100,1)
        end
    end
    if self.Holder.IsZetaPlayer then
        self.Holder:CancelMove()
    end
end

function ENT:GetHolderColor()
    return self.Holder.IsZetaPlayer and self.Holder.TeamColor or ZetaGetTeamColor(GetConVar("zetaplayer_playerteam"):GetString()) and ZetaGetTeamColor(GetConVar("zetaplayer_playerteam"):GetString()):ToColor() or color_white
end

function ENT:GetHolderName()
    return self.Holder:Name()
end

function ENT:SendChatMessage(...)
    net.Start("zeta_sendcoloredtext", true)
        net.WriteString(util.TableToJSON({...}))
    net.Broadcast()
end

function ENT:Draw()

    if !self:GetNW2Bool("zetaflag_pickedup",false) then
        local maxs = self:OBBMaxs()
        maxs[1] = 0
        maxs[2] = 0
        local pos = (self:GetPos()+maxs)+Vector(0,0,40)

        local ang = Angle(0,SysTime()*5 %360,90)

        self:Draw3dText(self:GetNW2String("zetaflag_team","Neutral"),pos,ang,0.5)

        pos = (self:GetPos()+maxs)+Vector(0,0,30)

        local addcapture = (self:GetNW2Bool("zetaflag_capturezone",false) and ": CAPTURE ZONE" or "")

        self:Draw3dText("["..self:GetNW2String("zetaflag_customname","A0").."]"..addcapture,pos,ang,0.5)

        if self:GetNW2Int("zetaflag_returntime",-1) != -1 then
            pos = (self:GetPos()+maxs)+Vector(0,0,20)
            self:Draw3dText("Returns in: "..self:GetNW2Int("zetaflag_returntime",-1),pos,ang,0.5)
            
        end
    end

    if !self:GetNW2Bool("zetaflag_capturezone",false) then
        self:DrawModel()
    end

end
