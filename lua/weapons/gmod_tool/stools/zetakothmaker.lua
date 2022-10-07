
AddCSLuaFile()

if CLIENT then

	TOOL.Information = {
		{name = "left"},
		{name = "right"}
	}

language.Add("tool.zetakothmaker", "King of the Hill Marker")

language.Add("tool.zetakothmaker.name", "King of the Hill Marker")
language.Add("tool.zetakothmaker.desc", "Marks a spot for King of the Hill")
language.Add("tool.zetakothmaker.left", "Fire onto a surface to mark a KOTH spot")
language.Add("tool.zetakothmaker.right", "Fire near a marker to remove it")
end

TOOL.Category = "Zeta Players"
TOOL.Name = "#tool.zetakothmaker"
TOOL.ClientConVar = {
	["pointname"] = ""
}



function TOOL:LeftClick( tr )

	local spawn = ents.Create("zeta_koth")
	spawn:SetPos(tr.HitPos)
	spawn.Overridename = self:GetClientInfo("pointname") != "" and self:GetClientInfo("pointname") or nil
	spawn:Spawn()

	local spawnindex = spawn:GetCreationID()
	local addname = (self:GetClientInfo("pointname") != "" and self:GetClientInfo("pointname")  or spawnindex)
	undo.Create("Zeta KOTH Marker "..addname)
		undo.SetPlayer(self:GetOwner())
		undo.AddEntity(spawn)
	undo.Finish("Zeta KOTH Marker "..addname)

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
		return IsValid(ent) and ent:GetClass() == "zeta_koth"
	end)

	for k,v in ipairs(surround) do
		v:Remove()
	end

	return true
end

function TOOL.BuildCPanel(panel)
	panel:TextEntry("Point Name", "zetakothmaker_pointname")
	panel:ControlHelp("The name of this KOTH Marker")
	
end
