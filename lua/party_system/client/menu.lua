surface.CreateFont( "Party_System_Main", {

	font = "Roboto",
	extended = false,
	size = 16,
	weight = 500,
	outline = false,

} )

surface.CreateFont( "Party_System_Buttons", {

	font = "Roboto",
	extended = false,
	size = 16,
	weight = 500,
	outline = false,

} )

surface.CreateFont( "Party_System_PartyMenu", {

	font = "Roboto",
	extended = false,
	size = 22,
	weight = 500,
	outline = false,

} )

surface.CreateFont( "Party_System_PartyButton_Small", {

	font = "Roboto",
	extended = false,
	size = 16,
	weight = 500,
	outline = false,

} )


concommand.Add( "partysystem_menu", function()

	Party_System:CreateClientMenu()

end )

function Party_System:CreateClientMenu()

	local __partyinfo = vgui.Create( "DFrame" )
	__partyinfo:SetSize( 450, 500 )
	__partyinfo:SetPos( ( ScrW() / 2 ) + 10, ( ScrH() / 2 ) - ( __partyinfo:GetTall() / 2 ) )
	__partyinfo:SetTitle( "" )
	__partyinfo:SetDraggable( false )
	__partyinfo:ShowCloseButton( false )
	__partyinfo:SetVisible( false )

	function __partyinfo:Paint( w, h )

		draw.RoundedBox( 4, 0, 0, w, h, Color( 45, 45, 45, 255 ) )
		draw.RoundedBox( 4, 0, 0, w, 50, Color( 30, 30, 30, 255 ) )
		draw.RoundedBox( 4, 0, h - 50, w, 50, Color( 30, 30, 30, 255 ) )

	end

	local _main = vgui.Create( "DFrame" )
	_main:SetSize( 450, 500 )
	_main:SetPos( ( ScrW() / 2 ) - ( _main:GetWide() / 2 ), ScrH() )
	_main:SetTitle( "" )
	_main:SetDraggable( false )
	_main:ShowCloseButton( false )
	_main:SetAlpha( 0 )
	_main:AlphaTo( 255, 0.4 )
	_main:MoveTo( ( ScrW() / 2 ) - ( _main:GetWide() / 2 ), ( ScrH() / 2 ) - ( _main:GetTall() / 2 ), 0.4 )
	_main:MakePopup()

	function _main:Paint( w, h )

		draw.RoundedBox( 4, 0, 0, w, h, Color( 45, 45, 45, 255 ) )
		draw.RoundedBox( 4, 0, 0, w, 50, Color( 30, 30, 30, 255 ) )
		draw.RoundedBox( 4, 0, h - 50, w, 50, Color( 30, 30, 30, 255 ) )
		draw.SimpleTextOutlined( "Party System - Created by Matsumoto", "Party_System_Main", w / 2, 15, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )

	end

	local _closebutton = vgui.Create( "DButton", _main )
	_closebutton:SetPos( _main:GetWide() - 30 - 10, 15 )
	_closebutton:SetText( "X" )
	_closebutton:SetSize( 30, 20 )
	_closebutton:SetTextColor( Color( 255, 255, 255 ) )

	function _closebutton:Paint( w, h )

		draw.RoundedBox( 3, 0, 0, w, h, Color( 110, 8, 8, ( self:IsHovered() || self:IsChildHovered() ) && 180 || 255 ) )

	end

	function _closebutton:DoClick()

		if __partyinfo && __partyinfo:IsVisible() then

			_main:MoveTo( -_main:GetWide(), ( ScrH() / 2 ) - ( _main:GetTall() / 2 ), 0.4 )
			_main:AlphaTo( 0, 0.4 )
			__partyinfo:MoveTo( ScrW(), ( ScrH() / 2 ) - ( _main:GetTall() / 2 ), 0.4 )
			__partyinfo:AlphaTo( 0, 0.4 )

			timer.Simple( 0.4, function()

				_main:Close()
				__partyinfo:Close()

			end )

		else

			_main:MoveTo( ( ScrW() / 2 ) - ( _main:GetWide() / 2 ), ScrH(), 0.4 )
			_main:Close()

		end

	end

	local _partymenu = vgui.Create( "DButton", _main )
	_partymenu:SetPos( ( _main:GetWide() / 2 ) - 75, _main:GetTall() - 25 - 12 )
	_partymenu:SetText( "" )
	_partymenu:SetSize( 150, 25 )

	function _partymenu:Paint( w, h )

		draw.RoundedBox( 3, 0, 0, w, h, Color( 72, 110, 0, ( self:IsHovered() || self:IsChildHovered() ) && 180 || 255 ) )
		draw.SimpleTextOutlined( "Create Party", "Party_System_PartyMenu", w / 2, h / 2, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )

	end

	function __partyinfo:OnClose()

		_main:MoveTo( ScrW(), ( ScrH() / 2 ) - ( __partyinfo:GetTall() / 2 ), 0.4 )

	end

	local cache = {}
	local page = 1
	local selected

	for i = 1, #Party_System.Parties do

		local _partybuttons_i = vgui.Create( "DButton", _main )
		_partybuttons_i:SetPos( 10, 60 + ( 55 * ( i - 1 ) ) )
		_partybuttons_i:SetText( "" )
		_partybuttons_i:SetSize( _main:GetWide() - 20, 45 )
		_partybuttons_i:SetTextColor( Color( 255, 255, 255 ) )

		function _partybuttons_i:Paint( w, h )

			draw.RoundedBox( 3, 0, 0, w, h, Color( 32, 136, 228, ( self:IsHovered() || self:IsChildHovered() ) && 180 || 255 ) )
			draw.SimpleTextOutlined( Party_System.Parties[ i ].title, "Party_System_PartyMenu", 10, h / 2, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255 ) )
			draw.SimpleTextOutlined( Party_System.Parties[ i ].owner:Nick(), "Party_System_PartyButton_Small", w - 10, 5, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
			draw.SimpleTextOutlined( ( #Party_System.Parties[ i ].members + 1 ) .. "/" .. Party_System.Config.Max_Players, "Party_System_PartyButton_Small", w - 10, 25, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )

		end

		function _partybuttons_i:DoClick()

			selected = self

			_main:MoveTo( ( ScrW() / 2 ) - _main:GetWide() - 10, ( ScrH() / 2 ) - ( _main:GetTall() / 2 ), 0.4 )

			__partyinfo:SetVisible( true )
			__partyinfo:SetAlpha( 0 )
			__partyinfo:AlphaTo( 255, 0.4 )
			__partyinfo:MakePopup()


		end

	end

end