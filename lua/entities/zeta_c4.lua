AddCSLuaFile()

ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.PrintName = "Zeta C4 Plastic Explosive"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PrintName = 'Zeta C4 Plastic Explosive'
ENT.IsZetaC4 = true


function ENT:Initialize()
    if CLIENT then return end

    self:SetModel("models/weapons/w_c4.mdl")
    self:SetColor(self:GetCreator():GetPlayerColor():ToColor())

    self:PhysicsInit(SOLID_VPHYSICS)

    self:SetUseType(SIMPLE_USE )

    local phys = self:GetPhysicsObject()

    if IsValid(phys) then
        phys:SetMass(1)
        phys:Wake()
    end

    self.currentcur = 2
    self.Cur = CurTime()+self.currentcur
    self.Armed = false

    self:EmitSound("zetaplayer/weapon/c4/c4_plant_quiet.wav",65)
end

function ENT:Think()
    if CLIENT then return end
    if self.Armed then return end

    if self.currentcur <= 0 then
        self.Armed = true
        self:EmitSound("zetaplayer/weapon/c4/nvg_on.wav",110)

        timer.Simple(math.Rand(0,1),function()
            for k,v in ipairs(ents.FindInSphere(self:GetPos(), 2500)) do
                local cansee = util.TraceLine({
                    start = self:GetPos()+self:OBBCenter(),
                    endpos = v:GetPos()+v:OBBCenter(),
                    filter = self
                })
                if v.IsZetaPlayer and cansee.Entity == v then
                    v:Panic(self)
                end
            end
        end)
        
        timer.Simple(1,function()
            if !IsValid(self) then return end
            self:EmitSound("zetaplayer/weapon/c4/arm_bomb.wav",110)
        end)

        timer.Simple(2,function()
            if !IsValid(self) then return end
            ParticleEffect( "explosion_huge", self:GetPos(),Angle(0,0,0) )
            util.BlastDamage(self,IsValid(self:GetCreator()) and self:GetCreator() or self,self:GetPos()+Vector(0,0,10),2500,1000)
            util.ScreenShake(self:GetPos(),50,100,4,5400)
            sound.Play("zetaplayer/weapon/c4/explode_6.wav",self:GetPos(),100,100,1)
            sound.Play("ambient/explosions/explode_2.wav",self:GetPos(),100,100,1)

            local downtrace = util.TraceLine({
                start = self:GetPos(),
                endpos = self:GetPos()-Vector(0,0,100),
                collisiongroup = COLLISION_GROUP_DEBRIS
            })
            net.Start("zeta_createc4decal",true)
                net.WriteTable(downtrace)
            net.Broadcast()


            if GetConVar("zetaplayer_c4debris"):GetInt() == 1 then
                local debris = {
                    "models/props_debris/concrete_chunk01a.mdl",
                    "models/props_debris/concrete_chunk01b.mdl",
                    "models/props_debris/concrete_chunk01c.mdl",
                    "models/props_debris/concrete_chunk02a.mdl",
                    "models/props_debris/concrete_chunk02b.mdl",
                    "models/props_debris/concrete_chunk06c.mdl",
                    "models/props_debris/concrete_chunk06d.mdl",
                    "models/props_debris/concrete_chunk08a.mdl",
                    "models/props_debris/walldestroyed08a.mdl",
                    "models/props_debris/concrete_floorpile01a.mdl",
                    "models/props_debris/concrete_section128wall001c.mdl",
                    "models/props_debris/concrete_wall01a.mdl",
                    "models/props_debris/plaster_ceilingpile001b.mdl",
                    "models/props_debris/plaster_ceilingpile001a.mdl",
                    "models/props_debris/plaster_ceilingpile001c.mdl"
                }


                for i=1, math.random(3,16) do
                    local concrete = ents.Create("prop_physics")
                    concrete:SetModel(debris[math.random(#debris)])
                    concrete:SetPos(self:GetPos()+Vector(math.random(-100,100),math.random(-100,100),100))
                    concrete:SetAngles(AngleRand(-180,180))
                    concrete.IsZetaProp = true
                    concrete:Spawn()

                    concrete:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
                    concrete:Ignite(math.random(5,30))
                    concrete:SetLocalAngularVelocity(AngleRand(-500,500))
                    local phys = concrete:GetPhysicsObject()

                    if IsValid(phys) then
                        phys:SetMass(60)
                        phys:ApplyForceCenter(VectorRand(-800000,800000))
                    end

                    timer.Simple(45,function()
                        if IsValid(concrete) then
                            concrete:Remove()
                        end
                    end)

                end
            end



            self:Remove()
        end)
    else
        if CurTime() > self.Cur then

            self:EmitSound("zetaplayer/weapon/c4/c4_click.wav",70)
            
            self.currentcur = self.currentcur - 0.1
            self.Cur = CurTime()+self.currentcur
        end
    end

end

function ENT:OnTakeDamage(dmginfo)
    self:TakePhysicsDamage(dmginfo)
end