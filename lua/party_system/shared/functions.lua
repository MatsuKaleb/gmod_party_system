function Party_System:FindPlayer( search )

	search = string.lower( search )

	for _, ply in pairs( player.GetAll() ) do

		if tonumber( search ) then

			if ply:UserID() == tonumber( search ) then

				return ply

			end

			continue

		end

		if ply:SteamID() == string.upper( search ) then

			return ply

		end

		if string.find( string.lower( ply:Nick() ), search ) then

			return ply

		end

	end

	return NULL

end

function Party_System:IsPartyName( party_name )

	for k, v in pairs( Party_System.Parties ) do

		if string.find( Party_System.Parties[ k ].title, party_name ) then return true end

	end

	return false

end


function Party_System:GetPartyID( party_name )

	for k, v in pairs( Party_System.Parties ) do

		if string.find( Party_System.Parties[ k ].title, party_name ) then return k end

	end

	return 0

end

function Party_System:GetPartyTitle( partyid )

	return Party_System.Parties[ partyid ].title or ""

end

function Party_System:IsProtected( partyid )

	return Party_System.Parties[ partyid ].protected or true

end

function Party_System:PlayerInParty( player, partyid )

	for k, v in pairs( Party_System.Parties.members ) do

		if v == player then return true end

	end

	return false

end

local _player = FindMetaTable( "Player" )
-- Party Helpers
function _player:GetPartyID()

	for k, v in pairs( Party_System.Parties ) do

		if v.owner == self then return k end

		for k2, v2 in pairs( v.members ) do

			if v2 == self then return k end

		end

	end

end

function _player:InParty()

	for k, v in pairs( Party_System.Parties ) do

		if v.owner == self then return true end

		for k2, v2 in pairs( v.members ) do

			if v2 == self then return true end

		end

	end

	return false

end

function _player:IsInParty( partyid )

	for k, v in pairs( Party_System.Parties[ partyid ].members ) do

		if v == self then return true end

	end

	if Party_System.Parties[ partyid ].owner == self then

		return true

	end

	return false

end

function _player:IsPartyOwner( partyid )

	return ( Party_System.Parties[ self:GetPartyID() ].owner == self ) or false

end

function _player:GetPartyTitle()

	return Party_System.Parties[ self:GetPartyID() ].title or ""

end

function _player:IsInvited( partyid )

	return table.HasValue( Party_System.Parties[ partyid ].invited, self ) or false

end