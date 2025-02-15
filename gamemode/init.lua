-- Include NutScript content. changed the rebel1324's version.
resource.AddWorkshop("1355625344")

-- Include features from the Sandbox gamemode.
DeriveGamemode("sandbox")
-- Define a global shared table to store NutScript information.
nut = nut or {util = {}, meta = {}}

-- Send the following files to players.
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("core/sh_util.lua")
AddCSLuaFile("shared.lua")

-- Include utility functions, data storage functions, and then shared.lua
include("core/sh_util.lua")
include("core/sv_data.lua")
include("shared.lua")

local color_green = Color(0, 255, 0)
local color_red = Color(255, 0, 0)

-- Connect to the database using SQLite, mysqloo, or tmysql4.
timer.Simple(0, function()
	hook.Run("SetupDatabase")

	nut.db.connect(function()
		-- Create the SQL tables if they do not exist.
		nut.db.loadTables()
		nut.log.loadTables()

		MsgC(color_green, "NutScript has connected to the database.\n")
		MsgC(color_green, "Database Type: "..nut.db.module..".\n")

		hook.Run("DatabaseConnected")
	end)
end)

concommand.Add("nut_setowner", function(client, command, arguments)
	if (!IsValid(client)) then
		MsgC(color_red, "** 'nut_setowner' has been deprecated in NutScript 1.1\n")
		MsgC(color_red, "** Instead, please install an admin mod and use that instead.\n")
	end
end)

cvars.AddChangeCallback("sbox_persist", function(name, old, new)
	-- A timer in case someone tries to rapily change the convar, such as addons with "live typing" or whatever
	timer.Create("sbox_persist_change_timer", 1, 1, function()
		hook.Run("PersistenceSave", old)

		game.CleanUpMap() -- Maybe this should be moved to PersistenceLoad?

		if (new == "") then return end

		hook.Run("PersistenceLoad", new)
	end)
end, "sbox_persist_load")
