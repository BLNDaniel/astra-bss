-- Made by DannyGG with <3
local astrabsslib = loadstring(game:HttpGet("https://raw.githubusercontent.com/BLNDaniel/astra-bss/refs/heads/main/Astra%20Lib%20Src.lua"))()

-- Configuration
local Config = {
    useRemotes = false,
    autoCollecting = false,
    stopAll = false,
    walkspeedEnabled = false,
    defaultWalkspeed = 60,
    debugmode = false,
    autofarming = false
}

-- Webhook Configuration
local WebhookConfig = {
    url = "https://discord.com/api/webhooks/1329436163093692467/mtVp0o82K2i5OuMhHBbD2ZrnFHgxT4uI70cMh-dIBs8AlTyADzopX2ustcZCO6ulqAyM",
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

-- Services
local http = game:GetService("HttpService")
local player = game.Players.LocalPlayer

-- Improved Stats Functions
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
            print("[❌] Honey nicht gefunden!")
        end
        
        if pollen then
            print("[📦] Found Pollen: " .. pollen.Value)
        end
        
        if capacity then
            print("[📦] Found Capacity: " .. capacity.Value)
        end
    end
    
    return {
        honey = honey,
        pollen = pollen,
        capacity = capacity
    }
end

-- Initialize starting values
local startStats = getStats()
local startHoney = startStats.honey and startStats.honey.Value or 0
local clientStartTime = tick()

-- Webhook Functions
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
    if not WebhookConfig.enabled then return end
    
    local currentStats = getStats()
    if not currentStats.honey then 
        warn("[❌] Cannot send webhook: Honey stat not found")
        return 
    end

    local currentHoney = currentStats.honey.Value
    local sessionHoney = currentHoney - startHoney
    local honeyPerHour = calculateHoneyPerHour(sessionHoney, clientStartTime)
    
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
        }
    }

    if WebhookConfig.settings.sendBalloonPollen and currentStats.pollen then
        table.insert(fields, {
            ["name"] = "🎈 Current Pollen",
            ["value"] = formatNumber(currentStats.pollen.Value),
            ["inline"] = true
        })
    end

    if currentStats.capacity then
        table.insert(fields, {
            ["name"] = "💼 Capacity",
            ["value"] = formatNumber(currentStats.capacity.Value),
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

    local success, err = pcall(function()
        http:PostAsync(WebhookConfig.url, http:JSONEncode(data))
    end)

    if success and Config.debugmode then
        print("[✅] Webhook sent successfully!")
    elseif not success then
        warn("[❌] Failed to send webhook: " .. tostring(err))
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

-- Uptime Functions
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

local stopall = HomeTab:NewToggle("Stop Everything", false, function(value)
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
        wait(1.2) 
    end
end

-- Farming Tab
local FarmingTab = Init:NewTab("Farming")
local FarmingSection = FarmingTab:NewSection("Farming")

local ToggleAutoFarm = FarmingTab:NewToggle("Autofarm", false, function(value)
    Config.autofarming = value
    if Config.debugmode then
        print(value and "✅ AutoFarm activated" or "❌ AutoFarm deactivated")
    end
end)

local ToggleAutoDig = FarmingTab:NewToggle("Auto Dig", false, function(value)
    if value then
        autoCollect()  
    else
        Config.autoCollecting = false  
    end
    if Config.debugmode then
        print(value and "✅ AutoDig activated" or "❌ AutoDig deactivated")
    end
end)

-- Misc Tab
local MiscTab = Init:NewTab("Misc")
local MiscSection = MiscTab:NewSection("Misc")

-- Webhook Tab
local WebhookTab = Init:NewTab("Webhook")
local WebhookSection = WebhookTab:NewSection("Webhook")

local ToggleWebhook = WebhookTab:NewToggle("Enable Webhook", false, function(value)
    WebhookConfig.enabled = value
    if Config.debugmode then
        print(value and "✅ Webhook activated" or "❌ Webhook deactivated")
    end
end)

local WebhookSlide = WebhookTab:NewSlider("Webhook Interval", "", true, "/", {min = 1, max = 60, default = 20}, function(value)
    WebhookConfig.interval = value
end)

local WebHookSettings = WebhookTab:NewSection("Webhook Settings")

local SendBallonPolls = WebhookTab:NewToggle("Send Balloon Pollen", false, function(value)
    WebhookConfig.settings.sendBalloonPollen = value
end)

local SendNectars = WebhookTab:NewToggle("Send Nectars", false, function(value)
    WebhookConfig.settings.sendNectars = value
end)

local SendPlanters = WebhookTab:NewToggle("Send Planters", false, function(value)
    WebhookConfig.settings.sendPlanters = value
end)

local SendItems = WebhookTab:NewToggle("Send Items", false, function(value)
    WebhookConfig.settings.sendItems = value
end)

local SendQuests = WebhookTab:NewToggle("Send Quests Done", false, function(value)
    WebhookConfig.settings.sendQuests = value
end)

local SendDisconnect = WebhookTab:NewToggle("Send Disconnect", false, function(value)
    WebhookConfig.settings.sendDisconnect = value
end)

-- Config Tab
local ConfigTab = Init:NewTab("Config")
local ConfigSection = ConfigTab:NewSection("Configuration")

local ToggleRemotes = ConfigTab:NewToggle("Use Remotes", false, function(value)
    Config.useRemotes = value
    if Config.debugmode then
        print(value and "✅ Remotes activated" or "❌ Remotes deactivated")
    end
end)

-- Movement Section
local MovementSection = ConfigTab:NewSection("Movement")
local ToggleWalkspeed = ConfigTab:NewToggle("Walkspeed Hack", false, function(value)
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

local WalkspeedSlide = ConfigTab:NewSlider("Walkspeed", "", true, "/", {min = 30, max = 100, default = 60}, function(value)
    Config.defaultWalkspeed = value
    if Config.walkspeedEnabled then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        if Config.debugmode then
            print("Walkspeed: " .. value)
        end
    end
end)

local TweenSpeedSlide = ConfigTab:NewSlider("TweenSpeed", "", true, "/", {min = 1, max = 10, default = 6}, function(value)
    if Config.debugmode then
        print("TweenSpeed: " .. value)
    end
end)

-- Settings Section
local SettingsSection = ConfigTab:NewSection("Settings")

local Toggledebug = ConfigTab:NewToggle("Debug Logs", false, function(value)
    Config.debugmode = value
    if Config.debugmode then
        print(value and "✅ Debug Logs activated" or "❌ Debug Logs deactivated")
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
        if WebhookConfig.enabled then
            sendWebhook()
        end
        task.wait(WebhookConfig.interval)
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
