local Loader = {}

function Loader.LoadModules()

    local modules = {}

    local folder = game.ReplicatedStorage.DeadSea.Modules

    for _,category in pairs(folder:GetChildren()) do
        for _,module in pairs(category:GetChildren()) do

            if module:IsA("ModuleScript") then
                local data = require(module)
                table.insert(modules,data)
            end

        end
    end

    return modules

end

return Loader