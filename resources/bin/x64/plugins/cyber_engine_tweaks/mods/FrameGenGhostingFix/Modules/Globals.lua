Globals = {
  __NAME = "Globals",
  __VERSION = { 5, 0, 0 },
  ModState = {
    isDebug = false,
    isHelp = true,
    keepWindow = false,
    isFGEnabled = true,
    openWindow = false,
    isFirstRun = false,
    isNewInstall = false,
    isReady = true,
    statusBar = nil,
  },
  PlayerState = {
    isMounted = nil,
  },
  MaskingGlobal = {
    masksController = "gameuiCrosshairContainerController",
    Widgets = {
      hedCorners = "horizontaledgedowncorners",
      hedFill = "horizontaledgedownfill",
      hedTracker = "horizontaledgedowntracker",
      hedCornersEditor = "horizontaledgedowncorners_editor",
      hedFillEditor = "horizontaledgedowncorners_editor",
      mask1 = "mask1",
      mask2 = "mask2",
      mask3 = "mask3",
      mask4 = "mask4",
      maskEditor1 = "mask_editor1",
      maskEditor2 = "mask_editor2",
      blockerAimOnFoot = "blockerAimOnFoot",
      cornerDownLeft = "cornerDownLeftOnFoot",
      cornerDonwRight = "cornerDownRightOnFoot",
      vignette = "vignetteOnFoot",
      vignette_editor = "vignetteOnFoot_editor",
      vignetteAim = "vignetteAimOnFoot"
    }
  },
  Screen = {
    aspectRatio = 1,
    Def = {
      Factor = {width = 1, height = 1},
      Resolution = {width = 3840, height = 2160},
      Space = {width = 3840, height = 2160},
    },
    Edge = {
      down = 2160,
      left = 0,
      right = 3840,
    },
    Factor = {width = 1, height = 1},
    isAspectRatioChange = false,
    Resolution = {width = nil, height = nil},
    Space = {width = 3840, height = 2160},
    type = 169,
    typeName = "16:9",
  },
}

-- --stores data that is shared between modules
local WhiteBoard = {}

--stores exlusive fallbacks for any module
local FallbackBoard = {}

--stores active delays
local DelayBoard = {}

local Localization = require("Modules/Localization")

local LogText = Localization.LogText

-----------
-- Unviersal methods
-----------

--- Creates a deep copy of the given contents. For non-table values, it returns the original value.
--
-- @param contents: any type; The value to be deep copied.
--
-- @return copy: table or contents; A deep copy of the input if it's a table, otherwise the input itself.
function Globals.Deepcopy(contents)
  if contents == nil then return contents end
  
  local contentsType = type(contents)
  local copy

  if contentsType == 'table' then
    copy = {}

    for key, value in next, contents, nil do
      copy[Globals.Deepcopy(key)] = Globals.Deepcopy(value)
    end

    setmetatable(copy, Globals.Deepcopy(getmetatable(contents)))
  else
    copy = contents
  end

  return copy
end

--- Safely merges two tables, updating only existing keys in the destination table.
--
-- @param mergeTo: table; The destination table to merge into.
-- @param mergeA: table; The source table to merge from.
--
-- @return mergeTo: table; The updated destination table after merging.
function Globals.SafeMergeTables(mergeTo, mergeA)
  if type(mergeTo) ~= "table" then Globals.Print("Can't merge. The mergeTo is not a table:", mergeTo) return mergeTo end
  if mergeA == nil then return mergeTo end
  if type(mergeA) ~= "table" then Globals.Print("Can't merge. The mergeA is not a table:", mergeA) return mergeTo end

  for key, value in pairs(mergeA) do
      if mergeTo[key] ~= nil then  -- Only proceed if the key exists in mergeTo
          if type(value) == "table" and type(mergeTo[key]) == "table" then
              mergeTo[key] = Globals.SafeMergeTables(mergeTo[key], value)
          else
              mergeTo[key] = value
          end
      end
  end

  return mergeTo
end

--- Merges two tables, combining their contents recursively.
--
-- @param mergeTo: table; The destination table to merge into.
-- @param mergeA: table; The source table to merge from.
--
-- @return mergeTo: table; The updated destination table after merging.
function Globals.MergeTables(mergeTo, mergeA)
  if type(mergeTo) ~= "table" then Globals.Print("Can't merge. The mergeTo is not a table:", mergeTo) end
  if mergeA == nil then return end
  if type(mergeA) ~= "table" then Globals.Print("Can't merge. The mergeA is not a table:", mergeA) end

  for key, value in pairs(mergeA) do
      if type(value) == "table" then
          if type(mergeTo[key]) == "table" then
              mergeTo[key] = Globals.MergeTables(mergeTo[key], value)
          else
              mergeTo[key] = Globals.MergeTables({}, value)
          end
      else
          mergeTo[key] = value
      end
  end

  return mergeTo
end

--- Prints a formatted message with an optional module name and variable number of content items.
--
-- @param moduleName: string|nil; The name of the module to be included in the output. If nil, no module name is printed: if only one item is given, no nil is needed (will print just the item without bracketing it as a module name).
-- @param ...: any; Variable number of items to be printed as the content of the message. 
--
-- @return nil
function Globals.Print(moduleName, ...)
  local mod = "[" .. FrameGenGhostingFix.__NAME .. "]"
  local module = ""
  local contents

  if select('#', ...) == 0 then
    contents = {moduleName}
  else
    module = "[" .. tostring(moduleName) .. "]"
    contents = {...}
  end

  if #contents == 0 and module == "" then
      return print(mod, Globals.__NAME, "No contents to print.")
  end

  for i, value in ipairs(contents) do
    contents[i] = tostring(value)
  end

  local concatenatedContents = table.concat(contents, " ")

  print(mod, module, concatenatedContents)
end

--- Prints a formatted message with an optional module name and variable number of content items. Prints to the mod's exlusive log file.
--
-- @param moduleName: string|nil; The name of the module to be included in the output. If nil, no module name is printed: if only one item is given, no nil is needed (will print just the item without bracketing it as a module name).
-- @param ...: any; Variable number of items to be printed as the content of the message. 
--
-- @return nil
function Globals.PrintError(moduleName, ...)
  local modError = "[" .. FrameGenGhostingFix.__NAME .. "]" .. " [ERROR]"
  local module = ""
  local contents

  if select('#', ...) == 0 then
    contents = {moduleName}
  else
    module = "[" .. tostring(moduleName) .. "]"
    contents = {...}
  end

  if #contents == 0 and module == "" then
      return print(modError, Globals.__NAME, "No error contents to print.")
  end

  for i, value in ipairs(contents) do
    contents[i] = tostring(value)
  end

  local concatenatedContents = table.concat(contents, " ")
  local printContents = modError .. " " .. module .. " " .. concatenatedContents

  print(printContents)
  spdlog.error(printContents)
end

--- Converts a version string to a table of numbers.
--
-- @param versionString: string; The version string to convert (e.g., "5.0.0").
--
-- @return table: A table containing the version numbers.
function Globals.VersionStringToTable(versionString)
  local versionTable = {}

  for number in versionString:gmatch("%d+") do
    table.insert(versionTable, tonumber(number))
  end

  return versionTable
end

--- Compares a given version table with the mod's current version (FrameGenGhostingFix.__VERSION) to check compatibility.
--
-- @param versionTable: table; The version table (must be 3 integers: {major, minor, patch}) to compare against FrameGenGhostingFix.__VERSION.
--
-- @return boolean: Returns true if the given version table is newer or equal, false otherwise.
function Globals.VersionCompare(versionTable)
  for i = 1, 3 do
    if   FrameGenGhostingFix.__VERSION[i] > versionTable[i] then
      return false
    elseif FrameGenGhostingFix.__VERSION[i] < versionTable[i] then
      return true
    end
  end

  return true
end

------------

-- writes to WhiteBoard for the module name under a key if one is given -- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
function Globals.WriteWhiteBoard(moduleName,contents,key)-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
  if moduleName and not contents then Globals.Print(moduleName, "Can't write to the mod's WhiteBoard, check the code...") end --debug-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
  if not moduleName or not contents then Globals.Print("Can't write to the mod's WhiteBoard, check the code...") end --debug-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE

  local copiedContents = Globals.Deepcopy(contents)-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE

  if key then-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
    WhiteBoard[moduleName] = WhiteBoard[moduleName] or {}-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
    WhiteBoard[moduleName][key] = copiedContents-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
  else
    WhiteBoard[moduleName] = copiedContents-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
  end
end

-- returns a table from WhiteBoard for the module name and key
function Globals.GetWhiteBoard(moduleName,key)-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
  if WhiteBoard[moduleName] == nil then Globals.Print(moduleName, "There's no pool in the mod's WhiteBoard for the given moduleName.") end --debug-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
  if key and WhiteBoard[moduleName][key] == nil then Globals.Print(moduleName, "There's no pool in the mod's WhiteBoard for the given module name and key:", key) end --debug-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE

  if key then-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
    return WhiteBoard[moduleName][key]-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
  else-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
    return WhiteBoard[moduleName]-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
  end-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
end-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE

------------

--- Sets a fallback value for a specified owner, optionally with a key.
-- This function stores a deep copy of the provided contents in the FallbackBoard,
-- either directly under the owner or nested under a specific key for that owner.
--
-- @param owner: string; The identifier for the fallback owner.
-- @param contents: any; The content to be stored as a fallback.
-- @param key: string; Optional. If provided, the contents are stored under this key for the owner.
--
-- @return None
function Globals.SetFallback(owner,contents,key)
  if not contents or not owner then Globals.Print("Can't set a fallback.") end

  local copiedContents = Globals.Deepcopy(contents)

  if key then
    FallbackBoard[owner] = FallbackBoard[owner] or {}
    FallbackBoard[owner][key] = copiedContents
  else
    FallbackBoard[owner] = copiedContents
  end
end

--- Retrieves a fallback value for a specified owner, optionally with a key.
-- This function returns the fallback content stored in the FallbackBoard for a given owner,
-- either directly or from a specific key associated with that owner.
--
-- @param owner: string; The identifier for the fallback owner.
-- @param key: astring; Optional. If provided, retrieves the fallback content associated with this key for the owner.
--
-- @return fallback: any; The fallback content for the specified owner (and key, if provided). 
--                        Returns nil if no fallback is found.
function Globals.GetFallback(owner,key)
  if FallbackBoard[owner] == nil then Globals.Print("There are no fallbacks for the owner:", owner) end --debug
  if key and FallbackBoard[owner] and FallbackBoard[owner][key] == nil then Globals.Print("There is no fallback for the given key:", key, owner) end --debug

  if key then
    return FallbackBoard[owner][key]
  else
    return FallbackBoard[owner]
  end
end

--- Sets a delay with a specified duration and callback function.
--
-- @param duration: number; The duration of the delay in seconds.
-- @param key: string; A unique identifier for the delay.
-- @param callback: function; The function to be called when the delay expires.
-- @param ...: any; Optional parameters to be passed to the callback function.
--
-- @return None
function Globals.SetDelay(duration, key, callback, ...)
  local parameters = {...}

  if not duration or not key or not callback then Globals.Print("Cannot set the delay. Check parameters.") return end

  DelayBoard[key] = {
    remainingTime = duration,
    callback = callback,
    parameters = parameters
  }
end

--- Cancel a delay.
--
-- @param key: string; A unique identifier for the delay.
--
-- @return None
function Globals.CancelDelay(key)
  if not key then Globals.Print("Cannot find a delay:", key) return end

  DelayBoard[key] = nil
end

--- Updates all active delays, decreasing their remaining time and executing callbacks for expired delays.
--
-- @param None
--
-- @return None
function Globals.UpdateDelays(gameDeltaTime)
  if not next(DelayBoard) then return end

  local delaysToRemove = {}

  for key, delay in pairs(DelayBoard) do
    delay.remainingTime = delay.remainingTime - gameDeltaTime
    
    if delay.remainingTime <= 0 then
      if delay.parameters then
        delay.callback(unpack(delay.parameters))
      else
        delay.callback()
      end
    
      table.insert(delaysToRemove, key)
    end
  end

  for _, key in ipairs(delaysToRemove) do
    DelayBoard[key] = nil
  end
end

--- Sets the debug state for the global configuration.
--
-- @param boolean: boolean; The debug state to set (true for debug mode, false for normal mode).
--
-- @return None
function Globals.SetDebug(boolean)
  Globals.ModState.isDebug = boolean
end

--- Checks if the mod is currently in debug mode.
--
-- @param None
--
-- @return isDebug: boolean;
function Globals.IsDebug()
  return Globals.ModState.isDebug
end

--- Sets the ready state for the global configuration.
--
-- @param boolean: boolean; The ready state to set (true if the mod is ready, false otherwise).
--
-- @return None
function Globals.SetModReady(boolean)
  Globals.ModState.isReady = boolean
end

--- Checks if the mod is ready for operation.
--
-- @param None
--
-- @return isReady: boolean;
function Globals.IsModReady()
  return Globals.ModState.isReady
end

--- Sets the first run state for the mod and performs related actions.
--
-- @param boolean: boolean; The first run state to set (true if it's the first run, false otherwise).
--
-- @return None
function Globals.SetFirstRun(boolean)
  Globals.ModState.isFirstRun = boolean
  if not boolean then return end
  Globals.SetNewInstall(true)
  Globals.Print(LogText.globals_firstRun)
end

--- Checks if this is the first run of the mod.
--
-- @param None
--
-- @return isFirstRun: boolean;
function Globals.IsFirstRun()
  return Globals.ModState.isFirstRun
end

--- Sets the new install state for the mod and logs a message if appropriate.
--
-- @param boolean: boolean; The new install state to set (true if it's a new install, false otherwise).
--
-- @return None
function Globals.SetNewInstall(boolean)
  Globals.ModState.isNewInstall = boolean
  if not boolean or Globals.ModState.isFirstRun then return end
  Globals.Print(LogText.globals_newVersion)
end

--- Checks if the current installation of the mod is new.
--
-- @param None
--
-- @return isNewInstall: boolean;
function Globals.IsNewInstall()
  return Globals.ModState.isNewInstall
end

--- Sets the state for keeping a window open or closed.
--
-- @param boolean: boolean; The keep window state to set (true to keep the window open, false to allow it to close).
--
-- @return None
function Globals.KeepWindow(boolean)
  Globals.ModState.keepWindow = boolean
end

--- Sets the state for opening or closing a window.
--
-- @param boolean: boolean; The open window state to set (true to open the window, false to close it).
--
-- @return None
function Globals.OpenWindow(boolean)
  Globals.ModState.openWindow = boolean
end

--- Retrieves the masks controller from the global configuration.
--
-- @param None
--
-- @return masksController: string; The masks controller name.
function Globals.GetMasksController()
  return Globals.MaskingGlobal.masksController
end

--- Retrieves the Widgets table containing masks' widgets names from the global configuration.
--
-- @param None
--
-- @return Widgets: table; The Widgets table from the global masking configuration.
function Globals.GetWidgets()
  return Globals.MaskingGlobal.Widgets
end

--- Retrieves the Screen table containg current screen data from the global configuration.
--
-- @param None
--
-- @return Screen: table; The Screen table from the global configuration.
function Globals.GetScreen()
  return Globals.Screen
end

--- Checks if the player is currently mounted on a vehicle and updates the player isMounted state.
--
-- @param None
--
-- @return isMounted: boolean; True if the player is mounted on a vehicle, false otherwise.
function Globals.IsMounted()
  local isMounted = Game['GetMountedVehicle;GameObject'](Game.GetPlayer())

  if isMounted then
    Globals.PlayerState.isMounted  = true
  else
    Globals.PlayerState.isMounted  = false
  end

  return Globals.PlayerState.isMounted
end

-----------
-- Screen Configuration
-----------

--- Calculates and updates the screen aspect ratio, detecting changes.
--
-- @param None
--
-- @return aspectRatio: number; The current aspect ratio of the screen. Updates Globals.Screen.isAspectRatioChange internally.
function Globals.GetAspectRatio()
  local previousAspectRatio = Globals.Screen.aspectRatio

  Globals.Screen.Resolution.width, Globals.Screen.Resolution.height = GetDisplayResolution();
  Globals.Screen.aspectRatio = Globals.Screen.Resolution.width / Globals.Screen.Resolution.height

  if previousAspectRatio == 1 then return Globals.Screen.aspectRatio end

  if Globals.Screen.aspectRatio ~= previousAspectRatio then
    Globals.Screen.isAspectRatioChange = true
    Globals.SetModReady(false)
    Globals.Print(LogText.globals_aspectRatioChange)
  end

  return Globals.Screen.aspectRatio
end

function Globals.IsAspectRatioChange()
  return Globals.Screen.isAspectRatioChange
end

function Globals.ResetAspectRatioChange()
  Globals.Screen.isAspectRatioChange = false
end

--- Determines and returns the screen type enum based on the current aspect ratio.
--
-- @param None
--
-- @return screenType: enum; Updates Globals.Screen.type internally.
function Globals.GetScreenType()
  local screenAspectRatio = Globals.Screen.aspectRatio

  if screenAspectRatio < 1.5 then
    Globals.Screen.type = 43
  elseif screenAspectRatio >= 1.5 and screenAspectRatio < 1.7 then
    Globals.Screen.type = 1610
  elseif screenAspectRatio >= 1.7 and screenAspectRatio < 2.2 then
    Globals.Screen.type = 169
  elseif screenAspectRatio >= 2.2 and screenAspectRatio < 3.4 then
    Globals.Screen.type = 219
  elseif screenAspectRatio >= 3.4 then
    Globals.Screen.type = 329
  end

  return Globals.Screen.type
end

--- Retrieves the string name of the current screen type.
--
-- @param None
--
-- @return screenTypeName: string; Updates Globals.Screen.typeName internally.
function Globals.GetScreenTypeName()
  local screenType = Globals.Screen.type

  if screenType == 169 then
    Globals.Screen.typeName = "16:9"
  elseif screenType == 1610 then
    Globals.Screen.typeName = "16:10"
  elseif screenType == 219 then
    Globals.Screen.typeName = "21:9"
  elseif screenType == 329 then
    Globals.Screen.typeName = "32:9"
  elseif screenType == 43 then
    Globals.Screen.typeName = "4:3"
  end

  return Globals.Screen.typeName
end

--- Determines and returns the screen width factor based on the current screen type.
--
-- @param None
--
-- @return widthFactor: number; Updates Globals.Screen.Factor.width internally.
function Globals.GetScreenWidthFactor()
  local screenType = Globals.Screen.type

  if screenType == 169 or screenType == 1610 or screenType == 43 then
    Globals.Screen.Factor.width = Globals.Screen.Def.Factor.width
  elseif screenType == 219 then
    Globals.Screen.Factor.width = 1.34
  elseif screenType == 329 then
    Globals.Screen.Factor.width = 2
  end

  return Globals.Screen.Factor.width
end

--- Calculates and returns the screen space dimensions based on the current screen type.
--
-- @param None
--
-- @return screenSpace: table; Updates Globals.Screen.Space internally.
function Globals.GetScreenSpace()
  local screenType = Globals.Screen.type
  local screenResDef = Globals.Screen.Def.Resolution
  local screenFactor = Globals.Screen.Factor

  if screenType == 169 or screenType == 1610 or screenType == 43 then
    Globals.Screen.Space.width = Globals.Screen.Def.Space.width
  elseif screenType == 219 or screenType == 329 then
    Globals.Screen.Space.width = screenResDef.width * screenFactor.width
  end

  return Globals.Screen.Space
end


--- Determines and returns the screen edge coordinates based on the current screen type.
--
-- @param None
--
-- @return screenEdge: table; A table containing the screen edge coordinates: left (x-axis), right (x-axis), down (y-axis). Updates Globals.Screen.Edge internally.
function Globals.GetScreenEdge()
  local screenType = Globals.Screen.type

  if screenType == 169 then
    Globals.Screen.Edge.left = 0
    Globals.Screen.Edge.right = 3840
    Globals.Screen.Edge.down = 2160
  elseif screenType == 1610 then
    Globals.Screen.Edge.left = 0
    Globals.Screen.Edge.right = 3840
    Globals.Screen.Edge.down = 2280
  elseif screenType == 219 then
    Globals.Screen.Edge.left = -640
    Globals.Screen.Edge.right = 4480
    Globals.Screen.Edge.down = 2160
  elseif screenType == 329 then
    Globals.Screen.Edge.left = -1920
    Globals.Screen.Edge.right = 5760
    Globals.Screen.Edge.down = 2160
  elseif screenType == 43 then
    Globals.Screen.Edge.left = 0
    Globals.Screen.Edge.right = 3840
    Globals.Screen.Edge.down = 2640
  end

  return Globals.Screen.Edge
end

-----------
-- On... handlers
-----------

function Globals.OnInitialize()
  Globals.GetAspectRatio()
  Globals.GetScreenType()
  Globals.GetScreenTypeName()
  Globals.GetScreenEdge()
  Globals.GetScreenWidthFactor()
  Globals.GetScreenSpace()
end

function Globals.OnOverlayOpen()
  Globals.GetAspectRatio()
  Globals.GetScreenType()
  Globals.GetScreenTypeName()
  Globals.GetScreenEdge()
  Globals.GetScreenWidthFactor()
  Globals.GetScreenSpace()
  Globals.IsMounted()
end

function Globals.OnOverlayClose()
  Globals.GetAspectRatio()
  Globals.GetScreenType()
  Globals.GetScreenTypeName()
  Globals.GetScreenEdge()
  Globals.GetScreenWidthFactor()
  Globals.GetScreenSpace()
end

return Globals