AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString( "Armoire" )

function ENT:Initialize()
    self:SetModel("models/wardrobe/gents_display.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:Use(caller, activator)
    net.Start("Armoire")
    net.WriteEntity(self)
    net.Send(caller)
end

net.Receive("Armoire", function (len,ply) 
    if IsValid(ply) then
        local ent = net.ReadEntity()
        local pos = ply:GetPos()
        if not IsValid(ent) then return end
        if ent:GetPos():Distance(pos) > 100 then return end
        local model = net.ReadString()
        if not table.HasValue( wardrobe, model ) then return end
        ply:SetModel( model )
        ply:ChatPrint(success_change)
    end
end)
