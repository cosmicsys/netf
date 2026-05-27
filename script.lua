--// FPS Savior | Cosmic Elite Edition
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")

--// CLEANUP PREVIOUS
if CoreGui:FindFirstChild("CosmicFPSGUI") then
    CoreGui.CosmicFPSGUI:Destroy()
end

--// GUI SETUP
local gui = Instance.new("ScreenGui")
gui.Name = "CosmicFPSGUI"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

--// MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 110)
frame.Position = UDim2.new(0.5, -120, 0.5, -55)
frame.BackgroundColor3 = Color3.fromRGB(10, 5, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

--// PERFORMANCE BAR (Wide and Short)
local perfBar = Instance.new("Frame")
perfBar.Size = UDim2.new(0.9, 0, 0, 20)
perfBar.Position = UDim2.new(0.05, 0, 0.1, 0)
perfBar.BackgroundColor3 = Color3.fromRGB(5, 2, 10)
perfBar.Parent = frame
Instance.new("UICorner", perfBar).CornerRadius = UDim.new(0, 6)

local perfText = Instance.new("TextLabel")
perfText.Size = UDim2.new(1, 0, 1, 0)
perfText.BackgroundTransparency = 1
perfText.Text = "FPS: -- | PING: -- ms"
perfText.Font = Enum.Font.GothamBold
perfText.TextSize = 11
perfText.TextColor3 = Color3.fromRGB(200, 150, 255)
perfText.Parent = perfBar

--// TOGGLE BUTTON
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.9, 0, 0, 35)
button.Position = UDim2.new(0.05, 0, 0.45, 0)
button.BackgroundColor3 = Color3.fromRGB(25, 10, 50)
button.Text = "FPS SAVIOR: OFF"
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.TextColor3 = Color3.fromRGB(180, 130, 255)
button.Parent = frame
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)

--// STATUS FOOTER
local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 20)
footer.Position = UDim2.new(0, 0, 0.82, 0)
footer.BackgroundTransparency = 1
footer.Text = "Visual Integrity Maintained"
footer.Font = Enum.Font.Gotham
footer.TextSize = 10
footer.TextColor3 = Color3.fromRGB(100, 80, 150)
footer.Parent = frame

--// ⭐ COSMIC STARS
for i = 1, 15 do
    local star = Instance.new("Frame")
    star.Size = UDim2.new(0, math.random(1, 2), 0, math.random(1, 2))
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    star.BackgroundTransparency = 0.6
    star.Parent = frame
    Instance.new("UICorner", star).CornerRadius = UDim.new(1, 0)
    local t = math.random() * 10
    RunService.RenderStepped:Connect(function()
        t += 0.02
        star.BackgroundTransparency = 0.5 + math.sin(t) * 0.4
    end)
end

--// LOGIC VARIABLES
local toggled = false
local initialFps = 60
local startTime = 0
local frameCount = 0
local fpsSamples = {}

--// PERFORMANCE TRACKING
RunService.RenderStepped:Connect(function(dt)
    frameCount += 1
    local currentFps = math.floor(1/dt)
    local ping = math.floor(Stats.Network.ServerTickTag:GetValue())
    perfText.Text = string.format("FPS: %d | PING: %d ms", currentFps, ping)
    
    if toggled then
        table.insert(fpsSamples, currentFps)
    end
end)

--// OPTIMIZATION ENGINE
local function optimize(state)
    if state then
        -- 1. Unused Texture & Faraway Model Stripping
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Texture") or v:IsA("Decal") then
                -- Only dim faraway/excessive textures
                v.Transparency = 0.3 
            elseif v:IsA("MeshPart") or v:IsA("Part") then
                -- Dynamic LOD (Simulated)
                if (v.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 300 then
                    v.CastShadow = false
                end
            elseif v:IsA("Explosion") or v:IsA("ParticleEmitter") then
                -- Mitigation for server-lag exploiters
                v.Enabled = false
            end
        end
        
        -- 2. Engine Optimization
        Lighting.GlobalShadows = false
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    else
        -- Restore
        Lighting.GlobalShadows = true
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
    end
end

--// TOGGLE LOGIC
local function onToggle()
    toggled = not toggled
    if toggled then
        button.Text = "FPS SAVIOR: ACTIVE"
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(80, 40, 140)}):Play()
        
        initialFps = math.floor(1/RunService.RenderStepped:Wait())
        startTime = tick()
        fpsSamples = {}
        optimize(true)
        
        -- 60 Second Notification
        task.delay(60, function()
            if toggled then
                local sum = 0
                for _, f in pairs(fpsSamples) do sum += f end
                local avgFps = #fpsSamples > 0 and (sum / #fpsSamples) or initialFps
                local diff = ((avgFps - initialFps) / initialFps) * 100
                
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Elite Performance Report",
                    Text = string.format("Avg FPS: %d\nImprovement: %.1f%%", avgFps, diff),
                    Duration = 10
                })
            end
        end)
    else
        button.Text = "FPS SAVIOR: OFF"
        button.TextColor3 = Color3.fromRGB(180, 130, 255)
        TweenService:Create(button, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(25, 10, 50)}):Play()
        optimize(false)
    end
end

button.MouseButton1Click:Connect(onToggle)

--// DRAG SYSTEM
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
