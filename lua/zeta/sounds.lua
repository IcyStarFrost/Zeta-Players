-----------------------------------------------
-- Sounds 
--- This is where Zeta's Voice functions are held
-----------------------------------------------
AddCSLuaFile()

ENT.DSteps_ConVar = GetConVar('zetaplayer_allowdstepssupport')
ENT.DSteps_Function = DSteps
ENT.DSteps_WhichFoot = 1

function ENT:EmitStepSound(level, volume)
    if !self.CanPlayFootstep or !self:IsOnGround() then return end
    local stepTrace = util.TraceLine({start = self:GetPos()+self:OBBCenter(),endpos = self:GetPos()-self:GetUp()*100000,filter = self})
    local stepsnd = self:GetStepSound(stepTrace.MatType)
    if !isstring(stepsnd) then stepsnd = self:GetStepSound(MAT_DEFAULT) end
    if self.DSteps_ConVar:GetBool() and self.DSteps_Function then
        self:DSteps_Function(self:GetPos(), self.DSteps_WhichFoot, stepsnd, volume)
        self.DSteps_WhichFoot = (self.DSteps_WhichFoot == 1 and 2 or 1)
    else
        self:EmitSound(stepsnd, level, pitchPercent, volume)
    end
end

--test
function ENT:ZetaPlayVoiceSound(sndName, callRemove, stopPlaying)
	if stopPlaying and (self.IsSpeaking == true or self.AllowVoice == false) then return end
	self.IsSpeaking = true

    local sndPitch = self.VoicePitch
    local sndDur = SoundDuration(sndName) * (100 / sndPitch)

	net.Start('zeta_voiceicon',true)
		net.WriteEntity(self)
		net.WriteFloat(sndDur)
	net.Broadcast()

    local stopPlaying = (stopPlaying == nil and true or stopPlaying)
	local zetaID = self:GetCreationID()
    if self.ZetaSpawnerID != nil then zetaID = self.ZetaSpawnerID end
	if !stopPlaying then
		net.Start("zeta_removevoicepopup",true)
			net.WriteInt(zetaID,32)
		net.Broadcast()
	end


	if GetConVar("zetaplayer_allowvoicepopup"):GetInt() == 1 then
		net.Start("zeta_voicepopup",true)
			net.WriteString(self.zetaname)
			net.WriteString(self.ProfilePicture)
			net.WriteFloat(sndDur)
			net.WriteInt(zetaID,32)
		net.Broadcast()
	end

	local sndLvl = self:GetCurrentVoiceSNDLEVEL()
	if GetConVar("zetaplayer_usenewvoicechatsystem"):GetInt() == 1 then
		local sndFlags = (sndLvl != 0) and '3d ' or ''
		net.Start("zeta_playvoicesound", true)
			net.WriteEntity(self)                       // Zeta Player
			net.WriteInt(zetaID,32)                     // Creation ID
			net.WriteString('sound/'..sndName)         	// Sound Path
			net.WriteString(sndFlags..'mono')   		// Sound Flags (adding 'mono' makes audiofiles with stereo play in-game without converting it to mono)
			net.WriteBool(stopPlaying)                  // Should sound stop playing when Zeta is deleted? Set to false when playing death sounds
            net.WriteInt(sndPitch,32)
		net.Broadcast()
	else
		self:EmitSound(sndName, sndLvl, sndPitch, GetConVar('zetaplayer_voicevolume'):GetFloat(), CHAN_AUTO, 0, self.VoiceDSP)
		if callRemove != nil and string.len(callRemove) > 0 then self:CallOnRemove(callRemove, function() self:StopSound(sndName) end) end
	end

	timer.Simple(sndDur, function() 
		if !self:IsValid() then return end 
		if callRemove != nil and string.len(callRemove) > 0 then self:RemoveCallOnRemove(callRemove) end
		self.IsSpeaking = false 
	end)

    return sndDur
end







function ENT:SayQuestion() -- Say a question. It may be answered of there is another Zeta
    if self.IsSpeaking == true then return end
    if self.AllowVoice == false then return end

    local dur
    local rnd = math.random(1,31)
    if rnd > 9 then
        local snd = 'vo/npc/male01/question'..rnd..'.wav'
        
        dur = self:ZetaPlayVoiceSound(snd, "zetacallremovequestion"..self:EntIndex(), true)

        
    elseif rnd < 10 then
        local snd = 'vo/npc/male01/question0'..rnd..'.wav'
        
        dur = self:ZetaPlayVoiceSound(snd, "zetacallremovequestion"..self:EntIndex(), true)
    end

    return dur
end


function ENT:Respond() -- Respond to someone else's question
    if self.IsSpeaking == true then return end
    if self:GetState() == 'chasemelee' then return end
    if self.AllowVoice == false then return end
    

    local rnd = math.random(1,40)
    if rnd > 9 then
        local snd = 'vo/npc/male01/answer'..rnd..'.wav'
        
        self:ZetaPlayVoiceSound(snd, "zetacallremoverespond"..self:EntIndex(), true)
    elseif rnd < 10 then
        local snd = 'vo/npc/male01/answer0'..rnd..'.wav'
        
        self:ZetaPlayVoiceSound(snd, "zetacallremoverespond"..self:EntIndex(), true)
    end


end

function ENT:PlayDeathSound()
    if !GetConVar('zetaplayer_allowdeathvoice'):GetBool() then return end
    local snd = "vo/k_lab/kl_ahhhh.wav"
    if self.DEATHVOICEPACKEXISTS then
        snd = "zetaplayer/custom_vo/"..self.VoicePack.."/".."death/death"..math.random(self.DeathSoundCount)..".wav"
    elseif GetConVar('zetaplayer_usealternatedeathsounds'):GetBool() then
        local rnd = math.random(79 + self.DeathSoundCount)
        if self.UseCustomDeath or rnd > 79 or !self.Permafriend and GetConVar("zetaplayer_customdeathlinesonly"):GetBool() or self.Permafriend and GetConVar("zetaplayer_friendcustomdeathlinesonly"):GetBool() then
            snd = "zetaplayer/custom_vo/death/death"..math.random(self.DeathSoundCount)..".wav"
        else
            snd = 'zetaplayer/vo/death/atlternatedeath'..rnd..'.wav'
        end
    end
    self:ZetaPlayVoiceSound(snd, '', false)
end


function ENT:PlayWitnessSound(victim) -- Feel horror after witnessing someone getting murdered
    DebugText('DeathWitness: Attempt to play witness sound')
    if GetConVar('zetaplayer_allowwitnesssounds'):GetInt() == 0 then return end
    if self.IsSpeaking == true then return end
    if self.AllowVoice == false then return end
            DebugText('DeathWitness: playing witness sounds')        

            
            timer.Simple(math.random(0.0,1.0),function()
                if !self:IsValid() then return end

                if self.WITNESSVOICEPACKEXISTS then
                    snd = "zetaplayer/custom_vo/"..self.VoicePack.."/witness/witness"..math.random(self.WitnessSoundCount)..".wav"
                    self:ZetaPlayVoiceSound(snd, "zetastopwitnesssound"..self:EntIndex())
                else
                    local rnd = math.random(1,#self.WitnessSNDS+self.WitnessSoundCount)
                    local snd
                    if GetConVar("zetaplayer_customwitnesslinesonly"):GetInt() == 1 or GetConVar("zetaplayer_friendcustomwitnesslinesonly"):GetInt() == 1 and self.Permafriend or self.UseCustomWitness then
                        snd = "zetaplayer/custom_vo/witness/witness"..math.random(self.WitnessSoundCount)..".wav"
                    else
                        if rnd > #self.WitnessSNDS then
                            snd = "zetaplayer/custom_vo/witness/witness"..math.random(self.WitnessSoundCount)..".wav"
                        else
                            snd = self.WitnessSNDS[rnd]
                        end
                    end
                    
                    self:ZetaPlayVoiceSound(snd, "zetastopwitnesssound"..self:EntIndex())
                end
            end)
       
    end


function ENT:PlayKillSound()
    if GetConVar('zetaplayer_allowkillvoice'):GetInt() == 0 then return end
    if self.IsSpeaking == true then return end
    if self.AllowVoice == false then return end

            timer.Simple(math.random(0.0,0.5),function()
                if !self:IsValid() then return end

                
                if self.KILLVOICEPACKEXISTS then
                    snd = "zetaplayer/custom_vo/"..self.VoicePack.."/".."kill/kill"..math.random(self.KillSoundCount)..".wav"
                    self:ZetaPlayVoiceSound(snd, "zetacallremovekill"..self:EntIndex(), true)
                else
                    local rnd = math.random(1,431+self.KillSoundCount)
                    local snd
                    if GetConVar("zetaplayer_customkilllinesonly"):GetInt() == 1 or GetConVar("zetaplayer_friendcustomkilllinesonly"):GetInt() == 1 and self.Permafriend or self.UseCustomKill then
                        snd = "zetaplayer/custom_vo/kill/kill"..math.random(self.KillSoundCount)..".wav"
                    else
                        snd = "zetaplayer/vo/kill/kill"..rnd..".wav"
                        if rnd > 431 then
                            snd = "zetaplayer/custom_vo/kill/kill"..math.random(self.KillSoundCount)..".wav"
                        end
                    end
                    
                    self:ZetaPlayVoiceSound(snd, "zetacallremovekill"..self:EntIndex(), true)
                end
            end)

end

function ENT:PlayTauntSound()
    if GetConVar('zetaplayer_allowtauntvoice'):GetInt() == 0 then return end
    if self.IsSpeaking == true then return end
    if self.AllowVoice == false then return end

            timer.Simple(math.random(0.0,0.5),function()
                if !self:IsValid() then return end

                if self.TAUNTVOICEPACKEXISTS then
                    snd = "zetaplayer/custom_vo/"..self.VoicePack.."/".."taunt/taunt"..math.random(self.TauntSoundCount)..".wav"
                    self:ZetaPlayVoiceSound(snd, "zetacallremovetaunt"..self:EntIndex(), true)
                else
                    local rnd = math.random(1,247+self.TauntSoundCount)
                    local snd
                    if GetConVar("zetaplayer_customtauntlinesonly"):GetInt() == 1 or GetConVar("zetaplayer_friendcustomtauntlinesonly"):GetInt() == 1 and self.Permafriend or self.UseCustomTaunt then
                        snd = "zetaplayer/custom_vo/taunt/taunt"..math.random(self.TauntSoundCount)..".wav"
                    else
                        snd = "zetaplayer/vo/taunt/taunt"..rnd..".wav"
                        if rnd > 247 then
                            snd = "zetaplayer/custom_vo/taunt/taunt"..math.random(self.TauntSoundCount)..".wav"
                        end
                    end

                    self:ZetaPlayVoiceSound(snd, "zetacallremovetaunt"..self:EntIndex(), true)
                end
            end)

end

function ENT:PlayAssistSound()
    if GetConVar('zetaplayer_allowtauntvoice'):GetInt() == 0 then return end
    if self.IsSpeaking == true then return end
    if self.AllowVoice == false then return end

            timer.Simple(math.random(0.0,0.5),function()
                if !self:IsValid() then return end

                if self.ASSISTVOICEPACKEXISTS then
                    snd = "zetaplayer/custom_vo/"..self.VoicePack.."/assist/assist"..math.random(self.AssistSoundCount)..".wav"
                    self:ZetaPlayVoiceSound(snd, "zetastoptauntsound"..self:EntIndex())
                else
                    local rnd = math.random(1,30+self.AssistSoundCount)
                    local snd
                    if GetConVar("zetaplayer_customassistlinesonly"):GetInt() == 1 or GetConVar("zetaplayer_friendcustomassistlinesonly"):GetInt() == 1 and self.Permafriend or self.UseCustomAssist then
                        snd = "zetaplayer/custom_vo/assist/assist"..math.random(self.AssistSoundCount)..".wav"
                    else
                        snd = "zetaplayer/vo/assist/assist"..rnd..".wav"
                        if rnd > 30 then
                            snd = "zetaplayer/custom_vo/assist/assist"..math.random(self.AssistSoundCount)..".wav"
                        end
                    end
                    
                    self:ZetaPlayVoiceSound(snd, "zetastoptauntsound"..self:EntIndex())
                end
            end)

end


function ENT:PlayScoldSound()
    if GetConVar('zetaplayer_allowscoldvoice'):GetInt() == 0 then return end
    if self.IsSpeaking == true then return end
    if self.AllowVoice == false then return end
    local duration
            
    if !self:IsValid() then return end

    if self.ADMINSCOLDVOICEPACKEXISTS then
        snd = "zetaplayer/custom_vo/"..self.VoicePack.."/adminscold/adminscold"..math.random(self.AdminScoldSoundCount)..".wav"
        duration = self:ZetaPlayVoiceSound(snd, "zetastoptauntsound"..self:EntIndex())
    else
    local rnd = math.random(1,41+self.AdminScoldSoundCount)
    local snd
    if GetConVar("zetaplayer_customadminscoldlinesonly"):GetInt() == 1 or GetConVar("zetaplayer_friendcustomadminscoldlinesonly"):GetInt() == 1 and self.Permafriend or self.UseCustomAdminScold then
        snd = "zetaplayer/custom_vo/adminscold/adminscold"..math.random(self.AdminScoldSoundCount)..".wav"
    else
        snd = "zetaplayer/vo/adminscold/adminscold"..rnd..".wav"
        if rnd > 41 then
            snd = "zetaplayer/custom_vo/adminscold/adminscold"..math.random(self.AdminScoldSoundCount)..".wav"
        end
    end
                
      duration = self:ZetaPlayVoiceSound(snd, "zetastoptauntsound"..self:EntIndex())
    end

    if duration then
        return duration
    else
        return 0
    end
end

function ENT:PlayFallingSound()
    if !IsValid(self) or !self.AllowVoice or CurTime() <= self.NextFallingSoundT or !GetConVar('zetaplayer_allowfallingvoice'):GetBool() then return end
    local rnd = math.random(10 + self.FallingSoundCount)
    local snd = "zetaplayer/vo/fall/fall"..rnd..".wav"
    if self.FALLVOICEPACKEXISTS then
        snd = "zetaplayer/custom_vo/"..self.VoicePack.."/fall/fall"..math.random(self.FallingSoundCount)..".wav"
    elseif rnd > 10 or self.UseCustomFalling or self.Permafriend and GetConVar("zetaplayer_friendcustomfallinglinesonly"):GetBool() or GetConVar("zetaplayer_customfallinglinesonly"):GetBool() then
        snd = "zetaplayer/custom_vo/fall/fall"..math.random(self.FallingSoundCount)..".wav"
    end
    local dur = self:ZetaPlayVoiceSound(snd, "zetastopfallingsound"..self:EntIndex())
    self.NextFallingSoundT = CurTime() + (dur or 1.0)
end



function ENT:ReacttoMediaPlayer()
    if GetConVar('zetaplayer_allowidlevoice'):GetInt() == 0 then return end
    if self.IsSpeaking == true then return end
    if self.AllowVoice == false then return end

            timer.Simple(math.random(0.0,1.0),function()
                if !self:IsValid() then return end
                local rnd = math.random(1,86)

                self:ZetaPlayVoiceSound("zetaplayer/vo/mediaremoved/mediaremove"..rnd..".wav", "zetacallremovemedia"..self:EntIndex(), true)

            end)

end



function ENT:RespondtoAdmin()
    if self.AllowVoice == false then return end
    if self.IsSpeaking then return end

        local dur = 0

        if GetConVar('zetaplayer_alternateidlesounds'):GetInt() == 1 then

            if self.SITRESPONDVOICEPACKEXISTS then
                snd = "zetaplayer/custom_vo/"..self.VoicePack.."/sitrespond/sitrespond"..math.random(self.SitRespondSoundCount)..".wav"
                dur = self:ZetaPlayVoiceSound(snd, "zetaidleremove"..self:EntIndex(), true)
            else
                local rnd = math.random(647+self.SitRespondSoundCount)
                local snd 
                if GetConVar("zetaplayer_customsitrespondlinesonly"):GetInt() == 1 or GetConVar("zetaplayer_friendcustomsitrespondlinesonly"):GetInt() == 1 and self.Permafriend or self.UseCustomSitRespond then
                    snd = "zetaplayer/custom_vo/sitrespond/sitrespond"..math.random(self.SitRespondSoundCount)..".wav"
                else
                    snd = 'zetaplayer/vo/idle/idle'..rnd..'.wav'
                    if rnd > 647 then
                        snd = "zetaplayer/custom_vo/sitrespond/sitrespond"..math.random(self.SitRespondSoundCount)..".wav"
                    end
                end
                dur = self:ZetaPlayVoiceSound(snd, "zetaidleremove"..self:EntIndex(), true)
            end
        else
            dur = self:SayQuestion()
        end

    return dur
end


function ENT:PlayQuestionLine()
    if self.AllowVoice == false then return end
    if !self:IsValid() then return end
    local duration

    if self.CONQUESTIONVOICEPACKEXISTS then
        snd = "zetaplayer/custom_vo/"..self.VoicePack.."/conquestion/conquestion"..math.random(self.QuestionSoundCount)..".wav"
        duration = self:ZetaPlayVoiceSound(snd, "zetastopquestionsound"..self:EntIndex())
    else
        local rnd = math.random(1,(647+self.IdleSoundCount)+self.QuestionSoundCount)
        local snd
        if GetConVar("zetaplayer_customquestionlinesonly"):GetInt() == 1 or GetConVar("zetaplayer_friendcustomquestionlinesonly"):GetInt() == 1 and self.Permafriend or self.UseCustomQuestion then
            snd = "zetaplayer/custom_vo/conquestion/conquestion"..math.random(self.QuestionSoundCount)..".wav"
        else
            snd = 'zetaplayer/vo/idle/idle'..rnd..'.wav'
            if rnd > (647+self.IdleSoundCount) then
                snd = "zetaplayer/custom_vo/conquestion/conquestion"..math.random(self.QuestionSoundCount)..".wav"
            elseif rnd > 647 then
                snd = "zetaplayer/custom_vo/idle/idle"..math.random(self.IdleSoundCount)..".wav"
            end
        end
                    
        duration = self:ZetaPlayVoiceSound(snd, "zetastopquestionsound"..self:EntIndex())
    end
    if duration then
        return duration
    else
        return 0
    end
end

function ENT:PlayRespondLine()
    if self.AllowVoice == false then return end
    if !self:IsValid() then return end
    local duration


    if self.CONRESPONDVOICEPACKEXISTS then
        snd = "zetaplayer/custom_vo/"..self.VoicePack.."/conrespond/conrespond"..math.random(self.ConRespondSoundCount)..".wav"
        duration = self:ZetaPlayVoiceSound(snd, "zetastoprespondsound"..self:EntIndex())
    else
        local rnd = math.random(1,(647+self.IdleSoundCount)+self.ConRespondSoundCount)
        local snd
        if GetConVar("zetaplayer_customrespondlinesonly"):GetInt() == 1 or GetConVar("zetaplayer_friendcustomrespondlinesonly"):GetInt() == 1 and self.Permafriend or self.UseCustomConRespond then
            snd = "zetaplayer/custom_vo/conrespond/conrespond"..math.random(self.ConRespondSoundCount)..".wav"
        else
            snd = 'zetaplayer/vo/idle/idle'..rnd..'.wav'
            if rnd > (647+self.IdleSoundCount) then
                snd = "zetaplayer/custom_vo/conrespond/conrespond"..math.random(self.ConRespondSoundCount)..".wav"
            elseif rnd > 647 then
                snd = "zetaplayer/custom_vo/idle/idle"..math.random(self.IdleSoundCount)..".wav"
            end
        end

        duration = self:ZetaPlayVoiceSound(snd, "zetastoprespondsound"..self:EntIndex())
    end
    if duration then
        return duration
    else
        return 0
    end
end


function ENT:PlayIdleLine()
    if self.IDLEVOICEPACKEXISTS then
        local rnd = math.random(self.IdleSoundCount)
        local snd = "zetaplayer/custom_vo/"..self.VoicePack.."/".."idle/idle"..math.random(self.IdleSoundCount)..".wav"
        self:ZetaPlayVoiceSound(snd, "zetaidleremove"..self:EntIndex(), true)
    else
        if GetConVar('zetaplayer_alternateidlesounds'):GetInt() == 1 then
            local rnd = math.random(647+self.IdleSoundCount)
            local snd 
            if GetConVar("zetaplayer_customidlelinesonly"):GetInt() == 1 or GetConVar("zetaplayer_friendcustomidlelinesonly"):GetInt() == 1 and self.Permafriend or self.UseCustomIdle then
                snd = "zetaplayer/custom_vo/idle/idle"..math.random(self.IdleSoundCount)..".wav"
            else
                snd = 'zetaplayer/vo/idle/idle'..rnd..'.wav'
                if rnd > 647 then
                    snd = "zetaplayer/custom_vo/idle/idle"..math.random(self.IdleSoundCount)..".wav"
                end
            end
            self:ZetaPlayVoiceSound(snd, "zetaidleremove"..self:EntIndex(), true)
        else
            self:SayQuestion()
        end

    end
end



function ENT:PlayMediaWatchLine()
    if self.AllowVoice == false then return end
    if !self:IsValid() then return end
    local duration

    if self.MEDIAWATCHVOICEPACKEXISTS then
        snd = "zetaplayer/custom_vo/"..self.VoicePack.."/mediawatch/mediawatch"..math.random(self.MediaWatchSoundCount)..".wav"
        duration = self:ZetaPlayVoiceSound(snd, "zetastopmediawatchsound"..self:EntIndex())
    else
        local rnd = math.random(1,(647+self.IdleSoundCount)+self.MediaWatchSoundCount)
        local snd
        if GetConVar("zetaplayer_custommediawatchlinesonly"):GetInt() == 1 or GetConVar("zetaplayer_friendcustomsitrespondlinesonly"):GetInt() == 1 and self.Permafriend or self.UseCustomMediaWatch then
            snd = "zetaplayer/custom_vo/mediawatch/mediawatch"..math.random(self.MediaWatchSoundCount)..".wav"
        else
            snd = 'zetaplayer/vo/idle/idle'..rnd..'.wav'
            if rnd > (647+self.IdleSoundCount) then
                snd = "zetaplayer/custom_vo/mediawatch/mediawatch"..math.random(self.MediaWatchSoundCount)..".wav"
            elseif rnd > 647 then
                snd = "zetaplayer/custom_vo/idle/idle"..math.random(self.IdleSoundCount)..".wav"
            end
        end

        duration = self:ZetaPlayVoiceSound(snd, "zetastopmediawatchsound"..self:EntIndex())
    end
    if duration then
        return duration
    else
        return 0
    end
end


function ENT:PlayPanicSound()
    if !GetConVar('zetaplayer_allowpanicvoice'):GetBool() then return end
    local rnd = math.random(#self.PanicSNDS + self.PanicSoundCount)
    local snd = self.PanicSNDS[rnd]
    if self.PANICVOICEPACKEXISTS then
        snd = "zetaplayer/custom_vo/"..self.VoicePack.."/panic/panic"..math.random(self.PanicSoundCount)..".wav"
    elseif self.UseCustomPanic or rnd > #self.PanicSNDS or self.Permafriend and GetConVar("zetaplayer_friendcustompaniclinesonly"):GetBool() or GetConVar("zetaplayer_custompaniclinesonly"):GetBool() then
        snd = "zetaplayer/custom_vo/panic/panic"..math.random(self.PanicSoundCount)..".wav"
    end
    self:ZetaPlayVoiceSound(snd, 'zetastoppanicsound'..self:EntIndex())
end
