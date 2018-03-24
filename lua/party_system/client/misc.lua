net.Receive( "Party_System_SendMessage", function()

	local _args = net.ReadTable()

	if #Party_System.Config.Chat_Prefix >= 1 then

		chat.AddText( Color( 255, 175, 14), Party_System.Config.Chat_Prefix .. " ", Color( 255, 255, 255 ), unpack( unpack(_args) ) )

	else

		chat.AddText( Color( 255, 255, 255 ), unpack( unpack(_args) ) )

	end

end )

net.Receive( "Party_System_SendPartiesToClient", function()

	local _parties = net.ReadTable()

	Party_System.Parties = _parties

end )