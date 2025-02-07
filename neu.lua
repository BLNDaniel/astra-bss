-- Made by DannyGG with <3
local astrabsslib = loadstring(game:HttpGet("https://raw.githubusercontent.com/BLNDaniel/astra-bss/refs/heads/main/Astra%20Lib%20Src.lua"))()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Config-Library/main/Main.lua"))()

local Config = {
    useRemotes = false,
    autoCollecting = false,
    stopAll = false,
    walkspeedEnabled = false,
    defaultWalkspeed = 60,
    defaultTweenSpeed = 6,
    debugmode = false,
    autofarming = false,
    anonymousmode = false,
    hidetokens = false,
    hideparticles = false,
    hidebees = false,
    hideflowers = false,
    destroyballoons = false,
    destroytextures = false,
    destroydecorations = false,
    rendering = false,
    transparent = false,
    hideothers = false,
    antilag = false,
    url = "",
    enabled = false,
    interval = 1,
    settings = {
        sendBalloonPollen = false,
        sendNectars = false,
        sendPlanters = false,
        sendItems = false,
        sendQuests = false,
        sendDisconnect = false
    }
}

local hives = {
    {Name = "Hive 6", Position = Vector3.new(-186.31, 6.38, 330.88)},
    {Name = "Hive 5", Position = Vector3.new(-149.32, 6.38, 331.58)},
    {Name = "Hive 4", Position = Vector3.new(-113.12, 6.38, 330.47)},
    {Name = "Hive 3", Position = Vector3.new(-76.40, 6.38, 331.25)},
    {Name = "Hive 2", Position = Vector3.new(-39.46, 6.38, 330.91)},
    {Name = "Hive 1", Position = Vector3.new(-3.01, 6.38, 329.70)},
}

task.wait(2)

local success, loadedConfig = pcall(function()
   return Library:LoadConfig("astra/config.json")
end)

if success and loadedConfig then
    Config = loadedConfig
else
    print("No Config Found.")
end

local http = game:GetService("HttpService")
local player = game.Players.LocalPlayer

local function findValue(name)
    for _, v in pairs(player:GetChildren()) do
        if v:IsA("Folder") or v:IsA("Model") then
            for _, data in pairs(v:GetChildren()) do
                if (data:IsA("IntValue") or data:IsA("NumberValue")) and data.Name == name then
                    return data
                end
            end
        end
    end
    return nil
end

local function getStats()
    local honey = findValue("Honey")
    local pollen = findValue("Pollen")
    local capacity = findValue("Capacity")
    
    if Config.debugmode then
        if honey then
            print("[📦] Found Honey: " .. honey.Value)
        else
            print("[❌] Honey not found!")
        end
        
        if pollen then
            print("[📦] Found Pollen: " .. pollen.Value)
        else
            print("[❌] Pollen not found!")
        end
        
        if capacity then
            print("[📦] Found Capacity: " .. capacity.Value)
        else
            print("[❌] Capacity not found!")
        end
    end
    
    return {
        honey = honey,
        pollen = pollen,
        capacity = capacity
    }
end

local startStats = getStats()
local startHoney = startStats.honey and startStats.honey.Value or 0
local clientStartTime = tick()

local function formatTime(seconds)
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local sec = math.floor(seconds % 60)
    
    return string.format("%d Days, %02d:%02d:%02d", days, hours, minutes, sec)
end

local function formatNumber(number)
    if not number then return "0" end
    local formatted = tostring(math.floor(number))
    local k
    while true do  
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if k == 0 then break end
    end
    return formatted
end

local function calculateHoneyPerHour(sessionHoney, startTime)
    local timeElapsed = (tick() - startTime) / 3600
    return timeElapsed > 0 and (sessionHoney / timeElapsed) or 0
end

local function sendWebhook()
    if not Config.enabled then return end
    
    local http = request or syn.request  -- Unterstützt verschiedene Executors

    local currentStats = getStats()
    if not currentStats.honey then 
        if Config.debugmode then
            warn("[❌] Cannot send webhook: Stats not found")
        end
        return 
    end

    local currentHoney = currentStats.honey.Value
    local sessionHoney = currentHoney - startHoney
    local honeyPerHour = calculateHoneyPerHour(sessionHoney, clientStartTime)
    local uptime = formatTime(workspace.DistributedGameTime)
    
    local fields = {
        {
            ["name"] = "🍯 Current Honey",
            ["value"] = formatNumber(currentHoney),
            ["inline"] = true
        },
        {
            ["name"] = "📊 Session Honey",
            ["value"] = formatNumber(sessionHoney),
            ["inline"] = true
        },
        {
            ["name"] = "⏱️ Honey/Hour",
            ["value"] = formatNumber(honeyPerHour),
            ["inline"] = true
        },
        {
            ["name"] = "⌛ Uptime",
            ["value"] = uptime,
            ["inline"] = true
        }
    }

    if Config.settings.sendBalloonPollen and currentStats.pollen then
        table.insert(fields, {
            ["name"] = "🎈 Current Pollen",
            ["value"] = formatNumber(currentStats.pollen.Value),
            ["inline"] = true
        })
    end

    local data = {
        ["embeds"] = {{
            ["title"] = "🐝 BSS Status Update",
            ["description"] = "Current statistics for " .. player.Name,
            ["color"] = 16776960,
            ["fields"] = fields,
            ["footer"] = {
                ["text"] = "AstraBSS | " .. os.date("%Y-%m-%d %H:%M:%S")
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local jsonData = game:GetService("HttpService"):JSONEncode(data)

    local requestData = {
        Url = Config.url,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = jsonData
    }

    local success, response = pcall(function()
        return http(requestData)
    end)

    if success and response.StatusCode == 200 then
        if Config.debugmode then
            print("[✅] Webhook sent successfully!")
        end
    else
        warn("[❌] Failed to send webhook: " .. tostring(response and response.StatusMessage or "Unknown error"))
    end
end

-- UI Setup
astrabsslib.rank = "Premium"
local Wm = astrabsslib:Watermark("AstraBSS | v" .. astrabsslib.version ..  " | " .. astrabsslib:GetUsername() .. " | rank: " .. astrabsslib.rank)
local FpsWm = Wm:AddWatermark("fps: " .. astrabsslib.fps)
coroutine.wrap(function()
    while wait(.75) do
        FpsWm:Text("fps: " .. astrabsslib.fps)
    end
end)()

local Notif = astrabsslib:InitNotifications()

for i = 10,0,-1 do 
    task.wait(0.05)
    local LoadingASTRA = Notif:Notify("Loading Astra V1, please be patient.", 3, "information")
end 

astrabsslib.title = "AstraBSS"
astrabsslib:Introduction()
wait(1)
local Init = astrabsslib:Init()

local function formatTime(seconds)
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local sec = math.floor(seconds % 60)
    return string.format("%d Days, %02d:%02d:%02d", days, hours, minutes, sec)
end

local function getServerUptime()
    return "⏳ Server Uptime: idk bro stfu"
end

local function getPlayerUptime()
    return "🎮 Player Uptime: " .. formatTime(workspace.DistributedGameTime)
end

-- Home Tab
local HomeTab = Init:NewTab("Home")
local Information = HomeTab:NewSection("Information")
local PlayerUptimeLabel = HomeTab:NewLabel(getPlayerUptime(), "left")
local emptylabel = HomeTab:NewLabel(" ")
local ServerUptimeLabel = HomeTab:NewLabel(getServerUptime(), "left")

task.spawn(function()
    while true do
        wait(2)  
        ServerUptimeLabel:Text(getServerUptime())
        PlayerUptimeLabel:Text(getPlayerUptime())
    end
end)

local emptysection = HomeTab:NewSection(" ")

local stopall = HomeTab:NewToggle("Stop Everything", Config.stopAll, function(value)
    Config.stopAll = value
    if Config.debugmode then
        print(value and "✅ stopped everything" or "❌ started everything")
    end
end)

-- Farming Functions
local ToolCollectEvent = game:GetService("ReplicatedStorage").Events.ToolCollect
local VirtualInputManager = game:GetService("VirtualInputManager")

local function autoCollect()
    Config.autoCollecting = true  
    while Config.autoCollecting and not Config.stopAll do
        if Config.useRemotes then  
            ToolCollectEvent:FireServer()
        else  
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0) 
            wait(0.1)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        wait(1) 
    end
end

-- Farming Tab
local FarmingTab = Init:NewTab("Farming")
local FarmingSection = FarmingTab:NewSection("Farming")

local FieldSelector = FarmingTab:NewSelector("What Field Bro ?", "Selected Field", {"Sunflower Field", "Dandelion Field", "Mushroom Field", "Blue Flower Field", "Clover Field", "Strawberry Field", "Spider Field", "Bamboo Field", "Pineapple Patch", "Stump Field", "Cactus Field", "Pumpkin Patch", "Pine Tree Forest", "Rose Field", "Mountain Top Field", "Pepper Patch", "Coconut Field"}, function(d)
    print(d)
end)

local ToggleAutoFarm = FarmingTab:NewToggle("Autofarm", Config.autofarming, function(value)
    Config.autofarming = value
    if Config.debugmode then
        print(value and "✅ AutoFarm activated" or "❌ AutoFarm deactivated")
    end
end)

local ToggleAutoDig = FarmingTab:NewToggle("Auto Dig", Config.autoCollecting, function(value)
    if value then
        autoCollect()
    else
        Config.autoCollecting = false
    end
    if Config.debugmode then
        print(value and "✅ AutoDig activated" or "❌ AutoDig deactivated")
    end
end)

-- Combat Tab
local CombatTab = Init:NewTab("Combat")
local CombatSection = CombatTab:NewSection("Combat")

-- Quest Tab
local QuestTab = Init:NewTab("Quest")
local QuestSection = QuestTab:NewSection("Quest")

-- Planters Tab
local PlantersTab = Init:NewTab("Planters")
local PlantersSection = PlantersTab:NewSection("Planters")

-- Toys Tab
local ToysTab = Init:NewTab("Toys")
local ToysSection = ToysTab:NewSection("Toys")

-- Misc Tab
local MiscTab = Init:NewTab("Misc")
local MiscSection = MiscTab:NewSection("Misc")

-- Webhook Tab
local WebhookTab = Init:NewTab("Webhook")
local WebhookSection = WebhookTab:NewSection("Webhook")

local ToggleWebhook = WebhookTab:NewToggle("Enable Webhook", Config.enabled, function(value)
    Config.enabled = value
    if Config.debugmode then
        print(value and "✅ Webhook activated" or "❌ Webhook deactivated")
    end
end)

local WebhookLink = WebhookTab:NewTextbox("Webhook URL", "", "Webhook URL", "all", "small", true, false, function(val)
    Config.url = val
end)

local WebhookSlide = WebhookTab:NewSlider("Webhook Interval", "", true, "/", {min = 1, max = 60, default = Config.interval}, function(value)
    Config.interval = value
end)

local SendTest = WebhookTab:NewButton("Send Test", function()
    sendWebhook()
end)

local WebHookSettings = WebhookTab:NewSection("Webhook Settings")

local SendBallonPolls = WebhookTab:NewToggle("Send Balloon Pollen", Config.settings.sendBalloonPollen, function(value)
    Config.settings.sendBalloonPollen = value
end)

local SendNectars = WebhookTab:NewToggle("Send Nectars", Config.settings.sendNectars, function(value)
    Config.settings.sendNectars = value
end)

local SendPlanters = WebhookTab:NewToggle("Send Planters", Config.settings.sendPlanters, function(value)
    Config.settings.sendPlanters = value
end)

local SendItems = WebhookTab:NewToggle("Send Items", Config.settings.sendItems, function(value)
    Config.settings.sendItems = value
end)

local SendQuests = WebhookTab:NewToggle("Send Quests Done", Config.settings.sendQuests, function(value)
    Config.settings.sendQuests = value
end)

local SendDisconnect = WebhookTab:NewToggle("Send Disconnect", Config.settings.sendDisconnect, function(value)
    Config.settings.sendDisconnect = value
end)

-- Config Tab
local ConfigTab = Init:NewTab("Config")
local ConfigSection = ConfigTab:NewSection("Configuration")

local ToggleRemotes = ConfigTab:NewToggle("Use Remotes", Config.useRemotes, function(value)
    Config.useRemotes = value
    if Config.debugmode then
        print(value and "✅ Remotes activated" or "❌ Remotes deactivated")
    end
end)

-- Movement Section
local MovementSection = ConfigTab:NewSection("Movement")
local ToggleWalkspeed = ConfigTab:NewToggle("Walkspeed Hack", Config.walkspeedEnabled, function(value)
    Config.walkspeedEnabled = value
    if value then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Config.defaultWalkspeed
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
    if Config.debugmode then
        print(value and "✅ Walkspeed Hack activated" or "❌ Walkspeed Hack deactivated")
    end
end)

local WalkspeedSlide = ConfigTab:NewSlider("Walkspeed", "", true, "/", {min = 30, max = 100, default = Config.defaultWalkspeed}, function(value)
    Config.defaultWalkspeed = value
    if Config.walkspeedEnabled then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        if Config.debugmode then
            print("Walkspeed: " .. value)
        end
    end
end)

local TweenSpeedSlide = ConfigTab:NewSlider("TweenSpeed", "", true, "/", {min = 1, max = 10, default = Config.defaultTweenSpeed}, function(value)
    Config.defaultTweenSpeed = value
    -- tween speed
end)

-- Settings Section
local SettingsSection = ConfigTab:NewSection("Settings")

local SaveConfig = ConfigTab:NewButton("Save Config", function()
    Library:SaveConfig("astra/config.json", Config)
end)

-- Debug Tab
local DebugTab = Init:NewTab("Debug")
local DebugSection = DebugTab:NewSection("Debug")

local Toggledebug = DebugTab:NewToggle("Debug Logs", Config.debugmode, function(value)
    Config.debugmode = value
    if Config.debugmode then
        print(value and "✅ Debug Logs activated" or "❌ Debug Logs deactivated")
    end
end)

local ToggleAnonymous = DebugTab:NewToggle("Anonymous Mode", Config.anonymousmode, function(value)
    Config.anonymousmode = value
    if Config.debugmode then
        print(value and "✅ Anonymous Mode activated" or "❌ Anonymous Mode deactivated")
    end
end)

local AntiLagSection = DebugTab:NewSection("AntiLag")

local ToggleHideTokens = DebugTab:NewToggle("Hide Tokens", Config.hidetokens, function(value)
    Config.hidetokens = value
    if Config.debugmode then
        print(value and "✅ Hide Tokens activated" or "❌ Hide Tokens deactivated")
    end
end)

local ToggleHideParticles = DebugTab:NewToggle("Hide Particles", Config.hideparticles, function(value)
    Config.hideparticles = value
    if Config.debugmode then
        print(value and "✅ Hide Particles activated" or "❌ Hide Particles deactivated")
    end
end)

local ToggleHideBees = DebugTab:NewToggle("Hide Bees", Config.hidebees, function(value)
    Config.hidebees = value
    if Config.debugmode then
        print(value and "✅ Hide Bees activated" or "❌ Hide Bees deactivated")
    end
end)

local ToggleHideFlowers = DebugTab:NewToggle("Hide Flowers", Config.hideflowers, function(value)
    Config.hideflowers = value
    if Config.debugmode then
        print(value and "✅ Hide Flowers activated" or "❌ Hide Flowers deactivated")
    end
end)

local ToggleDestroyBalloons = DebugTab:NewToggle("Destroy Balloons", Config.destroyballoons, function(value)
    Config.destroyballoons = value
    if Config.debugmode then
        print(value and "✅ Destroy Balloons activated" or "❌ Destroy Balloons deactivated")
    end
end)

local ToggleDestroyTextures = DebugTab:NewToggle("Destroy Textures", Config.destroytextures, function(value)
    Config.destroytextures = value
    if Config.debugmode then
        print(value and "✅ Destroy Textures activated" or "❌ Destroy Textures deactivated")
    end
end)

local ToggleDestroyDec = DebugTab:NewToggle("Destroy Decorations", Config.destroydecorations, function(value)
    Config.destroydecorations = value
    if Config.debugmode then
        print(value and "✅ Destroy Decorations activated" or "❌ Destroy Decorations deactivated")
    end
end)

local Toggle3DRendering = DebugTab:NewToggle("Disable 3D Rendering", Config.rendering, function(value)
    Config.rendering = value
    if Config.debugmode then
        print(value and "✅ Disable 3D Rendering activated" or "❌ Disable 3D Rendering deactivated")
    end
end)

local Toggletransparent = DebugTab:NewToggle("Make Everything Transparent", Config.transparent, function(value)
    Config.transparent = value
    if Config.debugmode then
        print(value and "✅ Make Everything Transparent activated" or "❌ Make Everything Transparent deactivated")
    end
end)

local ToggleHideOthers = DebugTab:NewToggle("Hide Other Players", Config.hideothers, function(value)
    Config.hideothers = value
    if Config.debugmode then
        print(value and "✅ Hide Other Players activated" or "❌ Hide Other Players deactivated")
    end
end)

local ToggleAntiLag = DebugTab:NewToggle("AntiLag", Config.antilag, function(value)
    Config.antilag = value
    if Config.debugmode then
        print(value and "✅ AntiLag activated" or "❌ AntiLag deactivated")
    end
end)

-- UI Tab
local UITab = Init:NewTab("UI")
local UISection = UITab:NewSection("UI Settings")

local Keybind1 = UITab:NewKeybind("UI Key", Enum.KeyCode.RightAlt, function(key)
    Init:UpdateKeybind(Enum.KeyCode[key])
    if Config.debugmode then
        print("UI Key Toggled")
    end
end)

-- Start Webhook Loop
task.spawn(function()
    while true do
        if Config.enabled then
            sendWebhook()
        end
        task.wait(Config.interval)
    end
end)

local FinishedLoading = Notif:Notify("Loaded AstraBSS", 4, "success")

-- // FUNCTION DOCS: 
--[[
    MAIN COMPONENT DOCS:

    -- // local astrabsslib = loadstring(game:HttpGet(link: url))()
    -- // astrabsslib.title = text: string
    -- // local Window = astrabsslib:Init()

    -- [astrabsslib.title contains rich text]

    -- / astrabsslib:Remove()
    -- destroys the astrabsslib

    -- / astrabsslib:Text("new")
    -- sets the lbrary's text to something new

    - / astrabsslib:UpdateKeybind(Enum.KeyCode.RightAlt)
    -- sets the lbrary's keybind to switch visibility to something new

    __________________________

    -- // local notificationastrabsslib = astrabsslib:InitNotifications()
    -- // local Notification = notificationastrabsslib:Notify(text: string, time: number, type: string (information, notification, alert, error, success))

    -- [Notify contains rich text]

    -- / 3rd argument is a function, used like this:
    
    Notif:Notify("Function notification", 7, function()
        print("done")
    end)

    -- / Welcome:Text("new text")
    -- sets the notifications text to something differet [ADDS A +0.4 ONTO YOUR TIMER]

    __________________________

    -- // local Wm = astrabsslib:Watermark(text: string)

    -- [Watermark contains rich text]

    -- / Wm:Hide()
    -- hides the watermark from eye view

    -- / Wm:Show()
    -- makes the watermark visible at the top of your screen

    -- / Wm:Text("new")
    -- sets the watermark's text to something new

    -- / Wm:Remove()
    -- destroys the watermark

    __________________________

    -- // local Home = Init:NewTab(text: string)

    -- [tab title contains rich text]

    -- / Home:Open()
    -- opens the tab you want

    -- / Home:Remove()
    -- destroys the tab

    -- / Home:Hide()
    -- hides the tab from eye view

    -- / Home:Show()
    -- makes the tab visible on the selection table

    -- / Home:Text("new")
    -- sets the tab's text to something new

    __________________________

    -- [label contains rich text]

    -- / Label1:Text("new")
    -- sets the label's text to something new

    -- / Label1:Remove()
    -- destroys the label

    -- / Label1:Hide()
    -- hides the label from eye view

    -- / Label1:Show()
    -- makes the tab visible on the page that is used

    -- / Label1:Align("le")
    -- aligns the label to a new point in text X

    __________________________

    -- [Button contains rich text]

    -- / Button1:AddButton("text", function() end)
    -- adds a new button inside of the frame [CAN ONLY GO UP TO 4 BUTTONS AT A TIME]

    -- / Button1:Fire()
    -- executes the script within the button

    -- / Button1:Text("new")
    -- sets the button's text to something new

    -- / Button1:Hide()
    -- hides the button from eye view

    -- / Button1:Show()
    -- makes the button visible

    -- / Button1:Remove()
    -- destroys the button

    __________________________

    -- [Sections contain rich text]

    -- / Section1:Text("new")
    -- sets the section's text to something new

    -- / Section1:Hide()
    -- hides the section from eye view

    -- / Section1:Show()
    -- makes the section visible

    -- / Section1:Remove()
    -- destroys the section

    __________________________

    -- [Toggles contain rich text]

    -- / Toggle1:Text("new")
    -- sets the toggle's text to something new

    -- / Toggle1:Hide()
    -- hides the toggle from eye view

    -- / Toggle1:Show()
    -- makes the toggle visible

    -- / Toggle1:Remove()
    -- destroys the toggle

    -- / Toggle1:Change()
    -- changes the toggles state to the opposite

    -- / Toggle1:Set(true)
    -- sets the toggle to true even if it is true

    -- / Toggle1:AddKeybind(Enum.KeyCode.P, false, function() end) -- false / true is used for just changing the toggles state
    -- adds a keybind to the toggle

    -- / Toggle1:SetFunction(function() end)
    -- sets the toggles function

    __________________________

    -- [Keybinds contain rich text]

    -- / Keybind1:Text("new")
    -- sets the keybind's text to something new

    -- / Keybind1:Hide()
    -- hides the keybind from eye view

    -- / Keybind1:Show()
    -- makes the keybind visible

    -- / Keybind1:Remove()
    -- destroys the keybind

    -- / Keybind1:SetKey(Enum.KeyCode.P)
    -- sets the keybinds new key

    -- / Keybind1:Fire()
    -- fires the keybind function

    -- / Keybind1:SetFunction(function() end)
    -- sets the new keybind function

    __________________________

    -- [Textboxes contain rich text]

    -- / Textbox1:Input("new")
    -- sets the text box's input to something new

    -- / Textbox1:Place("new")
    -- sets the text box's placeholder to something new

    -- / Textbox1:Fire()
    -- fires the textbox function

    -- / Textbox1:SetFunction(function() end)
    -- sets the text boxes new function

    -- / Textbox1:Text("new")
    -- sets the textbox's text to something new

    -- / Textbox1:Hide()
    -- hides the textbox from eye view

    -- / Textbox1:Show()
    -- makes the textbox visible

    -- / Textbox1:Remove()
    -- destroys the textbox

    __________________________

    -- [Selectors contain rich text]

    -- / Selector1:SetFunction(function() end)
    -- sets the selector new function

    -- / Selector1:Text("new")
    -- sets the selector's text to something new

    -- / Selector1:Hide()
    -- hides the selector from eye view

    -- / Selector1:Show()
    -- makes the selector visible

    -- / Selector1:Remove()
    -- destroys the selector

    __________________________

    -- [Sliders contain rich text]

    -- / Slider1:Value(1)
    -- sets the slider new value

    -- / Slider1:SetFunction(function() end)
    -- sets the slider new function

    -- / Slider1:Text("new")
    -- sets the slider's text to something new

    -- / Slider1:Hide()
    -- hides the slider from eye view

    -- / Slider1:Show()
    -- makes the slider visible

    -- / Slider1:Remove()
    -- destroys the slider

    ---------------------------------------------------------------------------------------------------------

    MISC SEMI USELESS DOCS:

    -- / astrabsslib.rank = ""
    -- returns the rank you choose (default = "private")

    -- / astrabsslib.fps
    -- returns FPS you're getting in game

    -- / astrabsslib.version
    -- returns the version of the astrabsslib

    -- / astrabsslib.title = ""
    -- returns the title of the astrabsslib

    -- / astrabsslib:GetDay("word") -- word, short, month, year
    -- returns the os day

    -- / astrabsslib:GetTime("24h") -- 24h, 12h, minute, half, second, full, ISO, zone
    -- returns the os time

    -- / astrabsslib:GetMonth("word") -- word, short, digit
    -- returns the os month

    -- / astrabsslib:GetWeek("year_S") -- year_S, day, year_M
    -- returns the os week

    -- / astrabsslib:GetYear("digits") -- digits, full
    -- returns the os year

    -- / astrabsslib:GetUsername()
    -- returns the localplayers username

    -- / astrabsslib:GetUserId()
    -- returns the localplayers userid

    -- / astrabsslib:GetPlaceId()
    -- returns the games place id

    -- / astrabsslib:GetJobId()
    -- returns the games job id

    -- / astrabsslib:CheckIfLoaded()
    -- returns true if you're fully loaded

    -- / astrabsslib:Rejoin()
    -- rejoins the same server as you was in

    -- / astrabsslib:Copy("stuff")
    -- copies the inputed string

    -- / astrabsslib:UnlockFps(500) -- only works with synapse
    -- sets the max fps to something you choose
    
    -- / astrabsslib:PromptDiscord("invite")
    -- invites you to a discord
]]
