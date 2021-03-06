-- module_loader by Adynathos.
BASE_MODULES = {
	'util',
	'timers',
	'physics',
	'lib.statcollection',
	'abilities',
	'samplerts',
	'buildinghelper',
	'ltw',
	'multi',
	'popups',
	'upgrades',
}

--MODULE LOADER STUFF
BASE_LOG_PREFIX = '[SRTS]'

LOG_FILE = "log/SampleRTS.txt"

InitLogFile(LOG_FILE, "[[ SampleRTS ]]")

function log(msg)
	print(BASE_LOG_PREFIX .. msg)
	AppendToLogFile(LOG_FILE, msg .. '\n')
end

function err(msg)
	display('[X] '..msg, COLOR_RED)
end

function warning(msg)
	display('[W] '..msg, COLOR_DYELLOW)
end

function display(text, color)
	color = color or COLOR_LGREEN

	log('> '..text)

	Say(nil, color..text, false)
end

local function load_module(mod_name)
	-- load the module in a monitored environment
	local status, err_msg = pcall(function()
		require(mod_name)
	end)

	if status then
		log(' module ' .. mod_name .. ' OK')
	else
		err(' module ' .. mod_name .. ' FAILED: '..err_msg)
	end
end
--END OF MODULE LOADER STUFF

-- Load all modules
for i, mod_name in pairs(BASE_MODULES) do
	load_module(mod_name)
end

function Precache( context )
	-- NOTE: IT IS RECOMMENDED TO USE A MINIMAL AMOUNT OF LUA PRECACHING, AND A MAXIMAL AMOUNT OF DATADRIVEN PRECACHING.
	-- Precaching guide: https://moddota.com/forums/discussion/119/precache-fixing-and-avoiding-issues

	--[[
	This function is used to precache resources/units/items/abilities that will be needed
	for sure in your game and that cannot or should not be precached asynchronously or 
	after the game loads.

	See SampleRTS:PostLoadPrecache() in samplerts.lua for more information
	]]

	print("[SAMPLERTS] Performing pre-load precache")

	-- Particles can be precached individually or by folder
	-- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
	PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
	PrecacheResource("particle_folder", "particles/test_particle", context)
	PrecacheResource("particle_folder", "particles/buildinghelper", context)

	-- Models can also be precached by folder or individually
	-- PrecacheModel should generally used over PrecacheResource for individual models
	PrecacheResource("model_folder", "particles/heroes/antimage", context)
	PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
	PrecacheModel("models/heroes/viper/viper.vmdl", context)
	PrecacheResource( "model_folder", "models/heroes/wisp/", context )
	PrecacheResource( "particle_folder", "particles/units/heroes/wisp/", context )

	-- Sounds can precached here like anything else
	PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)


	-- Entire items can be precached by name
	-- Abilities can also be precached in this way despite the name
	PrecacheItemByNameSync("example_ability", context)
	PrecacheItemByNameSync("item_example_item", context)

	-- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
	-- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
	PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
	PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
	PrecacheUnitByNameSync("npc_dota_hero_drow_ranger", context)
	PrecacheUnitByNameSync("npc_dota_hero_tinker", context)
	PrecacheUnitByNameSync("npc_dota_hero_jakiro", context)
	PrecacheUnitByNameSync("npc_dota_hero_wisp", context)
	PrecacheUnitByNameSync("arrow_tower_two", context)
	PrecacheUnitByNameSync("npc_ground_prop", context)
	PrecacheUnitByNameSync("npc_sheep", context)
	PrecacheUnitByNameSync("npc_wolf", context)
	PrecacheUnitByNameSync("npc_skeleton", context)
	PrecacheUnitByNameSync("npc_acolyte", context)
	PrecacheUnitByNameSync("npc_treant", context)
	PrecacheUnitByNameSync("npc_swordsman", context)
	PrecacheUnitByNameSync("npc_grunt", context)
	PrecacheUnitByNameSync("npc_temptress", context)
	PrecacheUnitByNameSync("npc_shade", context)
	PrecacheUnitByNameSync("npc_golem", context)
	PrecacheUnitByNameSync("npc_boss_one", context)
	PrecacheUnitByNameSync("arrow_tower_four_two", context)
	PrecacheUnitByNameSync("npc_dota_hero_shredder", context)
	PrecacheUnitByNameSync("sharp_tower_two", context)
	PrecacheUnitByNameSync("npc_dota_hero_bloodseeker ", context)
	PrecacheUnitByNameSync("sharp_tower_three_two", context)
	PrecacheUnitByNameSync("npc_dota_hero_ogre_magi ", context)
	PrecacheUnitByNameSync("sharp_tower_four_one", context)
	PrecacheUnitByNameSync("sharp_tower_four_two", context)
	PrecacheUnitByNameSync("npc_anti_cheat", context)
	PrecacheUnitByNameSync("elemental_tower", context)
	PrecacheUnitByNameSync("fire_tower_one", context)
	PrecacheUnitByNameSync("fire_tower_two", context)
	PrecacheUnitByNameSync("ice_tower_one", context)
	
	

	
	
	

	PrecacheUnitByNameSync("npc_barracks", context) -- Building that spawns units
	PrecacheUnitByNameSync("npc_peasant", context) -- Unit that builds and gathers resources
	PrecacheItemByNameSync("item_rally", context) -- Flag, should be a clientside particle instead
end

-- Create the game mode when we activate
function Activate()
	GameRules.SampleRTS = SampleRTS()
	GameRules.SampleRTS:InitSampleRTS()
	GameRules.LTW = LTW()
	GameRules.LTW:InitLTW()
	GameRules.Multi = CMultiteamExampleGameMode()
	GameRules.Multi:InitMulti()
	GameRules.UnitKV = LoadKeyValues("scripts/npc/npc_units_custom.txt")
	GameRules.AbilityKV = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
	GameRules.ItemKV = LoadKeyValues("scripts/npc/npc_items_custom.txt")
	GameRules.Requirements = LoadKeyValues("scripts/kv/tech_tree.kv")
end
