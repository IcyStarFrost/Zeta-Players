
AddCSLuaFile()

if CLIENT then
language.Add("tool.zetaprofilecreator", "Profile Creator")

language.Add("tool.zetaprofilecreator.name", "Profile Creator")
language.Add("tool.zetaprofilecreator.desc", "Creates a Profile from a Zeta")
language.Add("tool.zetaprofilecreator.0", "Fire onto a Zeta to create a profile of it")
end

TOOL.Category = "Zeta Players"
TOOL.Name = "#tool.zetaprofilecreator"


function TOOL:LeftClick( tr )
    local ent = tr.Entity
    if !IsValid(ent) then return end
    if ent:GetClass() != "npc_zetaplayer" then return end

    local profileDATA = {}

    profileDATA["name"] = ent.zetaname
    profileDATA["avatar"] = string.Explode("custom_avatars/",ent.ProfilePicture)[2] or ent:GetModel()
    profileDATA["playermodel"] = ent:GetModel()
    
    if ent.IsAdmin then
        profileDATA["admindata"] = {}

        profileDATA["admindata"]["isadmin"] = ent.IsAdmin
        profileDATA["admindata"]["strictness"] = ent.Strictness
    end



    profileDATA["playermodelcolor"] = isvector(ent.PlayermodelColor) and ent.PlayermodelColor:ToColor() or ent.PlayermodelColor


    profileDATA["physguncolor"] = isvector(ent.PhysgunColor) and ent.PhysgunColor:ToColor() or ent.PhysgunColor


    profileDATA["accuracylevel"] = ent.Accuracy
    
    profileDATA["mingebag"] = ent.IsMingebag


    local bodygroups = {}

    for k = 0, ent:GetNumBodyGroups() - 1 do
        if ( ent:GetBodygroupCount( k ) <= 1 ) then continue end
            table.insert(bodygroups,{ent:GetBodygroup( k ),k})
    end

    profileDATA["bodygroups"] = bodygroups

    profileDATA["skin"] = ent:GetSkin()

    if ent.VoicePack != "none" then
        profileDATA["voicepack"] = ent.VoicePack
    end

    profileDATA["voicepitch"] = ent.VoicePitch

    
    profileDATA["usecustomidle"] = ent.UseCustomIdle
    profileDATA["usecustomdeath"] = ent.UseCustomDeath
    profileDATA["usecustomkill"] = ent.UseCustomKill
    profileDATA["usecustomtaunt"] = ent.UseCustomTaunt
    profileDATA["usecustompanic"] = ent.UseCustomPanic
    profileDATA["usecustomassist"] = ent.UseCustomAssist
    profileDATA["usecustomlaugh"] = ent.UseCustomLaugh
    profileDATA["usecustomwitness"] = ent.UseCustomWitness
    profileDATA["usecustomadminscold"] = ent.UseCustomAdminScold
    profileDATA["usecustomFalling"] = ent.UseCustomFalling
    profileDATA["usecustomSitRespond"] = ent.UseCustomSitRespond
    profileDATA["usecustomQuestion"] = ent.UseCustomQuestion
    profileDATA["usecustomConRespond"] = ent.UseCustomConRespond
    profileDATA["usecustomMediaWatch"] = ent.UseCustomMediaWatch
    


    profileDATA["personality"] = {}

    profileDATA["personality"]["build"] = ent.BuildChance
    profileDATA["personality"]["tool"] = ent.CombatChance
    profileDATA["personality"]["combat"] = ent.ToolChance
    profileDATA["personality"]["physgun"] = ent.PhysgunChance
    profileDATA["personality"]["disrespect"] = ent.DisrespectChance
    profileDATA["personality"]["watchmedia"] = ent.WatchMediaPlayerChance
    profileDATA["personality"]["friendly"] = ent.FriendlyChance
    profileDATA["personality"]["voice"] = ent.VoiceChance
    profileDATA["personality"]["vehicle"] = ent.VehicleChance
    profileDATA["personality"]["text"] = ent.TextChance
        


    CreateZetaProfile(profileDATA)

    self:GetOwner():PrintMessage(HUD_PRINTTALK,"Created a Profile for, "..ent.zetaname)


    return true
end