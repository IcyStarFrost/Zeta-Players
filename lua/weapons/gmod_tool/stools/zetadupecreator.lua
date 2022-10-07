
AddCSLuaFile()

if SERVER then
    util.AddNetworkString("zetadupecreator_enablecopybox")
    util.AddNetworkString("zetadupecreator_updatepanel")

end

if CLIENT then

    TOOL.Information = {
		{name = "left"},
		{name = "reload"}
	}


    language.Add("tool.zetadupecreator", "Dupe Creator")

    language.Add("tool.zetadupecreator.name", "Dupe Creator")
    language.Add("tool.zetadupecreator.desc", "Creates a Duplication File in the zetaplayerdata/duplications folder")
    language.Add("tool.zetadupecreator.left", "Fire onto a contraption to create a dupe file")
    language.Add("tool.zetadupecreator.reload", "Toggles Area Copy mode")

    net.Receive("zetadupecreator_enablecopybox",function()
        LocalPlayer().zetaDupeBoxCopyEnabled = !LocalPlayer().zetaDupeBoxCopyEnabled
    end)
end

TOOL.Category = "Zeta Players"
TOOL.Name = "#tool.zetadupecreator"

TOOL.ClientConVar = {
    ["copysize"] = "1000",
    ["renderthroughworld"] = "0"
}

local characters = {"a","b","c","d","e","f","g","h","i","1","2","3","4","5","6","7","8","9","0"}

function TOOL:LeftClick( tr )
    if CLIENT then return end


    if !self:GetOwner().zetaDupeBoxCopyEnabled then

        local ent = tr.Entity
        if !IsValid(ent) then return end

        local ownangles = self:GetOwner():EyeAngles()
        ownangles[1] = 0
        ownangles[3] = 0

        duplicator.SetLocalPos(tr.HitPos)
        duplicator.SetLocalAng(ownangles)

        local dupedata = duplicator.Copy(tr.Entity)

        duplicator.SetLocalPos(Vector(0,0,0))
        duplicator.SetLocalAng(Angle(0,0,0))

        local json = util.TableToJSON(dupedata)

        local compressed = util.Compress(json)

        local filename = ""

        for i=1,32 do
            filename = filename..characters[math.random(#characters)]
        end


        file.Write("zetaplayerdata/duplications/"..filename..".json",compressed)

        

        net.Start("zetaplayer_createdupeicon")
            net.WriteString( "zetaplayerdata/duplications/"..filename..".json" )
            net.WriteString(filename)
        net.Send(Entity(1))

        self:GetOwner():PrintMessage(HUD_PRINTTALK,"Created Duplication file in zetaplayerdata/"..filename..".json")

        self:GetOwner().zetaLastCopiedDupe = filename

        net.Start("zetadupecreator_updatepanel")
        net.WriteString(filename)
        net.Send(Entity(1))

    else

        local size = self:GetClientNumber("copysize",1000)
        local maxs = LocalToWorld(Vector(size,size,size),Angle(0,0,0),tr.HitPos,Angle(0,0,0))
        local mins = LocalToWorld(Vector(-size,-size,-size),Angle(0,0,0),tr.HitPos,Angle(0,0,0))


        local areacopy = ents.FindInBox(mins,maxs)
        
        for k,v in ipairs(areacopy) do
            if !duplicator.IsAllowed(v:GetClass()) or !IsValid(v:GetPhysicsObject()) then areacopy[k] = nil end
        end

        if table.IsEmpty(areacopy) then return end

        duplicator.SetLocalPos(tr.HitPos)
        duplicator.SetLocalAng(Angle(0,self:GetOwner():EyeAngles().y,0))

        local copieddata = duplicator.CopyEnts( areacopy )

        duplicator.SetLocalPos(Vector(0,0,0))
        duplicator.SetLocalAng(Angle(0,0,0))



        local json = util.TableToJSON(copieddata)

        local compressed = util.Compress(json)

        local filename = ""

        for i=1,32 do
            filename = filename..characters[math.random(#characters)]
        end

        

        file.Write("zetaplayerdata/duplications/"..filename..".json",compressed)

        

        net.Start("zetaplayer_createdupeicon")
            net.WriteString( "zetaplayerdata/duplications/"..filename..".json" )
            net.WriteString(filename)
        net.Send(Entity(1))

        self:GetOwner():PrintMessage(HUD_PRINTTALK,"Created Duplication file in zetaplayerdata/"..filename..".json")

        self:GetOwner().zetaDupeBoxCopyEnabled = !self:GetOwner().zetaDupeBoxCopyEnabled 
        net.Start("zetadupecreator_enablecopybox")
        net.Send(self:GetOwner())

        self:GetOwner().zetaLastCopiedDupe = filename

        net.Start("zetadupecreator_updatepanel")
        net.WriteString(filename)
        net.Send(Entity(1))

    end

    return true
end

function TOOL:Think()
    if SERVER then
        
    else

        if self:GetOwner().zetaDupeBoxCopyEnabled then
            
            hook.Add("PostDrawOpaqueRenderables","zetadupecreatorBoxRender"..self:GetOwner():EntIndex(),function()

                local size = self:GetClientNumber("copysize",1000)
                local pos = self:GetOwner():GetEyeTrace().HitPos
                render.DrawWireframeBox( pos, Angle(0,0,0), Vector(-size,-size,-size), Vector(size,size,size), color_white, tobool(self:GetClientNumber("renderthroughworld",0)) )

                local maxs = LocalToWorld(Vector(size,size,size),Angle(0,0,0),pos,Angle(0,0,0))
                local mins = LocalToWorld(Vector(-size,-size,-size),Angle(0,0,0),pos,Angle(0,0,0))
        
        
                self.primedents = ents.FindInBox(mins,maxs)

                for k,v in ipairs(self.primedents) do
                    if !IsValid(v) then continue end
                    

                    v:SetColor(Color(0,255,0))

                    timer.Create("zetadupeselectedents"..v:EntIndex(),0.1,0,function() if !IsValid(v) then return end v:SetColor(Color(255,255,255)) end)

                end
            
            end)

        else
            hook.Remove("PostDrawOpaqueRenderables","zetadupecreatorBoxRender"..self:GetOwner():EntIndex())

        end

    end
end

function TOOL:Holster()
    self:GetOwner().zetaDupeBoxCopyEnabled = false

    if CLIENT then

        hook.Remove("PostDrawOpaqueRenderables","zetadupecreatorBoxRender"..self:GetOwner():EntIndex())
    end
end

function TOOL:Reload()
    self:GetOwner().zetaDupeBoxCopyEnabled = !self:GetOwner().zetaDupeBoxCopyEnabled 
    net.Start("zetadupecreator_enablecopybox")
    net.Send(self:GetOwner())
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

    local lastdupe

    local lastdupeimg

    local dupeoptionspanel

    local renameentry

    local deletebutton

    local filenamelabel 




    panel:CheckBox("Area Copy Write Z","zetadupecreator_renderthroughworld")
    panel:ControlHelp("If the Area copy box should render through the world or not")

    panel:NumSlider("Area Copy Size","zetadupecreator_copysize",10,20000)
    panel:ControlHelp("The distance entities should be copied")

    panel:Help("\n\n")


    lastdupeimg = vgui.Create("DImage",panel)
    lastdupeimg:SetSize(400,400)
    panel:AddItem(lastdupeimg)

    dupeoptionspanel = vgui.Create("EditablePanel",panel)
    dupeoptionspanel:SetSize(20,20)
    panel:AddItem(dupeoptionspanel)

    panel:Help("\n\n")


    net.Receive( "zetadupecreator_updatepanel", function() 
        lastdupe = net.ReadString()

        local mat = Material("../data/zetaplayerdata/duplications/"..lastdupe..".jpg")

        if IsValid( renameentry ) then
            renameentry:Remove()
        end

        if IsValid( deletebutton ) then
            deletebutton:Remove()
        end

        if IsValid( filenamelabel ) then
            filenamelabel:Remove()
        end

        if mat:IsError() then

            InitializeCoroutineThread(function() 
                
                while mat:IsError() do
                    mat = Material("../data/zetaplayerdata/duplications/"..lastdupe..".jpg")

                    coroutine.wait(0.4)
                end

                lastdupeimg:SetMaterial(mat)

            end)

        end

        timer.Simple(0.1,function()

            renameentry = vgui.Create("DTextEntry",dupeoptionspanel)
            renameentry:SetPlaceholderText(lastdupe)
            renameentry:Dock(LEFT)

            deletebutton = vgui.Create("DButton",dupeoptionspanel)
            deletebutton:SetText("Delete File")
            deletebutton:Dock(RIGHT)

            filenamelabel = vgui.Create("DLabel",dupeoptionspanel)
            filenamelabel:SetText("File Name: "..lastdupe)
            filenamelabel:Dock(BOTTOM)

            function renameentry:OnEnter(val)
                if val == "" then return end

                file.Delete("zetaplayerdata/duplications/"..val..".json")
                file.Delete("zetaplayerdata/duplications/"..val..".jpg")

                file.Rename("zetaplayerdata/duplications/"..lastdupe..".json","zetaplayerdata/duplications/"..val..".json")
                file.Rename("zetaplayerdata/duplications/"..lastdupe..".jpg","zetaplayerdata/duplications/"..val..".jpg")
                surface.PlaySound("buttons/button15.wav")

                local mat = Material("../data/zetaplayerdata/duplications/"..val..".jpg")

                filenamelabel:SetText("File Name: "..val)
                lastdupe = val

                lastdupeimg:SetMaterial(mat)
                panel:InvalidateLayout() 
            end

            function deletebutton:DoClick()

                file.Delete("zetaplayerdata/duplications/"..lastdupe..".json")
                file.Delete("zetaplayerdata/duplications/"..lastdupe..".jpg")

                if IsValid( renameentry ) then
                    renameentry:Remove()
                end
        
                if IsValid( deletebutton ) then
                    deletebutton:Remove()
                end

                if IsValid( filenamelabel ) then
                    filenamelabel:Remove()
                end

                surface.PlaySound("buttons/button9.wav")

                lastdupeimg:SetImage("nil")
                panel:InvalidateLayout() 
            end

            lastdupeimg:SetMaterial(mat)

            panel:InvalidateLayout() 
        end)

    end)
    
    
end
