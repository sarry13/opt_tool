Msg("[NT] ")print("Loaded.")
local ipairs = ipairs
local ents = ents
local timer = timer
local IsValid = IsValid
local lastSysCurrDiff = 9999
local function GetCurrentDelta()
	local SysCurrDiff = SysTime() - CurTime()
	deltaSysCurrDiff = SysCurrDiff - lastSysCurrDiff 
	lastSysCurrDiff = SysCurrDiff
	return deltaSysCurrDiff
end

hook.Add("OnCrazyPhysics", "check_who", function(ent, physobj)
    local owner = ent:CPPIGetOwner()
	if not IsValid(owner) then return end
	local nick = owner:Nick()
    print( "Crazy origins: " .. nick)
end)
local realtime = RealTime()
timer.Create("check_penetrating", 0.01, 0, function()
    if GetCurrentDelta() > 0.06 then
		local i = 0
		local tabl = {}
		local count = {}
		for _, ent in ipairs(ents.GetAll()) do
			local owner = ent:CPPIGetOwner()
			local phys = ent:GetPhysicsObject()
			if (IsValid(ent)) and (IsValid(phys)) then
				if phys:IsPenetrating() then
					i = i + 1
					if i > 4 then
					phys:EnableMotion(false)
					ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
					if (owner) then
						count[owner] = (count[owner] or 0) + 1
						Msg("[NT] ")print("Фризим проп: " .. ent:GetModel() .. " | ".. owner:Name())
					end
					end
				end
			end
		end
		if i >= 12 then
			if realtime > RealTime() then return end
			realtime = RealTime() + 2
			for k, v in pairs(count) do table.ForceInsert(tabl, {ply = k, count = v}) end
			table.sort(tabl, function(a, b) return a.count > b.count end)
			PrintMessage(HUD_PRINTTALK, "[NT] " .. tabl[1].ply:Nick()  .. " имеет " .. tabl[1].count .. " проникающих пропов.")
			--Discord.Backend.API:Send(Discord.OOP:New('Message'):SetChannel('Relay'):SetMessage(tabl[1].ply:Nick() .. " имеет " .. tabl[1].count .. " проникающих пропов."):ToAPI())
		end
    end
end)

hook.Add("PlayerSpawnedProp", "anticrasher_mb", function(ply, model, ent)
    if IsValid(ent) then
        local phys = ent:GetPhysicsObject()
        if (IsValid(phys)) then
			phys:EnableMotion(false)
        end
    end
end)

hook.Add("CanTool", "asdasd", function(ply, tr)
	timer.Simple(0, function()
		if IsValid(tr.Entity) and not tr.Entity:IsPlayer() then
			local ent = tr.Entity
			if not IsValid(ent) then return end
			if not ent.isFadingDoor then return end
			local state = ent.fadeActive
			if state then
				ent:fadeDeactivate()
			end
		end
	end)
end)

hook.Add("EntityTakeDamage","propdmg", function( target, dmg )
	if (dmg:GetDamageType() == DMG_CRUSH or dmg:GetDamageType() == DMG_VEHICLE) then
		dmg:SetDamage(0)
		return true 
	end
	local atk, ent = dmg:GetAttacker(), dmg:GetInflictor()
	if Entity(0) == ent or ent:IsWorld() then return false end
	if ent and not ent.GetClass then return false end 
	if not IsValid(ent) then return false end
	if ent.jailWall == true then return false end
	if ent:IsWeapon() then return false end
	if ent:IsPlayer() then return false end
	if ent:IsNPC() then return false end
	if simfphys.IsCar(ent) then return false end
	if (ent:GetClass() == "prop_physics") then return false end
	if (ent:GetClass() == "entityflame") then dmg:SetDamage(0) return true end
end)

local timer = timer

local function wait(callback)
    timer.Simple(FrameTime(), function()
        callback()
    end)
end

local i
timer.Create("e2_falling_cpu", 5, 0, function()
	i = 0
	for _, v in ipairs(ents.FindByClass("gmod_wire_expression2")) do
		local data = v:GetOverlayData()
		local timebench = data.timebench
		i = i + timebench*1000000
		if i > 6000 then v:Remove() Msg("[E2] ") print("Нагрузка всех CPU превышает 6k CPU. Удаляю некоторые чипы...") end
	end
end)

hook.Add("OnEntityCreated", "e2log", function(ent)
    wait(function()
        if (IsValid(ent) and ent:GetClass() == "gmod_wire_expression2") then
            local Context = ent.ResetContext
            function ent:ResetContext()
                wait(function()
                    if not IsValid(self) then return end

                    local owner = self:GetPlayer()

                    local name = self.directives.name or nil
                    local context = self.context

                    local weight = type(self.script) == "table" and self.script[2] or 0
                    local cpu = math.floor( weight + ( context.timebench*1000000 ) )

                    if !IsValid(owner) then return end
                    Msg("[E2] ")
                    print( string.format("%s(%s) скомпилил e2: ( %s ) [ CPU: %sus ]", owner:Nick(), owner:SteamID(), name, cpu) )
                end)
                return Context(self)
            end
        end
    end)
timer.Simple(0, function()
	if (IsValid(ent) and ent:GetClass() == "gmod_wire_expression2") then
		local ent_index = ent:EntIndex()
			timer.Create(ent_index .. "_check_what", 0, 0, function()
				if (!IsValid(ent)) then timer.Remove(ent_index .. "_check_what") return end
				local data = ent:GetOverlayData()
				if (data.timebench*1000000 < 5000) then return end
				ent:Remove()
				if (IsValid(ent:GetPlayer())) then
					ent:GetPlayer():SendLua("GAMEMODE:AddNotify(\"Твой чип сильно нагружал сервер и поэтому он был удалён.\", NOTIFY_ERROR, 8)")
					Msg("[E2] ")
					print( "Был удалён чип игрока " .. ent:GetPlayer():Name() .. " за сильную нагрузку сервера." )
				else
					Msg("[E2] ")
					print( "Был удалён какой-то чип за сильную нагрузку сервера." )
				end
			end)
		end
	end)
end)
