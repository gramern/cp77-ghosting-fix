local UI = {
  __NAME = "UI",
  __VERSION = { 5, 0, 0 },
  -- Reference to the 'ImGui' class.
  Std = ImGui,
  -- Reference to the 'ImGuiCol' class.
  Col = ImGuiCol,
  -- Reference to the 'ImGuiCond' class.
  Cond = ImGuiCond,
  -- Reference to the 'ImGuiStyleVar' class.
  StyleVar = ImGuiStyleVar,
  -- Reference to the 'ImGuiWindowFlags' class.
  WindowFlags = ImGuiWindowFlags,
  -- Custom ImGui-based extension methods to draw items.
  Ext = {

    -- Custom ImGui.Checkbox methods.
    Checkbox = {
      --- Renders a checkbox with white text.
      --
      -- @param string: string; The label text for the checkbox.
      -- @param setting: boolean; The current state of the checkbox.
      -- @param toggle: boolean; The current toggle state.
      --
      -- @return setting: boolean; The updated state of the checkbox after user interaction.
      -- @return toggle: boolean; The toggle state (unchanged by this function).
      TextWhite = function(string, setting, toggle)
        ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
        setting, toggle = ImGui.Checkbox(string, setting)
        ImGui.PopStyleColor()

        return setting, toggle
      end,
    },

    -- Custom methods to perform on a hovered ImGui/UI item.
    OnItemHovered = {
      --- Sets a tooltip for the previously created ImGui/UI item.
      --
      -- @param string: string; The text to display in the tooltip.
      --
      -- @return None
      SetTooltip = function(string)
        if ImGui.IsItemHovered() and Globals.ModState.isHelp then
          ImGui.SetTooltip(string)
        else
          ImGui.SetTooltip(nil)
        end
      end,
    },

    --- Displays a status bar with white text proceeded by a separator.
    --
    -- @param string: string; The text to display in the status bar.
    --
    -- @return None
    StatusBar = function(string)
      ImGui.Separator()
      ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
      ImGui.Text(string)
      ImGui.PopStyleColor()
    end,

    --- Displays text in green color with an option for text wrapping.
    --
    -- @param string: string; The text to display in green.
    -- @param wrap: boolean; If true, the text will be wrapped; if false or nil, the text will be on a single line.
    --
    -- @return None
    TextGreen = function(string, wrap)
      ImGui.PushStyleColor(ImGuiCol.Text, 0.2, 1, 0.2, 1)

      if not wrap then
        ImGui.Text(string)
      else
        ImGui.TextWrapped(string)
      end

      ImGui.PopStyleColor()
    end,
    
    --- Displays text in red color with an option for text wrapping.
    --
    -- @param string: string; The text to display in red.
    -- @param wrap: boolean; If true, the text will be wrapped; if false or nil, the text will be on a single line.
    --
    -- @return None
    TextRed = function(string, wrap)
      ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.2, 0.2, 1)

      if not wrap then
        ImGui.Text(string)
      else
        ImGui.TextWrapped(string)
      end

      ImGui.PopStyleColor()
    end,
    
    --- Displays text in white color with an option for text wrapping.
    --
    -- @param string: string; The text to display in white.
    -- @param wrap: boolean; If true, the text will be wrapped; if false or nil, the text will be on a single line.
    --
    -- @return None
    TextWhite = function(string, wrap)
      ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)

      if not wrap then
        ImGui.Text(string)
      else
        ImGui.TextWrapped(string)
      end

      ImGui.PopStyleColor()
    end,

    --- Displays text in a custom color, with an option for text wrapping.
    --
    -- @param string: string; The text to display.
    -- @param red: number; The red component of the text color (0.0 to 1.0).
    -- @param green: number; The green component of the text color (0.0 to 1.0).
    -- @param blue: number; The blue component of the text color (0.0 to 1.0).
    -- @param alpha: number; The alpha (opacity) component of the text color (0.0 to 1.0).
    -- @param wrap: boolean; If true, the text will be wrapped; if false or nil, the text will be on a single line.
    --
    -- @return None
    TextColor = function(string, red, green, blue, alpha, wrap)
      if not red and not green and not blue and not alpha then ImGui.Text("ERROR: Text's color isn't defined.") return end
      ImGui.PushStyleColor(ImGuiCol.Text, red, green, blue, alpha)

      if not wrap then
        ImGui.Text(string)
      else
        ImGui.TextWrapped(string)
      end

      ImGui.PopStyleColor()
    end,
  }
}

local Localization = require("Modules/Localization")

local UIText = Localization.UIText


-----------
-- Unviersal methods
-----------

--- Wraps text to a specified line length. Doesn't draw text. Use for the line's length control only, otherwise use boolean wrap for UI.Ext methods.
--
-- @param string: string; The text to be wrapped.
-- @param lineLength: string; The maximum number of characters allowed per line.
--
-- @return string; The input text wrapped to the specified line length.
function UI.WrapText(string, lineLength)
  local wrappedString = ""
  local line = ""

  for word in string:gmatch("%S+") do
    if #line + #word + 1 > lineLength then
      wrappedString = wrappedString .. line .. "\n"
      line = word
    else
      if #line > 0 then
        line = line .. " "
      end
      
      line = line .. word
    end
  end

  wrappedString = wrappedString .. line

  return wrappedString
end

-----------
-- Status bar logic
-----------

-- Table to store current text of the mod's status bar.
local Status = {
  bar = nil,
  previousBar = nil,
}

--- Resets the status bar to display the default state: the mod's version information.
--
-- @param None
--
-- @return None
function UI.ResetStatusBar()
  local status = UIText.General.info_version .. " " .. FrameGenGhostingFix.__VERSION_STRING

  UI.SetStatusBar(status)
end

--- Sets the text of the mod's status bar, updating only if the new text is different from the previous.
--
-- @param string: string; The new text to display in the status bar.
--
-- @return None
function UI.SetStatusBar(string)
  if Status.previousBar == string then return end

  Status.bar = string

  Status.previousBar = Status.bar
end

--- Retrieves the current text displayed in the status bar.
--
-- @param None
--
-- @return string; The current text displayed in the status bar.
function UI.GetStatusBar()
  return Status.bar
end

-----------
-- OnDraw methods
-----------

--- Pushes the mod's style to the UI elements.
--
-- @param None
--
-- @return None
function UI.PushStyle()
  UI.Std.PushStyleVar(UI.StyleVar.WindowMinSize, 300, 100)
  UI.Std.PushStyleColor(UI.Col.Button, 1, 0.78, 0, 1)
  UI.Std.PushStyleColor(UI.Col.ButtonHovered, 1, 0.85, 0.31, 1)
  UI.Std.PushStyleColor(UI.Col.ButtonActive, 0.73, 0.56, 0, 1)
  UI.Std.PushStyleColor(UI.Col.CheckMark, 0, 0, 0, 1)
  UI.Std.PushStyleColor(UI.Col.FrameBg, 1, 0.78, 0, 1)
  UI.Std.PushStyleColor(UI.Col.FrameBgHovered, 1, 0.85, 0.31, 1)
  UI.Std.PushStyleColor(UI.Col.FrameBgActive, 0.74, 0.58, 0, 1)
  UI.Std.PushStyleColor(UI.Col.Header, 1, 0.78, 0, 1)
  UI.Std.PushStyleColor(UI.Col.HeaderHovered, 1, 0.85, 0.31, 1)
  UI.Std.PushStyleColor(UI.Col.HeaderActive, 1, 0.78, 0, 1)
  UI.Std.PushStyleColor(UI.Col.PopupBg, 0.73, 0.56, 0, 1)
  UI.Std.PushStyleColor(UI.Col.ResizeGrip, 0.78, 0.612, 0, 1)
  UI.Std.PushStyleColor(UI.Col.ResizeGripHovered, 1, 0.85, 0.31, 1)
  UI.Std.PushStyleColor(UI.Col.ResizeGripActive, 0.73, 0.56, 0, 1)
  UI.Std.PushStyleColor(UI.Col.SliderGrab, 0.73, 0.56, 0, 1)
  UI.Std.PushStyleColor(UI.Col.SliderGrabActive, 1, 0.85, 0.31, 1)
  UI.Std.PushStyleColor(UI.Col.Tab, 0.73, 0.56, 0, 1)
  UI.Std.PushStyleColor(UI.Col.TabHovered, 1, 0.85, 0.31, 1)
  UI.Std.PushStyleColor(UI.Col.TabActive, 1, 0.78, 0, 1)
  UI.Std.PushStyleColor(UI.Col.TabUnfocused, 0.73, 0.56, 0, 1)
  UI.Std.PushStyleColor(UI.Col.TabUnfocusedActive, 0.73, 0.56, 0, 1)
  UI.Std.PushStyleColor(UI.Col.Text, 0, 0, 0, 1)
  UI.Std.PushStyleColor(UI.Col.TitleBg, 0.73, 0.56, 0, 1)
  UI.Std.PushStyleColor(UI.Col.TitleBgActive, 1, 0.78, 0, 1)
  UI.Std.PushStyleColor(UI.Col.TitleBgCollapsed, 0.73, 0.56, 0, 1)
  UI.Std.PushStyleColor(UI.Col.WindowBg, 0, 0, 0, 0.75)
end

--- Pops the mod's style to the UI elements.
--
-- @param None
--
-- @return None
function UI.PopStyle()
  UI.Std.PopStyleColor(26)
  UI.Std.PopStyleVar(1)
end

-----------
-- On... handlers
-----------

function UI.OnOverlayOpen()
  -- Refresh UIText reference
  Localization = require("Modules/Localization")
  UIText = Localization.UIText

  UI.ResetStatusBar()
end

return UI