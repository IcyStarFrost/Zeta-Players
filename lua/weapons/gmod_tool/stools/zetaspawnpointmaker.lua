
AddCSLuaFile()

if CLIENT then

	TOOL.Information = {
		{name = "left"},
		{name = "right"}
	}

	language.Add("tool.zetaspawnpointmaker", "Team Spawn Point Maker")

	language.Add("tool.zetaspawnpointmaker.name", "Team Spawn Point Maker")
	language.Add("tool.zetaspawnpointmaker.desc", "Creates a spawn point for a specified team")
	language.Add("tool.zetaspawnpointmaker.left", "Fire onto a surface to create a spawn point")
	language.Add("tool.zetaspawnpointmaker.right", "Right click near a spawn to remove it")
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

function TOOL:FindInSphere(pos,radius,filter)
	local picked = {}
	local sphere = ents.FindInSphere(pos,radius)
	for k,v in ipairs(sphere) do
	
	   if filter(v) == true then
		 table.insert(picked,v)
	   end
	end
  
	return picked
  end

function TOOL:RightClick(tr)
	local surround = self:FindInSphere(tr.HitPos,5,function(ent)
		return IsValid(ent) and ent:GetClass() == "zeta_teamspawnpoint"
	end)

	for k,v in ipairs(surround) do
		v:Remove()
	end

	return true
end



function TOOL.BuildCPanel(panel)

	local teamfile = file.Read("zetaplayerdata/teams.json")

	if teamfile then
		teamfile = util.JSONToTable(teamfile)
		local box = panel:ComboBox("Team","zetaspawnpointmaker_team")

		for k,v in ipairs(teamfile) do
			box:AddChoice(v[1],v[1])
		end

		local refresh = vgui.Create("DButton")
		panel:AddItem(refresh)
		refresh:SetText("Refresh Team List")

		function refresh:DoClick()
			box:Clear()

			local teamfile = util.JSONToTable(file.Read("zetaplayerdata/teams.json"))

			for k,v in ipairs(teamfile) do
				box:AddChoice(v[1],v[1])
			end
		end



	end
	panel:ControlHelp("The team that should use this spawn point")
	
end