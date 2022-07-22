AddCSLuaFile()




local function TrackPrettyprint(strin)
    local explode = string.Explode("/",strin)
    local filename = explode[#explode]
    filename = string.StripExtension(filename)
    return filename
end

properties.Add("Music Tracks", {
    MenuLabel = "Music Tracks",
    Order = 500,
    MenuIcon = "icon16/cd.png",

    Filter = function( self, ent, ply ) 
        if !IsValid(ent) then return false end
        if ent:GetClass() != "zeta_musicbox" then return false end
        if !gamemode.Call( "CanProperty", ply, "Music Tracks", ent ) then return false end

        return true
    end,

    MenuOpen = function( self, option, ent, tr )
        local submenu = option:AddSubMenu()

        local music = {
            'music/hl2_song0.mp3',
            'music/hl2_song12_long.mp3',
            'music/hl2_song14.mp3',
            'music/hl2_song15.mp3',
            'music/hl2_song16.mp3',
            'music/hl2_song20_submix0.mp3',
            'music/hl2_song20_submix4.mp3',
            'music/hl2_song29.mp3',
            'music/hl2_song3.mp3',
            'music/hl2_song4.mp3',
            'music/hl2_song6.mp3',
            'zetaplayer/musicbox/vlvx_song11.mp3',
            'zetaplayer/musicbox/vlvx_song12.mp3',
            'zetaplayer/musicbox/vlvx_song18.mp3',
            'zetaplayer/musicbox/vlvx_song21.mp3',
            'zetaplayer/musicbox/vlvx_song22.mp3',
            'zetaplayer/musicbox/vlvx_song23.mp3',
            'zetaplayer/musicbox/vlvx_song24.mp3',
            'zetaplayer/musicbox/vlvx_song25.mp3',
            'zetaplayer/musicbox/vlvx_song27.mp3',
            'zetaplayer/musicbox/vlvx_song28.mp3',
        
        }
        local files, dirs = file.Find('sourceengine/sound/zetaplayer/custom_music/*','BASE_PATH','namedesc')
        
        for k,soundfile in ipairs(files) do
            table.insert(music,'zetaplayer/custom_music/'..soundfile)
        end

        table.sort(music)

        for i = 1,#music do

            local option = submenu:AddOption( TrackPrettyprint(music[i]), function()
            
                self:MsgStart()
                    net.WriteEntity( ent )
                    net.WriteString(music[i])
                self:MsgEnd()

            end)

        end

    end,

    Action = function() end,

    Receive = function( self, length, ply )

		local ent = net.ReadEntity()
		local track = net.ReadString()

		if ( !properties.CanBeTargeted( ent, ply ) ) then return end
		if ( !self:Filter( ent, ply ) ) then return end

        ent:PlayMusic(track)

	end

})



properties.Add("Restart Current Track", {
    MenuLabel = "Restart Current Track",
    Order = 499,
    MenuIcon = "icon16/arrow_rotate_anticlockwise.png",

    Filter = function( self, ent, ply ) 
        if !IsValid(ent) then return false end
        if ent:GetClass() != "zeta_musicbox" then return false end
        if !gamemode.Call( "CanProperty", ply, "Restart Current Track", ent ) then return false end

        return true
    end,

    Action = function(self,ent) 
        self:MsgStart()
            net.WriteEntity( ent )
        self:MsgEnd()
    end,

    Receive = function( self, length, ply )

		local ent = net.ReadEntity()

		if ( !properties.CanBeTargeted( ent, ply ) ) then return end
		if ( !self:Filter( ent, ply ) ) then return end

        ent:PlayMusic(ent.CurrentMusic)

	end

})



if SERVER then
    
    util.AddNetworkString("zetamusicbox_playtrack")
    util.AddNetworkString("zetamusicbox_sendduration")


    net.Receive("zetamusicbox_sendduration",function(len,ply)
        local musicbox = net.ReadEntity()
        local dur = net.ReadInt(16)
        local index = musicbox:EntIndex()
        timer.Create("zetamusicboxstopmusic"..index,dur,1,function()
            if !IsValid(musicbox) then return end
            if GetConVar("zetaplayer_musicplayonce"):GetBool() then
                musicbox:Remove()
            else
                musicbox:PlayMusic()
            end
        end)
    
    end)


elseif CLIENT then

    local render = render
    local musiccolor = Color(0,0,0)


    local function PlayMusicTrack(musicbox,track,no3d)
        if !IsValid(musicbox) then return end

        local index = musicbox:EntIndex()

        if IsValid(musicbox.AudioChannel) then
            hook.Remove("Think","zetamusicboxthink"..musicbox:EntIndex())
            musicbox.AudioChannel:Stop()
        end

        local flags = "3d mono"

        if no3d then
            flags = "mono"
        end

        sound.PlayFile("sound/"..track,flags,function(channel,errorid,errorname)
            if errorid then
                if errorid == 2 then
                    print("MUSIC BOX AUDIO CHANNEL ERROR: ID = "..errorid.." NAME = "..errorname.."\n Used sound file = "..track)
                    print("File name may have unicode characters in the name. Make sure you remove them")
                    musicbox:EmitSound("buttons/combine_button_locked.wav",100)
                elseif errorid == 21 then
                    if !GetConVar("zetaplayer_surpressminormusicwarnings"):GetBool() then
                        print("Music Box Minor Warning: "..track.." Has a stereo channel. This means the sound won't be 3d. The sound file will continue to play")
                        musicbox:EmitSound("buttons/combine_button"..math.random(2,3)..".wav",100)
                    end
                    PlayMusicTrack(musicbox,track,true)
                    
                end
                
                
                return
            end
            musicbox.AudioChannel = channel

            local _FFT = {}



            local dur = channel:GetLength()
            net.Start("zetamusicbox_sendduration",true)
            net.WriteEntity(musicbox)
            net.WriteInt(dur,16)
            net.SendToServer()

            hook.Add("Think","zetamusicboxthink"..index,function()
                if !IsValid(musicbox) then channel:Stop() hook.Remove("Think","zetamusicboxthink"..index) return end
                if !IsValid(channel) then hook.Remove("Think","zetamusicboxthink"..index) return end
                channel:SetPos(musicbox:GetPos())
                if no3d then
                    local dist = LocalPlayer():GetPos():DistToSqr(musicbox:GetPos())
                    local volume = math.Clamp( GetConVar("zetaplayer_musicvolume"):GetFloat()/(dist/(7000*30)),0,GetConVar("zetaplayer_musicvolume"):GetFloat())
--[[                     if dist > (450*450) then ]]
                        channel:SetVolume( volume )
--[[                     else
                        channel:SetVolume(GetConVar("zetaplayer_musicvolume"):GetFloat())
                    end ]]
                else 
                    channel:SetVolume(GetConVar("zetaplayer_musicvolume"):GetFloat())
                end
            end)

            
            local mul = 10
            local fftmul=200
            local NumSegment = 2
            local high = 0
            

            hook.Add("PostDrawOpaqueRenderables","zetamusicboxFFT"..index,function()
                if !IsValid(musicbox) then hook.Remove("PostDrawOpaqueRenderables","zetamusicboxFFT"..index) return end
                if !IsValid(channel) then hook.Remove("PostDrawOpaqueRenderables","zetamusicboxFFT"..index) return end
                if !GetConVar("zetaplayer_enablemusicvisualizer"):GetBool() then return end
                if GetConVar("zetaplayer_visualizerplayeronly"):GetBool() and musicbox:GetNW2String("zetamusicbox_owner","none") == "none" then return end
                local dist = LocalPlayer():GetPos():DistToSqr(musicbox:GetPos())

                if dist > (GetConVar("zetaplayer_visualizerrenderdistance"):GetInt()*GetConVar("zetaplayer_visualizerrenderdistance"):GetInt()) then return end
                
                local zadd = Vector(0,0,2+musicbox:OBBMaxs()[3])
                local startpos = (musicbox:GetPos()+zadd)+musicbox:GetRight()*10
                channel:FFT( _FFT, GetConVar("zetaplayer_musicvisualizersamples"):GetInt() )


                local n = GetConVar("zetaplayer_visualizerresolution"):GetInt()



                if GetConVar("zetaplayer_enabledynamiclightvisualizer"):GetBool() then

                    local dlight = DynamicLight( musicbox:EntIndex() )

                    local add = 2

                    for i=1,n do
                        if _FFT[i] then
                            add = add + (_FFT[i]*100)
                        end
                    end
                    local rainbow = HSVToColor( (CurTime()*10)%360,1,1 )  
                    if ( dlight ) then
                        dlight.pos = musicbox:GetPos()
                        dlight.r = rainbow.r
                        dlight.g = rainbow.g
                        dlight.b = rainbow.b
                        dlight.brightness = add/90
                        dlight.Decay = 1000 / 4
                        dlight.Size = add
                        dlight.DieTime = CurTime() + 4
                    end

                end
                
                render.SetColorMaterial()

                -- Making use of my Starfall chips
                 for i=1,n do
                    local deg = (math.pi / n *i)*2
                    local x = math.sin(deg)
                    local y = math.cos(deg)
                    local pos = Vector(x,y+high/mul,0)*mul

                    -- I actually can't believe this hacky method worked on changing the angles.
                    local ang = ((musicbox:GetPos()+zadd)-((musicbox:GetPos()+zadd)+pos)):Angle()+Angle(-90,0,0)--Angle(0,0,-deg * 180/math.pi) 
                    
                    
                    local hue = (CurTime()*10)%360 + 360 / n * i
                    local col = HSVToColor(math.Clamp(hue % 360, 0, 360),1,1)

                    render.DrawBox( (musicbox:GetPos()+zadd)+pos, ang,Vector(), Vector(1,1,1+(_FFT[i%(n/NumSegment)] or 0)*fftmul),col)
                 end

--[[                 for i=1,40 do
                    musiccolor.r = _FFT[i]*500
                    musiccolor.g= _FFT[i]*500
                    musiccolor.b= _FFT[i]*500
                   
                    render.DrawBox( startpos-musicbox:GetRight()*i/2, musicbox:GetAngles(), Vector(-1,-1,0), Vector(1,1,((_FFT[i])*30) ),musiccolor )
                end ]]
            end)

        end)

        


    

    end

    net.Receive("zetamusicbox_playtrack",function()
        local musicbox = net.ReadEntity()
        local track = net.ReadString()
        PlayMusicTrack(musicbox,track)

    end)



end
