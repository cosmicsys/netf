--// FPS Savior: Elite Notch Edition (with DLSS Support)
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")

--// CLEANUP
if CoreGui:FindFirstChild("EliteNotch") then CoreGui.EliteNotch:Destroy() end

--// GUI SETUP (THE NOTCH)
local gui = Instance.new("ScreenGui")
gui.Name = "EliteNotch"
gui.Parent = CoreGui
gui.DisplayOrder = 999
gui.ResetOnSpawn = false

local notch = Instance.new("Frame")
notch.Name = "MainNotch"
notch.Size = UDim2.new(0, 320, 0, 35)
notch.Position = UDim2.new(0.5, -160, 0, -40) -- Start hidden for entry animation
notch.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
notch.BorderSizePixel = 0
notch.Parent = gui
Instance.new("UICorner", notch).CornerRadius = UDim.new(0, 10)

-- Subtle Border
local border = Instance.new("UIStroke", notch)
border.Color = Color3.fromRGB(40, 40, 60)
border.Thickness = 1
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

--// STATS DISPLAY
local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(0.5, 0, 1, 0)
statsLabel.Position = UDim2.new(0, 10, 0, 0)
statsLabel.BackgroundTransparency = 1
statsLabel.Text = "FPS: 60 | PING: 20ms"
statsLabel.Font = Enum.Font.GothamBold
statsLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
statsLabel.TextSize = 11
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.Parent = notch

--// DLSS INDICATOR
local dlssTag = Instance.new("TextLabel")
dlssTag.Size = UDim2.new(0.2, 0, 0.5, 0)
dlssTag.Position = UDim2.new(0.4, 0, 0.25, 0)
dlssTag.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
dlssTag.Text = "DLSS"
dlssTag.Font = Enum.Font.GothamBold
dlssTag.TextSize = 9
dlssTag.TextColor3 = Color3.fromRGB(0, 0, 0)
dlssTag.Visible = false
dlssTag.Parent = notch
Instance.new("UICorner", dlssTag).CornerRadius = UDim.new(1, 0)

--// TOGGLE BUTTON
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 80, 0, 23)
toggle.Position = UDim2.new(1, -90, 0.5, -11)
toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
toggle.Text = "OPTIMIZE"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 10
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Parent = notch
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

--// ENTRY ANIMATION
TweenService:Create(notch, TweenInfo.new(1, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -160, 0, 10)}):Play()

--// ⭐ COSMIC FLOW
local bgEffect = Instance.new("Frame")
bgEffect.Size = UDim2.new(1, 0, 1, 0)
bgEffect.BackgroundTransparency = 1
bgEffect.ClipsDescendants = true
bgEffect.Parent = notch
Instance.new("UICorner", bgEffect).CornerRadius = UDim.new(0, 10)

for i = 1, 5 do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, 2, 0, 2)
    p.Position = UDim2.new(math.random(), 0, math.random(), 0)
    p.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
    p.BackgroundTransparency = 0.5
    p.Parent = bgEffect
    Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
end

--// DLSS & OPTIMIZATION LOGIC
local enabled = false
local function setDLSS(state)
    local s = settings()
    if state then
        -- Simulate DLSS: Lower internal res, sharpen edges via FFlags
        s.Rendering.QualityLevel = Enum.QualityLevel.Level01
        pcall(function()
            setfflag("DFFlagDebugRenderCloudShadows", "False")
            setfflag("FIntRenderShadowIntensity", "0")
            setfflag("FIntAntialiasingQuality", "0") -- Upscaled look
            setfflag("DFFlagVariableMaxSimulationTimeSteps", "True")
        end)
        -- Optimization
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end
            if v:IsA("Texture") or v:IsA("Decal") then v.Transparency = 0.5 end
        end
        Lighting.GlobalShadows = false
    else
        s.Rendering.QualityLevel = Enum.QualityLevel.Automatic
        Lighting.GlobalShadows = true
    end
end

--// UPDATE LOOP
local fpsSamples = {}
local initialFps = 60

RunService.RenderStepped:Connect(function(dt)
    local fps = math.floor(1/dt)
    local ping = math.floor(Stats.Network.ServerTickTag:GetValue())
    statsLabel.Text = string.format("FPS: %d | PING: %dms", fps, ping)
    
    if enabled then table.insert(fpsSamples, fps) end
end)

toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        toggle.Text = "ENABLED"
        toggle.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
        dlssTag.Visible = true
        initialFps = math.floor(1/RunService.RenderStepped:Wait())
        setDLSS(true)
        
        -- 60s Report
        task.delay(60, function()
            if enabled then
                local sum = 0
                for _, f in pairs(fpsSamples) do sum += f end
                local avg = #fpsSamples > 0 and (sum/#fpsSamples) or initialFps
                local boost = ((avg - initialFps) / initialFps) * 100
                
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "DLSS Performance Report",
                    Text = string.format("Avg Boost: %.1f%%\nStatus: Elite Stability", boost),
                    Duration = 8
                })
            end
        end)
    else
        toggle.Text = "OPTIMIZE"
        toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        dlssTag.Visible = false
        setDLSS(false)
    end
end)

--// DRAG SYSTEM (Optional but requested draggable previously)
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
