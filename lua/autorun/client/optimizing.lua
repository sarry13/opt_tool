local on_collect = true -- если хотите чтобы на клиенте меньше фризов было то врубите эту хуйню, но стоит сказать она забирает немного фпс.
local concommand_add = true -- команда на повышение фпса

hook.Remove( 'GUIMousePressed', 'SuperDOFMouseDown' )
hook.Remove( 'GUIMouseReleased', 'SuperDOFMouseUp' )
hook.Remove( 'PreventScreenClicks', 'SuperDOFPreventClicks' )
hook.Remove( 'PostRender', 'RenderFrameBlend' )
hook.Remove( 'PreRender', 'PreRenderFrameBlend' )
hook.Remove( 'Think', 'DOFThink' )
hook.Remove( 'PostDrawEffects', 'RenderWidgets' )
hook.Remove( "RenderScreenspaceEffects", "RenderBokeh" )
hook.Remove( "NeedsDepthPass", "NeedsDepthPass_Bokeh" )

if on_collect then
	timer.Create("dont_freeze_my_game", 0, 0, function()
		collectgarbage("step", 170)
	end)
end

GAMEMODE.PreDrawViewModel = function() end

if concommand_add then
	CreateClientConVar("cl_fps_distance", 2000, true, false)
	concommand.Add("fps_up", function()
		ebaniyfps = !ebaniyfps
		LocalPlayer():EmitSound("garrysmod/content_downloaded.wav")
		if ebaniyfps then
			RunConsoleCommand('gmod_mcore_test', '1')
			RunConsoleCommand( "r_threaded_particles", "1" )
			RunConsoleCommand( "r_threaded_renderables", "1" )
			RunConsoleCommand( "mat_queue_mode", "-1" )
			RunConsoleCommand( "cl_threaded_client_leaf_system", "1" )
			RunConsoleCommand( "cl_threaded_bone_setup", "1" )
			RunConsoleCommand( "r_queued_ropes", "1" )
			RunConsoleCommand( "fps_max", "0" )
			if simfphys then
				hook.Remove("Think", "simfphys_lights_managment") -- убейте тварь которая кодила симфиз
			end
			local LocalPlayer = LocalPlayer
			timer.Create("pizda", 1, 0, function()
				local cl_fps_distance = GetConVarNumber("cl_fps_distance")
				for _, v in ipairs(ents.GetAll()) do
					if (IsValid(v)) and (LocalPlayer():GetPos():DistToSqr(v:GetPos()) > cl_fps_distance*1000) then
						v:SetNoDraw(true)
					else
						v:SetNoDraw(false)
					end
				end
			end)
			chat.AddText("Включено! Дальность прорисовки можно изменить командой cl_fps_distance.")
		else
			RunConsoleCommand('gmod_mcore_test', '0')
			RunConsoleCommand( "r_threaded_particles", "0" )
			RunConsoleCommand( "r_threaded_renderables", "0" )
			RunConsoleCommand( "mat_queue_mode", "2" )
			RunConsoleCommand( "cl_threaded_client_leaf_system", "0" )
			RunConsoleCommand( "cl_threaded_bone_setup", "0" )
			RunConsoleCommand( "r_queued_ropes", "0" )
			RunConsoleCommand( "fps_max", "300" )
			for _, v in ipairs(ents.GetAll()) do
				v:SetNoDraw(false)
			end
			timer.Remove("pizda")
			timer.Remove("cache_ents")
			chat.AddText("Выключено!")
		end
	end)
end
