local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

getgenv().MJ = getgenv().MJ or {}
MJ.AntiFling = true

local lastSafeXZ = nil
local flingCooldown = false

RunService.Heartbeat:Connect(function()

    if not MJ.AntiFling then return end

    local char = LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local velocity = hrp.AssemblyLinearVelocity.Magnitude

    if velocity < 60 then
        local pos = hrp.Position
        lastSafeXZ = Vector3.new(pos.X,0,pos.Z)
    end

    if velocity > 120 and not flingCooldown then

        flingCooldown = true

        hrp.Anchored = true
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero

        task.wait(0.25)

        if lastSafeXZ then
            local current = hrp.Position
            hrp.CFrame = CFrame.new(
                lastSafeXZ.X,
                current.Y,
                lastSafeXZ.Z
            )
        end

        task.wait(0.15)

        hrp.Anchored = false

        task.wait(1)
        flingCooldown = false
    end

end)

return {
    Name = "Anti Fling",
    Category = "Protection",
    Enabled = true,

    Toggle = function(state)
        MJ.AntiFling = state
    end
}