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
    SpeedBypass = false,
    BypassSpeed = 50,
    Netless = false,
    Lagger = false
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
   Name = "Speed Bypass (CFrame)",
   CurrentValue = false,
   Callback = function(state)
      States.SpeedBypass = state
      if state then
         task.spawn(function()
            while States.SpeedBypass do
               if Humanoid.MoveDirection.Magnitude > 0 then
                  RootPart.CFrame = RootPart.CFrame + (Humanoid.MoveDirection * (States.BypassSpeed / 100))
               end
               RunService.Heartbeat:Wait()
            end
         end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "Bypass Speed",
   Range = {10, 200},
   Increment = 5,
   CurrentValue = 50,
   Callback = function(v) States.BypassSpeed = v end,
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

-- [ UTILITY ] --
UtilityTab:CreateButton({
   Name = "Remote Deobfuscator",
   Callback = function()
      local count = 0
      for _, v in pairs(game:GetDescendants()) do
         if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            if v.Name:find("/") then
               local newName = ""
               for code in v.Name:gmatch("(%d+)") do
                  newName = newName .. string.char(tonumber(code))
               end
               if newName ~= "" then
                  v.Name = newName
                  count = count + 1
               end
            end
         end
      end
      Rayfield:Notify({Title = "Deobfuscator", Content = "Successfully cleaned " .. count .. " obfuscated remotes.", Duration = 5})
   end,
})

UtilityTab:CreateToggle({
   Name = "Client Lagger",
   CurrentValue = false,
   Callback = function(state)
      States.Lagger = state
      if state then
         task.spawn(function()
            while States.Lagger do
               for i = 1, 1000 do
                  local p = Instance.new("Part")
                  p.Transparency = 1
                  p.CanCollide = false
                  p.Anchored = true
                  p:Destroy()
               end
               RunService.Heartbeat:Wait()
            end
         end)
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
