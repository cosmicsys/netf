--// MURDER MYSTERY 2 ESP
--// Features: Toggles GUI, ESP for Sheriff and Murderer
--// Usage: Load with `loadModule("mm2.lua")` in your executor console.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ESP_ACTIVE = false
local ESP_GUIS = {} -- Store ESP BillboardGuis

local function createESP(player, color, roleText)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local rootPart = char.HumanoidRootPart
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 150, 0, 50)
    billboardGui.Adornee = rootPart
    billboardGui.AlwaysOnTop = true
    billboardGui.ExtentsOffset = Vector3.new(0, 4, 0) -- Adjust height above player
    billboardGui.Enabled = ESP_ACTIVE
    billboardGui.Name = "MM2_ESP_" .. player.Name
    billboardGui.Parent = char -- Parent to character to clean up on death/respawn

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = color
    frame.BackgroundTransparency = 0.7
    frame.BorderSizePixel = 0
    frame.Parent = billboardGui

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = player.Name .. "
" .. roleText
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 18
    textLabel.Parent = frame
    
    ESP_GUIS[player] = billboardGui
end

local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player == Players.LocalPlayer then continue end

        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            if ESP_GUIS[player] then
                ESP_GUIS[player]:Destroy()
                ESP_GUIS[player] = nil
            end
            continue
        end

        local role = "Innocent" -- Default role

        -- Attempt to find role - common MM2 role detection
        -- This might need adjustment based on specific MM2 game version
        if char:FindFirstChild("Sheriff") then
            role = "Sheriff"
        elseif char:FindFirstChild("Murderer") then
            role = "Murderer"
        -- You might need to inspect the game for more specific role indicators
        -- e.g., if player.Character:FindFirstChild("Status") and player.Character.Status.Value == "Sheriff"
        end

        local existingEsp = ESP_GUIS[player]
        if role == "Sheriff" or role == "Murderer" then
            local color = (role == "Sheriff" and Color3.fromRGB(0, 150, 255)) or Color3.fromRGB(255, 0, 0)
            if not existingEsp then
                createESP(player, color, role)
            else
                existingEsp.Enabled = ESP_ACTIVE
                local frame = existingEsp:FindFirstChildOfClass("Frame")
                if frame then frame.BackgroundColor3 = color end
                local label = existingEsp:FindFirstChildOfClass("TextLabel")
                if label then label.Text = player.Name .. "
" .. role end
                existingEsp.Adornee = char.HumanoidRootPart -- Update adornee in case character changed
            end
        else
            -- If no longer Sheriff/Murderer, destroy their ESP
            if existingEsp then
                existingEsp:Destroy()
                ESP_GUIS[player] = nil
            end
        end
    end

    -- Clean up ESP for players who left
    for player, gui in pairs(ESP_GUIS) do
        if not player.Parent then -- Player left the game
            gui:Destroy()
            ESP_GUIS[player] = nil
        end
    end
end

-- GUI Toggle Button
local gui = Instance.new("ScreenGui")
gui.Name = "MM2_ESP_GUI"
gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0.5, -60, 0, 50)
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.Text = "ESP: OFF"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 16
toggleButton.Parent = gui

toggleButton.MouseButton1Click:Connect(function()
    ESP_ACTIVE = not ESP_ACTIVE
    toggleButton.Text = "ESP: " .. (ESP_ACTIVE and "ON" or "OFF")
    
    for _, espGui in pairs(ESP_GUIS) do
        espGui.Enabled = ESP_ACTIVE
    end
    updateESP() -- Immediate update to reflect toggle
end)

-- Initial update and continuous loop
updateESP()
Players.PlayerAdded:Connect(updateESP)
Players.PlayerRemoving:Connect(updateESP)
RunService.Heartbeat:Connect(updateESP) -- Continuously update positions and roles
