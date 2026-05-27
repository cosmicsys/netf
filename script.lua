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
local CombatTab = Window:CreateTab("Combat", 4483362458)
local SurvivalTab = Window:CreateTab("Survival", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local UtilityTab = Window:CreateTab("Utility", 4483362458)

-- Global States
local States = {
    Aimbot = false,
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

-- Crosshair Drawing
local Crosshair = Drawing.new("Circle")
Crosshair.Thickness = 2
Crosshair.Color = Color3.fromRGB(255, 0, 0)
Crosshair.Radius = 5
Crosshair.Filled = true
Crosshair.Visible = false

-- [ UTILITY FUNCTIONS ] --
local function GetClosestPlayer()
    local target = nil
    local dist = math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local d = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                target = p
                dist = d
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
    Crosshair.Visible = States.Aimbot
    if States.Aimbot and not States.AimbotLocked then
        States.LockPosition = UserInputService:GetMouseLocation()
    end
    Crosshair.Position = States.LockPosition

    -- Anti-Die Logic
    if States.AntiDie and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if LocalPlayer.Character.Humanoid.Health < 3000 then
            local closest, dist = GetClosestPlayer()
            if closest and dist < 100 then
                local escapePos = LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(300, 50, 300)
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(escapePos)
                Rayfield:Notify({Title = "Anti-Die", Content = "Low Health! Teleported away from threat.", Duration = 3})
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

-- [ COMBAT TAB ] --
CombatTab:CreateToggle({
   Name = "Moveable Crosshair Aimbot",
   CurrentValue = false,
   Callback = function(v) States.Aimbot = v end,
})

CombatTab:CreateButton({
   Name = "Lock/Unlock Crosshair Position",
   Callback = function() 
       States.AimbotLocked = not States.AimbotLocked
       Crosshair.Color = States.AimbotLocked and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
       Rayfield:Notify({Title = "Aimbot", Content = States.AimbotLocked and "Position Locked!" or "Position Unlocked (Follow Mouse)", Duration = 2})
   end,
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
                           -- Color blending based on health
                           local percent = hum.Health / hum.MaxHealth
                           label.TextColor3 = Color3.fromHSV(percent * 0.3, 1, 1) -- Red (0) to Green (0.3)
                       end
                   end
                   task.wait(0.5)
               end
               -- Cleanup
               for _, p in pairs(Players:GetPlayers()) do
                   if p.Character and p.Character:FindFirstChild("HealthTag") then p.Character.HealthTag:Destroy() end
               end
           end)
       end
   end,
})

Rayfield:LoadConfiguration()
