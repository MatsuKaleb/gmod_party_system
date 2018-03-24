if ( SERVER ) then

	AddCSLuaFile( "config.lua" )
	include( "config.lua" )
		--print( "Party System: Loaded Config" )

else

	include( "config.lua" )

end