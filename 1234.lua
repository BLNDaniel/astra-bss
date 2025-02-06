local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Consistt/Ui/main/UnLeaked"))()

library.rank = "developer"
local Wm = library:Watermark("Astrabss | v" .. library.version .. " | " .. library:GetUsername() .. " | rank: " .. library.rank)
local FpsWm = Wm:AddWatermark("fps: " .. library.fps)
coroutine.wrap(function()
    while wait(.75) do
        FpsWm:Text("fps: " .. library.fps)
    end
end)()

local Notif = library:InitNotifications()
Notif:Notify("Loading Astrabss with xsx lib, please wait...", 3, "information")

library.title = "Astrabss"
library:Introduction()
wait(1)
local Init = library:Init()

-- UI Toggle Button
local UI_Toggle = Instance.new("TextButton")
UI_Toggle.Parent = game.CoreGui
UI_Toggle.Size = UDim2.new(0, 100, 0, 50)
UI_Toggle.Position = UDim2.new(1, -120, 0.5, -25) -- Rechts am Bildschirmrand
UI_Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
UI_Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
UI_Toggle.Font = Enum.Font.SourceSansBold
UI_Toggle.TextSize = 18
UI_Toggle.Text = "Toggle UI"

local UI_Visible = true
UI_Toggle.MouseButton1Click:Connect(function()
    UI_Visible = not UI_Visible
    if UI_Visible then
        Init:Show()
    else
        Init:Hide()
    end
end)

-- Tabs erstellen
local AutoFarmTab = Init:NewTab("AutoFarm")
local ToysTab = Init:NewTab("Toys")
local MiscTab = Init:NewTab("Misc")
local WebhookTab = Init:NewTab("Webhook")
local CombatTab = Init:NewTab("Combat")
local QuestsTab = Init:NewTab("Quests")
local PlantersTab = Init:NewTab("Planters")
local ConfigTab = Init:NewTab("Config")

-- Sections für Misc
local MiscSection = MiscTab:NewSection("Miscellaneous Features")

-- Noclip-Funktion
local NoclipEnabled = false
local function ToggleNoclip(state)
    NoclipEnabled = state
    local character = game.Players.LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end
end

-- Toggle-Option für Noclip (Richtig innerhalb der Section!)
local NoclipCheckbox = MiscSection:NewToggle("Enable Noclip", false, function(value)
    ToggleNoclip(value)
    print("Noclip " .. (value and "enabled" or "disabled"))
end)

-- Walkspeed-Funktion
local WalkspeedEnabled = false
local DefaultWalkspeed = 69
local Player = game.Players.LocalPlayer

local function SetWalkspeed(value)
    if WalkspeedEnabled and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = value
    end
end

-- Toggle-Option für Walkspeed (Innerhalb der Section!)
local WalkspeedCheckbox = MiscSection:NewToggle("Enable Walkspeed", false, function(value)
    WalkspeedEnabled = value
    if value then
        SetWalkspeed(DefaultWalkspeed)
    else
        SetWalkspeed(16) -- Standard Walkspeed in Roblox
    end
    print("Walkspeed " .. (value and "enabled" or "disabled"))
end)

-- Slider für Walkspeed
local WalkspeedSlider = MiscSection:NewSlider("Walkspeed Value", "", true, "/", {min = 16, max = 90, default = DefaultWalkspeed}, function(value)
    if WalkspeedEnabled then
        SetWalkspeed(value)
    end
    print("Walkspeed set to " .. value)
end)

-- Fertig geladen Nachricht
Notif:Notify("Astrabss loaded successfully!", 4, "success")
