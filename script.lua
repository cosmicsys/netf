--// Ultimate FPS Savior | Elite Benchmarking Edition
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

--// CLEANUP
if CoreGui:FindFirstChild("UltimateNotch") then CoreGui.UltimateNotch:Destroy() end

--// GUI SETUP
local gui = Instance.new("ScreenGui")
gui.Name = "UltimateNotch"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

local notch = Instance.new("Frame")
notch.Name = "MainNotch"
notch.Size = UDim2.new(0, 350, 0, 40)
notch.Position = UDim2.new(0.5, -175, 0, 10)
notch.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
notch.BorderSizePixel = 0
notch.Parent = gui
Instance.new("UICorner", notch).CornerRadius = UDim.new(0, 12)

local glow = Instance.new("UIStroke", notch)
glow.Color = Color3.fromRGB(30, 30, 45)
glow.Thickness = 1.5
glow.Transparency = 0.5

--// STATS (TRUE DATA ENGINE)
local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(0.6, 0, 1, 0)
statsLabel.Position = UDim2.new(0, 15, 0, 0)
statsLabel.BackgroundTransparency = 1
statsLabel.Text = "STABILIZING..."
statsLabel.Font = Enum.Font.GothamBold
statsLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
statsLabel.TextSize = 12
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.Parent = notch

--// PROGRESS BAR (Benchmarking Visual)
local benchBar = Instance.new("Frame")
benchBar.Size = UDim2.new(0, 0, 0, 2)
benchBar.Position = UDim2.new(0, 0, 1, -2)
benchBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
benchBar.BorderSizePixel = 0
benchBar.Visible = false
benchBar.Parent = notch

--// TOGGLE BUTTON
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0, 90, 0, 26)
toggle.Position = UDim2.new(1, -105, 0.5, -13)
toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
toggle.Text = "OPTIMIZE"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 10
toggle.TextColor3 = Color3.fromRGB(150, 150, 255)
toggle.Parent = notch
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

--// LOGIC VARIABLES
local enabled = false
local baselineFps = 0
local samples = {}
local isBenchmarking = false

--// ROLLING AVERAGE ENGINE
local function getRollingAverage(tbl)
    if #tbl == 0 then return 0 end
    local sum = 0
    for _, v in pairs(tbl) do sum += v end
    return sum / #tbl
end

--// STATS UPDATE LOOP
local lastUpdate = tick()
RunService.RenderStepped:Connect(function(dt)
    local currentFps = 1/dt
    local currentPing = math.floor(Stats.Network.ServerTickTag:GetValue())
    
    if tick() - lastUpdate > 0.5 then
        statsLabel.Text = string.format("FPS: %d | PING: %dms", math.floor(currentFps), currentPing)
        lastUpdate = tick()
    end
    
    if isBenchmarking then
        table.insert(samples, currentFps)
    end
end)

--// ELITE ENGINE OVERRIDES
local function setEngineState(state)
    local s = settings()
    if state then
        -- 1. True DLSS-Style Upscaling Simulation
        s.Rendering.QualityLevel = Enum.QualityLevel.Level01
        pcall(function()
            setfflag("DFFlagDebugRenderCloudShadows", "False")
            setfflag("FIntRenderShadowIntensity", "0")
            setfflag("FIntAntialiasingQuality", "0")
            setfflag("DFFlagVariableMaxSimulationTimeSteps", "True")
            setfflag("FIntPhysicsSolverIterationLimit", "1")
        end)
        
        -- 2. Aggressive Asset Optimization
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Texture") or v:IsA("Decal") then
                v.Transparency = 0.6 -- High-quality stripping
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            elseif v:IsA("BasePart") then
                -- Strip shadows from distant high-poly models
                if (v.Position - workspace.CurrentCamera.CFrame.Position).Magnitude > 500 then
                    v.CastShadow = false
                end
            end
        end
        Lighting.GlobalShadows = false
    else
        -- Restore
        s.Rendering.QualityLevel = Enum.QualityLevel.Automatic
        Lighting.GlobalShadows = true
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("Texture") or v:IsA("Decal") then v.Transparency = 0 end
        end
    end
end

--// BENCHMARKING SYSTEM
local function runBenchmark()
    isBenchmarking = true
    samples = {}
    benchBar.Visible = true
    benchBar.Size = UDim2.new(0, 0, 0, 2)
    
    -- Step 1: Baseline (5 Seconds)
    toggle.Text = "SAMPLING..."
    TweenService:Create(benchBar, TweenInfo.new(5, Enum.EasingStyle.Linear), {Size = UDim2.new(0.5, 0, 0, 2)}):Play()
    task.wait(5)
    baselineFps = getRollingAverage(samples)
    samples = {}
    
    -- Step 2: Optimized (5 Seconds)
    setEngineState(true)
    toggle.Text = "TESTING..."
    TweenService:Create(benchBar, TweenInfo.new(5, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 0, 2)}):Play()
    task.wait(5)
    local optimizedFps = getRollingAverage(samples)
    
    -- Finalize
    isBenchmarking = false
    benchBar.Visible = false
    local gain = ((optimizedFps - baselineFps) / baselineFps) * 100
    
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "VERIFIED REPORT",
        Text = string.format("Baseline: %d FPS\nOptimized: %d FPS\nGain: %.1f%%", baselineFps, optimizedFps, gain),
        Duration = 10
    })
    
    toggle.Text = "ACTIVE"
    toggle.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
end

toggle.MouseButton1Click:Connect(function()
    if not enabled then
        enabled = true
        runBenchmark()
    else
        enabled = false
        setEngineState(false)
        toggle.Text = "OPTIMIZE"
        toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        toggle.TextColor3 = Color3.fromRGB(150, 150, 255)
    end
end)

--// DRAG SYSTEM
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
