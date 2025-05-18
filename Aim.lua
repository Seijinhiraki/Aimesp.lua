-- [!] Execute no Delta Executor

local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

-- Variáveis
local aimbotEnabled = false
local espEnabled = false
local lockFOV = false
local fovSize = 100
local targetColor = Color3.fromRGB(255, 0, 0)
local closestPlayer = nil

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AimHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = plr.PlayerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🎯 AimHub"
title.TextColor3 = Color3.fromRGB(255, 87, 34)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Parent = mainFrame

-- Botões
local aimbotButton = Instance.new("TextButton")
aimbotButton.Position = UDim2.new(0.1, 0, 0.2, 0)
aimbotButton.Size = UDim2.new(0.8, 0, 0, 30)
aimbotButton.Text = "Aimbot: OFF"
aimbotButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
aimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotButton.Font = Enum.Font.Gotham
aimbotButton.Parent = mainFrame

local espButton = Instance.new("TextButton")
espButton.Position = UDim2.new(0.1, 0, 0.4, 0)
espButton.Size = UDim2.new(0.8, 0, 0, 30)
espButton.Text = "ESP: OFF"
espButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Font = Enum.Font.Gotham
espButton.Parent = mainFrame

local lockFOVButton = Instance.new("TextButton")
lockFOVButton.Position = UDim2.new(0.1, 0, 0.6, 0)
lockFOVButton.Size = UDim2.new(0.8, 0, 0, 30)
lockFOVButton.Text = "FOV Fixo: OFF"
lockFOVButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
lockFOVButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lockFOVButton.Font = Enum.Font.Gotham
lockFOVButton.Parent = mainFrame

-- Funções dos botões
aimbotButton.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimbotButton.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF")
    aimbotButton.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
end)

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    espButton.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
end)

lockFOVButton.MouseButton1Click:Connect(function()
    lockFOV = not lockFOV
    lockFOVButton.Text = "FOV Fixo: " .. (lockFOV and "ON" or "OFF")
    lockFOVButton.BackgroundColor3 = lockFOV and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
end)

-- Desenho do FOV
local fovCircle = Drawing.new("Circle")
fovCircle.Radius = fovSize
fovCircle.Thickness = 1
fovCircle.Color = targetColor
fovCircle.Filled = false
fovCircle.Visible = true

-- Aimbot
function getClosestPlayer()
    local closestDistance = math.huge
    local target = nil
    local localPos = camera.CFrame.Position

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local screenPos, onScreen = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local mousePos = userInputService:GetMouseLocation()
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                if distance < closestDistance and distance <= fovSize then
                    closestDistance = distance
                    target = v
                end
            end
        end
    end
    return target
end

-- Loop principal
runService.RenderStepped:Connect(function()
    -- Atualiza posição do FOV
    if not lockFOV then
        fovCircle.Position = userInputService:GetMouseLocation()
    else
        fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    end
    fovCircle.Radius = fovSize

    -- Aimbot
    if aimbotEnabled then
        closestPlayer = getClosestPlayer()
        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local root = closestPlayer.Character.HumanoidRootPart
            local lookAt = root.Position + root.Velocity * 0.05
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, lookAt)
        end
    end
end)

-- ESP
local espBoxes = {}

spawn(function()
    while true do
        wait(0.1)
        if espEnabled then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= plr and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                    local part = v.Character.HumanoidRootPart
                    local pos, onScreen = camera:WorldToViewportPoint(part.Position)

                    if not espBoxes[v] then
                        espBoxes[v] = {
                            box = Drawing.new("Square"),
                            text = Drawing.new("Text")
                        }
                    end

                    local size = 5
                    espBoxes[v].box.Size = Vector2.new(10 * size, 10 * size)
                    espBoxes[v].box.Position = Vector2.new(pos.X - 5 * size, pos.Y - 5 * size)
                    espBoxes[v].box.Color = targetColor
                    espBoxes[v].box.Filled = false
                    espBoxes[v].box.Thickness = 2
                    espBoxes[v].box.Visible = true

                    espBoxes[v].text.Text = v.Name
                    espBoxes[v].text.Size = 16
                    espBoxes[v].text.Position = Vector2.new(pos.X, pos.Y - 20)
                    espBoxes[v].text.Color = targetColor
                    espBoxes[v].text.Center = true
                    espBoxes[v].text.Visible = true
                else
                    if espBoxes[v] then
                        espBoxes[v].box.Visible = false
                        espBoxes[v].text.Visible = false
                    end
                end
            end
        else
            for _, data in pairs(espBoxes) do
                data.box.Visible = false
                data.text.Visible = false
            end
        end
    end
end)
