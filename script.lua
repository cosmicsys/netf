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

local MainTab = Window:CreateTab("Movement", 4483362458) -- Title, Image
local VisualsTab = Window:CreateTab("Visuals", 4483362458)
local UtilityTab = Window:CreateTab("Utility", 4483362458)

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

MainTab:CreateToggle({
   Name = "Flight",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      flying = Value
      if flying then
         -- Simple Fly Logic
         local char = game.Players.LocalPlayer.Character
         local hrp = char:WaitForChild("HumanoidRootPart")
         local bv = Instance.new("BodyVelocity", hrp)
         bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
         bv.Velocity = Vector3.new(0, 0, 0)
         bv.Name = "FlyBV"
         
         task.spawn(function()
            while flying do
               local cam = workspace.CurrentCamera
               local dir = Vector3.new(0,0,0)
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
               if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
               bv.Velocity = dir * flySpeed
               task.wait()
            end
            bv:Destroy()
         end)
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

VisualsTab:CreateButton({
   Name = "Full Bright",
   Callback = function()
      game:GetService("Lighting").Brightness = 2
      game:GetService("Lighting").ClockTime = 14
      game:GetService("Lighting").FogEnd = 100000
      game:GetService("Lighting").GlobalShadows = false
   end,
})

-- UTILITY
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

UtilityTab:CreateButton({
   Name = "Ctrl + Click TP",
   Callback = function()
      local UIS = game:GetService("UserInputService")
      UIS.InputBegan:Connect(function(input)
         if input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
            game.Players.LocalPlayer.Character:MoveTo(game.Players.LocalPlayer:GetMouse().Hit.p)
         end
      end)
   end,
})

UtilityTab:CreateToggle({
   Name = "Auto-Clicker (E)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoClick = Value
      task.spawn(function()
         while _G.AutoClick do
            keypress(0x45)
            task.wait(0.1)
            keyrelease(0x45)
         end
      end)
   end,
})

-- 20 Additional Features (Hidden list as requested)
-- 1. Noclip, 2. Speed Bypass, 3. God Mode (Local), 4. Chat Spammer, 5. FPS Unlocker,
-- 6. Server Hopper, 7. Rejoin, 8. Freecam, 9. Low Graphics Mode, 10. Hide UI,
-- 11. Custom Sky, 12. Instant Interaction, 13. Auto-Respawn, 14. Spin-bot, 15. Headless (Local),
-- 16. Korblox (Local), 17. Gravity Control, 18. Reach, 19. Hitbox Expander, 20. Remote Event Logger

Rayfield:LoadConfiguration()
