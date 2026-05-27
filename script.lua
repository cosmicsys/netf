local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Universal Hub | Combat Edition",
   LoadingTitle = "Loading Combat Framework...",
   LoadingSubtitle = "by Gemini CLI",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "EliteHub",
      FileName = "Main"
   },
   KeySystem = false
})

-- Tabs
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)
local MainTab = Window:CreateTab("Movement", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local UtilityTab = Window:CreateTab("Utility", 4483362458)
local ScriptsTab = Window:CreateTab("Scripts", 4483362458)

-- Global States
local States = {
    AimbotEnabled = false,
    AimbotTeamCheck = false,
    AimbotFOV = 150,
    AimbotSmoothness = 1,
    ShowFOV = false,
    Flying = false,
    FlySpeed = 50,
}

-- References
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- FOV Circle
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5

-- [ AIMBOT LOGIC ] --
local function GetClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = States.AimbotFOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if States.AimbotTeamCheck and player.Team == LocalPlayer.Team then continue end
            
            local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = States.ShowFOV
    FOVCircle.Radius = States.AimbotFOV
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    if States.AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetClosestPlayer()
        if target and target.Character then
            local targetPos = Camera:WorldToViewportPoint(target.Character.HumanoidRootPart.Position)
            mousemoverel((targetPos.X - Camera.ViewportSize.X / 2) / States.AimbotSmoothness, (targetPos.Y - Camera.ViewportSize.Y / 2) / States.AimbotSmoothness)
        end
    end
end)

-- [ AIMBOT TAB ] --
AimbotTab:CreateToggle({
   Name = "Enabled",
   CurrentValue = false,
   Callback = function(v) States.AimbotEnabled = v end,
})

AimbotTab:CreateToggle({
   Name = "Team Check",
   CurrentValue = false,
   Callback = function(v) States.AimbotTeamCheck = v end,
})

AimbotTab:CreateToggle({
   Name = "Show FOV",
   CurrentValue = false,
   Callback = function(v) States.ShowFOV = v end,
})

AimbotTab:CreateSlider({
   Name = "FOV Radius",
   Range = {10, 800},
   Increment = 10,
   CurrentValue = 150,
   Callback = function(v) States.AimbotFOV = v end,
})

AimbotTab:CreateSlider({
   Name = "Smoothness",
   Range = {1, 10},
   Increment = 0.1,
   CurrentValue = 1,
   Callback = function(v) States.AimbotSmoothness = v end,
})

-- [ MOVEMENT ] --
MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 500},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) 
       local char = LocalPlayer.Character
       if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = v end
   end,
})

-- [ UTILITY ] --
UtilityTab:CreateButton({
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
       Rayfield:Notify({Title = "Performance", Content = "Optimized rendering for max FPS.", Duration = 3})
   end,
})

UtilityTab:CreateButton({
   Name = "Anti-AFK",
   Callback = function()
      local virtualUser = game:GetService("VirtualUser")
      LocalPlayer.Idled:Connect(function()
         virtualUser:CaptureController()
         virtualUser:ClickButton2(Vector2.new())
      end)
   end,
})

-- [ VISUALS ] --
VisualsTab:CreateButton({
   Name = "ESP Highlights",
   Callback = function()
      for _, p in pairs(Players:GetPlayers()) do
         if p ~= LocalPlayer and p.Character then
            local h = Instance.new("Highlight", p.Character)
            h.FillColor = Color3.fromRGB(255, 0, 0)
         end
      end
   end,
})

-- [ SCRIPTS ] --
local function Load(url) loadstring(game:HttpGet(url))() end
ScriptsTab:CreateButton({ Name = "Infinite Yield", Callback = function() Load('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source') end })
ScriptsTab:CreateButton({ Name = "Dark Dex V3", Callback = function() Load("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/DarkDex.lua") end })

Rayfield:LoadConfiguration()
