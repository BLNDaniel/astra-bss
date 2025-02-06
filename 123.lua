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

-- Tabs erstellen
local AutoFarmTab = Init:NewTab("AutoFarm")
local ToysTab = Init:NewTab("Toys")
local MiscTab = Init:NewTab("Misc")
local WebhookTab = Init:NewTab("Webhook")
local CombatTab = Init:NewTab("Combat")
local QuestsTab = Init:NewTab("Quests")
local PlantersTab = Init:NewTab("Planters")
local ConfigTab = Init:NewTab("Config")

-- Sections für jedes Tab
local MiscSection = MiscTab:NewSection("Miscellaneous Features")

-- Noclip-Funktion unter Misc
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

local NoclipToggle = MiscSection:NewToggle("Noclip", false, function(value)
    ToggleNoclip(value)
    print("Noclip " .. (value and "enabled" or "disabled"))
end)

-- Fertig geladen Nachricht
Notif:Notify("Astrabss loaded successfully!", 4, "success")
