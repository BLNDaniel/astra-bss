-- Made by DannyGG with <3
local astrabsslib = loadstring(game:HttpGet("https://raw.githubusercontent.com/BLNDaniel/astra-bss/refs/heads/main/Astra%20Lib%20Src.lua"))()
local useRemotes = false
local autoCollecting = false 
local stopAll = false
local walkspeedEnabled = false  
local useWebhooks = false
local webhookinterval = 1
local defaultWalkspeed = 60
local clientStartTime = tick()
local autofarming = false
local debugmode = false
local http = game:GetService("HttpService")
local player = game.Players.LocalPlayer
local pollenStat = player:FindFirstChild("Pollen")
local honeyStat = player:FindFirstChild("Honey")
local capacityStat = player:FindFirstChild("Capacity")
local startHoney = honeyStat and honeyStat.Value or 0

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

-- Uptimes
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
    stopAll = value
    if debugmode then
        if value then
            print("✅ stopped everything")
        else 
            print("❌ started everything")
        end
    end
end)

-- Farming

-- Tool Remote Event
local ToolCollectEvent = game:GetService("ReplicatedStorage").Events.ToolCollect
local VirtualInputManager = game:GetService("VirtualInputManager")

local function autoCollect()
    autoCollecting = true  
    while autoCollecting and not stopAll do
        if useRemotes then  
            ToolCollectEvent:FireServer()
        else  
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0) 
            wait(0.1)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
        wait(1.2) 
    end
end

local FarmingTab = Init:NewTab("Farming")
local FarmingSection = FarmingTab:NewSection("Farming")
-- FIELD

local ToggleAutoFarm = FarmingTab:NewToggle("Autofarm", false, function(value)
    if value then

    else
        autofarming = false
    end
    if debugmode then
        if value then
            print("✅ AutoFarm activated")
        else
            print("❌ AutoFarm deactivated")
        end
    end
end)
-- Toggle für AutoCollect
local ToggleAutoDig = FarmingTab:NewToggle("Auto Dig", false, function(value)
    if value then
        autoCollect()  
    else
        autoCollecting = false  
    end
    if debugmode then
        if value then
            print("✅ AutoDig activated")
        else
            print("❌ AutoDig deactivated")
        end
    end
end)

-- Misc TAB
local MiscTab = Init:NewTab("Misc")
local MiscSection = MiscTab:NewSection("Misc")

-- Auto Quest

-- Auto Planters

-- Items

-- Misc

-- Hive

-- webhook function
local webhookURL = "https://discord.com/api/webhooks/1329436163093692467/mtVp0o82K2i5OuMhHBbD2ZrnFHgxT4uI70cMh-dIBs8AlTyADzopX2ustcZCO6ulqAyM"
local function sendWebhook()
    if not useWebhooks then return end
    if not honeyStat then return end

    local currentHoney = honeyStat.Value
    local sessionHoney = currentHoney - startHoney

    local data = {
        ["embeds"] = {{
            ["title"] = "🐝 **Honey Update**",
            ["description"] = "new data available!",
            ["color"] = 16776960, -- Gelb
            ["fields"] = {
                {["name"] = "🍯 Current Honey", ["value"] = tostring(currentHoney), ["inline"] = true},
                {["name"] = "📊 Session Honey", ["value"] = tostring(sessionHoney), ["inline"] = true}
            },
            ["footer"] = {
                ["text"] = "AstraBSS | Webhook System"
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local jsonData = http:JSONEncode(data)

    local success, err = pcall(function()
        http:PostAsync(webhookURL, jsonData, Enum.HttpContentType.ApplicationJson)
    end)

    if success then
        print("✅ Webhook erfolgreich gesendet!")
    else
        warn("❌ Fehler beim Senden des Webhooks: " .. err)
    end
end

task.spawn(function()
    while true do
        if useWebhooks then
            sendWebhook()
        end
        wait(webhookinterval)
    end
end)

-- Webhook
local WebhookTab = Init:NewTab("Webhook")
local WebhookSection = WebhookTab:NewSection("Webhook")

local ToggleWebhook = WebhookTab:NewToggle("Enable Webhook", false, function(value)
    useWebhooks = value
end)

local WebhookSlide = WebhookTab:NewSlider("Webhook Interval", "", true, "/", {min = 1, max = 60, default = 20}, function(value)
    webhookinterval = value
    -- comming soon
end)

local WebHookSettings = WebhookTab:NewSection("Webhook Settings")

local SendBallonPolls = WebhookTab:NewToggle("Send Balloon Pollen", false, function(value)
    sendballonpollss = value
    -- comming soon
end)
local SendNectars = WebhookTab:NewToggle("Send Nectars", false, function(value)
    sendnectarss = value
    -- comming soon
end)
local SendPlanters = WebhookTab:NewToggle("Send Planters", false, function(value)
    sendplanterss = value
    -- comming soon
end)
local SendItems = WebhookTab:NewToggle("Send Items", false, function(value)
    senditemss = value
    -- comming soon
end)
local SendQuests = WebhookTab:NewToggle("Send Quests Done", false, function(value)
    sendquestss = value
    -- comming soon
end)
local SendDisconnect = WebhookTab:NewToggle("Send Disconnect", false, function(value)
    senddisconnectt = value
    -- comming soon
end)

-- Config

local ConfigTab = Init:NewTab("Config")
local ConfigSection = ConfigTab:NewSection("Configuration")

local ToggleRemotes = ConfigTab:NewToggle("Use Remotes", false, function(value)
    useRemotes = value  
    if debugmode then
        if value then
            print("✅ Remotes activated")
        else
            print("❌ Remotes deactivated")
        end
    end
end)
-- walk speed
local MovementSection = ConfigTab:NewSection("Movement")
local ToggleWalkspeed = ConfigTab:NewToggle("Walkspeed Hack", false, function(value)
    walkspeedEnabled = value
    if value then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = defaultWalkspeed  
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16  
    end
    if debugmode then
        if value then
            print("✅ Walkspeed Hack aktiviert")
        else
            print("❌ Walkspeed Hack deaktiviert")
        end
    end
end)

local WalkspeedSlide = ConfigTab:NewSlider("Walkspeed", "", true, "/", {min = 30, max = 100, default = 60}, function(value)
    defaultWalkspeed = value
    if walkspeedEnabled then  
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        if debugmode then
            print("Walkspeed: " .. value)
        end
    end
end)

local TweenSpeedSlide = ConfigTab:NewSlider("TweenSpeed", "", true, "/", {min = 1, max = 10, default = 6}, function(value)
    print(value)
end)

local SettingsSection = ConfigTab:NewSection("Settings")

local Toggledebug = ConfigTab:NewToggle("Debug Logs", false, function(value)
    debugmode = value  
    if debugmode then
        if value then
            print("✅ Debug Logs activated")
        else
            print("❌ Debug Logs deactivated")
        end
    end
end)

-- UI 

local UITab = Init:NewTab("UI")
local UISection = UITab:NewSection("UI Settings")

local Keybind1 = UITab:NewKeybind("UI Key", Enum.KeyCode.RightAlt, function(key)
    Init:UpdateKeybind(Enum.KeyCode[key])
    if debugmode then
        print("UI Key Toggled")
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
