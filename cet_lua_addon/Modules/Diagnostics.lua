--FrameGen Ghosting Fix 4.0.2

local Diagnostics = {
	modscompatibility = true,
	modfiles = {}
}

--check for compatibility with other mods
function Diagnostics.CheckModsCompatibility()

	if ModArchiveExists('basegame_hud_minimap_scanner_tweak.archive') then
		Diagnostics.modscompatibility = false
		table.insert(Diagnostics.modfiles, 1, "Limited HUD")
	end
	if ModArchiveExists('##ReduxUI_AddonSpeedometer.archive') and not ModArchiveExists('###framegenghostingfix_RUIE3Speed.archive') then
		Diagnostics.modscompatibility = false
		table.insert(Diagnostics.modfiles, 2, "Redux UI E3 Speedometer")
	end
	if ModArchiveExists('#Project-E3_HUD.archive') and not ModArchiveExists('###framegenghostingfix_ProjectE3.archive') then
		if ModArchiveExists('###framegenghostingfix_RUIE3Speed.archive') then
			print("[FrameGen Ghosting 'Fix'] Compatibility tweak for Redux UI Speedometer detected. Ghosting 'Fix' enabled.")
		else
			Diagnostics.modscompatibility = false
			table.insert(Diagnostics.modfiles, 3, "Project E3 - HUD")
		end
	end
	if ModArchiveExists('#Project-E3_HUD-Lite.archive') and not ModArchiveExists('###framegenghostingfix_ProjectE3Lite.archive') then
		if ModArchiveExists('###framegenghostingfix_RUIE3Speed.archive') then
			print("[FrameGen Ghosting 'Fix'] Compatibility tweak for Redux UI Speedometer detected. Ghosting 'Fix' enabled.")
		else
			Diagnostics.modscompatibility = false
			table.insert(Diagnostics.modfiles, 4, "Project E3 - HUD (Lite)")
		end
	end
	if ModArchiveExists('dxstreamlined.archive') and not ModArchiveExists('###framegenghostingfix_StreamlinedHUD.archive') then
		if ModArchiveExists('###framegenghostingfix_RUIE3Speed.archive') then
			print("[FrameGen Ghosting 'Fix'] Compatibility tweak for Redux UI Speedometer detected. Ghosting 'Fix' enabled.")
		else
			Diagnostics.modscompatibility = false
			table.insert(Diagnostics.modfiles, 5, "Streamlined HUD")
		end
	end
end

return Diagnostics