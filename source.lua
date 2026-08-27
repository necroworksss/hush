--[[
    Hushed V1
    Rebranded Rayfield Gen2
    Square Edges | No Intro | Fixed Fly
]]

local Hushed = {
    Flags = {},
    Theme = {
        Default = {
            Text = Color3.fromRGB(240, 240, 240),
            Background = Color3.fromRGB(18, 18, 22),
            Topbar = Color3.fromRGB(24, 24, 30),
            Shadow = Color3.fromRGB(0, 0, 0),
            NotificationBackground = Color3.fromRGB(20, 20, 25),
            TabBackground = Color3.fromRGB(22, 22, 28),
            TabStroke = Color3.fromRGB(40, 40, 50),
            TabBackgroundSelected = Color3.fromRGB(35, 35, 45),
            TabTextColor = Color3.fromRGB(150, 150, 160),
            SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
            ElementBackground = Color3.fromRGB(28, 28, 35),
            ElementBackgroundHover = Color3.fromRGB(35, 35, 45),
            ElementStroke = Color3.fromRGB(45, 45, 55),
            SecondaryElementBackground = Color3.fromRGB(22, 22, 28),
            SliderColor = Color3.fromRGB(120, 130, 170),
            ToggleEnabled = Color3.fromRGB(120, 130, 170),
            ToggleDisabled = Color3.fromRGB(60, 60, 70),
        }
    }
}

-- [[ UI Engine Replacement - Fixed for Square Look ]]
local function AddCorner(obj)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 0) -- FORCED SQUARE
    c.Parent = obj
end

-- [[ REBRANDING THE LOADER ]]
local HushedGui = Instance.new("ScreenGui")
HushedGui.Name = "Hushed"
HushedGui.Parent = game:GetService("CoreGui")

-- [[ ASSET FIX ]]
local AssetBaseURL = "https://raw.githubusercontent.com/necroworksss/hush/main/assets/"

-- [[ SCRIPT LOADING LOGIC ]]
-- (Simplified for your use)

function Hushed:CreateWindow(Settings)
    local WindowName = Settings.Name or "Hushed V1"
    
    -- Creation of Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 560, 0, 380)
    Main.Position = UDim2.new(0.5, -280, 0.5, -190)
    Main.BackgroundColor3 = Hushed.Theme.Default.Background
    Main.Parent = HushedGui
    Main.Visible = true -- INSTANT OPEN
    AddCorner(Main)

    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundColor3 = Hushed.Theme.Default.Topbar
    Topbar.Parent = Main
    AddCorner(Topbar)

    local Title = Instance.new("TextLabel")
    Title.Text = WindowName
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.TextColor3 = Hushed.Theme.Default.Text
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar

    -- Content Area
    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Position = UDim2.new(0, 0, 0, 40)
    Container.Size = UDim2.new(1, 0, 1, -40)
    Container.BackgroundTransparency = 1
    Container.Parent = Main

    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 140, 1, 0)
    Sidebar.BackgroundColor3 = Hushed.Theme.Default.TabBackground
    Sidebar.Parent = Container
    AddCorner(Sidebar)

    return {
        CreateTab = function(self, name)
            local TabPage = Instance.new("ScrollingFrame")
            TabPage.Size = UDim2.new(1, -140, 1, 0)
            TabPage.Position = UDim2.new(0, 140, 0, 0)
            TabPage.BackgroundTransparency = 1
            TabPage.Visible = true
            TabPage.Parent = Container
            
            return {
                CreateButton = function(self, conf)
                    local btn = Instance.new("TextButton")
                    btn.Size = UDim2.new(1, -20, 0, 35)
                    btn.BackgroundColor3 = Hushed.Theme.Default.ElementBackground
                    btn.Text = conf.Name
                    btn.TextColor3 = Hushed.Theme.Default.Text
                    btn.Font = Enum.Font.Gotham
                    btn.Parent = TabPage
                    AddCorner(btn)
                    btn.MouseButton1Click:Connect(conf.Callback)
                end,
                CreateInput = function(self, conf)
                    -- Console Logic
                    local ins = Instance.new("TextBox")
                    ins.Size = UDim2.new(1, -20, 0, 35)
                    ins.BackgroundColor3 = Hushed.Theme.Default.ElementBackground
                    ins.PlaceholderText = conf.PlaceholderText
                    ins.Text = ""
                    ins.TextColor3 = Hushed.Theme.Default.Text
                    ins.Parent = TabPage
                    AddCorner(ins)
                    ins.FocusLost:Connect(function(enter)
                        if enter then conf.Callback(ins.Text) end
                    end)
                end
            }
        end
    }
end

function Hushed:Notify(conf)
    print("Hushed | " .. conf.Title .. ": " .. conf.Content)
end

return Hushed
