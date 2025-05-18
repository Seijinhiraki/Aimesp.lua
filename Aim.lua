-- == CONFIGURAÇÕES ==
local Enabled = false
local AimbotEnabled = false
local WallCheck = true
local FovSize = 100
local AimSpeed = 1
local EspEnabled = false

-- == SERVICES ==
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- == MAIN GUI ==
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "UniversalAimbotESP"
MainGui.ResetOnSpawn = false
MainGui.Parent = CoreGui

-- == WINDOW ==
local Window = Instance.new("Frame")
Window.Size = UDim2.new(0, 300, 0, 400)
Window.Position = UDim2.new(0.7, 0, 0.2, 0)
Window.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Window.BorderSizePixel = 0
Window.Visible = false
Window.Parent = MainGui

-- == DRAGGABLE ==
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    Window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Window.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Window.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Window.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        updateInput(dragInput)
    end
end)

-- == TOGGLE BUTTON ==
local ToggleButton = Instance.new("TextButton")
ToggleButton.Text = "Abrir Menu"
ToggleButton.Size = UDim2.new(0, 100, 0, 30)
ToggleButton.Position = UDim2.new(0.85, 0, 0.02, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BorderSizePixel = 0
ToggleButton.Parent = MainGui

ToggleButton.MouseButton1Click:Connect(function()
    Window.Visible = not Window.Visible
    ToggleButton.Text = Window.Visible and "Fechar Menu" or "Abrir Menu"
end)

-- == AIMBOT SECTION ==
local AimbotToggle = Instance.new("TextButton")
AimbotToggle.Text = "Aimbot: OFF"
AimbotToggle.Size = UDim2.new(0, 280, 0, 30)
AimbotToggle.Position = UDim2.new(0, 10, 0, 10)
AimbotToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AimbotToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AimbotToggle.BorderSizePixel = 0
AimbotToggle.Parent = Window

AimbotToggle.MouseButton1Click:Connect(function()
    AimbotEnabled = not AimbotEnabled
    AimbotToggle.Text = "Aimbot: " .. (AimbotEnabled and "ON" or "OFF")
end)

-- == WALL CHECK ==
local WallCheckToggle = Instance.new("TextButton")
WallCheckToggle.Text = "Wall Detect: ON"
WallCheckToggle.Size = UDim2.new(0, 280, 0, 30)
WallCheckToggle.Position = UDim2.new(0, 10, 0, 50)
WallCheckToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
WallCheckToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
WallCheckToggle.BorderSizePixel = 0
WallCheckToggle.Parent = Window

WallCheckToggle.MouseButton1Click:Connect(function()
    WallCheck = not WallCheck
    WallCheckToggle.Text = "Wall Detect: " .. (WallCheck and "ON" or "OFF")
end)

-- == FOV SLIDER ==
local FovSlider = Instance.new("TextBox")
FovSlider.PlaceholderText = "Tamanho do FOV (ex: 100)"
FovSlider.Size = UDim2.new(0, 280, 0, 30)
FovSlider.Position = UDim2.new(0, 10, 0, 90)
FovSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
FovSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
FovSlider.BorderSizePixel = 0
FovSlider.ClearTextOnFocus = false
FovSlider.Text = tostring(FovSize)
FovSlider.Parent = Window

FovSlider.FocusLost:Connect(function()
    FovSize = tonumber(FovSlider.Text) or FovSize
end)

-- == SPEED SLIDER ==
local SpeedSlider = Instance.new("TextBox")
SpeedSlider.PlaceholderText = "Velocidade do Aimbot (ex: 1)"
SpeedSlider.Size = UDim2.new(0, 280, 0, 30)
SpeedSlider.Position = UDim2.new(0, 10, 0, 130)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedSlider.BorderSizePixel = 0
SpeedSlider.ClearTextOnFocus = false
SpeedSlider.Text = tostring(AimSpeed)
SpeedSlider.Parent = Window

SpeedSlider.FocusLost:Connect(function()
    AimSpeed = tonumber(SpeedSlider.Text) or AimSpeed
end)

-- == RESET SPEED ==
local ResetSpeedBtn = Instance.new("TextButton")
ResetSpeedBtn.Text = "Redefinir Velocidade"
ResetSpeedBtn.Size = UDim2.new(0, 280, 0, 30)
ResetSpeedBtn.Position = UDim2.new(0, 10, 0, 170)
ResetSpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ResetSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ResetSpeedBtn.BorderSizePixel = 0
ResetSpeedBtn.Parent = Window

ResetSpeedBtn.MouseButton1Click:Connect(function()
    AimSpeed = 1
    SpeedSlider.Text = "1"
end)

-- == ESP TOGGLE ==
local EspToggle = Instance.new("TextButton")
EspToggle.Text = "ESP: OFF"
EspToggle.Size = UDim2.new(0, 280, 0, 30)
EspToggle.Position = UDim2.new(0, 10, 0, 210)
EspToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
EspToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
EspToggle.BorderSizePixel = 0
EspToggle.Parent = Window

EspToggle.MouseButton1Click:Connect(function()
    EspEnabled = not EspEnabled
    EspToggle.Text = "ESP: " .. (EspEnabled and "ON" or "OFF")
end)

-- == DRAWING FUNCTIONS ==
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.NumSides = 64
fovCircle.Radius = FovSize
fovCircle.Color = Color3.fromRGB(255, 0, 0)
fovCircle.Filled = false
fovCircle.Visible = true

RunService.RenderStepped:Connect(function()
    fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y)
    fovCircle.Radius = FovSize
    fovCircle.Color = AimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)

-- == GET NEAREST PLAYER DENTRO DO FOV E COM WALLCHECK ==
function GetNearestPlayer()
    local closest, minDist = nil, FovSize
    local camera = workspace.CurrentCamera

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            local hrp = v.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pos, onScreen = camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local distance = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).magnitude
                    if distance < minDist then
                        if WallCheck then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {LocalPlayer.Character, v.Character}
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude

                            local rayResult = workspace:Raycast(camera.CFrame.Position, hrp.Position - camera.CFrame.Position, rayParams)
                            if rayResult and rayResult.Instance:IsDescendantOf(v.Character) then
                                closest = v
                                minDist = distance
                            end
                        else
                            closest = v
                            minDist = distance
                        end
                    end
                end
            end
        end
    end
    return closest
end

-- == AIMBOT LOOP SUAVE (LERP) ==
RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = GetNearestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local headPos = target.Character.HumanoidRootPart.Position
            local currentCFrame = workspace.CurrentCamera.CFrame
            local direction = (headPos - currentCFrame.Position).unit

            -- Suavização da mira (lerp)
            local smoothness = AimSpeed * 0.1
            local newLookVector = currentCFrame.LookVector:lerp(direction, smoothness)
            local newCFrame = CFrame.fromMatrix(currentCFrame.Position, newLookVector, currentCFrame.UpVector)
            Mouse.Hit = newCFrame
        end
    end
end)

-- == ESP FUNCTION ==
spawn(function()
    while true do
        if EspEnabled then
            for _, v in pairs(Players:GetPlayers()) do
                if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") then
                    local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                        if onScreen then
                            local health = v.Character.Humanoid.Health
                            local maxHealth = v.Character.Humanoid.MaxHealth
                            local hpPercent = health / maxHealth

                            local espBox = Drawing.new("Square")
                            espBox.Size = Vector2.new(100, 100)
                            espBox.Position = Vector2.new(pos.X - 50, pos.Y - 50)
                            espBox.Color = Color3.fromRGB(255, 0, 0)
                            espBox.Thickness = 1
                            espBox.Filled = false

                            local nameTag = Drawing.new("Text")
                            nameTag.Text = v.Name
                            nameTag.Position = Vector2.new(pos.X, pos.Y - 70)
                            nameTag.Size = 16
                            nameTag.Color = Color3.fromRGB(255, 255, 255)
                            nameTag.Center = true

                            local healthBar = Drawing.new("Square")
                            healthBar.Size = Vector2.new(100 * hpPercent, 5)
                            healthBar.Position = Vector2.new(pos.X - 50, pos.Y - 60)
                            healthBar.Color = Color3.fromRGB(0, 255, 0)
                            healthBar.Filled = true

                            wait()

                            espBox.Visible = false
                            nameTag.Visible = false
                            healthBar.Visible = false
                        end
                    end
                end
            end
        end
        wait()
    end
end)
