
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName = "Lamp"
ENT.Editable = true
ENT.Textures = {
    "effects/flashlight/bars",
    "effects/flashlight/gradient",
    "effects/flashlight/hard",
    "effects/flashlight/caustics",
    "effects/flashlight/logo",
    "effects/flashlight001",
    "effects/flashlight/tech",
    "effects/flashlight/soft",
    "effects/flashlight/slit",
    "effects/flashlight/square",
    "effects/flashlight/circles",
    "effects/flashlight/window",



}
ENT.lampmodels = {
    "models/lamps/torch.mdl",
    "models/maxofs2d/lamp_flashlight.mdl",
    "models/maxofs2d/lamp_projector.mdl"

}


-- Custom drive mode
function ENT:GetEntityDriveMode()

	return "drive_noclip"

end

function ENT:Initialize()

	if ( SERVER ) then

        self:SetModel(self.lampmodels[math.random(#self.lampmodels)])

		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow( false )

        self:TurnOn()
        


		local phys = self:GetPhysicsObject()
		if ( IsValid( phys ) ) then phys:Wake() end

	end

	if ( CLIENT ) then

		self.PixVis = util.GetPixelVisibleHandle()

	end

end

if ( SERVER ) then


	function ENT:OnTakeDamage( dmginfo )

		self:TakePhysicsDamage( dmginfo )

	end

	function ENT:Use( activator, caller )
	end

	function ENT:Switch( bOn )
		self:SetOn( bOn )
	end

	function ENT:TurnOn()


		self.flashlight = ents.Create( "env_projectedtexture" )
		self.flashlight:SetParent( self )

		-- The local positions are the offsets from parent..
		self.flashlight:SetLocalPos( vector_origin )
		self.flashlight:SetLocalAngles( angle_zero )

		self.flashlight:SetKeyValue( "enableshadows", 0 )
		self.flashlight:SetKeyValue( "nearz", 12 )
		self.flashlight:SetKeyValue( "lightfov", math.random(10,170) ) 

		local dist = math.random(64,2048) 
		self.flashlight:SetKeyValue( "farz", dist )

		local c = ColorRand()
		local b = math.Rand(0.0,8.0)
		self.flashlight:SetKeyValue( "lightcolor", Format( "%i %i %i 255", c.r * b, c.g * b, c.b * b ) )

		self.flashlight:Spawn()
        local texture = self.Textures[math.random(#self.Textures)]

		self.flashlight:Input( "SpotlightTexture", NULL, NULL, texture )

	end


    return
end


-- Show the name of the player that spawned it..
function ENT:GetOverlayText()
	if IsValid(self:GetOwner()) then
		return self:GetOwner():GetNW2String("zeta_name","Zeta Player")
	else
		return "Couldn't Get Owner"
	end
	 
end

local matLight = Material( "sprites/light_ignorez" )
--local matBeam = Material( "effects/lamp_beam" )
function ENT:DrawEffects()

	-- No glow if we're not switched on!


	local LightNrm = self:GetAngles():Forward()
	local ViewNormal = self:GetPos() - EyePos()
	local Distance = ViewNormal:Length()
	ViewNormal:Normalize()
	local ViewDot = ViewNormal:Dot( LightNrm * -1 )
	local LightPos = self:GetPos() + LightNrm * 5

	-- glow sprite
	--[[
	render.SetMaterial( matBeam )

	local BeamDot = BeamDot = 0.25

	render.StartBeam( 3 )
		render.AddBeam( LightPos + LightNrm * 1, 128, 0.0, Color( r, g, b, 255 * BeamDot) )
		render.AddBeam( LightPos - LightNrm * 100, 128, 0.5, Color( r, g, b, 64 * BeamDot) )
		render.AddBeam( LightPos - LightNrm * 200, 128, 1, Color( r, g, b, 0) )
	render.EndBeam()
	--]]

	if ( ViewDot >= 0 ) then

		render.SetMaterial( matLight )
		local Visibile = util.PixelVisible( LightPos, 16, self.PixVis )

		if ( !Visibile ) then return end

		local Size = math.Clamp( Distance * Visibile * ViewDot * 2, 64, 512 )

		Distance = math.Clamp( Distance, 32, 800 )
		local Alpha = math.Clamp( ( 1000 - Distance ) * Visibile * ViewDot, 0, 100 )
		local Col = self:GetColor()
		Col.a = Alpha

		render.DrawSprite( LightPos, Size, Size, Col )
		render.DrawSprite( LightPos, Size * 0.4, Size * 0.4, Color( 255, 255, 255, Alpha ) )

	end

end

-- We have to do this to ensure DrawTranslucent is called for Opaque only models to draw our effects
ENT.RenderGroup = RENDERGROUP_BOTH
function ENT:DrawTranslucent( flags )
	BaseClass.DrawTranslucent( self, flags )
	self:DrawEffects()
end

