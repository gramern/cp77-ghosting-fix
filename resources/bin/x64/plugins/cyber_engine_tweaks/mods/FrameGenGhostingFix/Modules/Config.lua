local Config = {
  __NAME = "Config",
  __EDITION = "IV",
  __VERSION = "4.9.0",
  __VERSION_NUMBER = 490,
  __VERSION_SUFFIX = nil,
  __VERSION_STATUS = nil,
  ModState = {
    isDebug = false,
    keepWindow = false,
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
    newController = "gameuiCrosshairContainerController",
    legacyController = "IronsightGameController",
    masksController = nil,
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
local UIText = Localization.UIText

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

function Config.GetModVersion()
  if Config.__VERSION_SUFFIX ~= nil then
    Config.__VERSION = Config.__VERSION .. Config.__VERSION_SUFFIX
  end

  if not Config.__VERSION_STATUS then return end
  Config.__VERSION = Config.__VERSION .. "-" .. Config.__VERSION_STATUS
end

function Config.SetDebug(boolean)
  Config.ModState.isDebug = boolean
end

function Config.IsDebug()
  return Config.ModState.isDebug
end

function Config.SetModReady(boolean)
  Config.ModState.isReady = boolean
end

function Config.IsModReady()
  return Config.ModState.isReady
end

function Config.SetFirstRun(boolean)
  Config.ModState.isFirstRun = boolean
  if not boolean then return end
  Config.SetNewInstall(true)
  Config.Print(LogText.config_firstRun,nil,nil,Config.__NAME)
end

function Config.IsFirstRun()
  return Config.ModState.isFirstRun
end

function Config.SetNewInstall(boolean)
  Config.ModState.isNewInstall = boolean
  if not boolean or Config.ModState.isFirstRun then return end
  Config.Print(LogText.config_newVersion,nil,nil,Config.__NAME)
end

function Config.IsNewInstall()
  return Config.ModState.isNewInstall
end

function Config.KeepWindow(boolean)
  Config.ModState.keepWindow = boolean
end

function Config.OpenWindow(boolean)
  Config.ModState.openWindow = boolean
end

function Config.GetMasksController()
  return Config.MaskingGlobal.masksController
end

function Config.GetLegacyController()
  return Config.MaskingGlobal.legacyController
end

function Config.GetWidgets()
  return Config.MaskingGlobal.Widgets
end

function Config.GetScreen()
  return Config.Screen
end

function Config.ApplyPlayerState()
  local isMounted = Game['GetMountedVehicle;GameObject'](Game.GetPlayer())

  if isMounted then
    Config.PlayerState.isMounted  = true
  else
    Config.PlayerState.isMounted  = false
  end
end

function Config.IsMounted()
  return Config.PlayerState.isMounted
end

-- writes to WhiteBoard for the module name under a key if one is given
function Config.WriteWhiteBoard(moduleName,contents,key)
  if moduleName and not contents then Config.Print("Can't write to the mod's WhiteBoard, check the code...",nil,nil,moduleName) end --debug
  if not moduleName or not contents then Config.Print("Can't write to the mod's WhiteBoard, check the code...") end --debug

  local copiedContents = Config.Deepcopy(contents)

  if key then
    WhiteBoard[moduleName] = WhiteBoard[moduleName] or {}
    WhiteBoard[moduleName][key] = copiedContents
  else
    WhiteBoard[moduleName] = copiedContents
  end
end

-- returns a table from WhiteBoard for the module name and key
function Config.GetWhiteBoard(moduleName,key)
  if WhiteBoard[moduleName] == nil then Config.Print("There's no pool in the mod's WhiteBoard for the given moduleName:",moduleName) end --debug
  if key and WhiteBoard[moduleName][key] == nil then Config.Print("There's no pool in the mod's WhiteBoard for the given module name and key:",moduleName,key) end --debug

  if key then
    return WhiteBoard[moduleName][key]
  else
    return WhiteBoard[moduleName]
  end
end

--sets a fallback for a module
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

--gets a fallback for the module if exists
function Config.GetFallback(owner,key)
  if FallbackBoard[owner] == nil then Config.Print("There are no fallbacks for the owner:",owner) end --debug
  if key and FallbackBoard[owner] and FallbackBoard[owner][key] == nil then Config.Print("There is no fallback for the given key:",key,owner) end --debug

  if key then
    return FallbackBoard[owner][key]
  else
    return FallbackBoard[owner]
  end
end

--get the game's aspect ratio
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

--get the current screen type
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

function Config.OnInitialize()
  Config.GetModVersion()
  Config.ApplyMasksController()
  Config.GetAspectRatio()
  Config.GetScreenType()
  Config.GetScreenTypeName()
  Config.GetScreenEdge()
  Config.GetScreenWidthFactor()
  Config.GetScreenSpace()
end

function Config.OnOverlayOpen()
  Localization = require("Modules/Localization")
  UIText = Localization.UIText

  Config.GetAspectRatio()
  Config.GetScreenType()
  Config.GetScreenTypeName()
  Config.GetScreenEdge()
  Config.GetScreenWidthFactor()
  Config.GetScreenSpace()
  Config.ApplyPlayerState()
  Config.ResetStatusBar()
end

function Config.OnOverlayClose()
  Config.GetAspectRatio()
  Config.GetScreenType()
  Config.GetScreenTypeName()
  Config.GetScreenEdge()
  Config.GetScreenWidthFactor()
  Config.GetScreenSpace()
end

function Config.ApplyMasksController()
  local newController = Config.MaskingGlobal.newController
  local legacyController = Config.MaskingGlobal.legacyController

  if newController and legacyController then
    Config.MaskingGlobal.masksController = newController
    if Config.__VERSION_SUFFIX then return end
    if not legacyController then return Config.SetModReady(false) end
    Config.MaskingGlobal.masksController = legacyController
  else
    Config.SetModReady(false)
    Config.Print(LogText.config_controllerMissing,nil,nil,Config.__NAME)
  end
end

--status bar logic
local Status = {
  bar = nil,
  previousBar = nil,
}

function Config.ResetStatusBar()
  local status = UIText.General.info_version .. " " .. Config.__VERSION

  Config.SetStatusBar(status)
end

function Config.SetStatusBar(string)
  if Status.previousBar == string then return end

  Status.bar = string

  Status.previousBar = Status.bar
end

function Config.GetStatusBar()
  return Status.bar
end

return Config