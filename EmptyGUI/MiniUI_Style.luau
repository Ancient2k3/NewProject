-- MiniUI:("Script", {"HHxScripts_Rework", "true"}) --
local _ws, _plrs, _rpls, _rs, _mkps, _core
_ws = game:GetService("Workspace")
_plrs = game:GetService("Players")
_rpls = game:GetService("ReplicatedStorage")
_rs = game:GetService("RunService")
_mkps = game:GetService("MarketplaceService")
_core = game:GetService("CoreGui")

local _screenui, _blackdragf, _mainstuff, _openui, _lockbutton, _switchingpage
_screenui = Instance.new("ScreenGui", _core)
_blackdragf = Instance.new("Frame", _screenui)
_mainstuff = Instance.new("ScrollingFrame", _blackdragf)
_openui = Instance.new("TextButton", _blackdragf)
_lockbutton = Instance.new("TextButton", _blackdragf)
_switchingpage = Instance.new("TextButton", _blackdragf)

_screenui.Name = "KingLegacyEXP_UIRework"
_blackdragf.Name = "_SimiliarDragF"
_mainstuff.Name = "_MainScroll"
_openui.Name = "_OpenClosedUI"
_lockbutton.Name = "_lockUI"
_switchingpage.Name = "_JOBIS"

local _variables, _func = {
    is_hide = false,
    is_locked = false,
    set_page = 0
}, {
    mb1c = function(t, script) t.MouseButton1Click:Connect(script) end
}

_blackdragf.BackgroundTransparency = 0
_blackdragf.BackgroundColor3 = Color3.new(0, 0, 0)
_blackdragf.Position = UDim2.new(0.65, 0, -0.1, 0)
_blackdragf.Size = UDim2.new(0.2, 0, 0.05, 0)
_blackdragf.Active = true
_blackdragf.Draggable = true
_blackdragf.Visible = true

_mainstuff.BackgroundTransparency = 0.5
_mainstuff.BackgroundColor3 = Color3.new(0, 0, 0)
_mainstuff.Position = UDim2.new(0, 0, 1, 0)
_mainstuff.Size = UDim2.new(1, 0, 4.95, 0)
_mainstuff.CanvasSize = UDim2.new(0, 0, 0, 0)
_mainstuff.ScrollBarThickness = 0.1
_mainstuff.Visible = false

_openui.BackgroundTransparency = 0
_openui.BackgroundColor3 = Color3.new(1, 1, 1)
_openui.Position = UDim2.new(0.02, 0, 0.1, 0)
_openui.Size = UDim2.new(0.6, 0, 0.8, 0)
_openui.TextScaled = true
_openui.TextSize = 12
_openui.TextColor3 = Color3.new(1, 0, 1)
_openui.Font = Enum.Font.Code
_openui.Text = _mkps:GetProductInfo(game.PlaceId).Name or "Error: Can't Find Name"
_openui.Visible = true

_lockbutton.BackgroundTransparency = 0
_lockbutton.BackgroundColor3 = Color3.new(1, 1, 1)
_lockbutton.Position = UDim2.new(0.65, 0, 0.1, 0)
_lockbutton.Size = UDim2.new(0.15, 0, 0.8, 0)
_lockbutton.TextScaled = true
_lockbutton.TextSize = 12
_lockbutton.TextColor3 = Color3.new(0, 1, 0)
_lockbutton.Font = Enum.Font.Code
_lockbutton.Text = "Lock"
_lockbutton.Visible = true

_switchingpage.BackgroundTransparency = 0.5
_switchingpage.BackgroundColor3 = Color3.new(1, 1, 1)
_switchingpage.Position = UDim2.new(0, 0, 6.25, 0)
_switchingpage.Size = UDim2.new(1, 0, 0.8, 0)
_switchingpage.TextScaled = true
_switchingpage.TextSize = 12
_switchingpage.TextColor3 = Color3.new(1, 1, 1)
_switchingpage.Font = Enum.Font.Code
_switchingpage.Text = "<< MAIN >>"
_switchingpage.Visible = false

function _hideframe()
    _mainstuff.Visible = false
end

_func.mb1c(_openui, function()
    if not _variables.is_hide then _variables.is_hide = true
        _switchingpage.Visible = true
        if _variables.set_page == 0 then
            _mainstuff.Visible = true
            _switchingpage.Text = "<< MAIN >>"
        end
    else _variables.is_hide = false
        _switchingpage.Visible = false
        _hideframe()
    end
end)

_func.mb1c(_lockbutton, function()
    if not _variables.is_locked then _variables.is_locked = true
        if _blackdragf.Draggable ~= false then
            _lockbutton.Text = "Locked"
            _blackdragf.Draggable = false
        end
    else _variables.is_locked = false
        if not _blackdragf.Draggable ~= false then
            _lockbutton.Text = "Lock"
            _blackdragf.Draggable = true
        end
    end
end)
