
AddCSLuaFile()

if CLIENT then
language.Add("tool.zetaflagmaker", "Flag Maker")

language.Add("tool.zetaflagmaker.name", "Flag Maker")
language.Add("tool.zetaflagmaker.desc", "Creates a flag")
language.Add("tool.zetaflagmaker.0", "Fire onto a surface to create flag")
end

TOOL.Category = "Zeta Players"
TOOL.Name = "#tool.zetaflagmaker"
TOOL.ClientConVar = {
	["teamname"] = "",
	["customname"] = "",
	["allowpickup"] = "1"
}



function TOOL:LeftClick( tr )

	local flag = ents.Create("zeta_flag")
	flag:SetPos(tr.HitPos)
	flag.teamowner = self:GetClientInfo("teamname")
	flag.customname = self:GetClientInfo("customname")
	flag.CanBePickedUp = tobool(self:GetClientNumber("allowpickup",1))
	flag:Spawn()
	local mins = flag:OBBMins()

	flag:SetPos(tr.HitPos - tr.HitNormal * mins.z)

	local spawnindex = flag:GetCreationID()
	local addname = (self:GetClientInfo("teamname") != "" and self:GetClientInfo("teamname")  or spawnindex)
	undo.Create("Zeta Flag "..addname)
		undo.SetPlayer(self:GetOwner())
		undo.AddEntity(flag)
	undo.Finish("Zeta Flag "..addname)

	self:GetOwner():AddCleanup( "sents", flag )


    return true
end

function TOOL.BuildCPanel(panel)
	panel:TextEntry("Team", "zetaflagmaker_teamname")
	panel:ControlHelp("What team this flag should belong to")

	panel:TextEntry("Custom Name", "zetaflagmaker_customname")
	panel:ControlHelp("A name for this flag")

	panel:CheckBox("Allow Pickup","zetaflagmaker_allowpickup")
	panel:ControlHelp("If this flag can be picked up. Perfect for marking capture zones")

end
