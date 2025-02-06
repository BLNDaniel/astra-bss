local UILib = loadstring(game:HttpGet('https://raw.githubusercontent.com/StepBroFurious/Script/main/HydraHubUi.lua'))()
local Window = UILib.new("Bee Swarm Hub", "12345678", "Admin") -- Name, UserID, Rang

-- Tabs / Kategorien
local AutoFarm = Window:Category("AutoFarm", "rbxassetid://4483362458")
local Misc = Window:Category("Misc", "rbxassetid://4483362458")
local Combat = Window:Category("Combat", "rbxassetid://4483362458")
local Webhook = Window:Category("Webhook", "rbxassetid://4483362458")
local Quests = Window:Category("Quests", "rbxassetid://4483362458")
local Planters = Window:Category("Planters", "rbxassetid://4483362458")
local Config = Window:Category("Config", "rbxassetid://4483362458")

-- 🎮 AutoFarm Button
local AutoFarmButton = AutoFarm:Button("Start AutoFarm", "rbxassetid://4483362458")
local AutoFarmSection = AutoFarmButton:Section("AutoFarm Optionen", "Left")

AutoFarmSection:Button({
    Title = "Start AutoFarm",
    Description = "Fängt automatisch an zu farmen.",
    ButtonName = "Start"
}, function()
    print("AutoFarm gestartet!")
end)

-- 🛠️ Noclip Toggle im Misc Tab
local MiscButton = Misc:Button("Noclip", "rbxassetid://4483362458")
local MiscSection = MiscButton:Section("Noclip Einstellungen", "Left")

local noclip = false
local runService = game:GetService("RunService")

MiscSection:Toggle({
    Title = "Noclip",
    Description = "Aktiviert oder deaktiviert Noclip.",
    default = false
}, function(state)
    noclip = state
    while noclip do
        task.wait()
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- ⚙️ Config Einstellungen (z. B. Geschwindigkeit ändern)
local ConfigButton = Config:Button("Einstellungen", "rbxassetid://4483362458")
local ConfigSection = ConfigButton:Section("Spieler-Einstellungen", "Right")

ConfigSection:Slider({
    Title = "Spieler Geschwindigkeit",
    Description = "Ändert die Bewegungsgeschwindigkeit.",
    Min = 10,
    Max = 100,
    Default = 20
}, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
