
AddCSLuaFile()

if CLIENT then
language.Add("tool.zetaspawnpointmaker", "Team Spawn Point Maker")

language.Add("tool.zetaspawnpointmaker.name", "Team Spawn Point Maker")
language.Add("tool.zetaspawnpointmaker.desc", "Creates a spawn point for a specified team")
language.Add("tool.zetaspawnpointmaker.0", "Fire onto a surface to create a spawn point")
end

TOOL.Category = "Zeta Players"
TOOL.Name = "#tool.zetaspawnpointmaker"
TOOL.ClientConVar = {
	["team"] = ""
}



function TOOL:LeftClick( tr )

	local spawn = ents.Create("zeta_teamspawnpoint")
	spawn:SetPos(tr.HitPos)
	spawn.teamspawn = self:GetClientInfo("team")
	spawn:SetNW2String("zetateamspawn_team",self:GetClientInfo("team"))
	spawn:Spawn()

	local spawnindex = spawn:GetCreationID()

	undo.Create("Zeta Team Spawn {"..self:GetClientInfo("team").." "..spawnindex.."}")
		undo.SetPlayer(self:GetOwner())
		undo.AddEntity(spawn)
	undo.Finish("Zeta Team Spawn {"..self:GetClientInfo("team").." "..spawnindex.."}")
	self:GetOwner():AddCleanup( "sents", spawn )
    return true
end



function TOOL.BuildCPanel(panel)
	panel:TextEntry("Team", "zetaspawnpointmaker_team")
	panel:ControlHelp("The team that should use this spawn point")
	
end