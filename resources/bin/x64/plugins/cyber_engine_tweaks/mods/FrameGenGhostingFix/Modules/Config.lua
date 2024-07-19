local Config = {
  __NAME = "Config",
  __EDITION = "V",
  __VERSION = "5.0.0",
  __VERSION_NUMBER = 500,
  __VERSION_SUFFIX = nil,
  __VERSION_STATUS = nil,
  ModState = {
    isDebug = false,
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
      mask1 = "mask1",
      mask2 = "mask2",
      mask3 = "mask3",
      mask4 = "mask4",
      maskEditor1 = "mask_editor1",
      maskEditor2 = "mask_editor2",
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

--stores data that is shared between modules
local WhiteBoard = {}

--stores exlusive fallbacks for any module
local FallbackBoard = {}

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
function Config.Deepcopy(contents)
  if contents == nil then return contents end
  
  local contentsType = type(contents)
  local copy

  if contentsType == 'table' then
    copy = {}

    for key, value in next, contents, nil do
      copy[Config.Deepcopy(key)] = Config.Deepcopy(value)
    end

    setmetatable(copy, Config.Deepcopy(getmetatable(contents)))
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
function Config.SafeMergeTables(mergeTo, mergeA)
  if type(mergeTo) ~= "table" then Config.Print("Can't merge. The mergeTo is not a table:", mergeTo) return mergeTo end
  if mergeA == nil then return mergeTo end
  if type(mergeA) ~= "table" then Config.Print("Can't merge. The mergeA is not a table:", mergeA) return mergeTo end

  for key, value in pairs(mergeA) do
      if mergeTo[key] ~= nil then  -- Only proceed if the key exists in mergeTo
          if type(value) == "table" and type(mergeTo[key]) == "table" then
              mergeTo[key] = Config.SafeMergeTables(mergeTo[key], value)
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
function Config.MergeTables(mergeTo, mergeA)
  if type(mergeTo) ~= "table" then Config.Print("Can't merge. The mergeTo is not a table:",mergeTo) end
  if mergeA == nil then return end
  if type(mergeA) ~= "table" then Config.Print("Can't merge. The mergeA is not a table:",mergeA) end

  for key, value in pairs(mergeA) do
      if type(value) == "table" then
          if type(mergeTo[key]) == "table" then
              mergeTo[key] = Config.MergeTables(mergeTo[key], value)
          else
              mergeTo[key] = Config.MergeTables({}, value)
          end
      else
          mergeTo[key] = value
      end
  end

  return mergeTo
end

--- Prints a formatted message with up to three content parts and an optional (but recommended) module name.
--
-- @param contents1: any; The first content to print. Defaults to an empty string if nil.
-- @param contents2: any; The second content to print. Defaults to an empty string if nil.
-- @param contents3: any; The third content to print. Defaults to an empty string if nil.
-- @param moduleName: string; Optional. The name of the module to include in the output.
--
-- @return None
function Config.Print(contents1,contents2,contents3,moduleName)
  local module

  if moduleName then
    module = "[" .. tostring(moduleName) .. "]"
  else
    module = ""
  end

  if contents1 == nil then contents1 = "" end
  if contents2 == nil then contents2 = "" end
  if contents3 == nil then contents3 = "" end

  print("[FrameGen Ghosting 'Fix']" .. module,contents1,contents2,contents3)
end


--- Constructs and updates the mod version string based on predefined variables.
--
-- @param None
--
-- @return Config.__VERSION; Updates Config.__VERSION internally
function Config.GetModVersion()
  if Config.__VERSION_SUFFIX ~= nil then
    Config.__VERSION = Config.__VERSION .. Config.__VERSION_SUFFIX
  end

  if not Config.__VERSION_STATUS then return end
  Config.__VERSION = Config.__VERSION .. "-" .. Config.__VERSION_STATUS

  return Config.__VERSION
end

--- Sets the debug state for the global configuration.
--
-- @param boolean: boolean; The debug state to set (true for debug mode, false for normal mode).
--
-- @return None
function Config.SetDebug(boolean)
  Config.ModState.isDebug = boolean
end

--- Checks if the mod is currently in debug mode.
--
-- @param None
--
-- @return isDebug: boolean;
function Config.IsDebug()
  return Config.ModState.isDebug
end

--- Sets the ready state for the global configuration.
--
-- @param boolean: boolean; The ready state to set (true if the mod is ready, false otherwise).
--
-- @return None
function Config.SetModReady(boolean)
  Config.ModState.isReady = boolean
end

--- Checks if the mod is ready for operation.
--
-- @param None
--
-- @return isReady: boolean;
function Config.IsModReady()
  return Config.ModState.isReady
end

--- Sets the first run state for the mod and performs related actions.
--
-- @param boolean: boolean; The first run state to set (true if it's the first run, false otherwise).
--
-- @return None
function Config.SetFirstRun(boolean)
  Config.ModState.isFirstRun = boolean
  if not boolean then return end
  Config.SetNewInstall(true)
  Config.Print(LogText.config_firstRun,nil,nil,Config.__NAME)
end

--- Checks if this is the first run of the mod.
--
-- @param None
--
-- @return isFirstRun: boolean;
function Config.IsFirstRun()
  return Config.ModState.isFirstRun
end

--- Sets the new install state for the mod and logs a message if appropriate.
--
-- @param boolean: boolean; The new install state to set (true if it's a new install, false otherwise).
--
-- @return None
function Config.SetNewInstall(boolean)
  Config.ModState.isNewInstall = boolean
  if not boolean or Config.ModState.isFirstRun then return end
  Config.Print(LogText.config_newVersion,nil,nil,Config.__NAME)
end

--- Checks if the current installation of the mod is new.
--
-- @param None
--
-- @return isNewInstall: boolean;
function Config.IsNewInstall()
  return Config.ModState.isNewInstall
end

--- Sets the state for keeping a window open or closed.
--
-- @param boolean: boolean; The keep window state to set (true to keep the window open, false to allow it to close).
--
-- @return None
function Config.KeepWindow(boolean)
  Config.ModState.keepWindow = boolean
end

--- Sets the state for opening or closing a window.
--
-- @param boolean: boolean; The open window state to set (true to open the window, false to close it).
--
-- @return None
function Config.OpenWindow(boolean)
  Config.ModState.openWindow = boolean
end

--- Retrieves the masks controller from the global configuration.
--
-- @param None
--
-- @return masksController: string; The masks controller name.
function Config.GetMasksController()
  return Config.MaskingGlobal.masksController
end

--- Retrieves the Widgets table containing masks' widgets names from the global configuration.
--
-- @param None
--
-- @return Widgets: table; The Widgets table from the global masking configuration.
function Config.GetWidgets()
  return Config.MaskingGlobal.Widgets
end

--- Retrieves the Screen table containg current screen data from the global configuration.
--
-- @param None
--
-- @return Screen: table; The Screen table from the global configuration.
function Config.GetScreen()
  return Config.Screen
end

--- Checks if the player is currently mounted on a vehicle and updates the player isMounted state.
--
-- @param None
--
-- @return isMounted: boolean; True if the player is mounted on a vehicle, false otherwise.
function Config.IsMounted()
  local isMounted = Game['GetMountedVehicle;GameObject'](Game.GetPlayer())

  if isMounted then
    Config.PlayerState.isMounted  = true
  else
    Config.PlayerState.isMounted  = false
  end

  return Config.PlayerState.isMounted
end

----------

-- writes to WhiteBoard for the module name under a key if one is given -- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
function Config.WriteWhiteBoard(moduleName,contents,key)-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
  if moduleName and not contents then Config.Print("Can't write to the mod's WhiteBoard, check the code...",nil,nil,moduleName) end --debug-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
  if not moduleName or not contents then Config.Print("Can't write to the mod's WhiteBoard, check the code...") end --debug-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE

  local copiedContents = Config.Deepcopy(contents)-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE

  if key then-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
    WhiteBoard[moduleName] = WhiteBoard[moduleName] or {}-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
    WhiteBoard[moduleName][key] = copiedContents-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
  else
    WhiteBoard[moduleName] = copiedContents-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
  end
end

-- returns a table from WhiteBoard for the module name and key
function Config.GetWhiteBoard(moduleName,key)-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
  if WhiteBoard[moduleName] == nil then Config.Print("There's no pool in the mod's WhiteBoard for the given moduleName:",moduleName) end --debug-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
  if key and WhiteBoard[moduleName][key] == nil then Config.Print("There's no pool in the mod's WhiteBoard for the given module name and key:",moduleName,key) end --debug-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE

  if key then-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
    return WhiteBoard[moduleName][key]-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
  else-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
    return WhiteBoard[moduleName]-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
  end-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE
end-- TO BE DELETED ONCE PRESETS ARE ACCESSIBLE FROM THE PRESETS MODULE

----------

--- Sets a fallback value for a specified owner, optionally with a key.
-- This function stores a deep copy of the provided contents in the FallbackBoard,
-- either directly under the owner or nested under a specific key for that owner.
--
-- @param owner: string; The identifier for the fallback owner.
-- @param contents: any; The content to be stored as a fallback.
-- @param key: string; Optional. If provided, the contents are stored under this key for the owner.
--
-- @return None
function Config.SetFallback(owner,contents,key)
  if not contents or not owner then Config.Print("Can't set a fallback.") end

  local copiedContents = Config.Deepcopy(contents)

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
function Config.GetFallback(owner,key)
  if FallbackBoard[owner] == nil then Config.Print("There are no fallbacks for the owner:",owner) end --debug
  if key and FallbackBoard[owner] and FallbackBoard[owner][key] == nil then Config.Print("There is no fallback for the given key:",key,owner) end --debug

  if key then
    return FallbackBoard[owner][key]
  else
    return FallbackBoard[owner]
  end
end

--- Calculates and updates the screen aspect ratio, detecting changes.
--
-- @param None
--
-- @return aspectRatio: number; The current aspect ratio of the screen. Updates Config.Screen.isAspectRatioChange internally.
function Config.GetAspectRatio()
  local previousAspectRatio = Config.Screen.aspectRatio

  Config.Screen.Resolution.width, Config.Screen.Resolution.height = GetDisplayResolution();
  Config.Screen.aspectRatio = Config.Screen.Resolution.width / Config.Screen.Resolution.height

  if previousAspectRatio == 1 then return Config.Screen.aspectRatio end

  if Config.Screen.aspectRatio ~= previousAspectRatio then
    Config.Screen.isAspectRatioChange = true
    Config.SetModReady(false)
    Config.Print(LogText.config_aspectRatioChange,nil,nil,Config.__NAME)
  end

  return Config.Screen.aspectRatio
end

function Config.IsAspectRatioChange()
  return Config.Screen.isAspectRatioChange
end

function Config.ResetAspectRatioChange()
  Config.Screen.isAspectRatioChange = false
end

--- Determines and returns the screen type enum based on the current aspect ratio.
--
-- @param None
--
-- @return screenType: enum; Updates Config.Screen.type internally.
function Config.GetScreenType()
  local screenAspectRatio = Config.Screen.aspectRatio

  if screenAspectRatio < 1.5 then
    Config.Screen.type = 43
  elseif screenAspectRatio >= 1.5 and screenAspectRatio < 1.7 then
    Config.Screen.type = 1610
  elseif screenAspectRatio >= 1.7 and screenAspectRatio < 2.2 then
    Config.Screen.type = 169
  elseif screenAspectRatio >= 2.2 and screenAspectRatio < 3.4 then
    Config.Screen.type = 219
  elseif screenAspectRatio >= 3.4 then
    Config.Screen.type = 329
  end

  return Config.Screen.type
end

--- Retrieves the string name of the current screen type.
--
-- @param None
--
-- @return screenTypeName: string; Updates Config.Screen.typeName internally.
function Config.GetScreenTypeName()
  local screenType = Config.Screen.type

  if screenType == 169 then
    Config.Screen.typeName = "16:9"
  elseif screenType == 1610 then
    Config.Screen.typeName = "16:10"
  elseif screenType == 219 then
    Config.Screen.typeName = "21:9"
  elseif screenType == 329 then
    Config.Screen.typeName = "32:9"
  elseif screenType == 43 then
    Config.Screen.typeName = "4:3"
  end

  return Config.Screen.typeName
end

--- Determines and returns the screen width factor based on the current screen type.
--
-- @param None
--
-- @return widthFactor: number; Updates Config.Screen.Factor.width internally.
function Config.GetScreenWidthFactor()
  local screenType = Config.Screen.type

  if screenType == 169 or screenType == 1610 or screenType == 43 then
    Config.Screen.Factor.width = Config.Screen.Def.Factor.width
  elseif screenType == 219 then
    Config.Screen.Factor.width = 1.34
  elseif screenType == 329 then
    Config.Screen.Factor.width = 2
  end

  return Config.Screen.Factor.width
end

--- Calculates and returns the screen space dimensions based on the current screen type.
--
-- @param None
--
-- @return screenSpace: table; Updates Config.Screen.Space internally.
function Config.GetScreenSpace()
  local screenType = Config.Screen.type
  local screenResDef = Config.Screen.Def.Resolution
  local screenFactor = Config.Screen.Factor

  if screenType == 169 or screenType == 1610 or screenType == 43 then
    Config.Screen.Space.width = Config.Screen.Def.Space.width
  elseif screenType == 219 or screenType == 329 then
    Config.Screen.Space.width = screenResDef.width * screenFactor.width
  end

  return Config.Screen.Space
end


--- Determines and returns the screen edge coordinates based on the current screen type.
--
-- @param None
--
-- @return screenEdge: table; A table containing the screen edge coordinates: left (x-axis), right (x-axis), down (y-axis). Updates Config.Screen.Edge internally.
function Config.GetScreenEdge()
  local screenType = Config.Screen.type

  if screenType == 169 then
    Config.Screen.Edge.left = 0
    Config.Screen.Edge.right = 3840
    Config.Screen.Edge.down = 2160
  elseif screenType == 1610 then
    Config.Screen.Edge.left = 0
    Config.Screen.Edge.right = 3840
    Config.Screen.Edge.down = 2280
  elseif screenType == 219 then
    Config.Screen.Edge.left = -640
    Config.Screen.Edge.right = 4480
    Config.Screen.Edge.down = 2160
  elseif screenType == 329 then
    Config.Screen.Edge.left = -1920
    Config.Screen.Edge.right = 5760
    Config.Screen.Edge.down = 2160
  elseif screenType == 43 then
    Config.Screen.Edge.left = 0
    Config.Screen.Edge.right = 3840
    Config.Screen.Edge.down = 2640
  end

  return Config.Screen.Edge
end

-----------
-- On... handlers
-----------

function Config.OnInitialize()
  Config.GetModVersion()
  Config.GetAspectRatio()
  Config.GetScreenType()
  Config.GetScreenTypeName()
  Config.GetScreenEdge()
  Config.GetScreenWidthFactor()
  Config.GetScreenSpace()
end

function Config.OnOverlayOpen()
  Config.GetAspectRatio()
  Config.GetScreenType()
  Config.GetScreenTypeName()
  Config.GetScreenEdge()
  Config.GetScreenWidthFactor()
  Config.GetScreenSpace()
  Config.IsMounted()
end

function Config.OnOverlayClose()
  Config.GetAspectRatio()
  Config.GetScreenType()
  Config.GetScreenTypeName()
  Config.GetScreenEdge()
  Config.GetScreenWidthFactor()
  Config.GetScreenSpace()
end

return Config