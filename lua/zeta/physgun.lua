-----------------------------------------------
-- Physgun Functions
--- This is where Zeta's Physgun functions are
-----------------------------------------------
if CLIENT then return end
AddCSLuaFile()
function ENT:DrawBeamOn(ent)
    self.PhysgunBeamEnt = ent
    self:SetNW2Bool( 'zeta_drawphysgunbeam', true )
end

function ENT:EndDrawBeam()
    self.PhysgunBeamEnt = NULL
    self:SetNW2Bool( 'zeta_drawphysgunbeam', false )
end


function ENT:GrabEnt(ent)
    if !self:IsValid() or !IsValid(ent) then return end
    if self.Grabbing == true then return end
    if IsValid(self.GrabbedENT) then return end
    self.Grabbing = true
    self.PhysgunnedENT = ent
    self:DrawBeamOn(ent)
    self.PhysgunBeamDistance = ent:GetPos():Distance(self:GetPos())
    timer.Create('zetagrab'..self:EntIndex(),0,0,function()
    if !self:IsValid() then return end
    if !ent:IsValid() then self:EndDrawBeam() self.PhysgunnedENT = nil self.Grabbing = false timer.Remove('zetagrab'..self:EntIndex()) return end
    if IsValid(ent) and ent:IsPlayer() and !ent:Alive() then self.PhysgunnedENT = nil self.Grabbing = false timer.Remove('zetagrab'..self:EntIndex()) self:EndDrawBeam() return end
    if !self.WeaponENT:IsValid() then return end
    if self.Weapon != 'PHYSGUN' then self.PhysgunnedENT = nil self.Grabbing = false timer.Remove('zetagrab'..self:EntIndex()) return end
    if self.Grabbing == false then self.PhysgunnedENT = nil timer.Remove('zetagrab'..self:EntIndex()) return end
        -- This code below isn't actually mine believe it or not. It is from the Multi Physgun Addon.
        -- I had NO idea on where to start to do the math which would of maybe taken me many days
        -- Credit to the man he did it



        if ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot() then
           
            local dist = (self.WeaponENT:GetPos()+self.WeaponENT:GetForward()*self.PhysgunBeamDistance - ent:GetPos())

            local traceData = {
                start = ent:GetPos(),
                endpos = self.WeaponENT:GetPos()+self.WeaponENT:GetForward()*self.PhysgunBeamDistance,
                filter = ent,
                mask = MASK_NPCSOLID_BRUSHONLY
            }
            local traceResult = util.TraceEntity(traceData,ent)
            ent:SetPos(traceResult.HitPos )
        else
            if !self:IsValid() or !ent:IsValid() then self.PhysgunnedENT = nil self.Grabbing = false timer.Remove('zetagrab'..self:EntIndex()) return end
        local phys = ent:GetPhysicsObject()

        if phys:IsValid() then
            if !self:IsValid() or !ent:IsValid() then self.PhysgunnedENT = nil self.Grabbing = false timer.Remove('zetagrab'..self:EntIndex()) return end
        phys:EnableMotion(true)
        if !self:IsValid() then timer.Remove('zetagrab'..self:EntIndex()) return end
        local dist = (self.WeaponENT:GetPos()+self.WeaponENT:GetForward()*self.PhysgunBeamDistance) - ent:GetPos()
        local dir = dist:GetNormalized()
        local speed = math.min(4000/2, dist:Dot(dir) *5)*dir  +  ent:GetVelocity()*0.5
        speed = math.max(math.min(4000,speed:Dot(dir)),-1000)
        
        phys:SetVelocity((speed)*dir)

        else
            if !self:IsValid() or !ent:IsValid() then self.PhysgunnedENT = nil self.Grabbing = false timer.Remove('zetagrab'..self:EntIndex()) return end
            if !self.WeaponENT:IsValid() then timer.Remove('zetagrab'..self:EntIndex()) return end
        local traceData = {
            start = ent:GetPos(),
            endpos = self.WeaponENT:GetPos()+self.WeaponENT:GetForward()*self.PhysgunBeamDistance,
            filter = ent,
            mask = MASK_NPCSOLID_BRUSHONLY
        }
        local traceResult = util.TraceEntity(traceData,ent)
        ent:SetPos(traceResult.HitPos )
    end
end
    end)


end

---------- What to do next with physgunned object --------------

function ENT:FreezeHeldObject()
    if !self:IsValid() then return end
    if self.Grabbing != true then return end
    if !IsValid(self.PhysgunnedENT) then return end

    self:EndDrawBeam()
    self.Grabbing = false
    DebugText('PHYSGUN: Froze '..tostring(self.PhysgunnedENT))
    if IsValid(self.PhysgunnedENT:GetPhysicsObject()) then
        self.PhysgunnedENT:GetPhysicsObject():EnableMotion(false)
    end
    self.PhysgunnedENT = nil
    

end


function ENT:DropHeldObject()
    if !self:IsValid() then return end
    if !IsValid(self.PhysgunnedENT) then return end
    if self.Grabbing != true then return end

    self:EndDrawBeam()
    self.Grabbing = false
    DebugText('PHYSGUN: Dropped '..tostring(self.PhysgunnedENT))
    if IsValid(self.PhysgunnedENT:GetPhysicsObject()) then
        self.PhysgunnedENT:GetPhysicsObject():EnableMotion(true)
    end
    self.PhysgunnedENT = nil
    

end


function ENT:ThrowHeldObject()
    if !self:IsValid() then return end
    if self.Grabbing != true then return end
    if !IsValid(self.PhysgunnedENT) then return end
    if math.random(1,2) == 1 then
        self:EndDrawBeam()
        self.Grabbing = false
        local phys = self.PhysgunnedENT:GetPhysicsObject()
        DebugText('PHYSGUN: Threw '..tostring(self.PhysgunnedENT))
        if self.PhysgunnedENT:IsPlayer() then
            self.PhysgunnedENT:SetVelocity(self.WeaponENT:GetForward()*math.random(500,50000))
        end
        if IsValid(self.PhysgunnedENT) and phys:IsValid() then
            phys:EnableMotion(true)
            phys:ApplyForceCenter(self.WeaponENT:GetForward()*math.random(500,50000))
        end
        self.PhysgunnedENT = nil
    else
        self:LookAtTick(self:GetPos()+self:GetForward()*math.random(0,50)+Vector(0,0,1500),'both',200)
        DebugText('PHYSGUN: Preparing to throw '..tostring(self.PhysgunnedENT))
        timer.Simple(math.random(0.5,1.0),function()
            if !self.PhysgunnedENT then return end
            if !self:IsValid() or !self.PhysgunnedENT and !self.PhysgunnedENT:IsValid() then return end
            self:EndDrawBeam()
            self.Grabbing = false
            DebugText('PHYSGUN: Threw '..tostring(self.PhysgunnedENT))
            if self.PhysgunnedENT:IsPlayer() then
                self.PhysgunnedENT:SetVelocity(self.WeaponENT:GetForward()*math.random(500,50000))
            end
            if IsValid(phys) then
                phys:EnableMotion(true)
                phys:ApplyForceCenter(self.WeaponENT:GetForward()*math.random(500,50000))
            end
            self.PhysgunnedENT = nil

        end)

    end


end


function ENT:SlamHeldObject()
    if !self:IsValid() then return end
    if self.Grabbing != true then return end
    local a = 0

    DebugText('PHYSGUN: Slamming '..tostring(self.PhysgunnedENT))

    timer.Create('zetaslamheld'..self:EntIndex(),math.random(0.3,1),math.random(2,10),function()
        if !self.PhysgunnedENT then timer.Remove('zetaslamheld'..self:EntIndex()) return end
        if !self:IsValid() or !self.PhysgunnedENT:IsValid() then timer.Remove('zetaslamheld'..self:EntIndex()) return end
        if a > 1 then
            a = 0
        end

        if a == 0 then
            self:LookAtTick(self:GetPos()+self:GetForward()*100+Vector(0,0,500),'both',5)
        else
            self:LookAtTick(self:GetPos()+self:GetForward()*100+Vector(0,0,-500),'both',5)
        end
        a = a + 1
    end)



end

function ENT:SwingHeldObject()
    if !self:IsValid() then return end
    if self.Grabbing != true then return end
    local a = 0

    DebugText('PHYSGUN: Swinging '..tostring(self.PhysgunnedENT))
    timer.Create('zetaswingheld'..self:EntIndex(),math.random(0.3,1),math.random(2,10),function()
        if !self.PhysgunnedENT then timer.Remove('zetaswingheld'..self:EntIndex()) return end
        if !self:IsValid() or !self.PhysgunnedENT and !self.PhysgunnedENT:IsValid() then timer.Remove('zetaswingheld'..self:EntIndex()) return end
        if a > 1 then
            a = 0
        end

        if a == 0 then
            self:LookAtTick(self:GetPos()+self:GetForward()*100+self:GetRight()*500,'both',5)
        else
            self:LookAtTick(self:GetPos()+self:GetForward()*100+self:GetRight()*-500,'both',5)
        end
        a = a + 1
    end)



end



function ENT:PickupProp(ent)
    if !self:IsValid() or !IsValid(ent) then return end
    if self.Grabbing == true then return end
    if IsValid(ent:GetPhysicsObject()) and ent:GetPhysicsObject():GetMass() >= 35 then return end
    self.Grabbing = true
    self.GrabbedENT = ent
    timer.Create('zetagrab'..self:EntIndex(),0,0,function()
    if !self:IsValid() or !ent:IsValid() then self.GrabbedENT = nil self.Grabbing = false timer.Remove('zetagrab'..self:EntIndex()) return end
    if !self.WeaponENT:IsValid() then return end
    if self.Grabbing == false then self.GrabbedENT = nil timer.Remove('zetagrab'..self:EntIndex()) return end
        if self.Weapon == "PHYSGUN" then self.GrabbedENT = nil self.Grabbing = false timer.Remove('zetagrab'..self:EntIndex()) return end
        if !self:IsValid() or !ent:IsValid() then self.GrabbedENT = nil self.Grabbing = false timer.Remove('zetagrab'..self:EntIndex()) return end
        if self:GetRangeSquaredTo(ent) >= (110*110) then self.GrabbedENT = nil self.Grabbing = false timer.Remove('zetagrab'..self:EntIndex()) return end


        local attach = self:GetAttachmentPoint("eyes")

        local phys = ent:GetPhysicsObject()

        if phys:IsValid() then
            if !self:IsValid() or !ent:IsValid() then self.GrabbedENT = nil self.Grabbing = false timer.Remove('zetagrab'..self:EntIndex()) return end
            phys:EnableMotion(true)
            if !self:IsValid() then timer.Remove('zetagrab'..self:EntIndex()) return end
            local dist = (attach.Pos+attach.Ang:Forward()*60) - ent:GetPos()
            local dir = dist:GetNormalized()
            local speed = math.min(10000/2, dist:Dot(dir) *5)*dir  +  ent:GetVelocity()*0.5
            speed = math.max(math.min(10000,speed:Dot(dir)),-1000)
            
            phys:SetVelocity((speed)*dir)

        end
    end)



end

function ENT:DropHeldprop()
    if !self:IsValid() then return end
    if !IsValid(self.GrabbedENT) then return end
    if self.Grabbing != true then return end

    self.Grabbing = false
    self.GrabbedENT = nil

end

function ENT:ThrowHeldprop()
    if !self:IsValid() then return end
    if self.Grabbing != true then return end
    if !IsValid(self.GrabbedENT) then return end



        local attach = self:GetAttachmentPoint("eyes")

        if IsValid(self.GrabbedENT) and self.GrabbedENT:GetPhysicsObject():IsValid() then
            self.GrabbedENT:GetPhysicsObject():ApplyForceCenter(attach.Ang:Forward()*5000)
        end

        self.Grabbing = false
        self.GrabbedENT = nil

end