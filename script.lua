--// COSMIC ANTI-LAG MEGAPACK | GOD EDITION
--// Merged: Yero Rejoin + Yero Boost v2 + Elite DLSS Engine
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

--// CLEANUP
if CoreGui:FindFirstChild("CosmicMegaNotch") then CoreGui.CosmicMegaNotch:Destroy() end

--// SETTINGS & STATE
local State = {
    Optimized = false,
    AutoMode = false,
    DLSS = false,
    MobileClarity = false,
    HighSpeedBypass = false
}

--// GUI SETUP (COSMIC NOTCH)
local gui = Instance.new("ScreenGui")
gui.Name = "CosmicMegaNotch"
gui.Parent = CoreGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Name = "MainNotch"
main.Size = UDim2.new(0, 380, 0, 45)
main.Position = UDim2.new(0.5, -190, 0, 10)
main.BackgroundColor3 = Color3.fromRGB(10, 5, 20)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

-- Glow Border
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(60, 40, 120)
stroke.Thickness = 1.5
stroke.Transparency = 0.4

--// PERFORMANCE MONITOR
local perfLabel = Instance.new("TextLabel")
perfLabel.Size = UDim2.new(0.4, 0, 1, 0)
perfLabel.Position = UDim2.new(0, 15, 0, 0)
perfLabel.BackgroundTransparency = 1
perfLabel.Text = "STABILIZING..."
perfLabel.Font = Enum.Font.GothamBold
perfLabel.TextColor3 = Color3.fromRGB(200, 180, 255)
perfLabel.TextSize = 11
perfLabel.TextXAlignment = Enum.TextXAlignment.Left
perfLabel.Parent = main

--// TOP MENU (HIDDEN)
local menu = Instance.new("Frame")
menu.Size = UDim2.new(1, 0, 0, 180)
menu.Position = UDim2.new(0, 0, 1, 5)
menu.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
menu.Visible = false
menu.ClipsDescendants = true
menu.Parent = main
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", menu).Color = Color3.fromRGB(40, 20, 80)

local layout = Instance.new("UIListLayout", menu)
layout.Padding = UDim.new(0, 5)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
Instance.new("UIPadding", menu).PaddingTop = UDim.new(0, 10)

--// BUTTONS
local function CreateButton(txt, parent, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.9, 0, 0, 30)
    b.BackgroundColor3 = color or Color3.fromRGB(30, 20, 50)
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 11
    b.Parent = parent
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    return b
end

local optBtn = CreateButton("FULL FPS BOOST", menu)
local dlssBtn = CreateButton("ENABLE DLSS (AI UPSCALE)", menu)
local clarifyBtn = CreateButton("MOBILE PIXEL CLARITY", menu)
local rejoinBtn = CreateButton("REJOIN CURRENT SERVER", menu, Color3.fromRGB(100, 20, 20))
local hopBtn = CreateButton("JOIN NEW SERVER", menu, Color3.fromRGB(120, 40, 20))

--// + TOGGLE
local plus = Instance.new("TextButton")
plus.Size = UDim2.new(0, 40, 0, 25)
plus.Position = UDim2.new(1, -50, 0.5, -12)
plus.BackgroundColor3 = Color3.fromRGB(40, 20, 80)
plus.Text = "+"
plus.Font = Enum.Font.GothamBold
plus.TextColor3 = Color3.new(1, 1, 1)
plus.Parent = main
Instance.new("UICorner", plus).CornerRadius = UDim.new(0, 6)

plus.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
    plus.Text = menu.Visible and "-" or "+"
end)

--// ⭐ COSMIC STARS
for i = 1, 10 do
    local star = Instance.new("Frame")
    star.Size = UDim2.new(0, 2, 0, 2)
    star.Position = UDim2.new(math.random(), 0, math.random(), 0)
    star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    star.BackgroundTransparency = 0.6
    star.Parent = main
    Instance.new("UICorner", star).CornerRadius = UDim.new(1, 0)
end

--// OPTIMIZATION CORE
local function OptimizeAssets()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    
    for _, v in pairs(game:GetDescendants()) do
        pcall(function()
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 0.8
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                v.Enabled = false
            end
        end)
    end
end

local function SetDLSS(v)
    State.DLSS = v
    if v then
        pcall(function()
            setfflag("FIntAntialiasingQuality", "0")
            setfflag("DFFlagVariableMaxSimulationTimeSteps", "True")
            setfflag("FIntPhysicsSolverIterationLimit", "1")
        end)
    end
end

--// MAIN LOOP (FPS/PING + HIGH SPEED)
local frames = {}
RunService.RenderStepped:Connect(function(dt)
    local fps = math.floor(1/dt)
    local ping = math.floor(Stats.Network.ServerTickTag:GetValue())
    perfLabel.Text = string.format("FPS: %d | PING: %dms", fps, ping)
    
    -- Dynamic High Speed Optimization
    local char = Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if char.HumanoidRootPart.Velocity.Magnitude > 60 then
            Lighting.Decoration = false
        else
            Lighting.Decoration = true
        end
    end
end)

--// BUTTON CONNECTORS
optBtn.MouseButton1Click:Connect(function()
    OptimizeAssets()
    optBtn.Text = "FPS BOOSTED"
    optBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Cosmic Boost", Text = "All heavy assets stripped.", Duration = 5})
end)

dlssBtn.MouseButton1Click:Connect(function()
    State.DLSS = not State.DLSS
    SetDLSS(State.DLSS)
    dlssBtn.Text = State.DLSS and "DLSS: ON" or "DLSS: OFF"
    dlssBtn.BackgroundColor3 = State.DLSS and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(30, 20, 50)
end)

clarifyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        setfflag("FIntAntialiasingQuality", "1")
        setfflag("DFFlagEnableAntialiasing", "True")
    end)
    clarifyBtn.Text = "PIXELS CLARIFIED"
    clarifyBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
end)

rejoinBtn.MouseButton1Click:Connect(function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
end)

hopBtn.MouseButton1Click:Connect(function()
    TeleportService:Teleport(game.PlaceId, Players.LocalPlayer)
end)

--// DRAG SYSTEM
local dragging, dragStart, startPos
main.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType.Touch then
        dragging = true
        dragStart = i.Position
        startPos = main.Position
        i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
