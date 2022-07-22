AddCSLuaFile()

if CLIENT then
language.Add("tool.zetaeyetapper", "Eye Tapper")

TOOL.Information = {

    { name = "0" },
    { name = "reload" },

}

language.Add("tool.zetaeyetapper.name", "Eye Tapper")
language.Add("tool.zetaeyetapper.desc", "See through the eyes of a Zeta")
language.Add("tool.zetaeyetapper.0", "Fire onto a Zeta to see through what it sees. Jump to return your view back to normal")
language.Add("tool.zetaeyetapper.reload", "Press your reload key to eye tap a random zeta")
end

TOOL.Category = "Zeta Players"
TOOL.Name = "#tool.zetaeyetapper"




function TOOL:LeftClick( tr )
    local ent = tr.Entity
    if !IsValid(ent) then return end
    if ent:GetClass() != "npc_zetaplayer" then return end

    hook.Add("KeyPress","zetaeyetap_abort",function(ply,key)
        if key == IN_JUMP then
            hook.Remove("KeyPress","zetaeyetap_abort")
            hook.Remove("SetupPlayerVisibility","zetaeyetap_PVS")
        end
    end)

    hook.Add("SetupPlayerVisibility","zetaeyetap_PVS",function(ply,viewent)
        if IsValid(ent) then
            AddOriginToPVS(ent:GetPos())
        else
            hook.Remove("KeyPress","zetaeyetap_abort")
            hook.Remove("SetupPlayerVisibility","zetaeyetap_PVS")
        end
    end)

    net.Start("zetaplayer_eyetap",true)
        net.WriteEntity(ent)
    net.Send(self:GetOwner())

    return true
end

function TOOL:Reload()

    local zetas = ents.FindByClass("npc_zetaplayer")
    local zeta = NULL 
    for k,v in RandomPairs(zetas) do
        if IsValid(v) then
            zeta = v
            break
        end
    end

    hook.Add("KeyPress","zetaeyetap_abort",function(ply,key)
        if key == IN_JUMP then
            hook.Remove("KeyPress","zetaeyetap_abort")
            hook.Remove("SetupPlayerVisibility","zetaeyetap_PVS")
        end
    end)

    hook.Add("SetupPlayerVisibility","zetaeyetap_PVS",function(ply,viewent)
        if IsValid(zeta) then
            AddOriginToPVS(zeta:GetPos())
        else
            hook.Remove("KeyPress","zetaeyetap_abort")
            hook.Remove("SetupPlayerVisibility","zetaeyetap_PVS")
        end
    end)

    net.Start("zetaplayer_eyetap",true)
        net.WriteEntity(zeta)
    net.Send(self:GetOwner())

    return true
end
