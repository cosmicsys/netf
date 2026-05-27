--// Speed car modify | Cosmic Elite Edition
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

--// CLEANUP PREVIOUS
if CoreGui:FindFirstChild("CosmicEliteGUI") then
    CoreGui.CosmicEliteGUI:Destroy()
end

--// GUI SETUP
local gui = Instance.new("ScreenGui")
gui.Name = "CosmicEliteGUI"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

--// MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.5, -110, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(12, 5, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.ClipsDescendants = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

--// TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "COSMIC ELITE SPEED"
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextColor3 = Color3.fromRGB(180, 130, 255)
title.Parent = frame

--// THE TOGGLE BUTTON
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.85, 0, 0, 35)
button.Position = UDim2.new(0.075, 0, 0.3, 0)
button.BackgroundColor3 = Color3.fromRGB(20, 10, 40)
button.Text = "OFF"
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.TextColor3 = Color3.fromRGB(180, 130, 255)
button.ZIndex = 10
button.Parent = frame
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)

--// SPEED INPUT
local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.85, 0, 0, 30)
speedInput.Position = UDim2.new(0.075, 0, 0.65, 0)
speedInput.BackgroundColor3 = Color3.fromRGB(8, 4, 15)
speedInput.Text = "200"
speedInput.PlaceholderText = "Elite Multiplier"
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 14
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Parent = frame
Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 8)

--// ⭐ COSMIC STARS (Enhanced)
for i = 1, 20 do
    local star = Instance.new("Frame")
    local size = math.random(1, 3)
    star.Size = UDim2.new(0, size, 0, size)
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    star.BorderSizePixel = 0
    star.BackgroundTransparency = 0.5
    star.ZIndex = 5
    star.Parent = frame
    Instance.new("UICorner", star).CornerRadius = UDim.new(1, 0)
    
    local baseX, baseY = star.Position.X.Scale, star.Position.Y.Scale
    local radius, speed, t = math.random(0.01, 0.05), 0.2 + math.random(), math.random() * 10
    RunService.RenderStepped:Connect(function()
        if not star.Parent then return end
        t += speed * 0.02
        star.Position = UDim2.new(baseX + math.cos(t) * radius, 0, baseY + math.sin(t * 0.7) * radius, 0)
    end)
end

--// TOGGLE LOGIC
local toggled = false
local currentSpeed = 200

local function onToggle()
    toggled = not toggled
    if toggled then
        button.Text = "ACTIVE"
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(80, 40, 140)}):Play()
        TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(25, 10, 50)}):Play()
    else
        button.Text = "OFF"
        button.TextColor3 = Color3.fromRGB(180, 130, 255)
        TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(20, 10, 40)}):Play()
        TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(12, 5, 25)}):Play()
    end
end

button.MouseButton1Click:Connect(onToggle)

speedInput.FocusLost:Connect(function()
    currentSpeed = tonumber(speedInput.Text) or 200
    speedInput.Text = tostring(currentSpeed)
end)

--// 🚀 ELITE HYBRID SPEED LOGIC
RunService.Heartbeat:Connect(function()
    if not toggled then return end
    
    local char = Players.LocalPlayer.Character
    if not char then return end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    local seat = hum.SeatPart
    if not seat or not (seat:IsA("VehicleSeat") or seat:IsA("Seat")) then return end
    
    -- Hybrid Method 1: Assembly Linear Velocity (Physical)
    if seat.Throttle ~= 0 then
        local push = seat.CFrame.LookVector * (currentSpeed / 10)
        seat.AssemblyLinearVelocity = seat.AssemblyLinearVelocity + push
        
        -- Hybrid Method 2: Property Overrides (Engine-based)
        pcall(function()
            if seat:IsA("VehicleSeat") then
                seat.MaxSpeed = 9e9
                seat.Torque = 9e9
            end
        end)
        
        -- Hybrid Method 3: CFrame Step (Bypass-focused)
        seat.CFrame = seat.CFrame + (seat.CFrame.LookVector * (currentSpeed / 150))
    end
end)

--// 🚀 DRAG SYSTEM (Improved)
local dragging, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
end)
