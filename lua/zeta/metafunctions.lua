AddCSLuaFile()

local zetamath = {}
zetamath.random = math.random

local util = util

local Vect = FindMetaTable( 'Vector' )
local Angl = FindMetaTable( 'Angle' )
local Entmeta = FindMetaTable('Entity')
local plymeta = FindMetaTable( "Player" )


function plymeta:CanBeFriendsWith( ent )
  local count = 0
  local maxfriendcount = GetConVar("zetaplayer_friendamount"):GetInt()

  self.Friends = self.Friends or {}

  if istable(ent.Friends) then
    for _,v in pairs(ent.Friends) do
      if IsValid( v ) then
        count = count + 1
      end
    end
  end

  for _,v in pairs( self.Friends ) do
    
    if IsValid(v) then

      count = count + 1

    end

  end 

  return count < maxfriendcount
end


function Entmeta:GetCenteroid()
  return (self:GetPos() + self:OBBCenter())
end

function Entmeta:Disintegrate()
  if !self:IsValid() then return end
  local effect = EffectData()
  effect:SetOrigin(self:GetPos()+self:OBBCenter())
  effect:SetEntity(self)
  util.Effect('entity_remove',effect,true,true)
  sound.Play('zetaplayer/misc/zetadisintegrate'..zetamath.random(1,3)..'.wav', self:GetPos(), 52)
  for i=1, self:GetPhysicsObjectCount() do
    local phys = self:GetPhysicsObjectNum(i)
    if IsValid(phys) then
      phys:ApplyForceCenter(Vector(0,0,700))
      phys:EnableGravity(false)
    end
  end
  timer.Simple(1.5,function()
    if !self:IsValid() then return end
    local effect = EffectData()
    effect:SetOrigin(self:GetPos()+self:OBBCenter())
    effect:SetMagnitude(3)
    effect:SetScale(2)
    effect:SetRadius(4)
    util.Effect('Sparks',effect,true,true)
    
    local effect = EffectData()
    effect:SetOrigin(self:GetPos()+self:OBBCenter())

    util.Effect('cball_explode',effect,true,true)
    sound.Play('zetaplayer/misc/zetadisappear.wav', self:GetPos(), 52)
    if GetConVar("zetaplayer_explosivecorpsecleanup"):GetInt() == 1 then
      util.BlastDamage( self, self, self:GetPos(), 250, zetamath.random(1,500) )
      if CLIENT then
        net.Start('zeta_csragdollexplode', true)
          net.WriteVector(self:GetPos())
        net.SendToServer()
      end

      local effectdata = EffectData()
      effectdata:SetOrigin( self:GetPos() )
      self:EmitSound("BaseExplosionEffect.Sound")
      util.Effect( "Explosion", effectdata, true, true )
  end
    self:Remove()
  end)
end

function Entmeta:Dissolve()
  if !self:IsValid() then return end
  local disintegrator  = ents.Create('env_entity_dissolver')
  if not IsValid(disintegrator) then return end
  self:SetName("disintegratortarget "..self:GetClass()..self:EntIndex())
  
  disintegrator:SetKeyValue("target", self:GetName())
  disintegrator:SetKeyValue("dissolvetype", tostring(zetamath.random(0,2)))
  disintegrator:Fire("dissolve")
  disintegrator:Remove()
end


function Entmeta:MoveMouth(weight)
	if !self:IsValid() then return end

	local jaw_drop = self:GetFlexIDByName( "jaw_drop" )
	if jaw_drop then
		self:SetFlexWeight( jaw_drop, weight )
	end
	local lmouth_drop = self:GetFlexIDByName( "left_mouth_drop" )
	if lmouth_drop then
		self:SetFlexWeight( lmouth_drop, weight )
	end
	local rmouth_drop = self:GetFlexIDByName( "right_mouth_drop" )
	if rmouth_drop then
		self:SetFlexWeight( rmouth_drop, weight )
	end

end

function Entmeta:AttemptGiveWeapons()
  local npcList = list.Get('NPC')
  local npcData = npcList[self:GetClass()]
  if npcData != nil and npcData.Weapons != nil then
    local wepTbl = npcData.Weapons
    self:SetKeyValue('additionalequipment', wepTbl[zetamath.random(#wepTbl)])
    return
  end

  if self:GetClass() == 'npc_combine_s' then
    local weapon = {'weapon_ar2','weapon_smg1'}
    self:SetKeyValue('additionalequipment',weapon[zetamath.random(2)])
  end

  if self:GetClass() == 'npc_metropolice' then
    local weapon = {'weapon_stunstick','weapon_smg1','weapon_pistol'}
    self:SetKeyValue('additionalequipment',weapon[zetamath.random(3)])
  end

  if self:GetClass() == 'npc_citizen' then
    local weapon = {'weapon_smg1','weapon_pistol','weapon_shotgun','weapon_ar2'}
    self:SetKeyValue('additionalequipment',weapon[zetamath.random(4)])
  end

  if self:GetClass() == 'npc_alyx' then
    self:SetKeyValue('additionalequipment','weapon_alyxgun')
  end

  if self:GetClass() == 'npc_barney' then
    local weapon = {'weapon_ar2','weapon_smg1'}
    self:SetKeyValue('additionalequipment',weapon[zetamath.random(2)])
  end
  

end


function Vect:SetX(num)
  local vec = Vector(num,self.y,self.z)
  return vec
end

function Vect:SetY(num)
  local vec = Vector(self.x,num,self.z)
  return vec
end

function Vect:SetZ(num)
  local vec = Vector(self.x,self.y,num)
  return vec
end

function Angl:SetP(num)
  local ang = Angle(num,self.y,self.r)
  return ang
end

function Angl:SetY(num)
  local ang = Angle(self.p,num,self.r)
  return ang
end

function Angl:SetR(num)
  local ang = Angle(self.p,self.y,num)
  return ang
end

