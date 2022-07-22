AddCSLuaFile()

ENT.Base = "base_anim"


local color_glace = Color(0,105,153)

function ENT:Initialize()

    self:SetModel("models/props_combine/combine_mine01.mdl")
    local teamcolor = ZetaGetTeamColor(self:GetTeamSpawn())
    self.teamcolor = teamcolor and teamcolor:ToColor() or color_glace
    self:EmitSound("zetaplayer/misc/teamspawn_init.wav")

    self:DrawShadow(false)

    if SERVER then
        self.SpawnIndex = self:GetCreationID()
        self:SetNW2Int("zetateamspawnindex",self.SpawnIndex)

        timer.Simple(0,function()
            if self:GetTeamSpawn() == "" then
                self:Remove()
                PrintMessage(HUD_PRINTTALK,"You must specify a team!")
            end
        end)
    else
        self.SpawnIndex = self:GetNW2Int("zetateamspawnindex",0)
    end



end



function ENT:Draw()
    if IsValid(LocalPlayer()) and LocalPlayer():Alive() and IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "gmod_tool" then

        local ang = Angle(0,SysTime()*100 %360,90)
        cam.Start3D2D(self:GetPos()+Vector(0,0,50), ang,0.5)
            draw.DrawText(self:GetTeamSpawn().." "..self.SpawnIndex,"ChatFont",0,0,self.teamcolor,TEXT_ALIGN_CENTER)
        cam.End3D2D()

        ang:RotateAroundAxis(Vector(0,0,1), 180)

        cam.Start3D2D(self:GetPos()+Vector(0,0,50), ang,0.5)
            draw.DrawText(self:GetTeamSpawn().." "..self.SpawnIndex,"ChatFont",0,0,self.teamcolor,TEXT_ALIGN_CENTER)
        cam.End3D2D()

        self:DrawModel()
    end


end


function ENT:GetTeamSpawn()
    return (self.teamspawn or self:GetNW2String("zetateamspawn_team",""))
end