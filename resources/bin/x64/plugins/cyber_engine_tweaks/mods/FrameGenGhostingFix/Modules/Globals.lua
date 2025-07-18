local Globals = {
  __NAME = "Globals",
  __VERSION = { 5, 2, 6 },
}

local isDebug = nil

local MaskingGlobal = {
  masksController = "frameGenGhostingFixMasksController",
  Widgets = {
    hedCorners = "horizontaledgedowncorners",
    hedFill = "horizontaledgedownfill",
    hedTracker = "horizontaledgedowntracker",
    mask1 = "mask1",
    mask2 = "mask2",
    mask3 = "mask3",
    mask4 = "mask4",
    blockerAimOnFoot = "blockerAimOnFoot",
    cornerDownLeft = "cornerDownLeftOnFoot",
    cornerDonwRight = "cornerDownRightOnFoot",
    vignette = "vignetteOnFoot",
    vignette_editor = "vignetteOnFoot_editor",
    vignetteAim = "vignetteAimOnFoot"
  }
}

local Screen = {
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
}

--stores exlusive fallbacks for any module
local FallbackBoard = {}

--stores active delays
local DelayBoard = {}

------------------
-- Globals' Local Debug Mode Setter
------------------

-- @param `isDebugMode`: boolean; Sets Globals' internal debug variable to `true` or `false`
--
-- @return None
function Globals.SetDebugMode(isDebugMode)
  isDebug = isDebugMode
end

------------------
-- Masking Global
------------------

-- @return string: the masks controller name
function Globals.GetMasksController()
  return MaskingGlobal.masksController
end

-- @return table; The Widgets table containing masks' widgets names from the mod's global masking configuration
function Globals.GetWidgetsTable()
  return MaskingGlobal.Widgets
end

-----------
-- Screen Configuration
-----------

-- @return table; The Screen table containg current screen info and configuration
function Globals.GetScreenTable()
  return Screen
end

-- @param None
--
-- @return number; The current aspect ratio of the screen. Updates `Screen.aspectRatio`, `Screen.isAspectRatioChange` and `Screen.Resolution` internally.
function Globals.GetAspectRatio()
  local previousAspectRatio = Screen.aspectRatio

  Screen.Resolution.width, Screen.Resolution.height = GetDisplayResolution();
  Screen.aspectRatio = Screen.Resolution.width / Screen.Resolution.height

  if previousAspectRatio == 1 then return Screen.aspectRatio end

  if Screen.aspectRatio ~= previousAspectRatio then
    Screen.isAspectRatioChange = true
    Globals.Print(Globals.__NAME, "The aspect ratio of the screen has changed. Please restart the game to ensure the mod will work as intended.")
  end

  return Screen.aspectRatio
end

function Globals.IsAspectRatioChange()
  return Screen.isAspectRatioChange
end

function Globals.ResetAspectRatioChange()
  Screen.isAspectRatioChange = false
end

-- @param `dimension`: string; Optional `width` or `height`, if not given, two numbers `width` and `height` are returned
--
-- @return number: Number of pixels for the given `dimension`, if not `dimension` then for `width` 
-- @return number: If not `dimension`, number for pixels for `height`
function Globals.GetScreenResolution(dimension)
  if not dimension then
    return Screen.Resolution.width, Screen.Resolution.height
  else
    return Screen.Resolution[dimension]
  end
end

-- @param None
--
-- @return enum; Updates `Screen.type` internally.
function Globals.GetScreenType()
  local screenAspectRatio = Screen.aspectRatio

  if screenAspectRatio < 1.5 then
    Screen.type = 43
  elseif screenAspectRatio >= 1.5 and screenAspectRatio < 1.7 then
    Screen.type = 1610
  elseif screenAspectRatio >= 1.7 and screenAspectRatio < 2.2 then
    Screen.type = 169
  elseif screenAspectRatio >= 2.2 and screenAspectRatio < 3.4 then
    Screen.type = 219
  elseif screenAspectRatio >= 3.4 then
    Screen.type = 329
  end

  return Screen.type
end

-- @param None
--
-- @return string; Updates `Screen.typeName` internally.
function Globals.GetScreenTypeName()
  local screenType = Screen.type

  if screenType == 169 then
    Screen.typeName = "16:9"
  elseif screenType == 1610 then
    Screen.typeName = "16:10"
  elseif screenType == 219 then
    Screen.typeName = "21:9"
  elseif screenType == 329 then
    Screen.typeName = "32:9"
  elseif screenType == 43 then
    Screen.typeName = "4:3"
  end

  return Screen.typeName
end

-- @param None
--
-- @return number; Returns the screen width factor based on the current screen type. Updates `Screen.Factor.width` internally.
function Globals.GetScreenWidthFactor()
  local screenType = Screen.type

  if screenType == 169 or screenType == 1610 or screenType == 43 then
    Screen.Factor.width = Screen.Def.Factor.width
  elseif screenType == 219 then
    Screen.Factor.width = 1.34
  elseif screenType == 329 then
    Screen.Factor.width = 2
  end

  return Screen.Factor.width
end

-- @param None
--
-- @return table; Returns the screen space dimensions based on the current screen type. Updates `Screen.Space` internally.
function Globals.GetScreenSpace()
  local screenType = Screen.type
  local screenResDef = Screen.Def.Resolution
  local screenFactor = Screen.Factor

  if screenType == 169 or screenType == 1610 or screenType == 43 then
    Screen.Space.width = Screen.Def.Space.width
  elseif screenType == 219 or screenType == 329 then
    Screen.Space.width = screenResDef.width * screenFactor.width
  end

  return Screen.Space
end

-- @param None
--
-- @return table; A table containing the screen edge coordinates: left (x-axis), right (x-axis), down (y-axis). Updates `Screen.Edge` internally.
function Globals.GetScreenEdge()
  local screenType = Screen.type
  local screenEdge = Screen.Edge

  if screenType == 169 then
    screenEdge.left = 0
    screenEdge.right = 3840
    screenEdge.down = 2160
  elseif screenType == 1610 then
    screenEdge.left = 0
    screenEdge.right = 3840
    screenEdge.down = 2280
  elseif screenType == 219 then
    screenEdge.left = -640
    screenEdge.right = 4480
    screenEdge.down = 2160
  elseif screenType == 329 then
    screenEdge.left = -1920
    screenEdge.right = 5760
    screenEdge.down = 2160
  elseif screenType == 43 then
    screenEdge.left = 0
    screenEdge.right = 3840
    screenEdge.down = 2640
  end

  return screenEdge
end

--- Scale the mod's widget/masks accordingly to the screen configuration
--
-- @param None
--
-- @return None
function Globals.ScaleWidgets()
  Game.GetPlayer():QueueEvent(FrameGenGhostingFixScaleWidgetsEvent.new())
end

------------------
-- Unviersal methods
------------------

------------------
-- Tables 

--- Creates a deep copy of the given contents. For non-table values, it returns the original value.
--
-- @param `contents`: any; The value to be deep copied.
--
-- @return table | contents; A deep copy of the input if it's a table, otherwise the input itself.
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
-- @param `mergeTo`: table; The destination table to merge into.
-- @param `mergeA`: table; The source table to merge from.
--
-- @return table; The updated destination `mergeTo` table after merging.
function Globals.SafeMergeTables(mergeTo, mergeA)
  if mergeA == nil then return mergeTo end

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
-- @param `mergeTo`: table; The destination table to merge into.
-- @param `mergeA`: table; The source table to merge from.
--
-- @return table; The updated destination `mergeTo` table after merging.
function Globals.MergeTables(mergeTo, mergeA)
  if mergeA == nil then return mergeTo end

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

--- Converts a table to a string representation.
--
-- @param `table`: table; The table to be converted to a string.
--
-- @return string: A string representation of the input table.
function Globals.TableToString(table)
  if table == nil then
    Globals.PrintDebug(Globals.__NAME, "[TableToString]", "Table is nil")
    return
  end

  local result = "{"

  for k, v in pairs(table) do
    if type(v) == "table" then
      result = result .. k .. " = " .. Globals.TableToString(v) .. ", "
    else
      result = result .. k .. " = " .. tostring(v) .. ", "
    end
  end

  -- Remove trailing comma and space
  return result:sub(1, -3) .. "}"
end

------------------
-- Printing

--- Prints a formatted message with an optional module name and variable number of content items.
--
-- @param `moduleName`: string | nil; The name of the module to be included in the output. If nil, no module name is printed: if only one item is given, no nil is needed (will print just the item without bracketing it as a module name).
-- @param `...`: any; Variable number of items to be printed as the content of the message. 
--
-- @return None
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
      return Globals.Print(Globals.__NAME, "No contents to print.")
  end

  for i, value in ipairs(contents) do
    contents[i] = tostring(value)
  end

  local concatenatedContents = table.concat(contents, " ")

  print(mod, module, concatenatedContents)
end

--- Prints a formatted debug message ONLY if debug mode is enabled. Offers an optional module name and variable number of content items. Prints to the mod's exlusive log file.
--
-- @param `moduleName`: string | nil; The name of the module to be included in the output. If nil, no module name is printed: if only one item is given, no nil is needed (will print just the item without bracketing it as a module name).
-- @param `...`: any; Variable number of items to be printed as the content of the message. 
--
-- @return None
function Globals.PrintDebug(moduleName, ...)
  if not isDebug then return end

  local modError = "[" .. FrameGenGhostingFix.__NAME .. "]" .. " [Debug]"
  local module = ""
  local contents

  if select('#', ...) == 0 then
    contents = {moduleName}
  else
    module = "[" .. tostring(moduleName) .. "]"
    contents = {...}
  end

  if #contents == 0 and module == "" then
      return print(modError, Globals.__NAME, "No debug contents to print.")
  end

  for i, value in ipairs(contents) do
    contents[i] = tostring(value)
  end

  local concatenatedContents = table.concat(contents, " ")
  local printContents = modError .. " " .. module .. " " .. concatenatedContents

  print(printContents)
  spdlog.error(printContents)
end

--- Prints a formatted error message with an optional module name and variable number of content items. Prints to the mod's exlusive log file.
--
-- @param `moduleName`: string | nil; The name of the module to be included in the output. If nil, no module name is printed: if only one item is given, no nil is needed (will print just the item without bracketing it as a module name).
-- @param `...`: any; Variable number of items to be printed as the content of the message. 
--
-- @return None
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

--- Prints the contents of a table, including nested tables.
--
-- @param `table`: table; The table to be printed.
--
-- @return None
function Globals.PrintTable(table)
  if table == nil then
    Globals.PrintDebug(Globals.__NAME, "[PrintTable]", "Table is nil")
    return
  end

  for k, v in pairs(table) do
    if type(v) == "table" then
      local tableAsString = k .. ": " .. Globals.TableToString(v)

      Globals.PrintDebug(tableAsString)
    else
      local tableAsString = k .. ": " .. tostring(v)

      Globals.PrintDebug(tableAsString)
    end
  end
end

------------------
-- Version check

-- @param `versionString`: string; The version string  (e.g. "5.0.0") to convert to a table of numbers.
--
-- @return table: A table containing the version numbers.
function Globals.VersionStringToTable(versionString)
  local versionTable = {}

  if type(versionString) ~= "string" or versionString == "" then
    Globals.PrintError(Globals.__NAME, "Invalid version string provided.")
    return versionTable
  end

  local numericPart = versionString:match("^(%d+[%.%d]*)") or ""

  for number in numericPart:gmatch("%d+") do
    table.insert(versionTable, tonumber(number))
  end

  return versionTable
end

--- Pads a version table to ensure it has 4 elements
--
-- @param `versionTable`: table; Input version table with 1 to 4 numbers
--
-- @return table: A new table with the original version numbers padded to 4 elements
function Globals.PadVersion(versionTable)
  local padded = {table.unpack(versionTable)}

  for i = #padded + 1, 4 do
    padded[i] = 0
  end

  return padded
end

--- Compares given version tables
--
-- @param `requiredVersionTable`: table; Max 4 numbers (major, minor, patch, revision)
-- @param `foundVersionTable`: table; Max 4 numbers (major, minor, patch, revision)
--
-- @return boolean: Returns true if the given `foundVersionTable` table is newer or equal, false otherwise.
function Globals.VersionCompare(requiredVersionTable, foundVersionTable)
  local reqVersion = Globals.PadVersion(requiredVersionTable)
  local foundVersion = Globals.PadVersion(foundVersionTable)

  for i = 1, 4 do
    if reqVersion[i] > foundVersion[i] then
      return false
    elseif reqVersion[i] < foundVersion[i] then
      return true
    end
  end

  return true
end

------------------
-- Fallbacks

--- Sets a fallback value for a specified owner, optionally with a key.
-- This function stores a deep copy of the provided contents in the FallbackBoard,
-- either directly under the owner or nested under a specific key for that owner.
--
-- @param `owner`: string; The identifier for the fallback owner.
-- @param `contents`: any; The content to be stored as a fallback.
-- @param `key`: string; Optional. If provided, the contents are stored under this `key` for the `owner`.
--
-- @return None
function Globals.SetFallback(owner, contents, key)
  if not contents or not owner then Globals.PrintError(Globals.__NAME, "Can't set a fallback.") end

  local copiedContents = Globals.Deepcopy(contents)

  if key then
    FallbackBoard[owner] = FallbackBoard[owner] or {}
    FallbackBoard[owner][key] = copiedContents
  else
    FallbackBoard[owner] = copiedContents
  end

  Globals.PrintDebug(Globals.__NAME, "A fallback created for:", owner)
end

--- Retrieves a fallback value for a specified owner, optionally with a key.
-- This function returns the fallback content stored in the FallbackBoard for a given owner,
-- either directly or from a specific key associated with that owner.
--
-- @param `owner`: string; The identifier for the fallback owner.
-- @param `key`: astring; Optional. If provided, retrieves the fallback content associated with this `key` for the `owner`.
--
-- @return any: The fallback content for the specified `owner` (and `key`, if provided). 
--                        Returns nil if no fallback is found.
function Globals.GetFallback(owner, key)
  if isDebug then
    if FallbackBoard[owner] == nil then Globals.PrintDebug(Globals.__NAME, "There are no fallbacks for the owner:", owner) end 
    if key and FallbackBoard[owner] and FallbackBoard[owner][key] == nil then Globals.PrintDebug(Globals.__NAME, "There is no fallback for the given key:", key, owner) end
  end

  if FallbackBoard[owner] == nil then return nil end
  if key and FallbackBoard[owner] and FallbackBoard[owner][key] == nil then return nil end

  if key then
    return FallbackBoard[owner][key]
  else
    return FallbackBoard[owner]
  end
end

------------------
-- Delays

-- @param `key`: string; A unique identifier for the delay to be cancelled.
--
-- @return None
function Globals.CancelDelay(key)
  if not key then Globals.PrintError(Globals.__NAME, "Cannot find a delay:", key) return end

  key = tostring(key)

  DelayBoard[key] = nil
end

-- @param `key`: string; A unique identifier for the delay to be found.
--
-- @return boolean: `true` if the delay exists in the moment
function Globals.IsDelay(key)
  if not key then Globals.PrintError(Globals.__NAME, "Cannot find a delay:", key) return false end

  key = tostring(key)

  if DelayBoard[key] == nil then return false end
  return true
end

-- @param `duration`: number; The duration of the delay in seconds.
-- @param `key`: string; A unique identifier for the delay.
-- @param `callback`: function; The function to be called when the delay expires.
-- @param `...`: any; Optional parameters to be passed to the callback function.
--
-- @return None
function Globals.SetDelay(duration, key, callback, ...)
  local parameters = {...}

  if not duration or not key or not callback then Globals.PrintError(Globals.__NAME, "Cannot set the delay. Check parameters.") return end

  key = tostring(key)

  DelayBoard[key] = {
    remainingTime = duration,
    callback = callback,
    parameters = parameters
  }

  -- Globals.PrintDebug(Globals.__NAME, "Set Delay:", duration, "for:", key)
end

-- @param `gameDeltaTime`: number;
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
      -- Globals.PrintDebug(Globals.__NAME, "Delay fired for:", key)
    end
  end

  for _, key in ipairs(delaysToRemove) do
    DelayBoard[key] = nil
  end
end

------------------
-- JSON

-- @param `filename`: string;
--
-- @return any | `nil`: `nil` if failed
function Globals.LoadJSON(filename)
  local content = {}

  if not string.find(filename, '%.json$') then
    filename = filename .. ".json"
  end

  local file = io.open(filename, "r")
  if file ~= nil then
    content = json.decode(file:read("*a"))
    file:close()

    return content
  else
    return nil
  end
end

-- @param `filename`: string;
-- @param `content`: any;
--
-- @return boolean: `true` if succeded, `false` otherwise
function Globals.SaveJSON(filename, content)
  if not string.find(filename, '%.json$') then
    filename = filename .. ".json"
  end

  content = json.encode(content)

  local file = io.open(filename, "w+")
  if file then
    file:write(content)
    file:close()

    Globals.PrintDebug(Globals.__NAME, "File saved:", filename)

    return true
  else
    return false
  end
end

------------------
-- Names

-- @param 'text': string;
--
-- @return boolean: `true` if the `text` string has only letters as characters
function Globals.AreLettersOnly(text)
  return not string.match(text, "[^%a]")
end

-- @param `filename`: string; The filename to be validated.
--
-- @return boolean, string | nil; Returns `true` if the filename is valid, or `false` and the invalid character if not valid.
function Globals.ValidateFileName(filename)
  if #filename == 0 then
    return false, ""
  end

  if not string.match(filename:sub(1,1), "^[a-zA-Z]$") then
    return false, filename:sub(1,1)
  end

  for i = 2, #filename do
    local char = filename:sub(i,i)

    if not string.match(char, "^[a-zA-Z0-9_-]$") then
      return false, char
    end
  end

  return true
end

------------------
-- On... registers
------------------

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
end

function Globals.OnOverlayClose()
  Globals.GetAspectRatio()
  Globals.GetScreenType()
  Globals.GetScreenTypeName()
  Globals.GetScreenEdge()
  Globals.GetScreenWidthFactor()
  Globals.GetScreenSpace()
  Globals.ScaleWidgets()
end

return Globals