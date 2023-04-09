include("shared.lua")

function ENT:Draw()
    self:DrawModel()
end

net.Receive("Armoire", function(len,ply)
        local ent = net.ReadEntity()

        local Armoire = vgui.Create("DFrame")
        Armoire:SetSize(600, 325)
        Armoire:Center()
        Armoire:SetTitle(title_menu)
        Armoire:SetDraggable(false)
        Armoire:ShowCloseButton(false)
        Armoire:MakePopup()

        Armoire.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, -300, w, h, Color(255, 183, 48))
            draw.RoundedBox(0, 0, 25, w, h, Color(210, 212, 214))
        end

        local CloseButton = vgui.Create( "DImageButton", Armoire )
        CloseButton:SetPos(578, 5)
        CloseButton:SetSize(16, 16)
        CloseButton:SetImage("icon16/cancel.png")
        CloseButton.DoClick = function()
        Armoire:Close()
        end

        local Scroll = vgui.Create( "DScrollPanel", Armoire )
        Scroll:Dock(FILL)

        local sbar = Scroll:GetVBar()
        function sbar:Paint(w, h)
            draw.RoundedBox(6, 0, 0, w, h, Color(255, 166, 0))
        end
        function sbar.btnUp:Paint(w, h)
            draw.RoundedBoxEx(5, 0, 0, w, h, Color(255, 183, 48), true, true, false, false)
        end
        function sbar.btnDown:Paint(w, h)
            draw.RoundedBoxEx(5, 0, 0, w, h, Color(255, 183, 48), false, false, true, true)
        end
        function sbar.btnGrip:Paint(w, h)
            draw.RoundedBoxEx(5, 0, 0, w, h, Color(255, 183, 48), false, false, false, false)
        end

        local List = vgui.Create( "DIconLayout", Scroll )
        List:Dock(FILL)
        List:SetSpaceY(5)
        List:SetSpaceX(5)

        for k, v in pairs(wardrobe) do
            local ListItem = List:Add("DModelPanel")
            ListItem:SetSize(140, 130)
            ListItem:SetModel(v)

            local ListButton = vgui.Create( "DButton", ListItem )
            ListButton:SetSize(80, 20)
            ListButton:SetPos(30, 109)
            ListButton:SetText(choose_text)
            ListButton:SetTextColor(Color(0, 0, 0))

            ListButton.Paint = function(self, w, h)
            draw.RoundedBox(8, 0, 0, w, h, Color(255, 183, 48))
            end

            ListButton.DoClick = function()
                net.Start("Armoire")
                net.WriteEntity(ent)
                net.WriteString(v)
                net.SendToServer()
                Armoire:Close()
            end
        end
end)
