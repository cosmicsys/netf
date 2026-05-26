local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Universal Hub | Elite Edition",
   LoadingTitle = "Initializing Elite Framework...",
   LoadingSubtitle = "by Gemini CLI",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "EliteHub",
      FileName = "Main"
   },
   KeySystem = false
})

-- Tabs
local MainTab = Window:CreateTab("Movement", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local UtilityTab = Window:CreateTab("Utility", 4483362458)
local ScriptsTab = Window:CreateTab("Scripts", 4483362458)

-- Global States
local States = {
    Flying = false,
    FlySpeed = 50,
    Desync = false,
    DesyncMode = "Jitter",
    Visualizer = false,
    Netless = false
}

-- References
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Update Character Reference on Respawn
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
end)

-- [ MOVEMENT ] --
MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 500},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) Humanoid.WalkSpeed = v end,
})

MainTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 500},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(v) Humanoid.JumpPower = v end,
})

MainTab:CreateToggle({
   Name = "Flight",
   CurrentValue = false,
   Callback = function(state)
      States.Flying = state
      if state then
         local bv = Instance.new("BodyVelocity", RootPart)
         bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
         bv.Velocity = Vector3.new(0, 0, 0)
         bv.Name = "EliteFly"
         
         local bg = Instance.new("BodyGyro", RootPart)
         bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
         bg.P = 10000
         bg.Name = "EliteGyro"
         
         Humanoid.PlatformStand = true
         
         task.spawn(function()
            while States.Flying do
               local cam = workspace.CurrentCamera
               local dir = Vector3.new(0,0,0)
               if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
               if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
               if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
               if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
               if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
               if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
               
               bv.Velocity = dir * States.FlySpeed
               bg.CFrame = cam.CFrame
               RunService.RenderStepped:Wait()
            end
            bv:Destroy()
            bg:Destroy()
            Humanoid.PlatformStand = false
         end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 500},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(v) States.FlySpeed = v end,
})

-- [ UTILITY & DESYNC ] --
local fakeChar = nil
local function ClearVisualizer()
    if fakeChar then fakeChar:Destroy() fakeChar = nil end
end

UtilityTab:CreateDropdown({
   Name = "Desync Mode",
   Options = {"Jitter", "Orbit", "Lagger"},
   CurrentValue = "Jitter",
   Callback = function(v) States.DesyncMode = v end,
})

UtilityTab:CreateToggle({
   Name = "Elite Desync",
   CurrentValue = false,
   Callback = function(state)
      States.Desync = state
      if state then
         task.spawn(function()
            local angle = 0
            while States.Desync do
               local oldVel = RootPart.Velocity
               if States.DesyncMode == "Jitter" then
                  RootPart.Velocity = Vector3.new(math.random(-1e6, 1e6), 0, math.random(-1e6, 1e6))
               elseif States.DesyncMode == "Orbit" then
                  angle = angle + 0.1
                  RootPart.Velocity = Vector3.new(math.sin(angle) * 1e6, 0, math.cos(angle) * 1e6)
               elseif States.DesyncMode == "Lagger" then
                  RootPart.Velocity = Vector3.new(0, -1e7, 0)
               end
               RunService.Heartbeat:Wait()
               RootPart.Velocity = oldVel
               RunService.Heartbeat:Wait()
            end
         end)
         Rayfield:Notify({Title = "Elite Desync", Content = "Hitbox manipulation active.", Duration = 3})
      end
   end,
})

UtilityTab:CreateToggle({
   Name = "Desync Visualizer",
   CurrentValue = false,
   Callback = function(state)
      States.Visualizer = state
      if state then
         RunService.Heartbeat:Connect(function()
            if not States.Visualizer then ClearVisualizer() return end
            if not fakeChar then
                Character.Archivable = true
                fakeChar = Character:Clone()
                fakeChar.Parent = workspace
                for _, v in pairs(fakeChar:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.Transparency = 0.6
                        v.CanCollide = false
                        v.Material = Enum.Material.ForceField
                        v.Color = Color3.fromRGB(0, 255, 255)
                    elseif v:IsA("LocalScript") or v:IsA("Script") then
                        v:Destroy()
                    end
                end
            end
            fakeChar:SetPrimaryPartCFrame(RootPart.CFrame)
         end)
      else
         ClearVisualizer()
      end
   end,
})

UtilityTab:CreateToggle({
   Name = "Netless (Physics Bypass)",
   CurrentValue = false,
   Callback = function(state)
      States.Netless = state
      if state then
         task.spawn(function()
            while States.Netless do
               for _, v in pairs(Character:GetChildren()) do
                  if v:IsA("BasePart") then
                     v.Velocity = Vector3.new(0, -32, 0)
                  end
               end
               RunService.Stepped:Wait()
            end
         end)
      end
   end,
})

-- [ VISUALS ] --
VisualsTab:CreateButton({
   Name = "Elite ESP",
   Callback = function()
      for _, p in pairs(Players:GetPlayers()) do
         if p ~= LocalPlayer and p.Character then
            local h = Instance.new("Highlight", p.Character)
            h.FillColor = Color3.fromRGB(0, 255, 255)
            h.OutlineColor = Color3.fromRGB(255, 255, 255)
         end
      end
   end,
})

-- [ SCRIPTS ] --
local function Load(url) loadstring(game:HttpGet(url))() end

ScriptsTab:CreateButton({ Name = "Infinite Yield", Callback = function() Load('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source') end })
ScriptsTab:CreateButton({ Name = "CMD-X", Callback = function() Load("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source") end })
ScriptsTab:CreateButton({ Name = "Dark Dex V3", Callback = function() Load("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/DarkDex.lua") end })
ScriptsTab:CreateButton({ Name = "SimpleSpy", Callback = function() Load("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpy/master/SimpleSpySource.lua") end })

Rayfield:LoadConfiguration()
