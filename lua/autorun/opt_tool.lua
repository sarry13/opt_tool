hook.Remove("PlayerTick", "TickWidgets")
hook.Remove("Think", "CheckSchedules")
hook.Remove("LoadGModSave", "LoadGModSave")
timer.Destroy("HostnameThink")

hook.Add("PostGamemodeLoaded", "optimizee", function()

	function GAMEMODE:MouthMoveAnimation() return end
	function GAMEMODE:GrabEarAnimation() return end

end)

local ent = FindMetaTable("Entity")
local modelScale = ent.SetModelScale
function ent:SetModelScale(s, dt)
	if s > 10 or s < -10 then
		s = 1
	end
	return modelScale(self, s, dt)
end
