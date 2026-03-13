local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Loader = {}

-- Try requiring Core loader if it exists
local success, CoreLoader = pcall(function()
    return require(ReplicatedStorage:WaitForChild("Core"):WaitForChild("Loader"))
end)

-- SERVER: load modules
if RunService:IsServer() and success and CoreLoader then
    Loader.modules = CoreLoader.LoadModules()
    print("[Server] Core modules loaded:")
    for name, _ in pairs(Loader.modules) do
        print("-", name)
    end
else
    Loader.modules = {}
end

-- CLIENT: load UI
if RunService:IsClient() then
    Loader.ui = {}

    local player = Players.LocalPlayer
    local playerGui = player and player:WaitForChild("PlayerGui")

    if playerGui then
        local uiFolder = ReplicatedStorage:WaitForChild("DeadSea"):WaitForChild("UI")
        for _, gui in pairs(uiFolder:GetChildren()) do
            if gui:IsA("ScreenGui") then
                local clone = gui:Clone()
                clone.Parent = playerGui
                Loader.ui[gui.Name] = clone
            end
        end
    end

    print("[Client] UI loaded:")
    for name, _ in pairs(Loader.ui) do
        print("-", name)
    end
end

return Loader