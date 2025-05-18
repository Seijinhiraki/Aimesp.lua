-- == UNIVERSAL AIMBOT + ESP v2.0 ==
-- Script atualizado com todas as melhorias solicitadas!

local scriptContent = [[
-- == SERVICES ==
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

if not LocalPlayer then repeat wait() until Players.LocalPlayer; LocalPlayer = Players.LocalPlayer end

-- == CONFIGURAÇÕES ==
local Settings = {
    AimbotEnabled = false,
    EspEnabled = false,
    WallCheck = true,
    FovSize = 100,
    AimSpeed = 1,
}

-- == GUI SETUP ==
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "AimHub"
MainGui.ResetOnSpawn = false
MainGui.Parent = CoreGui

local Window = Instance.new("Frame")
Window.Size = UDim2.new(0, 300, 0, 400)
Window.Position = UDim2.new(0.5, -150, 0.5, -200)
Window.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Window.BorderSizePixel = 0
Window.Visible = false
Window.Parent = MainGui

-- == DRAGGABLE ==
local dragging = false
local dragStart, startPos

Window.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Window.Position
    end
end)

Window.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local delta = UserInputService:GetMouseLocation() - dragStart
        Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- == TOGGLE BUTTON ==
local ToggleButton = Instance.new("TextButton")
ToggleButton.Text = "🎯 Abrir Menu"
ToggleButton.Size = UDim2.new(0, 120, 0, 30)
ToggleButton.Position = UDim2.new(0.8, 0, 0.02, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BorderSizePixel = 0
ToggleButton.Parent = MainGui

ToggleButton.MouseButton1Click:Connect(function()
    Window.Visible = not Window.Visible
    ToggleButton.Text = Window.Visible and "❌ Fechar Menu" or "🎯 Abrir Menu"
end)

-- == TITLE ==
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Universal AimBot + ESP"
Title.TextColor3 = Color3.fromRGB(255, 87, 34)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Window

-- == AIMBOT TOGGLE ==
local AimbotToggle = Instance.new("TextButton")
AimbotToggle.Text = "Aimbot: OFF"
AimbotToggle.Size = UDim2.new(0, 280, 0, 30)
AimbotToggle.Position = UDim2.new(0, 10, 0, 40)
AimbotToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
AimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotToggle.BorderSizePixel = 0
AimbotToggle.Parent = Window

AimbotToggle.MouseButton1Click:Connect(function()
    Settings.AimbotEnabled = not Settings.AimbotEnabled
    AimbotToggle.Text = "Aimbot: " .. (Settings.AimbotEnabled and "ON" or "OFF")
    AimbotToggle.BackgroundColor3 = Settings.AimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(45, 45, 45)
end)

-- == WALL CHECK ==
local WallCheckToggle = Instance.new("TextButton")
WallCheckToggle.Text = "Wall Detect: ON"
WallCheckToggle.Size = UDim2.new(0, 280, 0, 30)
WallCheckToggle.Position = UDim2.new(0, 10, 0, 80)
WallCheckToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
WallCheckToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
WallCheckToggle.BorderSizePixel = 0
WallCheckToggle.Parent = Window

WallCheckToggle.MouseButton1Click:Connect(function()
    Settings.WallCheck = not Settings.WallCheck
    WallCheckToggle.Text = "Wall Detect: " .. (Settings.WallCheck and "ON" or "OFF")
    WallCheckToggle.BackgroundColor3 = Settings.WallCheck and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(45, 45, 45)
end)

-- == FOV SLIDER ==
local FovSlider = Instance.new("TextBox")
FovSlider.PlaceholderText = "FOV Size ("..Settings.FovSize..")"
FovSlider.Size = UDim2.new(0, 280, 0, 30)
FovSlider.Position = UDim2.new(0, 10, 0, 120)
FovSlider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
FovSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
FovSlider.BorderSizePixel = 0
FovSlider.ClearTextOnFocus = true
FovSlider.Text = tostring(Settings.FovSize)
FovSlider.Parent = Window

FovSlider.FocusLost:Connect(function()
    local value = tonumber(FovSlider.Text)
    if value and value > 0 then
        Settings.FovSize = value
        FovSlider.PlaceholderText = "FOV Size ("..value..")"
    else
        FovSlider.Text = Settings.FovSize
    end
end)

-- == AIMBOT SPEED SLIDER ==
local SpeedSlider = Instance.new("TextBox")
SpeedSlider.PlaceholderText = "Aim Speed ("..Settings.AimSpeed..")"
SpeedSlider.Size = UDim2.new(0, 280, 0, 30)
SpeedSlider.Position = UDim2.new(0, 10, 0, 160)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedSlider.BorderSizePixel = 0
SpeedSlider.ClearTextOnFocus = true
SpeedSlider.Text = tostring(Settings.AimSpeed)
SpeedSlider.Parent = Window

SpeedSlider.FocusLost:Connect(function()
    local value = tonumber(SpeedSlider.Text)
    if value and value >= 0.1 then
        Settings.AimSpeed = value
        SpeedSlider.PlaceholderText = "Aim Speed ("..value..")"
    else
        SpeedSlider.Text = Settings.AimSpeed
    end
end)

-- == ESP TOGGLE ==
local EspToggle = Instance.new("TextButton")
EspToggle.Text = "ESP: OFF"
EspToggle.Size = UDim2.new(0, 280, 0, 30)
EspToggle.Position = UDim2.new(0, 10, 0, 200)
EspToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
EspToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
EspToggle.BorderSizePixel = 0
EspToggle.Parent = Window

EspToggle.MouseButton1Click:Connect(function()
    Settings.EspEnabled = not Settings.EspEnabled
    EspToggle.Text = "ESP: " .. (Settings.EspEnabled and "ON" or "OFF")
    EspToggle.BackgroundColor3 = Settings.EspEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(45, 45, 45)
end)

-- == FOV CIRCLE ==
local FovCircle = Drawing.new("Circle")
FovCircle.Radius = Settings.FovSize
FovCircle.Thickness = 1.5
FovCircle.Color = Color3.fromRGB(255, 0, 0)
FovCircle.NumSides = 64
FovCircle.Filled = false
FovCircle.Visible = true

-- == MAIN LOOP ==
RunService.RenderStepped:Connect(function()
    -- Update FOV
    FovCircle.Radius = Settings.FovSize
    FovCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    FovCircle.Color = Settings.AimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)

    -- Aimbot
    if Settings.AimbotEnabled then
        local Closest, Distance = nil, math.huge
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local Pos, OnScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if OnScreen then
                    local MousePos = UserInputService:GetMouseLocation()
                    local ToMouse = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(MousePos.X, MousePos.Y)).Magnitude
                    if ToMouse < Distance and ToMouse <= Settings.FovSize then
                        if Settings.WallCheck then
                            local RaycastParams = RaycastParams.new()
                            RaycastParams.FilterDescendantsInstances = {LocalPlayer.Character, v.Character}
                            RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
                            local Result = workspace:Raycast(Camera.CFrame.Position, v.Character.Head.Position - Camera.CFrame.Position, RaycastParams)
                            if Result and Result.Instance:IsDescendantOf(v.Character) then
                                Closest = v
                                Distance = ToMouse
                            end
                        else
                            Closest = v
                            Distance = ToMouse
                        end
                    end
                end
            end
        end

        if Closest and Closest.Character and Closest.Character:FindFirstChild("Head") then
            local TargetCFrame = CFrame.lookAt(Camera.CFrame.Position, Closest.Character.Head.Position)
            Camera.CFrame = Camera.CFrame:Lerp(TargetCFrame, Settings.AimSpeed, true)
        end
    end
end)

-- == ESP ==
local EspBoxes = {}

spawn(function()
    while true do
        wait(0.1)
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character.Humanoid.Health > 0 then
                if not EspBoxes[Player] then
                    EspBoxes[Player] = {
                        Box = Drawing.new("Square"),
                        NameTag = Drawing.new("Text")
                    }
                end

                local HRP = Player.Character:FindFirstChild("HumanoidRootPart")
                if HRP then
                    local Pos, OnScreen = Camera:WorldToViewportPoint(HRP.Position)
                    local BoxSize = 20

                    EspBoxes[Player].Box.Visible = Settings.EspEnabled and OnScreen
                    EspBoxes[Player].NameTag.Visible = Settings.EspEnabled and OnScreen

                    EspBoxes[Player].Box.Position = Vector2.new(Pos.X - BoxSize, Pos.Y - BoxSize)
                    EspBoxes[Player].Box.Size = Vector2.new(BoxSize * 2, BoxSize * 2)
                    EspBoxes[Player].Box.Color = Color3.fromRGB(255, 0, 0)
                    EspBoxes[Player].Box.Thickness = 1.5
                    EspBoxes[Player].Box.Filled = false

                    EspBoxes[Player].NameTag.Position = Vector2.new(Pos.X, Pos.Y - 30)
                    EspBoxes[Player].NameTag.Text = Player.Name
                    EspBoxes[Player].NameTag.Size = 16
                    EspBoxes[Player].NameTag.Color = Color3.fromRGB(255, 255, 255)
                    EspBoxes[Player].NameTag.Center = true
                end
            else
                if EspBoxes[Player] then
                    EspBoxes[Player].Box.Visible = false
                    EspBoxes[Player].NameTag.Visible = false
                end
            end
        end
    end
end)
]]

-- Executa o script embutido
loadstring(scriptContent)()
