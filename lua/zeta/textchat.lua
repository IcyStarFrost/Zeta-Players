AddCSLuaFile()

ENT.TypingInChat = false

local keyphrase = {
    ["/map/"] = game.GetMap(), 
    ["/rndent/"] = true, -- Translates to a Random Zeta Player or Player. Used mainly in idle
    ["/keyent/"] = true, -- Key entity. A player to mention in certain situation. Used with response,death, and insult.
    ["/rndmap/"] = true, -- Translates to a random map
    ["/curday/"] = true, -- Translate to the current week day today
    ["/rndword/"] = true, -- Translates to a random word in the text we are responding to.
    ["/realplayer/"] = true, -- Translates to you, the player.
    ["/self/"] = true, -- Translates to the zeta's name that is speaking this message
    ["/rndaddon/"] = true -- Translates to a random Addon's name you have installed

}



local restrictRndWords = {
    ["a"] = true,
    ["can"] = true,
    ["cant"] = true,
    ["can't"] = true,
    ["could"] = true,
    ["couldn't"] = true,
    ["couldnt"] = true,
    ["an"] = true,
    ["the"] = true,
    ["or"] = true,
    ["my"] = true,
    ["that"] = true,
    ["thats"] = true,
    ["that's"] = true,
    ["our"] = true,
    ["i"] = true,
    ["i'm"] = true,
    ["before"] = true,
    ["get"] = true,
    ["after"] = true,
    ["got"] = true,
    ["you"] = true,
    ["youre"] = true,
    ["with"] = true,
    ["you're"] = true,
    ["was"] = true,
    ["were"] = true,
    ["your"] = true,
    ["yours"] = true,
    ["am"] = true,
    ["im"] = true,
    ["they're"] = true,
    ["their"] = true,
    ["named"] = true,
    ["hes"] = true,
    ["than"] = true,
    ["back"] = true,
    ["he's"] = true,
    ["she"] = true,
    ["shes"] = true,
    ["his"] = true,
    ["it's"] = true,
    ["of"] = true,
    ["its"] = true,
    ["and"] = true,
    ["ayo"] = true,
    ["yo"] = true,
    ["any"] = true,
    ["like"] = true,
    ["there"] = true,
    ["where"] = true,
    ["what"] = true,
    ["what"] = true,
    ["what's"] = true,
    ["whats"] = true,
    ["how"] = true,
    ["is"] = true,
    ["say"] = true,
    ["on"] = true,
    ["for"] = true,
    ["from"] = true,
    ["hold"] = true,
    ["why"] = true,
    ["says"] = true,
    ["this"] = true,
    ["there's"] = true,
    ["to"] = true,
    ["so"] = true,
    ["by"] = true,
    ["theres"] = true
}


local function CombineStringTable( tbl )
    local strin = ""
 
     for k, v in ipairs( tbl ) do
         strin = strin .. " " .. v    
     end 
     
     return strin
 end
     
 -- Prototype created in StarFall
 -- Bootleg markov chain stuff anyways. It's not the real deal but it works very well
 local function MarkovChain_MixPhrase( text, feed )
     
     local mod = ""
     
     local feedstring = CombineStringTable( feed )
     local textsplit = string.Explode( " ", text )
     local validwords = {}
     local smallwords = {}
     
     for k, word in ipairs( string.Explode( " ", feedstring ) ) do
         if #word > 3 then validwords[ #validwords + 1 ] = word end
     end
     
     for k, word in ipairs( string.Explode( " ", feedstring ) ) do
         if #word < 3 then smallwords[ #smallwords + 1 ] = word end
     end
     
     for k, word in ipairs( textsplit ) do
         local preword = word
         
         if #preword > 3 and math.random( 1, 2 ) == 1 then
             preword = validwords[ math.random( #validwords ) ]
         elseif #preword < 3 and math.random( 1, 6 ) == 1 then
             preword = smallwords[ math.random( #smallwords ) ]
         end    
         
         mod = mod .. " " .. preword
     end

     
     return mod
 end


local function GetStringRepeatCount(strin,pattern) -- Returns the amount of times the pattern text was found. "test /rndent/ test udshf /rndent/ /rndent/" would return 3 if /rndent/ is the pattern
    local count = 0
    for i in string.gmatch(strin, pattern) do
        count = count + 1
    end
    return count
end

local function GetAddonNames()
    local names = {}

    local workshopaddons = engine.GetAddons()
    local _,legacynames = file.Find("addons/*", "MOD", "datedesc")

    for _,addon in ipairs(workshopaddons) do
        local title = addon.title
        title = string.Replace(title,"-"," ")
        title = string.Replace(title,"_"," ")
        table.insert(names,title)
    end

    for _,name in ipairs(legacynames) do
        local title = ""
        title = string.Replace(name,"-"," ")
        title = string.Replace(title,"_"," ")
        table.insert(names,title)
    end
    
    return names
end

function ENT:CheckForKeyPhrases(strin)
    for k, phrase in pairs(keyphrase) do
        local find, b, c = string.find(strin, k)
        if !isnumber(find) then continue end
        if k == "/rndent/" then
            local rndply
            local plys = self:GetPlayerZetas()

            for i=1, GetStringRepeatCount(strin,"/rndent/") do
                for k,v in RandomPairs(plys) do
                    rndply = v:IsPlayer() and v:GetName() or v.IsZetaPlayer and v.zetaname
                    if rndply and rndply != "" then
                        break
                    end
                end
                strin = string.gsub( strin, k, rndply, 1 )
            end
            --strin = string.Replace(strin,k,rndply)
        elseif k == "/keyent/" then
            if self.text_keyent then
                local rndply = self.text_keyent
                strin = string.Replace(strin,k,rndply)
            end
        elseif k == "/rndmap/" then
            local maps,dirs = file.Find("maps/*.bsp","GAME")
            local rndmap = string.StripExtension(maps[math.random(#maps)])
            if rndmap then
                strin = string.Replace(strin,k,rndmap)
            end
        elseif k == "/curday/" then
            local date = os.date("%A")
            strin = string.Replace(strin,k,date)
        elseif k == "/rndword/" then
            if self.text_response then
                local strExplode = string.Explode(" ", self.text_response)
                if strExplode and #strExplode > 0 then
                    for k, v in ipairs(strExplode) do

                        if restrictRndWords[string.lower(v)] then table.remove(strExplode, k) end
                    end
                    local rndWord = string.Replace(string.lower(strExplode[math.random(#strExplode)]), "'s", "")
                    rndWord = string.Replace(rndWord, '[\\/:%*%?"<>|.,!#]', "")
                    strin = string.Replace(strin,k,rndWord)
                end
            end
        elseif k == "/realplayer/" then
            strin = string.Replace(strin,k,Entity(1):GetName())
        elseif k == "/self/" then
            strin = string.Replace(strin,k,self.zetaname)
        elseif k == "/rndaddon/" then
            local addons = GetAddonNames()
            local addon = ""
            for i=1, GetStringRepeatCount(strin,"/rndaddon/") do

                addon = addons[math.random(#addons)]
                strin = string.gsub( strin, k, addon, 1 )
            end


        else
            strin = string.Replace(strin,k,phrase)
        end
    end

    return strin
end

function ENT:TypeMessage(msgtype)
    if self.TypingInChat then return 0 end
    if !self.TEXTDATA or !self.TEXTDATA[msgtype] then return 0 end
    if GetConVar("zetaplayer_textchatslowtime"):GetFloat() != 0 and CurTime() < _ZETATEXTSLOWCUR then self:RemoveGesture(ACT_GMOD_IN_CHAT) self.TypingInChat = false return 0 end

    local isDead = (msgtype == "death")
    local textType = msgtype

    if !isDead then
        if self:IsChasingSomeone() then return 0 end
        self:AddGesture( ACT_GMOD_IN_CHAT,false )
        self.TypingInChat = true

        if msgtype == "idle" and _ZetaSpecificDay != "None" and math.random(3) == 1 then
            self.text_keyent = Entity(1):GetName()
            textType = _ZetaSpecificDay
        end
    end

    local rndphrase = self.TEXTDATA[textType][math.random(#self.TEXTDATA[textType])]

    rndphrase = GetConVar( "zetaplayer_textmixing" ):GetBool() and MarkovChain_MixPhrase( rndphrase, self.TEXTDATA[textType] ) or rndphrase

    rndphrase = self:CheckForKeyPhrases(rndphrase)

    


    local r,g,b = self:GetColorByRank()


    local typeTime = string.len(rndphrase)/math.random(5,11)
    self.TypingChatText = {rndphrase, CurTime(), typeTime,Color(r,g,b)} 

    local selfpos = self:GetPos()
    
    local name = self.zetaname
    timer.Create("zetaTypeChatMessage"..self:EntIndex(), typeTime, 1, function()
        if !isDead then 
            if !IsValid(self) or !self.TypingInChat then return end
            if GetConVar("zetaplayer_textchatslowtime"):GetFloat() != 0 and CurTime() < _ZETATEXTSLOWCUR then self:RemoveGesture(ACT_GMOD_IN_CHAT) self.TypingInChat = false return 0 end

            _ZETATEXTSLOWCUR = CurTime()+GetConVar("zetaplayer_textchatslowtime"):GetFloat()
            self:SendTextMessage(rndphrase, Color(r,g,b))
        else

            if GetConVar("zetaplayer_textchatslowtime"):GetFloat() != 0 and CurTime() < _ZETATEXTSLOWCUR then return 0 end

            _ZETATEXTSLOWCUR = CurTime()+GetConVar("zetaplayer_textchatslowtime"):GetFloat()

            hook.Run("ZetaPlayerSay", self, rndphrase, name)

            

            net.Start("zeta_chatsend", true)
                net.WriteString(name)
                net.WriteString(rndphrase)
                net.WriteColor(Color(r,g,b),false)
                net.WriteBool(isDead)
                net.WriteVector(selfpos)
            net.Broadcast()

            local dist = GetConVar("zetaplayer_textchatreceivedistance"):GetInt()
            if GetConVar("zetaplayer_enablemoonbasettssupport"):GetBool() and ConVarExists( "tts_enable" ) and (dist != 0 and Entity(1):GetPos():Distance(self:GetPos()) < dist or true ) then
                local tbl = hook.Run( "preTTS", Entity(1), rndphrase, false )
                if tbl.tts then
                    net.Start("tts")
                        net.WriteTable(tbl)
                    net.Broadcast()
                end
            end
    
            local sendSnd = GetConVar("zetaplayer_customtextsendsound"):GetString()
            if sendSnd != "" then
                sound.Play(sendSnd, Vector(0,0,0), 0)
            end
        end
    end)

    return typeTime
end

function ENT:SendTextMessage(msg,color)
    self:RemoveGesture(ACT_GMOD_IN_CHAT)
    self.TypingInChat = false

    if msg == "bloxwich" and !self.achievement_earnedbloxwich then
        self.achievement_earnedbloxwich = true
        self:AwardAchievement("Secret Phrase")
    end

    local selfpos = self:GetPos()

    hook.Run("ZetaPlayerSay", self, msg, self.zetaname)
    self.TypingChatText = nil
    
    net.Start("zeta_chatsend", true)
        net.WriteString(self.zetaname)
        net.WriteString(msg)
        net.WriteColor(color,false)
        net.WriteBool(false)
        net.WriteVector(selfpos)
    net.Broadcast()

    local dist = GetConVar("zetaplayer_textchatreceivedistance"):GetInt()
    if GetConVar("zetaplayer_enablemoonbasettssupport"):GetBool() and ConVarExists("tts_enable") and (dist != 0 and Entity(1):GetPos():Distance(self:GetPos()) < dist or true ) then
        local tbl = hook.Run( "preTTS", Entity(1), msg, false )
        if tbl.tts then
            net.Start("tts")
                net.WriteTable(tbl)
            net.Broadcast()
        end
    end

    local sendSnd = GetConVar("zetaplayer_customtextsendsound"):GetString()
    if sendSnd != "" then
        sound.Play(sendSnd, Vector(0,0,0), 0)
    end
end