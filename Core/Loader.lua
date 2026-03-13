-- Core/Loader.lua
local Loader = {}
Loader.modules = {}

function Loader.LoadModules()
    local folder = game.ReplicatedStorage:WaitForChild("DeadSea"):WaitForChild("Modules")
    
    for _, category in pairs(folder:GetChildren()) do
        for _, module in pairs(category:GetChildren()) do
            if module:IsA("ModuleScript") then
                local data = require(module)
                -- store by module name for easier access
                Loader.modules[module.Name] = data
            end
        end
    end
    
    return Loader.modules
end

-- Optional: reload a specific module (useful for dev)
function Loader.ReloadModule(moduleName)
    local folder = game.ReplicatedStorage:WaitForChild("DeadSea"):WaitForChild("Modules")
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

return Loader