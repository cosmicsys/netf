--// ITEM ESP SCRIPT
--// Features: ESPs players holding "gun" or "knife" items, togglable GUI.
--// Ignores teams.
--// Usage: Load with `loadModule("item_esp.lua")` in your executor console.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local ESP_ACTIVE = false
local ESP_GUIS = {} -- Store ESP BillboardGuis

-- Items to look for
local TARGET_ITEMS = {
    "gun",
    "knife"
}

local function createESP(player, color, itemFound)
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end

    local rootPart = char.HumanoidRootPart
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 150, 0, 50)
    billboardGui.Adornee = rootPart
    billboardGui.AlwaysOnTop = true
    billboardGui.ExtentsOffset = Vector3.new(0, 4, 0) -- Adjust height above player
    billboardGui.Enabled = ESP_ACTIVE
    billboardGui.Name = "ITEM_ESP_" .. player.Name
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
" .. itemFound
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 18
    textLabel.Parent = frame
    
    ESP_GUIS[player] = billboardGui
end

local function hasTargetItem(player)
    local char = player.Character
    local backpack = player:FindFirstChildOfClass("Backpack")

    local function checkContainer(container)
        if container then
            for _, child in pairs(container:GetDescendants()) do
                if table.find(TARGET_ITEMS, string.lower(child.Name)) then
                    return child.Name -- Return the name of the found item
                end
            end
        end
        return nil
    end

    local itemInChar = checkContainer(char)
    if itemInChar then return itemInChar end

    local itemInBackpack = checkContainer(backpack)
    if itemInBackpack then return itemInBackpack end

    return nil
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

        local itemFound = hasTargetItem(player)
        local existingEsp = ESP_GUIS[player]

        if itemFound then
            local color = Color3.fromRGB(255, 255, 0) -- Yellow for items
            if not existingEsp then
                createESP(player, color, itemFound)
            else
                existingEsp.Enabled = ESP_ACTIVE
                local frame = existingEsp:FindFirstChildOfClass("Frame")
                if frame then frame.BackgroundColor3 = color end
                local label = existingEsp:FindFirstChildOfClass("TextLabel")
                if label then label.Text = player.Name .. "
" .. itemFound end
                existingEsp.Adornee = char.HumanoidRootPart
            end
        else
            -- If no longer has item, destroy their ESP
            if existingEsp then
                existingEsp:Destroy()
                ESP_GUIS[player] = nil
            end
        end
    end

    -- Clean up ESP for players who left
    for player, gui in pairs(ESP_GUIS) do
        if not player.Parent then
            gui:Destroy()
            ESP_GUIS[player] = nil
        end
    end
end

-- GUI Toggle Button
local gui = Instance.new("ScreenGui")
gui.Name = "ITEM_ESP_GUI"
gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 40)
toggleButton.Position = UDim2.new(0.5, -60, 0, 100) -- Position slightly lower than MM2 ESP
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.Text = "ITEM ESP: OFF"
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 16
toggleButton.Parent = gui

toggleButton.MouseButton1Click:Connect(function()
    ESP_ACTIVE = not ESP_ACTIVE
    toggleButton.Text = "ITEM ESP: " .. (ESP_ACTIVE and "ON" or "OFF")
    
    for _, espGui in pairs(ESP_GUIS) do
        espGui.Enabled = ESP_ACTIVE
    end
    updateESP() -- Immediate update to reflect toggle
end)

-- Initial update and continuous loop
updateESP()
Players.PlayerAdded:Connect(updateESP)
Players.PlayerRemoving:Connect(updateESP)
RunService.Heartbeat:Connect(updateESP) -- Continuously update positions and items
