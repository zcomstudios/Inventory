//
/*

	Client main script
	
	Nautical & Anarchy
	
	5/8/2015
*/

if (SERVER) then return end

local set = {
	pad = 5,
	boxX = 50,
	boxY = 50,
	boxesW = 10,
	boxesT = 5
}

local inventory = {}
local function ReceiveInv()
	inventory = net.ReadTable()
end
net.Receive("SendInv", ReceiveInv)

local function Main()
	local frame = vgui.Create("DFrame")
	frame:SetSize(set.boxX*set.boxesW + set.pad*set.boxesW+set.pad, set.boxY*set.boxesT + set.pad*set.boxesW+set.pad)
	frame:Center()
	frame:SetTitle("Inv")
	frame:SetDraggable(false)
	frame:MakePopup()
	
	local iconLayout = vgui.Create("DIconLayout", frame)
	iconLayout:SetSize(frame:GetWide()-10, frame:GetTall()-35)
	iconLayout:SetPos(5,30)
	iconLayout:SetSpaceY(5)
	iconLayout:SetSpaceX(5)
	iconLayout.Paint = function( self )
		draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(55,55,55,0))
	end
	
	for k,v in pairs(inventory) do
		for l,m in pairs(v) do
			local slot = vgui.Create("DPanel", iconLayout)
			slot:SetSize(50, 50)
			slot:SetBackgroundColor(Color(0, 0, 0, 130))

			if m.class ~= nil then // if there's a class
				local item = vgui.Create("DModelPanel", slot)
				item:SetSize(50, 50)
				item:SetModel(m.model)
				item:SetCamPos(Vector(6, 6, 6))
				item:SetLookAt(Vector(0, 0, 0))
				item:SetTooltip(m.class)
				
				function item:OnMousePressed(but)
					if but == MOUSE_LEFT || MOUSE_RIGHT then
						
						local menu = vgui.Create("DMenu")
						menu:Open()
						
						// EQUIP WEAPON
						menu:AddOption("Equip", function() 
							net.Start("EquipWeapon")
								net.WriteInt(l, 32)
								net.WriteInt(k, 32)
								net.WriteEntity(LocalPlayer())
								net.WriteTable(m)
							net.SendToServer()
						end):SetIcon("icon16/add.png")
						
						
					end
				
				end
				
				
				
			end
			
		end
	end

end
usermessage.Hook("InvMenu", Main)