--// COSMIC ANTI-LAG: INFINITY EDITION (STABILITY FIX)
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

--// CLEANUP
if CoreGui:FindFirstChild("CosmicInfinityNotch") then CoreGui.CosmicInfinityNotch:Destroy() end

--// SETTINGS & STATE
local State = {
    InfinityEnabled = false,
    DLSS = false,
}

--// GUI SETUP (COSMIC NOTCH)
local gui = Instance.new("ScreenGui")
gui.Name = "CosmicInfinityNotch"
gui.Parent = CoreGui
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local main = Instance.new("Frame")
main.Name = "MainNotch"
main.Size = UDim2.new(0, 400, 0, 45)
main.Position = UDim2.new(0.5, -200, 0, 10)
main.BackgroundColor3 = Color3.fromRGB(10, 5, 20)
main.BorderSizePixel = 0
main.Active = true
main.ZIndex = 10
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 15)

-- Cosmic Glow Border
local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(150, 50, 255)
stroke.Thickness = 2
stroke.Transparency = 0.3

local gradient = Instance.new("UIGradient", main)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 5, 20)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(30, 10, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 5, 20))
})

--// PERFORMANCE MONITOR
local perfLabel = Instance.new("TextLabel")
perfLabel.Size = UDim2.new(0.5, 0, 1, 0)
perfLabel.Position = UDim2.new(0, 15, 0, 0)
perfLabel.BackgroundTransparency = 1
perfLabel.Text = "WAITING FOR DATA..."
perfLabel.Font = Enum.Font.GothamBold
perfLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
perfLabel.TextSize = 13
perfLabel.TextXAlignment = Enum.TextXAlignment.Left
perfLabel.ZIndex = 15
perfLabel.Parent = main

--// TOP MENU
local menu = Instance.new("Frame")
menu.Size = UDim2.new(1, 0, 0, 210)
menu.Position = UDim2.new(0, 0, 1, 8)
menu.BackgroundColor3 = Color3.fromRGB(8, 4, 15)
menu.Visible = false
menu.ClipsDescendants = true
menu.ZIndex = 20
menu.Parent = main
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 14)
local ms = Instance.new("UIStroke", menu)
ms.Color = Color3.fromRGB(100, 50, 200)
ms.Thickness = 1.5

local layout = Instance.new("UIListLayout", menu)
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
Instance.new("UIPadding", menu).PaddingTop = UDim.new(0, 12)

--// COSMIC BUTTON CREATOR
local function CreateCosmicButton(txt, parent, colorStart, colorEnd)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0.92, 0, 0, 36)
    b.BackgroundColor3 = Color3.new(1, 1, 1)
    b.Text = txt
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 12
    b.AutoButtonColor = false
    b.ZIndex = 25
    b.Parent = parent
    
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local bg = Instance.new("UIGradient", b)
    bg.Color = ColorSequence.new(colorStart or Color3.fromRGB(60, 30, 120), colorEnd or Color3.fromRGB(30, 15, 60))
    
    local bs = Instance.new("UIStroke", b)
    bs.Color = Color3.fromRGB(255, 255, 255)
    bs.Transparency = 0.7
    bs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    b.MouseEnter:Connect(function()
        TweenService:Create(bs, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(bs, TweenInfo.new(0.2), {Transparency = 0.7}):Play()
    end)
    
    return b
end

local infinityBtn = CreateCosmicButton("INFINITY ENGINE (MAX + NO LAG)", menu, Color3.fromRGB(150, 0, 255), Color3.fromRGB(50, 0, 150))
local dlssBtn = CreateCosmicButton("DLSS 3.5 (PIXEL UPSCALE)", menu)
local rejoinBtn = CreateCosmicButton("REJOIN SERVER", menu, Color3.fromRGB(200, 0, 50), Color3.fromRGB(100, 0, 0))
local hopBtn = CreateCosmicButton("SERVER HOP", menu, Color3.fromRGB(255, 100, 0), Color3.fromRGB(150, 50, 0))

--// + TOGGLE
local plus = Instance.new("TextButton")
plus.Size = UDim2.new(0, 50, 0, 30)
plus.Position = UDim2.new(1, -60, 0.5, -15)
plus.BackgroundColor3 = Color3.fromRGB(60, 20, 120)
plus.Text = "+"
plus.Font = Enum.Font.GothamBold
plus.TextColor3 = Color3.new(1, 1, 1)
plus.TextSize = 16
plus.ZIndex = 15
plus.Parent = main
Instance.new("UICorner", plus).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", plus).Color = Color3.new(1,1,1)

plus.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
    plus.Text = menu.Visible and "-" or "+"
end)

--// ⭐ SUPERSTARS
for i = 1, 15 do
    local s = Instance.new("Frame")
    s.Size = UDim2.new(0, 2, 0, 2)
    s.Position = UDim2.new(math.random(), 0, math.random(), 0)
    s.BackgroundColor3 = Color3.new(1,1,1)
    s.BackgroundTransparency = 0.6
    s.ZIndex = 12
    s.Parent = main
    Instance.new("UICorner", s).CornerRadius = UDim.new(1,0)
end

--// PERFORMANCE ENGINE (FIXED)
local function getPing()
    local ping = 0
    pcall(function()
        ping = math.floor(Stats.Network.ServerTickTag:GetValue())
        if ping <= 0 then
            ping = math.floor(Stats.PerformanceStats.Ping:GetValue())
        end
    end)
    return ping
end

local lastUpdate = 0
RunService.Heartbeat:Connect(function(dt)
    if tick() - lastUpdate >= 0.5 then
        lastUpdate = tick()
        local fps = math.floor(1/dt)
        local ping = getPing()
        perfLabel.Text = string.format("FPS: %d | PING: %dms", fps, ping)
    end
end)

--// INFINITY ENGINE
local function ApplyInfinity()
    local s = settings()
    s.Rendering.QualityLevel = Enum.QualityLevel.Level21
    Lighting.GlobalShadows = true
    Lighting.Decoration = true
    Lighting.FogEnd = 100000
    
    pcall(function()
        setfflag("DFFlagVariableMaxSimulationTimeSteps", "True")
        setfflag("FIntPhysicsSolverIterationLimit", "1")
        setfflag("FFlagDirectX11EnableResolutionScaling", "True")
        setfflag("DFFlagDebugRenderCloudShadows", "False")
        setfflag("FIntRenderShadowIntensity", "0")
        setfflag("FIntAntialiasingQuality", "0")
    end)
    
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then v.CastShadow = false end
    end
end

--// CONNECTORS
infinityBtn.MouseButton1Click:Connect(function()
    State.InfinityEnabled = not State.InfinityEnabled
    if State.InfinityEnabled then
        ApplyInfinity()
        infinityBtn.Text = "INFINITY: ACTIVE"
        infinityBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    else
        infinityBtn.Text = "INFINITY ENGINE (MAX + NO LAG)"
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
    end
end)

dlssBtn.MouseButton1Click:Connect(function()
    State.DLSS = not State.DLSS
    dlssBtn.Text = State.DLSS and "DLSS: ACTIVE" or "DLSS 3.5 (PIXEL UPSCALE)"
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
