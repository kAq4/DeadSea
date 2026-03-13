--// SERVICES
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// PLAYER
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// GLOBAL
getgenv().MJ = getgenv().MJ or {}

--// LOAD CORE MODULES
local Loader
local Config

pcall(function()
    Loader = require(ReplicatedStorage:WaitForChild("Core"):WaitForChild("Loader"))
    Config = require(ReplicatedStorage:WaitForChild("Core"):WaitForChild("Config"))
end)

if not Loader then
    warn("Core Loader not found")
    Loader = {LoadModules = function() return {} end}
end

if not Config then
    Config = {Save=function()end,Load=function()end}
end

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeadSeaUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

--// BLUR
local Blur = Instance.new("BlurEffect")
Blur.Size = 10
Blur.Parent = Lighting

--// WINDOW
local Window = Instance.new("Frame")
Window.Size = UDim2.new(0,650,0,420)
Window.Position = UDim2.new(0.5,-325,0.5,-210)
Window.BackgroundColor3 = Color3.fromRGB(25,25,30)
Window.BorderSizePixel = 0
Window.Parent = ScreenGui
Window.Active = true
Window.Draggable = true

--// HEADER
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1,0,0,40)
Header.BackgroundTransparency = 1
Header.Text = "DeadSea | MJ906"
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

--// TABS
local Tabs = {}
local CurrentTab

local function CreateTab(name)

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1,0,0,40)
    Button.Text = name
    Button.BackgroundColor3 = Color3.fromRGB(30,30,35)
    Button.TextColor3 = Color3.new(1,1,1)
    Button.Parent = Sidebar

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1,0,1,0)
    Frame.BackgroundTransparency = 1
    Frame.Visible = false
    Frame.Parent = Content

    Tabs[name] = Frame

    Button.MouseButton1Click:Connect(function()
        if CurrentTab then
            CurrentTab.Visible = false
        end
        Frame.Visible = true
        CurrentTab = Frame
    end)

end

--// CREATE TABS
local Categories = {"Visual","Combat","Movement","Network","Protection","Configs"}

for _,v in pairs(Categories) do
    CreateTab(v)
end

Tabs["Visual"].Visible = true
CurrentTab = Tabs["Visual"]

--// TOGGLE ELEMENT
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

--// LOAD MODULES
local Modules = Loader.LoadModules()

for _,module in pairs(Modules) do

    local tab = Tabs[module.Category]

    if tab then

        CreateToggle(tab,module.Name,function(state)

            module.Enabled = state

            if module.Toggle then
                module.Toggle(state)
            end

        end)

    end

end

--// KEYBIND
UIS.InputBegan:Connect(function(input)

    if input.KeyCode == Enum.KeyCode.N then

        Window.Visible = not Window.Visible
        Blur.Enabled = Window.Visible

    end

end)