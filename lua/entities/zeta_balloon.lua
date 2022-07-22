
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName = "Balloon"



function ENT:Initialize()
    self.Force = math.random(10,2000)
	if ( CLIENT ) then return end

    local mdls = {
        'models/balloons/balloon_classicheart.mdl',
        'models/balloons/balloon_dog.mdl',
        'models/balloons/balloon_star.mdl',
        'models/maxofs2d/balloon_classic.mdl',
        'models/maxofs2d/balloon_gman.mdl',     
        'models/maxofs2d/balloon_mossman.mdl',     

    }
    local model = mdls[math.random(1,6)]
    self:SetModel(model)
    if model == 'models/maxofs2d/balloon_classic.mdl' then
        self:SetSkin(math.random(0,3))
    end
    self:SetColor(Color(math.random(0,255),math.random(0,255),math.random(0,255)))

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )

	-- Set up our physics object here
	local phys = self:GetPhysicsObject()
	if ( IsValid( phys ) ) then

		phys:SetMass( 100 )
		phys:Wake()
		phys:EnableGravity( false )

	end

	
	self:StartMotionController()

end

function ENT:GetOverlayText()
	local txt2 
	local txt = "Force: " .. tostring(self.Force) 

	if ( txt == "" ) then return "" end

	if IsValid(self:GetOwner()) then
		txt2 = self:GetOwner():GetNW2String('zeta_name','Zeta Player')
	else
		txt2 = "Couldn't Get Owner"
	end

	return txt .. "\n(" .. txt2 .. ")"

end

function ENT:OnTakeDamage( dmginfo )

	local c = self:GetColor()

	local effectdata = EffectData()
	effectdata:SetOrigin( self:GetPos() )
	effectdata:SetStart( Vector( c.r, c.g, c.b ) )
	util.Effect( "balloon_pop", effectdata )


	local attacker = dmginfo:GetAttacker()
	if ( IsValid( attacker ) && attacker:IsPlayer() ) then
		attacker:SendLua( "achievements.BalloonPopped()" )
	end

	self:Remove()

end

function ENT:PhysicsSimulate( phys, deltatime )

	local vLinear = Vector( 0, 0, self.Force * 5000 ) * deltatime
	local vAngular = vector_origin

	return vAngular, vLinear, SIM_GLOBAL_FORCE

end
