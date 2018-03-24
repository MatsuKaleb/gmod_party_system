hook.Add( "PlayerSay", "Party_System_ChatCommand", function( _ply, _text )

	if string.lower( string.sub( _text, 1, #Party_System.Config.Command ) ) == Party_System.Config.Command then

		local text_explode = string.Explode( " ", _text )

		if !text_explode[ 2 ] then

			_ply:ConCommand( "partysystem_menu" )

			return  ""

		end

		local callback = string.lower( text_explode[ 2 ] )

		if callback == "create" then

			if !text_explode[ 3 ] then

				 _ply:SendMessage( { "You did not enter a valid party name" } )

				return ""

			end

			local _name = ""

			for i = 3, #text_explode do

				if i == 3 then

					_name = text_explode[ i ]

				else

					_name = _name .. " " .. text_explode[ i ]

				end

			end

			if #_name > Party_System.Config.Max_Party_Character_Limit then

				_ply:SendMessage( { "You can not have a party name greater than " .. tostring( Party_System.Config.Max_Party_Character_Limit ) } )

				return ""

			end

			Party_System:CreateParty( _ply, _name )

		elseif callback == "leave" then

			Party_System:Leave( _ply )

		elseif callback == "kick" then

			if !text_explode[ 3 ] then

				 _ply:SendMessage( { "You did not enter a valid player name" } )

				return ""

			end

			local _target = ""

			for i = 3, #text_explode do

				if i == 3 then

					_target = text_explode[ i ]

				else

					_target = _target .. " " .. text_explode[ i ]

				end

			end

			Party_System:Kick( _ply, _target )

		elseif callback == "invite" then

			if !text_explode[ 3 ] then

				 _ply:SendMessage( { "You did not enter a valid player name" } )

				return ""

			end

			local _target = ""

			for i = 3, #text_explode do

				if i == 3 then

					_target = text_explode[ i ]

				else

					_target = _target .. " " .. text_explode[ i ]

				end

			end

			Party_System:Invite( _ply, _target )

		elseif callback == "deleteinvite" then

			if !text_explode[ 3 ] then

				 _ply:SendMessage( { "You did not enter a valid player name" } )

				return ""

			end

			local _target = ""

			for i = 3, #text_explode do

				if i == 3 then

					_target = text_explode[ i ]

				else

					_target = _target .. " " .. text_explode[ i ]

				end

			end

			Party_System:DeleteInvite( _ply, _target )

		elseif callback == "request" then

			local _partyname = ""

			for i = 3, #text_explode do

				if i == 3 then

					_partyname = text_explode[ i ]

				else

					_partyname = _partyname .. " " .. text_explode[ i ]

				end

			end

			Party_System:Request( _ply, _partyname )

		elseif callback == "join" then

			if !text_explode[ 3 ] then

				 _ply:SendMessage( { "You did not enter a valid party name" } )

				return ""

			end

			local _partyname = ""

			for i = 3, #text_explode do

				if i == 3 then

					_partyname = text_explode[ i ]

				else

					_partyname = _partyname .. " " .. text_explode[ i ]

				end

			end

			Party_System:Join( _ply, _partyname )

		elseif callback == "disband" then

			Party_System:Disband( _ply )

		end

		return ""

	end

end )

function Party_System:CreateParty( _ply, _name )

	if Party_System:IsDarkRP() && table.HasValue( Party_System.Config.Blacklisted_Jobs, _ply:Team() ) then

		_ply:SendMessage( { "Your class is not allowed to create a party!" } )

		return

	end

	if _ply:InParty() then

		_ply:SendMessage( { "You are already in a party!" } )

		return

	end

	for k, v in pairs( Party_System.Parties ) do

		if Party_System.Parties[ k ].title == _name then

			_ply:SendMessage( { "There is already a party with this name!" } )

		end

	end

	local id = #Party_System.Parties + 1

	Party_System.Parties[ id ] = {}
	Party_System.Parties[ id ].owner = _ply
	Party_System.Parties[ id ].title = _name
	Party_System.Parties[ id ].protected = Party_System.Config.Parties_Auto_Locked
	Party_System.Parties[ id ].members = {}
	Party_System.Parties[ id ].invited = {}

	Party_System:SendMessageAll( { Color( 72, 176, 236 ), _ply:Nick(), Color( 255, 255, 255 ), " ", "created party ", Color( 202, 152, 15 ), _name } )
	Party_System:SendPartiesToClient( Party_System.Parties )

end

function Party_System:Disband( _ply )

	if !_ply:InParty() then

		_ply:SendMessage( { "You are not in a party!" } )

		return

	end

	if !_ply:IsPartyOwner( _ply:GetPartyID() ) then

		_ply:SendMessage( { "You are not the leader of the party!" } )

		return

	end

	local partyname = _ply:GetPartyTitle()

	table.remove( Party_System.Parties, _ply:GetPartyID() )

	Party_System:SendMessageAll( { Color( 72, 176, 236 ), _ply:Nick(), Color( 255, 255, 255 ), " ", "disbanded party ", Color( 135, 0, 15 ), partyname } )
	Party_System:SendPartiesToClient( Party_System.Parties )

end

function Party_System:Leave( _ply )

	if !_ply:InParty() then

		_ply:SendMessage( { "You are not in a party!" } )

		return

	end

	if _ply:IsPartyOwner( _ply:GetPartyID() ) then

		_ply:SendMessage( { "You are the leader of this party! You have to use disband!" } )

		return

	end

	for k, v in pairs( Party_System.Parties[ _ply:GetPartyID() ].members ) do

		if v == _ply then

			v = nil

		end

	end

	Party_System:SendMessageAll( { Color( 72, 176, 236 ), _ply:Nick(), Color( 255, 255, 255 ), " ", "disbanded party ", Color( 135, 0, 15 ), partyname } )
	Party_System:SendPartiesToClient( Party_System.Parties )

end

function Party_System:Invite( _ply, _target )

	if !_ply:InParty() then

		_ply:SendMessage( { "You are not in a party!" } )

		return

	end

	if Party_System.Config.Party_Creator_Invite_Only && !_ply:IsPartyOwner( _ply:GetPartyID() ) then

		_ply:SendMessage( { "You not the leader of this party!" } )

		return

	end

	local _target = Party_System:FindPlayer( _target )

	if !IsValid( _target ) then

		_ply:SendMessage( { "You did not enter a valid player!" } )

		return

	end

	if _ply == _target then

		_ply:SendMessage( { "You can't invite yourself!" } )

		return

	end

	if _target:IsInvited( _ply:GetPartyID() ) then

		_ply:SendMessage( { "Player is already invited to the party!" } )

		return

	end

	table.insert( Party_System.Parties[ _ply:GetPartyID() ].invited, _target )
	Party_System:MessageParty( _ply:GetPartyID(), { Color( 72, 176, 236 ), _ply:Nick(), Color( 255, 255, 255 ), " ", "invited ", Color( 202, 152, 15 ), _target:Nick(), Color( 255, 255, 255 ), " to the party!" } )
	Party_System:SendPartiesToClient( Party_System.Parties )

end

function Party_System:Join( _ply, _partyname )

	if !Party_System:IsPartyName( _partyname ) then

		_ply:SendMessage( { "There is not a valid party with that name!" } )

		return

	end

	if !_ply:IsInvited( Party_System:GetPartyID( _partyname ) ) && Party_System:IsProtected( Party_System:GetPartyID( _partyname ) ) then

		_ply:SendMessage( { "You are not invited to the party! You have to use request to request an invite" } )

		return

	end


	if _ply:InParty() then

		Party_System:Leave( _ply )

	end

	table.insert( Party_System.Parties[ Party_System:GetPartyID( _partyname ) ].members, _ply )

	for k, v in pairs( Party_System.Parties[ Party_System:GetPartyID( _partyname ) ].invited ) do

		if v == _ply then v = nil end

	end

	Party_System:MessageParty( Party_System:GetPartyID( _partyname ), { Color( 72, 176, 236 ), _ply:Nick(), Color( 255, 255, 255 ), " ", "joined the party!" } )
	Party_System:SendPartiesToClient( Party_System.Parties )

end

function Party_System:Kick( _ply, _target )

	if !_ply:InParty() then

		_ply:SendMessage( { "You are not in a party!" } )

		return

	end

	if !_ply:IsPartyOwner( _ply:GetPartyID() ) then

		_ply:SendMessage( { "You not the leader of this party!" } )

		return

	end

	local _target = Party_System:FindPlayer( _target )

	if !IsValid( _target ) then

		_ply:SendMessage( { "You did not enter a valid player!" } )

		return

	end

	if _ply == _target then

		_ply:SendMessage( { "You can't kick yourself!" } )

		return

	end

	if !target:PlayerInParty( player, _ply:GetPartyID() ) then

		_ply:SendMessage( { "Player is not in your party!" } )

		return

	end

	for k, v in pairs( Party_System.Parties[ _ply:GetPartyID() ].members ) do

		if v == _ply then v = nil end

	end

	Party_System:MessageParty( _ply:GetPartyID(), { Color( 72, 176, 236 ), _ply:Nick(), Color( 255, 255, 255 ), " ", "kicked ", Color( 202, 152, 15 ), _target:Nick(), Color( 255, 255, 255 ), " from the party!" } )
	Party_System:SendPartiesToClient( Party_System.Parties )

end

function Party_System:DeleteInvite( _ply, _target )

	if !_ply:InParty() then

		_ply:SendMessage( { "You are not in a party!" } )

		return

	end

	if !_ply:IsPartyOwner( _ply:GetPartyID() ) then

		_ply:SendMessage( { "You not the leader of this party!" } )

		return

	end

	local _target = Party_System:FindPlayer( _target )

	if !IsValid( _target ) then

		_ply:SendMessage( { "You did not enter a valid player!" } )

		return

	end

	if !_target:IsInvited( _ply:GetPartyID() ) then

		_ply:SendMessage( { "Player is not invited to the party!" } )

		return

	end

	for k, v in pairs( Party_System.Parties[ _ply:GetPartyID() ].invited ) do

		if v == _ply then v = nil end

	end

	Party_System:MessageParty( _ply:GetPartyID(), { Color( 72, 176, 236 ), _ply:Nick(), Color( 255, 255, 255 ), " ", "revoked the party invite from ", Color( 202, 152, 15 ), _target:Nick(), Color( 255, 255, 255 ), "!" } )
	Party_System:SendPartiesToClient( Party_System.Parties )

end

function Party_System:Request( _ply, _partyname )

	if _ply:InParty() then

		_ply:SendMessage( { "You are in a party!" } )

		return

	end

	if !Party_System:IsPartyName( _partyname ) then

		_ply:SendMessage( { "There is not a valid party with that name!" } )

		return

	end

	if _ply:IsInvited( Party_System:GetPartyID( _partyname ) ) && Party_System:IsProtected( Party_System:GetPartyID( _partyname ) ) then

		_ply:SendMessage( { "You are already invited to the party" } )

		return

	end

	Party_System:MessageParty( _ply:GetPartyID(), { Color( 72, 176, 236 ), _ply:Nick(), Color( 255, 255, 255 ), " ", "requests to join the party!" } )
	Party_System:SendPartiesToClient( Party_System.Parties )

end