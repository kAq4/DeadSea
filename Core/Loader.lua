local Loader = {}
Loader.modules = {}

-- Load all ModuleScripts inside ReplicatedStorage.DeadSea.Modules
function Loader.LoadModules()
    local folder = game:GetService("ReplicatedStorage"):WaitForChild("DeadSea"):WaitForChild("Modules")
    
    for _, category in pairs(folder:GetChildren()) do
        for _, module in pairs(category:GetChildren()) do
            if module:IsA("ModuleScript") then
                local data = require(module)
                -- store modules by name for easy access
                Loader.modules[module.Name] = data
            end
        end
    end
    
    return Loader.modules
end

-- Reload a specific module (useful during development)
function Loader.ReloadModule(moduleName)
    local folder = game:GetService("ReplicatedStorage"):WaitForChild("DeadSea"):WaitForChild("Modules")
    for _, category in pairs(folder:GetChildren()) do
        for _, module in pairs(category:GetChildren()) do
            if module:IsA("ModuleScript") and module.Name == moduleName then
                Loader.modules[module.Name] = require(module)
                return Loader.modules[module.Name]
            end
        end
    end
    return nil
end

-- Optional: allow clearing all loaded modules
function Loader.ClearModules()
    Loader.modules = {}
end

return Loader