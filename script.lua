local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Universal Hub | God Edition",
   LoadingTitle = "Initializing God Framework...",
   LoadingSubtitle = "by Gemini CLI",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "EliteHub",
      FileName = "GodMode"
   },
   KeySystem = false
})

-- Two Tabs
local AimlockTab = Window:CreateTab("Aimlock", 4483362458)
local EverythingElseTab = Window:CreateTab("Everything Else", 4483362458)

-- Global States
local States = {
    AimlockEnabled = false,
    AimlockSmoothness = 0.1,
    AimlockFOV = 150,
    ShowFOV = false,
    LockPosition = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2),
    CenterLocked = false,
    AntiDie = false,
    HealthESP = false,
    TweenSpeed = 300,
    LastNotification = 0
}

-- Target Variable for Sticky Lock
local CurrentTarget = nil

-- References
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Drawing Objects
local Crosshair = Drawing.new("Circle")
Crosshair.Thickness = 2
Crosshair.Color = Color3.fromRGB(255, 0, 0)
Crosshair.Radius = 5
Crosshair.Filled = true
Crosshair.Visible = false

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5
FOVCircle.Visible = false

-- [ IMPROVED TARGET SELECTION ] --
local function GetNearestPlayer()
    local target = nil
    local shortestDist = math.huge
    local center = States.LockPosition

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local headPos = p.Character.Head.Position
            local screenPos, onScreen = Camera:WorldToViewportPoint(headPos)
            
            if onScreen then
                -- Check if inside FOV first
                local fovDist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if fovDist <= States.AimlockFOV then
                    -- Select by physical 3D distance for "Nearest" feel
                    local physicalDist = (LocalPlayer.Character.HumanoidRootPart.Position - headPos).Magnitude
                    if physicalDist < shortestDist then
                        target = p
                        shortestDist = physicalDist
                    end
                end
            end
        end
    end
    return target
end

local function TweenTo(targetPos)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local dist = (char.HumanoidRootPart.Position - targetPos).Magnitude
    local duration = dist / States.TweenSpeed
    
    local tween = TweenService:Create(char.HumanoidRootPart, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
    tween:Play()
    return tween
end

-- [ MAIN LOOP ] --
RunService.RenderStepped:Connect(function()
    -- Crosshair & Center Logic
    Crosshair.Visible = States.AimlockEnabled
    if States.AimlockEnabled and not States.CenterLocked then
        States.LockPosition = UserInputService:GetMouseLocation()
    end
    Crosshair.Position = States.LockPosition
    
    -- FOV Logic
    FOVCircle.Visible = States.ShowFOV
    FOVCircle.Radius = States.AimlockFOV
    FOVCircle.Position = States.LockPosition

    -- Elite Aimlock Execution
    if States.AimlockEnabled then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
            -- Acquire target if we don't have one
            if not CurrentTarget or not CurrentTarget.Character or not CurrentTarget.Character:FindFirstChild("Head") or CurrentTarget.Character.Humanoid.Health <= 0 then
                CurrentTarget = GetNearestPlayer()
            end
            
            -- Lock onto target
            if CurrentTarget and CurrentTarget.Character and CurrentTarget.Character:FindFirstChild("Head") then
                local targetPos = CurrentTarget.Character.Head.Position
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, targetPos), 1 - States.AimlockSmoothness)
            end
        else
            -- Reset target on key release (Stop sticking)
            CurrentTarget = nil
        end
    end

    -- Anti-Die Logic
    if States.AntiDie and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if LocalPlayer.Character.Humanoid.Health < 3000 then
            local closest = GetNearestPlayer()
            if closest then
                local escapePos = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(math.random(200, 400), 100, math.random(200, 400))
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(escapePos)
                Rayfield:Notify({Title = "Anti-Die", Content = "Health Critical! Auto-Escape active.", Duration = 3})
            end
        end
    end

    -- Intelligent Kill Notifications
    if tick() - States.LastNotification > 10 then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
                local health = p.Character.Humanoid.Health
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if health < 5000 and dist < 1000 then
                    States.LastNotification = tick()
                    Rayfield:Notify({
                        Title = "Finish Him!",
                        Content = p.Name .. " is low! (" .. math.floor(health) .. " HP). Distance: " .. math.floor(dist),
                        Duration = 8,
                        Actions = {
                            Ignore = {Name = "Ignore", Callback = function() end},
                            Tween = {Name = "Tween", Callback = function() TweenTo(p.Character.HumanoidRootPart.Position) end}
                        }
                    })
                    break
                end
            end
        end
    end
end)

-- [ AIMLOCK TAB ] --
AimlockTab:CreateSection("Core Mechanics")

AimlockTab:CreateToggle({
   Name = "Enable Elite Aimlock",
   CurrentValue = false,
   Callback = function(v) States.AimlockEnabled = v end,
})

AimlockTab:CreateButton({
   Name = "Lock Aim Center (Crosshair)",
   Callback = function() 
       States.CenterLocked = not States.CenterLocked
       Crosshair.Color = States.CenterLocked and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
       Rayfield:Notify({Title = "Aimlock", Content = States.CenterLocked and "Center Locked!" or "Center following Mouse", Duration = 2})
   end,
})

AimlockTab:CreateSection("Settings")

AimlockTab:CreateToggle({
   Name = "Show FOV Circle",
   CurrentValue = false,
   Callback = function(v) States.ShowFOV = v end,
})

AimlockTab:CreateSlider({
   Name = "Target FOV",
   Range = {10, 800},
   Increment = 10,
   CurrentValue = 150,
   Callback = function(v) States.AimlockFOV = v end,
})

AimlockTab:CreateSlider({
   Name = "Smoothness",
   Range = {0, 0.9},
   Increment = 0.01,
   CurrentValue = 0.1,
   Callback = function(v) States.AimlockSmoothness = v end,
})

-- [ EVERYTHING ELSE TAB ] --
EverythingElseTab:CreateSection("Performance")

EverythingElseTab:CreateButton({
   Name = "Anti-Lag (FPS Booster)",
   Callback = function()
       local lighting = game:GetService("Lighting")
       lighting.GlobalShadows = false
       lighting.FogEnd = 9e9
       settings().Rendering.QualityLevel = 1
       for _, v in pairs(game:GetDescendants()) do
           if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
               v.Material = Enum.Material.SmoothPlastic
               v.Reflectance = 0
           elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
               v.Enabled = false
           end
       end
       Rayfield:Notify({Title = "Performance", Content = "Optimization applied.", Duration = 3})
   end,
})

EverythingElseTab:CreateSection("Survival & Visuals")

EverythingElseTab:CreateToggle({
   Name = "Anti-Die (Auto-TP)",
   CurrentValue = false,
   Callback = function(v) States.AntiDie = v end,
})

EverythingElseTab:CreateToggle({
   Name = "Dynamic Health ESP",
   CurrentValue = false,
   Callback = function(v)
       States.HealthESP = v
       if v then
           task.spawn(function()
               while States.HealthESP do
                   for _, p in pairs(Players:GetPlayers()) do
                       if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
                           local char = p.Character
                           local hum = char.Humanoid
                           if not char:FindFirstChild("HealthTag") then
                               local bill = Instance.new("BillboardGui", char)
                               bill.Name = "HealthTag"
                               bill.Size = UDim2.new(0, 100, 0, 50)
                               bill.Adornee = char:FindFirstChild("Head")
                               bill.AlwaysOnTop = true
                               local txt = Instance.new("TextLabel", bill)
                               txt.Size = UDim2.new(1, 0, 1, 0)
                               txt.BackgroundTransparency = 1
                               txt.Font = Enum.Font.GothamBold
                               txt.TextSize = 14
                           end
                           local label = char.HealthTag.TextLabel
                           label.Text = p.Name .. " | " .. math.floor(hum.Health) .. " HP"
                           local percent = hum.Health / hum.MaxHealth
                           label.TextColor3 = Color3.fromHSV(percent * 0.3, 1, 1)
                       end
                   end
                   task.wait(0.5)
               end
               for _, p in pairs(Players:GetPlayers()) do
                   if p.Character and p.Character:FindFirstChild("HealthTag") then p.Character.HealthTag:Destroy() end
               end
           end)
       end
   end,
})

EverythingElseTab:CreateSection("Utility")

EverythingElseTab:CreateButton({
   Name = "Infinite Yield",
   Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end,
})

EverythingElseTab:CreateButton({
   Name = "Anti-AFK",
   Callback = function()
      local virtualUser = game:GetService("VirtualUser")
      LocalPlayer.Idled:Connect(function()
         virtualUser:CaptureController()
         virtualUser:ClickButton2(Vector2.new())
      end)
   end,
})

Rayfield:LoadConfiguration()
