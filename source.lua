local Hushed = {
    Theme = {
        Main = Color3.fromRGB(20, 20, 25),
        Secondary = Color3.fromRGB(25, 25, 30),
        Accent = Color3.fromRGB(130, 130, 160),
        Text = Color3.fromRGB(240, 240, 240),
        Placeholder = Color3.fromRGB(100, 100, 110),
        Stroke = Color3.fromRGB(45, 45, 55)
    }
}

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = game.Players.LocalPlayer

-- [[ FLY ENGINE ]]
local FlyEnabled = false
local FlySpeed = 60
local flyBV, flyBG, flyConn
local flyKeys = {W = false, A = false, S = false, D = false, Space = false, LShift = false}

local function StopFly()
    FlyEnabled = false
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
    pcall(function()
        local hum = Player.Character:FindFirstChildOfClass("Humanoid")
        if hum then 
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

local function StartFly()
    StopFly()
    FlyEnabled = true
    local char = Player.Character
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")
    hum.PlatformStand = true

    flyBV = Instance.new("BodyVelocity", hrp)
    flyBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    flyBV.Velocity = Vector3.new(0,0,0)

    flyBG = Instance.new("BodyGyro", hrp)
    flyBG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    flyBG.P = 9000
    flyBG.CFrame = hrp.CFrame

    flyConn = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.new(0,0,0)
        if flyKeys.W then moveDir = moveDir + cam.CFrame.LookVector end
        if flyKeys.S then moveDir = moveDir - cam.CFrame.LookVector end
        if flyKeys.D then moveDir = moveDir + cam.CFrame.RightVector end
        if flyKeys.A then moveDir = moveDir - cam.CFrame.RightVector end
        if flyKeys.Space then moveDir = moveDir + Vector3.new(0,1,0) end
        if flyKeys.LShift then moveDir = moveDir - Vector3.new(0,1,0) end
        flyBV.Velocity = moveDir.Magnitude > 0 and moveDir.Unit * FlySpeed or Vector3.new(0,0,0)
        flyBG.CFrame = cam.CFrame
    end)
end

UserInputService.InputBegan:Connect(function(i, g)
    if not g and flyKeys[i.KeyCode.Name] ~= nil then flyKeys[i.KeyCode.Name] = true end
end)
UserInputService.InputEnded:Connect(function(i)
    if flyKeys[i.KeyCode.Name] ~= nil then flyKeys[i.KeyCode.Name] = false end
end)

-- [[ UI CONSTRUCTOR ]]
function Hushed:CreateWindow(Config)
    local Name = Config.Name or "Hushed V1"
    
    local HushedGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
    HushedGui.Name = "HushedUI"

    local Main = Instance.new("Frame", HushedGui)
    Main.Size = UDim2.new(0, 560, 0, 380)
    Main.Position = UDim2.new(0.5, -280, 0.5, -190)
    Main.BackgroundColor3 = Hushed.Theme.Main
    Main.BorderSizePixel = 1
    Main.BorderColor3 = Hushed.Theme.Stroke

    local Topbar = Instance.new("Frame", Main)
    Topbar.Size = UDim2.new(1, 0, 0, 35)
    Topbar.BackgroundColor3 = Hushed.Theme.Secondary
    Topbar.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", Topbar)
    Title.Text = "  " .. Name .. " | v1"
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.TextColor3 = Hushed.Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1

    local Container = Instance.new("Frame", Main)
    Container.Position = UDim2.new(0, 130, 0, 35)
    Container.Size = UDim2.new(1, -130, 1, -35)
    Container.BackgroundTransparency = 1

    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.Size = UDim2.new(0, 130, 1, -35)
    Sidebar.BackgroundColor3 = Hushed.Theme.Secondary
    Sidebar.BorderSizePixel = 0
    
    local TabList = Instance.new("UIListLayout", Sidebar)
    TabList.Padding = UDim.new(0, 2)

    return {
        CreateTab = function(self, tabName)
            local Page = Instance.new("ScrollingFrame", Container)
            Page.Size = UDim2.new(1, 0, 1, 0)
            Page.BackgroundTransparency = 1
            Page.Visible = false
            Page.BorderSizePixel = 0
            Page.ScrollBarThickness = 2
            
            local Layout = Instance.new("UIListLayout", Page)
            Layout.Padding = UDim.new(0, 5)
            Instance.new("UIPadding", Page).PaddingLeft = UDim.new(0, 10)

            local TabBtn = Instance.new("TextButton", Sidebar)
            TabBtn.Size = UDim2.new(1, 0, 0, 30)
            TabBtn.BackgroundColor3 = Hushed.Theme.Secondary
            TabBtn.BorderSizePixel = 0
            TabBtn.Text = tabName
            TabBtn.TextColor3 = Hushed.Theme.Placeholder
            TabBtn.Font = Enum.Font.GothamMedium
            TabBtn.TextSize = 12

            TabBtn.MouseButton1Click:Connect(function()
                for _, p in pairs(Container:GetChildren()) do p.Visible = false end
                for _, b in pairs(Sidebar:GetChildren()) do 
                    if b:IsA("TextButton") then b.TextColor3 = Hushed.Theme.Placeholder end
                end
                Page.Visible = true
                TabBtn.TextColor3 = Hushed.Theme.Text
            end)

            if #Sidebar:GetChildren() == 2 then 
                Page.Visible = true 
                TabBtn.TextColor3 = Hushed.Theme.Text
            end

            return {
                CreateButton = function(self, conf)
                    local b = Instance.new("TextButton", Page)
                    b.Size = UDim2.new(0, 400, 0, 32)
                    b.BackgroundColor3 = Hushed.Theme.Secondary
                    b.Text = "  " .. conf.Name
                    b.TextColor3 = Hushed.Theme.Text
                    b.Font = Enum.Font.Gotham
                    b.TextSize = 12
                    b.TextXAlignment = Enum.TextXAlignment.Left
                    b.BorderSizePixel = 1
                    b.BorderColor3 = Hushed.Theme.Stroke
                    b.MouseButton1Click:Connect(conf.Callback)
                end,
                CreateInput = function(self, conf)
                    local f = Instance.new("Frame", Page)
                    f.Size = UDim2.new(0, 400, 0, 32)
                    f.BackgroundColor3 = Hushed.Theme.Secondary
                    f.BorderSizePixel = 1
                    f.BorderColor3 = Hushed.Theme.Stroke
                    
                    local box = Instance.new("TextBox", f)
                    box.Size = UDim2.new(1, -10, 1, 0)
                    box.Position = UDim2.new(0, 5, 0, 0)
                    box.BackgroundTransparency = 1
                    box.PlaceholderText = conf.PlaceholderText
                    box.Text = ""
                    box.TextColor3 = Hushed.Theme.Text
                    box.Font = Enum.Font.Gotham
                    box.TextSize = 12
                    box.TextXAlignment = Enum.TextXAlignment.Left
                    box.FocusLost:Connect(function(e) if e then conf.Callback(box.Text) end end)
                end,
                CreateLabel = function(self, text)
                    local l = Instance.new("TextLabel", Page)
                    l.Size = UDim2.new(0, 400, 0, 20)
                    l.BackgroundTransparency = 1
                    l.Text = text
                    l.TextColor3 = Hushed.Theme.Placeholder
                    l.Font = Enum.Font.Gotham
                    l.TextSize = 11
                    l.TextXAlignment = Enum.TextXAlignment.Left
                end
            }
        end
    }
end

function Hushed:HandleCommand(input)
    local args = string.split(input, " ")
    local cmd = string.lower(args[1])
    if cmd == "speed" then Player.Character.Humanoid.WalkSpeed = tonumber(args[2]) or 16
    elseif cmd == "fly" then if FlyEnabled then StopFly() else StartFly() end
    elseif cmd == "flyspeed" then FlySpeed = tonumber(args[2]) or 60
    elseif cmd == "jump" then Player.Character.Humanoid.JumpPower = tonumber(args[2]) or 50
    end
end

return Hushed
