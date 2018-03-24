-- Do not edit shit you do not have any idea what it is.
Party_System = Party_System or {}
Party_System.Config = Party_System.Config or {}
Party_System.Parties = Party_System.Parties or {}
local cfg = Party_System.Config

-- Config Values -> General
cfg.Enabled = true -- Disable or enable the addon. (default = true)
cfg.Gamemode = "whatever" -- Gamemode for which your server is running (gamemode integrations are darkrp)
cfg.Command = "!p" -- Command for the party system. (default = "!p")
cfg.Chat_Prefix = "[Party]" -- Prefix for chat messages. (default = "[Party]") -> You can change it to "" if you want it to be no prefix
cfg.Message_Nick_Color = Color( 0, 137, 216 ) -- Color of the player's name in the chat messages (default = Color( 0, 137, 216 ))
cfg.Max_Players = 6 -- How many players can be in a single party? (default = 6)
cfg.Invite_Cooldown = 60 -- Seconds before another invite can be sent to the same player. (default = 60)
cfg.Join_Request_Cooldown = 60 -- Seconds before another join request can be sent from the player. (default = 60)
cfg.Party_Damage = true -- Can people in the same party damage each other? (default = true)
cfg.Show_Outline = true -- Do players have an outline around them? (default = true)
cfg.Max_Party_Character_Limit = 16 -- How many characters can a party's name have? (default = 16)
cfg.Parties_Auto_Locked = true -- Should parties be automatically locked? That means the player will have to get an invite. (default = true)
cfg.Party_Creator_Invite_Only = true -- Should the party leader be the only one to invite? (default = true)
cfg.Outlined_Through_Walls = false -- Should the player outline draw through walls? (default = false)
cfg.No_Party_Damage = false -- Should party members be able to damage each other? (thjs will override Reduce_Party_Damage if set to true) (default = false)
cfg.Reduce_Party_Damage = false -- Should party members take less damage from each other? (default = false)
cfg.Reduce_Party_Damage_Amount = 0.5 -- How much should the damage be reduced? ** number has to be 0 - 1 ** this is a percentage of the damage. So 0.5 == dmg / 2 (default = 0.5)

-- ** Don't edit anything below here. **
if Party_System.Config.Enabled then

	local cl_includes = file.Find( "party_system/client/*.lua", "LUA" )
	local sh_includes = file.Find( "party_system/shared/*.lua", "LUA" )
	local sv_includes = file.Find( "party_system/server/*.lua", "LUA" )

	for _, file in ipairs( sh_includes ) do

		local _file = "party_system/shared/" .. file

		if ( SERVER ) then

			AddCSLuaFile( _file )
			include( _file )
			print( "Party System: Loaded File (shared): " .. _file )

		else

			include( _file )

		end

	end
-- I see you down here, get out
	for _, file in ipairs( sv_includes	) do

		local _file = "party_system/server/" .. file

		if ( SERVER ) then

			include( _file )
			print( "Party System: Loaded File (server): " .. _file )

		end

	end
-- Looking further down? Stop
	for _, file in ipairs( cl_includes ) do

		local _file = "party_system/client/" .. file

		if ( SERVER ) then

			AddCSLuaFile( _file )
			print( "Party System: Loaded File (client): " .. _file )

		else

			include( _file )

		end

	end

else

	print( "** Party System is disabled! Make sure to check your config if this is a mistake! **" )

end