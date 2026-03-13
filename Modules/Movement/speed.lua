local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

getgenv().MJ = getgenv().MJ or {}

MJ.Speed = false
MJ.WalkSpeed = 16

RunService.Heartbeat:Connect(function()

    if not MJ.Speed then return end

    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if hrp and hum then

        local moveDir = hum.MoveDirection

        if moveDir.Magnitude > 0 then

            local vel = hrp.Velocity

            hrp.Velocity = Vector3.new(
                moveDir.X * MJ.WalkSpeed,
                vel.Y,
                moveDir.Z * MJ.WalkSpeed
            )

        end
    end

end)

return {
    Name = "Speed",
    Category = "Movement",
    Enabled = false,

    Toggle = function(state)
        MJ.Speed = state
    end,

    Slider = {
        Name = "WalkSpeed",
        Min = 16,
        Max = 200,
        Increment = 2,
        Default = 16,

        Callback = function(v)
            MJ.WalkSpeed = v
        end
    }
}