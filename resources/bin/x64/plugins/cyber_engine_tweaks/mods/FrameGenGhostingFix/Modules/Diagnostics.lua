--FrameGen Ghosting Fix 4.8.0xl-alpha2

local Diagnostics = {
  modscompatibility = true,
  modfiles = {},
  updateinfo = false
}

local UIText = require("Modules/UIText")

function Diagnostics.DiagnosticsUI()
  if ImGui.BeginTabItem(UIText.Diagnostics.tabname) then
    if not Diagnostics.modscompatibility then
      ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.2, 0.2, 1)
      ImGui.Text(UIText.Diagnostics.title_warning)
      ImGui.PopStyleColor()
      ImGui.Text("")
      ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
      ImGui.Text(UIText.Diagnostics.textfield_1)
      ImGui.Text("")
      ImGui.Text(UIText.Diagnostics.textfield_2)
      ImGui.PopStyleColor()
    else
      ImGui.PushStyleColor(ImGuiCol.Text, 0.2, 1, 0.2, 1)
      ImGui.Text(UIText.Diagnostics.title_info)
      ImGui.PopStyleColor()
      ImGui.Text("")
      ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
      ImGui.Text(UIText.Diagnostics.textfield_3)
      ImGui.Text("")
      ImGui.Text(UIText.Diagnostics.textfield_4)
      ImGui.PopStyleColor()
    end
    ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
    for modfile,mod in pairs(Diagnostics.modfiles) do
      ImGui.Text(mod)
    end
    ImGui.PopStyleColor()
  ImGui.EndTabItem()
  end
end

--check for compatibility with other mods
function Diagnostics.CheckModsCompatibility()
  if ModArchiveExists('LimitedHUD.archive') then
    table.insert(Diagnostics.modfiles, 1, "Limited HUD")
    Diagnostics.updateinfo = true
  end

  if ModArchiveExists('basegame_hud_minimap_scanner_tweak.archive') then
    table.insert(Diagnostics.modfiles, 2, "Limited HUD's Scanner Tweak")
    Diagnostics.updateinfo = true
    Diagnostics.modscompatibility = false
  end

  if ModArchiveExists('###framegenghostingfix_LimitedHUD.archive') then
    table.insert(Diagnostics.modfiles, 3, "Limited HUD")
    Diagnostics.updateinfo = true
  end

  if ModArchiveExists('##ReduxUI_AddonSpeedometer.archive') then
    table.insert(Diagnostics.modfiles, 4, "Redux UI E3 Speedometer")
    Diagnostics.updateinfo = true

    if not ModArchiveExists('###framegenghostingfix_RUIE3Speed.archive') then
      Diagnostics.modscompatibility = false
    end
  end

  if ModArchiveExists('#Project-E3_HUD.archive') then
    table.insert(Diagnostics.modfiles, 5, "Project E3 - HUD")
    Diagnostics.updateinfo = true

    if not ModArchiveExists('###framegenghostingfix_ProjectE3.archive') then
      Diagnostics.modscompatibility = false
    end
  end

  if ModArchiveExists('#Project-E3_HUD-Lite.archive') then
    table.insert(Diagnostics.modfiles, 6, "Project E3 - HUD (Lite)")
    Diagnostics.updateinfo = true

    if not ModArchiveExists('###framegenghostingfix_ProjectE3Lite.archive') then
      Diagnostics.modscompatibility = false
    end
  end

  if ModArchiveExists('dxstreamlined.archive') then
    table.insert(Diagnostics.modfiles, 7, "Streamlined HUD")
    Diagnostics.updateinfo = true

    if not ModArchiveExists('###framegenghostingfix_StreamlinedHUD.archive') then
      Diagnostics.modscompatibility = false
    end
  end
end

return Diagnostics