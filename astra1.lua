local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
    Name = "Bee Swarm Hub",
    LoadingTitle = "Bee Swarm Hub",
    LoadingSubtitle = "by DeinName",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "BeeSwarmHub",
       FileName = "UI_Config"
    },
    Discord = {
       Enabled = false,
       Invite = "discordlinknein", -- Dein Discord Invite
       RememberJoins = true
    },
    KeySystem = false
})

-- 🔹 Tabs erstellen
local AutoFarmTab = Window:CreateTab("AutoFarm", 4483362458) -- Icon ID ändern
local MiscTab = Window:CreateTab("Misc", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483362458)
local WebhookTab = Window:CreateTab("Webhook", 4483362458)
local QuestsTab = Window:CreateTab("Quests", 4483362458)
local PlantersTab = Window:CreateTab("Planters", 4483362458)
local ConfigTab = Window:CreateTab("Config", 4483362458)

-- 🛠️ Noclip in Misc hinzufügen
local noclip = false
runservice = game:GetService("RunService")

local NoclipToggle = MiscTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(value)
        noclip = value
        while noclip do
            task.wait()
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
})

-- 🚀 AutoFarm Button (Beispiel)
AutoFarmTab:CreateButton({
    Name = "Start AutoFarm",
    Callback = function()
        print("AutoFarm gestartet!")
    end
})

-- ⚙️ Config Slider
ConfigTab:CreateSlider({
    Name = "Speed",
    Range = {1, 100},
    Increment = 1,
    CurrentValue = 20,
    Flag = "SpeedSlider",
    Callback = function(value)
        print("Speed auf:", value)
    end
})

