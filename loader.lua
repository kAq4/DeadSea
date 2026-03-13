-- DeadSea/Loader.lua
local Loader = {}
Loader.Modules = {}
Loader.UI = {}

-- Load all ModuleScripts from Modules folder
function Loader.LoadModules()
    local folder = game:GetService("ReplicatedStorage"):WaitForChild("DeadSea"):WaitForChild("Modules")

    for _, category in pairs(folder:GetChildren()) do
        for _, module in pairs(category:GetChildren()) do
            if module:IsA("ModuleScript") then
                Loader.Modules[module.Name] = require(module)
            end
        end
    end

    return Loader.Modules
end

-- Reload a specific module (optional, useful for dev)
function Loader.ReloadModule(moduleName)
    local folder = game:GetService("ReplicatedStorage"):WaitForChild("DeadSea"):WaitForChild("Modules")
    for _, category in pairs(folder:GetChildren()) do
        for _, module in pairs(category:GetChildren()) do
            if module:IsA("ModuleScript") and module.Name == moduleName then
                Loader.Modules[module.Name] = require(module)
                return Loader.Modules[module.Name]
            end
        end
    end
    return nil
end

-- Load all UI scripts from UI folder
function Loader.LoadUI()
    local folder = game:GetService("ReplicatedStorage"):WaitForChild("DeadSea"):WaitForChild("UI")

    for _, uiElement in pairs(folder:GetChildren()) do
        if uiElement:IsA("ScreenGui") then
            Loader.UI[uiElement.Name] = uiElement:Clone()
        end
    end

    return Loader.UI
end

-- Reload a specific UI script
function Loader.ReloadUI(uiName)
    local folder = game:GetService("ReplicatedStorage"):WaitForChild("DeadSea"):WaitForChild("UI")
    local uiElement = folder:FindFirstChild(uiName)
    if uiElement and uiElement:IsA("ScreenGui") then
        Loader.UI[uiName] = uiElement:Clone()
        return Loader.UI[uiName]
    end
    return nil
end

return Loader