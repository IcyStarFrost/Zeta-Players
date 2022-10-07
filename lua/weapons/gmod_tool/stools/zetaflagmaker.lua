
AddCSLuaFile()

if CLIENT then

	TOOL.Information = {
		{name = "left"},
		{name = "right"}
	}

language.Add("tool.zetaflagmaker", "Flag Maker")

language.Add("tool.zetaflagmaker.name", "Flag Maker")
language.Add("tool.zetaflagmaker.desc", "Creates a flag")
language.Add("tool.zetaflagmaker.left", "Fire onto a surface to create flag")
language.Add("tool.zetaflagmaker.right", "Fire near a flag or capture zone to remove it")
end

TOOL.Category = "Zeta Players"
TOOL.Name = "#tool.zetaflagmaker"
TOOL.ClientConVar = {
	["teamname"] = "",
	["customname"] = "",
	["allowpickup"] = "1",
	["custommodel"] = "",
}



function TOOL:LeftClick( tr )

	local flag = ents.Create("zeta_flag")
	flag:SetPos(tr.HitPos)
	flag.teamowner = self:GetClientInfo("teamname")
	flag.customname = self:GetClientInfo("customname")
	flag.CanBePickedUp = tobool(self:GetClientNumber("allowpickup",1))
	flag.custommodel = self:GetClientInfo("custommodel") != "" and self:GetClientInfo("custommodel") or nil
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
		return IsValid(ent) and ent:GetClass() == "zeta_flag" or IsValid(ent) and ent._ZetaCaptureZone
	end)

	for k,v in ipairs(surround) do
		if v._ZetaCaptureZone then
			v.Flagowner:Remove()
		else
			v:Remove()
		end
	end

	return true
end

function TOOL.BuildCPanel(panel)

	local teamfile = file.Read("zetaplayerdata/teams.json")

	if teamfile then
		teamfile = util.JSONToTable(teamfile)
		local box = panel:ComboBox("Team","zetaflagmaker_teamname")

		for k,v in ipairs(teamfile) do
			box:AddChoice(v[1],v[1])
		end

		box:AddChoice("Neutral","")

		local refresh = vgui.Create("DButton")
		panel:AddItem(refresh)
		refresh:SetText("Refresh Team List")

		function refresh:DoClick()
			box:Clear()

			local teamfile = util.JSONToTable(file.Read("zetaplayerdata/teams.json"))

			for k,v in ipairs(teamfile) do
				box:AddChoice(v[1],v[1])
			end
			
			box:AddChoice("Neutral","")
		end



	end
	panel:ControlHelp("The team that should use this spawn point")

	panel:TextEntry("Custom Name", "zetaflagmaker_customname")
	panel:ControlHelp("A name for this flag")

	panel:TextEntry("Custom Model", "zetaflagmaker_custommodel")
	panel:ControlHelp("A custom model for this flag. Leave blank for default")
	

	panel:CheckBox("Allow Pickup","zetaflagmaker_allowpickup")
	panel:ControlHelp("If this flag can be picked up. Perfect for marking capture zones")

end
