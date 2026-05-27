--// Speed car modify | Cosmic Edition
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

--// CLEANUP PREVIOUS
if CoreGui:FindFirstChild("CosmicSpeedGUI") then
    CoreGui.CosmicSpeedGUI:Destroy()
end

--// GUI SETUP
local gui = Instance.new("ScreenGui")
gui.Name = "CosmicSpeedGUI"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

--// MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 110)
frame.Position = UDim2.new(0.5, -100, 0.5, -55)
frame.BackgroundColor3 = Color3.fromRGB(15, 5, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

--// TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 25)
title.BackgroundTransparency = 1
title.Text = "COSMIC SPEED"
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextColor3 = Color3.fromRGB(200, 150, 255)
title.Parent = frame

--// THE TOGGLE BUTTON
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0, 30)
button.Position = UDim2.new(0.1, 0, 0.3, 0)
button.BackgroundColor3 = Color3.fromRGB(25, 10, 45)
button.Text = "OFF"
button.Font = Enum.Font.GothamBold
button.TextSize = 16
button.TextColor3 = Color3.fromRGB(200, 150, 255)
button.ZIndex = 10
button.Parent = frame
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

--// SPEED INPUT
local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.8, 0, 0, 25)
speedInput.Position = UDim2.new(0.1, 0, 0.65, 0)
speedInput.BackgroundColor3 = Color3.fromRGB(10, 5, 20)
speedInput.Text = "200"
speedInput.PlaceholderText = "Multiplier"
speedInput.Font = Enum.Font.Gotham
speedInput.TextSize = 14
speedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
speedInput.Parent = frame
Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 6)

--// ⭐ COSMIC STARS
for i = 1, 15 do
    local star = Instance.new("Frame")
    local size = math.random(1, 3)
    star.Size = UDim2.new(0, size, 0, size)
    star.Position = UDim2.new(0, math.random(5, 195), 0, math.random(5, 105))
    star.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
    star.BorderSizePixel = 0
    star.BackgroundTransparency = 0.4
    star.ZIndex = 5
    star.Parent = frame
    Instance.new("UICorner", star).CornerRadius = UDim.new(1, 0)
    
    local baseX, baseY = star.Position.X.Offset, star.Position.Y.Offset
    local radius, speed, t = math.random(3, 8), 0.3 + math.random(), math.random() * 10
    RunService.RenderStepped:Connect(function()
        if not star.Parent then return end
        t += speed * 0.02
        star.Position = UDim2.new(0, math.clamp(baseX + math.cos(t) * radius, 5, 195), 0, math.clamp(baseY + math.sin(t * 0.8) * radius, 5, 105))
    end)
end

--// TOGGLE LOGIC
local toggled = false
local currentSpeed = 200

local function onToggle()
    toggled = not toggled
    if toggled then
        button.Text = "ON"
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60, 30, 100)}):Play()
    else
        button.Text = "OFF"
        button.TextColor3 = Color3.fromRGB(200, 150, 255)
        TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(15, 5, 30)}):Play()
    end
end

button.MouseButton1Click:Connect(onToggle)

speedInput.FocusLost:Connect(function()
    local val = tonumber(speedInput.Text)
    if val then
        currentSpeed = val
    else
        speedInput.Text = tostring(currentSpeed)
    end
end)

--// 🚀 SPEED LOGIC
RunService.Heartbeat:Connect(function()
    if toggled then
        local char = Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            local seat = char.Humanoid.SeatPart
            if seat and seat:IsA("VehicleSeat") then
                if seat.Throttle ~= 0 then
                    seat.AssemblyLinearVelocity = seat.AssemblyLinearVelocity + (seat.CFrame.LookVector * (currentSpeed / 10))
                end
            end
        end
    end
end)

--// 🚀 DRAG SYSTEM
local dragging, dragStart, startPos
button.InputBegan:Connect(function(input)
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
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
