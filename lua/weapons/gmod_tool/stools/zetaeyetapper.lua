AddCSLuaFile()

if CLIENT then
    language.Add("tool.zetaeyetapper", "Eye Tapper")

    TOOL.Information = {
        { name = "left" },
        { name = "right" },
        { name = "reload" }
    }

    language.Add("tool.zetaeyetapper.name", "Eye Tapper")
    language.Add("tool.zetaeyetapper.desc", "See through the eyes of a Zeta")

    language.Add("tool.zetaeyetapper.left", "Fire onto a Zeta to see through what it sees. Jump to return your view back to normal")
    language.Add("tool.zetaeyetapper.right", "Press this while viewing to switch between camera modes")
    language.Add("tool.zetaeyetapper.reload", "Press your reload key to eye tap a random zeta")
end

TOOL.Category = "Zeta Players"
TOOL.Name = "#tool.zetaeyetapper"

TOOL.LastRandomZeta = NULL

function TOOL:InitializeEyeTap(zeta)
    hook.Add("KeyPress", "zetaeyetap_abort", function(ply, key)
        if key != IN_JUMP then return end
        hook.Remove("KeyPress", "zetaeyetap_abort")
        hook.Remove("SetupPlayerVisibility", "zetaeyetap_PVS")
    end)

    local lastPos = zeta:GetPos()
    hook.Add("SetupPlayerVisibility","zetaeyetap_PVS", function(ply, viewent)
        if IsValid(zeta) then lastPos = zeta:GetPos() end
        AddOriginToPVS(lastPos)
    end)

    net.Start("zetaplayer_eyetap", true)
        net.WriteEntity(zeta)
    net.Send(self:GetOwner())
end

function TOOL:LeftClick(tr)
    self.LastRandomZeta = NULL
    local ent = tr.Entity
    if !IsValid(ent) or ent:GetClass() != "npc_zetaplayer" then return end
    self.LastRandomZeta = ent
    self:InitializeEyeTap(ent)
    return true
end

function TOOL:Reload()
    local rndZeta = NULL 
    for _, v in RandomPairs(ents.FindByClass("npc_zetaplayer")) do
        if IsValid(v) and v != self.LastRandomZeta then rndZeta = v break end
    end
    self.LastRandomZeta = rndZeta
    if !IsValid(rndZeta) then return false end
    self:InitializeEyeTap(rndZeta)
    return true
end
