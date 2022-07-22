AddCSLuaFile()

ENT.Base = "base_anim"

local util = util
local ents = ents
local math = math 
local IsValid = IsValid
local keynames = {"A","B","C","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}
local color_glacier = Color(130, 164, 192)
local vec_white = Vector(1,1,1)
function ENT:Initialize()


    self:SetModel("models/props_combine/CombineThumper002.mdl")
    self:SetModelScale(0.3)
    self.Captured = false 
    self.CapturedOwner = "neutral"
    self.Capturingowner = "none"
    self.Captureperc = 0
    self.OldColor = vec_white

    self.TeamScores = {}
    self.NextPoint = CurTime()

    if SERVER then
        self.Identity = keynames[math.random(#keynames)]..self:GetCreationID()
        if self.Overridename then
            self.Identity = self.Overridename
        end
        self:SetNW2String("zetakoth_identity",self.Identity)
    end

    self.funclimit = false
    self.funclimit2 = false
    self.TeamColor = vec_white
    self:SetNW2Vector("zetakoth_color",self.TeamColor)

end

function ENT:GetCapturerTeam(ent)
    return ent.IsZetaPlayer and (ent.zetaTeam or ent.zetaname or ent:GetNW2String("zeta_name","neutral")) or (GetConVar("zetaplayer_playerteam"):GetString() != "" and GetConVar("zetaplayer_playerteam"):GetString() or ent:Name())
end

function ENT:IsContested()
    local capturearea = ents.FindInSphere(self:GetPos(), 500)
    local curteam 
    for k,v in ipairs(capturearea) do
        if IsValid(v) and (v.IsZetaPlayer or v:IsPlayer() and !GetConVar("ai_ignoreplayers"):GetBool()) then
            if !curteam then
                curteam = v.zetaTeam
            else
                if v.zetaTeam != curteam then
                    return true
                end
            end
        end


    end


    return false
end

function ENT:OnBeingCaptured()
    if SERVER then
        PrintMessage(HUD_PRINTTALK,"Being captured")
    end
end

function ENT:SendChatMessage(...)
    net.Start("zeta_sendcoloredtext", true)
        net.WriteString(util.TableToJSON({...}))
    net.Broadcast()
end

function ENT:OnCapture()
    self.TeamColor = ZetaGetTeamColor(self.CapturedOwner) or vec_white
    self:SetNW2Vector("zetakoth_color",self.TeamColor)

    self:EmitSound("zetaplayer/koth/captured.wav",100)
    self:EmitSound("zetaplayer/koth/pointcap.wav",65)

    self:SendChatMessage(color_glacier,"[",self.OldColor:ToColor(),self.Identity,color_glacier,"]"," has been captured by ",self.TeamColor:ToColor(),self.CapturedOwner)

    local surrounding = self:FindInSphere(500,function(ent)
        if IsValid(ent) and ent.IsZetaPlayer and self:GetCapturerTeam(ent) == self.CapturedOwner then return true end
    end)

    for k,v in ipairs(surrounding) do
        timer.Simple(math.Rand(0,1),function()
            if !IsValid(v) then return end
            v:PlayKillSound()
        end)
    end
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

function ENT:IncrementCapturePercent(num,sub)
    if !sub then
        self.Captureperc = math.Clamp((self.Captureperc + num), 0, 100) 
        self:SetNW2Int("zetakoth_captureperc",math.Round(self.Captureperc,0))
    else
        self.Captureperc = math.Clamp((self.Captureperc - num), 0, 100)
        self:SetNW2Int("zetakoth_captureperc",math.Round(self.Captureperc,0))
    end
end

function ENT:IsOwner(ent)
    return self:GetCapturerTeam(ent) == self.CapturedOwner
end

local canseetracetbl = {}


function ENT:CanSee(ent)
  if !IsValid(ent) then return end
  local pos
  if ent:IsPlayer() then
    pos = ent:GetPos()+ent:OBBCenter()+Vector(0,0,5)
  else
    pos = ent:GetPos()+ent:OBBCenter()
  end
  canseetracetbl.start = self:GetPos()+self:OBBCenter()
  canseetracetbl.endpos = pos
  canseetracetbl.filter = self
  local lostest = util.TraceLine(canseetracetbl)
  if lostest.Entity == ent then
    return true
  elseif isfunction(lostest.Entity.GetDriver) and lostest.Entity:GetDriver() == ent then
    return true
  end

  return false
end

function ENT:RestoretoNeutral()
    self.Captured = false
    self.CapturedOwner = "neutral"

    self.TeamScores = {}
    self:SetNW2String("zetkoth_owner","neutral")
    self.OldColor = vec_white
    self.TeamColor = vec_white
    self.Captureperc = 0
    self:SetNW2Int("zetakoth_captureperc",math.Round(self.Captureperc,0))
    self:SetNW2Vector("zetakoth_color",Vector(1,1,1))
end

function ENT:Think()
    if CLIENT then return end
    local capturearea = self:FindInSphere(500,function(ent)
        if IsValid(ent) and (ent.IsZetaPlayer or ent:IsPlayer() and !GetConVar("ai_ignoreplayers"):GetBool()) and !self:IsContested() and self:CanSee(ent) then return true end
    end)

    if #capturearea > 0 then
        
        for k,v in ipairs(capturearea) do
            
            if !self:IsOwner(v) and self.Captured then
                self:IncrementCapturePercent(GetConVar("zetaplayer_kothcapturerate"):GetFloat(),true)
                
                if self.Captureperc <= 0 then
                    self.Captured = false
                    self.CapturedOwner = "neutral"
                    self:SetNW2String("zetkoth_owner","neutral")
                    self.OldColor = self.TeamColor
                    self.TeamColor = vec_white
                    self.Captureperc = 0
                    self:SetNW2Int("zetakoth_captureperc",math.Round(self.Captureperc,0))
                    self:SetNW2Vector("zetakoth_color",Vector(1,1,1))
                    self:EmitSound("zetaplayer/koth/holdlost.wav",100)
                    self:EmitSound("zetaplayer/koth/pointneutral.wav",65)
                    self:SendChatMessage(color_glacier,"[",self.OldColor:ToColor(),self.Identity,color_glacier,"]"," was brought to neutral")
                end
                
            else

                if self:IsOwner(v) and self.Captureperc < 100 and self.Captured and self:GetCapturerTeam(v) == self.CapturedOwner then
                    self:IncrementCapturePercent(GetConVar("zetaplayer_kothcapturerate"):GetFloat())
                end
                

                if !self:IsOwner(v) and self.Captureperc < 100 and !self.Captured then
                    self:IncrementCapturePercent(GetConVar("zetaplayer_kothcapturerate"):GetFloat())
                elseif !self:IsOwner(v) and self.Captureperc >= 100 and !self.Captured then
                    self.Captured = true
                    self.Captureperc = 100
                    self.CapturedOwner = self:GetCapturerTeam(v)
                    self:SetNW2String("zetkoth_owner",self.CapturedOwner)
                    self:OnCapture()
                end

            end

        end

    end

    if GetGlobalBool("_ZetaKOTH_Gameactive") and self.Captured and CurTime() > self.NextPoint then
        if !self.TeamScores[self.CapturedOwner] then
            self.TeamScores[self.CapturedOwner] = 0
            
        end
        self.NextPoint = CurTime()+0.3

        self.TeamScores[self.CapturedOwner] = self.TeamScores[self.CapturedOwner] + 1
    end

    self:NextThink(0.05)
    return true
end

function ENT:Draw3dText(text,pos,ang,scale)
    if SERVER then return end

    local col = self:GetNW2Vector("zetakoth_color",Vector(1,1,1)):ToColor()
        

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

function ENT:Draw()


    local ang = Angle(0,SysTime()*20 %360,90)
    self:Draw3dText("[MARKER "..self:GetNW2String("zetakoth_identity","A0").."] "..self:GetNW2String("zetkoth_owner","neutral"),self:GetPos()+Vector(0,0,100),ang,0.5)

    self:Draw3dText(tostring(self:GetNW2Int("zetakoth_captureperc",0)),self:GetPos()+Vector(0,0,110),ang,0.5)


    self:DrawModel()

end
