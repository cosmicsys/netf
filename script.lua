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

-- Tabs
local CombatTab = Window:CreateTab("Elite Combat", 4483362458)
local SurvivalTab = Window:CreateTab("Survival", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local UtilityTab = Window:CreateTab("Utility", 4483362458)

-- Global States
local States = {
    AimbotEnabled = false,
    AimbotSmoothness = 1,
    AimbotFOV = 150,
    ShowFOV = false,
    LockPosition = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2),
    AimbotLocked = false,
    AntiDie = false,
    HealthESP = false,
    TweenSpeed = 300,
    LastNotification = 0
}

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

-- [ UTILITY FUNCTIONS ] --
local function GetClosestPlayer()
    local target = nil
    local dist = States.AimbotFOV
    
    -- Target relative to crosshair position
    local center = States.LockPosition

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if d < dist then
                    target = p
                    dist = d
                end
            end
        end
    end
    return target, dist
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
    -- Crosshair Logic
    Crosshair.Visible = States.AimbotEnabled
    if States.AimbotEnabled and not States.AimbotLocked then
        States.LockPosition = UserInputService:GetMouseLocation()
    end
    Crosshair.Position = States.LockPosition
    
    -- FOV Logic
    FOVCircle.Visible = States.ShowFOV
    FOVCircle.Radius = States.AimbotFOV
    FOVCircle.Position = States.LockPosition

    -- Aimbot Execution
    if States.AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = Camera:WorldToViewportPoint(target.Character.HumanoidRootPart.Position)
            -- Aimbot relative to the chosen center (LockPosition)
            mousemoverel(
                (targetPos.X - States.LockPosition.X) / States.AimbotSmoothness, 
                (targetPos.Y - States.LockPosition.Y) / States.AimbotSmoothness
            )
        end
    end

    -- Anti-Die Logic
    if States.AntiDie and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if LocalPlayer.Character.Humanoid.Health < 3000 then
            local _, dist = GetClosestPlayer() -- Re-using check for closest player
            if dist < 100 then
                local escapePos = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(300, 50, 300)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(escapePos)
                Rayfield:Notify({Title = "Anti-Die", Content = "Low Health! Escape triggered.", Duration = 3})
            end
        end
    end

    -- Intelligent Notifications
    if tick() - States.LastNotification > 10 then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") then
                local health = p.Character.Humanoid.Health
                local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if health < 5000 and dist < 1000 then
                    States.LastNotification = tick()
                    Rayfield:Notify({
                        Title = "Kill Opportunity",
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

-- [ ELITE COMBAT TAB ] --
CombatTab:CreateSection("Targeting")

CombatTab:CreateToggle({
   Name = "Enable Aimbot & Crosshair",
   CurrentValue = false,
   Callback = function(v) States.AimbotEnabled = v end,
})

CombatTab:CreateButton({
   Name = "Lock/Unlock Center Position",
   Callback = function() 
       States.AimbotLocked = not States.AimbotLocked
       Crosshair.Color = States.AimbotLocked and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
       Rayfield:Notify({Title = "Combat", Content = States.AimbotLocked and "Aimbot Center Locked!" or "Center following Mouse", Duration = 2})
   end,
})

CombatTab:CreateSection("Adjustments")

CombatTab:CreateToggle({
   Name = "Show FOV Radius",
   CurrentValue = false,
   Callback = function(v) States.ShowFOV = v end,
})

CombatTab:CreateSlider({
   Name = "FOV Radius",
   Range = {10, 800},
   Increment = 10,
   CurrentValue = 150,
   Callback = function(v) States.AimbotFOV = v end,
})

CombatTab:CreateSlider({
   Name = "Smoothness",
   Range = {1, 10},
   Increment = 0.1,
   CurrentValue = 1,
   Callback = function(v) States.AimbotSmoothness = v end,
})

-- [ SURVIVAL TAB ] --
SurvivalTab:CreateToggle({
   Name = "Anti-Die (3000 HP Trigger)",
   CurrentValue = false,
   Callback = function(v) States.AntiDie = v end,
})

SurvivalTab:CreateSlider({
   Name = "Tween Speed",
   Range = {100, 1000},
   Increment = 50,
   CurrentValue = 300,
   Callback = function(v) States.TweenSpeed = v end,
})

-- [ VISUALS TAB ] --
VisualsTab:CreateToggle({
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

Rayfield:LoadConfiguration()
