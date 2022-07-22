
AddCSLuaFile()

if CLIENT then
language.Add("tool.zetaplayerspraytool", "Zeta Sprays Tool")

language.Add("tool.zetaspraytool.name", "Zeta Sprays Tool")
language.Add("tool.zetaspraytool.desc", "Sprays a random Zeta Spray")
language.Add("tool.zetaspraytool.0", "Fire onto a surface to place a spray")
end

TOOL.Category = "Zeta Players"
TOOL.Name = "#tool.zetaplayerspraytool"



function TOOL:LeftClick( tr )
    local ent = tr.Entity
    if ent == Entity(0) then

		local images,dirs = file.Find("zetaplayerdata/custom_sprays/*","DATA","nameasc")
		if images and #images > 0 then sprayImage ="../data/zetaplayerdata/custom_sprays/"..images[math.random(#images)] end

		local isMaterial = -1
		local textures,dirs = file.Find("sourceengine/materials/zetasprays/*","BASE_PATH","nameasc")
		if textures and #textures > 0 then
			for k, v in ipairs(textures) do
				if !string.EndsWith(v, '.vtf') then table.remove(textures, k) continue end
			end
		
			if !images or #images <= 0 or math.random(1, (#images+#textures)) <= #textures then

				local matPath = 'zetasprays/'..textures[math.random(#textures)]
				sprayImage = string.Left(matPath, string.len(matPath) - 4)
				isMaterial = self:GetOwner():EntIndex() + math.random(10000, 99999)
			end
		end
		
		if sprayImage == nil then return end

        net.Start('zeta_usesprayer',true)
			net.WriteString(sprayImage) 
			net.WriteTable(tr)   
            net.WriteInt(isMaterial, 32)
		net.Broadcast()
    end



    return true
end