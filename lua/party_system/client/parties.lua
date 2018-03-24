CreateClientConVar( "party_system_prefferedcolor", "0 180 255", true, false )

hook.Add( "PreDrawHalos", "Party_System_DrawHalos", function()

	if Party_System && Party_System.Parties && Party_System.Config.Show_Outline && LocalPlayer():InParty() && #Party_System.Parties[ LocalPlayer():GetPartyID() ].members >= 1 then


		local halotable = {}

		for k, v in pairs( Party_System.Parties[ LocalPlayer():GetPartyID() ].members ) do

			if v == LocalPlayer() then continue end

			table.insert( halotable, v )

		end

		if LocalPlayer() != Party_System.Parties[ LocalPlayer():GetPartyID() ].owner then

			table.insert( halotable, Party_System.Parties[ LocalPlayer():GetPartyID() ].owner )

		end

		if #halotable >= 1 then

			halo.Add( halotable, Vector( GetConVar( "party_system_prefferedcolor" ):GetString() ):ToColor() or Color( 0, 180, 255, 255), 0, 0, 2, true, Party_System.Config.Outlined_Through_Walls )

		end

	end

end )