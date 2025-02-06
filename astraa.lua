-- Fusion Setup
local Fusion = require(game.ReplicatedStorage:WaitForChild("Fusion"))

-- UI Variablen
local New = Fusion.New
local State = Fusion.State
local Children = Fusion.Children

-- Reaktive Zustände
local noclip = State(false)
local uiVisible = State(true)

-- UI erstellen
local ScreenGui = New("ScreenGui")({
    Parent = game.Players.LocalPlayer.PlayerGui,
    Name = "FusionUI"
})

-- Haupt-Frame
local mainFrame = New("Frame")({
    Parent = ScreenGui,
    Size = UDim2.new(0, 400, 0, 300),
    Position = UDim2.new(0.5, -200, 0.5, -150),
    BackgroundColor3 = Color3.fromRGB(40, 0, 80),
    BorderSizePixel = 2,
    BorderColor3 = Color3.fromRGB(200, 100, 255),
    [Children] = {
        -- TopBar mit Titel und Close Button
        New("Frame")({
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = Color3.fromRGB(100, 0, 200),
            [Children] = {
                New("TextLabel")({
                    Text = "Bee Swarm Hub",
                    Size = UDim2.new(1, -40, 1, 0),
                    Position = UDim2.new(0, 10, 0, 0),
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 20,
                    Font = Enum.Font.SourceSansBold
                }),
                New("TextButton")({
                    Text = "X",
                    Size = UDim2.new(0, 30, 0, 30),
                    Position = UDim2.new(1, -35, 0, 5),
                    BackgroundColor3 = Color3.fromRGB(150, 0, 220),
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.SourceSansBold,
                    TextSize = 18,
                    [Children] = {
                        New("UIAspectRatioConstraint")({
                            AspectRatio = 1
                        })
                    },
                    [Fusion.OnClick] = function()
                        uiVisible:set(false)
                    end
                })
            }
        }),

        -- Tabs Container
        New("Frame")({
            Size = UDim2.new(0, 120, 1, -40),
            Position = UDim2.new(0, 0, 0, 40),
            BackgroundColor3 = Color3.fromRGB(60, 0, 120),
            [Children] = {
                -- AutoFarm Tab
                New("TextButton")({
                    Text = "AutoFarm",
                    Size = UDim2.new(1, -10, 0, 35),
                    Position = UDim2.new(0, 5, 0, 5),
                    BackgroundColor3 = Color3.fromRGB(90, 0, 160),
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.SourceSansBold,
                    TextSize = 16,
                    [Fusion.OnClick] = function()
                        print("AutoFarm gestartet!")
                    end
                }),
                -- Misc Tab (mit Noclip)
                New("TextButton")({
                    Text = "Misc",
                    Size = UDim2.new(1, -10, 0, 35),
                    Position = UDim2.new(0, 5, 0, 45),
                    BackgroundColor3 = Color3.fromRGB(90, 0, 160),
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.SourceSansBold,
                    TextSize = 16,
                    [Fusion.OnClick] = function()
                        print("Misc Tab aktiv")
                    end
                }),
            }
        }),

        -- Content Area (zeigt den Inhalt von Tabs)
        New("Frame")({
            Size = UDim2.new(1, -120, 1, -40),
            Position = UDim2.new(0, 120, 0, 40),
            BackgroundColor3 = Color3.fromRGB(80, 0, 160),
            [Children] = {
                -- Noclip Toggle im Misc Tab
                New("TextButton")({
                    Text = "Noclip",
                    Size = UDim2.new(0, 180, 0, 40),
                    Position = UDim2.new(0.5, -90, 0.2, 0),
                    BackgroundColor3 = Color3.fromRGB(120, 0, 220),
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.SourceSansBold,
                    TextSize = 16,
                    [Fusion.OnClick] = function()
                        noclip:set(not noclip:get()) -- Noclip Toggle
                        print("Noclip Status:", noclip:get())
                        -- Noclip Funktion
                        if noclip:get() then
                            print("Noclip aktiviert")
                            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                        else
                            print("Noclip deaktiviert")
                            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = true
                                end
                            end
                        end
                    end
                })
            }
        })
    }
})

