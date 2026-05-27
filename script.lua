--// Ultimate FPS Savior | Elite God Edition (Mobile & High-Speed optimized)
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

--// CLEANUP
if CoreGui:FindFirstChild("GodNotch") then CoreGui.EliteNotch:Destroy() end

--// GUI SETUP
local gui = Instance.new("ScreenGui")
gui.Name = "GodNotch"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

local notch = Instance.new("Frame")
notch.Name = "MainNotch"
notch.Size = UDim2.new(0, 360, 0, 42)
notch.Position = UDim2.new(0.5, -180, 0, 10)
notch.BackgroundColor3 = Color3.fromRGB(5, 5, 10)
notch.BorderSizePixel = 0
notch.Parent = gui
Instance.new("UICorner", notch).CornerRadius = UDim.new(0, 14)

-- Ultra-Sharpen Border (Fixes mobile pixelation for UI)
local stroke = Instance.new("UIStroke", notch)
stroke.Color = Color3.fromRGB(60, 60, 100)
stroke.Thickness = 1.2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

--// STATS
local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(0.6, 0, 1, 0)
statsLabel.Position = UDim2.new(0, 15, 0, 0)
statsLabel.BackgroundTransparency = 1
statsLabel.Text = "CALIBRATING ENGINE..."
statsLabel.Font = Enum.Font.GothamBold
statsLabel.TextColor3 = Color3.fromRGB(230, 230, 255)
statsLabel.TextSize = 11
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.Parent = notch

--// SPEED INDICATOR (Small icon)
local speedTag = Instance.new("TextLabel")
speedTag.Size = UDim2.new(0, 50, 0, 15)
speedTag.Position = UDim2.new(0.4, 0, 0.65, 0)
speedTag.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
speedTag.Text = "HIGH SPEED"
speedTag.Font = Enum.Font.GothamBold
speedTag.TextSize = 7
speedTag.TextColor3 = Color3.fromRGB(255, 255, 255)
speedTag.Visible = false
speedTag.Parent = notch
Instance.new("UICorner", speedTag).CornerRadius = UDim.new(1, 0)

--// TOGGLE BUTTON
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 100, 0, 28)
toggle.Position = UDim2.new(1, -115, 0.5, -14)
toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
toggle.Text = "GOD OPTIMIZE"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 9
toggle.TextColor3 = Color3.fromRGB(180, 180, 255)
toggle.Parent = notch
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

--// LOGIC VARIABLES
local enabled = false
local highSpeedActive = false
local localPlayer = Players.LocalPlayer

--// PIXEL CLARITY & GOD OVERRIDES
local function setGodEngine(state)
    local s = settings()
    if state then
        -- 1. Mobile Pixelation Fix (Force Antialiasing via FFlags)
        pcall(function()
            setfflag("FIntAntialiasingQuality", "1") -- Sharpen edges
            setfflag("DFFlagEnableAntialiasing", "True")
            setfflag("FFlagDirectX11EnableResolutionScaling", "True")
            setfflag("DFFlagVariableMaxSimulationTimeSteps", "True")
        end)
        
        -- 2. General Optimization
        s.Rendering.QualityLevel = Enum.QualityLevel.Level01
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Texture") or v:IsA("Decal") then v.Transparency = 0.4 end
            if v:IsA("ParticleEmitter") then v.Enabled = false end
        end
        Lighting.GlobalShadows = false
    else
        pcall(function()
            setfflag("FIntAntialiasingQuality", "0")
        end)
        s.Rendering.QualityLevel = Enum.QualityLevel.Automatic
        Lighting.GlobalShadows = true
    end
end

--// HIGH-SPEED MONITORING
local function handleHighSpeed(isActive)
    if highSpeedActive == isActive then return end
    highSpeedActive = isActive
    speedTag.Visible = isActive
    
    if isActive then
        -- Even more aggressive for high speed
        workspace.CurrentCamera.FieldOfView = 80 -- Narrower for performance
        Lighting.Decoration = false
    else
        workspace.CurrentCamera.FieldOfView = 70
        Lighting.Decoration = true
    end
end

--// UPDATE LOOP
RunService.RenderStepped:Connect(function(dt)
    local fps = math.floor(1/dt)
    local ping = math.floor(Stats.Network.ServerTickTag:GetValue())
    statsLabel.Text = string.format("FPS: %d | PING: %dms", fps, ping)
    
    -- Velocity Detection
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local velocity = localPlayer.Character.HumanoidRootPart.Velocity.Magnitude
        if velocity > 60 then
            handleHighSpeed(true)
        else
            handleHighSpeed(false)
        end
    end
end)

toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        toggle.Text = "GOD MODE ACTIVE"
        toggle.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        setGodEngine(true)
        Rayfield:Notify({Title = "God Engine", Content = "Pixel Clarity & High-Speed Dynamic Loading Active.", Duration = 5})
    else
        toggle.Text = "GOD OPTIMIZE"
        toggle.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
        toggle.TextColor3 = Color3.fromRGB(180, 180, 255)
        setGodEngine(false)
    end
end)

--// DRAG
local dragging, dragStart, startPos
notch.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = notch.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        notch.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
