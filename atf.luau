-- AutoFarmLevels_Script.luau (HHxScripts) --
local ws, plrs, tws, rs, repls
ws = game:GetService("Workspace")
plrs = game:GetService("Players")
tws = game:GetService("TweenService")
rs = game:GetService("RunService")
repls = game:GetService("ReplicatedStorage")

local plr, _type, _enemies
plr = plrs.LocalPlayer
_type = type or typeof
_enemies = ws:WaitForChild("Enemies")

local _scriptdata, _twdata = {
    is_alive = true,
    noclip = true,
    is_running = false,
    has_monster = false,
    tw_speed = 250,
    monster = "none"
}, nil

local autofarm_info, value = loadstring(game:HttpGet("https://raw.githubusercontent.com/HoangHienXScripts/Scripts/refs/heads/chocolate/BloxFruits/B.luau"))(), {maxv = math.huge}

function expand_farm_info(table_input)
    local expanded_info = {}
    local level_keys = {}
    for level, _ in pairs(table_input) do
        table.insert(level_keys, tonumber(level))
    end
    table.sort(level_keys)
    local last_quest = nil
    local max_level = level_keys[#level_keys]
    for i = 1, max_level do
        for _, level in ipairs(level_keys) do
            local quest = table_input[tostring(level)]
            if i >= level then
                last_quest = quest
            end
        end
        if last_quest then
            expanded_info[tostring(i)] = {
                QuestName = last_quest["QuestName"],
                QuestNumber = last_quest["QuestNumber"],
                QuestNPC = last_quest["QuestNPC"],
                QuestWaitingSpots = last_quest["QuestWaitingSpots"],
                NPC_Count = last_quest["NPC_Count"]
            }
        end
    end
    return expanded_info
end

function _return_nearest_npc(_name)
    local near, mhuge, inrange, range = nil, math.huge, 1000
    for _, mobs in pairs(_enemies:GetChildren()) do
        if mobs:IsA("Model") and mobs.Name:match(_name) and mobs:FindFirstChild("HumanoidRootPart") then
            range = (plr.Character.HumanoidRootPart.Position - mobs.HumanoidRootPart.Position).magnitude
            if range < mhuge and range <= inrange then
                mhuge = range
                near = mobs
            end
        end
    end
    return near
end

function _canstopnow()
    if _twdata ~= nil then 
        _twdata:Cancel()
        _twdata = nil
    end
end

function _tweentopos(pos : Vector3)
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp and not hrp:FindFirstChild("__Float") then
        local bodyfloat = Instance.new("BodyVelocity", hrp)
        bodyfloat.Name = "__Float"
        bodyfloat.Velocity = Vector3.new(0, 0, 0)
        bodyfloat.MaxForce = Vector3.new(value.maxv, value.maxv, value.maxv)
    end 
    if _scriptdata.noclip then
        for _, base in pairs(plr.Character:GetChildren()) do
            if base:IsA("BasePart") then base.CanCollide = false end
        end
    end _twdata = tws:Create(hrp, TweenInfo.new((pos - hrp.Position).magnitude / _scriptdata.tw_speed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0), {
        CFrame = CFrame.new(pos)
    }) _twdata:Play()
end

function _toeachposition(waitspot)
    if not _scriptdata.is_running then 
        _scriptdata.is_running = true
        local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local index = 1
            local function _movingnext()
                if not _scriptdata.has_monster then
                    if index > #waitspot then 
                        return 
                    end
                    _tweentopos(waitspot[index])
                    _twdata.Completed:Wait() 
                    index += 1
                    wait(2.5) 
                    _movingnext()
                end
            end
            _movingnext()
        end 
        _scriptdata.is_running = false
    end
end

function _pickup_quest(pos, name, line)
    _canstopnow() _tweentopos(pos) 
    if (pos - plr.Character.HumanoidRootPart.Position).magnitude <= 50 then
        wait(2)
        repls.Remotes.CommF_:InvokeServer("StartQuest", name, line)
    end
end

function _cancelquest(name)
    local uivis = plr.PlayerGui.Main.Quest
    if uivis.Visible == true and uivis.Container.QuestTitle.Title.Text:match(name) then
        _scriptdata.monster = name
    else
        if uivis.Visible == true then
            repls.Remotes.CommF_:InvokeServer("AbandonQuest")
        end
    end
end

function _startfarm(t)
    local _questname, _whichquest, _npcpos, _waitingpos, _taskcount
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if _scriptdata.is_alive then
        if _type(plr.Data.Level.Value) == "number" then
            local own_level = plr.Data.Level.Value
            for _lvlcap, value in pairs(t) do
                if own_level == tonumber(_lvlcap) then
                    _questname = value["QuestName"]
                    _whichquest = value["QuestNumber"]
                    _npcpos = value["QuestNPC"]
                    _waitingpos = value["QuestWaitingSpots"]
                    _taskcount = value["NPC_Count"]
                end
            end
        end
        if plr.PlayerGui.Main.Quest.Visible ~= true then
            local npcposition_packed = Vector3.new(_npcpos[1], _npcpos[2], _npcpos[3])
            if hrp and (npcposition_packed - hrp.Position).magnitude > 5 then
                _pickup_quest(npcposition_packed, _questname, _whichquest)
            end
        else
            local nearest_monster = _return_nearest_npc(_taskcount)
            if nearest_monster ~= nil then _cancelquest(_taskcount)
                _scriptdata.has_monster = true
                if nearest_monster.Humanoid.Health > 0 then
                    _canstopnow()
                    _tweentopos(nearest_monster.HumanoidRootPart.Position + Vector3.new(0, 25, 0))
                else
                    nearest_monster.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position + Vector3.new(0, 900, 0))
                end
            else 
                _scriptdata.has_monster = false
                _toeachposition(_waitingpos)
            end
        end
    end
end

_G._FarmActivated = _G._FarmActivated or false
local final_info = expand_farm_info(autofarm_info) task.wait()
rs.RenderStepped:Connect(function()
    if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
        if not _scriptdata.is_alive then
            _scriptdata.is_alive = true
        end
        if _G._FarmActivated then _startfarm(final_info) else _canstopnow() end
    else
        if _scriptdata.is_alive then
            _scriptdata.is_alive = false
        end
    end
end) -- 2nd.1 Version, Fixed by HoangHien, also Create by HoangHien :D --
