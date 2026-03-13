local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

getgenv().MJ = getgenv().MJ or {}

MJ.Godmode = false

RunService.Heartbeat:Connect(function()

    if not MJ.Godmode then return end

    local char = LocalPlayer.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")

    if hum and hum.Health < hum.MaxHealth then
        hum.Health = hum.MaxHealth
    end

end)

return {
    Name = "Godmode",
    Category = "Protection",
    Enabled = false,

    Toggle = function(state)
        MJ.Godmode = state
    end
}