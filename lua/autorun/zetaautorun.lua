-----------------------------------------------
-- Auto Run
--- Some things that need to be auto ran
-----------------------------------------------

local util = util
local ents = ents
local net = net
local table = table
local ipairs = ipairs
local math = math
local Vector = Vector 
local Color = Color 
local Material = Material

local IsValid = IsValid

_ZetasInstalled = true

_bannedzetas = {}


include("zeta/zetamusicbox_net.lua")
include("zeta/consolecommands.lua")
include("zeta/zetafilehandling.lua")
include("zeta/zeta-voting.lua")
include("zeta/koth_funcs.lua")







if ( SERVER ) then

    function _ztrace()
        return Entity(1):GetEyeTrace().Entity
    end


    util.AddNetworkString('zeta_notifycleanup')
    util.AddNetworkString('zeta_playermodelcolor')
    util.AddNetworkString('zeta_voiceicon')
    util.AddNetworkString('zeta_addkillfeed')
    util.AddNetworkString('zeta_requestviewshot')
    util.AddNetworkString('zeta_joinmessage')
    util.AddNetworkString("zeta_disconnectmessage")
    util.AddNetworkString("zeta_voicepopup")
    util.AddNetworkString("zeta_removevoicepopup")
    util.AddNetworkString("zeta_playvoicesound")
    util.AddNetworkString("zeta_usesprayer")
    util.AddNetworkString("zeta_sendonscreenlog")
    util.AddNetworkString("zeta_sendcoloredtext")
    util.AddNetworkString("zeta_createcsragdoll")
    util.AddNetworkString("zeta_createc4decal")
    util.AddNetworkString("zeta_changevoicespeaker")
    util.AddNetworkString("zeta_sendvoiceicon")
    util.AddNetworkString("zeta_csragdollexplode")
    util.AddNetworkString("zeta_chatsend")
    util.AddNetworkString("zeta_achievement")
    util.AddNetworkString("zetaplayer_eyetap")
    util.AddNetworkString("zeta_realplayerendvoice")
    util.AddNetworkString("zeta_changegetplayername")

    -- Name panel
    util.AddNetworkString('zetapanel_getnames')
    util.AddNetworkString('zetapanel_sendnames')
    util.AddNetworkString('zetapanel_resetnames')
    util.AddNetworkString('zetapanel_removename')
    util.AddNetworkString('zetapanel_addname')

    -- Team panel

end

-- Precache the default models
util.PrecacheModel('models/player/alyx.mdl')
util.PrecacheModel('models/player/arctic.mdl')
util.PrecacheModel('models/player/barney.mdl')
util.PrecacheModel('models/player/breen.mdl')
util.PrecacheModel('models/player/charple.mdl')
util.PrecacheModel('models/player/combine_soldier.mdl')
util.PrecacheModel('models/player/combine_soldier_prisonguard.mdl')
util.PrecacheModel('models/player/combine_super_soldier.mdl')
util.PrecacheModel('models/player/corpse1.mdl')
util.PrecacheModel('models/player/dod_american.mdl')
util.PrecacheModel('models/player/dod_german.mdl')
util.PrecacheModel('models/player/eli.mdl')
util.PrecacheModel('models/player/gasmask.mdl')
util.PrecacheModel('models/player/gman_high.mdl')
util.PrecacheModel('models/player/guerilla.mdl')
util.PrecacheModel('models/player/kleiner.mdl')
util.PrecacheModel('models/player/leet.mdl')
util.PrecacheModel('models/player/odessa.mdl')
util.PrecacheModel('models/player/phoenix.mdl')
util.PrecacheModel('models/player/police.mdl')
util.PrecacheModel('models/player/riot.mdl')
util.PrecacheModel('models/player/skeleton.mdl')
util.PrecacheModel('models/player/soldier_stripped.mdl')
util.PrecacheModel('models/player/swat.mdl')
util.PrecacheModel('models/player/urban.mdl')
util.PrecacheModel('models/player/group01/female_01.mdl')
util.PrecacheModel('models/player/group01/female_02.mdl')
util.PrecacheModel('models/player/group01/female_03.mdl')
util.PrecacheModel('models/player/group01/female_04.mdl')
util.PrecacheModel('models/player/group01/female_05.mdl')
util.PrecacheModel('models/player/group01/female_06.mdl')
util.PrecacheModel('models/player/group01/male_01.mdl')
util.PrecacheModel('models/player/group01/male_02.mdl')
util.PrecacheModel('models/player/group01/male_03.mdl')
util.PrecacheModel('models/player/group01/male_04.mdl')
util.PrecacheModel('models/player/group01/male_05.mdl')
util.PrecacheModel('models/player/group01/male_06.mdl')
util.PrecacheModel('models/player/group01/male_07.mdl')
util.PrecacheModel('models/player/group01/male_08.mdl')
util.PrecacheModel('models/player/group01/male_09.mdl')
util.PrecacheModel('models/player/group02/male_02.mdl')
util.PrecacheModel('models/player/group02/male_04.mdl')
util.PrecacheModel('models/player/group02/male_06.mdl')
util.PrecacheModel('models/player/group02/male_08.mdl')
util.PrecacheModel('models/player/group03/female_01.mdl')
util.PrecacheModel('models/player/group03/female_02.mdl')
util.PrecacheModel('models/player/group03/female_03.mdl')
util.PrecacheModel('models/player/group03/female_04.mdl')
util.PrecacheModel('models/player/group03/female_05.mdl')
util.PrecacheModel('models/player/group03/female_06.mdl')
util.PrecacheModel('models/player/group03/male_01.mdl')
util.PrecacheModel('models/player/group03/male_02.mdl')
util.PrecacheModel('models/player/group03/male_03.mdl')
util.PrecacheModel('models/player/group03/male_04.mdl')
util.PrecacheModel('models/player/group03/male_05.mdl')
util.PrecacheModel('models/player/group03/male_06.mdl')
util.PrecacheModel('models/player/group03/male_07.mdl')
util.PrecacheModel('models/player/group03/male_08.mdl')
util.PrecacheModel('models/player/group03/male_09.mdl')
util.PrecacheModel('models/player/group03m/female_01.mdl')
util.PrecacheModel('models/player/group03m/female_02.mdl')
util.PrecacheModel('models/player/group03m/female_03.mdl')
util.PrecacheModel('models/player/group03m/female_04.mdl')
util.PrecacheModel('models/player/group03m/female_05.mdl')
util.PrecacheModel('models/player/group03m/female_06.mdl')
util.PrecacheModel('models/player/group03m/male_01.mdl')
util.PrecacheModel('models/player/group03m/male_02.mdl')
util.PrecacheModel('models/player/group03m/male_03.mdl')
util.PrecacheModel('models/player/group03m/male_04.mdl')
util.PrecacheModel('models/player/group03m/male_05.mdl')
util.PrecacheModel('models/player/group03m/male_06.mdl')
util.PrecacheModel('models/player/group03m/male_07.mdl')
util.PrecacheModel('models/player/group03m/male_08.mdl')
util.PrecacheModel('models/player/group03m/male_09.mdl')
util.PrecacheModel("models/player/zombie_soldier.mdl")
util.PrecacheModel("models/player/p2_chell.mdl")
util.PrecacheModel("models/player/mossman.mdl")
util.PrecacheModel("models/player/mossman_arctic.mdl")
util.PrecacheModel("models/player/magnusson.mdl")
util.PrecacheModel("models/player/monk.mdl")
util.PrecacheModel("models/player/zombie_fast.mdl")
















CreateConVar('zetaplayer_debug',0,FCVAR_NONE,"Enables the Zeta's debug text",0,1)
CreateConVar('zetaplayer_consolelog',0,FCVAR_ARCHIVE,"Enables the Console logging of Zetas. Mimics ent spawning logs you see with players",0,1)
CreateConVar('zetaplayer_allowtoolgunnonworld',1,FCVAR_ARCHIVE,'Allows the Zeta to toolgun non world ents',0,1)
CreateConVar('zetaplayer_allowtoolgunworld',1,FCVAR_ARCHIVE,'Allows the Zeta to toolgun world ents',0,1)
CreateConVar('zetaplayer_allowphysgunnonworld',1,FCVAR_ARCHIVE,'Allows the Zeta to physgun non world ents',0,1)
CreateConVar('zetaplayer_allowphysgunworld',0,FCVAR_ARCHIVE,'Allows the Zeta to physgun world ents',0,1)
CreateConVar('zetaplayer_allowphysgunplayers',0,FCVAR_ARCHIVE,'Allows the Zeta to physgun players',0,1)
CreateConVar('zetaplayer_allowphysgunzetas',0,FCVAR_ARCHIVE,'Allows the Zeta to physgun other Zetas',0,1)
CreateConVar('zetaplayer_allowcolortool',1,FCVAR_ARCHIVE,'Allows the Zeta to use the Color Tool',0,1)
CreateConVar('zetaplayer_allowmaterialtool',1,FCVAR_ARCHIVE,'Allows the Zeta to use the Material Tool',0,1)
CreateConVar('zetaplayer_allowropetool',1,FCVAR_ARCHIVE,'Allows the Zeta to use the Rope Tool',0,1)
CreateConVar('zetaplayer_allowlighttool',1,FCVAR_ARCHIVE,'Allows the Zeta to use the Light Tool',0,1)
CreateConVar('zetaplayer_allowmusicboxtool',1,FCVAR_ARCHIVE,'Allows the Zeta to use the Music Box Tool',0,1)
CreateConVar('zetaplayer_allowtrailstool',1,FCVAR_ARCHIVE,'Allows the Zeta to use the Trails Tool',0,1)
CreateConVar('zetaplayer_allowignitertool',1,FCVAR_ARCHIVE,'Allows the Zeta to use the Igniter Tool',0,1)
CreateConVar('zetaplayer_allowballoontool',1,FCVAR_ARCHIVE,'Allows the Zeta to use the Balloon Tool',0,1)
CreateConVar('zetaplayer_randomplayermodelcolor',1,FCVAR_ARCHIVE,'If Zeta models should have a random color applied',0,1)
CreateConVar('zetaplayer_allowremovertool',0,FCVAR_ARCHIVE,'Allows the Zeta to use the Remover Tool',0,1)
CreateConVar('zetaplayer_allowattacking',1,FCVAR_ARCHIVE,'Allows the Zeta to attack people',0,1)
CreateConVar('zetaplayer_allowselfdefense',1,FCVAR_ARCHIVE,'Allows the Zeta to defend itself if it has a lethal weapon',0,1)
CreateConVar('zetaplayer_allowdefendothers',1,FCVAR_ARCHIVE,'Allows the Zeta to defend other players or zetas if they are getting attacked',0,1)
CreateConVar('zetaplayer_allowspawnmenu',1,FCVAR_ARCHIVE,'Allows the Zeta to use its spawnmenu',0,1)
CreateConVar('zetaplayer_allowentities',0,FCVAR_ARCHIVE,'Allows the Zeta to spawn Entities',0,1)
CreateConVar('zetaplayer_allownpcs',0,FCVAR_ARCHIVE,'Allows the Zeta to spawn NPCS',0,1)
CreateConVar('zetaplayer_allowvehicles',1,FCVAR_ARCHIVE,'Allows the Zeta to use Vehicles',0,1)
CreateConVar('zetaplayer_npclimit',1,FCVAR_ARCHIVE,'How much npcs a Zeta is allowed to spawn',0,100)
CreateConVar('zetaplayer_allowfollowingfriend',1,FCVAR_ARCHIVE,'If Zetas are allowed to follow their friend',0,1)
CreateConVar('zetaplayer_allowlaughing',1,FCVAR_ARCHIVE,'If Zetas are allowed to laugh at dead people',0,1)
CreateConVar('zetaplayer_enablefriend',1,FCVAR_ARCHIVE,'Enable the Friend System',0,1)
CreateConVar('zetaplayer_alternateidlesounds',1,FCVAR_ARCHIVE,'Toggle Alternate Idle sounds',0,1)
CreateConVar('zetaplayer_wanderdistance',1500,FCVAR_ARCHIVE,'The max distance a Zeta can wander to',0,15000)
CreateConVar('zetaplayer_overridemodel','',FCVAR_ARCHIVE,'Override the spawning model of a Zeta')
CreateConVar('zetaplayer_spawnweapon','NONE',FCVAR_ARCHIVE,"Change the Zeta's spawning weapon")
CreateConVar('zetaplayer_naturalspawnweapon','NONE',FCVAR_ARCHIVE,"Change the natural Zeta's spawning weapon")
CreateConVar('zetaplayer_panicthreshold',0.3,FCVAR_ARCHIVE,"Health Threshold where if the a Zeta's health is below it, it may panic",0,1)
CreateConVar('zetaplayer_allowlargeprops',1,FCVAR_ARCHIVE,'If Zetas are allowed to spawn large props',0,1)
CreateConVar('zetaplayer_propspawnunfrozen',0,FCVAR_ARCHIVE,'If Props should spawn unfrozen. This will cause lag!',0,1)
CreateConVar('zetaplayer_mapwidespawning',0,FCVAR_ARCHIVE,'If Zetas should naturally spawn map wide. This will automatically create Zetas',0,1)
CreateConVar('zetaplayer_mapwidespawningzetaamount',10,FCVAR_ARCHIVE,'How many Zetas should spawn when using map wide spawning',1,300)
CreateConVar('zetaplayer_voicevolume',1,FCVAR_ARCHIVE,'The Volume of Zeta Voices',0.1,10.0)
CreateConVar('zetaplayer_removepropsondeath',1,FCVAR_ARCHIVE,"If a Zeta's props should be removed upon removal. You probably shouldn't touch this unless you want their props to be saved",0,1)
CreateConVar('zetaplayer_freezelargeprops',1,FCVAR_ARCHIVE,'If a large prop spawned by a Zeta should be frozen. To prevent any physics crash from large props',0,1)
CreateConVar('zetaplayer_ignorezetas',0,FCVAR_NONE,'If the Zetas should ignore each other',0,1)
CreateConVar('zetaplayer_randomplayermodels',0,FCVAR_ARCHIVE,'Allows the Zetas to have random playermodels',0,1)
CreateConVar('zetaplayer_randomdefaultplayermodels',0,FCVAR_ARCHIVE,'If the random playermodels should only be from the base game',0,1)
CreateConVar('zetaplayer_lightlimit',5,FCVAR_ARCHIVE,'How much lights a Zeta is allowed to spawn',1,30)
CreateConVar('zetaplayer_musicboxlimit',1,FCVAR_ARCHIVE,'How much music boxes a Zeta is allowed to spawn',1,30)
CreateConVar('zetaplayer_balloonlimit',5,FCVAR_ARCHIVE,'How much balloons a Zeta is allowed to spawn',1,100)
CreateConVar('zetaplayer_ropelimit',5,FCVAR_ARCHIVE,'How much ropes a Zeta is allowed to place',1,100)
CreateConVar('zetaplayer_proplimit',50,FCVAR_ARCHIVE,'How much props a Zeta is allowed to spawn',1,500)
CreateConVar('zetaplayer_sentlimit',10,FCVAR_ARCHIVE,'How much SENTS a Zeta is allowed to spawn',1,200)
CreateConVar('zetaplayer_usealternatedeathsounds',0,FCVAR_ARCHIVE,'Play alternate deaths sounds apart from the kleiner death sound',0,1)
CreateConVar('zetaplayer_cleanupcorpse',0,FCVAR_ARCHIVE,'If dead Zetas should be cleaned',0,1)
CreateConVar('zetaplayer_cleanupcorpseeffect',1,FCVAR_ARCHIVE,'If Corpses should play a effect before being removed',0,1)
CreateConVar('zetaplayer_mapwidespawninguseplayerstart',0,FCVAR_ARCHIVE,'If Natural Zetas should spawn at Player Spawnpoints',0,1)
CreateConVar('zetaplayer_cleanupcorpsetime',15,FCVAR_ARCHIVE,'The time before corpses should be cleaned',1,190)
CreateConVar('zetaplayer_disabled',0,FCVAR_NONE,'Disables the Zeta from thinking',0,1)
CreateConVar('zetaplayer_custommusiconly',0,FCVAR_ARCHIVE,'If Custom Music should only be played by Zeta Music Boxes',0,1)
CreateConVar('zetaplayer_musicvolume',1,FCVAR_ARCHIVE,'The volume of music played by the Music Box',0,10)
CreateConVar('zetaplayer_allowpainvoice',1,FCVAR_ARCHIVE,'If Zetas should make pain sounds',0,1)
CreateConVar('zetaplayer_allowpanicvoice',1,FCVAR_ARCHIVE,'If Zetas should make panic sounds',0,1)
CreateConVar('zetaplayer_allowidlevoice',1,FCVAR_ARCHIVE,'If Zetas should make idle sounds',0,1)
CreateConVar('zetaplayer_allowdeathvoice',1,FCVAR_ARCHIVE,'If Zetas should make death sounds',0,1)
CreateConVar('zetaplayer_allowar2altfire',1,FCVAR_ARCHIVE,'If Zetas are allowed to use the AR2 alt fire',0,1)
CreateConVar('zetaplayer_allowbackstabbing',1,FCVAR_ARCHIVE,'If Zetas are allowed to have increased attack damage when backstabbing with a knife',0,1)
CreateConVar('zetaplayer_allowwitnesssounds',1,FCVAR_ARCHIVE,'If Zetas are allowed to make witness sounds',0,1)
CreateConVar('zetaplayer_allowfalldamage',1,FCVAR_ARCHIVE,'If Zetas should take fall damage',0,1)
CreateConVar('zetaplayer_allowrealisticfalldamge',0,FCVAR_ARCHIVE,'If Zetas should take realistic fall damage. Note, Fall damage must be on for this to apply',0,1)
CreateConVar('zetaplayer_allowfaceposertool',1,FCVAR_ARCHIVE,'If Zetas are allowed to use the Faceposer tool',0,1)
CreateConVar('zetaplayer_allowemittertool',1,FCVAR_ARCHIVE,'If Zetas are allowed to use the Emitter tool',0,1)
CreateConVar('zetaplayer_emitterlimit',2,FCVAR_ARCHIVE,'How much emitters a Zeta is allowed to spawn',1,100)
CreateConVar('zetaplayer_allowmlgshots',1,FCVAR_ARCHIVE,'If Zetas are allowed to have increased attack damage randomly with the AWP',0,1)
CreateConVar('zetaplayer_drawcameraflashing',0,FCVAR_ARCHIVE,'If Zeta Cameras are allowed to emit a flash',0,1)
CreateConVar('zetaplayer_bonemanipulatortool',1,FCVAR_ARCHIVE,'If Zetas are allowed to use the Bone Manipulator Tool',0,1)
CreateConVar('zetaplayer_allowdynamitetool',1,FCVAR_ARCHIVE,'If Zetas are allowed to use the Dynamite tool',0,1)
CreateConVar('zetaplayer_dynamitelimit',2,FCVAR_ARCHIVE,'How much dynamite a Zeta is allowed to spawn',1,100)
CreateConVar('zetaplayer_allowcameraaslethalweapon',0,FCVAR_ARCHIVE,'If Zetas are allowed to equip the camera when trying to defend themselves',0,1)
CreateConVar('zetaplayer_allowpainttool',1,FCVAR_ARCHIVE,'If Zetas are allowed to use the Paint Tool',0,1)
CreateConVar('zetaplayer_allowkillvoice',1,FCVAR_ARCHIVE,'If Zetas can speak a line when killing someone',0,1)
CreateConVar('zetaplayer_allowtauntvoice',1,FCVAR_ARCHIVE,'If Zetas can taunt before attacking someone or defend themselves',0,1)
CreateConVar('zetaplayer_permamentfriend','',FCVAR_ARCHIVE,'If a Zeta spawns with provided name, they will always be your friend')
CreateConVar('zetaplayer_zetaspawnersaveidentity',1,FCVAR_ARCHIVE,'If Zeta Spawners should save identities',0,1)
CreateConVar('zetaplayer_allowzetascreenshots',0,FCVAR_ARCHIVE,'If Zetas are allowed to request and take screenshots',0,1)
CreateConVar('zetaplayer_ignoresmallnavareas',0,FCVAR_ARCHIVE,'If Zetas should ignore smaller nav areas',0,1)
CreateConVar('zetaplayer_allowdisconnecting',0,FCVAR_ARCHIVE,'If Zetas are allowed to disconnect from your game',0,1)
CreateConVar('zetaplayer_voicedsp',"normal",FCVAR_ARCHIVE,"The DSP effect on the Zeta's voice",0,1)
CreateConVar('zetaplayer_allowvoicepopup',0,FCVAR_ARCHIVE,"If speaking Zetas should have a voice chat popup",0,1)
CreateConVar('zetaplayer_globalvoicechat',0,FCVAR_ARCHIVE,"If speaking Zeta voice should be hard globally just like real players",0,1)
CreateConVar('zetaplayer_usecustomavatars',0,FCVAR_ARCHIVE,"If Zetas should use custom profile pictures from custom_avatars",0,1)
CreateConVar('zetaplayer_limitdsp',1,FCVAR_ARCHIVE,"Limits the amount of Zetas that can have DSP effects. TURN THIS OFF AT YOUR OWN RISK! This is supposed to keep source from crashing because of all the sounds it has to process!",0,1)
CreateConVar('zetaplayer_showprofilepicturesintab',0,FCVAR_ARCHIVE,"If tab menu should display zeta profile pictures",0,1)
CreateConVar('zetaplayer_dsplimit',7,FCVAR_ARCHIVE,"The amount of Zetas that are allowed to have DSP effects",1,7)
CreateConVar('zetaplayer_zetahealth',100,FCVAR_ARCHIVE,"The amount of health Zetas will spawn with",1,10000)
CreateConVar('zetaplayer_naturalspawnrate',2,FCVAR_ARCHIVE,"The spawn rate in seconds for natural zetas to spawn",0.1,120)
CreateConVar('zetaplayer_permamentfriendalwaysspawn',0,FCVAR_ARCHIVE,"If your permament friend should always be in game",0,1)
CreateConVar('zetaplayer_allowassistsound',1,FCVAR_ARCHIVE,"If Zetas should speak on assists",0,1)
CreateConVar('zetaplayer_dropweapons',0,FCVAR_ARCHIVE,"If Zetas should drop their weapons if they die",0,1)
CreateConVar('zetaplayer_showpfpoverhealth',0,FCVAR_ARCHIVE,"If Zetas should show their profile picture when you hover over them",0,1)
CreateConVar('zetaplayer_naturalzetahealth',100,FCVAR_ARCHIVE,"The amount of health Natural Zetas will spawn with",1,10000)
CreateConVar('zetaplayer_allowstrafing',1,FCVAR_ARCHIVE,"If Zetas should strafe when attacking",0,1)
CreateConVar('zetaplayer_triggermines', 1, FCVAR_ARCHIVE, 'Makes Zetas trigger nearby Combine Mines to explode', 0, 1)
CreateConVar('zetaplayer_triggermines_hoptime', 0.5, FCVAR_ARCHIVE, 'Time required for the mine to hop towards a target after triggering it', 0, 5)
--[[ CreateConVar('zetaplayer_allowdirectingmissiles', 0, FCVAR_ARCHIVE, 'If Zetas can direct their rockets', 0, 1)
CreateConVar('zetaplayer_missileinaccuracy', 0, FCVAR_ARCHIVE, 'The inaccuracy of directed missiles', 0, 5000) ]]
CreateConVar('zetaplayer_disableunstuck', 0, FCVAR_ARCHIVE, 'Disable the Unstuck system. Why?', 0, 1)
CreateConVar('zetaplayer_killontouchnodraworsky', 1, FCVAR_ARCHIVE, 'If Zetas should die when they are touching a nodraw surface or sky surface', 0, 1)
CreateConVar('zetaplayer_customidlelinesonly', 0, FCVAR_ARCHIVE, 'If Custom Idle Lines should only be used', 0, 1)
CreateConVar('zetaplayer_customdeathlinesonly', 0, FCVAR_ARCHIVE, 'If Custom Death Lines should only be used', 0, 1)
CreateConVar('zetaplayer_customkilllinesonly', 0, FCVAR_ARCHIVE, 'If Custom Kill Lines should only be used', 0, 1)
CreateConVar('zetaplayer_customtauntlinesonly', 0, FCVAR_ARCHIVE, 'If Custom Kill Lines should only be used', 0, 1)
CreateConVar('zetaplayer_combatinaccuracy', 0, FCVAR_ARCHIVE, 'The addition to inaccuracy of Zetas in combat', -3, 3)
CreateConVar('zetaplayer_damagedivider', 1, FCVAR_ARCHIVE, 'The amount damage will be divided by', 1, 10)
CreateConVar('zetaplayer_explosivecorpsecleanup', 0, FCVAR_ARCHIVE, 'If Corpses should blow up when they are cleaned', 0, 10)
CreateConVar('zetaplayer_useprofilesystem',0,FCVAR_ARCHIVE,'Use Zeta Profile Database to load data from instead of randomizing it',0,1)
CreateConVar('zetaplayer_norepeatingpfps',0,FCVAR_ARCHIVE,'If enabled, prevents Zetas from having the same profile picture used again',0,1)
CreateConVar('zetaplayer_usenewvoicechatsystem',0,FCVAR_ARCHIVE,'If Zetas speaking should use the new voice chat system | Community Contribute',0,1)
CreateConVar('zetaplayer_allowsprays',0,FCVAR_ARCHIVE,'If Zetas are allowed to use sprays | Community Contribute',0,1)
CreateConVar('zetaplayer_alwayshuntfortargets',0,FCVAR_ARCHIVE,'If Zetas should always hunt for a target',0,1)
CreateConVar('zetaplayer_allowuse+onprops',1,FCVAR_ARCHIVE,'If Zetas are allowed to pickup props with use+',0,1)
CreateConVar('zetaplayer_allowlamptool',1,FCVAR_ARCHIVE,'If Zetas are allowed to use the Lamp tool',0,1)
CreateConVar('zetaplayer_lamplimit',1,FCVAR_ARCHIVE,'Lamp Limit',1,30)
CreateConVar('zetaplayer_allowthrustertool',1,FCVAR_ARCHIVE,'If Zetas are allowed to use the Thruster tool',0,1)
CreateConVar('zetaplayer_thrusterlimit',5,FCVAR_ARCHIVE,'Thruster Limit',1,60)
CreateConVar('zetaplayer_forceadd',0,FCVAR_ARCHIVE,'The amount to add to Damage Force',0,10000)
CreateConVar('zetaplayer_musicplayonce',0,FCVAR_ARCHIVE,'If Music Boxes should only play once and remove themselves',0,1)
CreateConVar('zetaplayer_musicshuffle',1,FCVAR_ARCHIVE,'If Music Boxes should pick music randomly',0,1)
CreateConVar('zetaplayer_showzetalogonscreen',0,FCVAR_ARCHIVE,'If Zeta Events should show up on screen',0,1)
CreateConVar('zetaplayer_thrusterunfreeze',0,FCVAR_ARCHIVE,'If Zeta Thrusters should unfreeze whatever they are welded to',0,1)
CreateConVar('zetaplayer_differentvoicepitch',0,FCVAR_ARCHIVE,'If Zetas should have different pitches in voice',0,1)
CreateConVar('zetaplayer_voicepitchmin',80,FCVAR_ARCHIVE,'Voice pitch min and max',10,100)
CreateConVar('zetaplayer_voicepitchmax',130,FCVAR_ARCHIVE,'Voice pitch min and max',100,255)
CreateConVar('zetaplayer_mingebag',0,FCVAR_ARCHIVE,'If Zetas should be a mingebag',0,1)
CreateConVar('zetaplayer_mapwidemingebag',0,FCVAR_ARCHIVE,'If Natural Zetas should be a mingebag',0,1)
CreateConVar('zetaplayer_mapwidemingebagspawnchance',10,FCVAR_ARCHIVE,'The chance a natural Zeta will spawn as a mingebag',1,100)
CreateConVar('zetaplayer_allowscoldvoice',1,FCVAR_ARCHIVE,'If Admins should scold their offender',0,1)
CreateConVar('zetaplayer_zetaspawnerrespawntime',1,FCVAR_ARCHIVE,'Respawning Zeta spawn rate',0,120)
CreateConVar('zetaplayer_playersizedsprays',1,FCVAR_ARCHIVE,'If Sprays should mimic the size of real player sprays',0,1)
CreateConVar('zetaplayer_enabledrowning',1,FCVAR_ARCHIVE,'If Zetas should drown in water',0,1)
CreateConVar('zetaplayer_bugbait_limit',4,FCVAR_ARCHIVE,'The amount of antlions a Zeta can summon',1,30)
CreateConVar('zetaplayer_bugbait_lifetime',10,FCVAR_ARCHIVE,'The amount of time antlions can live for',0,120)
CreateConVar('zetaplayer_bugbait_spawnhp',30,FCVAR_ARCHIVE,'The amount of health antlions will spawn with',1,500)
CreateConVar('zetaplayer_jpgpropamount',15,FCVAR_ARCHIVE,'The amount of props the JPG will fire',1,15)
CreateConVar('zetaplayer_c4debris',0,FCVAR_ARCHIVE,'If C4 should create debris on explosion',0,1)
CreateConVar('zetaplayer_c4card',0,FCVAR_ARCHIVE,'If C4 should show up in a MW2 Card if the addon is installed',0,1)

CreateConVar('zetaplayer_serverjunk',0,FCVAR_ARCHIVE,'If Props should be spawned when the player loads in',0,1)
CreateConVar('zetaplayer_freezeserverjunk',0,FCVAR_ARCHIVE,'If server junk should spawn frozen',0,1)
CreateConVar('zetaplayer_serverjunkcount',45,FCVAR_ARCHIVE,'The amount of props that will spawn on the map',0,400)



CreateConVar('zetaplayer_customwitnesslinesonly', 0, FCVAR_ARCHIVE, 'If Custom Witness Lines should only be used', 0, 1)
CreateConVar('zetaplayer_custompaniclinesonly', 0, FCVAR_ARCHIVE, 'If Custom Panic Lines should only be used', 0, 1)
CreateConVar('zetaplayer_customassistlinesonly', 0, FCVAR_ARCHIVE, 'If Custom Assist Lines should only be used', 0, 1)
CreateConVar('zetaplayer_customlaughlinesonly', 0, FCVAR_ARCHIVE, 'If Custom Laughing Lines should only be used', 0, 1)
CreateConVar('zetaplayer_customadminscoldlinesonly', 0, FCVAR_ARCHIVE, 'If Custom Admin Scolding Lines should only be used', 0, 1)





CreateConVar('zetaplayer_useteamsystem',0,FCVAR_ARCHIVE,'If Zetas should join a team if they can',0,1)
CreateConVar('zetaplayer_eachteammemberlimit',3,FCVAR_ARCHIVE,'How many members can be in a team',2,100)
CreateConVar('zetaplayer_playerteam','',FCVAR_ARCHIVE,'What Team real players should be in')
CreateConVar('zetaplayer_overrideteam','',FCVAR_ARCHIVE,'What Team Zetas should be forced in')


CreateConVar('zetaplayer_randombodygroups',1,FCVAR_ARCHIVE,'If Zetas should have random bodygroups',0,1)
CreateConVar('zetaplayer_randomskingroups',1,FCVAR_ARCHIVE,'If Zetas should have random skins',0,1)

CreateConVar('zetaplayer_personalitytype','random',FCVAR_ARCHIVE,'Type of personality the Zeta will be')
CreateConVar('zetaplayer_buildchance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_combatchance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_toolchance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_physgunchance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_disrespectchance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_watchmediaplayerchance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_friendlychance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_voicechance',30,FCVAR_ARCHIVE,'voice Chance',0,100)
CreateConVar('zetaplayer_vehiclechance',30,FCVAR_ARCHIVE,'Vehicle Chance',0,100)


CreateConVar('zetaplayer_naturalpersonalitytype','random',FCVAR_ARCHIVE,'Type of personality the Zeta will be')
CreateConVar('zetaplayer_naturalbuildchance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_naturalcombatchance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_naturaltoolchance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_naturalphysgunchance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_naturaldisrespectchance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_naturalwatchmediaplayerchance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_naturalfriendlychance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_naturalvoicechance',30,FCVAR_ARCHIVE,'voice Chance',0,100)
CreateConVar('zetaplayer_naturalvehiclechance',30,FCVAR_ARCHIVE,'Vehicle Chance',0,100)




CreateConVar('zetaplayer_friendusecustomcolors',0,FCVAR_ARCHIVE,"Playermodel Color",0,1)
CreateConVar('zetaplayer_friendplayermodelcolorR',0,FCVAR_ARCHIVE,"Playermodel Color",0,255)
CreateConVar('zetaplayer_friendplayermodelcolorG',0,FCVAR_ARCHIVE,"Playermodel Color",0,255)
CreateConVar('zetaplayer_friendplayermodelcolorB',0,FCVAR_ARCHIVE,"Playermodel Color",0,255)

CreateConVar('zetaplayer_friendusephysguncolor',0,FCVAR_ARCHIVE,"Physgun Color",0,1)
CreateConVar('zetaplayer_friendphysguncolorR',0,FCVAR_ARCHIVE,"Physgun Color",0,255)
CreateConVar('zetaplayer_friendphysguncolorG',0,FCVAR_ARCHIVE,"Physgun Color",0,255)
CreateConVar('zetaplayer_friendphysguncolorB',0,FCVAR_ARCHIVE,"Physgun Color",0,255)

CreateConVar('zetaplayer_friendhealth',100,FCVAR_ARCHIVE,"The amount of health your friend will spawn with",1,10000)
CreateConVar('zetaplayer_friendprofilepicture', "", FCVAR_ARCHIVE, "Permament Friend Zeta's Profile Picture")
CreateConVar('zetaplayer_friendcustomidlelinesonly', 0, FCVAR_ARCHIVE, 'If Custom Idle Lines should only be used', 0, 1)
CreateConVar('zetaplayer_friendcustomdeathlinesonly', 0, FCVAR_ARCHIVE, 'If Custom Death Lines should only be used', 0, 1)
CreateConVar('zetaplayer_friendcustomkilllinesonly', 0, FCVAR_ARCHIVE, 'If Custom Kill Lines should only be used', 0, 1)
CreateConVar('zetaplayer_friendcustomtauntlinesonly', 0, FCVAR_ARCHIVE, 'If Custom Taunt Lines should only be used', 0, 1)
CreateConVar('zetaplayer_friendcustompaniclinesonly', 0, FCVAR_ARCHIVE, 'If Custom Panic Lines should only be used', 0, 1)
CreateConVar('zetaplayer_friendcustomassistlinesonly', 0, FCVAR_ARCHIVE, 'If Custom Assist Lines should only be used', 0, 1)
CreateConVar('zetaplayer_friendcustomlaughlinesonly', 0, FCVAR_ARCHIVE, 'If Custom Laughing Lines should only be used', 0, 1)
CreateConVar('zetaplayer_friendcustomwitnesslinesonly', 0, FCVAR_ARCHIVE, 'If Custom Witness Lines should only be used', 0, 1)
CreateConVar('zetaplayer_friendcustomadminscoldlinesonly', 0, FCVAR_ARCHIVE, 'If Custom Admin Scolding Lines should only be used', 0, 1)


CreateConVar('zetaplayer_friendisadmin', 0, FCVAR_ARCHIVE, 'If the permanent friend should be a admin', 0, 1)

CreateConVar('zetaplayer_friendoverridemodel','',FCVAR_ARCHIVE,'Override the spawning model of a Zeta')
CreateConVar('zetaplayer_friendpersonalitytype','random',FCVAR_ARCHIVE,'Type of personality the Zeta will be')
CreateConVar('zetaplayer_friendbuildchance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_friendcombatchance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_friendtoolchance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_friendphysgunchance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_frienddisrespectchance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_friendwatchmediaplayerchance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_friendfriendlychance',30,FCVAR_ARCHIVE,'Personality Chance',0,100)
CreateConVar('zetaplayer_friendvoicechance',30,FCVAR_ARCHIVE,'voice Chance',0,100)
CreateConVar('zetaplayer_friendvehiclechance',30,FCVAR_ARCHIVE,'Vehicle Chance',0,100)
CreateConVar('zetaplayer_friendspawnweapon','NONE',FCVAR_ARCHIVE,"Change the permament friend Zeta's spawning weapon")

--CreateConVar('zetaplayer_laughingchance',6,FCVAR_ARCHIVE,'Vehicle Chance',0,100)




-- Admin Convars 
CreateConVar('zetaplayer_admindisplaynameRed',0,FCVAR_ARCHIVE,'Red value of the display name color',0,255)
CreateConVar('zetaplayer_admindisplaynameGreen',148,FCVAR_ARCHIVE,'Green value of the display name color',0,255)
CreateConVar('zetaplayer_admindisplaynameBlue',255,FCVAR_ARCHIVE,'Blue value of the display name color',0,255)

CreateConVar('zetaplayer_adminoverridemodel','models/player/police.mdl',FCVAR_ARCHIVE,'Override the spawning model of a Admin Zeta')
CreateConVar('zetaplayer_spawnasadmin',0,FCVAR_ARCHIVE,'If Admins should spawn',0,1)
CreateConVar('zetaplayer_forcespawnadmins',0,FCVAR_ARCHIVE,'If Zetas that you spawn next should become admins',0,1)
CreateConVar('zetaplayer_adminrule_nopropkill',1,FCVAR_ARCHIVE,'Enforce no prop killing',0,1)
CreateConVar('zetaplayer_adminrule_rdm',1,FCVAR_ARCHIVE,'Enforce no random killing.',0,1)
CreateConVar('zetaplayer_adminrule_griefing',1,FCVAR_ARCHIVE,'Enforce no altering of other entities that you do not own.',0,1)
CreateConVar('zetaplayer_admintreatowner',0,FCVAR_ARCHIVE,'If admins should treat you as the owner and ignore your rulebreaking',0,1)
CreateConVar('zetaplayer_adminprintecho',1,FCVAR_ARCHIVE,'If admins using commands should have their commands echo into chat',0,1)
CreateConVar('zetaplayer_adminsctrictnessmin',0,FCVAR_ARCHIVE,'How Strict and harsh should the admins be',0,100)
CreateConVar('zetaplayer_adminsctrictnessmax',30,FCVAR_ARCHIVE,'How Strict and harsh should the admins be',0,100)
CreateConVar('zetaplayer_adminshouldsticktogether',0,FCVAR_ARCHIVE,'If admins should stick together most of the time',0,1)
CreateConVar('zetaplayer_admincount',1,FCVAR_ARCHIVE,'How many Admins can there be',1,100)


CreateConVar('zetaplayer_allowpistol',1,FCVAR_ARCHIVE,'Allows the Zeta to equip the pistol',0,1)
CreateConVar('zetaplayer_allowar2',1,FCVAR_ARCHIVE,'Allows the Zeta to equip the ar2',0,1)
CreateConVar('zetaplayer_allowshotgun',1,FCVAR_ARCHIVE,'Allows the Zeta to equip the shotgun',0,1)
CreateConVar('zetaplayer_allowsmg',1,FCVAR_ARCHIVE,'Allows the Zeta to equip the smg',0,1)
CreateConVar('zetaplayer_allowrpg',1,FCVAR_ARCHIVE,'Allows the Zeta to equip the rpg',0,1)
CreateConVar('zetaplayer_allowcrowbar',1,FCVAR_ARCHIVE,'Allows the Zeta to equip the crowbar',0,1)
CreateConVar('zetaplayer_allowstunstick',1,FCVAR_ARCHIVE,'Allows the Zeta to equip the stunstick',0,1)
CreateConVar('zetaplayer_allowrevolver',1,FCVAR_ARCHIVE,'Allows the Zeta to equip the revolver',0,1)
CreateConVar('zetaplayer_allowtoolgun',1,FCVAR_ARCHIVE,'Allows the Zeta to equip the toolgun',0,1)
CreateConVar('zetaplayer_allowphysgun',1,FCVAR_ARCHIVE,'Allows the Zeta to equip the physgun',0,1)
CreateConVar('zetaplayer_allowknife',1,FCVAR_ARCHIVE,'Allows the Zeta to equip the knife',0,1)
CreateConVar('zetaplayer_allowfist',1,FCVAR_ARCHIVE,'Allows the Zeta to use their fists',0,1)
CreateConVar('zetaplayer_allowcrossbow',1,FCVAR_ARCHIVE,'Allows the Zeta to use the crossbow',0,1)
CreateConVar('zetaplayer_allowm4a1',1,FCVAR_ARCHIVE,'Allows the Zeta to use the m4a1',0,1)
CreateConVar('zetaplayer_allowawp',1,FCVAR_ARCHIVE,'Allows the Zeta to use the awp',0,1)
CreateConVar('zetaplayer_allowcamera',1,FCVAR_ARCHIVE,'Allows the Zeta to use the camera',0,1)
CreateConVar('zetaplayer_allowwrench',1,FCVAR_ARCHIVE,'Allows the Zeta to use the Wrench',0,1)
CreateConVar('zetaplayer_allowscattergun',1,FCVAR_ARCHIVE,'Allows the Zeta to use the Scatter gun',0,1)
CreateConVar('zetaplayer_allowtf2pistol',1,FCVAR_ARCHIVE,'Allows the Zeta to use the TF2 Pistol',0,1)
CreateConVar('zetaplayer_allowak47',1,FCVAR_ARCHIVE,'Allows the Zeta to use the AK47',0,1)
CreateConVar('zetaplayer_allowmachinegun',1,FCVAR_ARCHIVE,'Allows the Zeta to use the Machine Gun',0,1)
CreateConVar('zetaplayer_allowdeagle',1,FCVAR_ARCHIVE,'Allows the Zeta to use the Desert Eagle',0,1)
CreateConVar('zetaplayer_allowtf2sniper',1,FCVAR_ARCHIVE,'Allows the Zeta to use the TF2 Sniper',0,1)
CreateConVar('zetaplayer_allowtf2shotgun',1,FCVAR_ARCHIVE,'Allows the Zeta to use the TF2 Shotgun',0,1)
CreateConVar('zetaplayer_allowgrenades',1,FCVAR_ARCHIVE,'Allows the Zeta to use Grenades',0,1)
CreateConVar('zetaplayer_allowmp5',1,FCVAR_ARCHIVE,'Allows the Zeta to use MP5',0,1)
CreateConVar('zetaplayer_allowjpg',1,FCVAR_ARCHIVE,'Allows the Zeta to use the JPG',0,1)









if ( SERVER ) then


    net.Receive("zeta_realplayerendvoice",function(len,ply)
        hook.Run("ZetaRealPlayerEndVoice",ply)
    end)



    net.Receive('zeta_csragdollexplode', function()
        local blastSrc = net.ReadVector()
        util.BlastDamage(Entity(0), Entity(0), blastSrc, 250, math.random(1,500))
    end)

    net.Receive('zeta_sendvoiceicon', function()
        local zeta = net.ReadEntity()
        local dur = net.ReadFloat()
    
        net.Start('zeta_voiceicon', true)
            net.WriteEntity(zeta)
            net.WriteFloat(dur)
        net.Broadcast()
    end)


    net.Receive('zetapanel_getnames',function(len,ply)
        local json = file.Read("zetaplayerdata/names.json","DATA")
        local tbl = util.JSONToTable(json)
        for k,name in ipairs(tbl) do
            local isdone = false
            if k == #tbl then
                isdone = true
            end
            net.Start("zetapanel_sendnames")
            net.WriteString(name)
            net.WriteBool(isdone)
            net.Send(ply)
        end
    end)

    net.Receive('zetapanel_resetnames',function(len,ply)
        ResetNamestoDefault(ply)
    end)

    net.Receive('zetapanel_removename',function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to remove names!') return end
        local _string = net.ReadString()
        
            local json = file.Read("zetaplayerdata/names.json","DATA")
            local decoded = util.JSONToTable(json)
            if !table.HasValue(decoded,_string) then ply:PrintMessage(HUD_PRINTCONSOLE,_string.." is not Registered!") return end
            table.RemoveByValue(decoded,_string)
            local encoded = util.TableToJSON(decoded,true)
            file.Write("zetaplayerdata/names.json",encoded)
            ply:PrintMessage(HUD_PRINTCONSOLE,"Removed ".._string.." from Zeta's names")
    end)

    net.Receive('zetapanel_addname',function(len,ply)
        if !ply:IsSuperAdmin() then ply:PrintMessage(HUD_PRINTCONSOLE,'Only Super Admins are allowed to register names!') return end
        local _string = net.ReadString()


            local json = file.Read("zetaplayerdata/names.json","DATA")
            local decoded = util.JSONToTable(json)
            if table.HasValue(decoded,_string) then
                 ply:PrintMessage(HUD_PRINTCONSOLE,_string.." is already registered!")
                 net.Start('zeta_notifycleanup',true)
                 net.WriteString(_string..' is already registered!')
                 net.WriteBool(true)
                 net.Send(ply)
                  return
                 end
            table.insert(decoded,_string)
            local encoded = util.TableToJSON(decoded,true)
            file.Write("zetaplayerdata/names.json",encoded)
            ply:PrintMessage(HUD_PRINTCONSOLE,"Added ".._string.." To Zeta's names")

            net.Start('zeta_notifycleanup',true)
            net.WriteString("Added ".._string.." To Zeta's names")
            net.WriteBool(false)
            net.Send(ply)
    end)


    net.Receive('zetapanel_resetteams',function(len,ply)
        ResetTeamstoDefault(ply)
    end)


    





    hook.Add("PlayerSpawnedProp","zeta_SetPropCreator",function(ply,mdl,prop)
        timer.Simple(0,function()
            if IsValid(prop) then
                prop:SetCreator(ply)
            end
        end)
    end)

    hook.Add("PlayerSpawnedVehicle","zeta_SetVehicleCreator",function(ply,vehicle)
        timer.Simple(0,function()
            if IsValid(vehicle) then
                vehicle:SetCreator(ply)
            end
        end)
    end)

    hook.Add("PlayerSpawnedRagdoll","zeta_SetRagdollCreator",function(ply,mdl,ragdoll)
        timer.Simple(0,function()
            if IsValid(ragdoll) then
                ragdoll:SetCreator(ply)
            end
        end)
    end)

    hook.Add("PlayerSpawnedEffect","zeta_SetEffectCreator",function(ply,mdl,effect)
        timer.Simple(0,function()
            if IsValid(effect) then
                effect:SetCreator(ply)
            end
        end)
    end)

    hook.Add("PlayerSpawnedSWEP","zeta_SetSwepCreator",function(ply,swep)
        timer.Simple(0,function()
            if IsValid(swep) then
                swep:SetCreator(ply)
            end
        end)
    end)
    
    
    
    hook.Add('PlayerSpawnedNPC','zetaSetCreator',function(ply,ent)
        timer.Simple(0, function()
            if IsValid(ent) and ent:GetClass() == 'npc_zetaplayer' then
                ent:SetCreator(ply)
            end
        end)
    end)

    hook.Add("OnEntityCreated","zeta_Createmedkittimers",function(ent)
        timer.Simple(0, function()
            if IsValid(ent) then
                if ent:GetClass() == "item_healthkit" or ent:GetClass() == "item_healthvial" or ent:GetClass() == "sent_ball" or ent:GetClass() == "item_battery" then
                    ent.ZetaSpawnTimer = CurTime()+1
                end
            end
        end)
    
    end)


    hook.Add("PlayerSpawnedSENT","zeta_setmedkitcreators",function(ply,ent)
        timer.Simple(0,function()
            if IsValid(ent) then
                if ent:GetClass() == "item_healthkit" or ent:GetClass() == "item_healthvial" or ent:GetClass() == "sent_ball" or ent:GetClass() == "item_battery" then
                    ent:SetCreator(ply)
                end
            end
        end)
    end)

    hook.Add("PlayerInitialSpawn","zetaSpawnProps",function(ply)
        if GetConVar("zetaplayer_serverjunk"):GetInt() == 0 then return end
        if !game.SinglePlayer() then return end
        local jsonfile = file.Read('zetaplayerdata/props.json','DATA')
        local decoded = util.JSONToTable(jsonfile)
        local count = GetConVar("zetaplayer_serverjunkcount"):GetInt()
        local function GetOverWaterNav()
            local areas = navmesh.GetAllNavAreas()
            local found = {}
            for k,v in ipairs(areas) do
                if IsValid(v) and !v:IsUnderwater() and v:GetSizeX() >= 70 and v:GetSizeY() >= 70 then
                    table.insert(found,v)
                end
            end
            return found
        end
        
        local areas = GetOverWaterNav()
        local currentcount = 0
        
        if istable(areas) then
            for i=1, count do
                if currentcount >= count then break end
                local mdl = decoded[math.random(#decoded)]
        
                local area = areas[math.random(#areas)]
        
                if IsValid(area) then
                    local prop = ents.Create("prop_physics")
                    prop:SetModel(mdl)
                    local mins = prop:OBBMins()
                    prop:SetPos(area:GetRandomPoint() - prop:GetUp() * mins.z)
                    prop:SetAngles(Angle(0,math.random(-180,180),0))
                    prop.IsZetaProp = true 
                    prop:Spawn()
                    local phys = prop:GetPhysicsObject()
                    if IsValid(phys) then
                        phys:EnableMotion(!GetConVar("zetaplayer_freezeserverjunk"):GetBool())
                    end
                    currentcount = currentcount + 1
                end
            end
                
                

        end


    
    end)



    local hitScales = {
        [HITGROUP_HEAD] = GetConVar('sk_player_head'),
        [HITGROUP_LEFTARM] = GetConVar('sk_player_arm'),
        [HITGROUP_RIGHTARM] = GetConVar('sk_player_arm'),
        [HITGROUP_CHEST] = GetConVar('sk_player_chest'),
        [HITGROUP_STOMACH] = GetConVar('sk_player_stomach'),
        [HITGROUP_LEFTLEG] = GetConVar('sk_player_leg'),
        [HITGROUP_RIGHTARM] = GetConVar('sk_player_leg')
    }
    local boneHitgroups = {
        ["ValveBiped.Bip01_Head1"] = HITGROUP_HEAD,
        ["ValveBiped.Bip01_Neck1"] = HITGROUP_HEAD,
    
        ["ValveBiped.Bip01_L_Clavicle"] = HITGROUP_CHEST,
        ["ValveBiped.Bip01_R_Clavicle"] = HITGROUP_CHEST,
        ["ValveBiped.Bip01_Spine4"] = HITGROUP_CHEST,
        ["ValveBiped.Bip01_Spine2"] = HITGROUP_CHEST,
    
        ["ValveBiped.Bip01_Spine1"] = HITGROUP_STOMACH,
        ["ValveBiped.Bip01_Spine"] = HITGROUP_STOMACH,
        ["ValveBiped.Bip01_Pelvis"] = HITGROUP_STOMACH,
    
        ["ValveBiped.Bip01_L_UpperArm"] = HITGROUP_LEFTARM,
        ["ValveBiped.Bip01_L_Forearm"] = HITGROUP_LEFTARM,
        ["ValveBiped.Bip01_L_Hand"] = HITGROUP_LEFTARM,
    
        ["ValveBiped.Bip01_R_UpperArm"] = HITGROUP_RIGHTARM,
        ["ValveBiped.Bip01_R_Forearm"] = HITGROUP_RIGHTARM,
        ["ValveBiped.Bip01_R_Hand"] = HITGROUP_RIGHTARM,
    
        ["ValveBiped.Bip01_L_Thigh"] = HITGROUP_LEFTLEG,
        ["ValveBiped.Bip01_L_Calf"] = HITGROUP_LEFTLEG,
        ["ValveBiped.Bip01_L_Foot"] = HITGROUP_LEFTLEG,
        ["ValveBiped.Bip01_L_Toe0"] = HITGROUP_LEFTLEG,
    
        ["ValveBiped.Bip01_R_Thigh"] = HITGROUP_RIGHTLEG,
        ["ValveBiped.Bip01_R_Calf"] = HITGROUP_RIGHTLEG,
        ["ValveBiped.Bip01_R_Foot"] = HITGROUP_RIGHTLEG,
        ["ValveBiped.Bip01_R_Toe0"] = HITGROUP_RIGHTLEG
    }
    
    hook.Add('ScaleNPCDamage', 'zetaScaleDamage', function(ent,hit,dmginfo)
        if !ent.IsZetaPlayer then return end
        
        -- Workaround for playermodels with no hitboxes
        local hasHitBoxes = !(hit == 0 and dmginfo:IsBulletDamage())
        if !hasHitBoxes then
            local closestBone = {nil, math.huge}
            for i = 0, ent:GetBoneCount() - 1 do
                local boneName = ent:GetBoneName(i)
                if !boneHitgroups[boneName] then continue end
                local dist = dmginfo:GetDamagePosition():DistToSqr(ent:GetBonePosition(i))
                if dist < closestBone[2] then
                    closestBone = {boneName, dist}
                end
            end
    
            hit = (boneHitgroups[closestBone[1]] or HITGROUP_GENERIC)
        end
    
        if GetConVar('zetaplayer_userealplayerdmgscale'):GetBool() then
            if hasHitBoxes then
                if hit == HITGROUP_HEAD then
                    dmginfo:ScaleDamage(0.5)
                elseif hit == HITGROUP_LEFTARM or hit == HITGROUP_RIGHTARM or hit == HITGROUP_LEFTLEG or hit == HITGROUP_RIGHTLEG then
                    dmginfo:ScaleDamage(4)
                end
            end
            dmginfo:ScaleDamage((hitScales[hit] and hitScales[hit]:GetFloat() or 1.0))
        else
            if hit == HITGROUP_HEAD then
                dmginfo:ScaleDamage(hasHitBoxes and 2 or 4)
            elseif !hasHitBoxes and (hit == HITGROUP_LEFTARM or hit == HITGROUP_RIGHTARM or hit == HITGROUP_LEFTLEG or hit == HITGROUP_RIGHTLEG) then
                dmginfo:ScaleDamage(0.25)
            end
        end
    end)

    local areas = navmesh.GetAllNavAreas()
    local removezetas = false
    local area
    local point
    naturalzetas = {}
    local rate = CurTime()+GetConVar("zetaplayer_naturalspawnrate"):GetFloat()
    local firstspawndelay = CurTime()+6
    hook.Add("Think","zetamapwidespawn",function()
        if CurTime() < firstspawndelay then return end
        if CurTime() < rate then return end
        rate = GetConVar("zetaplayer_mapwidespawningrandom"):GetInt() == 1 and CurTime()+math.Rand(0.1,GetConVar("zetaplayer_naturalspawnrate"):GetFloat()) or CurTime()+GetConVar("zetaplayer_naturalspawnrate"):GetFloat()
        if GetConVar('zetaplayer_mapwidespawning'):GetInt() == 0 then
             if removezetas then 
                removezetas = false  
                for k,v in ipairs(naturalzetas) do
                    if v:IsValid() then
                        v:Remove()
                    end
                end

                for k,v in ipairs(ents.FindByClass('npc_zetaplayer')) do
                    if v:IsValid() and v.IsNatural then
                        v:Remove()
                    end
                end
            end 
            return 
        end
        if #naturalzetas > GetConVar('zetaplayer_mapwidespawningzetaamount'):GetInt() then naturalzetas[math.random(#naturalzetas)]:Remove() return end
        if #naturalzetas >= GetConVar('zetaplayer_mapwidespawningzetaamount'):GetInt() then return end
        removezetas = true
        if GetConVar('zetaplayer_mapwidespawninguseplayerstart'):GetInt() == 0 then
        area = areas[math.random(#areas)]
        if !area or !area:IsValid() then
            areas = navmesh.GetAllNavAreas()
            area = areas[math.random(#areas)]
        end

        if !area or !area:IsValid() then
            return
        end
        if area:IsUnderwater() then return end
            point = area:GetRandomPoint()
        else
            local info_player_starts = ents.FindByClass('info_player_start')
            local info_player_teamspawns = ents.FindByClass("info_player_teamspawn")
            local info_player_terrorist = ents.FindByClass("info_player_terrorist")
            local info_player_counterterrorist = ents.FindByClass("info_player_counterterrorist")
            local info_player_combine = ents.FindByClass("info_player_combine")
            local info_player_rebel = ents.FindByClass("info_player_rebel")
            local info_player_allies = ents.FindByClass("info_player_allies")
            local info_player_axis = ents.FindByClass("info_player_axis")
            local info_coop_spawn = ents.FindByClass("info_coop_spawn")
            local info_survivor_position = ents.FindByClass("info_survivor_position")
            table.Add(info_player_starts,info_player_teamspawns)
            table.Add(info_player_starts,info_player_terrorist)
            table.Add(info_player_starts,info_player_counterterrorist)
            table.Add(info_player_starts,info_player_combine)
            table.Add(info_player_starts,info_player_rebel)
            table.Add(info_player_starts,info_player_allies)
            table.Add(info_player_starts,info_player_axis)
            table.Add(info_player_starts,info_coop_spawn)
            table.Add(info_player_starts,info_survivor_position)
            local spawn = info_player_starts[math.random(#info_player_starts)]
            if IsValid(spawn) then
                point = spawn:GetPos()
            else
                print('MAP WIDE SPAWNER WARNING: Player Spawn Is not Valid!')
                return
            end
        end


        if !GetConVar("zetaplayer_mwsspawnrespawningzetas"):GetBool() then
            local zeta = ents.Create('npc_zetaplayer')
            table.insert(naturalzetas,zeta)
            zeta:CallOnRemove('zetacallonremove'..zeta:EntIndex(),function()
                table.RemoveByValue(naturalzetas,zeta)
            end)


            zeta:SetPos(point)
            zeta:SetAngles(Angle(0,math.random(0,360,0),0))
            zeta.IsNatural = true
            zeta.NaturalWeapon = GetConVar("zetaplayer_naturalspawnweapon"):GetString()
            zeta:Spawn()
            zeta:EmitSound(GetConVar("zetaplayer_customspawnsound"):GetString() != "" and GetConVar("zetaplayer_customspawnsound"):GetString() or 'zetaplayer/misc/spawn_zeta.wav',60)
        else
            local zeta = ents.Create('zeta_zetaplayerspawner')
            table.insert(naturalzetas,zeta)
            zeta:CallOnRemove('zetacallonremove'..zeta:EntIndex(),function()
                table.RemoveByValue(naturalzetas,zeta)
            end)


            zeta:SetPos(point)
            zeta:SetAngles(Angle(0,math.random(0,360,0),0))
            zeta.IsNatural = true
            zeta.NaturalWeapon = GetConVar("zetaplayer_naturalspawnweapon"):GetString()
            zeta:Spawn()
            zeta:EmitSound(GetConVar("zetaplayer_customspawnsound"):GetString() != "" and GetConVar("zetaplayer_customspawnsound"):GetString() or 'zetaplayer/misc/spawn_zeta.wav',60)

        end
        

    end)







    function FindZetaByName(name)
        if !name then return end
        local zetas = ents.FindByClass("npc_zetaplayer")
        local foundzeta
        name = string.lower(name)

        for k,zeta in ipairs(zetas) do
            if !IsValid(zeta) then continue end
            local find,b,c = string.find(string.lower(zeta.zetaname),name)
            if isnumber(find) then
                foundzeta = zeta
                break
            end
        end

        return foundzeta
    end

    
    
    
    -- More Erma's contributes v v v v v v
    hook.Add('OnEntityCreated', 'zetaSpawnedEntitySupport',function(ent)
        if !ent:IsValid() then return end 

        local entClass = ent:GetClass()
        if entClass == 'npc_sanic' or (ent:IsNextBot() and isfunction(ent.AttackNearbyTargets)) then
            ent.ZetaHook_ClosestZeta = NULL

            local id = ent:GetCreationID()
            hook.Add('Think', 'zeta_sanicNextbotsSupport_'..id, function()
                if !IsValid(ent) then hook.Remove('Think', 'zeta_sanicNextbotsSupport_'..id) return end
                
                local scanTime = GetConVar(entClass..'_expensive_scan_interval'):GetInt() or 1
                if (CurTime() - ent.LastTargetSearch) > scanTime then
                    ent.ZetaHook_ClosestZeta = NULL
                    
                    local lastDist = math.huge
                    local chaseDist = GetConVar(entClass..'_acquire_distance'):GetInt() or 2500
                    for _, v in ipairs(ents.FindByClass('npc_zetaplayer')) do
                        if !v.IsZetaPlayer or v.IsDead then continue end
                        local distSqr = ent:GetRangeSquaredTo(v)
                        if distSqr <= (chaseDist*chaseDist) and distSqr < lastDist then
                            ent.ZetaHook_ClosestZeta = v
                            lastDist = distSqr
                        end
                    end
                end

                local closestZeta = ent.ZetaHook_ClosestZeta
                if !IsValid(closestZeta) then return end 
                
                local curTarget = ent.CurrentTarget
                local zetaDist = ent:GetRangeSquaredTo(closestZeta)
                
                if ent.CurrentTarget != closestZeta then
                    if !IsValid(curTarget) or (ent:GetRangeSquaredTo(curTarget) > zetaDist and closestZeta != curTarget) then
                        ent.CurrentTarget = closestZeta
                    end
                elseif !closestZeta.IsDead then
                    local dmgDist = GetConVar(entClass..'_attack_distance'):GetInt() or 80
                    if zetaDist > (dmgDist*dmgDist) then return end
                    
                    local startHP = closestZeta:Health()

                    local attackForce = GetConVar(entClass..'_attack_force'):GetInt() or 800
                    if isfunction(ent.AttackOpponent) then
                        ent:AttackOpponent(closestZeta, ent:GetPos(), attackForce)
                    else
                        local dmgInfo = DamageInfo()
                        dmgInfo:SetAttacker(ent)
                        dmgInfo:SetInflictor(ent)
                        dmgInfo:SetDamage(1e8)
                        dmgInfo:SetDamagePosition(ent:GetPos())
                        dmgInfo:SetDamageForce(((closestZeta:GetPos() - ent:GetPos()):GetNormal()*attackForce + ent:GetUp()*500)*100)
                        closestZeta:TakeDamageInfo(dmgInfo)

                        ent:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav", 350, 120)
                    end

                    if closestZeta:Health() < startHP then 
                        if ent.TauntSounds and (CurTime() - ent.LastTaunt) > 1.2 then
                            ent.LastTaunt = CurTime()
                            local snd = ent.TauntSounds[math.random(#ent.TauntSounds)]
                            if snd == nil then snd = ent.TauntSounds end
                            if isstring(snd) then
                                ent:EmitSound(snd, 350, 100)
                            end
                        end

                        

                        ent.LastTargetSearch = 0
                    end
                end
            end)
        end

        if GetConVar('zetaplayer_triggermines'):GetInt() != 1 or ent:GetClass() != 'combine_mine' then return end
        
        // Initialize mine's variables
        ent.MineHopTarget = ent.MineHopTarget or NULL
        ent.MineCurrentState = ent.MineCurrentState or 1
        ent.NextMineThinkTime = ent.NextMineThinkTime or CurTime() + 0.1
        
        // Add think hook
        hook.Add('Think', 'mineZetaTrigger'..ent:EntIndex(), function()
            if !IsValid(ent) then hook.Remove('Think', 'mineZetaTrigger'..ent:EntIndex()) return end
            
            // If mine is not placed by a real player and it's at default state, search for zetas
            if CurTime() > ent.NextMineThinkTime and ent:GetInternalVariable('m_bPlacedByPlayer') != true then
                if ent.MineCurrentState == 1 then 
                    if ent:GetInternalVariable('m_iMineState') == 3 then
                        // Loop through all entities with 'npc_zetaplayer' classname
                        for _, v in ipairs(ents.FindByClass('npc_zetaplayer')) do
                            // If zeta is near my by 100 units and visible to me, trigger the mine
                            if v:GetPos():Distance(ent:GetPos()) <= 100 and ent:Visible(v) then
                                // Increment mine's state value
                                ent.MineCurrentState = ent.MineCurrentState + 1
    
                                // Set mine's target
                                ent.MineHopTarget = v
                                
                                // Disarm mine so it won't get interrupted by another target
                                ent:Input('Disarm')
    
                                // Play trigger sound
                                ent:EmitSound('npc/roller/blade_in.wav', 70)
    
                                // Nudge
                                local phys = ent:GetPhysicsObject()
                                if phys:IsValid() then
                                    local vecNudge = Vector(math.Rand(-1, 1), math.Rand(-1, 1), 1.5) * 350
                                    phys:Wake()
                                    phys:ApplyForceCenter(vecNudge)
                                end
    
                                // Set mine's next think time to ConVar's value
                                ent.NextMineThinkTime = CurTime() + GetConVar('zetaplayer_triggermines_hoptime'):GetFloat()
                                return
                            end
                        end
                    end
                elseif ent.MineCurrentState == 2 then
                    // Play hop sound
                    ent:EmitSound('npc/roller/mine/rmine_blip3.wav', 70)
    
                    // The next code is adapted from HL2 source code
                    local phys = ent:GetPhysicsObject()
                    if phys:IsValid() then
                        local maxJumpHeight = 200
    
                        // Figure out how much headroom the mine has, and hop to within a few inches of that.
                        local tr = util.TraceLine({
                            start = ent:GetPos(),
                            endpos = ent:GetPos() + Vector(0, 0, maxJumpHeight),
                            mask = MASK_SHOT,
                            filter = {ent},
                            collisiongroup = COLLISION_GROUP_INTERACTIVE
                        })
    
                        local height
                        if IsValid(tr.Entity) and IsValid(tr.Entity:GetPhysicsObject()) then
                            // Physics object resting on me. Jump as hard as allowed to try to knock it away.
                            height = maxJumpHeight
                        else
                            height = tr.HitPos.z - ent:GetPos().z
                            height = height - 24
                            if height < 0.1 then height = 0.1 end
                        end
    
                        local gravity = GetConVar('sv_gravity'):GetFloat()
                        local time = math.sqrt( height / (0.5 * gravity) )
                        local velocity = gravity * time
    
                        // or you can just AddVelocity to the object instead of ApplyForce
                        local force = velocity * phys:GetMass()
    
                        phys:Wake()
                        phys:ApplyForceCenter( ent:GetUp() * force )
    
                        local target = ent.MineHopTarget
                        if IsValid(target) and !target.IsDead then
                            local vecPredict = target.loco:GetVelocity()
                            phys:ApplyForceCenter( vecPredict * 10 )
                        end
                    end
    
                    // Increment mine's state value
                    ent.MineCurrentState = ent.MineCurrentState + 1
    
                    // If mine touches something, explode
                    ent:AddCallback('PhysicsCollide', function(ent, data)                                 
                        // Create explosion
                        local explode = ents.Create('env_explosion')
                        explode:SetPos(ent:GetPos())
                        explode:SetAngles(ent:GetAngles())
                        explode:SetOwner(ent)
                        explode:SetKeyValue('iMagnitude', 150.0)        // Damage
                        explode:SetKeyValue('iRadiusOverride', 125.0)   // Radius
                        explode:Spawn()
                        explode:Input('Explode')                        // And finally, explode the explosion
    
                        // Remove the mine
                        ent:Remove()
                    end)
    
                    hook.Remove('Think', 'mineZetaTrigger'..ent:EntIndex())
                    return
                end
    
                ent.NextMineThinkTime = CurTime() + 0.1
            end
        end)
    end)



    local props = {
        ["prop_physics"] = true,
        ["prop_physics_multiplayer"] = true,
        ["prop_ragdoll"] = true
    
    }

    hook.Add("OnNPCKilled","zetaaddkillfeed_npc",function(NPC,attacker,inflictor)
    
        if IsValid(attacker) and attacker.IsZetaPlayer then
            local data
            local teamname = ""
      
            if attacker.zetaTeam then
              teamname = " {"..attacker.zetaTeam.."}"
            end
            local killIcon = attacker.WeaponKillIcons[attacker.Weapon]

              data = {
                attacker = attacker.zetaname..teamname,
                attackerteam = 0,
                inflictor = killIcon or " ",
                victim = "#"..NPC:GetClass(),
                victimteam = -1,
                prettyprint = IsValid(inflictor) and inflictor:GetClass() == "prop_physics" and "Physics Prop" or attacker.PrettyPrintWeapon
              }
            
      
      
            net.Start('zeta_addkillfeed',true)
            net.WriteString(util.TableToJSON(data))
            net.WriteBool(killIcon != nil)
            net.Broadcast()  
        end
    
    end)

    hook.Add("PlayerDeath","zetaddkillfeed_player",function(ply,inflict,attacker)

        if IsValid(attacker) and attacker.IsZetaPlayer then
            local data
            local teamname = ""
      
            if attacker.zetaTeam then
              teamname = " {"..attacker.zetaTeam.."}"
            end
            local killIcon = attacker.WeaponKillIcons[attacker.Weapon]
              data = {
                attacker = attacker.zetaname..teamname,
                attackerteam = 0,
                inflictor = killIcon or " ",
                victim = ply:GetName(),
                victimteam = ply:Team(),
                prettyprint = IsValid(inflict) and inflict:GetClass() == "prop_physics" and "Physics Prop" or attacker.PrettyPrintWeapon
              }
      
      
            net.Start('zeta_addkillfeed',true)
            net.WriteString(util.TableToJSON(data))
            net.WriteBool(killIcon != nil)
            net.Broadcast()  
        end

    end)


    hook.Add("PostEntityTakeDamage","zetaADMIN_Rules_Dmg",function(victim,dmginfo)
        if !game.SinglePlayer() then return end
        
        if victim:GetClass() == "npc_zetaplayer" or victim:IsPlayer() then

            local nopropkill = GetConVar("zetaplayer_adminrule_nopropkill"):GetBool()
            local noRDM = GetConVar("zetaplayer_adminrule_rdm"):GetBool()
        
            local inflictor = dmginfo:GetInflictor()
            local attacker = dmginfo:GetAttacker()
            local IsvictimDead = victim:Health() <= 0 
            local propkilled
            if IsValid(inflictor) then
                propkilled = props[inflictor:GetClass()]
            else
                propkilled = false
            end

            

            if attacker:IsNPC() then return end
            if victim == attacker then return end

            if IsValid(attacker) and attacker:IsPlayer() and GetConVar("zetaplayer_admintreatowner"):GetInt() == 1 then return end
        
            
        
            if nopropkill and IsValid(inflictor) and propkilled then
                hook.Run("ZetaAdminRuleViolate",victim,attacker,inflictor,"propkill")
            end
            --print(noRDM,IsValid(attacker),!attacker:IsPlayer(),attacker:GetNW2Bool( 'zeta_aggressor', false ),IsvictimDead,propkilled)
            if noRDM and IsValid(attacker) and !attacker:IsPlayer() and attacker:GetNW2Bool( 'zeta_aggressor', false ) and math.random(1,2) == 1 and !propkilled then
                hook.Run("ZetaAdminRuleViolate",victim,attacker,inflictor,"rdm")

            end

            if noRDM and IsValid(attacker) and attacker:IsPlayer() and !victim:GetNW2Bool( 'zeta_aggressor', false ) and math.random(1,2) == 1 and !propkilled then
                hook.Run("ZetaAdminRuleViolate",victim,attacker,inflictor,"rdm")

            end

        end
    
        
    
        
    
    end)


    hook.Add("CanTool","zetaAdmin_PlayerToolgun",function(ply,tr)
        if GetConVar("zetaplayer_adminrule_griefing"):GetInt() == 0 then return end

        local ent = tr.Entity

        if IsValid(ent) and ent:GetCreator() != ply and math.random(1,6) == 1 then
            hook.Run("ZetaAdminRuleViolate",ply,ply,ply,"grief")
        end
        
    end)


    hook.Add("OnZetaUseToolgun","zetaAdmin_Toolgunenforcement",function(zeta,ent,tool) -- The Zeta that used the tool. The Entity the Zeta used it on. The Tool that was used
        if zeta.IsAdmin then return end
        if !IsValid(zeta) or !IsValid(ent) then return end
        if GetConVar("zetaplayer_adminrule_griefing"):GetInt() == 0 then return end
        local isowner = (zeta == ent:GetOwner())

        if !isowner and math.random(1,6) == 1 then
            hook.Run("ZetaAdminRuleViolate",zeta,zeta,zeta,"grief")
        end

    end)


    hook.Add("PhysgunPickup","ZetaAdmin_Preventphysgun",function(ply,ent)
        if ply.IsJailed then return false end
        if ent.isjailent then return false end
    end)

    hook.Add("CanPlayerSuicide","ZetaAdmin_Preventdeath",function(ply)
        if ply.IsJailed then return false end
    end)

    hook.Add("PlayerNoClip","ZetaAdmin_PreventNoclip",function(ply,state)
        if ply.IsJailed then return false end
    end)

    hook.Add("EntityTakeDamage","ZetaAdmin_PreventDamage",function(targ,dmginfo)
        if IsValid(targ) and targ:IsPlayer() and targ.IsJailed then return true end
        if IsValid(targ) and targ.IsZetaPlayer and targ.IsJailed then return true end
        if IsValid(targ) and targ.zetaIngodmode then return true end
        if IsValid(targ) and IsValid(dmginfo:GetAttacker()) and dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker().IsJailed then return true end
    end)

    hook.Add("CanProperty","ZetaAdmin_PreventProperty",function(ply,proper,ent)
        if ent.isjailent then return false end
    end)

    hook.Add("CanTool","ZetaAdmin_PreventToolgun",function(ply,tr)
        if IsValid(tr.Entity) and tr.Entity.isjailent then return false end
    end)

    hook.Add("EntityRemoved","ZetaAdmin_JailRemove",function(ent)
        if ent.IsZetaPlayer and ent.IsJailed then
            RemoveJailOnEnt(ent)
        end
    end)


    hook.Add("PlayerSpawn","Zetaspawnatteamspawn",function(ply)
        if GetConVar("zetaplayer_spawnatteamspawns"):GetBool() then
            local teamspawns = ents.FindByClass("zeta_teamspawnpoint")
            if #teamspawns > 0 then
                local spawns = {}
                for k,v in ipairs(teamspawns) do
                    if v:GetTeamSpawn() == GetConVar("zetaplayer_playerteam"):GetString() then
                        spawns[#spawns+1] = v
                    end
                end
                local spawn = spawns[math.random(#spawns)]
                if IsValid(spawn) then
                    ply:SetPos(spawn:GetPos())
                end
            end
        end
    end)



    function RemoveJailOnEnt(ply)
        
        if ply.zetaJailEnts then
            for k,prop in ipairs(ply.zetaJailEnts) do
                if IsValid(prop) then
                    prop:Remove()
                end
            end

            ply.zetaJailEnts = nil
        end
    
    end
    
    function CreateJailOnEnt(ply)
        ply.zetaJailEnts = {}
        local mdl1 = Model( "models/props_building_details/Storefront_Template001a_Bars.mdl" )
    
        local jail = { -- ULX Jail
            { pos = Vector( 0, 0, -5 ), ang = Angle( 90, 0, 0 ), mdl=mdl1 },
            { pos = Vector( 0, 0, 97 ), ang = Angle( 90, 0, 0 ), mdl=mdl1 },
            { pos = Vector( 21, 31, 46 ), ang = Angle( 0, 90, 0 ), mdl=mdl1 },
            { pos = Vector( 21, -31, 46 ), ang = Angle( 0, 90, 0 ), mdl=mdl1 },
            { pos = Vector( -21, 31, 46 ), ang = Angle( 0, 90, 0 ), mdl=mdl1 },
            { pos = Vector( -21, -31, 46), ang = Angle( 0, 90, 0 ), mdl=mdl1 },
            { pos = Vector( -52, 0, 46 ), ang = Angle( 0, 0, 0 ), mdl=mdl1 },
            { pos = Vector( 52, 0, 46 ), ang = Angle( 0, 0, 0 ), mdl=mdl1 },
        }
    
    
        if ply:IsPlayer() then
            ply:SetMoveType(MOVETYPE_WALK)
        end
    
        for _, v in ipairs( jail ) do
            local ent = ents.Create( "prop_physics" )
            ent:SetModel( v.mdl )
            ent:SetPos( ply:GetPos() + v.pos )
            ent:SetAngles( v.ang )
            ent:Spawn()
            ent:GetPhysicsObject():EnableMotion( false )
            ent:SetMoveType( MOVETYPE_NONE )
            ent.isjailent = true
            table.insert( ply.zetaJailEnts, ent )
        end
    
    
    end




    function ZetaPlayer_ApplySpawnOverridedata(zeta,name,mdl,personal,pfp,voicepack,Zetateam)
        local BuildChance = personal.build or math.random(60)
        local CombatChance = personal.combat or math.random(10)
        local ToolChance = personal.tool or math.random(60)
        local PhysgunChance = personal.phys or math.random(60)
        local DisrespectChance = personal.disre or math.random(60)
        local WatchMediaPlayerChance = personal.media or math.random(60)
        local FriendlyChance = personal.friendly or math.random(60)
        local VoiceChance = personal.voice or math.random(60)
        local VehicleChance = personal.vehicle or math.random(60)
        local TextChance = personal.text or math.random(20)
        local Voicepitch = personal.voicepitch or 100
        local Strictness = personal.strictness 

        local overridedata = {
            personality = {
                build = BuildChance,
                combat = CombatChance,
                tool = ToolChance,
                phys = PhysgunChance,
                disre = DisrespectChance,
                media = WatchMediaPlayerChance,
                friendly = FriendlyChance,
                voice = VoiceChance,
                vehicle = VehicleChance,
                text = TextChance,
                voicepitch = Voicepitch,
                strictness = Strictness,
            },

            pfp = pfp,
            vp = voicepack,
            zetateam = Zetateam,
            model = mdl,
            name = name,
        }
        zeta.SpawnOVERRIDE = overridedata
    end






end

_zetaconvardefault = {
    zetaplayer_debug = 0,
    zetaplayer_consolelog=0,
    zetaplayer_allowtoolgunnonworld=1,
    zetaplayer_allowtoolgunworld=1,
    zetaplayer_allowphysgunnonworld=1,
    zetaplayer_allowphysgunworld=0,
    zetaplayer_allowphysgunplayers=0,
    zetaplayer_allowphysgunzetas=0,
    zetaplayer_allowcolortool=1,
    zetaplayer_allowmaterialtool=1,
    zetaplayer_allowropetool=1,
    zetaplayer_allowlighttool=1,
    zetaplayer_allowmusicboxtool=1,
    zetaplayer_allowtrailstool=1,
    zetaplayer_allowignitertool=1,
    zetaplayer_allowballoontool=1,
    zetaplayer_randomplayermodelcolor=1,
    zetaplayer_allowremovertool=0,
    zetaplayer_allowattacking=1,
    zetaplayer_allowselfdefense=1,
    zetaplayer_allowdefendothers=1,
    zetaplayer_allowspawnmenu=1,
    zetaplayer_allowentities=0,
    zetaplayer_allownpcs=0,
    zetaplayer_allowvehicles=1,
    zetaplayer_npclimit=1,
    zetaplayer_allowfollowingfriend=1,
    zetaplayer_allowlaughing=1,
    zetaplayer_enablefriend=1,
    zetaplayer_alternateidlesounds=1,
    zetaplayer_wanderdistance=1500,
    zetaplayer_overridemodel='',
    zetaplayer_spawnweapon='NONE',
    zetaplayer_naturalspawnweapon='NONE',
    zetaplayer_panicthreshold=0.3,
    zetaplayer_allowlargeprops=1,
    zetaplayer_propspawnunfrozen=0,
    zetaplayer_mapwidespawning=0,
    zetaplayer_mapwidespawningzetaamount=10,
    zetaplayer_voicevolume=1,
    zetaplayer_removepropsondeath=1,
    zetaplayer_freezelargeprops=1,
    zetaplayer_ignorezetas=0,
    zetaplayer_randomplayermodels=0,
    zetaplayer_randomdefaultplayermodels=0,
    zetaplayer_lightlimit=5,
    zetaplayer_musicboxlimit=1,
    zetaplayer_balloonlimit=5,
    zetaplayer_ropelimit=5,
    zetaplayer_proplimit=50,
    zetaplayer_sentlimit=10,
    zetaplayer_usealternatedeathsounds=0,
    zetaplayer_cleanupcorpse=0,
    zetaplayer_cleanupcorpseeffect=1,
    zetaplayer_mapwidespawninguseplayerstart=0,
    zetaplayer_cleanupcorpsetime=15,
    zetaplayer_disabled=0,
    zetaplayer_custommusiconly=0,
    zetaplayer_musicvolume=1,
    zetaplayer_allowpainvoice=1,
    zetaplayer_allowpanicvoice=1,
    zetaplayer_allowidlevoice=1,
    zetaplayer_allowdeathvoice=1,
    zetaplayer_allowar2altfire=1,
    zetaplayer_allowbackstabbing=1,
    zetaplayer_allowwitnesssounds=1,
    zetaplayer_allowfalldamage=1,
    zetaplayer_allowrealisticfalldamge=0,
    zetaplayer_allowfaceposertool=1,
    zetaplayer_allowemittertool=1,
    zetaplayer_emitterlimit=2,
    zetaplayer_allowmlgshots=1,
    zetaplayer_drawcameraflashing=0,
    zetaplayer_bonemanipulatortool=1,
    zetaplayer_allowdynamitetool=1,
    zetaplayer_dynamitelimit=2,
    zetaplayer_allowcameraaslethalweapon=0,
    zetaplayer_allowpainttool=1,
    zetaplayer_allowkillvoice=1,
    zetaplayer_allowtauntvoice=1,
    zetaplayer_permamentfriend='',
    zetaplayer_zetaspawnersaveidentity=1,
    zetaplayer_allowzetascreenshots=0,
    zetaplayer_ignoresmallnavareas=0,
    zetaplayer_allowdisconnecting=0,
    zetaplayer_voicedsp="normal",
    zetaplayer_allowvoicepopup=0,
    zetaplayer_useprofilesystem=0,
    zetaplayer_globalvoicechat=0,
    zetaplayer_usecustomavatars=0,
    zetaplayer_limitdsp=1,
    zetaplayer_showprofilepicturesintab=0,
    zetaplayer_dsplimit=7,
    zetaplayer_zetahealth=100,
    zetaplayer_naturalspawnrate=2,
    zetaplayer_permamentfriendalwaysspawn=0,
    zetaplayer_allowassistsound=1,
    zetaplayer_dropweapons=0,
    zetaplayer_showpfpoverhealth=0,
    zetaplayer_naturalzetahealth=100,
    zetaplayer_allowstrafing=1,
    zetaplayer_triggermines=1,
    zetaplayer_triggermines_hoptime=0.5,
    zetaplayer_disableunstuck=0,
    zetaplayer_killontouchnodraworsky=1,
    zetaplayer_customidlelinesonly=0,
    zetaplayer_customdeathlinesonly=0,
    zetaplayer_customkilllinesonly=0,
    zetaplayer_customtauntlinesonly=0,
    zetaplayer_combatinaccuracy=0,
    zetaplayer_damagedivider=1,
    zetaplayer_explosivecorpsecleanup=0,
    zetaplayer_norepeatingpfps=0,
    zetaplayer_usenewvoicechatsystem=0,
    zetaplayer_allowsprays=0,
    zetaplayer_alwayshuntfortargets=0,
    zetaplayer_allowuseonprops=1,
    zetaplayer_allowlamptool=1,
    zetaplayer_lamplimit=1,
    zetaplayer_allowthrustertool=1,
    zetaplayer_thrusterlimit=5,
    zetaplayer_forceadd=0,
    zetaplayer_musicsoundlevel=110,
    zetaplayer_musicplayonce=0,
    zetaplayer_musicshuffle=1,
    zetaplayer_showzetalogonscreen=0,
    zetaplayer_thrusterunfreeze=0,
    zetaplayer_differentvoicepitch=0,
    zetaplayer_voicepitchmin=80,
    zetaplayer_voicepitchmax=130,
    zetaplayer_mingebag=0,
    zetaplayer_mapwidemingebag=0,
    zetaplayer_mapwidemingebagspawnchance=10,
    zetaplayer_allowscoldvoice=1,
    zetaplayer_zetaspawnerrespawntime=1,
    zetaplayer_playersizedsprays=1,
    zetaplayer_enabledrowning=1,
    zetaplayer_bugbait_limit=4,
    zetaplayer_bugbait_lifetime=10,
    zetaplayer_bugbait_spawnhp=30,
    zetaplayer_jpgpropamount=15,
    zetaplayer_c4debris=0,
    zetaplayer_c4card=0,
    zetaplayer_serverjunk=0,
    zetaplayer_freezeserverjunk=0,
    zetaplayer_serverjunkcount=45,
    zetaplayer_customwitnesslinesonly=0,
    zetaplayer_custompaniclinesonly=0,
    zetaplayer_customassistlinesonly=0,
    zetaplayer_customlaughlinesonly=0,
    zetaplayer_customadminscoldlinesonly=0,
    zetaplayer_useteamsystem=0,
    zetaplayer_eachteammemberlimit=3,
    zetaplayer_playerteam='',
    zetaplayer_overrideteam='',
    zetaplayer_randombodygroups=1,
    zetaplayer_randomskingroups=1,
    zetaplayer_personalitytype='random',
    zetaplayer_buildchance=30,
    zetaplayer_combatchance=30,
    zetaplayer_toolchance=30,
    zetaplayer_physgunchance=30,
    zetaplayer_disrespectchance=30,
    zetaplayer_watchmediaplayerchance=30,
    zetaplayer_friendlychance=30,
    zetaplayer_voicechance=30,
    zetaplayer_vehiclechance=30,
    zetaplayer_naturalpersonalitytype='random',
    zetaplayer_naturalbuildchance=30,
    zetaplayer_naturalcombatchance=30,
    zetaplayer_naturaltoolchance=30,
    zetaplayer_naturalphysgunchance=30,
    zetaplayer_naturaldisrespectchance=30,
    zetaplayer_naturalwatchmediaplayerchance=30,
    zetaplayer_naturalfriendlychance=30,
    zetaplayer_naturalvoicechance=30,
    zetaplayer_naturalvehiclechance=30,
    zetaplayer_friendusecustomcolors=0,
    zetaplayer_friendplayermodelcolorR=0,
    zetaplayer_friendplayermodelcolorG=0,
    zetaplayer_friendplayermodelcolorB=0,
    zetaplayer_friendusephysguncolor=0,
    zetaplayer_friendphysguncolorR=0,
    zetaplayer_friendphysguncolorG=0,
    zetaplayer_friendphysguncolorB=0,
    zetaplayer_friendhealth=100,
    zetaplayer_friendprofilepicture="",
    zetaplayer_friendcustomidlelinesonly=0,
    zetaplayer_friendcustomdeathlinesonly=0,
    zetaplayer_friendcustomkilllinesonly=0,
    zetaplayer_friendcustomtauntlinesonly=0,
    zetaplayer_friendcustompaniclinesonly=0,
    zetaplayer_friendcustomassistlinesonly=0,
    zetaplayer_friendcustomlaughlinesonly=0,
    zetaplayer_friendcustomwitnesslinesonly=0,
    zetaplayer_friendcustomadminscoldlinesonly=0,
    zetaplayer_friendisadmin=0,
    zetaplayer_friendoverridemodel='',
    zetaplayer_friendpersonalitytype='random',
    zetaplayer_friendbuildchance=30,
    zetaplayer_friendcombatchance=30,
    zetaplayer_friendtoolchance=30,
    zetaplayer_friendphysgunchance=30,
    zetaplayer_frienddisrespectchance=30,
    zetaplayer_friendwatchmediaplayerchance=30,
    zetaplayer_friendfriendlychance=30,
    zetaplayer_friendvoicechance=30,
    zetaplayer_friendvehiclechance=30,
    zetaplayer_friendspawnweapon='NONE',
    zetaplayer_admindisplaynameRed=0,
    zetaplayer_admindisplaynameGreen=148,
    zetaplayer_admindisplaynameBlue=255,
    zetaplayer_adminoverridemodel='models/player/police.mdl',
    zetaplayer_spawnasadmin=0,
    zetaplayer_forcespawnadmins=0,
    zetaplayer_adminrule_nopropkill=1,
    zetaplayer_adminrule_rdm=1,
    zetaplayer_adminrule_griefing=1,
    zetaplayer_admintreatowner=0,
    zetaplayer_adminprintecho=1,
    zetaplayer_adminsctrictnessmin=0,
    zetaplayer_adminsctrictnessmax=30,
    zetaplayer_adminshouldsticktogether=0,
    zetaplayer_admincount=1,
    zetaplayer_allowpistol=1,
    zetaplayer_allowar2=1,
    zetaplayer_allowshotgun=1,
    zetaplayer_allowsmg=1,
    zetaplayer_allowrpg=1,
    zetaplayer_allowcrowbar=1,
    zetaplayer_allowstunstick=1,
    zetaplayer_allowrevolver=1,
    zetaplayer_allowtoolgun=1,
    zetaplayer_allowphysgun=1,
    zetaplayer_allowknife=1,
    zetaplayer_allowfist=1,
    zetaplayer_allowcrossbow=1,
    zetaplayer_allowm4a1=1,
    zetaplayer_allowawp=1,
    zetaplayer_allowcamera=1,
    zetaplayer_allowwrench=1,
    zetaplayer_allowscattergun=1,
    zetaplayer_allowtf2pistol=1,
    zetaplayer_allowak47=1,
    zetaplayer_allowmachinegun=1,
    zetaplayer_allowdeagle=1,
    zetaplayer_allowtf2sniper=1,
    zetaplayer_allowtf2shotgun=1,
    zetaplayer_allowgrenades=1,
    zetaplayer_allowmp5=1,
    zetaplayer_allowjpg=1,
    zetaplayer_displayzetanames=1,
    zetaplayer_showfriends=1,
    zetaplayer_displayarmor=0,
    zetaplayer_frienddisplaydistance=1400,
    zetaplayer_displaynamerainbow=0,
    zetaplayer_drawvoiceicon=1,
    zetaplayer_drawfriendhalo=1,
    zetaplayer_drawfriendhalothroughworld=0,
    zetaplayer_drawflashlight=1,
    zetaplayer_showconnectmessages=0,
    zetaplayer_zetascreenshotfov=90,
    zetaplayer_zetascreenshotfiletype='jpg',
    zetaplayer_zetascreenshotchance=10,
    zetaplayer_voicepopupdrawdistance=0,
    zetaplayer_voicepopup_x=1.17,
    zetaplayer_voicepopup_y=1.15,
    zetaplayer_displaynameRed=164,
    zetaplayer_displaynameGreen=182,
    zetaplayer_displaynameBlue=0,
    zetaplayer_drawteamhalo=1,
    zetaplayer_drawteamname=1,
    zetaplayer_drawteamhalothroughworld=0,
    zetaplayer_teamnamedrawdistance=1400,
    zetaplayer_teamcolorRed=0,
    zetaplayer_teamcolorGreen=180,
    zetaplayer_teamcolorBlue=180,
    zetaplayer_friendnamecolorR=0,
    zetaplayer_friendnamecolorG=200,
    zetaplayer_friendnamecolorB=0,
}

-- Shared stuff

function zeta_NonPlayerNPC(ent) -- Returns if the entity is not any character
    if !ent:IsNPC() and !ent:IsNextBot() and !ent:IsPlayer() then
        return true
    else
        return false
    end
end

if IsMounted("tf") then
    game.AddParticles("particles/flamethrower.pcf")
end

zetaWeaponConfigTable = {
    ['GMOD'] = {},
    ['CSS'] = {},
    ['TF2'] = {},
    ["HL1"] = {},
    ['DOD'] = {},
    ['L4D'] = {}
}

local function RegisterZetaWeapon(category, name, prettyName,defaultvar)
    if prettyName == nil then prettyName = name end
    local cvarName = 'zetaplayer_allow'..string.lower(name)
    CreateConVar(cvarName,defaultvar,FCVAR_ARCHIVE,'Allows the Zeta to equip the '..prettyName,0,1)
    table.insert(zetaWeaponConfigTable[category], {prettyName, name, cvarName})

    _zetaconvardefault[cvarName] = defaultvar

end




RegisterZetaWeapon('L4D', 'L4D_PISTOL_P220','[L4D2] SIG Sauer P220',1)
RegisterZetaWeapon('L4D', 'L4D_PISTOL_GLOCK26','[L4D2] Glock 26',1)
RegisterZetaWeapon('L4D', 'L4D_PISTOL_MAGNUM','[L4D2] Magnum',1)
RegisterZetaWeapon('L4D', 'L4D_SMG','[L4D2] Submachine Gun',1)
RegisterZetaWeapon('L4D', 'L4D_SMG_SILENCED','[L4D2] Silenced Submachine Gun',1)
RegisterZetaWeapon('L4D', 'L4D_SHOTGUN_PUMP','[L4D2] Pump Shotgun',1)
RegisterZetaWeapon('L4D', 'L4D_SHOTGUN_CHROME','[L4D2] Chrome Shotgun',1)
RegisterZetaWeapon('L4D', 'L4D_SHOTGUN_AUTOSHOT','[L4D2] Tactical Shotgun',1)
RegisterZetaWeapon('L4D', 'L4D_SHOTGUN_SPAS12','[L4D2] Combat Shotgun',1)
RegisterZetaWeapon('L4D', 'L4D_RIFLE_M16','[L4D2] M-16 Assault Rifle',1)
RegisterZetaWeapon('L4D', 'L4D_RIFLE_AK47','[L4D2] AK47',1)
RegisterZetaWeapon('L4D', 'L4D_RIFLE_SCARL','[L4D2] Combat Rifle',1)
RegisterZetaWeapon('L4D', 'L4D_RIFLE_RUGER14','[L4D2] Hunting Rifle',1)
RegisterZetaWeapon('L4D', 'L4D_RIFLE_MILITARYS','[L4D2] Military Rifle',1)
RegisterZetaWeapon('L4D', 'L4D_PISTOL_M1911','[L4D1] M1911 Pistol',1)

-- Left 4 Dead 2 Melee Weapons
RegisterZetaWeapon('L4D', 'L4D_MELEE_FIREAXE','[L4D2] Fireaxe',1)
RegisterZetaWeapon('L4D', 'L4D_MELEE_GUITAR','[L4D2] Guitar',1)
RegisterZetaWeapon('L4D', 'L4D_MELEE_GOLFCLUB','[L4D2] Golf Club',1)
RegisterZetaWeapon('L4D', 'L4D_MELEE_TONFA','[L4D2] Nightstick',1)

-- Left 4 Dead 2 Special Weapons
RegisterZetaWeapon('L4D', 'L4D_SPECIAL_GL_DELAYED','[L4D2] Grenade Launcher (Non-Impact)',1)
RegisterZetaWeapon('L4D', 'L4D_SPECIAL_GL_IMPACT','[L4D2] Grenade Launcher (Impact)',1)
RegisterZetaWeapon('L4D', 'L4D_SPECIAL_M60','[L4D2] M60',1)


-- Axis
RegisterZetaWeapon('DOD', 'DODS_AXIS_SPADE','German Entrenching Spade Shovel',1)
RegisterZetaWeapon('DOD', 'DODS_AXIS_P38','Walther P38',1)
RegisterZetaWeapon('DOD', 'DODS_AXIS_C96','Mauser C96',1)
RegisterZetaWeapon('DOD', 'DODS_AXIS_MP40','Maschinenpistole 40',1)
RegisterZetaWeapon('DOD', 'DODS_AXIS_KAR98k','Karabiner 98k',1)
RegisterZetaWeapon('DOD', 'DODS_AXIS_KAR98KSNIPER','Karabiner 98k Sniper',1)
RegisterZetaWeapon('DOD', 'DODS_AXIS_MG42','Maschinengewehr 42',1)
RegisterZetaWeapon('DOD', 'DODS_AXIS_PANZERSCHRECK','Panzerschreck 54',1)
RegisterZetaWeapon('DOD', 'DODS_AXIS_MP44','Sturmgewehr 44',1)

 
-- Allies
RegisterZetaWeapon('DOD', 'DODS_US_AMERIKNIFE','M1 Trench Knife',1)
RegisterZetaWeapon('DOD', 'DODS_US_COLT45','Colt .45',1)
RegisterZetaWeapon('DOD', 'DODS_US_THOMPSON','M1 Thompson',1)
RegisterZetaWeapon('DOD', 'DODS_US_GARAND','M1 Garand',1)
RegisterZetaWeapon('DOD', 'DODS_US_M1CARBINE','M1 Carbine',1)
RegisterZetaWeapon('DOD', 'DODS_US_BAR','M1918 Browning Auto Rifle',1)
RegisterZetaWeapon('DOD', 'DODS_US_SPRINGFIELD','Springfield',1)
RegisterZetaWeapon('DOD', 'DODS_US_30CAL','M1919 Browning Machine Gun',1)
RegisterZetaWeapon('DOD', 'DODS_US_BAZOOKA','M1 Bazooka',1)



RegisterZetaWeapon('CSS', 'UMP45','Ump45',1)
RegisterZetaWeapon('CSS', 'FAMAS','Famas',1)
RegisterZetaWeapon('CSS', 'AUG','AUG',1)
RegisterZetaWeapon('CSS', 'SG552','SG552',1)
RegisterZetaWeapon('CSS', 'P90','P90',1)
RegisterZetaWeapon('CSS', 'MAC10','Mac10',1)
RegisterZetaWeapon('CSS', 'SCOUT', 'Steyr Scout',1)
RegisterZetaWeapon('CSS', 'XM1014','XM1014',1)
RegisterZetaWeapon('CSS', 'FIVESEVEN',"Five-Seven",1)
RegisterZetaWeapon('CSS', 'USPSILENCED',"Silenced Usp",1)
RegisterZetaWeapon('CSS', 'GLOCK_AUTO',"Glock 18 Auto",1)
RegisterZetaWeapon('CSS', 'GLOCK_SEMI',"Glock 18 Semi-Auto",1)
RegisterZetaWeapon('CSS', 'UMP45','UMP-45',1)
RegisterZetaWeapon('CSS', 'FAMAS','Famas',1)
RegisterZetaWeapon('CSS', 'AUG','AUG',1)
RegisterZetaWeapon('CSS', 'SG552','SG552',1)
RegisterZetaWeapon('CSS', 'P90','P90',1)
RegisterZetaWeapon('CSS', 'MAC10','Mac-10',1)
RegisterZetaWeapon('CSS', 'SCOUT', 'Steyr Scout',1)
RegisterZetaWeapon('CSS', 'XM1014','XM1014',1)
RegisterZetaWeapon('CSS', 'FIVESEVEN',"Five-Seven",1)
RegisterZetaWeapon('CSS', 'USPSILENCED',"USP-45",1)
RegisterZetaWeapon('CSS', 'GLOCK_AUTO',"Glock 18 (Auto)",1)
RegisterZetaWeapon('CSS', 'GLOCK_SEMI',"Glock 18 (Semi-Auto)",1)
RegisterZetaWeapon('CSS', 'M3',"M3 Super 90",1)
RegisterZetaWeapon('CSS', 'GALIL',"IMI Galil",1)
RegisterZetaWeapon('CSS', 'TMP',"TMP",1)
RegisterZetaWeapon('CSS', 'DUALELITES',"Dual Berettas",1)


RegisterZetaWeapon('GMOD', 'HACKSMONITORS','Anti Hacks Monitors',1)
RegisterZetaWeapon('GMOD', 'IMPACTGRENADE','Punch Activated Impact Grenade',1)
RegisterZetaWeapon('GMOD', 'SHOVEL','Shovel',1)
RegisterZetaWeapon('GMOD', 'VOLVER','Volver',0)
RegisterZetaWeapon('GMOD', 'BUGBAIT','Bugbait',1)
RegisterZetaWeapon('GMOD', 'PAN','Frying Pan',1)
RegisterZetaWeapon('GMOD', 'MEATHOOK','Meat Hook',1)
RegisterZetaWeapon('GMOD', 'C4','C4 Plastic Explosive',0)
RegisterZetaWeapon('GMOD', 'LARGEGRENADE','Comically Large Grenade',1)
RegisterZetaWeapon('GMOD', 'KATANA','Katana',1)
RegisterZetaWeapon('GMOD', 'ALYXGUN','Alyx Gun',1)
RegisterZetaWeapon('GMOD', 'ANNABELLE','Annabelle',1)
RegisterZetaWeapon('GMOD', 'WOODENCHAIR','Wooden Chair',1)
RegisterZetaWeapon('GMOD', 'THEKLEINER','Kleiner',1)
RegisterZetaWeapon('GMOD', 'LARGESIGN','Large Sign Post',1)
RegisterZetaWeapon('GMOD', 'CARDOOR','Car Door',1)
RegisterZetaWeapon('GMOD', 'ZOMBIECLAWS','Zombie Claws',1)

if istable(rb655_gForcePowers) then
    RegisterZetaWeapon('GMOD', 'LIGHTSABER', 'Lightsaber', 1)
end




RegisterZetaWeapon('TF2', 'BAT','Bat',1)
RegisterZetaWeapon('TF2', 'SNIPERSMG','TF2 SMG',1)
RegisterZetaWeapon('TF2', 'FORCEOFNATURE','Force of Nature',1)
RegisterZetaWeapon('TF2', 'GRENADELAUNCHER','Grenade Launcher',1)
RegisterZetaWeapon('TF2', 'FLAMETHROWER','Flamethrower',1)
RegisterZetaWeapon('HL1', 'HL1SMG','HL1 MP5',1)
RegisterZetaWeapon('HL1', 'HL1GLOCK','HL1 Glock',1)
RegisterZetaWeapon('HL1', 'HL1SPAS','HL1 Spas',1)
RegisterZetaWeapon('HL1', 'HL1357','HL1 357',1)

-- When adding convars, We now should use this for it to add to the preset system
local function AddZetaConvar(cvarname,save,value,helptext,min,max)
    CreateConVar(cvarname,value,save and FCVAR_ARCHIVE or !save and FCVAR_NONE,helptext,min,max)
    _zetaconvardefault[cvarname] = value
end

AddZetaConvar("zetaplayer_customsitrespondlinesonly",true,0,"If Zetas should only use your custom sit respond lines",0,1)
AddZetaConvar("zetaplayer_custommediawatchlinesonly",true,0,"If Zetas should only use your custom Media Watch lines",0,1)
AddZetaConvar("zetaplayer_friendcustomsitrespondlinesonly",true,0,"If Zetas should only use your custom sit respond lines",0,1)
AddZetaConvar("zetaplayer_friendcustommediawatchlinesonly",true,0,"If Zetas should only use your custom media watch lines",0,1)

AddZetaConvar("zetaplayer_allowmediawatchvoice",true,1,"If Zetas should speak while watching a media player",0,1)

AddZetaConvar("zetaplayer_friendsticknear",true,0,"If Zetas should stick near their friend",0,1)
AddZetaConvar("zetaplayer_usedynamicpathfinding",true,0,"If Zetas should try to dynamically pathfind",0,1)
AddZetaConvar("zetaplayer_mapwidespawningrandom",true,0,"If MWS should use the rate value as the max of a random value",0,1)
AddZetaConvar("zetaplayer_bugbait_dmgscale",true,0,"Damage scaling for Zeta Antlions",0,100)
AddZetaConvar("zetaplayer_friendstickneardistance",true,1000,"The distance Zetas can wander from their friend",0,15000)

AddZetaConvar("zetaplayer_adminallowgodmode",true,1,"If Admins can use God Mode",0,1)
AddZetaConvar("zetaplayer_adminallowsethealth",true,1,"If Admins can set their health",0,1)
AddZetaConvar("zetaplayer_adminallowsetarmor",true,1,"If Admins can set their armor",0,1)
AddZetaConvar("zetaplayer_adminallowgoto",true,1,"If Admins can goto someone",0,1)
AddZetaConvar("zetaplayer_adminallowsetpos",true,1,"If Admins can set their position elsewhere",0,1)

AddZetaConvar("zetaplayer_profilesystemonly",true,0,"If Zetas should spawn using the profile system if possible",0,1)
AddZetaConvar("zetaplayer_allowfallingvoice",true,1,"If Zetas should speak when falling",0,1)

AddZetaConvar("zetaplayer_customfallinglinesonly",true,0,"If custom falling sounds should only be used",0,1)
AddZetaConvar("zetaplayer_friendcustomfallinglinesonly",true,0,"If your permanent should only use custom falling sounds",0,1)

AddZetaConvar("zetaplayer_customquestionlinesonly",true,0,"If custom question sounds should only be used",0,1)
AddZetaConvar("zetaplayer_friendcustomquestionlinesonly",true,0,"If your permanent should only use custom question sounds",0,1)

AddZetaConvar("zetaplayer_customrespondlinesonly",true,0,"If custom respond sounds should only be used",0,1)
AddZetaConvar("zetaplayer_friendcustomrespondlinesonly",true,0,"If your permanent should only use custom respond sounds",0,1)

AddZetaConvar("zetaplayer_allowconversations",true,1,"If Zetas can walk up to somebody and have a conversation",0,1)


AddZetaConvar('zetaplayer_zetaarmor',true,0,"The amount of armor Zetas will spawn with",0,10000)
AddZetaConvar('zetaplayer_naturalzetaarmor',true,0,"The amount of armor Natural Zetas will spawn with",0,10000)
AddZetaConvar('zetaplayer_friendarmor',true,0,"The amount of armor your friend will spawn with",0,10000)
AddZetaConvar('zetaplayer_armorabsorbpercent',true,80,'How much percent of damage should zetas armor absorb',1,100)

AddZetaConvar('zetaplayer_startconversationchance',true,25,'The chance a zeta will look for someone to talk to when they attempt',1,100)
AddZetaConvar('zetaplayer_textchance',true,30,'The chance a zeta will type in text chat',0,100)
AddZetaConvar('zetaplayer_naturaltextchance',true,30,'The chance a zeta will type in text chat',0,100)
AddZetaConvar('zetaplayer_friendtextchance',true,30,'The chance a zeta will type in text chat',0,100)
AddZetaConvar('zetaplayer_allowtextchat',true,1,'If Zetas are allowed to use text chat',0,1)

AddZetaConvar('zetaplayer_callonnpckilledhook',true,0,'If killed Zetas should call the onkilledhook',0,1)
AddZetaConvar('zetaplayer_alwaystargetnpcs',true,1,'If Zetas should always attack npcs regardless of combat chance',0,1)
AddZetaConvar('zetaplayer_customspawnsound',true,"",'Custom sound effect for when a zeta spawns')
AddZetaConvar('zetaplayer_customtextsendsound',true,"",'Custom sound effect for when a zeta sends a text message')
AddZetaConvar('zetaplayer_clearpath',true,0,'If Zetas should shoot objects that block the way and can break',0,1)
AddZetaConvar('zetaplayer_sourcecutdistance',true,800,'The distance Source cut can reach',100,10000)
AddZetaConvar('zetaplayer_allowsourcecut',true,0,'If Zetas can use Source Cut',0,1)


AddZetaConvar('zetaplayer_overridetextchance',true,0,'Override Text Chance Vars',0,1)
AddZetaConvar('zetaplayer_textchanceoverride',true,20,'The overriden chance of text chance',0,100)

AddZetaConvar('zetaplayer_fleefromsanics',true,0,'If Zetas should run away from sanic type nextbots',0,1)

AddZetaConvar('zetaplayer_allowrequestmedia',true,1,'If Zetas are allowed to request videos',0,1)

AddZetaConvar('zetaplayer_enablemoonbasettssupport',true,0,'If Zetas in text chat should use Moonbase tts if installed',0,1)

AddZetaConvar('zetaplayer_disablejumping',true,0,"If Zetas shouldn't jump over objects",0,1)

AddZetaConvar('zetaplayer_enableblockmodels',true,0,"If models that are considered block shouldn't be used",0,1)

AddZetaConvar('zetaplayer_customjoinsound',true,"zetaplayer/misc/zeta_nocon_sound.wav",'Custom sound effect for when a zeta joins the server')
AddZetaConvar('zetaplayer_customleavesound',true,"zetaplayer/misc/zeta_nocon_sound.wav",'Custom sound effect for when a zeta leaves the server')

AddZetaConvar('zetaplayer_fleefromdrgbasenextbots',true,0,"If Zetas should run from DRG Nextbots",0,1)

AddZetaConvar('zetaplayer_userealplayerdmgscale', true, 1, "If damage dealt to Zetas should scale like the real players one do.", 0, 1)

AddZetaConvar('zetaplayer_allowdstepssupport', true, 1, "If Zetas should use DSteps' footstep sounds if its installed", 0, 1)

AddZetaConvar('zetaplayer_ignorefriendlyfirebyzeta', true, 0, "If Zetas should ignore friendly fire caused by other zeta", 0, 1)

AddZetaConvar('zetaplayer_mwsspawnrespawningzetas', true, 0, "If Natural Zetas should respawn when they die", 0, 1)

AddZetaConvar('zetaplayer_allowkillbind', true, 0, "If Zetas are allowed to use their kill bind", 0, 1)

AddZetaConvar('zetaplayer_casuallooking', true, 0, "If Zetas should look around normally", 0, 1)

AddZetaConvar('zetaplayer_maxdisconnecttime', true, 600, "The max of time it will take before a Zeta decides to disconnect", 0, 3600)

AddZetaConvar('zetaplayer_displaynameRed',true,164,'Red value of the display name color',0,255)
AddZetaConvar('zetaplayer_displaynameGreen',true,182,'Green value of the display name color',0,255)
AddZetaConvar('zetaplayer_displaynameBlue',true,0,'Blue value of the display name color',0,255)

AddZetaConvar('zetaplayer_friendnamecolorR',true,0,"Friend Color",0,255)
AddZetaConvar('zetaplayer_friendnamecolorG',true,200,"Friend Color",0,255)
AddZetaConvar('zetaplayer_friendnamecolorB',true,0,"Friend Color",0,255)

AddZetaConvar('zetaplayer_playercolordisplaycolor', true, 0, "If display name colors should be based on the Zeta's Playermodel Color", 0, 1)

AddZetaConvar('zetaplayer_connectlines', true, 1, "If Zetas should say connect lines", 0, 1)
AddZetaConvar('zetaplayer_disconnectlines', true, 1, "If Zetas should say connect lines", 0, 1)

AddZetaConvar('zetaplayer_useservercacheddata', true, 0, "If Prop data and others should use the cache the server has saved", 0, 1)

AddZetaConvar('zetaplayer_allowinterrupting', true, 1, "If Zetas should send a message when they are interrupted", 0, 1)

AddZetaConvar('zetaplayer_forceradius',true, 700, "Radius for forcing certain actions on Zetaplayers", 150, 10000)

AddZetaConvar('zetaplayer_friendamount', true, 1, "How many friends a player or zeta can have at max", 1, 50)
AddZetaConvar('zetaplayer_allowfriendswithzetas', true, 0, "If Zetas are allowed to consider each other friends", 0, 1)
AddZetaConvar('zetaplayer_showhwosfriendwithwho', true, 0, "If Name Display should show who a zeta is friends with", 0, 1)
AddZetaConvar('zetaplayer_stickwithplayer', true, 0, "If Zetas who are friends with the player should always stick near them", 0, 1)
AddZetaConvar('zetaplayer_usefriendcolor', true, 1, "If Friend Zetas should use the friend color for their name display", 0, 1)
AddZetaConvar('zetaplayer_allowfriendswithplayers', true, 1, "If Zetas are allowed to consider players friends", 0, 1)
AddZetaConvar('zetaplayer_spawnasfriendchance', true, 10, "The chance a zeta will spawn as a friend to someone", 1, 100)
AddZetaConvar('zetaplayer_musicvisualizersamples', true, 4, "Amount of Sample the Visualizer will process. The higher the value the more smooth the visualizer will move", 0, 7)
AddZetaConvar('zetaplayer_enablemusicvisualizer', true, 0, "If Music Boxes should draw their Visualizers", 0, 1)
AddZetaConvar('zetaplayer_enabledynamiclightvisualizer', true, 0, "If Music Boxes should draw light with the music", 0, 1)
AddZetaConvar('zetaplayer_dancechance', true, 20, "The chance that Zetas will dance to music", 1, 100)
AddZetaConvar('zetaplayer_visualizerresolution', true, 100, "The resolution of the visualizer", 20, 200)


AddZetaConvar('zetaplayer_visualizerrenderdistance', true, 1500, "The distance the Visualizer is allowed to render", 200, 10000)

AddZetaConvar('zetaplayer_visualizerplayeronly', true, 0, "If the Visualizer should only be shown on music boxes spawned by a player", 0, 1)
AddZetaConvar('zetaplayer_surpressminormusicwarnings', true, 0, "If minor warnings should be surpressed", 0, 1)

AddZetaConvar('zetaplayer_allownoclip', true, 0, "If Zetas are allowed to noclip", 0, 1)
AddZetaConvar('zetaplayer_allowadminnoclip', true, 0, "If Admin Zetas are allowed to noclip", 0, 1)
AddZetaConvar('zetaplayer_allowpanicbhop', true, 0, "If Zetas should bhop when running away", 0, 1)

AddZetaConvar('zetaplayer_voicepackchance', true, 0, "The chance a Zeta will spawn with a voice pack", 0, 100)

AddZetaConvar('zetaplayer_friendvoicepack', true, "none", "Friend voice pack")

AddZetaConvar('zetaplayer_findpokertableonspawn', true, 0, "If Zetas should look for a poker table when they spawn", 0, 1)

AddZetaConvar('zetaplayer_allowwiregatetool', true, 1, "If Zetas are allowed to use the wire gate tool", 0, 1)
AddZetaConvar('zetaplayer_wiregatelimit', true, 10, "The amount of wire gates a zeta can spawn", 1, 100)

AddZetaConvar('zetaplayer_allowwirebuttontool', true, 1, "If Zetas are allowed to use the wire button tool", 0, 1)
AddZetaConvar('zetaplayer_wirebuttonlimit', true, 10, "The amount of wire buttons a zeta can spawn", 1, 100)

AddZetaConvar('zetaplayer_allowcreatingvotes', true, 0, "If Zetas are allowed to create votes", 0, 1)

AddZetaConvar('zetaplayer_motivatedkatana', true, 0, "Bury the light deep within!", 0, 1)

AddZetaConvar('zetaplayer_sticknearnonav', true, 0, "If Friend Zetas should not pick a random location based on navmesh", 0, 1)

AddZetaConvar('zetaplayer_allowjudgementcut', true, 0, "If Katana users can use Judgement Cut during combat", 0, 1)

AddZetaConvar('zetaplayer_waterairtime', true, 12, 'The amount of time zeta can swim in water before starting to drown', 1, 60)

AddZetaConvar('zetaplayer_eyetap_preventtilting', true, 1, "If the view from Zeta Eye Tapper shouldn't be tilted left and right", 0, 1)

AddZetaConvar('zetaplayer_usenewchancesystem', true, 0, "If the new chance system should be used", 0, 1)

AddZetaConvar('zetaplayer_teamsalwaysattack', true, 0, "If Teams should always attack each other", 0, 1)
AddZetaConvar('zetaplayer_spawnatteamspawns', true, 0, "If the player should spawn at their team spawn", 0, 1)
AddZetaConvar('zetaplayer_showkothpointsonhud', true, 0, "If KOTH points should show on your HUD", 0, 1)

AddZetaConvar('zetaplayer_10secondcountdownsound', true, "zetaplayer/koth/tensecond.mp3", "The sound that should play when the timer hits 10 seconds")

AddZetaConvar('zetaplayer_kothgameover', true, "zetaplayer/koth/loss.wav", "The sound that should play when game ends")
AddZetaConvar('zetaplayer_kothvictory', true, "zetaplayer/koth/won.wav", "The sound that should play when your team wins")
AddZetaConvar('zetaplayer_kothgamestart', true, "zetaplayer/koth/chooseteam.mp3", "The sound that should play when game starts")

AddZetaConvar('zetaplayer_kothmodetime', true, 190, "If KOTH points should show on your HUD", 10)
AddZetaConvar('zetaplayer_kothcapturerate', true, 0.2, "The capture rate of koth points", 0.01, 5)
AddZetaConvar('zetaplayer_enablefriendlyfire', true, 0, "If friendly fire is enabled with teams", 0, 1)

AddZetaConvar('zetaplayer_ctfenemyflagstolensound', true, "zetaplayer/ctf/flagsteal.wav", "Sound that will play when a enemy flag is stolen")
AddZetaConvar('zetaplayer_ctfenemyflagcapturesound', true, "zetaplayer/ctf/flagcapture.wav", "Sound that will play when a enemy flag is captured")

AddZetaConvar('zetaplayer_ctfflagreturn', true, "zetaplayer/ctf/flagreturn.wav", "Sound that will play when a flag returns back to its zone")

AddZetaConvar('zetaplayer_ctfflagdropped', true, "zetaplayer/ctf/flagdropped.wav", "Sound that will play when a flag is dropped")

AddZetaConvar('zetaplayer_ctfourflagcapturesound', true, "zetaplayer/ctf/ourflagcaptured.wav", "Sound that will play when your team's flag is captured")
AddZetaConvar('zetaplayer_ctfourflagstolensound', true, "zetaplayer/ctf/ourflagstole.wav", "Sound that will play when your team's flag is stolen")

AddZetaConvar('zetaplayer_textchatreceivedistance', true, 0, "How far you can receive text messages from Zetas. leave zero for global", 0, 10000)

include("zeta/zetaspawnmenusettings.lua")

function ZetaGetTeamColor(zetateam)
    local teamdata = file.Read("zetaplayerdata/teams.json")
    teamdata = util.JSONToTable(teamdata)
    local foundteam = nil
    for k,v in ipairs(teamdata) do
        if v[1] == zetateam then
            foundteam = v
            break
        end
    end
    if istable(foundteam) then
        return foundteam[2]
    else
        return nil
    end
end

function ZetaGetTeamSpawns(zetateam)
    local teamspawns = ents.FindByClass("zeta_teamspawnpoint")
    local spawns = {}
  
    for k,v in ipairs(teamspawns) do
      if v:GetTeamSpawn() == zetateam then
        spawns[#spawns+1] = v
      end
    end
  
    return spawns
  end

  

if ( CLIENT ) then

    



    local zetarender = {}
    local draw = draw
    local surface = surface
    local Material = Material












    voiceChannels = {}
    speakingZetas = {}



    zetarender.SetMaterial = render.SetMaterial
    zetarender.DrawScreenQuadEx = render.DrawScreenQuadEx


    -- Saving these color objects once so they don't get recreated many times in a rendering hook
    -- This is nice optimization
    local zetaname_color = Color(0,0,0)
    local voicechat_color = Color(0,0,0)
    local voicechat_whitecolor = Color(255,255,255,255)
    local voicechat_whitecolor2 = Color(255,255,255,255)
    local zetavoicechat_black = Color(0,0,0,255)
    local zetatabmenu_color = Color(0,0,0)
    local zetafriend_text = Color(0,0,0)
    local zetateam_color = Color(0,0,0)
    local zetadisplay_name = Color(0,0,0)
    local zeta_halos = Color(0,0,0)

    local playerspeaking = false
    local playerspeakenddur = RealTime()+0.1
    local playervoicepopupexists = false


    if game.SinglePlayer() then
        local limit = false

        hook.Add("Think","zetaplayervoicechatthink",function()
            local playervoicechatbind = input.LookupBinding("+voicerecord")
            local numbind = playervoicechatbind and input.GetKeyCode(playervoicechatbind) or KEY_X
            
            if input.IsKeyDown( numbind ) and !limit then
                hook.Run("PlayerStartVoice",LocalPlayer())
                limit = true
                playerspeaking = true
                if !playervoicepopupexists then
                    table.insert(speakingZetas,LocalPlayer())
                end
            elseif !input.IsKeyDown( numbind ) and limit then
                hook.Run("PlayerEndVoice",LocalPlayer())
                limit = false
                playerspeakenddur = RealTime()+0.1
                playerspeaking = false
                net.Start("zeta_realplayerendvoice",true)
                net.SendToServer()
            end
        end)

        hook.Add("PlayerStartVoice","zetanodefaultvoiceicon",function(ply)
            return true
        end)
    end




    if !file.Exists('zetaplayerdata/zeta_viewshots','DATA') then
        file.CreateDir('zetaplayerdata/zeta_viewshots')
    end

    
    CreateClientConVar('zetaplayer_displayzetanames',1,true,false,'If Zetas should show their names when you hover over them',0,1)
    CreateClientConVar('zetaplayer_showfriends',1,true,false,'Show a Friend Tag above a Zeta who has considered you a friend',0,1)
    CreateClientConVar('zetaplayer_displayarmor',0,true,false,'If name displays should show armor',0,1)
    CreateClientConVar('zetaplayer_frienddisplaydistance',1400,true,false,'Distance to display the Friend Tag',0,10000)
    CreateClientConVar('zetaplayer_displaynamerainbow',0,true,false,'If the display names should change color linearly',0,1)
    CreateClientConVar('zetaplayer_drawvoiceicon',1,true,false,'If the Voice Icons should appear',0,1)
    CreateClientConVar('zetaplayer_drawfriendhalo',1,true,false,'If a Friend Zeta should have a halo drawn over it',0,1)
    CreateClientConVar('zetaplayer_drawfriendhalothroughworld',0,true,false,"If a Friend Zeta's halo should draw through the world",0,1)
    CreateClientConVar('zetaplayer_drawflashlight',1,true,false,'If Zeta Flashlights should draw',0,1)
    CreateClientConVar('zetaplayer_showconnectmessages',0,true,false,'If newly spawned Zetas should send a connect message in chat',0,1)
    CreateClientConVar('zetaplayer_zetascreenshotfov',90,true,false,'The FOV of the screenshots',10,180)
    CreateClientConVar('zetaplayer_zetascreenshotfiletype','jpg',true,false,'The file type of the screenshot')
    CreateClientConVar('zetaplayer_zetascreenshotchance',10,true,false,'The chance of a View Shot will render and saved each time a Zeta requests a view shot')
    CreateClientConVar('zetaplayer_voicepopupdrawdistance',0,true,false,'The distance a voice popup will be drawn. Set this to 0 for unlimited',0,15000)


    CreateClientConVar('zetaplayer_voicepopup_x',1.17,true,false,'Screencord',0,100)
    CreateClientConVar('zetaplayer_voicepopup_y',1.15,true,false,'Screencord',0,100)


    CreateClientConVar('zetaplayer_drawteamhalo',1,true,false,'If a team member should have a halo drawn over it',0,1)
    CreateClientConVar('zetaplayer_drawteamname',1,true,false,"If a team member should have it's team drawn over it",0,1)
    CreateClientConVar('zetaplayer_drawteamhalothroughworld',0,true,false,"If a team member's halo should draw through the world",0,1)
    CreateClientConVar('zetaplayer_teamnamedrawdistance',1400,true,false,'Distance to display the Team Tag',0,10000)
    CreateClientConVar('zetaplayer_teamcolorRed',0,true,false,'Red value of the team color',0,255)
    CreateClientConVar('zetaplayer_teamcolorGreen',180,true,false,'Green value of the team color',0,255)
    CreateClientConVar('zetaplayer_teamcolorBlue',180,true,false,'Blue value of the team color',0,255)




    concommand.Add('zetaplayer_cleanviewshotfolder',CleanViewShotFolder,nil,'Cleans the View Shot Folder')


    local refresh = CurTime()+0.2
    local SpawnedZetas 


    --if GetConVar("zetaplayer_usenewvoicechatsystem"):GetInt() == 1 then  

    net.Receive("zeta_changevoicespeaker", function()
        local old = net.ReadEntity()
        local oldID = net.ReadInt(32)
        local new = net.ReadEntity()
        
        hook.Remove('PreDrawEffects','zetavoiceicon'..oldID)
    
        if #voiceChannels > 0 then 
            for _, v in pairs(voiceChannels) do
                if v[5] == old then
                    v[5] = new
    
                    local time = (v[4] - v[1]:GetTime())
                    if time > 0 then
                        net.Start("zeta_sendvoiceicon", true)
                            net.WriteEntity(new)
                            net.WriteFloat(time)
                        net.SendToServer()
                    end
                    
                    break
                end
            end
        end
    end)
    
    net.Receive("zeta_removevoicepopup",function()
        local ID = net.ReadInt(32)
        for k,tbl in ipairs(speakingZetas) do
            if tbl[1] == ID then
                table.remove(speakingZetas,k)
            end
        end
    
    end)

    hook.Add('Tick', 'zeta_checkVoiceChannel', function()
        if #voiceChannels <= 0 then return end
	for k, v in pairs(voiceChannels) do
		local audio = v[1]
		if !audio:IsValid() then table.remove(voiceChannels, k) continue end
	
		local src = v[5]
		local len = v[4]
		local remove = v[6]
		
		-- This code prevents jaw to be wide open when sound ends with high sound level
		if src:IsValid() and audio:GetTime() >= len then src:MoveMouth(0) end
		
		-- The '+ 2.0' is to prevent voice popups appear when fading out and far away
		if audio:GetTime() >= len + 2.0 or remove == true and !src:IsValid() then
			audio:Stop()
			table.remove(voiceChannels, k)
			continue
		end
		
		local leftC, rightC = audio:GetLevel()
		local voiceLvl = ((leftC + rightC) / 2)
		v[3] = voiceLvl

		if src:IsValid() then
			audio:SetPos(src:GetPos())
			
			-- Such a mess... Just to make jaw always be wide open no matter the audio's level 
			v[7] = v[7] or 0.0
			v[8] = v[8] or RealTime()
			v[9] = v[9] or 0.0
			if RealTime() <= v[8] then
				if voiceLvl > v[7] then
					v[7] = voiceLvl 
				end
			else
				v[7] = 0.0
				v[8] = RealTime() + 1
			end
			
			v[9] = (v[7] <= 0.2 and v[9] or (voiceLvl / v[7]))
			
			-- Debugging code, you may remove it if you want to
			if src.IsZetaPlayer and GetConVar("developer"):GetInt() == 1 then
				local debugattach = src:GetAttachmentPoint("eyes")
				debugoverlay.Text(debugattach.Pos - Vector(0,0,3), "Jaw Value: "..math.Round(v[9], 2).."; "..math.Round(v[7], 2), 0)
			end	
			
			src:MoveMouth(v[9])
		end
	end
    end)

    net.Receive('zeta_playvoicesound',function()
        local zeta = net.ReadEntity()
        if !zeta or !zeta:IsValid() or zeta.IsDead == true then return end

        local ragdoll = zeta.DeathRagdoll
        if !IsValid(ragdoll) then ragdoll = zeta:GetNW2Entity('zeta_ragdoll', NULL) end
        if IsValid(ragdoll) then zeta = ragdoll end

        local ID = net.ReadInt(32)
        local sndName = net.ReadString()
        local playType = net.ReadString()
        local stopPlaying = net.ReadBool()
        local pitch = net.ReadInt(32)
        local pos = zeta:GetPos()
        

        if voiceChannels and #voiceChannels > 0 then
            for k, v in pairs(voiceChannels) do
                if v[2] == ID then
                    v[1]:Stop()
                    table.remove(voiceChannels, k)
                    break
                end
            end
        end

        local ragdoll = zeta.DeathRagdoll
        if !IsValid(ragdoll) then ragdoll = zeta:GetNW2Entity('zeta_ragdoll', NULL) end
        if IsValid(ragdoll) then zeta = ragdoll end

        sound.PlayFile(sndName, playType, function(speech, errorId, errorName)
            if IsValid(speech) then
                speech:SetVolume(GetConVar('zetaplayer_voicevolume'):GetFloat())
                speech:SetPlaybackRate((pitch/100))
                speech:SetPos(pos)
                

                table.insert(voiceChannels, {speech, ID, 0, speech:GetLength(), zeta, stopPlaying})
            else
                local errorcomment = "None"
                if errorName == "BASS_ERROR_NO3D" then
                    errorcomment = "This Error happens when a sound file has a Stereo Channel.\nTurn the indicated Sound File to Mono to prevent this from happening"
                elseif errorName == "BASS_ERROR_FILEOPEN" then
                    errorcomment = "Check the folder the sound file is from and make sure it is evenly sequential! Example, idle1 idle2 idle3 ect.. Make sure you placed the files in the right directory as well incase the first advice didn't work!"
                end
                print("Zeta VoiceChat V2: Audio Channel Error ID",errorId," Error Name ", errorName, " Sound file is, ",sndName,"\nDeveloper Comment: "..errorcomment)
            end
        end)
    end)


    net.Receive("zeta_voicepopup",function()
        local name = net.ReadString()
        local finalname = name
        if #name >= 20 then
            local trim = string.Left( name, 17 ).."..."
            finalname = trim
        end
        local model = net.ReadString()
        local dur = net.ReadFloat()
        local ID = net.ReadInt(32)
        local mat

        if model != nil then

            if string.Explode("/",model)[4] == "custom_avatars" then
                mat = Material(model)

                if mat:IsError() then
                    mat = Material("spawnicons/"..string.sub(model,1,#model-4)..".png")
                    if mat:IsError() then
                        mat = Material("entities/npc_zetaplayer.png")
                    end
                end

            else
                mat = Material(model)

                if mat:IsError() then
                mat = Material("spawnicons/"..string.sub(model,1,#model-4)..".png")

                if mat:IsError() then
                    mat = Material("entities/npc_zetaplayer.png")
                end
                
             end

            end

        else
            mat = Material("entities/npc_zetaplayer.png")
        end


        if GetConVar("zetaplayer_usenewvoicechatsystem"):GetInt() == 1 then
        if #speakingZetas > 0 then
            for k,tbl in ipairs(speakingZetas) do
                if tbl[2] == finalname then
                    tbl[4] = RealTime() + dur
                    return
                end
            end
        end
        
        table.insert(speakingZetas, {ID,finalname,mat,RealTime()+dur,RealTime()})
    else

        local index = table.insert(speakingZetas, {ID,finalname,mat})
        timer.Simple(dur,function()
        for k,tbl in ipairs(speakingZetas) do
            if tbl[1] == ID then
                table.remove(speakingZetas,k)
            end
        end
        end)
        end
    end)

    local canprint = true
    local canprintTAB = true

    local logevents = {}

    net.Receive("zeta_sendonscreenlog",function()
        local log = net.ReadString()
        local color = net.ReadColor(false)
        table.insert(logevents, {log = log,dur = CurTime()+3,alpha = 255,color = color})
    end)

    local function GetClientZetaFriends()
        local zetas = ents.FindByClass("npc_zetaplayer")
        local friends = {}

        for _,ply in ipairs(zetas) do
            local isfriend = ply:GetNW2Bool("zeta_showfriendstat",false)
            if isfriend then
                table.insert(friends,ply)
            end
        end

        return friends
    end

    local showlist = false
    hook.Add("KeyRelease","zetascorehide",function(ply,key)
        if key == IN_SCORE then
            showlist = false
        end
    end)


    hook.Add("KeyPress","zetascoreshow",function(ply,key)
        if key == IN_SCORE then
            showlist = true
        end
    end)



    surface.CreateFont( "ZetaKothTime", {
        font = "ChatFont",
        extended = false,
        size = 25,
        weight = 500,
        blursize = 0,
        scanlines = 0,
        antialias = true,
        underline = false,
        italic = false,
        strikeout = false,
        symbol = false,
        rotary = false,
        shadow = false,
        additive = false,
        outline = false,
    } )






    hook.Add('HUDPaint','_zetahudpaint',function() -- Show Zeta stuff

        if GetGlobalBool("_ZetaKOTH_Gameactive") then
            local w = ScrW()/2
            local h = ScrH()/50
            local time = string.FormattedTime( GetGlobalInt("_ZetaKOTH_time",0), "%02i:%02i:%02i" )
            draw.SimpleTextOutlined("Time: "..time,"ZetaKothTime",w,h,color_white,TEXT_ALIGN_CENTER,TEXT_ALIGN_TOP,1,color_black)
        end


        if GetConVar("zetaplayer_showkothpointsonhud"):GetBool() then
        local kothpoints = ents.FindByClass("zeta_koth")
            if #kothpoints > 0 then
                for i=1,#kothpoints do
                    local w = ScrW()/50
                    local h = (ScrH()/2)-i*20
                    draw.SimpleTextOutlined(kothpoints[i]:GetNW2String("zetakoth_identity","A0"),"ChatFont",w,h,kothpoints[i]:GetNW2Vector("zetakoth_color",Vector(1,1,1)):ToColor(),TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP,1,color_black)
                end
            end
        end

        if #logevents > 0 then
            for index,logdata in ipairs(logevents) do
                local y = ScrH()/50

                y = y + 15*index

                
                

                if logdata.dur < CurTime() then
                    logdata.alpha = logdata.alpha - 5
                    if logdata.alpha <= 0 then
                        table.remove(logevents, index)
                    end
                end

                
                zetaname_color.r = logdata.color.r
                zetaname_color.g = logdata.color.g
                zetaname_color.b = logdata.color.b

                draw.TextShadow( {
                    text = logdata.log,
                    pos = {ScrW()/50,y},
                    font = "DebugFixedSmall",


                    color = zetaname_color
                }, 1.2, logdata.alpha )
                --draw.DrawText( logdata.log, "DebugFixedSmall", ScrW()/50, y, Color(255,255,255,255), TEXT_ALIGN_LEFT )
                
            end
        end



        if GetConVar("zetaplayer_usenewvoicechatsystem"):GetInt() == 1 then
            if #speakingZetas > 0 then
                // Since now voice popups are able to not show when too far, instead of using table's index, create new local variable
                local popupCount = 1
                for index,vcdata in ipairs(speakingZetas) do
                    local x,y = ScrW()/GetConVar("zetaplayer_voicepopup_x"):GetFloat(), ScrH()/GetConVar("zetaplayer_voicepopup_y"):GetFloat()
                    y = y + popupCount*-60
                    local alpha = 255


                    if IsValid(vcdata) and vcdata:IsPlayer() then  -- This is somewhat hacky but it works
                        playervoicepopupexists = true
                        popupCount = popupCount + 1


                        if !IsValid(LocalPlayer()._zetaAvatar) then
                            LocalPlayer()._zetaAvatar = vgui.Create( "AvatarImage" )
                            LocalPlayer()._zetaAvatar:SetSize( 32, 32 )
                            LocalPlayer()._zetaAvatar:SetPos( x + 5, y + 9 )
                            LocalPlayer()._zetaAvatar:SetPlayer( LocalPlayer(), 32 )
                        end
                        if !playerspeaking then
                            alpha = (alpha - (RealTime() - playerspeakenddur) * 127.5)
                        end
                        if alpha <= 0 then
                            playervoicepopupexists = false
                            table.remove(speakingZetas, index)
                            LocalPlayer()._zetaAvatar:Remove()
                        else
                            voicechat_color.g = 0
                            voicechat_color.a = alpha
                            draw.RoundedBox( 4, x, y, 230, 50, voicechat_color )

                            LocalPlayer()._zetaAvatar:SetPos( x + 5, y + 9 )
                            LocalPlayer()._zetaAvatar:SetAlpha(alpha)

                            //render.SetMaterial(icon)
                            //render.DrawScreenQuadEx( x+5,   y+9, 32, 32 )
                            voicechat_whitecolor2.a = alpha
                            --surface.SetDrawColor(voicechat_whitecolor2)
                            --surface.SetMaterial(icon)
                            --surface.DrawTexturedRect(x + 5, y + 9, 32, 32)
                            voicechat_whitecolor.a = alpha
                            draw.DrawText( LocalPlayer():GetName(), "Trebuchet24", x+40, y+12, voicechat_whitecolor, TEXT_ALIGN_LEFT )
                        end
                        continue
                    end 


                    
                    local ID = vcdata[1]
                    local name = vcdata[2]
                    local icon = vcdata[3]
                    local dur = vcdata[4]
                    

                    if GetConVar('zetaplayer_globalvoicechat'):GetInt() == 0 and (RealTime() - vcdata[5]) < 0.2 then continue end

                    

                    -- Use the new local variable instead of table's index
                    

                    local green = 0
                    local tooFar = false
                    for k, v in pairs(voiceChannels) do
                    
                        if v[2] == ID then
                            if v[1]:Is3D() and GetConVar("zetaplayer_voicepopupdrawdistance"):GetInt() != 0 and v[1]:GetPos():Distance(LocalPlayer():GetPos()) > GetConVar("zetaplayer_voicepopupdrawdistance"):GetInt() then
                                -- If global chat is off and player if too far from speaker, don't show voice popup
                                tooFar = true
                            else
                                // Turn the box green depending on sound volume
                                green = 255 * v[3]
                            end
                    
                            break;
                        end
                    end
                    
                    if alpha > 0 and tooFar == false then
                    -- Increment the new local variable
                    popupCount = popupCount + 1
                    end

                    // Slowly fadeout

                    if !dur then return end
                    if RealTime() > dur then
                        alpha = (tooFar == true) and 0 or (alpha - (RealTime() - dur) * 127.5)
                    end
                    if alpha <= 0 then
                        table.remove(speakingZetas, index)
                    elseif !tooFar then
                        voicechat_color.g = green
                        voicechat_color.a = alpha-15
 
                        draw.RoundedBox( 4, x, y, 230, 50, voicechat_color )

                        //render.SetMaterial(icon)
                        //render.DrawScreenQuadEx( x+5,   y+9, 32, 32 )
                        voicechat_whitecolor2.a = alpha
                        surface.SetDrawColor(voicechat_whitecolor2)
                        surface.SetMaterial(icon)
                        surface.DrawTexturedRect(x + 5, y + 9, 32, 32)
                        voicechat_whitecolor.a = alpha
                        draw.DrawText( name, "Trebuchet24", x+40, y+12, voicechat_whitecolor, TEXT_ALIGN_LEFT )
                    end
                end
--[[                 for index,vcdata in ipairs(speakingZetas) do
                    local ID = vcdata[1]
                    local name = vcdata[2]
                    local icon = vcdata[3]

                    local x,y = ScrW()/GetConVar("zetaplayer_voicepopup_x"):GetFloat(), ScrH()/GetConVar("zetaplayer_voicepopup_y"):GetFloat()

                    y = y + index*-60

                    // Turn the box green depending on sound volume
                    local green = 0
                    for k, v in pairs(voiceChannels) do
                        if v[2] == ID then
                            green = 255 * v[3]
                            break;
                        end
                    end

                  draw.RoundedBox( 4, x, y, 230, 50, Color(0,green,0,255) )
                    
                    render.SetMaterial(icon)
                    render.DrawScreenQuadEx( x+5,   y+9, 32, 32 )

                    draw.DrawText( name, "Trebuchet24", x+40, y+12, Color(255,255,255), TEXT_ALIGN_LEFT ) 

                    // Slowly fadeout
                    local dur = vcdata[4]
                    local alpha = 255
                    if !dur then return end
                    if CurTime() > dur then
                        alpha = alpha - (CurTime() - dur) * 127.5
                    end
                    if alpha <= 0 then
                        table.remove(speakingZetas, index)
                    else
                        draw.RoundedBox( 4, x, y, 230, 50, Color(0,green,0,alpha-15) )

                        //render.SetMaterial(icon)
                        //render.DrawScreenQuadEx( x+5,   y+9, 32, 32 )

                        surface.SetDrawColor(255, 255, 255, alpha)
                        surface.SetMaterial(icon)
                        surface.DrawTexturedRect(x + 5, y + 9, 32, 32)

                        draw.DrawText( name, "Trebuchet24", x+40, y+12, Color(255,255,255,alpha), TEXT_ALIGN_LEFT )
                    end
                    
                end ]]

            end
        else
        if #speakingZetas > 0 then -- My system
            for index,vcdata in ipairs(speakingZetas) do

                local x,y = ScrW()/GetConVar("zetaplayer_voicepopup_x"):GetFloat(), ScrH()/GetConVar("zetaplayer_voicepopup_y"):GetFloat()

                y = y + index*-60
                if IsValid(vcdata) and vcdata:IsPlayer() then

                    if !IsValid(LocalPlayer()._zetaAvatar) then
                        LocalPlayer()._zetaAvatar = vgui.Create( "AvatarImage" )
                        LocalPlayer()._zetaAvatar:SetSize( 32, 32 )
                        LocalPlayer()._zetaAvatar:SetPos( x + 5, y + 9 )
                        LocalPlayer()._zetaAvatar:SetPlayer( LocalPlayer(), 32 )
                    end

                    if !playerspeaking then
                        table.remove(speakingZetas,index)
                        LocalPlayer()._zetaAvatar:Remove()
                    end

                    LocalPlayer()._zetaAvatar:SetPos( x + 5, y + 9 )

                    draw.RoundedBox( 4, x, y, 230, 50, zetavoicechat_black )
    
                    draw.DrawText( LocalPlayer():GetName(), "Trebuchet24", x+40, y+12, color_white, TEXT_ALIGN_LEFT )

                    continue
                end
                local name = vcdata[2]
                local icon = vcdata[3]

                
                draw.RoundedBox( 4, x, y, 230, 50, zetavoicechat_black )
                zetarender.SetMaterial(icon)
                zetarender.DrawScreenQuadEx( x+5,   y+9, 32, 32 )

                draw.DrawText( name, "Trebuchet24", x+40, y+12, color_white, TEXT_ALIGN_LEFT )
                
            end

        end
    end -- Voicechat system end
                   




        local candrawlist = hook.Run("ZetaDrawTabZetaList")

        if !candrawlist then

            if showlist then
                if CurTime() > refresh then
                    SpawnedZetas = ents.FindByClass('npc_zetaplayer')
                    refresh = CurTime()+0.2
                end
                local zetacount
                local r,g,b
    
                if #SpawnedZetas == 0 then
                    zetacount = 'None Existing Zetas'
                else
                    zetacount = 'Active Zetas '..#SpawnedZetas
                end
    
            
    
                -- Draw Title
            draw.SimpleTextOutlined('Zeta Players | '..zetacount, 'Trebuchet24', ScrW()/80, ScrH()/40, color_white, nil, nil, 1, color_black)

            for index,zeta in ipairs(SpawnedZetas) do
                if !IsValid(zeta) then continue end
                local mult 
                if GetConVar("zetaplayer_showprofilepicturesintab"):GetInt() == 1 and GetConVar("zetaplayer_usecustomavatars"):GetInt() == 1 then
                    mult = 30
                else
                    mult = 18
                end
                local row = (ScrH()/20)+index*mult
                local add = ''
                local teamadd = ''
                local adminadd = ""
                local isfriend = zeta:GetNW2Bool("zeta_showfriendstat",false)
                local name = zeta:GetNW2String('zeta_name','Zeta Player {could not get real name}')
                if isfriend then
                    add = '{ Friend }'
                else
                    add = ''
                end


                if zeta:GetNW2Bool("zeta_isadmin",false) then adminadd = "  | ADMIN " end

                if IsInTeam(zeta) then
                    teamadd = '{ '..GetConVar('zetaplayer_playerteam'):GetString()..' Member }'
                else
                    teamadd = ''
                end

                local r,g,b = zeta:GetColorByRank()

                zetatabmenu_color.r = r
                zetatabmenu_color.g = g
                zetatabmenu_color.b = b
                draw.SimpleTextOutlined(name..' '..add..' '..teamadd..adminadd, 'ChatFont', ScrW()/40, row, zetatabmenu_color, nil, nil, 0.1, color_black)
                surface.SetDrawColor( 0, 0, 0, 100 )
                local finalname = name..' '..add..' '..teamadd..adminadd
                surface.DrawRect(ScrW()/45, row,0+#finalname*9,20)

                if GetConVar("zetaplayer_showprofilepicturesintab"):GetInt() == 1 and GetConVar("zetaplayer_usecustomavatars"):GetInt() == 1 then
                    if IsValid(zeta) then
                        local pfp = zeta:GetNW2String('zeta_profilepicture',"none")
                        

                        if pfp != "none" then

                            if !zeta.zetapfpcache then
                                local mat = Material(pfp)
                                zeta.zetapfpcache = mat
                            end
                            zetarender.SetMaterial(zeta.zetapfpcache)
                            zetarender.DrawScreenQuadEx( ScrW()/200, row, 30, 30 )
                            if zeta.zetapfpcache:IsError() and canprintTAB then
                                canprintTAB = false
                            end
                        end
                    end
                end

            end

        end

        end


        if GetConVar('zetaplayer_showfriends'):GetInt() == 1 then
            local friends = GetClientZetaFriends()

            for _,zeta in ipairs(friends) do
                if zeta:IsValid() and zeta:GetPos():Distance(LocalPlayer():GetPos()) <= GetConVar('zetaplayer_frienddisplaydistance'):GetInt() and util.TraceLine({start = LocalPlayer():EyePos(),endpos = zeta:GetPos()+zeta:OBBCenter(),filter = function(ent) if ent == zeta then return true end end}).Entity == zeta then
                    local pos = zeta:GetPos()+Vector(0,0,95)
                    local screen = pos:ToScreen()
                    local r,g,b = zeta:GetColorByRank()
                    zetafriend_text.r = r
                    zetafriend_text.g = g
                    zetafriend_text.b = b
                    draw.DrawText('Friend','ChatFont',screen.x,screen.y,GetConVar("zetaplayer_usefriendcolor"):GetBool() and zetafriend_text or Color(r,g,b),TEXT_ALIGN_CENTER)
                end
            end
        end


        if GetConVar('zetaplayer_drawteamname'):GetInt() == 1 then
            local teammates = GetTeamMembers()

            for k,zeta in ipairs(teammates) do
               if IsValid(zeta) and zeta:GetPos():Distance(LocalPlayer():GetPos()) <= GetConVar('zetaplayer_teamnamedrawdistance'):GetInt() and util.TraceLine({start = LocalPlayer():EyePos(),endpos = zeta:GetPos()+zeta:OBBCenter(),filter = function(ent) if ent == zeta then return true end end}).Entity == zeta then
                   local pos = zeta:GetPos()+Vector(0,0,90)
                   local screen = pos:ToScreen()
                   local r,g,b = zeta:GetColorByRank()
                   zetateam_color.r = r
                   zetateam_color.g = g
                   zetateam_color.b = b
                    draw.DrawText(GetConVar('zetaplayer_playerteam'):GetString()..' Member','ChatFont',screen.x,screen.y,zetateam_color,TEXT_ALIGN_CENTER)
               end
            end
           end



        if GetConVar('zetaplayer_displayzetanames'):GetInt() == 0 then return end
        local w,h = ScrW(),ScrH()
        local trace = LocalPlayer():GetEyeTrace()
        local traceent = trace.Entity


        if traceent.Entity and traceent.Entity:IsValid() and traceent.Entity:GetClass() == 'npc_zetaplayer' then
            local r,g,b = traceent:GetColorByRank()
            zetadisplay_name.r = r
            zetadisplay_name.g = g
            zetadisplay_name.b = b
            local addname = ""
            local teamadd = ""
            if traceent:GetNW2String("zeta_team","") != "" then teamadd = " | "..traceent:GetNW2String("zeta_team","").." Member" end
            if traceent:GetNW2Bool("zeta_isadmin",false) then addname = "  | ADMIN " end

            local name = traceent.Entity:GetNW2String('zeta_name','Zeta Player')..teamadd..addname
 



            draw.DrawText(name,'ChatFont',w/2,h/2,zetadisplay_name,TEXT_ALIGN_CENTER)
            draw.DrawText(traceent:GetNW2Float('zeta_health','NAN')..'%','ChatFont',w/2,h/1.93,zetadisplay_name,TEXT_ALIGN_CENTER)
            
            if GetConVar("zetaplayer_displayarmor"):GetInt() == 1 then
                local armor = traceent:GetNW2Int("zeta_armor",0)
                draw.DrawText("Armor: "..armor..' %','ChatFont',w/2,h/1.85,zetadisplay_name,TEXT_ALIGN_CENTER)
            end

            local friendlist = traceent.Entity:GetNW2String("zeta_friendlist","none")
            if friendlist != "none" then
                draw.DrawText(friendlist, 'ChatFont', w/2, h/1.77, zetadisplay_name, TEXT_ALIGN_CENTER)
            end

            if GetConVar("zetaplayer_showpfpoverhealth"):GetInt() == 1 and game.SinglePlayer() then
                local pfp = traceent.Entity:GetNW2String('zeta_profilepicture',"none")
                    

                if pfp != "none" then
                    if !traceent.Entity.zetapfpcache then
                        local mat = Material(pfp)
                        traceent.Entity.zetapfpcache = mat
                    end
                    zetarender.SetMaterial(traceent.Entity.zetapfpcache)
                    zetarender.DrawScreenQuadEx( w/2+5*#name, h/2 , 40, 40 )
                    if traceent.Entity.zetapfpcache:IsError() and canprint then
                        canprint = false
                    end
                end

            end

        else
            canprint = true
        end

    end)


    hook.Add('PreDrawHalos','zetaHalos',function()

        if GetConVar('zetaplayer_drawteamhalo'):GetInt() == 1 then  
            local team_mates = GetTeamMembers()
           -- print(#team_mates)
           local dummyent = team_mates[math.random(#team_mates)]
            if #team_mates > 0 then

                local r,g,b = dummyent:GetColorByRank()
                zeta_halos.r = r
                zeta_halos.g = g
                zeta_halos.b = b
                halo.Add(team_mates,zeta_halos,1,1,2,true,GetConVar('zetaplayer_drawteamhalothroughworld'):GetBool())
            end
        end



        if GetConVar('zetaplayer_drawfriendhalo'):GetInt() == 1 then  
            local friends = GetClientZetaFriends()
            
            for _,zeta in ipairs(friends) do
                if zeta:IsValid() and zeta:GetPos():Distance(LocalPlayer():GetPos()) <= GetConVar('zetaplayer_frienddisplaydistance'):GetInt() then
                    local r,g,b = zeta:GetColorByRank()
                    zeta_halos.r = r
                    zeta_halos.g = g
                    zeta_halos.b = b
                    halo.Add({zeta},GetConVar("zetaplayer_usefriendcolor"):GetBool() and zeta_halos or Color(r,g,b),1,1,2,true,GetConVar('zetaplayer_drawfriendhalothroughworld'):GetBool())
                end
            end
        end

    end)



    function GetTeamMembers()
        local members = {}
        local entities = ents.FindByClass('npc_zetaplayer')
      
        for k,zeta in ipairs(entities) do
          if GetConVar('zetaplayer_playerteam'):GetString() != '' and zeta.zetaTeam == GetConVar('zetaplayer_playerteam'):GetString() then
            table.insert(members,zeta)
          end
        end
        return members
      end

      function IsInTeam(ent)

        if ent:IsNextBot() and ent.IsZetaPlayer then
          if GetConVar('zetaplayer_playerteam'):GetString() != '' and  ent.zetaTeam == GetConVar('zetaplayer_playerteam'):GetString() then
            return true
          else
            return false
          end
        end
      
      
      end


function CleanViewShotFolder(caller)
    local files, directories  = file.Find('zetaplayerdata/zeta_viewshots/*','DATA','namedesc')
    for _,image in ipairs(files) do
        file.Delete('zetaplayerdata/zeta_viewshots/'..image)
    end
    caller:PrintMessage(HUD_PRINTTALK,'View Shot folder Cleaned! Had '..#files..' files')
end


function OpenNameRegisterPanel(caller)
    if caller:IsPlayer() and !caller:IsSuperAdmin() then 
        net.Start('zeta_notifycleanup',true)
        net.WriteString('Only Super Admins can use these panels!')
        net.WriteBool(true)
        net.Send(caller)
     return 
    end
    local names = {}
    
    net.Start('zetapanel_getnames')
    net.SendToServer()
    local starttime = CurTime()

    notification.AddLegacy("Requesting names from Server..",NOTIFY_CLEANUP,4)


    net.Receive('zetapanel_sendnames',function()
    local name = net.ReadString()
    local isdone = net.ReadBool()
    table.insert(names,name)

    if isdone then
    notification.AddLegacy("Received all names! Took "..CurTime()-starttime.." seconds",NOTIFY_CLEANUP,4)
    local count = #names

    local panel = vgui.Create( 'DFrame' )
    panel:SetDeleteOnClose( true )
    panel:CenterHorizontal(0.3)
    panel:CenterVertical(0.4)
    panel:SetTitle('Zeta Name Panel')
    panel:SetIcon( 'icon/physgun.png' )
    panel:SetSize(600,500)
    panel:MakePopup()
    local label = vgui.Create( 'DLabel', panel )
    label:SetText('Welcome to the Name Panel! There are '..count..' Names.')
    label:Dock(TOP)

    local label2 = vgui.Create( 'DLabel', panel )
    label2:SetText('You can Register names by using the text box below and you can remove names by right clicking on a name.')
    label2:Dock(TOP)
    
    local panellist = vgui.Create( 'DListView', panel )

    panellist:Dock(TOP)
    panellist:SetSize(100,300)
    panellist:AddColumn('Zeta Names',1)

    function panellist:OnRowRightClick(id,line)
        net.Start('zetapanel_removename')
        net.WriteString(line:GetSortValue(1))
        net.SendToServer()
        notification.AddLegacy('Removed '..line:GetSortValue(1)..' from Zeta names',NOTIFY_CLEANUP,4)
        LocalPlayer():EmitSound('buttons/button15.wav')
        panellist:RemoveLine( id )
        panellist:SetDirty( true )
        count = count - 1
        label:SetText('Welcome to the Name Panel! There are '..count..' Names. Re-open the panel when you need to see changes')
    end

    for k,v in ipairs(names) do
        local line = panellist:AddLine(v)
        line:SetSortValue( 1, v )
    end

    local resetbutton = vgui.Create( 'DButton', panel )
    resetbutton:Dock(BOTTOM)
    resetbutton:SetText('Reset Names to Default. A backup file will save your names before they are reset')

    function resetbutton:DoClick()
        net.Start('zetapanel_resetnames')
        net.SendToServer()
        notification.AddLegacy('Reset Zeta Names to Default!',NOTIFY_CLEANUP,4)
        LocalPlayer():EmitSound('buttons/button15.wav')
        panel:Close()
    end

    local textpanel = vgui.Create( 'DTextEntry', panel)
    textpanel:DockMargin(0, 0, 0, 60)
    textpanel:Dock(BOTTOM)

    function textpanel:OnEnter(val)
        if val != '' then
        net.Start('zetapanel_addname')
        net.WriteString(val)
        net.SendToServer()
        textpanel:SetText('')
        local line = panellist:AddLine(val)
        line:SetSortValue( 1, val )
        panellist:SetDirty( true )
        count = count + 1
        label:SetText('Welcome to the Name Panel! There are '..count..' Names')
        textpanel:RequestFocus()
        end
    end
    

    local label = vgui.Create( 'DLabel', panel )
    label:SetText('Type a name here and press enter to register it!')
    label:Dock(BOTTOM)

    end


    end)

end






















local function GetAttachmentPoint(self,pointtype)

    if pointtype == "hand" then
  
      local lookup = self:LookupAttachment('anim_attachment_RH')
  
      if lookup == 0 then
          local bone = self:LookupBone("ValveBiped.Bip01_R_Hand")
  
          if !bone then
            return {Pos = (self:GetPos()+self:OBBCenter()),Ang = self:GetForward():Angle()}
          else
            return self:GetBonePosAngs(bone)
          end
          
      else
        return self:GetAttachment(lookup)
      end
  
    elseif pointtype == "eyes" then
      
      local lookup = self:LookupAttachment('eyes')
  
      if lookup == 0 then
          return {Pos = self:GetPos()+self:OBBCenter()+Vector(0,0,5),Ang = self:GetForward():Angle()+Angle(-20,0,0)}
      else
        return self:GetAttachment(lookup)
      end
  
    end
  
  end

function TakeZetaViewShot(self)

    if GetConVar('zetaplayer_allowzetascreenshots'):GetInt() == 0 then return end
    if 100 * math.random() > GetConVar('zetaplayer_zetascreenshotchance'):GetInt() then return end

    local attachment = GetAttachmentPoint(self,"eyes")
    local filetype = GetConVar('zetaplayer_zetascreenshotfiletype'):GetString()
    
    hook.Add('CalcView','zetaviewshotcalc'..self:EntIndex(),function(ply, origin,angles, fov, znear, zfar)
        if !IsValid(self) then hook.Remove('CalcView','zetaviewshotcalc'..self:EntIndex()) return end
        return {
            origin = attachment.Pos,
            angles = attachment.Ang,
            fov = GetConVar('zetaplayer_zetascreenshotfov'):GetInt(),
            drawviewer = true
        }
    end)
    hook.Add('PreDrawEffects','zetaviewshot'..self:EntIndex(),function()
        if !IsValid(self) then hook.Remove('PreDrawEffects','zetaviewshot'..self:EntIndex()) return end
            local viewshot = render.Capture({
                format = filetype,
                x = 0,
                y = 0,
                w = ScrW(),
                h = ScrH(),
                alpha = false
            } )

        local path = 'zetaplayerdata/zeta_viewshots/'..self:GetNW2String('zeta_name','Zeta Player')..'_'..game.GetMap()..'_'..tostring(math.random(1,100000))..'.png'
        
        
            file.Write(path,viewshot)
            hook.Remove('CalcView','zetaviewshotcalc'..self:EntIndex())
            hook.Remove('PreDrawEffects','zetaviewshot'..self:EntIndex())
        
        
    end)

end



end



if ( CLIENT )  then

    net.Receive("zeta_changegetplayername",function()
        local ent = net.ReadEntity()
        local name = net.ReadString()
        if !IsValid(ent) then return end
        ent.GetPlayerName = function() return name end
    end)

    net.Receive("zeta_joinmessage",function()
        if GetConVar("zetaplayer_showconnectmessages"):GetInt() == 0 then return end
        local name = net.ReadString()
        local clr = net.ReadColor(false)

        chat.AddText( clr,name,Color(255,255,255)," connected to the server" )

        LocalPlayer():EmitSound(GetConVar("zetaplayer_customjoinsound"):GetString() != "" and GetConVar("zetaplayer_customjoinsound"):GetString() or 'friends/friend_join.wav')

    end)

    net.Receive("zeta_disconnectmessage",function()
        local name = net.ReadString()
        local clr = net.ReadColor(false)

        chat.AddText( clr,name,Color(255,255,255)," disconnected from server" )

        LocalPlayer():EmitSound(GetConVar("zetaplayer_customleavesound"):GetString() != "" and GetConVar("zetaplayer_customleavesound"):GetString() or 'friends/message.wav')


    end)




    local textchatcolor = Color(0,0,0)

    local eyetaptrace = {
        collisiongroup = COLLISION_GROUP_WORLD
    }

    local function ZetaTap(ent)
       
        local lastpos = Vector(0,0,0)
        local vectoradd = VectorRand(0,1300)
        local frac = 0
        local add = 0.01
        hook.Add("KeyPress","zetaeyetap_abort",function(ply,key)
            if key == IN_JUMP then
                hook.Remove("KeyPress","zetaeyetap_abort")
                hook.Remove("CalcView","zetaeyeTap_Calcview")
            end
        end)
        hook.Add("CalcView","zetaeyeTap_Calcview",function(ply,origin,angles,fov,znear,zfar)

            if !IsValid(ent) then
                if add > 0 then
                    frac = frac + add
                    add = add - 0.00007
                end
                local targetpos = (lastpos+vectoradd)
                eyetaptrace.start = lastpos
                eyetaptrace.endpos = targetpos
                local trace = util.TraceLine(eyetaptrace)
                local lerp = LerpVector(frac,lastpos,trace.HitPos)
                local returns = {
                    origin = lerp,
                    angles = (lastpos-lerp):Angle(),
                    fov = fov,
                    znear = znear,
                    zfar = zfar,
                    drawviewer = true
                }

                return returns
            end

            
            local attach = ent:GetAttachmentPoint("eyes")
            attach.Ang.z = (GetConVar("zetaplayer_eyetap_preventtilting"):GetBool() and 0 or attach.Ang.z)
            lastpos = attach.Pos or ent:GetPos()

            local returns = {
                origin = attach.Pos,
                angles = attach.Ang,
                fov = fov,
                znear = znear,
                zfar = zfar,
                drawviewer = true
            }
            return returns
        end)
    


    
    end

    net.Receive("zetaplayer_eyetap",function()
        local zeta = net.ReadEntity()
        if !IsValid(zeta) then return end
        ZetaTap(zeta)
    end)








    net.Receive("zeta_achievement",function()
        local zetaname = net.ReadString()
        local text = net.ReadString()
        local col = net.ReadColor(false)

        
        chat.AddText(col,zetaname,color_white," earned the achievement ",Color(238,255,0),text)
    end)


    net.Receive("zeta_chatsend", function()
        local zetaname = net.ReadString()
        local text = net.ReadString()
        local rank = net.ReadString()
        local mdlcolor = net.ReadColor(false)
        local isdead = net.ReadBool()
        local pos = net.ReadVector()

        local dist = GetConVar("zetaplayer_textchatreceivedistance"):GetInt()
        if dist > 0 and LocalPlayer():GetPos():Distance(pos) > dist then
            return
        end

        local r,g,b = GetConVar('zetaplayer_displaynameRed'):GetInt(),GetConVar('zetaplayer_displaynameGreen'):GetInt(),GetConVar('zetaplayer_displaynameBlue'):GetInt()
        textchatcolor.r = r
        textchatcolor.g = g
        textchatcolor.b = b

        if mdlcolor and mdlcolor != Color(0,0,0) then
            textchatcolor.r = mdlcolor.r
            textchatcolor.g = mdlcolor.g
            textchatcolor.b = mdlcolor.b
        end

        if rank == "friend" then
            r,g,b = GetConVar('zetaplayer_friendnamecolorR'):GetInt(),GetConVar('zetaplayer_friendnamecolorG'):GetInt(),GetConVar('zetaplayer_friendnamecolorB'):GetInt()
            textchatcolor.r = r
            textchatcolor.g = g
            textchatcolor.b = b
        elseif rank == "admin" then
            r,g,b = GetConVar('zetaplayer_admindisplaynameRed'):GetInt(),GetConVar('zetaplayer_admindisplaynameGreen'):GetInt(),GetConVar('zetaplayer_admindisplaynameBlue'):GetInt()
            textchatcolor.r = r
            textchatcolor.g = g
            textchatcolor.b = b
        elseif rank == "team" then
            r,g,b = GetConVar('zetaplayer_teamcolorRed'):GetInt(),GetConVar('zetaplayer_teamcolorGreen'):GetInt(),GetConVar('zetaplayer_teamcolorBlue'):GetInt()
            textchatcolor.r = r
            textchatcolor.g = g
            textchatcolor.b = b
        end
        local deadadd = ""

        if isdead then
            deadadd = "*DEAD* "
        end
        
        chat.AddText(Color(177,0,0),deadadd,textchatcolor,zetaname,color_white,":".." "..text)
    end)


    net.Receive("zeta_createc4decal",function()
        local result = net.ReadTable()
        if !result.Hit then return end

        local mat = util.DecalMaterial( "Scorch" )
        local imat = Material(mat)
        util.DecalEx( imat, Entity(0), result.HitPos, result.HitNormal, Color(255,255,255), 10,10 )
    end)


    net.Receive('zeta_createcsragdoll',function()
        local zeta = net.ReadEntity()
        local color = net.ReadVector()
        if !IsValid(zeta) or zeta:GetShouldServerRagdoll() then return end
    
        local ragdoll = zeta:BecomeRagdollOnClient()
        zeta.DeathRagdoll = ragdoll
    
        ragdoll.GetPlayerColor = function() return color end
    
        if GetConVar('zetaplayer_cleanupcorpse'):GetBool() then
            timer.Simple(GetConVar('zetaplayer_cleanupcorpsetime'):GetInt(), function()
                if !IsValid(ragdoll) then return end
                if GetConVar('zetaplayer_cleanupcorpseeffect'):GetBool() then
                    ragdoll:Disintegrate()
                    return
                end
                if GetConVar("zetaplayer_explosivecorpsecleanup"):GetBool() then
                    net.Start('zeta_csragdollexplode', true)
                        net.WriteVector(ragdoll:GetPos())
                    net.SendToServer()
    
                    local effectdata = EffectData()
                    effectdata:SetOrigin( ragdoll:GetPos() )
                    util.Effect( "Explosion", effectdata, true, true )
                    ragdoll:EmitSound("BaseExplosionEffect.Sound")
                end
                ragdoll:Remove()
            end)
        end
    end)


    net.Receive("zeta_sendcoloredtext",function()
        local json = net.ReadString()
        local textargs = util.JSONToTable(json)
        
        chat.AddText(unpack(textargs))
    end)


    net.Receive('zeta_usesprayer', function()
        local spray = net.ReadString()      // Spray Image Path
        local traceTbl = net.ReadTable()    // TraceResult table
        local sprayIndex = net.ReadInt(32)
        local sprayMat = nil
        if sprayIndex != -1 then
            // Create material from texture
            // sprayIndex is used to create unique material names
            sprayMat = CreateMaterial('zetaSpray'..sprayIndex, 'LightmappedGeneric', {
                ['$basetexture'] = spray,
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
            // Create material from image
            sprayMat = Material(spray)
        end
        if !sprayMat or sprayMat:IsError() then print("Zeta Sprays: "..spray.." Failed to load and or is a error!") return end
        if GetConVar("zetaplayer_playersizedsprays"):GetInt() == 1 then
            local texWidth = sprayMat:Width()
            local texHeight = sprayMat:Height()

            local widthPower = 256
            local heightPower = 256
            if texWidth > texHeight then
                heightPower = 128
            elseif texHeight > texWidth then
                widthPower = 128
            end

            if texWidth < 256 then
                texWidth = (texWidth / 256)
            else
                texWidth = (widthPower / (texWidth * 4))
            end

            if texHeight < 256 then
                texHeight = (texHeight / 256)
            else
                texHeight = (heightPower / (texHeight * 4))
            end

            -- Create spray decal
            util.DecalEx(sprayMat, Entity(0), traceTbl.HitPos, traceTbl.HitNormal, Color(255, 255, 255, 255), texWidth, texHeight)
        else
            -- Old method because it is funny to see large sprays
            local width = (sprayMat:Width() * 0.15) / sprayMat:Width()
            local height = (sprayMat:Height() * 0.15) / sprayMat:Height() 
            util.DecalEx(sprayMat, Entity(0), traceTbl.HitPos, traceTbl.HitNormal, Color(255, 255, 255, 255), width, height)
        end




    end)


--[[     net.Receive('zeta_usesprayer', function() -- New Spray System by Erma
        local spray = net.ReadString()      // Spray Image Path
        local traceTbl = net.ReadTable()    // TraceResult table

        // Create material from image
        local sprayMat = Material(spray)
        if sprayMat:IsError() then print("Zeta Sprays: "..spray.." Failed to load and or is a error!") return end

        // Scale the material
        local width = (sprayMat:Width() * 0.15) / sprayMat:Width()
        local height = (sprayMat:Height() * 0.15) / sprayMat:Height() 

        // Create spray decal
        if traceTbl.Entity == NULL or traceTbl.Entity == nil then return end -- Using this because IsValid() returns false if it is World Spawn
        util.DecalEx(sprayMat, Entity(0), traceTbl.HitPos, traceTbl.HitNormal, Color(255, 255, 255, 255), width, height)
    end) ]]

    matproxy.Add( {
        name = "ZetaPlayerWeaponColor",
    
        init = function( self, mat, values )
    
            self.ResultTo = values.resultvar
    
        end,
    
        bind = function( self, mat, ent )
    
            if ( !IsValid( ent ) ) then return end

            local wepClr = ent:GetNW2Vector('zeta_physcolor')
            if ( isvector(wepClr) and wepClr != Vector(0,0,0)) then
                local mul = ( 1 + math.sin( CurTime() * 5 ) ) * 0.5
                mat:SetVector( self.ResultTo, wepClr + wepClr * mul )
                return
            end
    
            local owner = ent:GetOwner()
            if ( !IsValid( owner ) or !owner.IsZetaPlayer ) then return end
    
            local col = owner:GetNW2Vector('zeta_physcolor',Vector(1,1,1))
            if ( !isvector( col ) ) then return end
    
            local mul = ( 1 + math.sin( CurTime() * 5 ) ) * 0.5

            mat:SetVector( self.ResultTo, col + col * mul )
    
        end
    } )


    local voiceicon = Material("voice/icntlk_pl")
    net.Receive('zeta_addkillfeed',function()
        local killfeednet = net.ReadString()
        local killfeeddata = util.JSONToTable(killfeednet)


        if table.IsEmpty(killfeeddata) then return end

        local killfeedicon = net.ReadBool()
        local add = ((!killfeedicon and killfeeddata.prettyprint) and " | using a "..killfeeddata.prettyprint or "") 

        if !killicon.Exists( killfeeddata.inflictor ) then
            killfeeddata.inflictor = "default"
        end
        
        GAMEMODE:AddDeathNotice(language.GetPhrase(killfeeddata.attacker)..add,killfeeddata.attackerteam,killfeeddata.inflictor,killfeeddata.victim,killfeeddata.victimteam)

    end)



    net.Receive('zeta_notifycleanup',function()
        local text = net.ReadString()
        local fail = net.ReadBool()
        if !fail then
            notification.AddLegacy(text,NOTIFY_CLEANUP,4)
            LocalPlayer():EmitSound('buttons/button15.wav')
        else
            notification.AddLegacy(text,NOTIFY_ERROR,4)
            LocalPlayer():EmitSound('buttons/button10.wav')
        end
    end)

    net.Receive('zeta_playermodelcolor',function()
        local ent = net.ReadEntity()
        local color = net.ReadVector()
        if ent:IsValid() then
            ent.GetPlayerColor = function() return color end
        end
    end)

    net.Receive('zeta_voiceicon',function()
        if GetConVar('zetaplayer_drawvoiceicon'):GetInt() == 0 then return end
        local zeta = net.ReadEntity()
        local time = net.ReadFloat()
        
        if zeta:IsValid() then

            local followEnt = zeta
            if IsValid(zeta.DeathRagdoll) then followEnt = zeta.DeathRagdoll 
            elseif IsValid(zeta:GetNW2Entity('zeta_ragdoll', NULL)) then followEnt = zeta:GetNW2Entity('zeta_ragdoll', NULL) end

            timer.Simple(time,function() hook.Remove('PreDrawEffects','zetavoiceicon'..followEnt:EntIndex()) end)
        hook.Add('PreDrawEffects','zetavoiceicon'..followEnt:EntIndex(),function()
            if !followEnt:IsValid() then hook.Remove('PreDrawEffects','zetavoiceicon'..followEnt:EntIndex()) return end
                local ang = EyeAngles()
                local pos = followEnt:GetPos() + Vector(0, 0, 80)
                ang:RotateAroundAxis(ang:Up(), -90)
                ang:RotateAroundAxis(ang:Forward(), 90)
        
                cam.Start3D2D(pos, ang, 1)
                surface.SetMaterial(voiceicon)
                surface.SetDrawColor(255, 255, 255)
                surface.DrawTexturedRect(-8, -8, 16, 16)
                cam.End3D2D()
            
        end)
        end
        end)

        net.Receive('zeta_requestviewshot',function()
            local zeta = net.ReadEntity()
            if IsValid(zeta) then
                TakeZetaViewShot(zeta)
            end
        end)




end 




if ( CLIENT ) then
    concommand.Add('zetaplayer_cleanviewshotfolder',CleanViewShotFolder,nil,'Cleans the View Shot Folder')
    concommand.Add('zetaplayer_opennamepanel',OpenNameRegisterPanel,nil,'Opens the Name Register Panel')
    concommand.Add('zetaplayer_openproppanel',OpenPropPanel,nil,'Opens the Prop Register Panel')
    concommand.Add('zetaplayer_openentpanel',OpenEntPanel,nil,'Opens the Entity Register Panel')
    concommand.Add('zetaplayer_opennpcpanel',OpenNPCPanel,nil,'Opens the NPC Register Panel')
    concommand.Add('zetaplayer_openprofilepanel',OpenProfilePanel,nil,'Opens the Profile Panel')
end


concommand.Add( 'zetaplayer_autotweaknavmesh', _ZetaTweakNavmesh, nil, "Edits the entire navigation mesh to suit the zetas")
concommand.Add( 'zetaplayer_savenavmesh', _ZetaSavenavmesh, nil, "Saves the navigation mesh edited by auto tweak")

--[[ concommand.Add( 'zetaplayer_force_findpokertable', ZetasForceFindTable, nil, "Force all nearby Zetas to find a poker table") ]]
concommand.Add( 'zetaplayer_force_panicaroundplayer', PanicZetasAroundPlayer, nil, "Panic all nearby Zetas that are around the player")
concommand.Add( 'zetaplayer_force_panicinviewofplayer', PanicZetasInView, nil, "Panic all Zetas that are in view of the player")
concommand.Add( 'zetaplayer_force_laughatplayer', ZetasLaughInView, nil, "Makes all nearby Zetas laugh at the player")
concommand.Add( 'zetaplayer_force_targetplayer', ZetasTargetPlayer, nil, "Makes all nearby Zetas attack at the player")
concommand.Add( 'zetaplayer_force_killall', ZetasDiesAroundPlayer, nil, "Makes all nearby Zetas commit suicide around the player")
-- Just in case.

concommand.Add( 'zetaplayer_registermaterial', RegisterMaterial, nil, "Adds a material that a zeta can use")
concommand.Add( 'zetaplayer_removematerial', RemoveMaterial, nil, "Removes a registered material")
concommand.Add( 'zetaplayer_registerprop', RegisterProp, nil, "Adds a prop that a zeta can spawn")
concommand.Add( 'zetaplayer_removeprop', RemoveProp, nil, "Removes a registered prop")

concommand.Add( 'zetaplayer_updateservercache', _ZetaUpdateServerCache, nil, "Updates the Data Cache")

concommand.Add( 'zetaplayer_registername', RegisterName, nil, "Adds a name a zeta can use")
concommand.Add( 'zetaplayer_removename', RemoveName, nil, "Removes a Zeta name")

concommand.Add( 'zetaplayer_registerentity', RegisterEntity, nil, "Adds a Entity that a zeta can spawn")
concommand.Add( 'zetaplayer_removeentity', RemoveEntity, nil, "Removes a registered Entity")

concommand.Add( 'zetaplayer_registernpc', RegisterNPC, nil, "Adds a NPC that a zeta can spawn")
concommand.Add( 'zetaplayer_removenpc', RemoveNPC, nil, "Removes a registered NPC")

concommand.Add( 'zetaplayer_cleanupents', CleanupZetaEnts, nil, "Removes all currently spawned Zeta Entities")
concommand.Add( 'zetaplayer_cleanupzetaplayers', CleanupAllZetas, nil, "Removes all currently spawned Zeta Players")

concommand.Add( 'zetaplayer_force_befriendplayer', ZetasForceFriendToPlayer, nil, "Force all nearby Zetas to befriend the player")

concommand.Add( 'zetaplayer_tptorandomzeta', TeleportRNDZeta, nil, "Teleport to a random Zeta")
concommand.Add( 'zetaplayer_tptofriendzeta', TeleportFriendZeta, nil, "Teleport to a Zeta who considers you as a friend")
concommand.Add( 'zetaplayer_tpfriendzetatoself', TeleportFriendZetaToCaller, nil, "Teleport to a Friend Zeta to your position")

concommand.Add( 'zetaplayer_debugzetainfo', testzetastate, nil, "Debug a Zeta's info")

concommand.Add( 'zetaplayer_cacheallmodels', PrecacheAllPlayermodels, nil, "Cache all Playermodels. WARNING! THIS WILL LAG YOUR GAME")

concommand.Add( 'zetaplayer_createserverjunk', CreateServerJunk, nil, "Spawn junk all over the map")
concommand.Add( 'zetaplayer_setplayerbirthday', SetPlayerBirthday, nil, "Enter your birthday here. EXAMPLE: December 5")


if SERVER then -- Cache all these values 
    
    _SERVERTEXTDATA = util.JSONToTable(file.Read("zetaplayerdata/textchatdata.json","DATA"))

    _SERVERMEDIADATA = util.JSONToTable(file.Read("zetaplayerdata/mediaplayerdata.json","DATA"))

    _SERVERValidMaterials = util.JSONToTable(file.Read('zetaplayerdata/materials.json','DATA'))

    _SERVERValidProps = util.JSONToTable(file.Read('zetaplayerdata/props.json','DATA'))

    _SERVERValidNPCS = util.JSONToTable(file.Read('zetaplayerdata/npcs.json','DATA'))

    _SERVERValidENTS = util.JSONToTable(file.Read('zetaplayerdata/ents.json','DATA'))

    _SERVERNAMES = util.JSONToTable(file.Read('zetaplayerdata/names.json','DATA'))

    _SERVERPFPS,_SERVERPFPDIRS = file.Find("zetaplayerdata/custom_avatars/*","DATA","nameasc")
    
    ----
    local managermodels = player_manager.AllValidModels()
    _SERVERPLAYERMODELS = table.Copy(managermodels)
    ----

    _SERVERPLAYERMODELS = table.ClearKeys( _SERVERPLAYERMODELS )


    local json = file.Read("zetaplayerdata/blockedplayermodels.json","DATA")
    local blockedmdls = util.JSONToTable(json)

    if #blockedmdls > 0 then
        for k,v in ipairs(blockedmdls) do
            if !util.IsValidModel(v) then continue end
            local key = table.KeyFromValue( _SERVERPLAYERMODELS, v )
            
            table.remove(_SERVERPLAYERMODELS,key)
        end
    end

    
    _SERVERDEFAULTMDLS = {
        'models/player/alyx.mdl',
        'models/player/arctic.mdl',
        'models/player/barney.mdl',
        'models/player/breen.mdl',
        'models/player/charple.mdl',
        'models/player/combine_soldier.mdl',
        'models/player/combine_soldier_prisonguard.mdl',
        'models/player/combine_super_soldier.mdl',
        'models/player/corpse1.mdl',
        'models/player/dod_american.mdl',
        'models/player/dod_german.mdl',
        'models/player/eli.mdl',
        'models/player/gasmask.mdl',
        'models/player/gman_high.mdl',
        'models/player/guerilla.mdl',
        'models/player/kleiner.mdl',
        'models/player/leet.mdl',
        'models/player/odessa.mdl',
        'models/player/phoenix.mdl',
        'models/player/police.mdl',
        'models/player/riot.mdl',
        'models/player/skeleton.mdl',
        'models/player/soldier_stripped.mdl',
        'models/player/swat.mdl',
        'models/player/urban.mdl',
        'models/player/group01/female_0'..math.random(1,6)..'.mdl',
        'models/player/group01/male_0'..math.random(1,9)..'.mdl',
        'models/player/group02/male_02.mdl',
        'models/player/group02/male_04.mdl',
        'models/player/group02/male_06.mdl',
        'models/player/group02/male_08.mdl',
        'models/player/group03/female_0'..math.random(1,6)..'.mdl',
        'models/player/group03/male_0'..math.random(1,9)..'.mdl',
        'models/player/group03m/female_0'..math.random(1,6)..'.mdl',
        'models/player/group03m/male_0'..math.random(1,9)..'.mdl',
        "models/player/zombie_soldier.mdl",
        "models/player/p2_chell.mdl",
        "models/player/mossman.mdl",
        "models/player/mossman_arctic.mdl",
        "models/player/magnusson.mdl",
        "models/player/monk.mdl",
        "models/player/zombie_fast.mdl"
    }

    if GetConVar("zetaplayer_enableblockmodels"):GetBool() then
        local json = file.Read("zetaplayerdata/blockedplayermodels.json","DATA")
        local blockedmdls = util.JSONToTable(json)
        if #blockedmdls > 0 then
            for k,v in ipairs(blockedmdls) do
                if !util.IsValidModel(v) then continue end

                local key = table.KeyFromValue( _SERVERDEFAULTMDLS, v )
                
                table.remove(_SERVERDEFAULTMDLS,key)
            end
        end
    end



    _ZETANAVMESH = {}

    local navmes = navmesh.GetAllNavAreas()

    for k,nav in ipairs(navmes) do
        if IsValid(nav) and nav:GetSizeX() > 75 or nav:GetSizeY() > 75 then
            table.insert(_ZETANAVMESH,nav)
        end
    end
end


_ZETANORMALSEATS = {
    ["models/nova/airboat_seat.mdl"] = true,
    ["models/nova/chair_plastic01.mdl"] = true,
    ["models/nova/chair_wood01.mdl"] = true,
    ["models/nova/chair_plastic01.mdl"] = true,
    ["models/nova/chair_office02.mdl"] = true,
    ["models/nova/chair_office01.mdl"] = true,
    ["models/nova/jeep_seat.mdl"] = true,
    ["models/nova/jalopy_seat.mdl"] = true,
    ["models/props_phx/carseat2.mdl"] = true,
    ["models/props_phx/carseat3.mdl"] = true,
}



if gPoker and gPoker.betType then
    gPoker.betType[1].get = function(p)
        if p:IsPlayer() or p.IsZetaPlayer then
            return p:Health()
        else
            local ent = gPoker.getTableFromPlayer(p)
            if !IsValid(ent) then return 0 end
            local key = ent:getPlayerKey(p)
            return ent.players[key].health
        end
    end
    gPoker.betType[1].add = function(p, a, e)
        if CLIENT then return end
        if !IsValid(p) then return end
        
        a = a or 0

        local hp = gPoker.betType[e:GetBetType()].get(p) + a
        if hp < 1 then 
            e:removePlayerFromMatch(p)
            if p:IsPlayer() or p.IsZetaPlayer then p:Kill() end
        else
            if p:IsPlayer() or p.IsZetaPlayer then p:SetHealth(hp) else 
                e.players[e:getPlayerKey(p)].health = hp 
                e:updatePlayersTable() 
            end
        end

        e:SetPot(e:GetPot() - a)
    end
end