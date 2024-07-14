local UI = {
  __NAME = "UI",
  __VERSION_NUMBER = 500,
  Std = ImGui,
  Col = ImGuiCol,
  Cond = ImGuiCond,
  StyleVar = ImGuiStyleVar,
  WindowFlags = ImGuiWindowFlags,
  Ext = {

    Checkbox = {
      TextWhite = function(string, setting, toggle)
        ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
        setting, toggle = ImGui.Checkbox(string, setting)
        ImGui.PopStyleColor()

        return setting, toggle
      end,
    },

    OnItemHovered = {
      SetTooltip = function(string)
        if ImGui.IsItemHovered() then
          ImGui.SetTooltip(string)
        else
          ImGui.SetTooltip(nil)
        end
      end,
    },

    StatusBar = function(string)
      ImGui.Separator()
      ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)
      ImGui.Text(string)
      ImGui.PopStyleColor()
    end,

    -- string: string; wrap: boolean
    TextGreen = function(string, wrap)
      ImGui.PushStyleColor(ImGuiCol.Text, 0.2, 1, 0.2, 1)

      if wrap then
        ImGui.TextWrapped(string)
      else
        ImGui.Text(string)
      end

      ImGui.PopStyleColor()
    end,
    
    -- string: string; wrap: boolean
    TextRed = function(string, wrap)
      ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.2, 0.2, 1)

      if wrap then
        ImGui.TextWrapped(string)
      else
        ImGui.Text(string)
      end

      ImGui.PopStyleColor()
    end,
    
    -- string: string; wrap: boolean
    TextWhite = function(string, wrap)
      ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 1, 1)

      if wrap then
        ImGui.TextWrapped(string)
      else
        ImGui.Text(string)
      end

      ImGui.PopStyleColor()
    end,
  }
}

--[[
Returns a wrapped string for a specified number of characters
(the lineLength argument); doesn't draw text. Use for line
length control; otherwise use UI.Std.TextWrapped or a "true"
wrap boolean for a UI.Ext variant (e.g., UI.Ext.TextWhite).

string: string; lineLength: integer
]]
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

function UI.PopStyle()
  UI.Std.PopStyleColor(26)
  UI.Std.PopStyleVar(1)
end

return UI