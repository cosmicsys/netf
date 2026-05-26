local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Universal Hub | Premium",
   LoadingTitle = "Universal Script Loading...",
   LoadingSubtitle = "by Gemini CLI",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "UniversalHub",
      FileName = "Config"
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Movement", 4483362458)
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local UtilityTab = Window:CreateTab("Utility", 4483362458)
local ScriptsTab = Window:CreateTab("Scripts", 4483362458)

-- Variables
local flying = false
local flySpeed = 50
local hum = game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid")

-- MOVEMENT FEATURES
MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 500},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "WS",
   Callback = function(Value)
      hum.WalkSpeed = Value
   end,
})

MainTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 500},
   Increment = 1,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JP",
   Callback = function(Value)
      hum.JumpPower = Value
   end,
})

-- FIXED FLY SCRIPT
MainTab:CreateToggle({
   Name = "Flight",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      flying = Value
      local player = game.Players.LocalPlayer
      local char = player.Character or player.CharacterAdded:Wait()
      local hrp = char:WaitForChild("HumanoidRootPart")
      
      if flying then
         local bodyVel = Instance.new("BodyVelocity")
         bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
         bodyVel.Velocity = Vector3.new(0, 0, 0)
         bodyVel.Name = "FlyVelocity"
         bodyVel.Parent = hrp
         
         local bodyGyro = Instance.new("BodyGyro")
         bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
         bodyGyro.P = 9000
         bodyGyro.D = 400
         bodyGyro.CFrame = hrp.CFrame
         bodyGyro.Name = "FlyGyro"
         bodyGyro.Parent = hrp
         
         hum.PlatformStand = true
         
         task.spawn(function()
            while flying do
               local camera = workspace.CurrentCamera
               local moveDir = Vector3.new(0, 0, 0)
               
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                  moveDir = moveDir + camera.CFrame.LookVector
               end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                  moveDir = moveDir - camera.CFrame.LookVector
               end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                  moveDir = moveDir - camera.CFrame.RightVector
               end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                  moveDir = moveDir + camera.CFrame.RightVector
               end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                  moveDir = moveDir + Vector3.new(0, 1, 0)
               end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                  moveDir = moveDir - Vector3.new(0, 1, 0)
               end
               
               bodyVel.Velocity = moveDir * flySpeed
               bodyGyro.CFrame = camera.CFrame
               task.wait()
            end
            bodyVel:Destroy()
            bodyGyro:Destroy()
            hum.PlatformStand = false
         end)
      else
         if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
         if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
         hum.PlatformStand = false
      end
   end,
})

MainTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 500},
   Increment = 5,
   Suffix = "Studs",
   CurrentValue = 50,
   Flag = "FlySpeed",
   Callback = function(Value)
      flySpeed = Value
   end,
})

MainTab:CreateButton({
   Name = "Infinite Jump",
   Callback = function()
      game:GetService("UserInputService").JumpRequest:Connect(function()
         game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
      end)
      Rayfield:Notify({Title = "Enabled", Content = "Infinite Jump is now active", Duration = 3})
   end,
})

-- VISUALS (ESP & More)
VisualsTab:CreateButton({
   Name = "Simple ESP",
   Callback = function()
      for _, p in pairs(game.Players:GetPlayers()) do
         if p ~= game.Players.LocalPlayer and p.Character then
            local highlight = Instance.new("Highlight", p.Character)
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
         end
      end
   end,
})

VisualsTab:CreateSlider({
   Name = "Field of View",
   Range = {70, 120},
   Increment = 1,
   CurrentValue = 70,
   Callback = function(Value)
      workspace.CurrentCamera.FieldOfView = Value
   end,
})

-- UTILITY
local desyncEnabled = false
local netlessEnabled = false
local desyncMode = "Jitter"

-- FFlag Premium Networking Optimization
local function setPremiumNetworking(state)
    local s = settings()
    if state then
        s.Physics.AllowSleep = false
        s.Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
        s.Physics.ThrottleAdjustTime = 0
        pcall(function()
            setfflag("DFFlagDebugRenderCloudShadows", "False")
            setfflag("FIntAntialiasingQuality", "0")
            setfflag("FIntRenderShadowIntensity", "0")
            setfflag("DFFlagVariableMaxSimulationTimeSteps", "True")
            setfflag("FIntPhysicsSolverIterationLimit", "1")
        end)
    else
        s.Physics.AllowSleep = true
        s.Physics.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Default
    end
end

UtilityTab:CreateDropdown({
   Name = "Desync Mode",
   Options = {"Jitter", "Orbital", "Static"},
   CurrentValue = "Jitter",
   Flag = "DesyncMode",
   Callback = function(Option)
      desyncMode = Option
   end,
})

UtilityTab:CreateToggle({
   Name = "Premium Desync",
   CurrentValue = false,
   Flag = "PremiumDesyncToggle",
   Callback = function(Value)
      desyncEnabled = Value
      setPremiumNetworking(Value)
      
      if desyncEnabled then
         task.spawn(function()
            local rs = game:GetService("RunService")
            local lp = game.Players.LocalPlayer
            local angle = 0
            
            while desyncEnabled do
               local char = lp.Character
               local hrp = char and char:FindFirstChild("HumanoidRootPart")
               if hrp then
                  local oldVel = hrp.Velocity
                  local oldCFrame = hrp.CFrame
                  
                  if desyncMode == "Jitter" then
                     hrp.Velocity = Vector3.new(math.random(-1000000, 1000000), 0, math.random(-1000000, 1000000))
                  elseif desyncMode == "Orbital" then
                     angle = angle + 0.5
                     hrp.Velocity = Vector3.new(math.sin(angle) * 1000000, 0, math.cos(angle) * 1000000)
                  elseif desyncMode == "Static" then
                     hrp.Velocity = Vector3.new(0, 9e9, 0)
                  end
                  
                  rs.Heartbeat:Wait()
                  hrp.Velocity = oldVel
               end
               rs.Heartbeat:Wait()
            end
         end)
         Rayfield:Notify({Title = "Premium Active", Content = "Networking desynchronized via " .. desyncMode .. " mode.", Duration = 4})
      end
   end,
})

UtilityTab:CreateToggle({
   Name = "Netless (Physics Bypass)",
   CurrentValue = false,
   Flag = "NetlessToggle",
   Callback = function(Value)
      netlessEnabled = Value
      if netlessEnabled then
         task.spawn(function()
            local rs = game:GetService("RunService")
            while netlessEnabled do
               local char = game.Players.LocalPlayer.Character
               if char then
                  for _, v in pairs(char:GetChildren()) do
                     if v:IsA("BasePart") then
                        v.Velocity = Vector3.new(0, -31, 0)
                        v.CanCollide = false
                     end
                  end
               end
               rs.Stepped:Wait()
            end
         end)
      end
   end,
})

UtilityTab:CreateButton({
   Name = "Anti-AFK",
   Callback = function()
      local virtualUser = game:GetService("VirtualUser")
      game.Players.LocalPlayer.Idled:Connect(function()
         virtualUser:CaptureController()
         virtualUser:ClickButton2(Vector2.new())
      end)
      Rayfield:Notify({Title = "Active", Content = "Anti-AFK is running", Duration = 5})
   end,
})

-- SCRIPTS TAB
ScriptsTab:CreateButton({
   Name = "Infinite Yield",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})

ScriptsTab:CreateButton({
   Name = "CMD-X",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source", true))()
   end,
})

ScriptsTab:CreateButton({
   Name = "Dark Dex V3",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/DarkDex.lua"))()
   end,
})

ScriptsTab:CreateButton({
   Name = "SimpleSpy",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpy/master/SimpleSpySource.lua"))()
   end,
})

ScriptsTab:CreateButton({
   Name = "Remote Spy G2L",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/Hydroxide/main/init.lua"))()
   end,
})

Rayfield:LoadConfiguration()
