AddCSLuaFile()
DEFINE_BASECLASS( "base_gmodentity" )

ENT.PrintName = "Zeta Music Box"
ENT.Spawnable = true

function ENT:Initialize()
    if ( CLIENT ) then return end
    if self:GetCreator():IsPlayer() then
        local mdls = {
            'models/props_lab/citizenradio.mdl',
            'models/props_lab/reciever01d.mdl',
            'models/props_lab/reciever01c.mdl',
        }
        self:SetModel(mdls[math.random(1,3)])
        self:SetNW2String("zetamusicbox_owner",self:GetCreator():GetName())
    end
    if GetConVar('zetaplayer_custommusiconly'):GetInt() == 0 then
    self.music = {
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
    else
        self.music = {}
    end
    local files, dirs = file.Find('sourceengine/sound/zetaplayer/custom_music/*','BASE_PATH','namedesc')

    for k,soundfile in ipairs(files) do
        table.insert(self.music,'zetaplayer/custom_music/'..soundfile)
    end


    self.CurrentMusic = 'none'
    self.CurrentIndex = 0

    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetUseType(SIMPLE_USE)

    self:GetPhysicsObject():Wake()

    self:PlayMusic()



end

local function TrackPrettyprint(strin)
    local explode = string.Explode("/",strin)
    local filename = explode[#explode]
    filename = string.StripExtension(filename)
    return filename
end

function ENT:PlayMusic(specifictrack)
    local track
    if GetConVar("zetaplayer_musicshuffle"):GetBool() then
        track = self.music[math.random(#self.music)]
    else
        self.CurrentIndex = self.CurrentIndex + 1
        if self.CurrentIndex > #self.music then
            self.CurrentIndex = 1
        end
        track = self.music[self.CurrentIndex]
    end
    track = specifictrack or track

    self.CurrentMusic = track

    self:SetNW2String("musicbox_trackname",TrackPrettyprint(track))
    net.Start("zetamusicbox_playtrack",true)
    net.WriteEntity(self)
    net.WriteString(track)
    net.Broadcast()

    local sphere = ents.FindInSphere(self:GetPos(),1500)

    for _,v in ipairs(sphere) do
        if IsValid(v) and v.IsZetaPlayer and math.random(1,100) < GetConVar("zetaplayer_dancechance"):GetInt() and !v.PlayingPoker then
            v:DanceNearEnt(self)
        end
    end
end

function ENT:Use(activator,caller,use,value)
    self:PlayMusic()
end

function ENT:GetOverlayText()
    if self:GetNW2String("zetamusicbox_owner","none") != "none" then
        return self:GetNW2String("zetamusicbox_owner","none").."\n( "..self:GetNW2String("musicbox_trackname","Failed to get Track Name").." )"
    else
        local txt2
        if IsValid(self:GetOwner()) then
            txt2 = self:GetOwner():GetNW2String('zeta_name','Zeta Player')
        else
            txt2 = "Couldn't Get Owner"
        end

	    return txt2.."\n( "..self:GetNW2String("musicbox_trackname","Failed to get Track Name").." )"
    end
end

list.Set( "Entities", "zeta_musicbox", {
	Name = "Zeta Music Box",
	Class = "zeta_musicbox",
	Category = "Zeta Player Entities"
})