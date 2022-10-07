
AddCSLuaFile()

if CLIENT then
language.Add("tool.zetaplayerspraytool", "Zeta Sprays Tool")

TOOL.Information = {
	{name = "left"},
	{name = "right"}
}

language.Add("tool.zetaspraytool.name", "Zeta Sprays Tool")
language.Add("tool.zetaspraytool.desc", "Sprays a random Zeta Spray")
language.Add("tool.zetaspraytool.left", "Fire onto a surface to place a spray")
language.Add("tool.zetaspraytool.right", "Fire onto a surface to place the spray you selected in the spawn menu")
end

TOOL.Category = "Zeta Players"
TOOL.Name = "#tool.zetaplayerspraytool"

if SERVER then
	util.AddNetworkString("zetasprays_changeactivespray")
	net.Receive("zetasprays_changeactivespray",function(len,ply)
		local spray = net.ReadString()
		ply.zetaSelectedSpray = spray
		ply.zetaSelectedSprayIsTexture = net.ReadBool()
	end)
end


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

function TOOL:RightClick(tr)
	local owner = self:GetOwner()

	if !owner.zetaSelectedSpray then return false end

	local ent = tr.Entity
    if ent == Entity(0) then

        net.Start('zeta_usesprayer',true)
			net.WriteString(owner.zetaSelectedSpray) 
			net.WriteTable(tr)   
            net.WriteInt(owner.zetaSelectedSprayIsTexture and self:GetOwner():EntIndex() + math.random(10000, 99999) or -1, 32)
		net.Broadcast()

	end

	return true
end

local function InitializeCoroutineThread(func,warnend)
	local thread = coroutine.create(func)
	local id = math.random(1000000)
	hook.Add("Think","zetacoroutineengine"..id,function()
		if coroutine.status(thread) != "dead" then
			coroutine.resume(thread)
		else
			hook.Remove("Think","zetacoroutineengine"..id)
			if warnend then
				print("Coroutine Thread was returned!")    
			end
		end
	end)
end

function TOOL.BuildCPanel( panel )

	panel:Help("Click on a image to select it. Right click on a surface to paste the image.\n")
	local percent = 0
	local generatingimages = panel:Help("Generating Spray Images.. "..percent.."% done")

	local sprays = file.Find( "zetaplayerdata/custom_sprays/*", "DATA" )

	local textures,dirs = file.Find("sourceengine/materials/zetasprays/*.vtf","BASE_PATH","nameasc")

	table.Add(sprays, textures)

	if #sprays > 0 then
		InitializeCoroutineThread( function()
			for i=1, #sprays do
				
				
				
				local img = sprays[ i ]
				local imagepath
				local mat

				local isMaterial = string.EndsWith(img, ".vtf")

				if isMaterial then
					local matPath = 'zetasprays/'..img
					imagepath = string.Left(matPath, string.len(matPath) - 4)
					local sprayIndex = LocalPlayer():EntIndex() + math.random(10000, 99999)

					mat = CreateMaterial('zetaSpray'..sprayIndex, 'UnlitGeneric', {
						['$basetexture'] = imagepath,
						['$translucent'] = 1,
						['Proxies'] = {
							['AnimatedTexture'] = {
								['animatedTextureVar'] = '$basetexture',
								['animatedTextureFrameNumVar'] = '$frame',
								['animatedTextureFrameRate'] = 10
							}
						}
					})

				else
					imagepath = "../data/zetaplayerdata/custom_sprays/"..img
					mat = Material(imagepath)
				end
				

				local button = vgui.Create( "DImageButton", panel )
				button:SetSize( 512 ,512 )
				button:SetMaterial( mat )
				

				function button:DoClick()
					surface.PlaySound( "buttons/combine_button1.wav" )
					net.Start("zetasprays_changeactivespray")
					net.WriteString(imagepath)
					net.WriteBool(isMaterial)
					net.SendToServer()
				end
				if i != #sprays then
					percent = math.Round( ( i / #sprays ) * 100,0 )
					generatingimages:SetText("Generating Spray Images.. "..percent.."% done")
				else
					generatingimages:SetText("Finished Generating All Images!")
				end

				panel:AddItem(button)
				panel:InvalidateLayout()
				coroutine.wait(0.05)
			end

		end)
	end
end