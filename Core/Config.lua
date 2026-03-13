local HttpService = game:GetService("HttpService")

local Config = {}

local folder = "DeadSeaConfigs"

if not isfolder(folder) then
    makefolder(folder)
end

function Config.Save(name)

    if not name then
        name = "default"
    end

    local data = HttpService:JSONEncode(getgenv().MJ)

    writefile(folder.."/"..name..".json", data)

end

function Config.Load(name)

    if not name then
        name = "default"
    end

    local path = folder.."/"..name..".json"

    if not isfile(path) then
        warn("Config not found")
        return
    end

    local data = readfile(path)

    local decoded = HttpService:JSONDecode(data)

    for k,v in pairs(decoded) do
        getgenv().MJ[k] = v
    end

end

function Config.List()

    return listfiles(folder)

end

return Config