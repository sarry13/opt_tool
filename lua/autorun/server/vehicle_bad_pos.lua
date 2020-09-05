--[[ берите это если у вас на сервере есть simfphys и не хотите чтобы им крашали за считанные секунды ]]--
if not simfphys then return end
local stackingOffset = Vector(0, 0, -5)
local function CheckSpawnedObject(ply, ent)
	local trace = 
	{ 
		start = ent:GetPos() + stackingOffset, 
		endpos = ent:GetPos() + stackingOffset, 
		filter = ent,
	}
	local tr = util.TraceEntity( trace, ent )
	if (tr.Hit == true and IsValid(tr.Entity)) then 
		local t = math.abs(tr.Entity:GetCreationTime() - ent:GetCreationTime())
		if t == 0 then 
			return false 
		end 
	end 
	return tr.Hit
end
hook.Add("PlayerSpawnedVehicle", "stacking_vehicle", function(ply, ent)
if (ply.limitcars == nil or ply.limitcars < 0) then
ply.limitcars = 0 end
if (simfphys.IsCar(ent) or ent:GetModel() == "models/buggy.mdl" or ent:GetModel() == "models/airboat.mdl") then
ply.limitcars = ply.limitcars + 1
ent:SetPos(ent:GetPos() + Vector(0,0,30))
	timer.Simple(0, function()
		if not IsValid(ent) then
			return
		end
		timer.Simple(10, function()
			if IsValid(ply) then
			ply.limitcars = ply.limitcars - 1
			end
		end)
		if ply.limitcars >= 3 then
			ent:Remove()
			ply.limitcars = 3
			ply:SendLua('notification.AddLegacy( "Не-а! Подожди немного.", NOTIFY_ERROR, 4 ) surface.PlaySound( "buttons/button10.wav" )')
		return end
		if CheckSpawnedObject(ply, ent) == true then
			ent:Remove()
			ply:SendLua('notification.AddLegacy( "Плохая позиция для спавна.", NOTIFY_ERROR, 3 ) surface.PlaySound( "buttons/button10.wav" )')
		end
	end)
end end)
