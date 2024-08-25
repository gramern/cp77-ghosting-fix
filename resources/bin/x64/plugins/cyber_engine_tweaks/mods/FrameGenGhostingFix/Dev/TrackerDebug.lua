local TrackerDebug = {
  __NAME = "TrackerDebug",
  __VERSION = { 5, 1, 9 },
}

local ImGuiExt = require("Modules/ImGuiExt")
local Tracker = require("Modules/Tracker")

local ModState = Tracker.GetModStateTable()
local GamePerf = Tracker.GetGamePerfTable()
local GameState = Tracker.GetGameStateTable()
local Player = Tracker.GetPlayerTable()
local Vehicle = Tracker.GetVehicleTable()

function TrackerDebug.DrawUI()
  if ImGui.BeginTabItem("Tracker Debug") then
    ImGuiExt.Text("Mod State:")
    ImGuiExt.Text("isFirstRun:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(ModState.isFirstRun))
    ImGuiExt.Text("isNewInstall:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(ModState.isNewInstall))
    ImGuiExt.Text("isOpenWindow:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(ModState.isOpenWindow))
    ImGuiExt.Text("isReady:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(ModState.isReady))
    ImGuiExt.Text("isFrameGen:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(ModState.isFrameGen))

    ImGui.Separator()

    ImGuiExt.Text("Game State:")
    ImGuiExt.Text("isPreGame:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(GameState.isPreGame))
    ImGuiExt.Text("isGameLoaded:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(GameState.isGameLoaded))
    ImGuiExt.Text("isGamePaused:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(GameState.isGamePaused))
    ImGuiExt.Text("isFrameGen:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(GameState.isFrameGen))

    ImGui.Separator()

    ImGuiExt.Text("Game Perf:")
    ImGuiExt.Text("averageFps:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(GamePerf.averageFps))
    ImGuiExt.Text("currentFps:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(GamePerf.currentFps))
    ImGuiExt.Text("gameDeltaTime:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(GamePerf.gameDeltaTime))
    
    ImGui.Separator()

    ImGuiExt.Text("Player:")
    ImGuiExt.Text("isMoving:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Player.isMoving))
    ImGuiExt.Text("isWeapon:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Player.isWeapon))
    ImGuiExt.Text("isDriver:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Player.isDriver))

    ImGui.Separator()

    ImGuiExt.Text("Vehicle:")
    ImGuiExt.Text("isMounted:")
    ImGui.SameLine()
    ImGuiExt.Text(tostring(Vehicle.isMounted))
    if Vehicle.isMounted then
      ImGuiExt.Text("baseObject:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vehicle.baseObject))
      ImGuiExt.Text("isSupported:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vehicle.isSupported))
      ImGuiExt.Text("currentSpeed:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vehicle.currentSpeed))
      ImGuiExt.Text("isMoving:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vehicle.isMoving))
      ImGuiExt.Text("isWeapon:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vehicle.isWeapon))
    end

    ImGui.EndTabItem()
  end
end

return TrackerDebug