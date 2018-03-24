-- Networking

util.AddNetworkString( "Party_System_SendMessage" )
util.AddNetworkString( "Party_System_SendPartiesToClient" )

function table.pack( ... ) -- https://github.com/stevedonovan/Penlight/blob/master/lua/pl/compat.lua#L134

    return { n = select('#',...); ... }

end

function Party_System:SendMessageAll( msg )

	net.Start( "Party_System_SendMessage" )
	net.WriteTable( table.pack( msg ) )

	for _, ply in pairs( player.GetAll() ) do

		net.Send( ply )

	end

end

function Party_System:SendMessageAllButOne( _ply, msg )

	net.Start( "Party_System_SendMessage" )
	net.WriteTable( table.pack( msg ) )

	for _, ply in pairs( player.GetAll() ) do

		if ply == _ply then continue end

		net.Send( ply )

	end

end

function Party_System:MessageParty( teamid, msg )

	net.Start( "Party_System_SendMessage" )
	net.WriteTable( table.pack( msg ) )

	local players = {}

	for k, v in pairs( Party_System.Parties ) do

		if k == teamid then

			table.insert( players, v.owner )

			for k, v in pairs( v.members ) do

				table.insert( players, v )

			end

		end

	end

	for i = 1, #players do

		net.Send( players[ i ] )

	end

end

function Party_System:SendPartiesToClient( table )

	net.Start( "Party_System_SendPartiesToClient" )
	net.WriteTable( table )

	for _, ply in pairs( player.GetAll() ) do

		if !IsValid( ply ) then continue end

		net.Send( ply )

	end

end

local _player = FindMetaTable( "Player" )

function _player:SendMessage( msg )

	net.Start( "Party_System_SendMessage" )
	net.WriteTable( table.pack( msg ) )
	net.Send( self )

end

hook.Add( "EntityTakeDamage", "Party_System_TakeDamage", function( ent, dmginfo )

	local attacker = dmginfo:GetAttacker()

	if IsValid( ent ) && IsValid( attacker ) && ent:InParty() && attacker:InParty() && attacker:IsInParty( ent:GetPartyID() ) then

		if Party_System.Config.Reduce_Party_Damage && !Party_System.Config.No_Party_Damage then

			dmginfo:ScaleDamage( Party_System.Config.Reduce_Party_Damage_Amount )

		elseif Party_System.Config.No_Party_Damage then

			dmginfo:ScaleDamage( 0 )

		end

	end

end )

hook.Add( "PlayerDisconnected", "Party_System_TakeDamage", function( ply )

	local _ply = ply

	if _ply:InParty() && _ply:IsPartyOwner( _ply:GetPartyID() ) then

		local partyid = _ply:GetPartyID()

		Party_System.Parties[ partyid ] = nil
		Party_System:SendPartiesToClient( Party_System.Parties )

	elseif _ply:InParty() then

		local partyid = _ply:GetPartyID()

		for k, v in pairs( Party_System.Parties[ partyid ].members ) do

			if v == _ply then v = nil end

		end

		Party_System:SendPartiesToClient( Party_System.Parties )

	end

end )