local player = game.Players.LocalPlayer
local runservice = game:GetService("RunService")
local noclip = false
local uiVisible = true

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local TabsFrame = Instance.new("Frame")
local ContentFrame = Instance.new("Frame")

local Tabs = {
    "AutoFarm", "Toys", "Misc", "Webhook", "Combat", "Quests", "Planters", "Config"
}

ScreenGui.Parent = player:WaitForChild("PlayerGui")

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 80) -- Dunkles Lila
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(200, 100, 255) -- Lila Rand
MainFrame.Active = true
MainFrame.Draggable = true -- Bewegbare UI

TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(100, 0, 200)
TopBar.Size = UDim2.new(1, 0, 0, 40)

Title.Parent = TopBar
Title.Text = "Bee Swarm Hub"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left

CloseButton.Parent = TopBar
CloseButton.Text = "X"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(150, 0, 220)
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18

TabsFrame.Parent = MainFrame
TabsFrame.BackgroundColor3 = Color3.fromRGB(60, 0, 120)
TabsFrame.Size = UDim2.new(0, 120, 1, -40)
TabsFrame.Position = UDim2.new(0, 0, 0, 40)

ContentFrame.Parent = MainFrame
ContentFrame.BackgroundColor3 = Color3.fromRGB(80, 0, 160)
ContentFrame.Size = UDim2.new(1, -120, 1, -40)
ContentFrame.Position = UDim2.new(0, 120, 0, 40)

local function createTab(name)
    local TabButton = Instance.new("TextButton")
    TabButton.Parent = TabsFrame
    TabButton.Text = name
    TabButton.Size = UDim2.new(1, -10, 0, 35)
    TabButton.Position = UDim2.new(0, 5, 0, (#TabsFrame:GetChildren() - 1) * 40 + 5)
    TabButton.BackgroundColor3 = Color3.fromRGB(90, 0, 160)
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.TextSize = 16

    TabButton.MouseButton1Click:Connect(function()
        for _, v in pairs(ContentFrame:GetChildren()) do
            if v:IsA("Frame") then
                v.Visible = false
            end
        end
        ContentFrame:FindFirstChild(name).Visible = true
    end)

    return TabButton
end

for _, tabName in ipairs(Tabs) do
    local TabContent = Instance.new("Frame")
    TabContent.Parent = ContentFrame
    TabContent.Name = tabName
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.Visible = false

    createTab(tabName)
end

ContentFrame:FindFirstChild("AutoFarm").Visible = true

local MiscTab = ContentFrame:FindFirstChild("Misc")
local NoclipButton = Instance.new("TextButton")

NoclipButton.Parent = MiscTab
NoclipButton.Text = "Toggle Noclip: OFF"
NoclipButton.Size = UDim2.new(0, 180, 0, 40)
NoclipButton.Position = UDim2.new(0.5, -90, 0.2, 0)
NoclipButton.BackgroundColor3 = Color3.fromRGB(120, 0, 220)
NoclipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipButton.Font = Enum.Font.SourceSansBold
NoclipButton.TextSize = 16

local function toggleNoclip()
    noclip = not noclip
    NoclipButton.Text = noclip and "Toggle Noclip: ON" or "Toggle Noclip: OFF"

    runservice.Stepped:Connect(function()
        if noclip then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

NoclipButton.MouseButton1Click:Connect(toggleNoclip)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false
end)
