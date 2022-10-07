
AddCSLuaFile()

if CLIENT then
language.Add("tool.zetaplayerdebugtool", "Debug Info")

language.Add("tool.zetadebugtool.name", "Debug Info")
language.Add("tool.zetadebugtool.desc", "Prints debug info of the target Zeta")
language.Add("tool.zetadebugtool.0", "Fire onto a Zeta to print its info in Console")
end

TOOL.Category = "Zeta Players"
TOOL.Name = "#tool.zetaplayerdebugtool"


local function printpersonality(ent)

    print("\n\n---- PERSONALITY SETTINGS ----\n\n")
        print("Build chance = ",ent.BuildChance)
        print("Combat chance = ",ent.CombatChance)
        print("Tool chance = ",ent.ToolChance)
        print("Physgun chance = ",ent.PhysgunChance)
        print("Disrespect chance = ",ent.DisrespectChance)
        print("Media Watch chance = ",ent.WatchMediaPlayerChance)
        print("Friendly chance = ",ent.FriendlyChance)
        print("Voice chance = ",ent.VoiceChance)
        print("Vehicle chance = ",ent.VehicleChance)
        print("Text chance = ",ent.TextChance)
    print("\n\n------------------------\n\n")

end

function TOOL:LeftClick( tr )
    local ent = tr.Entity
    if !IsValid(ent) then return end
    if ent:GetClass() != "npc_zetaplayer" then return end

    self:GetOwner():PrintMessage(HUD_PRINTTALK,"Printed Info of "..ent.zetaname.." in Console")

    
    print("--------- Zeta Debug ---------")
    print("Zeta Name = ",ent.zetaname,"\n")
    print("Ent Index = ",ent:EntIndex(),"\n")
    print("Zeta Weapon ENT = ",ent.WeaponENT,"\n")
    print("Profile Picture = ",ent.ProfilePicture,"\n")
    if ent.HasProperAttachment then
        print("This Zeta has proper attachments for their hand","\n")
    else
        print("This Zeta does not have the proper attachments for their hand. Currently using the fall backs","\n")
    end

    print("Conversation Partner = ",ent.ConversePartner,"\n")

    print("Zeta State = ",ent.State,"\n")

    print("Last State = ",ent.LastState,"\n")

    print("Zeta Weapon = ",ent.Weapon,"\n")

    print("Zeta Accuracy Value = ",ent.Accuracy,"\n")

    print("Zeta Enemy = ",ent.Enemy,"\n")

    print("Friend List -- --\n")
    for _,v in pairs(ent.Friends) do
        
        print((v.IsZetaPlayer and v.zetaname or v:GetName())," Their Creation ID is "..v:GetCreationID())
    end
    print("\nEnd friend List -- --\n")

    print("Vehicle = ",ent.Vehicle,"\n")

    print("Personality = ",ent.Personality,"\n")

    print("Voice Pack = ",(ent.VoicePack != "none" and ent.VoicePack or "None"),"\n")

    print("Is Natural = ",ent.IsNatural,"\n")

    print(ent.zetaTeam and "This zeta is a member of, "..ent.zetaTeam.."\n" or "This Zeta is not in any team\n")

    print("Is Speaking = ",ent.IsSpeaking,"\n")

    print( "Is Climbing a Ladder = ", ent.IsClimbingLadder or false, "\n" )

    print("Can Speak = ",ent.AllowVoice,"\n")
    
    print("DATA METHOD\n",ent.UsingSERVERCACHE and "This Zeta is using the SERVER Cache for its data\n" or "This Zeta is using its own data")

    print("\n\n--- Zeta State Trace backs ---\n\n")

    PrintTable(ent.LastStateTraces)
    
    print("------------------")

    printpersonality(ent)

    return true
end