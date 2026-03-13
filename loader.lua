local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Loader = {}

-- Require the Core loader
local CoreLoader = require(ReplicatedStorage:WaitForChild("Core"):WaitForChild("Loader"))

-- Load all modules from Core
Loader.modules = CoreLoader.LoadModules()

print("Core modules loaded:")
for name, _ in pairs(Loader.modules) do
    print("-", name)
end

-- Optional: load UI from ReplicatedStorage.DeadSea.UI
Loader.ui = {}
local uiFolder = ReplicatedStorage:WaitForChild("DeadSea"):WaitForChild("UI")
for _, gui in pairs(uiFolder:GetChildren()) do
    if gui:IsA("ScreenGui") then
        local clone = gui:Clone()
        clone.Parent = Players.LocalPlayer and Players.LocalPlayer:WaitForChild("PlayerGui") or nil
        Loader.ui[gui.Name] = clone
    end
end

print("UI loaded:")
for name, _ in pairs(Loader.ui) do
    print("-", name)
end

return Loader