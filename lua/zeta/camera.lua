-----------------------------------------------
-- Camera Functions
--- Some camera functions
-----------------------------------------------
AddCSLuaFile()

if ( CLIENT ) then








elseif ( SERVER ) then
    
function ENT:RequestViewShot()
    if GetConVar("zetaplayer_allowzetascreenshots"):GetInt() == 1 then
        net.Start('zeta_requestviewshot')
        net.WriteEntity(self)
        net.SendPVS(self:GetPos()+self:OBBCenter())
    end

end

function ENT:UseCamera()

    self:EmitSound("npc/scanner/scanner_photo1.wav",80)
    if GetConVar("zetaplayer_drawcameraflashing"):GetInt() == 0 then return end
    effectdata = EffectData()
    effectdata:SetOrigin( self:GetPos() )
    util.Effect( "camera_flash", effectdata, true )

end




end