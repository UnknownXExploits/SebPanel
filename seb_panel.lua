-- Seb Panel Script

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SebPanelGUI"
screenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- Create draggable "Seb Panel" button
local openButton = Instance.new("TextButton")
openButton.Name = "OpenPanelButton"
openButton.Parent = screenGui
openButton.Size = UDim2.new(0, 150, 0, 50)
openButton.Position = UDim2.new(0.4, 0, 0.1, 0)
openButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- Orange color
openButton.Text = "Seb Panel"
openButton.Active = true
openButton.Draggable = true

-- Create loading screen
local loadingFrame = Instance.new("Frame")
loadingFrame.Name = "LoadingFrame"
loadingFrame.Parent = screenGui
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingFrame.Visible = true
loadingFrame.ZIndex = 2

local loadingText = Instance.new("TextLabel")
loadingText.Name = "LoadingText"
loadingText.Parent = loadingFrame
loadingText.Size = UDim2.new(1, 0, 1, 0)
loadingText.Text = "Loading Seb Panel..."
loadingText.TextScaled = true
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.BackgroundTransparency = 1
loadingText.ZIndex = 3

wait(5) -- Show loading screen for 5 seconds
loadingFrame.Visible = false

-- Create panel frame
local panel = Instance.new("Frame")
panel.Name = "SebPanel"
panel.Parent = screenGui
panel.Size = UDim2.new(0, 300, 0, 250)
panel.Position = UDim2.new(0.4, 0, 0.2, 0)
panel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
panel.Visible = false
panel.Active = true
panel.Draggable = true

-- Create "X" button to close panel
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = panel
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(0.85, 0, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Text = "X"

-- Create "Fly" button
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Parent = panel
flyButton.Size = UDim2.new(0, 140, 0, 40)
flyButton.Position = UDim2.new(0.05, 0, 0.2, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
flyButton.Text = "Fly"

-- Create "Unfly" button
local unflyButton = Instance.new("TextButton")
unflyButton.Name = "UnflyButton"
unflyButton.Parent = panel
unflyButton.Size = UDim2.new(0, 140, 0, 40)
unflyButton.Position = UDim2.new(0.55, 0, 0.2, 0)
unflyButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
unflyButton.Text = "Unfly"

-- Flight system
local flying = false
local flightSpeed = 75
local flightConn = nil
local lastChar = nil

flyButton.MouseButton1Click:Connect(function()
    local character = game.Players.LocalPlayer.Character
    if character then
        local humanoidRoot = character:FindFirstChild("HumanoidRootPart")
        if humanoidRoot then
            flying = true
            -- Remove existing BodyMovers if any
            for _, obj in pairs(humanoidRoot:GetChildren()) do
                if obj:IsA("BodyGyro") or obj:IsA("BodyVelocity") then
                    obj:Destroy()
                end
            end
            local bodyGyro = Instance.new("BodyGyro", humanoidRoot)
            local bodyVelocity = Instance.new("BodyVelocity", humanoidRoot)
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            lastChar = character
            if flightConn then flightConn:Disconnect() end
            flightConn = game:GetService("RunService").Heartbeat:Connect(function()
                if flying and humanoidRoot then
                    local mouse = game.Players.LocalPlayer:GetMouse()
                    if mouse and mouse.Hit then
                        local moveDirection = mouse.Hit.p - humanoidRoot.Position
                        if moveDirection.Magnitude > 1 then
                            bodyVelocity.Velocity = moveDirection.Unit * flightSpeed
                        else
                            bodyVelocity.Velocity = Vector3.new()
                        end
                        bodyGyro.CFrame = CFrame.lookAt(humanoidRoot.Position, mouse.Hit.p)
                    end
                end
            end)
        end
    end
end)

unflyButton.MouseButton1Click:Connect(function()
    flying = false
    if flightConn then
        flightConn:Disconnect()
        flightConn = nil
    end
    local character = game.Players.LocalPlayer.Character
    if character then
        local humanoidRoot = character:FindFirstChild("HumanoidRootPart")
        if humanoidRoot then
            for _, obj in pairs(humanoidRoot:GetChildren()) do
                if obj:IsA("BodyGyro") or obj:IsA("BodyVelocity") then
                    obj:Destroy()
                end
            end
        end
    end
end)

-- Create teleport & kick system
local teleportInput = Instance.new("TextBox")
teleportInput.Name = "TeleportInput"
teleportInput.Parent = panel
teleportInput.Size = UDim2.new(0, 140, 0, 30)
teleportInput.Position = UDim2.new(0.05, 0, 0.4, 0)
teleportInput.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
teleportInput.Text = "Enter Player Name"
teleportInput.ClearTextOnFocus = true

local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Parent = panel
teleportButton.Size = UDim2.new(0, 140, 0, 40)
teleportButton.Position = UDim2.new(0.55, 0, 0.4, 0)
teleportButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
teleportButton.Text = "Teleport"

teleportButton.MouseButton1Click:Connect(function()
    local targetPlayer = game.Players:FindFirstChild(teleportInput.Text)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character.PrimaryPart then
        local char = game.Players.LocalPlayer.Character
        if char and char.PrimaryPart then
            char:SetPrimaryPartCFrame(targetPlayer.Character.PrimaryPart.CFrame)
        end
    end
end)

-- Fling Player feature
local flingButton = Instance.new("TextButton")
flingButton.Name = "FlingButton"
flingButton.Parent = panel
flingButton.Size = UDim2.new(0, 140, 0, 40)
flingButton.Position = UDim2.new(0.3, 0, 0.6, 0)
flingButton.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
flingButton.Text = "Fling Player"

flingButton.MouseButton1Click:Connect(function()
    local targetPlayer = game.Players:FindFirstChild(teleportInput.Text)
    if targetPlayer and targetPlayer.Character then
        local humanoidRoot = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRoot then
            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Velocity = Vector3.new(math.random(-150, 150), 300, math.random(-150, 150))
            bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bodyVelocity.Parent = humanoidRoot

            wait(0.5)
            bodyVelocity:Destroy()
        end
    end
end)

-- Wear Dominus feature (example asset, will error if not allowed!)
local dominusButton = Instance.new("TextButton")
dominusButton.Name = "DominusButton"
dominusButton.Parent = panel
dominusButton.Size = UDim2.new(0, 140, 0, 40)
dominusButton.Position = UDim2.new(0.3, 0, 0.8, 0)
dominusButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
dominusButton.Text = "Wear Dominus"

dominusButton.MouseButton1Click:Connect(function()
    local character = game.Players.LocalPlayer.Character
    if character then
        local hatId = 48474294 -- Example Dominus Asset ID
        local success, hat = pcall(function()
            return game:GetService("InsertService"):LoadAsset(hatId)
        end)
        if success and hat and hat:IsA("Model") then
            for _, child in ipairs(hat:GetChildren()) do
                if child:IsA("Accessory") or child:IsA("Hat") then
                    child.Parent = character
                end
            end
            hat:Destroy()
        end
    end
end)

openButton.MouseButton1Click:Connect(function()
    panel.Visible = not panel.Visible
end)

closeButton.MouseButton1Click:Connect(function()
    panel.Visible = false
end)
