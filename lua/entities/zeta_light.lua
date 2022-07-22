
-----------------------------------------------
-- Light
--- This is the only way I could think of allowing the Zetas to use lights without it being a complicated mess
-----------------------------------------------


AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName = "Light"


local MODEL = Model( "models/maxofs2d/light_tubular.mdl" )


function ENT:Initialize()

	if ( CLIENT ) then

		self.PixVis = util.GetPixelVisibleHandle()
        self.Red = math.random(0,255)
        self.Green = math.random(0,255)
        self.Blue = math.random(0,255)
        self.LightSize = math.random(200,1024)
        self.Brightness = math.random(1,6)

	end

	if ( SERVER ) then --lights are rolling around even though the model isn't round!!

		self:SetModel( MODEL )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow( false )

		local phys = self:GetPhysicsObject()

		if ( IsValid( phys ) ) then
			phys:Wake()
		end

	end

end

function ENT:OnTakeDamage( dmginfo )
	-- React to physics damage
	self:TakePhysicsDamage( dmginfo )
end


function ENT:Think()

	self.BaseClass.Think( self )

	if ( CLIENT ) then


		
		local dlight = DynamicLight( self:EntIndex(), noworld )

		if ( dlight ) then

			local c = self:GetColor()

			local size = self.LightSize
			local brght = self.Brightness


			dlight.Pos = self:GetPos()
			dlight.r = self.Red
			dlight.g = self.Green
			dlight.b = self.Blue
			dlight.Brightness = self.Brightness
			dlight.Decay = size * 5
			dlight.Size = self.LightSize
			dlight.DieTime = CurTime() + 1

			
            

		end

	end

end

function ENT:GetOverlayText()
	local txt2
	if IsValid(self:GetOwner()) then
		txt2 = self:GetOwner():GetNW2String('zeta_name','Zeta Player')
	else
		txt2 = "Couldn't Get Owner"
	end

	return txt2
end

local matLight = Material( "sprites/light_ignorez" )
function ENT:DrawEffects()

	

	local LightPos = self:GetPos()

	local Visibile = util.PixelVisible( LightPos, 4, self.PixVis )
	if ( !Visibile || Visibile < 0.1 ) then return end

	local c = self:GetColor()
	local Alpha = 255 * Visibile
	local up = self:GetAngles():Up()

	render.SetMaterial( matLight )
	render.DrawSprite( LightPos - up * 2, 8, 8, Color( 255, 255, 255, Alpha ) )
	render.DrawSprite( LightPos - up * 4, 8, 8, Color( 255, 255, 255, Alpha ) )
	render.DrawSprite( LightPos - up * 6, 8, 8, Color( 255, 255, 255, Alpha ) )
	render.DrawSprite( LightPos - up * 5, 64, 64, Color( c.r, c.g, c.b, 64 ) )

end

-- We have to do this to ensure DrawTranslucent is called for Opaque only models to draw our effects
ENT.RenderGroup = RENDERGROUP_BOTH
function ENT:DrawTranslucent( flags )
	BaseClass.DrawTranslucent( self, flags )
	self:DrawEffects()
end
