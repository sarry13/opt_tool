local ticks = 0
local last_clear = 0
local ticks_per_second = 0
local gay = 0
local cache_gay = 0
local i = 0
hook.Add( "Tick", "dacounter", function()
	if (SysTime() > last_clear) then
		ticks_per_second = ticks
		ticks = 0
        last_clear = SysTime() + 1
        gay = ((1/engine.TickInterval() - ticks_per_second)*0.01)*2.3
        gay = math.Clamp(gay, 0, 1)
	end
    ticks = ticks + 1
end )
timer.Create("cache_gay", 1, 0, function()
    if gay > cache_gay then
        cache_gay = gay
		if timer.Exists("numberrrs") then timer.Remove("numberrrs") i = 0  end
        RunConsoleCommand("phys_timescale", 1-cache_gay)
        timer.Create("numberrrs", 1, 90, function()
            i = i + 1
            if i >= 90 then
                RunConsoleCommand("phys_timescale", "1")
                cache_gay = 0
                i = 0
            end
        end)
    end
end)
