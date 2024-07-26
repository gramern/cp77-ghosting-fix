local TrackerDebug = {
  __NAME = "TrackerDebug",
  __VERSION = { 5, 0, 0 },
}

local ImGuiExt = require("Modules/ImGuiExt")
local Tracker = require("Modules/Tracker")

local GamePerf = Tracker.GetGamePerfTable()
local GameState = Tracker.GetGameStateTable()
local Player = Tracker.GetPlayerTable()
local Vehicle = Tracker.GetVehicleTable()

function TrackerDebug.DrawUI()
  if ImGui.BeginTabItem("Tracker Debug") then
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
      ImGuiExt.Text("id:")
      ImGui.SameLine()
      ImGuiExt.Text(tostring(Vehicle.id))
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