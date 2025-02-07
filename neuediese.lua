-- Made by DannyGG with <3
local astrabsslib = loadstring(game:HttpGet("https://raw.githubusercontent.com/BLNDaniel/astra-bss/refs/heads/main/Astra%20Lib%20Src.lua"))()
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Config-Library/main/Main.lua"))()

local Config = {
    useRemotes = false,
    autoCollecting = false,
    stopAll = false,
    walkspeedEnabled = false,
    defaultWalkspeed = 60,
    defaultTweenSpeed = 3,
    debugmode = false,
    autofarming = false,
    anonymousmode = false,
    hidetokens = false,
    hideparticles = false,
    hidebees = false,
    hideflowers = false,
    destroyballoons = false,
    destroytextures = false,
    selectedField = "SunflowerField",
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

local fieldData = {
    PineTreeForest = {
        Position = Vector3.new(-328.67, 65.5, -187.35), 
        Size = Vector3.new(90.62000274658203, 1, 121.5) 
    },
    SunflowerField = {
        Position = Vector3.new(-208.951294, 1.5, 176.579224),
        Size = Vector3.new(80.71003723144531, 1, 131.50999450683594)
    },
    CloverField = {
        Position = Vector3.new(157.547073, 31.608448, 196.350006),
        Size = Vector3.new(106.49425506591797, 2, 118.75)
    },
    BlueFlowerField = {
        Position = Vector3.new(146.865021, 2.13494039, 99.3078308),
        Size = Vector3.new(171.62998962402344, 2, 67.66536712646484)
    },
    MushroomField = {
        Position = Vector3.new(-89.7000122, 1.95073581, 111.725006),
        Size = Vector3.new(128.5, 2, 91.5)
    },
    StrawberryField = {
        Position = Vector3.new(-178.174973, 18.1322384, -9.8549881),
        Size = Vector3.new(89.64999389648438, 2, 106.29002380371094)
    },
    BambooField = {
        Position = Vector3.new(132.963409, 18.1719551, -25.6000061),
        Size = Vector3.new(156.4501190185547, 2, 74.79998779296875)
    },
    SpiderField = {
        Position = Vector3.new(-43.4654312, 18.1220875, -13.5899963),
        Size = Vector3.new(112.31002807617188, 2, 106.01997375488281)
    },
    CactusField = {
        Position = Vector3.new(-188.5, 65.5000153, -101.595818),
        Size = Vector3.new(135, 1, 68.80997467041016)
    },
    PumpkinPatch = {
        Position = Vector3.new(-188.5, 65.5000153, -183.845093),
        Size = Vector3.new(135, 1, 68.80997467041016)
    },
    RoseField = {
        Position = Vector3.new(-327.459839, 17.5552464, 129.496735),
        Size = Vector3.new(123.06999206542969, 1, 82.8600082397461)
    },
    PineapplePatch = {
        Position = Vector3.new(256.498108, 66.1299973, -207.479324),
        Size = Vector3.new(130.67312622070312, 2, 91.11000061035156)
    },
    StumpField = {
        Position = Vector3.new(424.483276, 94.4255676, -174.810959),
        Size = Vector3.new(110.47999572753906, 2.609133005142212, 113.31136322021484)
    },
    CoconutField = {
        Position = Vector3.new(-254.478104, 68.9707947, 469.459045),
        Size = Vector3.new(120.31002044677734, 1, 84.32997131347656)
    },
    PepperPatch = {
        Position = Vector3.new(-488.761566, 120.701508, 535.680176),
        Size = Vector3.new(82.3900375366211, 1, 110.54999542236328)
    },
    MountainTopField = {
        Position = Vector3.new(77.6849823, 173.500015, -165.431),
        Size = Vector3.new(97.72999572753906, 1, 110.82001495361328)
    },
    DandelionField = {
        Position = Vector3.new(-29.6986389, 1.5, 221.572845),
        Size = Vector3.new(143.65000915527344, 1, 72.5)
    }
}

local hives = {
    {Name = "Hive6", Position = Vector3.new(-186.31, 6.38, 330.88)},
    {Name = "Hive5", Position = Vector3.new(-149.32, 6.38, 331.58)},
    {Name = "Hive4", Position = Vector3.new(-113.12, 6.38, 330.47)},
    {Name = "Hive3", Position = Vector3.new(-76.40, 6.38, 331.25)},
    {Name = "Hive2", Position = Vector3.new(-39.46, 6.38, 330.91)},
    {Name = "Hive1", Position = Vector3.new(-3.01, 6.38, 329.70)},
}

local hiveStates = {
    Hive1 = false, Hive2 = false, Hive3 = false,
    Hive4 = false, Hive5 = false, Hive6 = false
}

local claimedHive = nil

task.wait(2)

local success, loadedConfig = pcall(function()
   return Library:LoadConfig("astra/config.json")
end)

if success and loadedConfig then
    Config = loadedConfig
else
    print("No Config Found.")
end

local function safeMove(character, targetPosition, isTeleport)
    if not character or not character:IsA("Model") then
        warn("Ungültiger Charakter!")
        return
    end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        warn("HumanoidRootPart wurde nicht gefunden!")
        return
    end

    if not targetPosition or typeof(targetPosition) ~= "Vector3" then
        warn("Ungültige Zielposition!")
        return
    end

    local speed = Config.defaultTweenSpeed 
    local duration = 10 / speed 

    if isTeleport then
        hrp.CFrame = CFrame.new(targetPosition)
        return
    end

    local startPosition = hrp.Position
    local startTime = tick()

    while tick() - startTime < duration do
        local elapsedTime = tick() - startTime
        local alpha = math.clamp(elapsedTime / duration, 0, 1)  

        local newPosition = startPosition:Lerp(targetPosition, alpha)
        hrp.CFrame = CFrame.new(newPosition)

        wait(0.03)
    end

    hrp.CFrame = CFrame.new(targetPosition)
end

local function findFreeHive()
    for i = #hives, 1, -1 do 
        local hive = hives[i]
        local hiveKey = hive.Name 
        
        if hiveStates[hiveKey] == false then
            return hive.Position, tonumber(hiveKey:match("%d+")) 
        end
    end
    return nil, nil
end


local function checkHivePlatforms()
    local hivePlatforms = game.Workspace:FindFirstChild("HivePlatforms")
    if hivePlatforms then
        for _, platform in pairs(hivePlatforms:GetChildren()) do
            local playerRef = platform:FindFirstChild("PlayerRef")
            local hiveValue = platform:FindFirstChild("Hive")

            if playerRef and hiveValue then
                local playerName = playerRef.Value
                local hiveName = tostring(hiveValue.Value)
                if playerName == nil or playerName == "" then
                    hiveStates[hiveName] = false
                else
                    hiveStates[hiveName] = true
                end
            else
                print("Error on Hives")
            end
        end
    else
        print("No Hives Found!")
    end
end


checkHivePlatforms()

task.wait(2)

local function moveToFreeHive()
    local player = game.Players.LocalPlayer
    local character = player and player.Character or player.CharacterAdded:Wait()
    
    local freeHivePosition, hiveNumber = findFreeHive() 
    
    if freeHivePosition and hiveNumber then
        safeMove(character, freeHivePosition, 2, false)
        task.wait(0.5) 
        local args = {hiveNumber}
        game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("ClaimHive"):FireServer(unpack(args))
        claimedHive = hiveNumber
    else
        print("Error!")
    end
end


moveToFreeHive()

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
    
    local http = request or syn.request

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

    if success and (response.StatusCode == 200 or response.StatusCode == 204) then
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

local function pressKey(key, duration)
    VirtualInputManager:SendKeyEvent(true, key, false, game) -- Taste drücken
    wait(duration) -- Halten
    VirtualInputManager:SendKeyEvent(false, key, false, game) -- Taste loslassen
end

local function autoFarm(fieldName)
    if not Config.autofarming then return end  

    local player = game.Players.LocalPlayer
    local character = player and player.Character or player.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local userInputService = game:GetService("UserInputService")
    
    if not fieldData[fieldName] then
        warn("Feld nicht gefunden!")
        return
    end

    local field = fieldData[fieldName]
    local fieldPosition = field.Position
    local fieldSize = field.Size

    -- Verwende safeMove, um ins Feld zu fliegen
    safeMove(character, fieldPosition, false)
    wait(1)

    local moveDirection = Vector3.new(0, 0, 0)

    local function isWithinBounds(position)
        local minX = fieldPosition.X - fieldSize.X / 2
        local maxX = fieldPosition.X + fieldSize.X / 2
        local minZ = fieldPosition.Z - fieldSize.X / 2
        local maxZ = fieldPosition.Z + fieldSize.Z / 2

        return position.X >= minX and position.X <= maxX and position.Z >= minZ and position.Z <= maxZ
    end

    local function onKeyPress(input, gameProcessedEvent)
        if gameProcessedEvent then
            return
        end

        if input.KeyCode == Enum.KeyCode.W then
            moveDirection = Vector3.new(0, 0, -1)
        elseif input.KeyCode == Enum.KeyCode.A then
            moveDirection = Vector3.new(-1, 0, 0)
        elseif input.KeyCode == Enum.KeyCode.S then
            moveDirection = Vector3.new(0, 0, 1)
        elseif input.KeyCode == Enum.KeyCode.D then
            moveDirection = Vector3.new(1, 0, 0)
        end
    end

    local function onKeyRelease(input, gameProcessedEvent)
        if gameProcessedEvent then
            return
        end

        if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D then
            moveDirection = Vector3.new(0, 0, 0)
        end
    end

    userInputService.InputBegan:Connect(onKeyPress)
    userInputService.InputEnded:Connect(onKeyRelease)

    local function onRenderStep()
        if moveDirection.Magnitude > 0 then
            local newPosition = character.PrimaryPart.Position + (moveDirection * 0.1 * game:GetService("RunService").RenderStepped:Wait())

            if isWithinBounds(newPosition) then
                humanoid:Move(newPosition - character.PrimaryPart.Position, true)
            end
        end
    end

    game:GetService("RunService").RenderStepped:Connect(onRenderStep)

    -- Starte den Auto-Farming-Prozess
    while Config.autofarming and not Config.stopAll do
        wait(0.1)
    end
end

-- Farming Tab
local FarmingTab = Init:NewTab("Farming")
local FarmingSection = FarmingTab:NewSection("Farming")

local FieldSelector = FarmingTab:NewSelector("Choose an Field", "Feld", {
    "SunflowerField", "DandelionField", "MushroomField", "BlueFlowerField", "CloverField",
    "StrawberryField", "SpiderField", "BambooField", "PineapplePatch", "StumpField",
    "CactusField", "PumpkinPatch", "PineTreeForest", "RoseField", "MountainTopField",
    "PepperPatch", "CoconutField"
}, function(selected)
    Config.selectedField = selected 
    print("Feld changed: " .. Config.selectedField)
end)

local ToggleAutoFarm = FarmingTab:NewToggle("Autofarm", Config.autofarming, function(value)
    Config.autofarming = value
    if value then
        autoFarm(Config.selectedField)
    end
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

local WebhookLink = WebhookTab:NewTextbox("Webhook URL", "", "URL", "all", "small", true, false, function(val)
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

local TweenSpeedSlide = ConfigTab:NewSlider("TweenSpeed", "", true, "/", 
    {min = 1, max = 10, default = Config.defaultTweenSpeed}, 
    function(value)
        Config.defaultTweenSpeed = value
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
