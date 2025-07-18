local Debug = {
  __NAME = "Debug",
  __VERSION = { 5, 2, 6 },
}

local Globals = require("Modules/Globals")
local ImGuiExt = require("Modules/ImGuiExt")

local Calculate = require("Modules/Calculate")
local Diagnostics = require("Modules/Diagnostics")
local Vectors = require("Modules/Vectors")

local Screen = Globals.GetScreenTable()
local CalculateMaskingGlobal = Calculate.GetMaskingGlobalData()
local VectorsMaskingGlobal = Vectors.GetMaskingGlobalData()
local OnFootMasksData = Calculate.GetMasksData()
local VehMasksData = Vectors.GetVehMasksData()


function Debug.DrawUI()
  if ImGui.BeginTabItem("General Data") then

    if Diagnostics and Diagnostics.modscompatibility then
      ImGuiExt.Text("Diagnostics:")
      ImGuiExt.Text("Mods Compatibility")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Diagnostics.modscompatibility))
    elseif Diagnostics and Diagnostics.modscompatibility == nil then
      ImGuiExt.Text("Diagnostics module deactivated")
    else
      ImGuiExt.Text("Diagnostics module not present")
    end

    ImGui.Separator()

    ImGuiExt.Text("Screen Resolution:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Screen.Resolution.width))
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Screen.Resolution.height))
    ImGuiExt.Text("Screen Aspect Ratio:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Screen.aspectRatio))
    ImGuiExt.Text("Screen Type:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Screen.typeName))
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Screen.type))
    ImGuiExt.Text("Screen Width Factor:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Screen.Factor.width))
    ImGuiExt.Text("Screen Space:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Screen.Space.width))
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Screen.Space.height))

    ImGui.Separator()
    ImGuiExt.Text("Masks Controller:")
    
    if Vectors then
      ImGuiExt.Text("For Vectors Module")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(VectorsMaskingGlobal.masksController))
    end
    
    if Calculate then
      ImGuiExt.Text("For Calculate Module")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(CalculateMaskingGlobal.masksController))
    end

    ImGui.Separator()

    ImGuiExt.Text("Masking enabled:")
    ImGuiExt.Text("For Vectors Module")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(VectorsMaskingGlobal.vehicles))

    if Vectors then
      ImGui.Separator()

      ImGuiExt.Text("Masks Paths:")

      if VehMasksData.HorizontalEdgeDown.hedCornersPath then
        ImGuiExt.Text(tostring(VehMasksData.HorizontalEdgeDown.hedCornersPath))
        ImGuiExt.Text(tostring(VehMasksData.HorizontalEdgeDown.hedFillPath))
        ImGuiExt.Text(tostring(VehMasksData.HorizontalEdgeDown.hedTrackerPath))
        ImGuiExt.Text(tostring(VehMasksData.Mask1.maskPath))
        ImGuiExt.Text(tostring(VehMasksData.Mask2.maskPath))
        ImGuiExt.Text(tostring(VehMasksData.Mask3.maskPath))
        ImGuiExt.Text(tostring(VehMasksData.Mask4.maskPath))
      end
    end

    ImGui.EndTabItem()
  end
  if Calculate then
    if ImGui.BeginTabItem("Calculate Debug") then

      ImGuiExt.Text("Corner Masks Screen Space:")
      if OnFootMasksData.Corners.ScreenSpace.Left.x then
        ImGuiExt.Text(tostring(OnFootMasksData.Corners.ScreenSpace.Left.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(OnFootMasksData.Corners.ScreenSpace.Right.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(OnFootMasksData.Corners.ScreenSpace.Bottom.y))
      end

      ImGui.Separator()

      ImGuiExt.Text("Blocker Size:")
      if OnFootMasksData.Blocker.Size.x then
        ImGuiExt.Text(tostring(OnFootMasksData.Blocker.Size.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(OnFootMasksData.Blocker.Size.y))
      end

      ImGui.Separator()

      ImGuiExt.Text("Vignette Screen Space:")
      if OnFootMasksData.Vignette.ScreenSpace.x then
        ImGuiExt.Text(tostring(OnFootMasksData.Vignette.ScreenSpace.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(OnFootMasksData.Vignette.ScreenSpace.y))
      end

      ImGuiExt.Text("Vignette Size:")
      if OnFootMasksData.Vignette.ScreenSpace.x then
        ImGuiExt.Text(tostring(OnFootMasksData.Vignette.Size.x))
        ImGui.SameLine()
        ImGuiExt.Text(tostring(OnFootMasksData.Vignette.Size.y))
      end

      ImGui.EndTabItem()
    end
  end
end

return Debug