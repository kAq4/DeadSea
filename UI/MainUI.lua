--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// GLOBAL
getgenv().MJ = getgenv().MJ or {}

--// LOAD CORE
local Loader, Config = nil, nil
local success, err = pcall(function()
    Loader = require(ReplicatedStorage:WaitForChild("Core"):WaitForChild("Loader"))
    Config = require(ReplicatedStorage:WaitForChild("Core"):WaitForChild("Config"))
end)

if not success then
    warn("Failed to load Core modules:", err)
    Loader = { LoadModules = function() return {} end } -- fallback
    Config = { Save = function() end, Load = function() end }
end

--// PLAYER
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then return end

--// GUI ROOT
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeadSeaUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

--// BLUR
local Blur = Instance.new("BlurEffect")
Blur.Size = 10
Blur.Parent = Lighting

--// MAIN WINDOW
local Window = Instance.new("Frame")
Window.Size = UDim2.new(0,650,0,420)
Window.Position = UDim2.new(0.5,-325,0.5,-210)
Window.BackgroundColor3 = Color3.fromRGB(25,25,30)
Window.BorderSizePixel = 0
Window.Active = true
Window.Draggable = true
Window.Parent = ScreenGui

--// HEADER
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1,0,0,40)
Header.BackgroundTransparency = 1
Header.Text = "DeadSea | By MJ906 Team"
Header.Font = Enum.Font.GothamBold
Header.TextColor3 = Color3.new(1,1,1)
Header.TextSize = 18
Header.Parent = Window

--// SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,140,1,-40)
Sidebar.Position = UDim2.new(0,0,0,40)
Sidebar.BackgroundColor3 = Color3.fromRGB(20,20,25)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Window

--// CONTENT
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-140,1,-40)
Content.Position = UDim2.new(0,140,0,40)
Content.BackgroundTransparency = 1
Content.Parent = Window

--// TAB SYSTEM
local Tabs = {}
local CurrentTab = nil
local function CreateTab(name)
    -- sidebar button
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1,0,0,40)
    Button.Text = name
    Button.BackgroundColor3 = Color3.fromRGB(30,30,35)
    Button.TextColor3 = Color3.new(1,1,1)
    Button.Font = Enum.Font.Gotham
    Button.TextSize = 14
    Button.Parent = Sidebar

    -- tab frame
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1,0,1,0)
    Frame.BackgroundTransparency = 1
    Frame.Visible = false
    Frame.Parent = Content

    Tabs[name] = Frame

    Button.MouseButton1Click:Connect(function()
        if CurrentTab then CurrentTab.Visible = false end
        Frame.Visible = true
        CurrentTab = Frame
    end)
end

--// CREATE DEFAULT TABS
local Categories = {"Visual","Combat","Movement","Network","Protection","Configs"}
for _,v in pairs(Categories) do
    CreateTab(v)
end
Tabs["Visual"].Visible = true
CurrentTab = Tabs["Visual"]

--// UI ELEMENTS
local function CreateToggle(parent,name,callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(0,180,0,35)
    Toggle.Text = name.." : OFF"
    Toggle.BackgroundColor3 = Color3.fromRGB(40,40,50)
    Toggle.TextColor3 = Color3.new(1,1,1)
    Toggle.Parent = parent

    local state = false
    Toggle.MouseButton1Click:Connect(function()
        state = not state
        Toggle.Text = name.." : "..(state and "ON" or "OFF")
        callback(state)
    end)
end

local function CreateSlider(parent,name,min,max,default,callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0,200,0,40)
    Frame.BackgroundColor3 = Color3.fromRGB(40,40,50)
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1,0,0,20)
    Label.Text = name.." : "..default
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.new(1,1,1)
    Label.Parent = Frame

    local Slider = Instance.new("TextButton")
    Slider.Size = UDim2.new(1,0,0,20)
    Slider.Position = UDim2.new(0,0,0,20)
    Slider.Text = ""
    Slider.BackgroundColor3 = Color3.fromRGB(70,70,80)
    Slider.Parent = Frame

    local value = default
    Slider.MouseButton1Click:Connect(function()
        value = math.clamp(value + 1, min, max)
        Label.Text = name.." : "..value
        callback(value)
    end)
end

--// LOAD MODULES
local Modules = Loader.LoadModules()
for _,module in pairs(Modules) do
    local tab = Tabs[module.Category]
    if tab then
        CreateToggle(tab,module.Name,function(state)
            module.Enabled = state
            if module.Toggle then module.Toggle(state) end
        end)

        if module.Slider then
            CreateSlider(
                tab,
                module.Slider.Name,
                module.Slider.Min,
                module.Slider.Max,
                module.Slider.Default,
                module.Slider.Callback
            )
        end
    end
end

--// CONFIG TAB
local ConfigTab = Tabs["Configs"]
local Save = Instance.new("TextButton")
Save.Size = UDim2.new(0,180,0,40)
Save.Text = "Save Config"
Save.BackgroundColor3 = Color3.fromRGB(50,120,80)
Save.TextColor3 = Color3.new(1,1,1)
Save.Parent = ConfigTab
Save.MouseButton1Click:Connect(function() Config.Save("default") end)

local Load = Instance.new("TextButton")
Load.Size = UDim2.new(0,180,0,40)
Load.Position = UDim2.new(0,0,0,50)
Load.Text = "Load Config"
Load.BackgroundColor3 = Color3.fromRGB(80,80,120)
Load.TextColor3 = Color3.new(1,1,1)
Load.Parent = ConfigTab
Load.MouseButton1Click:Connect(function() Config.Load("default") end)

--// TOGGLE GUI WITH KEY
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.N then
        Window.Visible = not Window.Visible
        Blur.Enabled = Window.Visible
    end
end)