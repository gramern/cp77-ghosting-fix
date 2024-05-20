--FrameGen Ghosting Fix 4.1.2

local Diagnostics = {
  modscompatibility = true,
  modfiles = {},
  updateinfo = false;
}

--check for compatibility with other mods
function Diagnostics.CheckModsCompatibility()
  if ModArchiveExists('basegame_hud_minimap_scanner_tweak.archive') then
    table.insert(Diagnostics.modfiles, 1, "Limited HUD")
    Diagnostics.updateinfo = true
    Diagnostics.modscompatibility = false
  end

  if ModArchiveExists('###framegenghostingfix_LimitedHUD.archive') then
    table.insert(Diagnostics.modfiles, 1, "Limited HUD")
    Diagnostics.updateinfo = true
  end

  if ModArchiveExists('##ReduxUI_AddonSpeedometer.archive') then
    table.insert(Diagnostics.modfiles, 2, "Redux UI E3 Speedometer")
    Diagnostics.updateinfo = true

    if not ModArchiveExists('###framegenghostingfix_RUIE3Speed.archive') then
      Diagnostics.modscompatibility = false
    end
  end

  if ModArchiveExists('#Project-E3_HUD.archive') then
    table.insert(Diagnostics.modfiles, 3, "Project E3 - HUD")
    Diagnostics.updateinfo = true

    if not ModArchiveExists('###framegenghostingfix_ProjectE3.archive') then
      Diagnostics.modscompatibility = false
    end
  end

  if ModArchiveExists('#Project-E3_HUD-Lite.archive') then
    table.insert(Diagnostics.modfiles, 4, "Project E3 - HUD (Lite)")
    Diagnostics.updateinfo = true

    if not ModArchiveExists('###framegenghostingfix_ProjectE3Lite.archive') then
      Diagnostics.modscompatibility = false
    end
  end

  if ModArchiveExists('dxstreamlined.archive') then
    table.insert(Diagnostics.modfiles, 5, "Streamlined HUD")
    Diagnostics.updateinfo = true

    if not ModArchiveExists('###framegenghostingfix_StreamlinedHUD.archive') then
      Diagnostics.modscompatibility = false
    end
  end
end

return Diagnostics