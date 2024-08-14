local Diagnostics = {
  __NAME = "Diagnostics",
  __VERSION = { 5, 0, 1 },
  isModsCompatibility = true,
  modfiles = {},
  isUpdateRecommended = false
}

local Globals = require("Modules/Globals")
local ImGuiExt = require("Modules/ImGuiExt")
local Localization = require("Modules/Localization")
local Tracker = require("Modules/Tracker")

local DiagnosticsText = Localization.GetDiagnosticsText()


function Diagnostics.IsUpdateRecommended()
  return Diagnostics.isUpdateRecommended
end

--check for compatibility with other mods
function Diagnostics.CheckModsCompatibility()
end

function Diagnostics.OnInitialize()
  -- Diagnostics.CheckModsCompatibility()
  if Diagnostics.isModsCompatibility then return end
  Tracker.SetModReady(false)
end

--Local UI
function Diagnostics.DrawUI()
  if ImGui.BeginTabItem(DiagnosticsText.tab_name_diagnostics) then
    if not Diagnostics.isModsCompatibility then
      ImGuiExt.TextRed(DiagnosticsText.info_warning)
      ImGui.Text("")
      ImGuiExt.Text(DiagnosticsText.info_conflict)
      ImGui.Text("")
      ImGuiExt.Text(DiagnosticsText.info_conflicting_mods)
    else
      ImGuiExt.TextGreen(DiagnosticsText.info_update)
      ImGui.Text("")
      ImGuiExt.Text(DiagnosticsText.info_potentially)
      ImGui.Text("")
      ImGuiExt.Text(DiagnosticsText.info_potentially_mods)
    end

    for _, mod in pairs(Diagnostics.modfiles) do
      ImGuiExt.Text(mod)
    end
   
    ImGui.EndTabItem()
  end
end

return Diagnostics