
AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName = "Dynamite"

function ENT:Initialize()



	if ( SERVER ) then
        local mdls = {
            'models/dynamite/dynamite.mdl',
            'models/dav0r/tnt/tnttimed.mdl',
            'models/dav0r/tnt/tnt.mdl',
        }
        self:SetModel(mdls[math.random(1,3)])
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
        local dmg = math.random(10,500)
        local delay = math.random(1,60)
        local delete 
        if math.random(1,2) == 1 then
            delete = true
        else
            delete = false
        end
        self:SetNW2Int("zetadynamite_delay",delay)
        self:SetNW2Int("zetadynamite_dmg",dmg)
        self:SetNW2Bool("zetadynamite_delete",delete)
        self:Explode(delay,delete)
	end

end


function ENT:GetOverlayText()
    local txt2
	local txt = string.format( "Damage: %g\nDelay: %g",  self:GetNW2Int("zetadynamite_dmg",math.random(10,500)), self:GetNW2Int("zetadynamite_delay",math.random(0,60)) )

    if IsValid(self:GetOwner()) then
		txt2 = self:GetOwner():GetNW2String('zeta_name','Zeta Player')
	else
		txt2 = "Couldn't Get Owner"
	end

	return txt .. "\n(" .. txt2 .. ")"

end

function ENT:OnTakeDamage( dmginfo )

	if ( dmginfo:GetInflictor():GetClass() == "gmod_dynamite" ) then return end

	self:TakePhysicsDamage( dmginfo )

end

--
-- Blow that mother fucker up, BAATCHH
--
function ENT:Explode(somedelay,shoulddelete)

	if ( !IsValid( self ) ) then return end

	local _delay =  somedelay or self:GetNW2Int("zetadynamite_delay",math.random(0,60))

	if ( _delay == 0 ) then

		local radius = 300

		if IsValid(self:GetOwner()) then
			util.BlastDamage( self, self:GetOwner(), self:GetPos(), radius, self:GetNW2Int("zetadynamite_dmg",math.random(10,500)) )
		else
			util.BlastDamage( self, self, self:GetPos(), radius, self:GetNW2Int("zetadynamite_dmg",math.random(10,500)) )
		end

		local effectdata = EffectData()
		effectdata:SetOrigin( self:GetPos() )
        self:EmitSound("BaseExplosionEffect.Sound")
		util.Effect( "Explosion", effectdata, true, true )
        if shoulddelete then if IsValid(self) then self:Remove() return end return end
		if ( self:GetMaxHealth() > 0 && self:Health() <= 0 ) then self:SetHealth( self:GetMaxHealth() ) end
        self:Explode(self:GetNW2Int("zetadynamite_delay",math.random(0,60)))
	else

		timer.Simple( _delay, function() if ( !IsValid( self ) ) then return end self:Explode( 0,self:GetNW2Bool("zetadynamite_delete",true) ) end )

	end

end
